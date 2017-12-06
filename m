Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63531 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753536AbdLFAnI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 19:43:08 -0500
Subject: Re: Chunk-Recovery fails with alignment error
To: Benjamin Beichler <hadrian2002@googlemail.com>,
        linux-btrfs@vger.kernel.org
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <211ded6e-5b02-0c33-b75e-b0ad6ff30ca4@gmx.com>
Date: Wed, 6 Dec 2017 08:42:59 +0800
MIME-Version: 1.0
In-Reply-To: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3QXWSLrtuAM3MlJN39Nu05Mj4eOwhllFa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3QXWSLrtuAM3MlJN39Nu05Mj4eOwhllFa
Content-Type: multipart/mixed; boundary="cIU06Cvl4mJFGH9OpjrMUe6UxMhsBQ7sX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Benjamin Beichler <hadrian2002@googlemail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <211ded6e-5b02-0c33-b75e-b0ad6ff30ca4@gmx.com>
Subject: Re: Chunk-Recovery fails with alignment error
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
In-Reply-To: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>

--cIU06Cvl4mJFGH9OpjrMUe6UxMhsBQ7sX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8806=E6=97=A5 03:22, Benjamin Beichler wrote:
> Hi,
>=20
> I have a setup as following:  (1,7TB drive + 128GB SSD in Bcache) <=3D=3D=
>
> luks device <=3D=3D> btrfs FS
> I have been running Arch linux with newest stable kernel 4.14.
>=20
> After a reboot last week my btrfs volume becomes unmountable, because
> of checksum errors in the chunk root.
>=20
> These are the outputs of check:
> "btrfs check /dev/mapper/root
>=20
> checksum verify failed on 131072 found 1A98EC4A wanted B97166DB
> checksum verify failed on 131072 found 1A98EC4A wanted B97166DB
> bytenr mismatch, want=3D131072, have=3D9229526874648754029
> ERROR: cannot read chunk root
> ERROR: cannot open file system

That's the most serious problem for btrfs.
No chunk tree nothing can be recovered.

> "
>=20
> Most other check/repair commands fail with the same error. The
> super-dump can be found here:
> https://gist.github.com/anonymous/33bd22696c37355c6cfd093f4c6bd226

Better with -fa option to show system chunk array and backup roots.

>=20
>  After my attempts in initramfs failed I used a recent arch-live disk
> to compile newest btrfs-tools and use recent kernel (4.9) to recover
> the chunk tree.
>=20
> Therefore I ran the chunk recover command on my drive.  It looks like
> the following here>
> https://gist.github.com/anonymous/5359c08734cf81ad3887b635536d9631
>=20
> for better debugging I already used gdb to inspect the following error:=

>=20
> "ERROR: tree block bytenr 0 is not aligned to sectorsize 4096"
>=20
> but as the exception raise is far to late to inspect the problem.
> Since most of my chunks seems to be recoverable, I hope a tree rebuild
> is possible, but I don't know how.

This seems to be related to __rebuikld_device_items(), where
btrfs_insert_item() return -EIO and triggered BUG_ON().

Despite the heavy (and mostly overkilled) method, we can do a lighter
version by checking every possible tree root in system chunk array.

Which needs the -fa option of super-dump subcommand.


The basic idea is:
1) Check the back_roots of output
   If backup_chunk_root of all backup roots are the same with chunk_root
   (which is 131072 in your case), skip to step 3)

2) Try all backup_chunk_root numbers with "btrfs check --chunk-root
   <bytenr>"
   If some number returns good result (no obvious problem reported),
   then with --repair option, finish the repair.
   If all fails, go step 3)

3) Try all bytenr aligned to 16K in system chunk
   Same "btrfs check --chunk-root <bytenr>" until one returns good
   result. Then --repair.

Thanks,
Qu
>=20
> Do you have any suggestions?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--cIU06Cvl4mJFGH9OpjrMUe6UxMhsBQ7sX--

--3QXWSLrtuAM3MlJN39Nu05Mj4eOwhllFa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlonPRMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjL4Qf/Q2IxUA0+x1Uu1OUl/RIiLq6f
6egVQzUXqIARNCRr+2OXSTjqfxXEOtj59KCs+EgXZG4m5AzKu9/MaUWeiUmZHLFj
kMIRwewLcf3Oifr5a3k8ddSqoPF3hQtLwz/EXCMK84KXJUjRNZOJ1GqA/bn/acSX
oiaz1Ly5hGSLkGl1AELbeKCJweqNWAGj2SKE4wIXqb/TtS5b5lwa6pL8IL45HRfs
7NblIMzBlMC3vHkVTmfafeVdITbAfhqACU9F9I+4b7Y4VvHeJ/voBvWJPiPpRI9Z
8bmcvEwPLgjaBIeuUXNLYuDH4nWSoq1jKkiN4TVIAxWy0gffegqfhKAg38yRkg==
=Tnvm
-----END PGP SIGNATURE-----

--3QXWSLrtuAM3MlJN39Nu05Mj4eOwhllFa--
