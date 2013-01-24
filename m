Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from selda.webserv-it.de ([91.211.43.170]:49084 "EHLO
	mercenary.garni.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3AXQZW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 11:25:22 -0500
Received: from 77-22-254-87-dynip.superkabel.de ([77.22.254.87] helo=queen.localnet)
	by mercenary.garni.ch with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <info@syntax-k.de>)
	id 1TyP9x-0004Tw-E6
	for linux-btrfs@vger.kernel.org; Thu, 24 Jan 2013 16:56:19 +0100
From: =?ISO-8859-1?Q?J=F6rg?= Walter <info@syntax-k.de>
To: linux-btrfs@vger.kernel.org
Date: Thu, 24 Jan 2013 16:56:06 +0100
Message-ID: <1842933.L15n886rVc@queen>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3293517.tvHoUb2QCt"
Subject: btrfs-undelete shell-script
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart3293517.tvHoUb2QCt
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi,

I tried to recover an accidentally deleted text file from a btrfs volum=
e using=20
the trusty old 'grep --text -C 500' method and failed, since the filesy=
stem was=20
compressed. So I wrote a shell script that uses btrfs-progs for a prope=
r=20
undelete functionality.

Attached is the script that implements a working btrfs-undelete using t=
he find-
root and restore tools from btrfs-progs. It is fairly complete and soli=
d and=20
it even has some command  line help. It needs bash and common unix util=
ities=20
(sed, grep, wc, dirname, sort). I have successfully used it to recover =
a=20
couple of files I deleted accidentally and was able to recover 2/3 of t=
hem just=20
fine. The rest was zero-sized, I assume that's because the file blocks =
have=20
already been reused.

If you like it, feel free to add it to btrfs-progs. I've chosen GPLv2 o=
r later=20
as license, as that's what btrfs-progs seems to use.

Please CC me on replies, I am not subscribed (and don't intend to).

--=20
Mit freundlichen Gr=FC=DFen,

=09J=F6rg Walter
--nextPart3293517.tvHoUb2QCt
Content-Disposition: attachment; filename="btrfs-undelete"
Content-Transfer-Encoding: quoted-printable
Content-Type: application/x-shellscript; name="btrfs-undelete"

#!/bin/bash
# btrfs-undelete
# Copyright (C) 2013 J=C3=B6rg Walter <info@syntax-k.de>
# This program is free software; you can redistribute it and/or modify =
it under
# the term of the GNU General Public License as published by the Free S=
oftware
# Foundation; either version 2 of the License, or any later version.

if [ ! -b "$1" -o -z "$2" ]; then
=09echo "Usage: $0 <dev> <file/dir>" 1>&2
=09echo
=09echo "This program tries to recover the most recent version of the"
=09echo "given file or directory (recursively)"
=09echo
=09echo "<dev> must not be mounted, otherwise this program may appear"
=09echo "to work but find nothing."
=09echo
=09echo "<file/dir> must be specified relative to the filesystem root,"=

=09echo "obviously. It may contain * and ? as wildcards, but in that"
=09echo "case, empty files might be 'recovered'. If <file/dir> is a"
=09echo "single file name, this program tries to recover the most"
=09echo "recent non-empty version of the file."
=09echo
=09echo "Note that files are restored to a temporary subdirectory"
=09echo "below /tmp, so you probably don't want to restore huge file"
=09echo "trees unless your /tmp has enough free space."
=09exit 1
fi
dir=3D"`dirname "$0"`"
dev=3D"$1"
file=3D"$2"

file=3D"${file#/}"
file=3D"${file%/}"
regex=3D"${file//\\/\\\\}"

# quote regex special characters
regex=3D"${regex//./\.}"
regex=3D"${regex//+/\+}"
regex=3D"${regex//|/\|}"
regex=3D"${regex//(/\(}"
regex=3D"${regex//)/\)}"
regex=3D"${regex//\[/\[}"
regex=3D"${regex//]/\]}"
regex=3D"${regex//\{/\{}"
regex=3D"${regex//\}/\}}"

# treat shell wildcards specially
nowild=3D"$regex"
regex=3D"${regex//\*/.*}"=20
regex=3D"${regex//\?/.}"
test "$nowild" !=3D "$regex"
nowild=3D$?

# extract number of slashes in order to get correct number of closing p=
arens
slashes=3D"${regex//[^\/]/}"

# build final regex
regex=3D"^/(|${regex//\//(|/}(|/.*${slashes//?/)}))\$"=20

roots=3D/tmp/btrfs-undelete.$$.lst
out=3D/tmp/btrfs-undelete.$$

trap "rm $roots" EXIT
trap "rm -r $out &> /dev/null; exit 1" SIGINT

echo -ne "Searching roots..."
"$dir"/find-root /dev/mapper/queen-home 2>&1 \
=09| grep ^Well \
=09| sed -e 's/Well block \(.*\) seems.*, have=3D\(.*\), want=3D/\2 \1 =
/'  \
=09| sort -n > $roots || exit 1

i=3D0
max=3D"$(wc -l $roots)"
max=3D"${max%% *}"
echo " found $max roots."

while [ "$i" -lt "$max" ]; do
=09((i+=3D1))
=09echo -ne "Trying root $i...\r"
=09tail -n $i $roots | {
=09=09read x id y
=09=09rm -r $out
=09=09mkdir $out
=09=09"$dir/restore" -i -t $id -m "$regex" "$dev" $out
=09} &> /dev/null
=09if [ "$?" =3D 0 ]; then
=09=09if [ "$nowild" =3D 1 ]; then
=09=09=09if [ -s "$out/$file" -o -d "$out/$file" ]; then
=09=09=09=09echo "Recovered file '$out/$file' from root $i".
=09=09=09=09exit 0
=09=09=09fi
=09=09else
=09=09=09if ls "$out/"${file// /\ } &> /dev/null; then
=09=09=09=09echo "Recovered file(s) '$out/$file' from root $i".
=09=09=09=09exit 0
=09=09=09fi
=09=09fi
=09fi
done
rm -r $out
echo "Didn't find '$file'"
exit 1

--nextPart3293517.tvHoUb2QCt--

