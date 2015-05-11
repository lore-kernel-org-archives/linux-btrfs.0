Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59549 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbbEKUNf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 16:13:35 -0400
Date: Mon, 11 May 2015 20:13:33 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: raid 5 and different device size
Message-ID: <20150511201333.GQ18480@carfax.org.uk>
References: <55510B14.7090204@friedels.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SvyA5ywaG/v2A5dH"
In-Reply-To: <55510B14.7090204@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SvyA5ywaG/v2A5dH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 11, 2015 at 10:03:32PM +0200, Hendrik Friedel wrote:
> Hello,
> 
> I need your advice for the following scenario:
> I do have three -identical- 3TB HDD. On these I store:
> -Backups (Images of my Families Laptop; Backup of the Machines (the
> one with the HDD) running System).
> -Videos (recordings, not essential)
> -HomeVideos (Familiy, essential)
> -Photos
> -Documents
> 
> Now I intend to:
> * increase the available disc space
> * stop worrying how much space is available on which drive
> * create redundancy
> * have low operating cost (power-consumption)
> 
> 
> So, I need to buy one additional HDD.
> And I want to combine the drives to one big volume.
> 
> I am aware that raid is no backup.
> Thus, I backup the HomeVideos and the Photos on an external drive
> not connected to the power supply and USB.
> 
> I think, that I do not need raid5, depending on the definition of
> 'not essential'. Nevertheless, raid5 would efficiently (at low cost)
> decrease the likelyhood of loss of the 'non-essential' data.
> Furthermore, raid5 would fill the gap that I have between backups
> (the fact, that I do these backup manually means that I do not do
> them every day) and at least safe me from hardware failures.
> 
> So, yes, I think I do want raid5 and I want to combine.
> But what size of HDD do I want to buy? The best value (cost per TB)
> I get for 3TB drives. So I could by two 3TB drives, one for
> additional space, the other for the parity information.
> Or I could by one bigger drive, with potentially lower power
> consumption. But how would the raid5 look in this case? I fear, only
> 3TB of the 6 would be redundant and the other 3 would be not
> redundant, right?

   No, 3 TB of the new drive would be usable, giving you a grand total
of (4-1) * 3TB = 9 TB of usable space on the array, with 3 TB of raw
space unusable (the remainder of the 6 TB device).

   http://carfax.org.uk/btrfs-usage may be helpful to you here.

> Now the last point: Power consumption: Under which conditions can
> the drives spin down in case of raid5? I assume that all drives have
> to run as in case the data is written on any one of the drives,
> right?
> Is that also true during reading of data, i.e. is the parity also
> checked for read operations?

   Parity is spread evenly across all devices, so a read of more than
a trivial quantity of data would almost certainly spin up all devices
anyway.

   Hugo.

-- 
Hugo Mills             | A gentleman doesn't do damage unless he's paid for
hugo@... carfax.org.uk | it.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                            Juri Papay

--SvyA5ywaG/v2A5dH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVUQ1tAAoJEFheFHXiqx3kuKAP/jTp/yNMFJ+qCq/eb6HrwKcv
tqsChNRUqQLZ1eavuQoVWi9fkpM+LWiJgt9dSSQ8nekqHlU/sd5u3q5v8AKBfzT/
SNTQ9qHe5fn36AULe/rP8Cx533tElzS70g0yUS6gTRxNwfMktoeGUJ7ogfU4kXm6
Hve+0Nrq/AQ38dYeskB6gmBeTpYEnTvw4dgVwOI+7fzZbARh7ECd1zo1xM/OcVi7
9MH3gDmXE7uCF7fbuINSovokcGyCKM+RBjt+v1KkBNIkIlt4j9QjavL/L+N1zl+x
tXb6Ocs1IHJ+EE0BVsPA7EEzv9oMCXpjdcJVUJOeV4ECXYlPhBdc0QBgBSyE7Ys1
Tg6ez0UjvkvlDscvZRWwjLw20MKjsNEfVyBd0jF82x5L5UMhPVTzhb7Nu6OUKw20
rfWoZXrfn5KAAY8lFewRdkNPFyQWidu/ozs0cPxvqHTlniHkN9nugJTJIaNcrqF6
0vqJeo08c2X06K6I/11YZVLJbGquUhESRIvh/9n+asj6rmgwqcltFFMs8P016jBV
gQn0VLiJ59lIvIBIer5GPGb4pGlcLBkocI6KqIy1/DtB0pGaPp/R+5TG1FTFfcyg
r6gLK7JzftyoFcTzdQburOPnY8ztTVHTRoFrFPZEr9vNcZs4vMDmVBSfZ3Zl3NMT
0i17frI1ogZP8iKAEjp6
=ga0N
-----END PGP SIGNATURE-----

--SvyA5ywaG/v2A5dH--
