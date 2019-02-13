Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09004C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 14:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9BAF222B2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 14:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389121AbfBMOck (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 09:32:40 -0500
Received: from mout.gmx.net ([212.227.15.19]:40823 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732843AbfBMOck (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 09:32:40 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M5LJv-1hI4N149eh-00zaHd; Wed, 13
 Feb 2019 15:32:30 +0100
Subject: Re: [PATCH] btrfs: ensure that a DUP block group has exactly two
 stripes
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Liu Bo <obuil.liubo@gmail.com>
References: <20190213142602.20436-1-jthumshirn@suse.de>
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
Message-ID: <7a137a90-aa8e-f170-a34f-5166a4e41ce5@gmx.com>
Date:   Wed, 13 Feb 2019 22:32:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190213142602.20436-1-jthumshirn@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IYmbI60TKFbSSf8Hmdz9iw0Wdb2rNpUfN"
X-Provags-ID: V03:K1:T7JgwH500ulVZhNkvwPqYUeOTUWGHBT64ETmE2NWhxzvR7GFGKW
 989gZPnrxBRLuqx2/4LYeKwXzDQxt5q7IZVaV4WMDR9aWtCjMluIy+7ACeey51Q6sZJT5PR
 9wNUs3saTrsiVwOPoHHzm3GefokUnouS4vVZ0GSok139ko9Wp6KbAaMi7992oxdp4KduG8+
 +1I1PXFoWT2YU7V55X8pA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:PkoFH47nSk0=:RAq1UitxMU1vBjFlAfRhai
 pu1/t72Ixlj787qtVQ4JE4T1lgTjWJMwhBhR9nYm3DUNtozijTy8j/C/LxFgDkyMdtbNyT5g5
 o8LWaxTUfinJHyrOXUYC1Kwgr4XjIpjMjPFXnV10HAufd6f/8uJLuy2mMTW4ir/FpVZuKP9vw
 JjMrR4v1Jx9cwl63M8bifxsIx3ZRPTt/QkwGPdKE+vpTVGJOScYcs+Df2dav1m4Xwl07t9MEc
 kcK4TXnA440Ya8+gMKjjhw0JP/pkTzBvn2uEB1sCGto8BLbTb/Cde8Y1hF9+Up0HrBedfXCRt
 IyffuzhkyXV95X3bh13M7c1Z6Y/S/0Y8i9ioBVLdKKK9fLMrwG13CsAfOqQ071XggbTKdsMVq
 S45riKvADPkandbVfG/80st51J2ejCXtqo7+6DCenlilGaVjbie3MySYRmOiRrlIjURdbNoAp
 VCYvKtVED1Lj4haiWyMPaOj5P+ZIBKbBYHpjGdxjST24rlACPi7Vd/oLgac0B9leiqX1nmiwW
 JFuQXG5WdMnV8Hmfw+9gfpapPQnpbdq2vfwrIzINSEdAFDSvldvHPufOhwxzkMGN0ixdwyebC
 bKitQWkBsVWRhJIE52NjhEjLr+QGoJWC7aVK5sO0dEH5e3BMzlavfqQrVS9g+r1cU9hCpYvaf
 zYYYolU6TuRpqKWNQmee9Ivk4VsQo54SaJLd4jdk0YYcC38bKhOiU70eVTVxx1riyy+KIwyf+
 /XPpwdOPPaZC07jOZ+EFYJVIkwFXqvv69HncXBWonyL2/NuWTCGZKtUOgL8BiPdWohNc3pU5x
 Ry9PzxE/TKG70mwN9z+zTEmfplVIoa6IJblnnE/JxSPpkKRBWEUpljBuebwcRmZuoALOSXx0X
 HNkOJ82YwrQHVnQk3BBqz8ramUDQ/ayP5oDAhk0uwCEdVsr6UMOkiNnIDpxHKUFg1/LY9v9yt
 /++lXFfhI4KBfy4wRB7iT0+zaIYk5sucrnoSdio7q2NYDZNj4b9UkKb5wYYDxaliF7rILyt2E
 Lum83o75QgBA2Xbrk1krrFRQ6W7liIbjEAqegoDo1fKA0SZrd+qfGDaeIZEP82GTAr96kingh
 vhSYv77hoAJhF4=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IYmbI60TKFbSSf8Hmdz9iw0Wdb2rNpUfN
Content-Type: multipart/mixed; boundary="SploxQ3fPVWYglbihJ7AViE35iWB9gogD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Johannes Thumshirn <jthumshirn@suse.de>, David Sterba <dsterba@suse.com>
Cc: Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
 Liu Bo <obuil.liubo@gmail.com>
Message-ID: <7a137a90-aa8e-f170-a34f-5166a4e41ce5@gmx.com>
Subject: Re: [PATCH] btrfs: ensure that a DUP block group has exactly two
 stripes
References: <20190213142602.20436-1-jthumshirn@suse.de>
In-Reply-To: <20190213142602.20436-1-jthumshirn@suse.de>

--SploxQ3fPVWYglbihJ7AViE35iWB9gogD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/13 =E4=B8=8B=E5=8D=8810:26, Johannes Thumshirn wrote:
> We recently had a customer issue with a corrupted filesystem. When tryi=
ng
> to mount this image btrfs panicked with a division by zero in
> calc_stripe_length().
>=20
> The corrupt chunk had a 'num_stripes' value of 1. calc_stripe_length()
> takes this value and divides it by the number of copies the RAID profil=
e is
> expected to have to calculate the amount of data stripes. As a DUP prof=
ile
> is expected to have 2 copies this division resulted in 1/2 =3D 0. Later=
 then
> the 'data_stripes' variable is used as a divisor in the stripe length
> calculation which results in a division by 0 and thus a kernel panic.
>=20
> When encountering a filesystem with a DUP block group and a 'num_stripe=
s'
> value unequal to 2, refuse mounting as the image is corrupted and will =
lead
> to unexpected behaviour.
>=20
> Fixes: e06cd3dd7cea ("Btrfs: add validadtion checks for chunk loading")=

> Cc: Liu Bo <obuil.liubo@gmail.com>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 03f223aa7194..b40cc7c830f4 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6794,7 +6794,7 @@ static int btrfs_check_chunk_valid(struct btrfs_f=
s_info *fs_info,
>  	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
>  	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
>  	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
> -	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
> +	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes !=3D 2) ||
>  	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) =3D=3D 0 &&
>  	     num_stripes !=3D 1)) {
>  		btrfs_err(fs_info,
>=20


--SploxQ3fPVWYglbihJ7AViE35iWB9gogD--

--IYmbI60TKFbSSf8Hmdz9iw0Wdb2rNpUfN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxkKnYACgkQwj2R86El
/qh/RAf/cEvt4/tMmA4Dccoj0OOCvQEV67UqXuWdPUbjr0Ue77xFDQcFNlfr08fK
4GuayazaBv4x7EoYsYYiNmxz26TcGRTE5jEwFlkeBI5bUqhGOVry97YPmuL04qD7
Sy/EuNeRKjkGw0U//las6K+ClGgUVxA3kw2pc2Dav3e1UT1awAk1NuIewbOW5n/D
lXF/wUPwpOjWu8PnrWFT7GWvRQIPyBsNvQpFeYng+CEmi0WA2GH1p8GgOldDEVCl
sV2rC9dW5rgKGk2pchtpPmSQtdglR7tuAz8cIZlWUxWJHvgaqalWJopRIQDUlA/x
10IfygE25vwiOLQ2e3IKDkjXgee0Hg==
=sgdn
-----END PGP SIGNATURE-----

--IYmbI60TKFbSSf8Hmdz9iw0Wdb2rNpUfN--
