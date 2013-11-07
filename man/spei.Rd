\name{Drought indices}

\alias{spei}
\alias{spi}

\title{Calculation of the Standardized Precipitation-Evapotranspiration Index (SPEI) and the Standardized Precipitation Index (SPI).}

\description{Given a time series of the climatic water balance (precipitation minus potential evapotranspiration), gives a time series of the Standardized Precipitation-Evapotranspiration Index (SPEI).}

\usage{
spei(data, scale, kernel = list(type = 'rectangular', shift = 0),
	distribution = 'log-Logistic', fit = 'ub-pwm', na.rm = FALSE,
	ref.start=NULL, ref.end=NULL, x=FALSE, params=NULL, ...)

spi(data, scale, kernel = list(type = 'rectangular', shift = 0),
	distribution = 'Gamma', fit = 'ub-pwm', na.rm = FALSE,
	ref.start=NULL, ref.end=NULL, x=FALSE, params=NULL, ...)
}

\arguments{
  \item{data}{ a vector, matrix or data frame with time ordered values of precipitation (for the SPI) or of the climatic balance precipitation minus potential evapotranspiration (for the SPEI).}
  \item{scale}{ an integer, representing the time scale at which the SPEI / SPI will be computed.}
  \item{kernel}{ optional, a list defining the type of kernel used for computing the SPEI / SPI at scales higher than one. Defaults to unshifted rectangular kernel.}
  \item{distribution}{ optional, name of the distribution function to be used for computing the SPEI / SPI (one of 'log-Logistic', 'Gamma' and 'PearsonIII'). Defaults to 'log-Logistic' for \code{spei}, and to 'Gamma' for \code{spi}.}
  \item{fit}{ optional, name of the method used for computing the distribution function parameters (one of 'ub-pwm', 'pp-pwm' and 'max-lik'). Defaults to 'ub-pwm'.}
  \item{na.rm}{ optional, a logical value indicating whether NA values should be stripped from the computations. Defaults to FALSE, i.e. no NA are allowed in the data.}
  \item{ref.start}{ optional, starting point of the reference period used for computing the index. Defaults to NULL, indicating that the first value in data will be used as starting point.}
  \item{ref.end}{ optional, ending point of the reference period used for computing the index. Defaults to NULL, indicating that the last value in data will be used as ending point.}
  \item{x}{ optional, a logical value indicating wether the data used for fitting the model should be kept. Defaults to FALSE.}
  \item{params}{ optional, an array of parameters for computing the spei. This option overrides computation of fitting parameters.}
  \item{...}{ other possible parameters.}
}

\details{

The \code{spei} and \code{spi} functions allow computing the SPEI and the SPI indices. These are climatic proxies widely used for drought quantification and monitoring. Both functions are identical (in fact, \code{spi} is just a wrapper for \code{spei}), but they are kept separated for clarity. Basically, the functions standardize a variable following a log-Logistic (or Gamma, or PearsonIII) distribution function (i.e., they transform it to a standard Gaussian variate with zero mean and standard deviation of one).

\subsection{Input data}{
The input variable is a time ordered series of precipitation values for \code{spi}, or a series of the climatic water balance (precipitation minus potential evapotranspiration) for \code{spei}. When used with the default options, it would yield values of both indices exactly as defined in the references given below.

The SPEI and the SPI were defined for monthly data. Since the PDFs of the data are not homogenous from month to month, the data is split into twelve series (one for each month) and independent PDFs are fit to each series. If \code{data} is a vector or a matrix it will be treated as a sequence of monthly values starting in January. If it is a (univariate or multivariate) time series then the function \code{\link{cycle}} will be used to determine the position of each observation within the year (month), allowing the data to start in a month other than January.
}

\subsection{Time scales}{
An important advantage of the SPEI and the SPI is that they can be computed at different time scales. This way it is possible to incorporate the influence of the past values of the variable in the computation enabling the index to adapt to the memory of the system under study. The magnitude of this memory is controlled by parameter \code{scale}. For example, a value of six would imply that data from the current month and of the past five months will be used for computing the SPEI or SPI value for a given month. By default all past data will have the same weight in computing the index, as it was originally proposed in the references below. Other kernels, however, are available through parameter \code{kernel}. The parameter \code{kernel} is a list defining the shape of the kernel and a time shift. These parameters are then passed to the function \code{\link{kern}}.
}

\subsection{Probability distributions}{
Following the original definitions \code{spei} uses a log-Logistic distribution by default, and \code{spi} uses a Gamma distribution. This behaviour can be modified, however, through parameter \code{distribution}.
}

\subsection{Fitting methods}{
The default method for parameter fitting is based on unbiased Probability Weighted Moments ('ub-pwm'), but other methods can be used through parameter \code{fit}. A valid alternative is the plotting-position PWM ('pp-pwm') method. For the log-Logistic distribution, also the maximum likelihood method ('max-lik') is available.
}

\subsection{User-provided parameters}{
An option exists to override parameter fitting and provide user default parameters. This is activated with the parameter \code{params}. The exact values provided tothis parameter depend on the distribution function being used. For log-Logistic and PearsonII it should be a three-dimensional array with dimensions (3,number of series in data,12), containing twelve parameter triads (xi, alpha, kappa) for each data series, one for each month. For Gamma, a three-dimensional array with dimensions (2,number of series in data,12), containing twelve parameter pairs (alpha, beta). It is a good idea to look at the coefficients slot of a previously fit \code{spei} spei object in order to understand the structure of the parameter array. The parameter \code{distribution} is still used under this option in order to know what distribution function should be used.
}

\subsection{Reference period}{
The default behaviour of the functions is using all the values provided in \code{data} for parameter fitting. However, this can be modified with help of parameters \code{ref.start} and \code{ref.end}. These parameters allow defining a subset of values that will be used for parameter fitting, i.e. a reference period. The functions, however, will compute the values of the indices for the whole data set. For these options to work it is necessary that \code{data} will be a time series object. The starting and ending points of the reference period will then be defined as pairs of year and month values, e.g. c(1900,1).
}

\subsection{Processing large datasets}{
It is possible to use the \code{spei} and \code{spi} functions for processing multivariate datasets at once. If a matrix or data frame is supplied as \code{data}, with time series of precipitation or precipitation minus potential evapotranspiration arranged in columns, the result would be a matrix (data frame) of spi or spei series. This makes processing large datasets extremely easy, since no loops need to be used.
}

}

