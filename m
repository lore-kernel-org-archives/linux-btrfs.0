Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A209C282D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 02:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D02F92084C
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 02:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfAaCiO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 21:38:14 -0500
Received: from mout.gmx.net ([212.227.15.18]:38207 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfAaCiO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 21:38:14 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LslCb-1hI09u39zN-012Gh6; Thu, 31
 Jan 2019 03:38:08 +0100
Subject: Re: [PATCH RFC 2/2] btrfs: Introduce free dev extent hint to speed up
 chunk allocation
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190130074000.16638-1-wqu@suse.com>
 <20190130074000.16638-3-wqu@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <8a785ed2-80ef-e30b-5a63-6556f744eaf6@gmx.com>
Date:   Thu, 31 Jan 2019 10:38:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190130074000.16638-3-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="m3C8wp2Q33vmMq2S3caKlLnrLuvoDzEzd"
X-Provags-ID: V03:K1:W7/2ozGJ5Nb2QAYp8sEDL6gKC4JhbqT28l25cq7ggNXzfUz5YSn
 T7x+0P1VO900sckuUzULL1NepOZyRJAiWSxaozT3xjA4cOUxEsaPsc5W7T6S0o79Hr9p6KI
 KK6NLvREn0642pz0AEp/Ta01X2cCdPVlKbywsd4VnjQL1oRqPRauT7M4fanuYIFu9JR7iaH
 yKkcF9iGnszNKF0qUa9IQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:cGTQnWufMNQ=:OGEma6TIebxpCnXWC8HLIS
 /1iO4zjPu3v5LGRurL1MOpkbRnw00//qdfa8dFtnjEcgVDsxovSboMm8obwRxdQ7XN+ep8kzF
 3PQLnM9tNmFlvMuQfDN2i3x30LwbKYyi7hnES329FoPFGMLhdSEpWn0vOsyVP9tG6qSixFNNS
 AU5K9PDHiA5RJic/nYrj9KYnBEHzQmwNoKBO1ZT0T515GChc89o498uQZWYLNJEE5zLDrJp3w
 7iJG3KdgXg4AgxDk0PguMTsHxi8jb9f3x1WhbRFu9QSwKluVnkOtKUWrXOYMSJl6iKGFqMfJj
 qIeDvAOcsAMpJU7ij9rCtey4S0kWuoC9YaO2miG/YwiB5Rn3221OOeXikMinyydekRl9yU7Yj
 wAxajpiVoHe6/pJYxpVqOsaVQogfI0oQgotCnNwl7FR88pLc7f6HspjcoTzk+hD32JevMTHAN
 Ns9p+JEq0Z29TP6XCcpsxCu2UxyyDclvTQC1ApIc/ItfUPBTGNMvZGDPum+h5uh7ZPGbAXkEy
 FX2rm5p7Y6ITSSoE4vG6/GkVeJuaNTskO+DMPJeUSwEDIlMBDip6NNlc/z9mj1ZNC+5BK2ln3
 zlgZ29c8jrfRCg6dRMu6tqNTUkfCOsQzEs/yhjcGA1LOA07wAZUUZUmvhy1Jgbn8sUXGmo4+a
 TDxHRAuioHCUxWDEay71JniVV4Gv67geDlmVPBvNqTY6OCWsxOHNdqQYbeyPn2+GfAzfMeHKk
 3zHY7pA+exzJYZ2L1JZ59zHUzR+6LBBVpkmKdm8zITJ5zxBluTALeCRlwgg3txsAq87ndkl7d
 Qmh0W790E/TGxa/Zg1Ej70I2nmmchavujefcBCWTpmdt+QdeCR376zaI4gUjfYnYHw2DazbzP
 aBc4PR2HL78pjUmsy7RabKJ/XC+3piSazXLoD95eh4O5gNjUi8pjg7NKRZwScR
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--m3C8wp2Q33vmMq2S3caKlLnrLuvoDzEzd
Content-Type: multipart/mixed; boundary="htbkmMMovmUgBHsWsHG3BcsFOtXemQORa";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <8a785ed2-80ef-e30b-5a63-6556f744eaf6@gmx.com>
Subject: Re: [PATCH RFC 2/2] btrfs: Introduce free dev extent hint to speed up
 chunk allocation
References: <20190130074000.16638-1-wqu@suse.com>
 <20190130074000.16638-3-wqu@suse.com>
In-Reply-To: <20190130074000.16638-3-wqu@suse.com>

--htbkmMMovmUgBHsWsHG3BcsFOtXemQORa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

> [ENHANCEMENT]
> This patch will introduce btrfs_device::hint_free_dev_extent member to
> give some hint for chunk allocator to find free dev extents.
>=20
> The hint itself is pretty simple, only tells where the first free slot
> could possibly be.
>=20
> It is not 100% correct, unlike free space cache, but since
> find_free_dev_extent_start() is already robust enough to handle
> search_hint, so there is not need to introduce a complex and fancy free=

> dev extent cache.
>=20
> With this patch, allocating 4G on a 4T filled fs will be way more
> faster:
>=20
>       v5.0-rc1   |   patched      |    function
> ---------------------------------------------------------------------
>  7)              | 7)             |  __btrfs_alloc_chunk [btrfs]() {
>  7) ! 152.496 us | 7)   7.885 us  |    find_free_dev_extent_start [btrf=
s]();
>  7) ! 185.488 us | 7) + 36.649 us |  }
>  7)              | 7)             |  __btrfs_alloc_chunk [btrfs]() {
>  7) ! 132.889 us | 7)   2.454 us  |    find_free_dev_extent_start [btrf=
s]();
>  7) ! 152.115 us | 7) + 24.145 us |  }
>  7)              | 7)             |  __btrfs_alloc_chunk [btrfs]() {
>  7) ! 127.689 us | 7)   2.245 us  |    find_free_dev_extent_start [btrf=
s]();
>  7) ! 146.595 us | 7) + 19.376 us |  }
>  7)              | 7)             |  __btrfs_alloc_chunk [btrfs]() {
>  7) ! 126.657 us | 7)   2.174 us  |    find_free_dev_extent_start [btrf=
s]();
>  7) ! 144.521 us | 7) + 16.321 us |  }

