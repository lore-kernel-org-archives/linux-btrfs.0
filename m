Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40199 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751667AbdBKCB7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 21:01:59 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ccN0V-0006Uk-79
        for linux-btrfs@vger.kernel.org; Sat, 11 Feb 2017 03:01:47 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already
 exists
Date: Sat, 11 Feb 2017 03:01:39 +0100
Message-ID: <20170211030139.7bff427e@jupiter.sol.kaishome.de>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de>
        <11009787.rdtfuSitqF@thetick>
        <20170203234410.7ef21de7@jupiter.sol.kaishome.de>
        <2314132.jQCgNOg6dG@thetick>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/BBW8R22rU0ljz1QhLVqhHyu"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/BBW8R22rU0ljz1QhLVqhHyu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Fri, 10 Feb 2017 23:15:03 +0100
schrieb Marc Joliet <marcec@gmx.de>:

> # btrfs filesystem df /media/MARCEC_BACKUP/  =20
> Data, single: total=3D851.00GiB, used=3D831.36GiB
> System, DUP: total=3D64.00MiB, used=3D120.00KiB
> Metadata, DUP: total=3D13.00GiB, used=3D10.38GiB
> Metadata, single: total=3D1.12GiB, used=3D0.00B
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> Hmm, I take it that the single metadata is a leftover from running
> --repair?

It's more probably a remnant of an incomplete balance operation or an
older mkfs version. I'd simply rebalance metadata to fix this.

I don't think that btrfs-repair would migrate missing metadata
duplicates back to single profile, it would more likely trigger
recreating the missing duplicates. But I'm not sure.

If it is a result of the repair operation, that could be an
interesting clue. Could it explain "error -17" from your logs? But that
would mean the duplicates were already missing before the repair
operation and triggered that problem. So the question is, why are those
duplicates missing in the first place as a result of normal operation?
=46rom your logs:

---8<--- snip
Feb 02 22:49:14 thetick kernel: BTRFS: device label MARCEC_BACKUP devid
1 transid 283903 /dev/sdd2
Feb 02 22:49:19 thetick kernel: EXT4-fs (sdd1): mounted filesystem with=20
ordered data mode. Opts: (null)
Feb 03 00:18:52 thetick kernel: BTRFS info (device sdd2): use zlib
compression Feb 03 00:18:52 thetick kernel: BTRFS info (device sdd2):
disk space caching is enabled
Feb 03 00:18:52 thetick kernel: BTRFS info (device sdd2): has skinny
extents Feb 03 00:20:09 thetick kernel: BTRFS info (device sdd2): The
free space cache file (3967375376384) is invalid. skip it
Feb 03 01:05:58 thetick kernel: ------------[ cut here ]------------
Feb 03 01:05:58 thetick kernel: WARNING: CPU: 1 PID: 26544 at
fs/btrfs/extent- tree.c:2967 btrfs_run_delayed_refs+0x26c/0x290
Feb 03 01:05:58 thetick kernel: BTRFS: Transaction aborted (error -17)
--->8--- snap

"error -17" being "object already exists". My only theory would be this
has a direct connection to you finding the single metadata profile.
Like in "the kernel thinks the objects already exists when it really
didn't, and as a result the object is there only once now" aka "single
metadata".

But I'm no dev and no expert on the internals.

--=20
Regards,
Kai

Replies to list-only preferred.

--Sig_/BBW8R22rU0ljz1QhLVqhHyu
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAliecIMACgkQ+D7cQ/kIzAUUkQCffD3nlsNF0zE1U6G60ntUgsTo
LFAAn3+QA/6wA6FSWiplvriESOzGzuWh
=chYH
-----END PGP SIGNATURE-----

--Sig_/BBW8R22rU0ljz1QhLVqhHyu--