\value{
Functions \code{spei} and \code{spi} return an object of class \code{spei}. The generic functions \code{print} and \code{summary} can be used to obtain summaries of the results. The generic accessor functions \code{coefficients} and \code{fitted} extract useful features of the object.

An object of class \code{spei} is a list containing at least the following components:

call: the call to \code{spei} or \code{spi} used to generate the object.

fitted: time series with the values of the Standardized Precipitation-Evapotranspiration Index (SPEI) or the Standardized Precipitation Index (SPI). If data consists of several columns the function will treat each column as independent data, and the result will be a multivariate time series. The names of the columns in \code{data} will be used as column names in fitted.

coefficients: an array with the values of the coefficients of the distribution function fitted to the data. The first dimension of the array contains the three (or two) coefficients, the second dimension will typically consist of twelve values corresponding to each month, and the third dimension will be equal to the number of columns (series) in \code{data}. If a time scale greater than one has been used then the first elements will have NA value since the kernel can not be applied. The first element with valid data will be the one corresponding to the time scale chosen.

scale: the \code{scale} parameter used to generate the object.

kernel: the parameters and values of the kernel used to generate the object.

distribution: the distribution function used to generate the object.

fit: the fitting method used to generate the object.

na.action: the value of the na.action parameter used.

data: if requested, the input data used.
}

\references{
S.M. Vicente-Serrano, S. Beguería, J.I. López-Moreno. 2010. A Multi-scalar drought index sensitive to global warming: The Standardized Precipitation Evapotranspiration Index – SPEI. \emph{Journal of Climate} \bold{23}: 1696, DOI: 10.1175/2009JCLI2909.1.

\url{http://sac.csic.es/spei/}
}

\author{
Santiago Beguería and Sergio M. Vicente-Serrano. Maintainer: Santiago Beguería.
}

\note{Dependencies: the spei function depends on the library \code{lmomco}.}

\seealso{\code{\link{kern}} for different kernel functions available. \code{\link{thornthwaite}}, \code{\link{hargreaves}} and \code{\link{penman}} for ways of calculating potential evapotranspiration. \code{\link{summary.spei}} and \code{\link{print.spei}} for summaries of \code{spei} objects. \code{\link{plot.spei}} for plotting \code{spei} objects.}

\examples{
# Load data
data(wichita)

# One and tvelwe-months SPEI
wichita$PET <- thornthwaite(wichita$TMED,37.6475)
spei1 <- spei(wichita$PRCP-wichita$PET,1)
spei12 <- spei(wichita$PRCP-wichita$PET,12)

# Extract information from spei object
summary(spei1)
names(spei1)
spei1$call
spei1$fitted
spei1$coefficients

# Plot spei object
par(mfrow=c(2,1))
plot(spei1)
plot(spei12,'Wichita')

# One and tvelwe-months SPI
spi_1 <- spi(wichita$PRCP,1)
spi_12 <- spi(wichita$PRCP,12)
par(mfrow=c(2,1))
plot(spi_1)
plot(spi_12)

# Define the properties of the time series with ts()
plot(spei(ts(wichita$PRCP-wichita$PET,freq=12,start=c(1980,1)),12))

# Time series not starting in January
plot(spei(ts(wichita$PRCP-wichita$PET,freq=12,start=c(1980,6)),12))

# Using a particular reference period
plot(spei(ts(wichita$PRCP-wichita$PET,freq=12,start=c(1980,1)),12,
	ref.start=c(1980,1), ref.end=c(2000,1)))

# Using different kernels
spei24 <- spei(wichita$PRCP-wichita$PET,24)
spei24_gau <- spei(wichita$PRCP-wichita$PET,24,kernel=list(type='gaussian',shift=0))
par(mfrow=c(2,1))
plot(spei24,'Rectangular kernel')
plot(spei24_gau,'Gaussian kernel')

# Computing several time series at a time
data(balance)
names(balance)
bal_spei12 <- spei(balance,12)
plot(bal_spei12)

# User provided parameters
coe <- spei1$coefficients
dim(coe)
spei(wichita$PRCP-wichita$PET,1,params=coe)
}

%\keyword{}
%\keyword{}