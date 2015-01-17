Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59560 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbbAQMX2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Jan 2015 07:23:28 -0500
Date: Sat, 17 Jan 2015 12:23:24 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: G EO <1g2e3o4@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Duncan <1i5t5.duncan@cox.net>
Subject: Re: Backup: Lost local reference
Message-ID: <20150117122324.GG32182@carfax.org.uk>
References: <CAOsFrTexWG-SZ=22fO8myx+trqz-w1qQ9XPFDOZJTHoNVgggEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7BtE0xW96okrVgVt"
In-Reply-To: <CAOsFrTexWG-SZ=22fO8myx+trqz-w1qQ9XPFDOZJTHoNVgggEw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7BtE0xW96okrVgVt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 17, 2015 at 01:03:20PM +0100, G EO wrote:
> I know I have discussed it already on this list, but unfortunately it
> did no work out for me.
> I am creating backups with btrfs send/receive, like described on the
> wiki page https://btrfs.wiki.kernel.org/index.php/Incremental_Backup.
> 
> That means I have a subvolume "home", create a snapshot
> "home-snapshot" and send it to the backup drive. Then the following
> times I create another snapshot "home-snapshot-1" and send the
> difference to the backup drive using "btrfs send -p home-snapshot
> home-snapshot-1 | btrfs receive /path". For that to work I always need
> to keep the last local reference (like home-snapshot) in this example.
> 
> Now I am in the unfortunate situation that I deleted the local
> reference accidentally out of my own stupidity and wonder if there is
> a way to determine the difference between the last snapshot on the
> backup drive and the state of my sub-volume now.

   I think the short answer is, no, there isn't any way of doing it.

   Hugo.

> I tried the following: I sent the last snapshot (in this example
> home-snapshot-1) on the backup drive to an empty btrfs filesystem.
> Then I created a read/write snapshot of this one
> (home-snapshot-1-snap) and copied my whole current subvolume to the
> read/write snapshot in the hope btrfs would only writes changes, but
> that was hopeless, when sending the "diff -p" between the imported
> snapshot (home-snapshot-1) and the read write snapshot
> (home-snapshot-1-snap) back to the backup drive, it did not send any
> differences but the whole subvolume (home-snapshot-1-snap).
> 
> So is there any way I can let compute the differences in order to
> restore the old situation and continue with my incremental backups?
> 
> For information: I do not have any older local snapshots :-(, all of
> the snapshot were deleted because of a regex problem in a script I
> ran.

-- 
Hugo Mills             | Debugging is like hitting yourself in the head with
hugo@... carfax.org.uk | hammer: it feels so good when you find the bug, and
http://carfax.org.uk/  | you're allowed to stop debugging.
PGP: 65E74AC0          |                                        PotatoEngineer

--7BtE0xW96okrVgVt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUulQ8AAoJEFheFHXiqx3kl/cQAKUAHnn7FRGTygyWCmnYDZb2
ElQMh0Uig0om33dl03yR382f3jux4p/6jNnpA74v+Xw9EDCjDo0O/d03jeapXOM5
FJzjpNUz11AaumRkec6LQoLsZXLvUBAlzV4W4R2fScln8nCfh4AEpuCJnLm12iBj
+/A0//RW2AYVbTwxX9/RNo94KvbNR8pitN2Q4DhU4Rdrd6WWmdue3/0dvMYIB3Si
IRQRLEMiQtw3NPTSLTkhPPW9j0cFLLMnbJaPT+rCXd5Lcs9CH7EUMlggLUE+Sgvt
XuS5Jrbmit5U9jzGJpxGlB1olLKF0XqHTE4EIigVJxwAyKo7kw/ZBSOYJvGWhs8K
kD4o+Z0gIXqUmXmA14gxgYi/7lMj38uAFMugLr65qAZpeTJvsUC/QRKql+kTgXoG
/hX7hVe57zKdveimsTuJVberNHo7tHSXavooGWvlm1ZXAFhzPu2tdXpXBY6Vor30
W+B/0M0OnHR+PVh8LNkxx3EawAstNesC9+CHVlk70V0jHKNuGiTHrFqdCITuvTt9
wMcCmU/v2Ic0cMAbgTCISRDDVOuIvuhrkD4qOLb8V/KmRu9NYqteBFadMn/BvIZd
UBJFIodnrtO9uNTcHyVQFJ/UBY55bzrZV5WZoJ5tsJ9P+P5R63PBjnVT8chUZwej
I2JxC+kOrCxnLKN/aj8z
=cfKz
-----END PGP SIGNATURE-----

--7BtE0xW96okrVgVt--
