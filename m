Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47754 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbbEFRtE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 13:49:04 -0400
Date: Wed, 6 May 2015 17:49:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Neal Becker <ndbecker2@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs device scan returns nothing?
Message-ID: <20150506174902.GL18480@carfax.org.uk>
References: <midjtt$s4f$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Jbyekxk18hnEXT0m"
In-Reply-To: <midjtt$s4f$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Jbyekxk18hnEXT0m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 06, 2015 at 01:44:29PM -0400, Neal Becker wrote:
> What am I doing wrong?
> 
> sudo btrfs device scan
> 
> Scanning for Btrfs filesystems
> [silence]

   Nothing wrong -- that's what it's meant to do.

   It tells the kernel about the filesystems it finds, not the
user. If you want to do a scan and show the filesystems on the current
machine, btrfs fi show is the tool you need.

   Hugo.

> But I'm running on btrfs now:
> 
> --- /etc/fstab
> UUID=7246327b-1905-4fe2-9b6b-b9376017264f /                       btrfs   
> subvol=root     1 1
> UUID=2c04be93-34c1-4016-ba41-60fd9fd90616 /boot                   ext4    
> defaults        1 2
> UUID=7246327b-1905-4fe2-9b6b-b9376017264f /home                   btrfs   
> subvol=home     1 2
> ...

-- 
Hugo Mills             | We don't just borrow words; on occasion, English has
hugo@... carfax.org.uk | pursued other languages down alleyways to beat them
http://carfax.org.uk/  | unconscious and rifle their pockets for new
PGP: E2AB1DE4          | vocabulary.                           James D. Nicoll

--Jbyekxk18hnEXT0m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVSlQOAAoJEFheFHXiqx3k/6sQAJ14yiYQqIs1Go3TY/PUZlpC
16G6TdkRMySh/TxZoloT6FohbfxjFrWb+LZaTaRBcb0XAtO/YRX0y4T45JceDxOs
+SPYXiJgou3cvpaxjeIAHAdFzF5aE5VZIiiSO1B+ZhxEqibhImwiivuGiStuKpmT
lJ3PYG6cr8wOWd46codsqjFjPCQ9/oHmTIsZhBfYHwNmUUC3tDiVrs0DOFyDLtqE
akOweiW2MhAmJ+hMjO7koud5Exsm4HMqX2EeU7KEN3TlE43GdYzDjsGZ4RhEfQ3T
1HhosaHLj0l96TJFJnaag9SVwel1GXPvAsYhKIPWJUR7A7HCUNjj0WcEbkv1ZnXD
oCRsGmoKiaagGffC9+oLOVsPw7l12+rg/CEMukLJlJYq37RdlSoJaVCoFIEzUvso
15k7f+44qcBvijO5/tTmwLvpichp2jnImL/Cj3b7tHvc3QIi5KmgNccfI6bU+F4W
EL6hTaIYpdhxJqcBdCKpes2udkHH1tlADAwiftmkcoBrLMSNSVH5qjIpRMKNOVOl
EPeqpdyBVXL/8Hpcq0vEHwwgXqwDE0D2gIOx7X/eYWwnkoULL3vpBxMzFlNJeN2g
WNy87/UHVp4cut3hxEzUpUrfJqD76crZelOiKlMIrSom0cYiXG+pnLG9KLFd5kym
WSYT3zkgpn+HzGqOCMXf
=V8Fe
-----END PGP SIGNATURE-----

--Jbyekxk18hnEXT0m--
