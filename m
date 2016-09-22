Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37446 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1034493AbcIVRum (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 13:50:42 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bn88Y-0001Qk-1q
        for linux-btrfs@vger.kernel.org; Thu, 22 Sep 2016 19:50:18 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs rare silent data corruption with kernel data leak
Date: Thu, 22 Sep 2016 19:49:58 +0200
Message-ID: <20160922194958.19a1cdd6@jupiter.sol.kaishome.de>
References: <20160921045556.GN21290@hungrycats.org>
        <ME1PR01MB13788B5A79BF88786A1D571D9EF60@ME1PR01MB1378.ausprd01.prod.outlook.com>
        <20160921130209.GO21290@hungrycats.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/SSUY68rLl8FfSUvfIV2/SX9"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/SSUY68rLl8FfSUvfIV2/SX9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Wed, 21 Sep 2016 09:02:09 -0400
schrieb Zygo Blaxell <ce3g8jdj@umail.furryterror.org>:

> On Wed, Sep 21, 2016 at 11:14:35AM +0000, Paul Jones wrote:
> > > -----Original Message-----
> > > From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> > > owner@vger.kernel.org] On Behalf Of Zygo Blaxell
> > > Sent: Wednesday, 21 September 2016 2:56 PM
> > > To: linux-btrfs@vger.kernel.org
> > > Subject: btrfs rare silent data corruption with kernel data leak
> > >=20
> > > Summary:
> > >=20
> > > There seem to be two btrfs bugs here: one loses data on writes,
> > > and the other leaks data from the kernel to replace it on reads.
> > > It all happens after checksums are verified, so the corruption is
> > > entirely silent--no EIO errors, kernel messages, or device event
> > > statistics.
> > >=20
> > > Compressed extents are corrupted with kernel data leak.
> > > Uncompressed extents may not be corrupted, or may be corrupted by
> > > deterministically replacing data bytes with zero, or may not be
> > > corrupted.  No preconditions for corruption are known.  Less than
> > > one file per hundred thousand seems to be affected.  Only
> > > specific parts of any file can be affected. Kernels v4.0..v4.5.7
> > > tested, all have the issue. =20
> >=20
> > Funny you should bring this up - I think I just suffered from this,
> > or something similar. =20
> [...snip...]
> > [ 1311.456545] BTRFS warning (device sda1): csum failed ino
> > 44628192 off 3222405120 csum 2566472073 expected csum 3548745998
> > [ 1311.456551] BTRFS warning (device sda1): csum failed ino
> > 44628192 off 3222470656 csum 2566472073 expected csum 2988893031
> >=20
> > I'm seeing a lot of checksum 2566472073 - Is that the checksum of
> > blank space I wonder? =20
>=20
> The issue I found occurs after successful checksum validation, and
> can affect only the first 4096 bytes of a file.  It produces no kernel
> messages and no checksum failures.  If you run 'filefrag -v' on the
> file, the corrupted extent *must* have the 'inline' flag; otherwise,
> it's a different problem.
>=20
> You have csum failures, and the affected offsets are way beyond 4096.
>=20
> Holes are not checksummed in general because they are gaps in the
> file offset address space.  Metadata records that describe holes are
> checksummed, but when those checksums fail the kernel messages look
> different.
>=20
> I don't recognize the symptoms you are having.  After eliminating
> hardware problems and making sure your kernel is up to date, I'd try
> changing mount options...
>=20
> > Here are the details of the filesystem concerned: =20
> [...]
> > /dev/sda1 on / type btrfs
> > (rw,noatime,ssd,discard,noacl,space_cache=3Dv2,subvolid=3D5,subvol=3D/)
> > (compress was enabled previously) =20
>=20
> ...discard and space_cache=3Dv2 in particular.  Free space tree is a new
> feature, and discard has had a few bug fixes over the years.  Both are
> non-default options.
>=20
> Speaking of mount options, 'max_inline=3D0' may prevent the issue I
> found.

This sounds a lot like problems I've seen with my virtualbox images.
They just accumulate csum errors over time, especially after
defragmenting. No matter if discard was enabled or not.

The only common option is compression, I'm using compress=3Dlzo.

I made the files nocow which of course disables compression and
probably results in not triggering autodefrag. Of course this also
disables checksums so you won't see data corruption as a direct error
in the FS. But the vm images are running fine so far without any
problems. Data integrity and data safety looks healthy.

You probably want to nonow mysql anyways. I think mysql data files have
their own checksumming, copy on write, and transactions. There's really
no point in doing it twice.

So it seems that btrfs either can damage files on defragmentation or
that compression has a bug with files that are heavily modified inline
(thus breaking the file into a lot of extents) - which probably has bad
effects on compressed extents, too.

--=20
Regards,
Kai

Replies to list-only preferred.

--Sig_/SSUY68rLl8FfSUvfIV2/SX9
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlfkGccACgkQ+D7cQ/kIzAWWjACeNpn3+GBKjiWq9ehPuMuixxfT
bXQAn2m+ogvv4cQYqX8OBT4I63o+KRzm
=9x0t
-----END PGP SIGNATURE-----

--Sig_/SSUY68rLl8FfSUvfIV2/SX9--


