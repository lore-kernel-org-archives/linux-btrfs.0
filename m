Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57997 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaILKrf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 06:47:35 -0400
Date: Fri, 12 Sep 2014 11:47:32 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: shane-kernel@csy.ca
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 failure and recovery
Message-ID: <20140912104732.GO5783@carfax.org.uk>
References: <000f01cfce67$9e9015f0$dbb041d0$@csy.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GEn4szYucjS2InE7"
In-Reply-To: <000f01cfce67$9e9015f0$dbb041d0$@csy.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--GEn4szYucjS2InE7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 12, 2014 at 01:57:37AM -0700, shane-kernel@csy.ca wrote:
> Hi,

> I am testing BTRFS in a simple RAID1 environment. Default mount
> options and data and metadata are mirrored between sda2 and sdb2. I
> have a few questions and a potential bug report. I don't normally
> have console access to the server so when the server boots with 1 of
> 2 disks, the mount will fail without -o degraded. Can I use -o
> degraded by default to force mounting with any number of disks? This
> is the default behaviour for linux-raid so I was rather surprised
> when the server didn't boot after a simulated disk failure.

   The problem with that is that at the moment, you don't get any
notification that anything's wrong when the system boots. As a result,
using -odegraded as a default option is not generally recommended.

> So I pulled sdb to simulate a disk failure. The kernel oops'd but
> did continue running. I then rebooted encountering the above mount
> problem. I re-inserted the disk and rebooted again and BTRFS mounted
> successfully. However, I am now getting warnings like: BTRFS: read
> error corrected: ino 1615 off 86016 (dev /dev/sda2 sector
> 4580382824)
> 
> I take it there were writes to SDA and sdb is out of sync. Btrfs is
> correcting sdb as it goes but I won't have redundancy until sdb
> resyncs completely. Is there a way to tell btrfs that I just
> re-added a failed disk and to go through and resync the array as
> mdraid would do? I know I can do a btrfs fi resync manually but can
> that be automated if the array goes out of sync for whatever reason
> (power failure)...

   I've done this before, by accident (pulled the wrong drive,
reinserted it). You can fix it by running a scrub on the device (btrfs
scrub start /dev/ice, I think).

> Finally for those using this sort of setup in production, is running
> btrfs on top of mdraid the way to go at this point?

   Using btrfs native RAID means that you get independent checksums on
the two copies, so that where the data differs between the copies, the
correct data can be identified.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- SCSI is usually fixed by remembering that it needs three ---     
        terminations: One at each end of the chain. And the goat.        
                                                                         

--GEn4szYucjS2InE7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVBLPRFheFHXiqx3kAQI5Ng/+KO1qXIooGPSSSjxoOfp5epxUoZCiiJc1
x2jIof8yZTBwpO4crLqEbrf4TtEMCF3LOExvKo3q2xVFIXvAoXpWAiFKoDkaVJPV
sbxNu6cpo6kYpnqLlNN4ExmZZtSrKvI7O/YQRbph68r+LUw+Y5S3cQPKXovggsUn
kPfGv2mi+qlDeP70sAvhsRGvqFMeIbNIiV9oBDabVU0aolwHM3tDtmT8RW6uyYcc
sl9wazgHk4yZmff7j8Ui7IZxmuWWU6qjkDMaC0pRtCn0O5CsVbLaXxcSLEujWZpj
1P8DpKDtHPKSEfJRAtjSIuOrrPZNJwtJkJv2ueyjOE0omxcPk6UcegMNaiGESvkM
Kt2PrJqKFthKxg7b6L/8WJMs8KGQk/sWhObDFF73zxHiKQWZ++NDBwN3MnXzCuDv
cWDJLgXGlmk0ZSi+o3tk1D1tvyaD6f6l1oY8+wGZeYdz6VKXNmCepL/KL++3af+u
pKkQhoy3dvN4a1jgsUdvLjNmrWEfGKJKOkUR9gBzpoGv4Bwhf7iL2gwfaDDbSd1W
421h2UDInRaKW7u7MwW89d59274VcB1lgnZkkPXEmf1A+bdHqLjtNQ5VW7nQqbx4
PtDMyx4p3B20LmO/Fd1i5e0tvQj4nJZ5g9nmlyvjhxaZbzuYCS810504HRvV/7CH
+sZ1ah+uCqs=
=W/Fd
-----END PGP SIGNATURE-----

--GEn4szYucjS2InE7--
