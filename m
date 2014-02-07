Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:39828 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaBGGIP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 01:08:15 -0500
Date: Fri, 7 Feb 2014 12:08:12 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: kreijack@inwind.it, kreijack@libero.it,
        Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
Message-ID: <20140207120812.43dc7982@natsu>
In-Reply-To: <1B8BB06F-64EA-40EC-B0D7-FB4A38928DA3@colorremedies.com>
References: <20140206021516.304732cd@natsu>
	<52F33BE7.4020708@swiftspirit.co.za>
	<20140206184502.128b7dbe@natsu>
	<52F3E86B.4030805@libero.it>
	<20140207104005.7bd1438a@natsu>
	<1B8BB06F-64EA-40EC-B0D7-FB4A38928DA3@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j3W4PpkOtU0w/k=9an3hG.y"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/j3W4PpkOtU0w/k=9an3hG.y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Feb 2014 22:30:46 -0700
Chris Murphy <lists@colorremedies.com> wrote:

> >From the original post, context is a 2x 1TB raid volume:
>=20
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda2       1.8T  1.1M  1.8T   1% /mnt/p2
>=20
> Earlier conventions would have stated Size ~900GB, and Avail ~900GB. But =
that's not exactly true either, is it?

Much better, and matching the user expectations of how RAID1 should behave,
without a major "gotcha" blowing up into their face the first minute they a=
re
trying it out. In fact next step that I planned would be finding how to adj=
ust
also Size and Used on all my machines to show what you just mentioned. I ge=
t it
that btrfs is special and its RAID1 is not the usual RAID1 either, but that=
's
not a good reason to break the 'df' behavior; do whatever you want with in
'btrfs fi df', but if I'm not mistaken the UNIX 'df' always was about user
data, how much of my data I have already stored on this partition and how m=
uch
more can I store. If that's not possible to tell, then try to be reasonably
close to the truth, not deliberately off by 2x.

> On Btrfs ...the amount Avail is likewise not wrong because that space is =
"not otherwise occupied" which is the definition of available.

That's not the definition of available that's directly useful to anyone, but
rather a filesystem-designer level implementation detail, if anything.

What usually interests me is, I have a 100 GB file, can I fit it on this
filesystem, yes/no? Sure let's find out, just check 'df'. Oh wait, not so f=
ast
let's remember was this btrfs? Is that the one with RAID1 or not?... And wh=
at
if I am accessing that partition on a server via a network CIFS/NFS share a=
nd
don't even *have a way to find out* any of that.


--=20
With respect,
Roman

--Sig_/j3W4PpkOtU0w/k=9an3hG.y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlL0eE0ACgkQTLKSvz+PZwjxyQCfRLvQon78pyiMFSiz5bs+W9Fi
7psAmwa7HpG1b/ATmZHMElU9BhF/ICO0
=CRAe
-----END PGP SIGNATURE-----

--Sig_/j3W4PpkOtU0w/k=9an3hG.y--
