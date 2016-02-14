Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:47920 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbcBNWmX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 17:42:23 -0500
Date: Mon, 15 Feb 2016 03:42:19 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
Message-ID: <20160215034219.2f0df0ce@natsu>
In-Reply-To: <20160214213224.GB28882@localhost.localdomain>
References: <CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com>
	<CAJCQCtRtVjyjvSfT=BCZZwfaSvbD4YVxEBezfAx+-q7cwMHmRQ@mail.gmail.com>
	<CABXGCsNivrLgTEE+HZOLHXA-kpLVQOUv9L_nTw96nvy+DHodZg@mail.gmail.com>
	<CAJCQCtTrcnwvumgt-bOx+9wX+f50S9ja5rDrnYAsuuN1aDTsZA@mail.gmail.com>
	<20160211191741.GA4762@localhost.localdomain>
	<CABXGCsPN3MOLkU68gpw=TsnZLODEkYZ66ZHgUxMyeqbdNME9Sw@mail.gmail.com>
	<20160212032226.GA10542@localhost.localdomain>
	<CABXGCsNjHq4M8TBibeWQLyK+Of0cu++P3QQ=+e=TUuZjaPMLtA@mail.gmail.com>
	<20160212203426.GA24399@localhost.localdomain>
	<CABXGCsMMkcMmEH8=d3TqJksB8uc_OVrRqfjX7E1RO+4R94O=Ug@mail.gmail.com>
	<20160214213224.GB28882@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/bLkSrxrEBiCYStSvpgsi6M7"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/bLkSrxrEBiCYStSvpgsi6M7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 14 Feb 2016 13:32:24 -0800
Liu Bo <bo.li.liu@oracle.com> wrote:

> Hi Mike,
> On Sun, Feb 14, 2016 at 12:23:16AM +0500, =D0=9C=D0=B8=D1=85=D0=B0=D0=B8=
=D0=BB =D0=93=D0=B0=D0=B2=D1=80=D0=B8=D0=BB=D0=BE=D0=B2 wrote:
> > Sorry, I have not yet had time to apply your patch.
> >=20
> > And get hang again when launch web browser.
> >=20
> > Here new logs: http://btrfs.sy24.ru/kernel-sysrqw-btrfscleaner770blocke=
d-3.txt
>=20
> The logs show,
> every hung process is waiting for fs tree root's WRITE_LOCK, but someone =
who's
> holding the WRITE_LOCK is not reflected here.
>=20
> Only one suspicious process is=20
> "Chrome_FileThre D ffff8807fe1d7a18 10360 22486   2826 0x00000000"
> it's also waiting on btrfs_tree_lock(), but I can't tell whether it
> waits for the fs tree root node's lock or the children node's lock.
>=20
> Hmm, sorry for not being helpful, but I was wondering if this also
> occurs on the latest btrfs(4.5) or is it possible to give it a shot?
>=20
> The best result is that it's been fixed by one commit in 4.5.

FWIW I had a persistently repeating deadlock on 4.1 and 4.3, but after upgr=
ade
to 4.4 it no longer happens. Not sure if it might be related or not, the
backtrace seems similar: http://www.spinics.net/lists/linux-btrfs/msg50951.=
html

My advice would be to try 4.4, but don't forget to manually add the
nocow/enospc patch: https://patchwork.kernel.org/patch/7967161/

None of the vanilla 4.1, 4.3 or 4.4 should be considered usable with Btrfs =
at
the moment. The latest kernel series which works out of the box was 3.18;
patched 4.4 also works fine so far, but I wonder if that patch makes it into
4.4.2 or gets forgotten/etc again.

--=20
With respect,
Roman

--Sig_/bLkSrxrEBiCYStSvpgsi6M7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlbBAssACgkQTLKSvz+PZwgVZgCgiNMEUEVpZZ71D89IuTmwB8Mm
ghIAn2iAiXdPmzng3mo2WvgQqWmoSoVK
=7641
-----END PGP SIGNATURE-----

--Sig_/bLkSrxrEBiCYStSvpgsi6M7--
