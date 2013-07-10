Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54992 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GJQQ1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 12:16:27 -0400
Date: Wed, 10 Jul 2013 17:16:23 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, zab@redhat.com, wangshilong1991@gmail.com
Subject: Re: [PATCH] btrfs-progs: per-thread, per-call pretty buffer
Message-ID: <20130710161623.GJ5445@carfax.org.uk>
References: <20130709202443.GJ18717@lenny.home.zabbo.net>
 <1373466615-30013-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rmUrFcWP4LYae1gV"
In-Reply-To: <1373466615-30013-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rmUrFcWP4LYae1gV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Sorry to be a pain in the arse at this late stage of the patch, but
I've only just noticed.

On Wed, Jul 10, 2013 at 04:30:15PM +0200, David Sterba wrote:
>  static char *size_strs[] = { "", "KB", "MB", "GB", "TB",
> -			    "PB", "EB", "ZB", "YB"};
> -char *pretty_sizes(u64 size)
> +			    "PB", "EB"};

   These are SI (power of 10) prefixes...

> +void pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
>  {
>  	int num_divs = 0;
> -        int pretty_len = 16;
>  	float fraction;
> -	char *pretty;
> +
> +	if (str_bytes == 0)
> +		return;
>  
>  	if( size < 1024 ){
>  		fraction = size;
> @@ -1172,13 +1173,13 @@ char *pretty_sizes(u64 size)
>  			num_divs ++;
>  		}
>  
> -		if (num_divs >= ARRAY_SIZE(size_strs))
> -			return NULL;
> +		if (num_divs >= ARRAY_SIZE(size_strs)) {
> +			str[0] = '\0';
> +			return;
> +		}
>  		fraction = (float)last_size / 1024;

   ... and this is working in IEC (power of 2) units.

   Can we fix this discrepancy, please? Also note that SI uses k for
10^3, but IEC uses K for 2^10. Just insert an "i" in the middle of
each element of size_strs should deal with the problem.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Charting the inexorable advance of Western syphilisation... ---   

--rmUrFcWP4LYae1gV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUd2I1lheFHXiqx3kAQJGVw//bOud+XgnuPzwFW3urun7SmmU4VVYgg/f
sWl7sAGgdgFfXYABIh6TvXCqOKh5QIK4g52eVWWJk50euZyXUM+Bq1kLIE6YurDS
Ux2ywPsGwlpWfJ1maq1kwZWtv6FM7oBg+KZIZpqo9rbXNfb89Ocy2ZJA9+f6zWsT
HxOncZJsfp1iRYoF6kR3CdIPg1q1g2bqb/88IhToys/wDH6ahWz2/RC0rd2D4Ncw
4Khf4CdM/wL4+OSZCw4DWLkNFKHULkXN+Di0ww1QELt1tq/yDX0sfD8YxaGXEK4A
snMVzVzynuj5uuGBSjzyvwZNBaM0Uogd4yJy2OyAWsyGmXyg7cGQP86Qc1Riq/6/
s+5ns3+w3N2wychiwQoif0RUrxQNobZMv41/2XmcjoY4walrVyIT0a2KpO5yTufy
OiKYF2AMUJW0Fertz4z5cOCbEOxk760MkkvmPtcgm87h53okG0Rk7BJp5V2MGwv4
Sau39zrOuUmSQBBd394pvSs88vP7JJcFAEUrsjSNaUTiyIwVHkXiyKZosHACuuKO
vz8lS9rvsKIP+/8Mmxw03rE1RARDwI4VTdjwiBo40KomdUNKdILpiyhy8W+F2XK9
LPwRL0mG1u+7xcrAvd9HwkWSEvvDDH4su4sW8HSCHimaiJgtz2p0V5NXjgUct7NI
85wa4P6lsvw=
=G9Oz
-----END PGP SIGNATURE-----

--rmUrFcWP4LYae1gV--
