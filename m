Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58542 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756013AbdBQITi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 03:19:38 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cedlG-0001CD-Fy
        for linux-btrfs@vger.kernel.org; Fri, 17 Feb 2017 09:19:26 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already
 exists
Date: Fri, 17 Feb 2017 09:19:15 +0100
Message-ID: <20170217091915.066488ef@jupiter.sol.kaishome.de>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de>
        <20170211030139.7bff427e@jupiter.sol.kaishome.de>
        <2380483.tGrojfQH67@thetick>
        <2424977.zeESiHcezE@thetick>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+.q+re_9Ax2/0JuG8Hor391"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/+.q+re_9Ax2/0JuG8Hor391
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Tue, 14 Feb 2017 13:52:48 +0100
schrieb Marc Joliet <marcec@gmx.de>:

> Hi again,
>=20
> so, it seems that I've solved the problem:  After having to
> umount/mount the FS several times to get btrfs-cleaner to finish, I
> thought of the "failed to load free space [...], rebuilding it now"
> type errors and decided to try the clear_cache mount option.  Since
> then, my home server has been running its backups regularly again.
> Furthermore, I was able back up my desktop again via send/recv (the
> rsync based backup is still running, but I expect it to succeed).
> The kernel log has also stayed clean.
>=20
> Kai, I'd be curious whether clear_cache will help in your case, too,
> if you haven't tried it already.

The FS in question has been rebuilt from scratch. AFAIR it wasn't even
mountable back then, or at it froze the system short after mounting.

I needed the system back in usable state, so I had to recreate and
restore the system.

Next time, if it happens again (finger crossed it does not), I'll give
it a try.

--=20
Regards,
Kai

Replies to list-only preferred.

--Sig_/+.q+re_9Ax2/0JuG8Hor391
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAlimsgQACgkQ+D7cQ/kIzAVBZACeKmnPjDH2zS6He3rkMfPHeptt
ecAAnjtX+QWmZvK7yt4UpmzsDjJPLHNJ
=44I6
-----END PGP SIGNATURE-----

--Sig_/+.q+re_9Ax2/0JuG8Hor391--


