Return-Path: <SRS0=RlhI=RB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B4EC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 07:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33C9E213A2
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 07:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfBZHjI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Feb 2019 02:39:08 -0500
Received: from mout.gmx.net ([212.227.15.15]:57749 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfBZHjH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Feb 2019 02:39:07 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MfVU3-1gfVIv2XKF-00P7Ku; Tue, 26
 Feb 2019 08:38:59 +0100
Subject: Re: [RFC PATCH] btrfs: Introduce developer-oriented check to ensure
 all tree blocks are written back before writing super blocks
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190221082249.24187-1-wqu@suse.com>
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
Message-ID: <c9ce0bbd-11bf-2cf8-e354-7d4f2a66a0ef@gmx.com>
Date:   Tue, 26 Feb 2019 15:38:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190221082249.24187-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jGtMOnuwBLvsqYOGwoNkpd6qZlAzEVT1C"
X-Provags-ID: V03:K1:mnsEXHJxLxrmW5IT1cqmfDkVjLt89tEenDCDTsevDv3lgEGN2T8
 gliqNZzV8YR+BkDvHN2kLf2ciUQMGjs/5Or3H6uwmGncvtHUQ6GVipJTwgQ0l1diDjlHjmK
 qV7nkvDDRVXaDYpC3BwCAH+oDHYDQ8z6scUDdaLXlXkzbZKLanf5OyQSqQ8XPVQgzUj3p+G
 wwUY3pYPzlmyevXdeqhcA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xK0Ug3zwjFk=:etKooTxxNTRwBdeAcCV8Ci
 UHPc4UfgJCtPHqWLaQsfyejvuWUfGcS4B3Zv1ghya6498zFq6pQ4UwUG4OLNnM+hvIzMzyVTQ
 nb9SrcxxpNlwNXI/8ivWP43yu/vvEBkALsVAyrOd0MgcslZAKU2Oth+YlkQB2k1KOhKi0YS8x
 89YfcY3/FkByCIA/m2nSqcX9lhixymrEmwJIkCvSzhN5j8UWwSlY0AsOv9CVsDoiOZSZtgSIy
 huFYKIn2pOZCyG++byMUsv5Z3QUFW6+kvquGFmfZJ+LiBYBQu6FoiNrcbecAaVj21M10UZRUZ
 qd17MfDdCNZPbVHjp2oaBPt7A73WlwT9qT8Hfhg0Q3ThVs95Nrtk7a795XVS2goX+9dqnelTK
 igRqb9LLCnRD2cV78PaYO5HgSxUBmFi4Gm9lciJ1DD3Gr3VF9ULB5uRlctgwjcwkaq6yKPilE
 XbUE2A5R28XUMt6BPk9Ve03KUQhiPUaJx5plExvAjgVjkcZrxr57yoA7D6SwHIPUKP006VgWP
 xeJoigKiLw+Q5kOjfc4wOJxOLIiP6h92cRlt4H43ZArDnXFFz0/SeKHDu50ktLNSGGxQyj6OR
 OzkKSBFOYVbNhxA7olnBdzioFc7hBdrBoptckSu1cICIE6xX7GFPTH8kEfwes4ncULI8J4f4Z
 FSVlf8cVjKnndGDZnkiBzibsDgn3A5MiGpilGs/htgExTbrhsU0gaMdN3WeIVuy912ez9XHjy
 s7e+zJ4/U52Izn3iQj1PB0P6kDmeCgvox+fT0LQMg6duSXDkTQreRUmoaDTXZCvMZN4o+IVyb
 2yWtl8DOCM6JX43mGW/n/IYJkTd1HB1TJ7LpTvR46xXZSH0Sy7cWCsPg9a18QSgVboIUERotz
 Zxkn10lXLSWdC5xHvotUYFovH1y5pxh7lXqf44Cm30rqvxNrOPvQPvvN97KXqC
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jGtMOnuwBLvsqYOGwoNkpd6qZlAzEVT1C
Content-Type: multipart/mixed; boundary="jkWvFyvMFUMjcctAWCY5IyK6mSJdEMvLx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c9ce0bbd-11bf-2cf8-e354-7d4f2a66a0ef@gmx.com>
Subject: Re: [RFC PATCH] btrfs: Introduce developer-oriented check to ensure
 all tree blocks are written back before writing super blocks
References: <20190221082249.24187-1-wqu@suse.com>
In-Reply-To: <20190221082249.24187-1-wqu@suse.com>

--jkWvFyvMFUMjcctAWCY5IyK6mSJdEMvLx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/21 =E4=B8=8B=E5=8D=884:22, Qu Wenruo wrote:
> There are a lot of error reports complaining about transid error in the=

> mail list.
>=20
> Under most case, the on-disk transid is lower than expected transid.
> This may indicate that some tree blocks are not written back to disk
> before writing super blocks.
>=20
> This patch will add a safe net for developers, by calling
> btrfs_write_and_wait_transaction() before setting transaction unblocked=

> and double check btree_inode and dirty_pages io_tree, to ensure no tree=

> blocks are still dirty or under writeback.
>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Please discard this patch.

As Nikolay suggested, the check doesn't make much sense.

> =20
> +	/* Last safenet or developer to catch any unwritten tree blocks */
> +	if (IS_ENABLED(CONFIG_BTRFS_DEBUG)) {
> +		u64 found_start =3D 0;
> +		u64 found_end =3D 0;
> +
> +		ret =3D btrfs_write_and_wait_transaction(trans);
> +		if (ret) {
> +			btrfs_handle_fs_error(fs_info, ret,
> +					      "Error while writing out transaction");
> +			mutex_unlock(&fs_info->tree_log_mutex);
> +			goto scrub_continue;
> +		}
> +
> +		/* No dirty extent should exist in btree inode */
> +		ret =3D test_range_bit(&trans->transaction->dirty_pages, 0,
> +				(u64)-1, EXTENT_DIRTY | EXTENT_WRITEBACK,
> +				0, NULL);

For dirty_pages, btrfs_write_and_wait_transaction() will clear all bits.
So the check will always return 0.

> +		if (ret > 0) {
> +			WARN(1,
> +		"dirty_pages not fully written back, start=3D%llu len=3D%llu\n",
> +			     found_start, found_end + 1 - found_start);
> +			ret =3D -EUCLEAN;
> +			mutex_unlock(&fs_info->tree_log_mutex);
> +			goto scrub_continue;
> +		}
> +		ret =3D test_range_bit(&BTRFS_I(fs_info->btree_inode)->io_tree, 0,
> +				     (u64)-1, EXTENT_DIRTY | EXTENT_WRITEBACK,
> +				     0, NULL);

btree_inode doesn't really carry EXTENT_DIRTY bit.
It only carries EXTENT_LOCK, and are mostly for tree read locking.

So this check doesn't make much sense either.

Thanks,
Qu

> +		if (ret > 0) {
> +			WARN(1,
> +		"btree io_tree not fully written back, start=3D%llu len=3D%llu\n",
> +			     found_start, found_end + 1 - found_start);
> +			ret =3D -EUCLEAN;
> +			mutex_unlock(&fs_info->tree_log_mutex);
> +			goto scrub_continue;
> +		}
> +	}
> +
>  	spin_lock(&fs_info->trans_lock);
>  	cur_trans->state =3D TRANS_STATE_UNBLOCKED;
>  	fs_info->running_transaction =3D NULL;
>=20


--jkWvFyvMFUMjcctAWCY5IyK6mSJdEMvLx--

--jGtMOnuwBLvsqYOGwoNkpd6qZlAzEVT1C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx07Q4ACgkQwj2R86El
/qg89gf/XpSkb9dQxsFxQYWb4rD5FKY0vL6F0mUARASLTDcT64imfCfmFy5mGyDd
H+dw6qmMkn5+u112g/HH/DekoQp0KWUdoDjKwEwBR1wOYQgfRQv94DO9rF8kuydx
8OTlmv5bkzJMI2EINiSKS5y/3ZuKxVmAm85xTrZwvFDPOwq/z9vcZ71FAcumN0GV
61uyAzW7oMLdsm5SCPaCQ51nu5Ge4KvOB9z7NY+tw7goKpJucU3U2Ns2b57tTeUG
5RjAxljTIfnOmS24WzDM+L18q/82Ugf2k+492Mj03Q3Ad9xhIA7glTkSW62ri3Bg
+1dYqsx2Z3bSujkADPzwUtrBPdpttw==
=IrsP
-----END PGP SIGNATURE-----

--jGtMOnuwBLvsqYOGwoNkpd6qZlAzEVT1C--
