Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47684 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S934983AbcJHGKK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 8 Oct 2016 02:10:10 -0400
Date: Sat, 8 Oct 2016 02:10:08 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>
Subject: Re: btrfs rare silent data corruption with kernel data leak (updated
 with some bisection results)
Message-ID: <20161008061008.GT21290@hungrycats.org>
References: <20160921045556.GN21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mgIE+9cwyCTt+85Z"
In-Reply-To: <20160921045556.GN21290@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mgIE+9cwyCTt+85Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

(continuing from https://www.spinics.net/lists/linux-btrfs/msg59251.html)

I'm still poking at this bug, and found out some more about it.
Recall that this bug seems to have two parts which together cause data
corruption:

The "write half" of the bug writes a questionable extent structure in
the filesystem once every few hundred thousand files (a compressed inline
extent followed by other non-inline extents when a write occurs at
the beginning of a file, followed by a seek past the end of the first
page of the file, followed by another write).

The "read half" of the bug reads this structure inconsistently (data
between the inline extent and the following extent is random garbage,
different each time the file is read).

After having no success attacking the read half of the bug with a patch,
I tried to bisect to see where the bug was introduced.

The "write half" of the bug seems to appear first somewhere between v3.8
and v3.9.  I have not been able to reproduce it with v3.8.13, v3.7.10, or
v3.6.11.  I can reproduce it in v3.9.11, v3.12.64, and v3.18.13..v4.7.5.

The "read half" of the bug is more interesting.  All kernels I've tested
that have the write half of the bug have the read half as well, but
versions 3.6..3.9 have many more instances of a separate non-repeatable
read corruption (one that does not require the "write half" bug to occur).
These additional bugs were not anticipated by my bisection test case,
so my bisect went in the wrong direction and I didn't cover the right
kernels to understand where these bugs were introduced (yet).

The good news is that whatever went wrong around 3.6..3.9 seems to have
been fixed by v3.12--that kernel has the same behavior as v4.7.5 for
data corruption on reads.


This is my current repro script.  Run it in a shell loop until corruption
occurs, e.g. "while repro; do date; done".  Adjust the "result" function
to taste (e.g. write it to a file, use your own email address, etc).

#!/bin/sh
set -x

result () {
	echo "$@" "$(cat /proc/version)" | mail -s "$(echo "$@" | head -1) $(uname -r)" results@localhost
}

umount /try
mkdir -p /try
for blk in /dev/vdc /dev/sdc; do
	< "$blk" || continue
	mkfs.btrfs -dsingle -mdup -O ^extref,^skinny-metadata,^no-holes -f "$blk" || exit 1
	mount -ocompress-force,flushoncommit,max_inline=4096,noatime "$blk" /try || exit 1
	cd /try || exit 1
	break
done

# Must be on btrfs
btrfs sub list . || exit 1

y=/usr; for x in $(seq 0 9); do rsync -axHSWI "$y/." "$x"; y="$x"; done &
y=/usr; for x in $(seq 10 19); do rsync -axHSWI "$y/." "$x"; y="$x"; done &
y=/usr; for x in $(seq 20 29); do rsync -axHSWI "$y/." "$x"; y="$x"; done &
y=/usr; for x in $(seq 30 39); do rsync -axHSWI "$y/." "$x"; y="$x"; done &

wait

touch list

find -type f -size +4097c -exec sh -c 'for x; do if filefrag -v "$x" | sed -n "4p" | grep -q "inline"; then echo "$x" >> list; fi; done' -- {} +

if [ -s list ]; then
	while read -r x; do
		ls -l "$x"
		filefrag -v "$x"
		sum="$(sha1sum "$x")"
		for y in $(seq 0 99); do
			sysctl vm.drop_caches=1
			sum2="$(sha1sum "$x")"
			if [ "$sum" != "$sum2" ]; then
				result "$x sum1 $sum sum2 $sum2"
				exit 1
			fi
		done
	done < list
	result "No inconsistent reads, $(wc -l < list) inlines"
else
	result "No inline extents"
fi

for x in *9/.; do
	if ! diff -r /usr/. "$x"; then
		result "Differences found in $x"
		# We are looking for corrupted inline extents.
		# Other corruption is interesting but it's not our bug.
		exit 0
	fi
done

result "No corruption found"
exit 0

--mgIE+9cwyCTt+85Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlf4jcAACgkQgfmLGlazG5zsvgCfQmthQVvJIFNNn/KWAgBDD1rt
f2EAnjuzMb1LgN3ID+quF1+JFJcJ0M3J
=Mnhr
-----END PGP SIGNATURE-----

--mgIE+9cwyCTt+85Z--
