#! /bin/sh

modssl_clean_hashes()
{
	find -maxdepth 1 -type l -name '[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f].[0-9]*' -exec rm -f {} \;
	find -maxdepth 1 -type l -name '[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f].r[0-9]*' -exec rm -f {} \;
}

modssl_update_hashes()
{
	for file in `find . -type f -name \*.crt`; do
		if [ -n "`grep SKIPME $file`" ]; then
			echo "$file ... Skipped"
		else
			hash="`openssl x509 -noout -hash < $file`"
			n=0
			while [ -r "$hash.$n" ]; do
				n=$(( $n + 1 ))
			done

			echo "$file ... $hash.$n"
			ln -s $file $hash.$n
		fi
	done

	for file in `find . -type f -name \*.crl`; do
		if [ -n "`grep SKIPME $file`" ]; then
			echo "$file ... Skipped"
		else
			hash="`openssl crl -noout -hash < $file`"
			n=0
			while [ -r "$hash.r$n" ]; do
				n=$(( $n + 1 ))
			done

			echo "$file ... $hash.r$n"
			ln -s $file $hash.r$n
		fi
	done
}
