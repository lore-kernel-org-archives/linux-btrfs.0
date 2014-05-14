Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39144 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbaENJBV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 05:01:21 -0400
Date: Wed, 14 May 2014 10:01:17 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Astro Xe <astroxeu@yahoo.it>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Error in btrfs wiki - "How much space will I get with my
 multi-device configuration?"
Message-ID: <20140514090117.GG23212@carfax.org.uk>
References: <1400057388.37889.YahooMailNeo@web172202.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hTiIB9CRvBOLTyqY"
In-Reply-To: <1400057388.37889.YahooMailNeo@web172202.mail.ir2.yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hTiIB9CRvBOLTyqY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 14, 2014 at 09:49:48AM +0100, Astro Xe wrote:
> The content of the FAQ "How much space will I get with my multi-device configuration?" (https://btrfs.wiki.kernel.org/index.php/FAQ#How_much_space_will_I_get_with_my_multi-device_configuration.3F) is currently wrong. The usable space is the sum of the space of the devices. I'm using multi-device btrfs (data: single, metadata: single or DUP) on kernels from 3.2 to 3.14 and I have never seen the behavior described in the answer.

   It's correct, but for the *previous* question. I'm not quite sure
how that got like that, but I've fixed it now.

   Hugo.

> Please remove this question.
> 
> 
> Thanks,
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- Keming (n.) The result of poor kerning ---              

--hTiIB9CRvBOLTyqY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU3Mw3VheFHXiqx3kAQLFZA//Z/ZuoVRdft3uGJHorAXdIRZm5o9Xil65
7GzEEsX53WRe4YtLuekMC1qCwEguTESVpgAAZoJU9zlkoFLJcyoPW1S3xfAQEooM
Hs3/GnC5z+OitG5k5YJYTse2bZfawAz8Ad3KSjoDeI6MhRgPcvkQp8+dDY4T++NE
FVbY0DNW/PzJyFiXOZdgk3hRgk39ViLP2p8A6BhlSwhLbrX188AQ2aEsR6qwiOT9
cXkXGkVgamvXdXAQ+6SvKvJwo5/WJNmsf98F1qxT4zfDkNfigxjZBkdodvAJ5Hny
/9XznXQmu/uoPula0/nX+9GBL1oORq/Q5SY9YJTp8LTiI3RaP2efwDYGDhYKEZvy
/wJS+hD2I+m+aIyVrAdv9dFIlfuIbQ07NtN7QtcQ2HiQH14eO0JtI0U7Kzr9n7pY
FQTJPJ5qhzZcMrIzycqMTithOpUcTwkEf1ZWJVBkb9KtO9X6na6mIW6gzQauGdfh
NNHyMwdN7cU7hZW1HSGlTs0JrAc0mCf1B4tHxxmcIHl2VvQjUTGRIHrzII7vgQ6R
8ZgzWzrSlVtzw/bE/im5aS9QVwT4tJSqTqf69KGvZoZcnG2rTgFG5e51QtbH9Fvi
Y38+5aF4p37Ef0M5y5BtRomjKLyR6d5aOi3tOHB6mK+LwYwuNrh//1FLm7f8G9iF
835KIl46AgI=
=tL1r
-----END PGP SIGNATURE-----

--hTiIB9CRvBOLTyqY--
