Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7269EC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 04:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3811720879
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 04:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfAJEut (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Jan 2019 23:50:49 -0500
Received: from mout.gmx.net ([212.227.15.15]:33489 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbfAJEut (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Jan 2019 23:50:49 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LgptO-1h1iEY0cwI-00oIIP; Thu, 10
 Jan 2019 05:50:17 +0100
Subject: Re: [For 5.0-rc PATCH] btrfs: Use real device structure to verify dev
 extent
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>
References: <20190108060818.9517-1-wqu@suse.com>
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
Message-ID: <2ac8040f-8799-1091-262a-ec18545054cc@gmx.com>
Date:   Thu, 10 Jan 2019 12:50:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190108060818.9517-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GaqUWlp6WdWaJbcTOwxCf3spT3OnmKYXz"
X-Provags-ID: V03:K1:nNNxoADt8K8+a9TpFDpYPGwYQ9QFAocHvBNBdYOTzMikEoR1Vvw
 4nijVJER7jIDNsjMCgCBI59ffmD5YCnQs5F0DACNor46/9Z/0r3AcfBzcD0gP78AVzrFDKm
 ktTZuYq/DWdgxWoActFrmfBkvo6fTPEnoNYqg8nJlIxl1oAxGli1y2wZHroqbtMQvfCYEwz
 qjTPMLKibKc7QCTW3u6/A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:VTH9r1SgKeg=:pmeXrrTFACxF9jjgH7B16C
 hrukGhvdOhi1b71C9F3iiE5DDzZkZX3BtACJw+vvJakb+EpgZXN05wzebONbfk98g4MvS4/Mj
 YeVLrCUXPkDnrKn588CLaksxeyajQcdvUec3BHx5Dp9UKZVBglPvwQzW2CPQc+DzncIxF5505
 PGzEKN3ZMvwOrXRu+60Wiw5zNUzyuUa7iW51wAYudHy+u47gJf7tFazAlbS2oUWZolG4ICA9i
 zuYiYU2X4okUNF8LizJcpnLeue0sWi+1hnkSkOXHsuWwfof4an1EMRrdv2sLnIKHdHPSSNxt5
 Sr9GXj2/Q2O4PhJyAd/PKMe4KqrmMSGuUtceZftRwol+WMQJJzRx/Zkd6PRclBcL4WOveac7N
 V5aB56BdHOTe92PcqJWb/6wzfrm1fXs7egfCccmEpPLO+MQ3YEkdo20uFOWWZ7tqLp8/49c60
 VtdqQSp9wrjeykrGntgNu4opqjr7BjYl9FIU/2PKizXxI9SXJF92Foy737us6/lXlH1o3EJqa
 ytXyfYYeagoYTIBLloe6HyMFajnw2sI32u3ZzyF3H9Jotk0DJTbX1avLt8ixjTNxAY6W4Ulap
 VeNk1C4Deh8yKpHHvSOXkFpwpm4uYdKIOksWWq5CclYlIR8IW41tIQbaHDFnUP+X2fhL2PInF
 m7Zsu/cYQXXin5fWukmsPTqW0PA2oMi8kXNlZmDR/PrRXWu5Q7wekpbkiZGqDtou3hACB18Gv
 d+3fogjFOHoe83E1eBYhXFASAisuyZeeCU4+oXOqNVYWtHl8icrd4pFPTdIlHU/FbCPIQFkVq
 Mg6oGbUU/kEZ2+dQ0Xq0qCD+b4/lvP8BbYru4+7y/FXiKnibzzwf9Nrqg6PPC0a/ouOpPAm6Q
 W/FLtBkiwzoUnF3P0Vfm9bI+GOSnjOQdNWxbQJFFtO3kA3DCf71+UEAnBuyUS5
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GaqUWlp6WdWaJbcTOwxCf3spT3OnmKYXz
Content-Type: multipart/mixed; boundary="H2M8U6XlqnLny7NsW0mgFHUzBz0ajS9aX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Message-ID: <2ac8040f-8799-1091-262a-ec18545054cc@gmx.com>
Subject: Re: [For 5.0-rc PATCH] btrfs: Use real device structure to verify dev
 extent
References: <20190108060818.9517-1-wqu@suse.com>
In-Reply-To: <20190108060818.9517-1-wqu@suse.com>

--H2M8U6XlqnLny7NsW0mgFHUzBz0ajS9aX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Gentle ping.

Although this is just a dirty fix, it would be much better to avoid seed
device users yelling at me.

Thanks,
Qu

On 2019/1/8 =E4=B8=8B=E5=8D=882:08, Qu Wenruo wrote:
> [BUG]
> Linux v5.0-rc1 will fail fstests/btrfs/163 with the following kernel
> message:
>=20
>   BTRFS error (device dm-6): dev extent devid 1 physical offset 1363148=
8 len 8388608 is beyond device boundary 0
>   BTRFS error (device dm-6): failed to verify dev extents against chunk=
s: -117
>   BTRFS error (device dm-6): open_ctree failed
>=20
> [CAUSE]
> Commit cf90d884b347 ("btrfs: Introduce mount time chunk <-> dev extent
> mapping check") introduced strict check on dev extents.
>=20
> We use btrfs_find_device() with dev uuid and fs uuid set to NULL, and
> only dependent on @devid to find the real device.
>=20
> For seed devices, we call clone_fs_devices() in open_seed_devices() to
> allow us search seed devices directly.
>=20
> However clone_fs_devices() just populates devices with devid and dev
> uuid, without populating other essential members, like disk_total_bytes=
=2E
>=20
> This makes any device returned by btrfs_find_device(fs_info, devid,
> NULL, NULL) is just a dummy, with 0 disk_total_bytes, and any dev
> extents on the seed device will not pass the device boundary check.
>=20
> [FIX]
> This patch will try to verify the device returned by btrfs_find_device(=
)
> and if it's a dummy then re-search in seed devices.
>=20
> Reported-by: Filipe Manana <fdmanana@suse.com>
> Fixes: cf90d884b347 ("btrfs: Introduce mount time chunk <-> dev extent =
mapping check")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/volumes.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2576b1a379c9..3e4f8f88353e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -7825,6 +7825,18 @@ static int verify_one_dev_extent(struct btrfs_fs=
_info *fs_info,
>  		ret =3D -EUCLEAN;
>  		goto out;
>  	}
> +
> +	/* It's possible this device is a dummy for seed device */
> +	if (dev->disk_total_bytes =3D=3D 0) {
> +		dev =3D find_device(fs_info->fs_devices->seed, devid, NULL);
> +		if (!dev) {
> +			btrfs_err(fs_info, "failed to find seed devid %llu",
> +				  devid);
> +			ret =3D -EUCLEAN;
> +			goto out;
> +		}
> +	}
> +
>  	if (physical_offset + physical_len > dev->disk_total_bytes) {
>  		btrfs_err(fs_info,
>  "dev extent devid %llu physical offset %llu len %llu is beyond device =
boundary %llu",
>=20


--H2M8U6XlqnLny7NsW0mgFHUzBz0ajS9aX--

--GaqUWlp6WdWaJbcTOwxCf3spT3OnmKYXz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw2zvwACgkQwj2R86El
/qjrVAgAksbVpOXLEBwoahMgStu7k7+wFRGmTXjvFxxHr3tmVNDCNmggQTmRSZGm
CNadmZb1cUjfOG6DOtZqzcQM14PXa6fLcvTi49Fx+N2XP7aNNX3Ww14Bv08KOqaF
46LQvDiSWrHdwwmKtf03nDL+/8fqmObDvlYtuGTfQh3jLuJYKROgZwvM3yFnqUMJ
jfMg/0xgUVgp5mMneSeu811yicZKWxteWR6ElimsK1PgQ0pT8NFSsv4gamRXE+Hu
AVkmTkuHCeixkV4fErVy0StdFaDjNDIyCacp1iakTo7gWrlUAvcaWy8t5M9G3guN
/WsM1JgFxeSMKGZYk57dX9pCC2SNcA==
=h30m
-----END PGP SIGNATURE-----

--GaqUWlp6WdWaJbcTOwxCf3spT3OnmKYXz--
