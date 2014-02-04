Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:54660 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaBDQfP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Feb 2014 11:35:15 -0500
Date: Tue, 4 Feb 2014 22:35:06 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs crash with a corrupted(?) filesystem
Message-ID: <20140204223506.569626c1@natsu>
In-Reply-To: <20140204163235.GC6490@carfax.org.uk>
References: <20140204222310.65c4a468@natsu>
	<20140204163235.GC6490@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZwyBn2oC3Q36T.bQtcF9ap/"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/ZwyBn2oC3Q36T.bQtcF9ap/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 4 Feb 2014 16:32:35 +0000
Hugo Mills <hugo@carfax.org.uk> wrote:

> On Tue, Feb 04, 2014 at 10:23:10PM +0600, Roman Mamedov wrote:
> > Hello,
> >=20
> > My server had a period of instability (PSU-related issues), some lockup=
s,
> > some strange crashes, and some files became corrupted, and perhaps part=
s of
> > a filesystem too. One BTRFS partition now fails with the following erro=
rs.
> >=20
> > On an attempt to make a snapshot:
> >=20
> > [   48.035664] btrfs: corrupt leaf, bad key order: block=3D193529446400=
,root=3D1, slot=3D9
> [snip]
>=20
>    Bad key order is pretty much always down to hardware corrupting
> data at some point -- which would go well with your list of hardware
> problems above.
>=20
> > Currently I have it mounted read-only, and all data seems to be accessi=
ble.
> > Short of copying everything away and recreating the FS, how can I bring=
 it to
> > a working order. Is btrfsck a good option here?
>=20
>    The first investigation to do would be to look at the block in
> question and see if it's got an obvious problem with it. If you post
> the output of "btrfs-debug-tree -b 193529446400 /dev/whatever", we can
> take a look at the indexing.

Thanks; here it is:

