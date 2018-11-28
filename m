Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DACAC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CECF2086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:36:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0CECF2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbeK1Mfz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 07:35:55 -0500
Received: from mout.gmx.net ([212.227.15.15]:59959 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbeK1Mfy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 07:35:54 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M3RVA-1faods0gXQ-00r1ZQ; Wed, 28
 Nov 2018 02:36:01 +0100
Subject: Re: [PATCH 9/9] btrfs: drop extra enum initialization where using
 defaults
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
 <932e555ce5dff2ec978bf1d21a4ef1d8d5e7ccfd.1543348078.git.dsterba@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <efea97ef-f7e8-eb43-b5b6-212b0bae8cb4@gmx.com>
Date:   Wed, 28 Nov 2018 09:35:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <932e555ce5dff2ec978bf1d21a4ef1d8d5e7ccfd.1543348078.git.dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="79BAnNAuU7xSDvxKkFhflM03NWaiCfRtX"
X-Provags-ID: V03:K1:SmRsPxeAZFiQHJGb7PXiWwuMQ8DykPfjmJ0PdZzXKOp9pSDadFK
 WAUVNV6HurEaYB3j1K95b4j4BL7cfwc8p44/BiMLhmcpcHaYJBMVzfy448/lI4V4zW+x4GW
 vER/Zsa0Vg3WHuWYyAE6W8j/rfS5Y6ynd8FD/nmQ/m9xD728ZvpcXSLdRU8jRlLyKJnM7+x
 52RYBkJwbUpVc7A32Yhxg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:UPKX1B7WTzo=:rfkWpJEe6hdXjwwKNlyrQ8
 TXzRR66q7xcN0mgfrtS3giB1yu/ryl1pcYfiDmkB8Rx+xLUw02N9IRhkDVUF9ynkg27fXYHBF
 IVylcNajnTX2iD4onaisuyTgoHRcWLioteLcnO43k3QnrS09DaohpTN+fMNhqdFrGgODEC+4L
 ochOezPs44lXqvHJFULXmsl6nxZZwHlIdZp3Kl/bED0S1ptR2EwFF9Dxl6C1J5FG4YZ3zB7dL
 gpx2irAQc26xcTcYmdsWO8vyACCiiF72TnqBV0HZd3Ev8U7AAHOijFshtTmuKgZ/s0otGI0Yk
 EYGqi9W7YzZvSureKBEj5SYkRx9B+J+RV+f+BrhFYDq8ZAEt2GFkErWDGl5Z1HZGt1YhXIRVG
 oU0M2NtzMX9jNcuXEQ4VCsPdmC6bG47N131VK0iRFB1lPFf7usacTlsDmC6DVKnjlMNPmh/O0
 TcyqnRfUE6j88c/AcHo7w9xU57jKK0nZGWzqUIqRMqYillag5cK2S5zgHFD7KK5fioOjdusxc
 Bc6wogw1wlscNn2jXsJQqd8OTOgur1xqW3uAPVhlPsE/iLt8hOl3jhJ86kzfrK5T/eJ3WbB//
 6/Gd40hCaZ1/wGofzXF/A8AGtUCbAZIq+jWqUpmbSdpjHxjvt3lKT4f3hBXEefmiif8su5+2R
 2zgzGdxHE5svcpjagtjgcG9Dpg4XxzmeTibXiJ0bi2tLxfavcI+wBMQKXux7F/WanOQVvVmDT
 Xki8SB2oReGwsvrG+ScOAj5Efgitp6C/8/gK0tSwCPhQ8Qk6pj2+RVj9pQXel/qbEyP5P3hy6
 3vqYtc2O2w4nCriGZ0ehnfNCXVXB6LPnLAcmv4iXq4X+weGTAYKlxEnJyR3ks5E6LmZvSGtiB
 2ca5wN7Tip+3LgTT7h49yYuL7TFrH7jX6+UdzQF7o=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--79BAnNAuU7xSDvxKkFhflM03NWaiCfRtX
Content-Type: multipart/mixed; boundary="JSbtM0LSPkEJV3z4TiyKSbkzJurPRjKZF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <efea97ef-f7e8-eb43-b5b6-212b0bae8cb4@gmx.com>
Subject: Re: [PATCH 9/9] btrfs: drop extra enum initialization where using
 defaults
References: <cover.1543348078.git.dsterba@suse.com>
 <932e555ce5dff2ec978bf1d21a4ef1d8d5e7ccfd.1543348078.git.dsterba@suse.com>
In-Reply-To: <932e555ce5dff2ec978bf1d21a4ef1d8d5e7ccfd.1543348078.git.dsterba@suse.com>

--JSbtM0LSPkEJV3z4TiyKSbkzJurPRjKZF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/28 =E4=B8=8A=E5=8D=883:53, David Sterba wrote:
> The first auto-assigned value to enum is 0, we can use that and not
> initialize all members where the auto-increment does the same. This is
> used for values that are not part of on-disk format.
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/btrfs_inode.h |  2 +-
>  fs/btrfs/ctree.h       | 28 ++++++++++++++--------------
>  fs/btrfs/disk-io.h     | 10 +++++-----
>  fs/btrfs/qgroup.h      |  2 +-
>  fs/btrfs/sysfs.h       |  2 +-
>  fs/btrfs/transaction.h | 14 +++++++-------
>  6 files changed, 29 insertions(+), 29 deletions(-)
>=20
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 4de321aee7a5..fc25607304f2 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -20,7 +20,7 @@
>   * new data the application may have written before commit.
>   */
>  enum {
> -	BTRFS_INODE_ORDERED_DATA_CLOSE =3D 0,
> +	BTRFS_INODE_ORDERED_DATA_CLOSE,
>  	BTRFS_INODE_DUMMY,
>  	BTRFS_INODE_IN_DEFRAG,
>  	BTRFS_INODE_HAS_ASYNC_EXTENT,
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 4bb0ac3050ff..f1d1c6ba3aa1 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -334,7 +334,7 @@ struct btrfs_node {
>   * The slots array records the index of the item or block pointer
>   * used while walking the tree.
>   */
> -enum { READA_NONE =3D 0, READA_BACK, READA_FORWARD };
> +enum { READA_NONE, READA_BACK, READA_FORWARD };
>  struct btrfs_path {
>  	struct extent_buffer *nodes[BTRFS_MAX_LEVEL];
>  	int slots[BTRFS_MAX_LEVEL];
> @@ -532,18 +532,18 @@ struct btrfs_free_cluster {
>  };
> =20
>  enum btrfs_caching_type {
> -	BTRFS_CACHE_NO		=3D 0,
> -	BTRFS_CACHE_STARTED	=3D 1,
> -	BTRFS_CACHE_FAST	=3D 2,
> -	BTRFS_CACHE_FINISHED	=3D 3,
> -	BTRFS_CACHE_ERROR	=3D 4,
> +	BTRFS_CACHE_NO,
> +	BTRFS_CACHE_STARTED,
> +	BTRFS_CACHE_FAST,
> +	BTRFS_CACHE_FINISHED,
> +	BTRFS_CACHE_ERROR,
>  };
> =20
>  enum btrfs_disk_cache_state {
> -	BTRFS_DC_WRITTEN	=3D 0,
> -	BTRFS_DC_ERROR		=3D 1,
> -	BTRFS_DC_CLEAR		=3D 2,
> -	BTRFS_DC_SETUP		=3D 3,
> +	BTRFS_DC_WRITTEN,
> +	BTRFS_DC_ERROR,
> +	BTRFS_DC_CLEAR,
> +	BTRFS_DC_SETUP,
>  };
> =20
>  struct btrfs_caching_control {
> @@ -2621,10 +2621,10 @@ static inline gfp_t btrfs_alloc_write_mask(stru=
ct address_space *mapping)
>  /* extent-tree.c */
> =20
>  enum btrfs_inline_ref_type {
> -	BTRFS_REF_TYPE_INVALID =3D	 0,
> -	BTRFS_REF_TYPE_BLOCK =3D		 1,
> -	BTRFS_REF_TYPE_DATA =3D		 2,
> -	BTRFS_REF_TYPE_ANY =3D		 3,
> +	BTRFS_REF_TYPE_INVALID,
> +	BTRFS_REF_TYPE_BLOCK,
> +	BTRFS_REF_TYPE_DATA,
> +	BTRFS_REF_TYPE_ANY,
>  };
> =20
>  int btrfs_get_extent_inline_ref_type(const struct extent_buffer *eb,
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 4cccba22640f..987a64bc0c66 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -21,11 +21,11 @@
>  #define BTRFS_BDEV_BLOCKSIZE	(4096)
> =20
>  enum btrfs_wq_endio_type {
> -	BTRFS_WQ_ENDIO_DATA =3D 0,
> -	BTRFS_WQ_ENDIO_METADATA =3D 1,
> -	BTRFS_WQ_ENDIO_FREE_SPACE =3D 2,
> -	BTRFS_WQ_ENDIO_RAID56 =3D 3,
> -	BTRFS_WQ_ENDIO_DIO_REPAIR =3D 4,
> +	BTRFS_WQ_ENDIO_DATA,
> +	BTRFS_WQ_ENDIO_METADATA,
> +	BTRFS_WQ_ENDIO_FREE_SPACE,
> +	BTRFS_WQ_ENDIO_RAID56,
> +	BTRFS_WQ_ENDIO_DIO_REPAIR,
>  };
> =20
>  static inline u64 btrfs_sb_offset(int mirror)
> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
> index d8f78f5ab854..e4e6ee44073a 100644
> --- a/fs/btrfs/qgroup.h
> +++ b/fs/btrfs/qgroup.h
> @@ -70,7 +70,7 @@ struct btrfs_qgroup_extent_record {
>   *	be converted into META_PERTRANS.
>   */
>  enum btrfs_qgroup_rsv_type {
> -	BTRFS_QGROUP_RSV_DATA =3D 0,
> +	BTRFS_QGROUP_RSV_DATA,
>  	BTRFS_QGROUP_RSV_META_PERTRANS,
>  	BTRFS_QGROUP_RSV_META_PREALLOC,
>  	BTRFS_QGROUP_RSV_LAST,
> diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
> index c6ee600aff89..40716b357c1d 100644
> --- a/fs/btrfs/sysfs.h
> +++ b/fs/btrfs/sysfs.h
> @@ -9,7 +9,7 @@
>  extern u64 btrfs_debugfs_test;
> =20
>  enum btrfs_feature_set {
> -	FEAT_COMPAT =3D 0,
> +	FEAT_COMPAT,
>  	FEAT_COMPAT_RO,
>  	FEAT_INCOMPAT,
>  	FEAT_MAX
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 703d5116a2fc..f1ba78949d1b 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -12,13 +12,13 @@
>  #include "ctree.h"
> =20
>  enum btrfs_trans_state {
> -	TRANS_STATE_RUNNING		=3D 0,
> -	TRANS_STATE_BLOCKED		=3D 1,
> -	TRANS_STATE_COMMIT_START	=3D 2,
> -	TRANS_STATE_COMMIT_DOING	=3D 3,
> -	TRANS_STATE_UNBLOCKED		=3D 4,
> -	TRANS_STATE_COMPLETED		=3D 5,
> -	TRANS_STATE_MAX			=3D 6,
> +	TRANS_STATE_RUNNING,
> +	TRANS_STATE_BLOCKED,
> +	TRANS_STATE_COMMIT_START,
> +	TRANS_STATE_COMMIT_DOING,
> +	TRANS_STATE_UNBLOCKED,
> +	TRANS_STATE_COMPLETED,
> +	TRANS_STATE_MAX,
>  };
> =20
>  #define BTRFS_TRANS_HAVE_FREE_BGS	0
>=20


--JSbtM0LSPkEJV3z4TiyKSbkzJurPRjKZF--

--79BAnNAuU7xSDvxKkFhflM03NWaiCfRtX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv98P0ACgkQwj2R86El
/qj4BwgAmQPeS8v/x7UdKCzb52MuDEX0W28pPU1SqUg6xQWYBUNYuYL33G7Fk2Qz
lryiXt9AgWPMB7YEqfwluxQWfjtSpLvxWlN26MSBqR4LRTTCANWQsHb5PO1Y+hdg
Kks2P25l5UtUq6UMXhCdkWUN4/v916H0vbGlI+CA8mytkGoGDRqeRt8wqYj1U9OS
4YfPCzbQNjUh1CPpMHK7tszM+sQ8q3UrtgwO5WDelxM0X9+0wEdoQfFhZkYFwCcW
QJxIvkWDVuWSJzdF1DWAoUg7gdILSlrbGP7h1CPBdriNYtPLVB3cXN9RrL8ck5wh
Ml97CqCpv+BVOkHDijWuzwg/PZSqKg==
=gW0Z
-----END PGP SIGNATURE-----

--79BAnNAuU7xSDvxKkFhflM03NWaiCfRtX--
