Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34296 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbcGDTf3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2016 15:35:29 -0400
Received: by mail-io0-f194.google.com with SMTP id 100so18838179ioh.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 12:35:29 -0700 (PDT)
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data loss in archivers)
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_9191EE8A-ED92-4C70-B91A-B97C4D0C50A9"; protocol="application/pgp-signature"; micalg=pgp-sha256
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
Date: Mon, 4 Jul 2016 13:35:25 -0600
Cc: linux-btrfs@vger.kernel.org, bug-tar <bug-tar@gnu.org>
Message-Id: <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
To: Pavel Raiskup <praiskup@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_9191EE8A-ED92-4C70-B91A-B97C4D0C50A9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 2, 2016, at 1:18 AM, Pavel Raiskup <praiskup@redhat.com> wrote:
>=20
> There are optimizations in archivers (tar, rsync, ...) that rely on =
up2date
> st_blocks info.  For example, in GNU tar there is optimization check =
[1]
> whether the 'st_size' reports more data than the 'st_blocks' can hold =
--> then
> tar considers that file is sparse (and does additional steps).
>=20
> It looks like btrfs doesn't show correct value in 'st_blocks' until =
the data
> are synced.  ATM, there happens that:
>=20
>    a) some "tool" creates sparse file
>    b) that tool does not sync explicitly and exits ..
>    c) tar is called immediately after that to archive the sparse file
>    d) tar considers [2] the file is completely sparse (because =
st_blocks is
>       zero) and archives no data.  Here comes data loss.
>=20
> Because we fixed 'btrfs' to report non-zero 'st_blocks' when the file =
data is
> small and is in-lined (no real data blocks) -- I consider this is too =
bug in
> btrfs worth fixing.

We had a similar problem with both ext4 and Lustre - the client was =
reporting
zero blocks due to delayed allocation until data was written to disk.  =
While
those problems were fixed in the filesystem to report an estimate of the =
block
count before any blocks were actually written to disk, it seems like =
this may
be a problem that will come up again with other filesystems in the =
future.

I think in addition to fixing btrfs (because it needs to work with =
existing
tar/rsync/etc. tools) it makes sense to *also* fix the heuristics of tar
to handle this situation more robustly.  One option is if st_blocks =3D=3D=
 0 then
tar should also check if st_mtime is less than 60s in the past, and if =
yes
then it should call fsync() on the file to flush any unwritten data to =
disk,
or assume the file is not sparse and read the whole file, so that it =
doesn't
incorrectly assume that the file is sparse and skip archiving the file =
data.

Cheers, Andreas

>=20
> [1] =
http://git.savannah.gnu.org/cgit/paxutils.git/tree/lib/system.h?id=3Dec72a=
bd9dd63bbff4534ec77e97b1a6cadfc3cf8#n392
> [2] =
http://git.savannah.gnu.org/cgit/tar.git/tree/src/sparse.c?id=3Dac065c57fd=
c1788a2769fb119ed0c8146e1b9dd6#n273
>=20
> Tested on kernel:
> kernel-4.5.7-300.fc24.x86_64
>=20
> Originally reported here, reproducer available there:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1352061
>=20
> Pavel
>=20
>=20


Cheers, Andreas






--Apple-Mail=_9191EE8A-ED92-4C70-B91A-B97C4D0C50A9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV3q6fXKl2rkXzB/gAQhRjg/8CFcNA8DwOM8xgczZuFKegkiebdDrqPm4
pAj27LcaJ/CCcXG0SQ9zTPLArOYs/uoUq7Et1gRxdmmN6eLPkyg2pgh3wTS7N01H
Kw4UPTgshYvtn0j9M5QcSTKx3/Cwf43ven2q4L/SbOQBhGDDqu3lb9DcfEkAaWV8
E8x9rWHCm7qsV1A2/nXP+RpDbO+KOzayW0nL8zk0xajuvKCMb38m0BKhv1U+VNTp
7B21bdTYe1Am7HU9LVbaQL7PAPebmM8aaUBiOgO4uHHMgxBBJbGDhPs4HVIB+82d
+YPB4wpZth1I+MSjUQ9vbkg9AHSJ4FRXvooqFWBpvCeldQjYs5JjNVPlQyVwXA/a
UIE3KqPYWLURI/MaNkMQ026K6RLmH1BW47FXpZXLo21gdxIJMBz7PNhU2ng7plfd
KLGEJhUiOMetJe/LdioobYnZDdfD0ykgKpcIGxVx3YTaAy01M1AtTJzgSkmQ4N2S
6QWcb2QzdfwT2w0wbNDA4EYphD+P5jwz0cqaii9IWkU5C6s+mO5p8ciTIq/mnfjj
lMnsblrxiXiq842ZuzLCdkG3MVVrTpjUAkAY2Au/RTmge6E5628KNVfdSqkySoto
XQkzWUBaculimnKaOHeSVpIB1813Ad3H9BdjrLaTNbLYuiZupbONcLUM4bfu4hKa
kxPG8ybzX+M=
=SDt/
-----END PGP SIGNATURE-----

--Apple-Mail=_9191EE8A-ED92-4C70-B91A-B97C4D0C50A9--
