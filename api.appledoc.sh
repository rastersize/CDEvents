#!/bin/sh

##
# USAGE
# ./api.appledoc.sh [version-string]
#
# Execute it from the root of the CDEvents project.


PROJECT_VERSION="HEAD"
if [ "$#" -gt "0" ]
then
	PROJECT_VERSION=$1
fi

API_DOCS_DIR="./api/appledoc"
#HEADER_FILES=`find . -name '*.h'`
HEADER_FILES=`ls *.h`


echo "API documentation generator for CDEvents v1"
echo "Will save generated documentation to \"${API_DOCS_DIR}\""
echo "Removing old API documentation"
rm -r $API_DOCS_DIR/html 2> /dev/null
rm -r $API_DOCS_DIR/docset 2> /dev/null

echo "Will generate API documentation based on:"
echo ${HEADER_FILES}

echo "Generating for version \"${PROJECT_VERSION}\"..."
appledoc \
  --output ${API_DOCS_DIR} \
  --project-name "CDEvents" \
  --project-version ${PROJECT_VERSION} \
  --project-company "Aron Cedercrantz" \
  --company-id "com.cedercrantz" \
  --create-html \
  --keep-intermediate-files \
  --no-install-docset \
  ${HEADER_FILES}
echo "Done!"

echo "You can open the HTML documentation with:"
echo "\"open ${API_DOCS_DIR}/html/index.html\""

