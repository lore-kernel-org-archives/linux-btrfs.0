Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:40388 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753240AbdJaF6W (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 31 Oct 2017 01:58:22 -0400
Subject: Re: [PATCH] btrfs-progs: ins: print c/o/s/r time of ROOT_ITEM
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <8bccc1fc-c8bb-9999-dbb7-94185ba5d7e8@jp.fujitsu.com>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <d5c0fff9-4373-5405-dc09-be33df7f62f2@suse.com>
Date: Tue, 31 Oct 2017 13:58:04 +0800
MIME-Version: 1.0
In-Reply-To: <8bccc1fc-c8bb-9999-dbb7-94185ba5d7e8@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uiPFqHNmwuPXFOatXNlnRUgv4nHLlsGIO"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uiPFqHNmwuPXFOatXNlnRUgv4nHLlsGIO
Content-Type: multipart/mixed; boundary="JaKt7Ohb8qkX9J7mwMG0pq8qAIUN4Mg1I";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <d5c0fff9-4373-5405-dc09-be33df7f62f2@suse.com>
Subject: Re: [PATCH] btrfs-progs: ins: print c/o/s/r time of ROOT_ITEM
References: <8bccc1fc-c8bb-9999-dbb7-94185ba5d7e8@jp.fujitsu.com>
In-Reply-To: <8bccc1fc-c8bb-9999-dbb7-94185ba5d7e8@jp.fujitsu.com>

--JaKt7Ohb8qkX9J7mwMG0pq8qAIUN4Mg1I
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8831=E6=97=A5 13:40, Misono, Tomohiro wrote:
> Currently c/o/s/r time of ROOT_ITEM is not printed in print_root_item()=
=2E
> Fix this and print them if the values are not zero. print_timespec()
> is moved forward to reuse.
>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  ctree.h      | 32 ++++++++++++++++++++++++++++++++
>  print-tree.c | 52 ++++++++++++++++++++++++++++++++--------------------=

>  2 files changed, 64 insertions(+), 20 deletions(-)
>=20
> diff --git a/ctree.h b/ctree.h
> index 2280659..54a85fd 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -2072,6 +2072,38 @@ BTRFS_SETGET_STACK_FUNCS(root_stransid, struct b=
trfs_root_item,
>  BTRFS_SETGET_STACK_FUNCS(root_rtransid, struct btrfs_root_item,
>  			 rtransid, 64);
> =20
> +static inline struct btrfs_timespec *
> +btrfs_root_ctime(struct btrfs_root_item *root_item)
> +{
> +	unsigned long ptr =3D (unsigned long)root_item;
> +	ptr +=3D offsetof(struct btrfs_root_item, ctime);
> +	return (struct btrfs_timespec *)ptr;
> +}
> +
> +static inline struct btrfs_timespec *
> +btrfs_root_otime(struct btrfs_root_item *root_item)
> +{
> +	unsigned long ptr =3D (unsigned long)root_item;
> +	ptr +=3D offsetof(struct btrfs_root_item, otime);
> +	return (struct btrfs_timespec *)ptr;
> +}
> +
> +static inline struct btrfs_timespec *
> +btrfs_root_stime(struct btrfs_root_item *root_item)
> +{
> +	unsigned long ptr =3D (unsigned long)root_item;
> +	ptr +=3D offsetof(struct btrfs_root_item, stime);
> +	return (struct btrfs_timespec *)ptr;
> +}
> +
> +static inline struct btrfs_timespec *
> +btrfs_root_rtime(struct btrfs_root_item *root_item)
> +{
> +	unsigned long ptr =3D (unsigned long)root_item;
> +	ptr +=3D offsetof(struct btrfs_root_item, rtime);
> +	return (struct btrfs_timespec *)ptr;
> +}
> +
>  /* struct btrfs_root_backup */
>  BTRFS_SETGET_STACK_FUNCS(backup_tree_root, struct btrfs_root_backup,
>  		   tree_root, 64);
> diff --git a/print-tree.c b/print-tree.c
> index 9d1b862..62f3163 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -551,6 +551,26 @@ static void root_flags_to_str(u64 flags, char *ret=
)
>  		strcat(ret, "none");
>  }
> =20
> +static void print_timespec(struct extent_buffer *eb,
> +		struct btrfs_timespec *timespec, const char *prefix,
> +		const char *suffix)
> +{
> +	struct tm tm;
> +	u64 tmp_u64;
> +	u32 tmp_u32;
> +	time_t tmp_time;
> +	char timestamp[256];
> +
> +	tmp_u64 =3D btrfs_timespec_sec(eb, timespec);
> +	tmp_u32 =3D btrfs_timespec_nsec(eb, timespec);
> +	tmp_time =3D tmp_u64;
> +	localtime_r(&tmp_time, &tm);
> +	strftime(timestamp, sizeof(timestamp),
> +			"%Y-%m-%d %H:%M:%S", &tm);
> +	printf("%s%llu.%u (%s)%s", prefix, (unsigned long long)tmp_u64, tmp_u=
32,
> +			timestamp, suffix);
> +}
> +
>  static void print_root_item(struct extent_buffer *leaf, int slot)
>  {
>  	struct btrfs_root_item *ri;
> @@ -600,6 +620,18 @@ static void print_root_item(struct extent_buffer *=
leaf, int slot)
>  				btrfs_root_stransid(&root_item),
>  				btrfs_root_rtransid(&root_item));
>  		}
> +		if (btrfs_timespec_sec(leaf, btrfs_root_ctime(ri)))
> +			print_timespec(leaf, btrfs_root_ctime(ri),
> +					"\t\tctime ", "\n");
> +		if (btrfs_timespec_sec(leaf, btrfs_root_otime(ri)))
> +			print_timespec(leaf, btrfs_root_otime(ri),
> +					"\t\totime ", "\n");
> +		if (btrfs_timespec_sec(leaf, btrfs_root_stime(ri)))
> +			print_timespec(leaf, btrfs_root_stime(ri),
> +					"\t\tstime ", "\n");
> +		if (btrfs_timespec_sec(leaf, btrfs_root_rtime(ri)))
> +			print_timespec(leaf, btrfs_root_rtime(ri),
> +					"\t\trtime ", "\n");
>  	}
> =20
>  	btrfs_disk_key_to_cpu(&drop_key, &root_item.drop_progress);
> @@ -858,26 +890,6 @@ static void inode_flags_to_str(u64 flags, char *re=
t)
>  		strcat(ret, "none");
>  }
> =20
> -static void print_timespec(struct extent_buffer *eb,
> -		struct btrfs_timespec *timespec, const char *prefix,
> -		const char *suffix)
> -{
> -	struct tm tm;
> -	u64 tmp_u64;
> -	u32 tmp_u32;
> -	time_t tmp_time;
> -	char timestamp[256];
> -
> -	tmp_u64 =3D btrfs_timespec_sec(eb, timespec);
> -	tmp_u32 =3D btrfs_timespec_nsec(eb, timespec);
> -	tmp_time =3D tmp_u64;
> -	localtime_r(&tmp_time, &tm);
> -	strftime(timestamp, sizeof(timestamp),
> -			"%Y-%m-%d %H:%M:%S", &tm);
> -	printf("%s%llu.%u (%s)%s", prefix, (unsigned long long)tmp_u64, tmp_u=
32,
> -			timestamp, suffix);
> -}
> -
>  static void print_inode_item(struct extent_buffer *eb,
>  		struct btrfs_inode_item *ii)
>  {
>=20


--JaKt7Ohb8qkX9J7mwMG0pq8qAIUN4Mg1I--

--uiPFqHNmwuPXFOatXNlnRUgv4nHLlsGIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAln4EO0NHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qFnZB/oCyvcTCCO2zn4iUjwcYW5qTc0/1lxw078aEZ6j
1mG5oWfn/mxWFTp4ifrvM+lYKV5HGYrpsK7wb3hMKStzc2FyXjSuVfo5iXlwZL+O
NpuaTpI7M7bEeXCNzEXMi4D8Lz/g8KsaK7bkDOc2wZuFQwWvGUGMwoCDjnkH4OKc
rbeJ6gYRtRs2iPBatNx9+0kBAWaK5A9/fp1xB01MgcWEIqzAQILWDrPkeJEvvu4Z
ldkb213WCZSJzRE+5+nu7Bu5QD6Jg87HhoXpnhSaoc3TFhQuZmo4mq39jAhPVprd
d1qXY7EdVa7TTT6s32wNO5NKzS/yiUbQJ5QrAsUtV5ZMfsse
=C13U
-----END PGP SIGNATURE-----

--uiPFqHNmwuPXFOatXNlnRUgv4nHLlsGIO--
