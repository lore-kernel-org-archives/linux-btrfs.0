Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62017 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752644AbdLEJCl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 04:02:41 -0500
Subject: Re: [PATCH 2/7] btrfs-progs: Factor out common print_device_info
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-3-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8c5add20-a4e0-c274-0ce9-db3c50205e06@gmx.com>
Date: Tue, 5 Dec 2017 17:02:25 +0800
MIME-Version: 1.0
In-Reply-To: <1512463189-24724-3-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cAO6t0KhRPRDAxa8uijU24EWhhN82CUls"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cAO6t0KhRPRDAxa8uijU24EWhhN82CUls
Content-Type: multipart/mixed; boundary="XbHe37iPsrw4Jruf6sPE9KLLjLlsn8Vqb";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <8c5add20-a4e0-c274-0ce9-db3c50205e06@gmx.com>
Subject: Re: [PATCH 2/7] btrfs-progs: Factor out common print_device_info
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-3-git-send-email-nborisov@suse.com>

--XbHe37iPsrw4Jruf6sPE9KLLjLlsn8Vqb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 16:39, Nikolay Borisov wrote:
> This function has been copied twice in chunk-recover and super-recover.=
 Factor
> it out into utils.c/h and use it. No functional changes.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  chunk-recover.c | 18 ------------------
>  super-recover.c | 13 -------------
>  utils.c         | 18 ++++++++++++++++++
>  utils.h         |  3 +++
>  4 files changed, 21 insertions(+), 31 deletions(-)
>=20
> diff --git a/chunk-recover.c b/chunk-recover.c
> index 4a6d7141ae80..705bcf52379d 100644
> --- a/chunk-recover.c
> +++ b/chunk-recover.c
> @@ -451,24 +451,6 @@ static void print_device_extent_tree(struct device=
_extent_tree *tree)
>  	printf("\n");
>  }
> =20
> -static void print_device_info(struct btrfs_device *device, char *prefi=
x)
> -{
> -	if (prefix)
> -		printf("%s", prefix);
> -	printf("Device: id =3D %llu, name =3D %s\n",
> -	       device->devid, device->name);
> -}
> -
> -static void print_all_devices(struct list_head *devices)
> -{
> -	struct btrfs_device *dev;
> -
> -	printf("All Devices:\n");
> -	list_for_each_entry(dev, devices, dev_list)
> -		print_device_info(dev, "\t");
> -	printf("\n");
> -}
> -
>  static void print_scan_result(struct recover_control *rc)
>  {
>  	if (!rc->verbose)
> diff --git a/super-recover.c b/super-recover.c
> index 6b80416f976a..6a13d81b0b29 100644
> --- a/super-recover.c
> +++ b/super-recover.c
> @@ -186,19 +186,6 @@ static struct super_block_record *recover_get_good=
_super(
>  	return record;
>  }
> =20
> -static void print_all_devices(struct list_head *devices)
> -{
> -	struct btrfs_device *dev;
> -
> -	printf("All Devices:\n");
> -	list_for_each_entry(dev, devices, dev_list) {
> -		printf("\t");
> -		printf("Device: id =3D %llu, name =3D %s\n",
> -			dev->devid, dev->name);
> -	}
> -	printf("\n");
> -}
> -
>  static void print_super_info(struct super_block_record *record)
>  {
>  	printf("\t\tdevice name =3D %s\n", record->device_name);
> diff --git a/utils.c b/utils.c
> index 524f463d3140..6c0d9fc1bebf 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -2701,3 +2701,21 @@ unsigned long total_memory(void)
>          }
>          return si.totalram * si.mem_unit;       /* bytes */
>  }
> +
> +void print_device_info(struct btrfs_device *device, char *prefix)
> +{
> +	if (prefix)
> +		printf("%s", prefix);
> +	printf("Device: id =3D %llu, name =3D %s\n",
> +	       device->devid, device->name);
> +}
> +
> +void print_all_devices(struct list_head *devices)
> +{
> +	struct btrfs_device *dev;
> +
> +	printf("All Devices:\n");
> +	list_for_each_entry(dev, devices, dev_list)
> +		print_device_info(dev, "\t");
> +	printf("\n");
> +}
> diff --git a/utils.h b/utils.h
> index a82d46f6d7cc..e31ed34426c4 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -171,6 +171,9 @@ int prefixcmp(const char *str, const char *prefix);=

> =20
>  unsigned long total_memory(void);
> =20
> +
> +void print_device_info(struct btrfs_device *device, char *prefix);
> +void print_all_devices(struct list_head *devices);
>  /*
>   * Global program state, configurable by command line and available to=

>   * functions without extra context passing.
>=20


--XbHe37iPsrw4Jruf6sPE9KLLjLlsn8Vqb--

--cAO6t0KhRPRDAxa8uijU24EWhhN82CUls
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlomYKEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjMMAgApJl9C+O5UZDD9BFU8oYvcHOT
8+vEZu4iC8t70oiNj/76Du5VRjlxM4SBPgpGIqA3MDCUX99auiX0qtAc9Rt90q1R
TSB2wDDeUCMJoVVvYdTuiwBS0ITizJqw3A87U4ulv/kvLclhsT4sbmE81CVVVKYh
9P2S56ZNGWxlPqZUSpVxR7LdKgnD6ooGWTUSa2z4J/55TOTHID1VbrRFTtpJRFjk
YUDoAZ1ickHDsReTMT0tpNiR9WD8ylBehEp3wAyxVpRfbpLv3zIO6HmKH3imWy9Z
1FJJr5DDS21HKDjxNd6cckuV0nu6atDXyUJjzFBEnK0koAPdD0/t1wpWySM9GA==
=2oA7
-----END PGP SIGNATURE-----

--cAO6t0KhRPRDAxa8uijU24EWhhN82CUls--
