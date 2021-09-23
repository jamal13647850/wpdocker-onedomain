#!/bin/bash


echo "Set the domain for this project"

echo "New domain:(eg newdomain.com)"
read replacement
echo "Replacing all occurences of $existing with $replacement in files matching $filepattern"

#find . -name '*.conf' -o -name '*.yml' -print0 | xargs -0 sed -i '' -e "s/$existing/$replacement/g"

for filename in `find . -name '*.conf' -o -name '*.yml'`; do
  sed -i "s/example.com/$replacement/g" $filename
done

echo "Your email for letsencrypt:"
read email
for filename in `find . -name '*.conf' -o -name '*.yml'`; do
  sed -i "s/yourmail@gmail.com/$email/g" $filename
done
