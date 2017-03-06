Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51198 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752930AbdCFLUr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Mar 2017 06:20:47 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LmrZY-1c46re1aXM-00h8fI for
 <linux-btrfs@vger.kernel.org>; Mon, 06 Mar 2017 12:19:06 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
Date: Mon, 06 Mar 2017 12:18:59 +0100
Message-ID: <3265560.KVp5lIrk4g@thetick>
In-Reply-To: <2713353.CA3Dyp7XXF@thetick>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de> <14737660.8idzxVKBRv@thetick> <2713353.CA3Dyp7XXF@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1667547.W5pzVBQUSF"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1667547.W5pzVBQUSF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Montag, 6. M=E4rz 2017 00:53:40 CET Marc Joliet wrote:
> On Mittwoch, 1. M=E4rz 2017 19:14:07 CET you wrote:
> >  In any
> >=20
> > case, I started btrfs-check on the device itself.
>=20
> *Sigh*, I had to restart it, because I forgot to redirect to a file and
> quite frankly wasn't expecting this flood of output, but here's a summary
> of the output after about 2 days:
>=20
[snip old output]

OK, it finished last night.  Here's the summary again:

% wc -l btrfs_check_output_20170303.log=20
3028222 btrfs_check_output_20170303.log
% grep -v "backref lost" btrfs_check_output_20170303.log | grep -v "check \
(leaf\|node\) failed" | grep -v "lost its parent" | grep -v "referencer cou=
nt"=20
checking extents
ERROR: block group[3879328546816 1073741824] used 1072840704 but extent ite=
ms=20
used 1129164800
ERROR: block group[4163870130176 1073741824] used 1072259072 but extent ite=
ms=20
used 0
ERROR: block group[4223999672320 1073741824] used 1073664000 but extent ite=
ms=20
used 1074188288
ERROR: block group[4278760505344 1073741824] used 1073377280 but extent ite=
ms=20
used 1073901568
ERROR: block group[4406535782400 1073741824] used 1073627136 but extent ite=
ms=20
used 0
ERROR: extent [3830028140544 4096] referencer bytenr mismatch, wanted:=20
3830028140544, have: 3826183847936
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
Checking filesystem on /dev/sdb2
UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
found 892572778496 bytes used err is -5
total csum bytes: 860790216
total tree bytes: 36906336256
total fs tree bytes: 34551476224
total extent tree bytes: 1230610432
btree space waste bytes: 7446885892
file data blocks allocated: 16359581663232
 referenced 2358137831424

> That's right, slowly approaching 1.5 million lines of btrfs-check output!
> That's *way* more than I ran it the last time this error happened a few
> weeks ago.

As can be seen above, that ballooned to over 3 million lines.  Since the=20
output is 4.2 MB, even after XZ compression, I put it up on my Dropbox, jus=
t=20
in case it's interesting to anybody:

https://www.dropbox.com/s/h6ftqpygfr4vsks/btrfs_check_output_20170303.log.x=
z?
dl=3D0

Since this is my backup drive, and the second time within a month that it h=
ad=20
problems like this, *and* I've got both the btrfs-image dump and btrfs-chec=
k=20
output, I'm going to go ahead and reformat, so that my three computers are=
=20
finally backed up again.

Oh, and for what it's worth, I did test against a 4.8 kernel, and pretty mu=
ch=20
immediately got the "forced RO" error, just like with 4.9.  I didn't try=20
anything older (or newer).

As a last step, I'll probably collect all information I have and post it to=
=20
bugzilla when I have a chance, since others might hit it, too (Kai did befo=
re=20
me, after all).

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--nextPart1667547.W5pzVBQUSF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEax7Ya5gDQFOJHKGQv9DmhiyIePQFAli9RaMACgkQv9DmhiyI
ePRPeg//eszkdjlpsWRBXGHOHvQ9T/90j/fcrxWbt56/nwH0fZuJ3hTYqkOKJTpD
3O6Honbp0nryDhgBFIUrdcUiqkhgmMtlP1mYdb+G6Y1k0ekdVmXiQcD5ZebyQ5cx
6HOOQpTAxpCuRP+DlEH3Y4lH3LmSX8gpoun1/8b8nc52oB3h/6n/De2sA8/6wPn5
biqPwtPY2a6WZ75i3qtCxLnI7YCHSd5aRp84yjSkgxEvVCfeaEY/4LmVXjC9mD3g
aSyuB+JRlaHe00u1pVFQEc/IPgaNKu/uJeoUgQXuyqsobEWfNYYnzK3u0RehYLiX
HqG52Y1Er+80u4cFk/m7tf0TET2GRT1PtEY+azsZQZltMgpZxpbrLwQIsJVllGec
/Qv2kQ9uk3rMGuaio2u2pozMdtEMlUAnsK4gYio95VAXib307SOvV/nUsOLisNR7
+3uQE16Ek72y1Tzy2652dZcP2ai6baplJP3eQx1Tsqdl3AHbSXuRGie+zUpuBIni
s1+dnPoYrhBjNxcIXd9Sdjit1FiRGY1m5AUneslTuaT74eV9eUxWxDyyD37Vd7O4
TqZ96f76zjgNClSX/g8mXHxJ2ORsSjEe2NmV/p8PvwB478TeLTHOvgTDls4+z3hU
hYZxMs68F+PsqU8+TNU0bdycwh6+xq3+S3Z2WMmJF5JPBwRdutg=
=Uhy5
-----END PGP SIGNATURE-----

--nextPart1667547.W5pzVBQUSF--

