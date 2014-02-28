Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:42028 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaB1Eeo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 23:34:44 -0500
Date: Fri, 28 Feb 2014 10:34:36 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Justin Brown <otakujunction@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Help with space
Message-ID: <20140228103436.2dfd2669@natsu>
In-Reply-To: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j17P27lb20+yGo_IBO2w1aK"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/j17P27lb20+yGo_IBO2w1aK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Feb 2014 12:19:05 -0600
Justin Brown <otakujunction@gmail.com> wrote:

> I've a 18 tera hardware raid 5 (areca ARC-1170 w/ 8 3 gig drives) in

Do you sleep well at night knowing that if one disk fails, you end up with
basically a RAID0 of 7x3TB disks? And that if 2nd one encounters unreadable
sector during rebuild, you lost your data? RAID5 actually stopped working 5
years ago, apparently you didn't get the memo. :)
http://hardware.slashdot.org/story/08/10/21/2126252/why-raid-5-stops-workin=
g-in-2009

> need of help.  Disk usage (du) shows 13 tera allocated yet strangely
> enough df shows approx. 780 gigs are free.  It seems, somehow, btrfs
> has eaten roughly 4 tera internally.  I've run a scrub and a balance
> usage=3D5 with no success, in fact I lost about 20 gigs after the

Did you run balance with "-dusage=3D5" or "-musage=3D5"? Or both?
What is the output of the balance command?

> terra:/var/lib/nobody/fs/ubfterra # btrfs fi df .
> Data, single: total=3D17.58TiB, used=3D17.57TiB
> System, DUP: total=3D8.00MiB, used=3D1.93MiB
> System, single: total=3D4.00MiB, used=3D0.00
> Metadata, DUP: total=3D392.00GiB, used=3D33.50GiB
                       ^^^^^^^^^

If you'd use "-musage=3D5", I think this metadata reserve should have been
shrunk, and you'd gain a lot more free space.

But then as others mentioned it may be risky to use this FS on 32-bit at al=
l,
so I'd suggest trying anything else only after you reboot into a 64-bit ker=
nel.

--=20
With respect,
Roman

--Sig_/j17P27lb20+yGo_IBO2w1aK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlMQEdwACgkQTLKSvz+PZwhoUACcCV7vNWjuVCjMtTa91hcRcHrW
xtIAniV+j6mf/j9gL3jowbOqqSB5Vp+T
=6pKX
-----END PGP SIGNATURE-----

--Sig_/j17P27lb20+yGo_IBO2w1aK--
