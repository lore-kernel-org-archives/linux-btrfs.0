Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40608 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaA2IFi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 03:05:38 -0500
Date: Wed, 29 Jan 2014 08:05:14 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can you keep reflink relationship during a copy/backup to
 another filesystem?
Message-ID: <20140129080514.GQ3314@carfax.org.uk>
References: <20140129075025.GM14998@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e2bLSPRkEYxxSNev"
In-Reply-To: <20140129075025.GM14998@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--e2bLSPRkEYxxSNev
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 28, 2014 at 11:50:25PM -0800, Marc MERLIN wrote:
> So I used to use hardlinks to do historical backups of the same filesystem
> but I know it's preferable to use refllink with btrfs to avoid having too
> many hardlinks.

   If you use btrfstune to set the "extended inode refs" option on the
device, then there's no hardlink limit (and the limit was only on the
number of hardlinks to the same thing *in the same directory*).

> But if I need to backup this filesystem to another one some other way than
> btrfs send/receive (let's say cp -a, tar, or rsync), is it correct to say
> that reflink relationships will be lost and my data will take more space?
> 
> That is unless the target filesytem can do deduplication like btrs now can?
> (I haven't tried it yet, but it's about time that I do)

   Correct.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- vi vi vi:  the Editor of the Beast. ---               

--e2bLSPRkEYxxSNev
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUui2OVheFHXiqx3kAQJSPw//QlChw8Ze34M0r/WL9ZCg0jNfkOhBVbzv
TmOp2B9oRSGq6mcZDbAoPPYrtb85EtHgqi5mDIVcW4/+A2L7y/JokUhNFoyhic+F
YirGI2PzFHG74lbfXkA3odvKttvY6mlkUD2sBNbEKwmR0iNzYa0qatvTAlk3/1sk
V6FBFJ2VqNvaCT9ZItYuWwm2ozVEfY46+ZocAGyaTCZo/ExtxCakTfzGb0VZ8x51
EGA8jOMzwYGVES0WSEbPoFAG8+5aDBknCE/edz8J4UWYBhjBbr+e30VkLefrDVAo
NZs8iJ9gVmZjxx1rovm260Rr9BqZrnWZXiejb3W+8XqV2KWdO+cuQT0kdLDin3Z4
wgsqkEV5aQtrJtMF4aTPYzjSlERHkvzlbylkrHW2rWSLC192CquzFWjcwltwhoFg
bYRkT3P70YK8P7KiTsP6eCboO87PZA1H73n/lL7Dpmv55HulnA4Q6z9xMJ0nY9oa
g8VzQy0bPhc1j41b1e7hrMuUlMrO0pX76Ep5TlnsKPQWCvkjXik3XtAaVi3Kd+Cw
eHeYQFMmXyckzXlGh1zSY5y9Z9TKQtjVZhwHpYkL+uhZmLGFtXtllgJr/nqBimO+
ev9dyu4FiLh8SW1Bt+zRUEoRJQ03nWg7OUogZgiyWw/3udjB0Xbi3KJYgnnLogMh
Ree5ITrWtwQ=
=OQzO
-----END PGP SIGNATURE-----

--e2bLSPRkEYxxSNev--
