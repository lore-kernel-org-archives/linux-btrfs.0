Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59802 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3JTQxm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Oct 2013 12:53:42 -0400
Date: Sun, 20 Oct 2013 17:53:36 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: lilofile <lilofile@aliyun.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: question
Message-ID: <20131020165336.GD6598@carfax.org.uk>
References: <1c7f1ff8-7161-4e67-9acc-eb5d4b8b965d@aliyun.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TybLhxa8M7aNoW+V"
In-Reply-To: <1c7f1ff8-7161-4e67-9acc-eb5d4b8b965d@aliyun.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--TybLhxa8M7aNoW+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 20, 2013 at 11:19:26PM +0800, lilofile wrote:
> 
> when i read transaction_kthread function in disk-io.c 
> 
> delay = HZ * 30;
> 
> why commit transaction is 30 seconds,  Other values 20 seconds,10 seconds?
> what considerations about the commit transaction interval?

   It's a more or less arbitrary number. There's been a patch recently
(last couple of months) to allow modifying the value. If you make it
too large, you end up using lots of RAM for unflushed changes, you
risk losing those changes if the machine crashes. If you make it too
small, you end up writing lots more metadata, because that's always
changing as the FS is modified.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- There are three things you should never see being made: laws, ---  
                        standards,  and sausages.                        

--TybLhxa8M7aNoW+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUmQKj1heFHXiqx3kAQK5vg//STmkfwwMKN0uNd7TuS6zJLFHvSTcXZj7
hZnFywQbyyKnISPfzws3RgUgTC+ePgFAUlEJWX44xhv64mumIJ+FSlRjZg2TYeyb
x63Cft7cx5YU6on8xq67eYuKrEhCZiMnXUADbTroS8gG9CciMt07AMXn4UAhBNLF
ObB4sT/74HzTIcaILj5TMAymogyxGblFU/HlODP3tS8H7QbHzxoOTAi3LjFE2ahJ
aO/kehaqfqXUa6r4EE0SRoKUscLun+Up+V97A+UsLdARY7UFANUb6QdKl4Ovd8YY
k4WquqlgAgen7tHgUbtgUIm8dT4bdJjO0AoCVzss1866SlXjD5tS4zV/Jf37LVvk
yktJ0+Ri5pnp/GE6gOEJbtyEAnCUabH21X6fJhC0do34U87AO0iZaZlFQAPP7AR5
zaGnRKmDzKMfgsaehup5w9iPoT7Wn9jU1n0ZDMIfb51zpDNymuNNf30qvFG5Uzha
PQz3pAxtewcFkW8h5VEKz/gxNR2oDRM0LP/egHiihGAcPANcJoRuN0a1FdiCd6b/
GXy0fESkhzB2aK7pQ6P3FYLC/okJVPOns4qQkJD7gOcrcXPen3CnACUv7n5iYvci
IIKDpvjczqhhit7lM4UUzKurCi9DLiTjqy5j+j7xXXkFaN9+9v9EoV9HySuah5HG
U1qkqfvpNws=
=9MBZ
-----END PGP SIGNATURE-----

--TybLhxa8M7aNoW+V--