# btrfs-debug-tree -b 193529446400 /dev/md4=20
leaf 193529446400 items 81 free space 46 generation 565572 owner 7
fs uuid dd12de99-bbe5-45cf-b869-6313c1f58431
chunk uuid b61f845a-ada5-4bcf-b995-7c5e1affa63d
	item 0 key (EXTENT_CSUM EXTENT_CSUM 4278808576) itemoff 3955 itemsize 40
		extent csum item
	item 1 key (EXTENT_CSUM EXTENT_CSUM 4278853632) itemoff 3895 itemsize 60
		extent csum item
	item 2 key (EXTENT_CSUM EXTENT_CSUM 4278919168) itemoff 3883 itemsize 12
		extent csum item
	item 3 key (EXTENT_CSUM EXTENT_CSUM 4278931456) itemoff 3843 itemsize 40
		extent csum item
	item 4 key (EXTENT_CSUM EXTENT_CSUM 4278976512) itemoff 3819 itemsize 24
		extent csum item
	item 5 key (EXTENT_CSUM EXTENT_CSUM 4279001088) itemoff 3815 itemsize 4
		extent csum item
	item 6 key (EXTENT_CSUM EXTENT_CSUM 4279005184) itemoff 3787 itemsize 28
		extent csum item
	item 7 key (EXTENT_CSUM EXTENT_CSUM 4279033856) itemoff 3715 itemsize 72
		extent csum item
	item 8 key (EXTENT_CSUM EXTENT_CSUM 4279107584) itemoff 3619 itemsize 96
		extent csum item
	item 9 key (EXTENT_CSUM EXTENT_CSUM 72998785024) itemoff 3599 itemsize 20
		extent csum item
	item 10 key (EXTENT_CSUM EXTENT_CSUM 4279345152) itemoff 3583 itemsize 16
		extent csum item
	item 11 key (EXTENT_CSUM EXTENT_CSUM 4279369728) itemoff 3575 itemsize 8
		extent csum item
	item 12 key (EXTENT_CSUM EXTENT_CSUM 4279463936) itemoff 3551 itemsize 24
		extent csum item
	item 13 key (EXTENT_CSUM EXTENT_CSUM 4279496704) itemoff 3523 itemsize 28
		extent csum item
	item 14 key (EXTENT_CSUM EXTENT_CSUM 4279525376) itemoff 3515 itemsize 8
		extent csum item
	item 15 key (EXTENT_CSUM EXTENT_CSUM 4279533568) itemoff 3511 itemsize 4
		extent csum item
	item 16 key (EXTENT_CSUM EXTENT_CSUM 4279537664) itemoff 3491 itemsize 20
		extent csum item
	item 17 key (EXTENT_CSUM EXTENT_CSUM 4279562240) itemoff 3463 itemsize 28
		extent csum item
	item 18 key (EXTENT_CSUM EXTENT_CSUM 4279607296) itemoff 3459 itemsize 4
		extent csum item
	item 19 key (EXTENT_CSUM EXTENT_CSUM 4279615488) itemoff 3403 itemsize 56
		extent csum item
	item 20 key (EXTENT_CSUM EXTENT_CSUM 4280020992) itemoff 3395 itemsize 8
		extent csum item
	item 21 key (EXTENT_CSUM EXTENT_CSUM 4280033280) itemoff 3391 itemsize 4
		extent csum item
	item 22 key (EXTENT_CSUM EXTENT_CSUM 4280053760) itemoff 3379 itemsize 12
		extent csum item
	item 23 key (EXTENT_CSUM EXTENT_CSUM 4280082432) itemoff 3331 itemsize 48
		extent csum item
	item 24 key (EXTENT_CSUM EXTENT_CSUM 4280135680) itemoff 3311 itemsize 20
		extent csum item
	item 25 key (EXTENT_CSUM EXTENT_CSUM 4280156160) itemoff 3299 itemsize 12
		extent csum item
	item 26 key (EXTENT_CSUM EXTENT_CSUM 4280168448) itemoff 3255 itemsize 44
		extent csum item
	item 27 key (EXTENT_CSUM EXTENT_CSUM 4280229888) itemoff 3243 itemsize 12
		extent csum item
	item 28 key (EXTENT_CSUM EXTENT_CSUM 4280262656) itemoff 3231 itemsize 12
		extent csum item
	item 29 key (EXTENT_CSUM EXTENT_CSUM 4280360960) itemoff 3223 itemsize 8
		extent csum item
	item 30 key (EXTENT_CSUM EXTENT_CSUM 4280369152) itemoff 3123 itemsize 100
		extent csum item
	item 31 key (EXTENT_CSUM EXTENT_CSUM 4280496128) itemoff 3115 itemsize 8
		extent csum item
	item 32 key (EXTENT_CSUM EXTENT_CSUM 4280504320) itemoff 3103 itemsize 12
		extent csum item
	item 33 key (EXTENT_CSUM EXTENT_CSUM 4280532992) itemoff 3087 itemsize 16
		extent csum item
	item 34 key (EXTENT_CSUM EXTENT_CSUM 4280549376) itemoff 3071 itemsize 16
		extent csum item
	item 35 key (EXTENT_CSUM EXTENT_CSUM 4280565760) itemoff 3063 itemsize 8
		extent csum item
	item 36 key (EXTENT_CSUM EXTENT_CSUM 4280573952) itemoff 3055 itemsize 8
		extent csum item
	item 37 key (EXTENT_CSUM EXTENT_CSUM 4280664064) itemoff 3047 itemsize 8
		extent csum item
	item 38 key (EXTENT_CSUM EXTENT_CSUM 4280672256) itemoff 3023 itemsize 24
		extent csum item
	item 39 key (EXTENT_CSUM EXTENT_CSUM 4280696832) itemoff 2967 itemsize 56
		extent csum item
	item 40 key (EXTENT_CSUM EXTENT_CSUM 4280762368) itemoff 2947 itemsize 20
		extent csum item
	item 41 key (EXTENT_CSUM EXTENT_CSUM 4280852480) itemoff 2939 itemsize 8
		extent csum item
	item 42 key (EXTENT_CSUM EXTENT_CSUM 4280868864) itemoff 2931 itemsize 8
		extent csum item
	item 43 key (EXTENT_CSUM EXTENT_CSUM 4280885248) itemoff 2915 itemsize 16
		extent csum item
	item 44 key (EXTENT_CSUM EXTENT_CSUM 4280905728) itemoff 2911 itemsize 4
		extent csum item
	item 45 key (EXTENT_CSUM EXTENT_CSUM 4280909824) itemoff 2895 itemsize 16
		extent csum item
	item 46 key (EXTENT_CSUM EXTENT_CSUM 4280971264) itemoff 2859 itemsize 36
		extent csum item
	item 47 key (EXTENT_CSUM EXTENT_CSUM 4281036800) itemoff 2823 itemsize 36
		extent csum item
	item 48 key (EXTENT_CSUM EXTENT_CSUM 4281102336) itemoff 2771 itemsize 52
		extent csum item
	item 49 key (EXTENT_CSUM EXTENT_CSUM 4281176064) itemoff 2759 itemsize 12
		extent csum item
	item 50 key (EXTENT_CSUM EXTENT_CSUM 4281188352) itemoff 2743 itemsize 16
		extent csum item
	item 51 key (EXTENT_CSUM EXTENT_CSUM 4281233408) itemoff 2735 itemsize 8
		extent csum item
	item 52 key (EXTENT_CSUM EXTENT_CSUM 4281323520) itemoff 2723 itemsize 12
		extent csum item
	item 53 key (EXTENT_CSUM EXTENT_CSUM 4281352192) itemoff 2711 itemsize 12
		extent csum item
	item 54 key (EXTENT_CSUM EXTENT_CSUM 4281364480) itemoff 2707 itemsize 4
		extent csum item
	item 55 key (EXTENT_CSUM EXTENT_CSUM 4281376768) itemoff 2667 itemsize 40
		extent csum item
	item 56 key (EXTENT_CSUM EXTENT_CSUM 4281417728) itemoff 2611 itemsize 56
		extent csum item
	item 57 key (EXTENT_CSUM EXTENT_CSUM 4281475072) itemoff 2591 itemsize 20
		extent csum item
	item 58 key (EXTENT_CSUM EXTENT_CSUM 4281495552) itemoff 2555 itemsize 36
		extent csum item
	item 59 key (EXTENT_CSUM EXTENT_CSUM 4281532416) itemoff 2551 itemsize 4
		extent csum item
	item 60 key (EXTENT_CSUM EXTENT_CSUM 4281561088) itemoff 2547 itemsize 4
		extent csum item
	item 61 key (EXTENT_CSUM EXTENT_CSUM 4281565184) itemoff 2527 itemsize 20
		extent csum item
	item 62 key (EXTENT_CSUM EXTENT_CSUM 4281602048) itemoff 2511 itemsize 16
		extent csum item
	item 63 key (EXTENT_CSUM EXTENT_CSUM 4281638912) itemoff 2503 itemsize 8
		extent csum item
	item 64 key (EXTENT_CSUM EXTENT_CSUM 4281876480) itemoff 2455 itemsize 48
		extent csum item
	item 65 key (EXTENT_CSUM EXTENT_CSUM 4281937920) itemoff 2431 itemsize 24
		extent csum item
	item 66 key (EXTENT_CSUM EXTENT_CSUM 4282073088) itemoff 2411 itemsize 20
		extent csum item
	item 67 key (EXTENT_CSUM EXTENT_CSUM 4282093568) itemoff 2395 itemsize 16
		extent csum item
	item 68 key (EXTENT_CSUM EXTENT_CSUM 4282109952) itemoff 2387 itemsize 8
		extent csum item
	item 69 key (EXTENT_CSUM EXTENT_CSUM 4282134528) itemoff 2335 itemsize 52
		extent csum item
	item 70 key (EXTENT_CSUM EXTENT_CSUM 4282191872) itemoff 2331 itemsize 4
		extent csum item
	item 71 key (EXTENT_CSUM EXTENT_CSUM 4282216448) itemoff 2255 itemsize 76
		extent csum item
	item 72 key (EXTENT_CSUM EXTENT_CSUM 4282298368) itemoff 2251 itemsize 4
		extent csum item
	item 73 key (EXTENT_CSUM EXTENT_CSUM 4282503168) itemoff 2223 itemsize 28
		extent csum item
	item 74 key (EXTENT_CSUM EXTENT_CSUM 4282531840) itemoff 2211 itemsize 12
		extent csum item
	item 75 key (EXTENT_CSUM EXTENT_CSUM 4282548224) itemoff 2151 itemsize 60
		extent csum item
	item 76 key (EXTENT_CSUM EXTENT_CSUM 4282626048) itemoff 2123 itemsize 28
		extent csum item
	item 77 key (EXTENT_CSUM EXTENT_CSUM 4282658816) itemoff 2119 itemsize 4
		extent csum item
	item 78 key (EXTENT_CSUM EXTENT_CSUM 4282662912) itemoff 2107 itemsize 12
		extent csum item
	item 79 key (EXTENT_CSUM EXTENT_CSUM 4282679296) itemoff 2095 itemsize 12
		extent csum item
	item 80 key (EXTENT_CSUM EXTENT_CSUM 4282712064) itemoff 2071 itemsize 24
		extent csum item

--=20
With respect,
Roman

--Sig_/ZwyBn2oC3Q36T.bQtcF9ap/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLxFroACgkQTLKSvz+PZwjaWQCgip0bOPymYc2dj+G8cVEKBuKh
RjkAn2B7FF1LfPmJ017klc480GJYIEcA
=eK4l
-----END PGP SIGNATURE-----

--Sig_/ZwyBn2oC3Q36T.bQtcF9ap/--
