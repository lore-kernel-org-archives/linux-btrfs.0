Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50907 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbaHFK3Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Aug 2014 06:29:24 -0400
Date: Wed, 6 Aug 2014 11:29:19 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: fix compressed write corruption on enospc
Message-ID: <20140806102918.GA3968@carfax.org.uk>
References: <1406213285-19607-1-git-send-email-bo.li.liu@oracle.com>
 <1537782.AGn1dfcASJ@merkaba>
 <234528786.A5cAeyBFJU@merkaba>
 <3143412.n5KSJct7YP@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
In-Reply-To: <3143412.n5KSJct7YP@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 06, 2014 at 12:21:59PM +0200, Martin Steigerwald wrote:
> It basically happened on about the first heavy write I/O occasion after
> the BTRFS trees filled the complete device:
> 
> I am now balancing the trees down to lower sizes manually with
> 
> btrfs balance start -dusage=10 /home
> 
> btrfs balance start -musage=10 /home

   Note that balance has nothing to do with balancing the metadata
trees. The tree structures are automatically balanced as part of their
normal operation. A "btrfs balance start" is a much higher-level
operation. It's called balance because the overall effect is to
balance the data usage evenly across multiple devices. (Actually, to
balance the available space evenly).

   Also note that the data part isn't tree-structured, so referring to
"balancing the trees" with a -d flag is doubly misleading. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- You know... I'm sure this code would seem a lot better if I ---   
                         never tried running it.                         

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU+IDflheFHXiqx3kAQIo7BAApmn8KRu8J1UpC1+cwvJngHfxhQT9yXSS
RDH2DJy7IwOKYcqTxJUYOYy1o687ZTFStltrEdCftK6QNLSPkJOECo7dWt70yXVv
zDyQYmjngFbvicrtSrviM5d1ITEOHquerGLkiS1Km400GHKG6dno8KJaQcLd8VD7
oS6efvgA+tONQFHwzt4F1wg84IXf8CcUVCAB7zx7klZxTIHQNvs+85GpzKJau5w6
h5Php71YngmiJj3hzPnuCnvTmrDPBfXVr+zqHeJ2PygKgXFcnXf8Rnug5uxHl8Oc
o38b+FIeWoUBfhhhPfwMsBzxfNo6OhyIHmgOio/Hl6aZDI4CKncKLZtDNUCjZzlI
X4ZLUR+709MLG8q4frEAE+uxp4CbGzhgqDSf64Imdtb8TBSyUw6Nu75ea8Toj6DL
+OonY85Ao94baa26Dik5oJv+CWKMOzZ9FLSHp3MddEALWmV2NORriCJMksDGWkiM
txftQ2a/PYwcIt5XvQpMwsN7/1zHqYLacJhMOC2bZ4wMHQIstY22O3nXHrDVLcV3
zl4107trnScev1DBtyBxbkmsH6HjyOn/7auWxObLHUAvjZrZsdgyVcXkI2jtfb+Q
Q/WwEwwZKsPZx2AG+41Rjaf3Q2pRdyAuIbmfkqOKEbTJtZ4/2eRu8RySStvYIs8F
mABXwxVy3E4=
=q3R6
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
