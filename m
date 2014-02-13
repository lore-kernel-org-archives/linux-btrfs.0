Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43484 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaBMT54 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:57:56 -0500
Date: Thu, 13 Feb 2014 19:57:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Possible to wait for snapshot deletion?
Message-ID: <20140213195732.GY6490@carfax.org.uk>
References: <jfhvsa-unf.ln1@hurikhan77.spdns.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m8yuz6kcWj4yJ5vq"
In-Reply-To: <jfhvsa-unf.ln1@hurikhan77.spdns.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--m8yuz6kcWj4yJ5vq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 08:02:43PM +0100, Kai Krakow wrote:
> Hi!
> 
> Is it technically possible to wait for a snapshot completely purged from 
> disk? I imagine an option like "--wait" for btrfs delete subvolume.

   I'm sure there's been some patches for that around here somewhere,
some time ago. I guess they didn't get merged.

   Hugo.

> This would fit some purposes I'm planning to implement:
> 
> * In a backup scenario have a subprocess which deletes snapshots one by one,
>   starting with the oldest. If free space raises above a certain threshold,
>   pause the subprocess. If number of kept snapshots falls below a certain
>   threshold, exit the subprocess. When the backup job finished, it joins the
>   subprocess to wait for a pending subvolume deletion if any, then syncs the
>   filesystem and waits some grace time for uncommitted writes, then shuts
>   the system down or hibernates it.
> 
> * Wait for pending background subvolume deletion before putting the system
>   to sleep.
> 
> * Get better control of cron jobs working with subvolumes so jobs either do
>   not overlap or do not put too much parallel work on the file system.
> 
> Scrubbing does allow that. Why don't snapshots do? At least I found no 
> options for it.
> 
> Background information: If btrfs is shut down improperly, already deleted 
> subvolume entries may reappear in their directories. The deletion is not 
> gracefully resumed. Since deletion of subvolumes/snapshots can take hours, 
> this is a problem for systems that are not guaranteed to be up all the time 
> or suffer from disconnected power, especially if multiple snapshots are 
> being deleted at once. With an option to wait, a script managing snapshot 
> deletion could more gracefully resume its job.
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Gentlemen!  You can't fight here! This is the War Room! ---     

--m8yuz6kcWj4yJ5vq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUv0jq1heFHXiqx3kAQI2yhAAsFkMRPFkb5A7WMiOTJsy/ds/JG+n6wKk
+qPGl7L1qCtPjVRqISPuK+x5jhZF09z8rMClhydnOd1M1WYqK171xWQ1nVXJzUkb
AUeFw4NJ5OfwjlrKx7Q8NX4SAu2cvtR51++D/1fqzNDBJfFDmUCI/uNCsS/0J4kL
LT6+AfbCspir/HbD5mxyWxpK9QzIOK1t1phmreWnUDbH7qiW22X80hBwPkTqsweK
l6joTybiqcwuaKYrG6CY4jX1kY5vApWVQWZdEl0PjPbA/WGlsvTFtUPeYpi35Cq1
OtRvnK3uvSyRsGtiWrp28qMndtOLdLuMPTpurIHYvBkM6yPyO2XaiR7ixeHwrWEC
/VyTQyJTZ2X/QKoDrHc5ZYYeAS1T8UMZZ/jNS/rD3SjbHbtn1bb4BXE98oXn+OQy
kqAUzsWUSD+hfr3Rc7I0I1VEwDSNX6ALDEjEoPyfl/XnecofOOqPR7VFJdDrPFpy
Minsr6X2BM0GJhLmaZnpMMmFW8H1CvtF164KXkE7lkIDdQJ4E1heeylbaEcJT7r9
Pmj+IeERmfzLJVbAJEeKRYY2G72Z/XyiBBwnyStCJq7ZWz4gPf/LzPgJMSwenD3b
Ie9DIbSn8YSyb66cSIrtvIDDa/3Gnt+rvxrn28Bquyzhp2DMT0Mx1COAW6JFhh4G
w9IkirkyynE=
=RI8P
-----END PGP SIGNATURE-----

--m8yuz6kcWj4yJ5vq--
