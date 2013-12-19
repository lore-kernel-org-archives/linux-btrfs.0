Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42662 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3LSITP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 03:19:15 -0500
Date: Thu, 19 Dec 2013 08:19:08 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: ioctls would need unique id
Message-ID: <20131219081908.GO11281@carfax.org.uk>
References: <1387425992-15268-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DITGHUV3p5DjDsXt"
In-Reply-To: <1387425992-15268-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--DITGHUV3p5DjDsXt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 19, 2013 at 12:06:32PM +0800, Anand Jain wrote:
> BTRFS_IOC_SET_FEATURES and BTRFS_IOC_GET_SUPPORTED_FEATURES
> conflicts with BTRFS_IOC_GET_FEATURES
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  include/uapi/linux/btrfs.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 7d7f776..0fe736e 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -634,9 +634,9 @@ struct btrfs_ioctl_fslist_args {
>  					struct btrfs_ioctl_fslist_args)
>  #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
>  				   struct btrfs_ioctl_feature_flags)
> -#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
> +#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 58, \
>  				   struct btrfs_ioctl_feature_flags[2])
> -#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
> +#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 59, \
>  				   struct btrfs_ioctl_feature_flags[3])

   The ioctls are distinct as tehy are, as they have different-sized
parameters. Changing these numbers is changing the public interface,
which is a big no-no.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- I think that everything darkling says is actually a joke. ---    
         It's just that we haven't worked out most of them yet.          

--DITGHUV3p5DjDsXt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUrKr/FheFHXiqx3kAQIMJhAAhHBYhqAGn+3xcr/YlRp+Z0Nwu9v3VOz4
QWO+WYxVo5cC6/wPRGFVPJUr9HvOtSA6s0IAs0Oc8pKWeoxUutkVJtWyAByZjn/+
2Ufs3JKi9Z/blnMmdIwCfp6rQFqIZEkKJeFKhf+oWlRO2OOutyzsDqg4nHoh1l8T
1erradOiEnVehFW4ZJ3+nkUTcV5LkwVx7666UwSV50egX92duI7nyfnavbbOtcl1
o/0lhTTGhN/FebbNVY+mGyHaj3ihze9BcmdQppMUPEnc5ZusLKJ2J4nGMVc3g+uV
26clOTryq/letkVFqwgwUgCKzxd1BlASMXIrfY2vLUN7pDbb7NPR0COO6Vqwjs0j
xrV6YtlRjrp0wUtWCiAg09ePHf584Wln3OyLBgxwlmBNEiCTyqQPEkpB585ouMaI
YwMg56ITpiXu99/e5/opq2qOp1JszbkjkDu//Cch+n+twPZCwGqsn1iie66WAxI3
QU0Dj4CIkVOqBIYOhe8PQWdJ+eaL3Dh11ECd9jWSgumlS0oF+ggCVB3l1UqJdWap
UQLsZK3V7aOZQeB/klYtaVs9IMnk9or1GYY6Hse8Ql8oCEr1kIPDCKO//S1+SdJj
t5YHxq9ihwOrnsYJUIcgClkcENNehWrwvcmp4AYmKSr5HTqEf/Scrv94XBu5zJ4f
BW11Ig9IbZw=
=1uN6
-----END PGP SIGNATURE-----

--DITGHUV3p5DjDsXt--