For anyone who is interesting in unrealistic workload, without this
patch, fallocating a 1PiB file TiB by TiB will take 5+ hours!!

With this patch, it's just going to take around 15~20min.

Anyway, we're still far from customer oriented 1PiB HDDs, so that's not
something we need to bother yet.

Thanks,
Qu

>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/volumes.c | 23 +++++++++++++++---
>  fs/btrfs/volumes.h | 58 ++++++++++++++++++++++++++++++++++++++++++++++=

>  2 files changed, 78 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8e932d7d2fe6..cc15bf70dc72 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -411,6 +411,7 @@ static struct btrfs_device *__alloc_device(void)
>  	btrfs_device_data_ordered_init(dev);
>  	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);=

>  	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM=
);
> +	dev->hint_free_dev_extent =3D (u64)-1;
> =20
>  	return dev;
>  }
> @@ -1741,9 +1742,9 @@ int find_free_dev_extent(struct btrfs_trans_handl=
e *trans,
>  			 struct btrfs_device *device, u64 num_bytes,
>  			 u64 *start, u64 *len)
>  {
> -	/* FIXME use last free of some kind */
> -	return find_free_dev_extent_start(trans->transaction, device,
> -					  num_bytes, 0, start, len);
> +	return find_free_dev_extent_start(trans->transaction, device, num_byt=
es,
> +					  device->hint_free_dev_extent, start,
> +					  len);
>  }
> =20
>  static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
> @@ -1799,6 +1800,7 @@ static int btrfs_free_dev_extent(struct btrfs_tra=
ns_handle *trans,
>  				      "Failed to remove dev extent item");
>  	} else {
>  		set_bit(BTRFS_TRANS_HAVE_FREE_BGS, &trans->transaction->flags);
> +		btrfs_device_hint_add_free(device, key.offset, *dev_extent_len);
>  	}
>  out:
>  	btrfs_free_path(path);
> @@ -1841,6 +1843,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_tr=
ans_handle *trans,
>  	btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
> =20
>  	btrfs_set_dev_extent_length(leaf, extent, num_bytes);
> +	btrfs_device_hint_del_free(device, key.offset, num_bytes);
>  	btrfs_mark_buffer_dirty(leaf);
>  out:
>  	btrfs_free_path(path);
> @@ -7913,6 +7916,14 @@ int btrfs_verify_dev_extents(struct btrfs_fs_inf=
o *fs_info)
>  		devid =3D key.objectid;
>  		physical_offset =3D key.offset;
> =20
> +		/*
> +		 * previous device verification is done, update its free dev
> +		 * extent hint
> +		 */
> +		if (device && devid !=3D device->devid)
> +			btrfs_device_hint_add_free(device, prev_dev_ext_end,
> +				device->disk_total_bytes - prev_dev_ext_end);
> +
>  		if (!device || devid !=3D device->devid) {
>  			device =3D btrfs_find_device(fs_info, devid, NULL, NULL);
>  			if (!device) {
> @@ -7940,6 +7951,10 @@ int btrfs_verify_dev_extents(struct btrfs_fs_inf=
o *fs_info)
>  					    physical_offset, physical_len);
>  		if (ret < 0)
>  			goto out;
> +
> +		btrfs_device_hint_add_free(device, prev_dev_ext_end,
> +				physical_offset - prev_dev_ext_end);
> +
>  		prev_devid =3D devid;
>  		prev_dev_ext_end =3D physical_offset + physical_len;
> =20
> @@ -7951,6 +7966,8 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info=
 *fs_info)
