% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract_ABS_data.R
\name{extract_ABS_data}
\alias{extract_ABS_data}
\title{extract ABS data from ONS working file spreadsheet}
\usage{
extract_ABS_data(x, sheet_name = "New ABS Data", ...)
}
\arguments{
\item{x}{Location of the input spreadsheet file. Named something like
"working_file_dcms_VXX.xlsm".}

\item{sheet_name}{The name of the spreadsheet in which the data are stored.
Defaults to \code{New ABS Data}.}

\item{...}{passes arguments to \code{readxl::read_excel()} which is the basis
of this function.}
}
\value{
The function returns nothing, but saves the extracted dataset to
  \code{file.path(output_path, 'OFFICIAL_ABS.Rds')}. This is an R data
  object, which retains the column types which would be lost if converted to
  a flat format like CSV.
}
\description{
The data which underlies the Economic Sectors for DCMS sectors
  data is typically provided to DCMS as a spreadsheet from the Office for
  National Statistics. This function extracts the ABS data from that
  spreadsheet, and saves it to .Rds format.

  IT IS HIGHLY ADVISEABLE TO ENSURE THAT THE DATA WHICH ARE CREATED BY THIS
  FUNCTION ARE NOT STORED IN A FOLDER WHICH IS A GITHUB REPOSITORY TO
  MITIGATE AGAINST ACCIDENTAL COMMITTING OF OFFICIAL DATA TO GITHUB. TOOLS TO
  FURTHER HELP MITIGATE THIS RISK ARE AVAILABLE AT
  https://github.com/ukgovdatascience/dotfiles.
}
\details{
The best way to understand what happens when you run this function
  is to look at the source code, which is available at
  \url{https://github.com/ukgovdatascience/eesectors/blob/master/R/}. The
  code is relatively transparent and well documented. A brief explanation of
  what the function does here:

  1. The function calls \code{readxl::read_excel} to load the appropriate
  page from the underlying spreadsheet.

  2. In the 2016 version of the working file spreadhseet, there were a number
  of replicated columns. These are removed, however it is at present a
  relatively dumb exercise. The function simply looks for columns with teh
  same name, and retains only the first one.

  3. The column names are cleaned to make selection of variables easier using
  \code{make.names}.

  4. The data are pivoted into long form using \code{tidyr::gather_}. This
  converts the data from a wide dataframe with year as column headers, into a
  long dataframe with year included in a year column. This makes the data
  much easier to subset.

  5. All the ABS values are combined into a column called \code{ABS}. In the
  2016 spreadsheet there were a number of full stops (\code{.}) in the
  \code{ABS} column, which will be coerced to \code{NA} when the the column
  is converted to numeric using \code{as.numeric} (the next step). The
  internal function \code{eesectors::integrity_check} runs a quick check to
  make sure that the only NAs creeping into the \code{ABS} column are from
  full stops in the original data. The full stops are then converted to
  zeros.

  6. The internal function \code{eesectors::clean_sic} is run on the
  \code{DOMVAL} column to ensure that all 3 and 4 digit SIC codes are
  formatted properly.

  7. The data are printed to console, and can be saved out using the normal
  methods, for instance \code{saveRDS}, or \code{write.csv}.
}
\examples{

\dontrun{
library(eesectors)
extract_ABS_data(
x = 'OFFICIAL_working_file_dcms_V13.xlsm',
sheet_name = 'New ABS Data'
)
}

}