>  			break;
>  		}
>  	}
> +	btrfs_device_hint_add_free(device, prev_dev_ext_end,
> +			device->disk_total_bytes - prev_dev_ext_end);
> =20
>  	/* Ensure all chunks have corresponding dev extents */
>  	ret =3D verify_chunk_dev_extent_mapping(fs_info);
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index ed806649a473..00f7ef72466f 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -108,6 +108,14 @@ struct btrfs_device {
> =20
>  	/* bytes used on the current transaction */
>  	u64 commit_bytes_used;
> +
> +	/*
> +	 * hint about where the first possible free dev extent is.
> +	 *
> +	 * u64(-1) means no hint.
> +	 */
> +	u64 hint_free_dev_extent;
> +
>  	/*
>  	 * used to manage the device which is resized
>  	 *
> @@ -569,4 +577,54 @@ bool btrfs_check_rw_degradable(struct btrfs_fs_inf=
o *fs_info,
>  int btrfs_bg_type_to_factor(u64 flags);
>  int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
> =20
> +static inline void btrfs_device_hint_add_free(struct btrfs_device *dev=
,
> +					      u64 start, u64 len)
> +{
> +	if (dev->disk_total_bytes =3D=3D 0 || start + len > dev->disk_total_b=
ytes)
> +		return;
> +	if (len < SZ_16M)
> +		return;
> +	if (start > dev->hint_free_dev_extent)
> +		return;
> +	dev->hint_free_dev_extent =3D start;
> +}
> +
> +static inline void btrfs_device_hint_del_free(struct btrfs_device *dev=
,
> +					      u64 start, u64 len)
> +{
> +	u64 free_hint =3D dev->hint_free_dev_extent;
> +
> +	if (dev->disk_total_bytes =3D=3D 0 || start + len > dev->disk_total_b=
ytes)
> +		return;
> +	/*
> +	 * |<- to be removed ->|
> +	 * 			| free hint
> +	 * Not affecting free hint
> +	 */
> +	if (start + len <=3D free_hint)
> +		return;
> +	/*
> +	 * |<- to be removed ->|
> +	 * 		| free hint
> +	 * Or
> +	 * 	|<- to be removed ->|
> +	 * | free hint
> +	 * |<-->| Less than 16M
> +	 *
> +	 * Move the hint to the range end
> +	 */
> +	if ((start <=3D free_hint && start + len > free_hint) ||
> +	    (start > free_hint && free_hint - start < SZ_16M)) {
> +		dev->hint_free_dev_extent =3D start + len;
> +		return;
> +	}
> +
> +	/*
> +	 * 			|<- to be removed ->|
> +	 * | free hint
> +	 *
> +	 * We still have larger than 16M free space, no need to update
> +	 * free hint
> +	 */
> +}
>  #endif
>=20


--htbkmMMovmUgBHsWsHG3BcsFOtXemQORa--

--m3C8wp2Q33vmMq2S3caKlLnrLuvoDzEzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxSX4wACgkQwj2R86El
/qht4ggApDvvEzF6UIsxDhok/hhu8E19Gpg635Y1lG2Nlkm9tPfXe421X9ry5/Qd
TyDayDnmKfYmbhvApNXBJSXzkVLy+K/XmL58DrhGfoRYGSr6cYCUce/hz0wp9XdL
eAdaEnDrVuNAf77VO1q66R7oSnt+el/aSfZyHTGegNJgfyfRBnoI4eRcCn+LU717
i3Yny3awj2FnR2nNoPXDNII27tSAX6oEtTtxlHqYtoY7r3ZnAtXObhNQ5e1x0FFY
vI9fOkDqz6JgQf/IooQ0IJTX0YFo9Pk9oSmnMpf55CeaWTtO94ylwtvtrOf0ZsRW
STEBGZMJ8GM1ZoInT9xPX0zcWai5JA==
=zsxI
-----END PGP SIGNATURE-----

--m3C8wp2Q33vmMq2S3caKlLnrLuvoDzEzd--
