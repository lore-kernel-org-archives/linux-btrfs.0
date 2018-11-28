Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698A7C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EA102082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:26:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EA102082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbeK1MZ5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 07:25:57 -0500
Received: from mout.gmx.net ([212.227.15.15]:56269 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbeK1MZ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 07:25:57 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M3AzH-1fZywK1M63-00sxcL; Wed, 28
 Nov 2018 02:26:08 +0100
Subject: Re: [PATCH 7/9] btrfs: switch BTRFS_*_LOCK to enums
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
 <5293feb9eb97fdaaa34db024ead13c5ec19234e3.1543348078.git.dsterba@suse.com>
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
Message-ID: <896fd455-f4af-9f18-f60d-538e9ee040ca@gmx.com>
Date:   Wed, 28 Nov 2018 09:26:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <5293feb9eb97fdaaa34db024ead13c5ec19234e3.1543348078.git.dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MxycawzFixtzp5iwxVl4eLlBPqPfSbqtB"
X-Provags-ID: V03:K1:kNUHrYJEJ2nbxcEJ6ODWA/ERAgY1dH8Kla5X7IH3857BfE+S2lb
 Ax04QHPuE2pHt//kghQeV+RoHn4zEVgU347VMUzWtWUJdxleCb2ZHcT4HpXyUu5sMIjCrXv
 7rDvFSzn1bnrcIHk4aVSrbpekkbpbp3HnUYgJ6B2NVRq42M11dIJF2/OtVspW/d3A4oECxD
 0OHoXe+sXJKZTsKEIzsvA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vqGmF5x5c0o=:GsMIf+A2IEECna3/NcJvRa
 mQm6R4RrBoDmUHfkeo32onQtFyvTo+td856FLXWZ3RvCdIFiWSpm04bieAHV7UnUIAHo7gckW
 ivPT9/W/gweHT2ELyDMJVr9f8GvECXVBYeXSplUJPrv058X/5GnLPl2vz9o2BGL8LbIBA/A5j
 Rf/iMb5DMln6VQwuo895NJj1FeneeV9earFzHdTZnWBTLop8eKjzBm2RclMCm+cLL9kvZWH43
 rFXEzxeu4jODXmU+6jX9tW4M9CW4aPK5dukJPC6vYsicLMuJoGZbzLL1eAtkRDl2eSRK0o9ck
 uL08zlXedjos08cltaR8m1GmWutxTmMW3E8yL66bCKzngWST7Y5A8mlNFByl82Vzgvl7Qi4Xf
 Snnhc4WIpAJ4cJG3TiCvI5uVnTJR2ONGdSVCH9R33fhpRI/szjwCwA8FNqs5U0EvZOLbX50i8
 5rSDJnY044zuBSJ/B9RhV+eUiRb5gwWa/huMqpQRNxHQaMSHt7P2JWWdYa9zrZmCr0Wvwv8VH
 4Lx4JC29n4vkzYTUNr1uPoHCHOzO6CA/RBuUgxghSwa2eldRemUbpae8U91l3ba5sKKU36tld
 pP+TBM23tykbmESUxHlmU95ELn3y5g51WSgfVbajAtnFLqJu2wnqMnlfGVOJMa/RUWDUuisW+
 Rc8K/yRhk1ms8G0ASe75LFNscpbMD1SgYGHz/TZKShLMkvv9tFmdO/P/lTc15jO0KawuQFt+/
 iykOhPlEDLhlUFuZhZuN3zIDaQ2WFSQph01XA51Y3R7MYUv6toYcQ+SrfNKnw2FJfEOFUNdCQ
 SjBmJPDt1WbqFKSmZAm+ENyMOCLj8ZDrvZLPguJuBPhneJ0Xbr+wvqTA4sG99lXYI3BFtnEBH
 uuI3Fp3RiFJelRAFN7Ku3esf4wKwBKpC3vIGEHoXM=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MxycawzFixtzp5iwxVl4eLlBPqPfSbqtB
Content-Type: multipart/mixed; boundary="3NTM52CkQoyixe6CQN2HwZuDV2mO3NdN4";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <896fd455-f4af-9f18-f60d-538e9ee040ca@gmx.com>
Subject: Re: [PATCH 7/9] btrfs: switch BTRFS_*_LOCK to enums
References: <cover.1543348078.git.dsterba@suse.com>
 <5293feb9eb97fdaaa34db024ead13c5ec19234e3.1543348078.git.dsterba@suse.com>
In-Reply-To: <5293feb9eb97fdaaa34db024ead13c5ec19234e3.1543348078.git.dsterba@suse.com>

--3NTM52CkQoyixe6CQN2HwZuDV2mO3NdN4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/28 =E4=B8=8A=E5=8D=883:53, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> tree lock types.
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/locking.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
> index 29135def468e..684d0ef4faa4 100644
> --- a/fs/btrfs/locking.h
> +++ b/fs/btrfs/locking.h
> @@ -6,10 +6,12 @@
>  #ifndef BTRFS_LOCKING_H
>  #define BTRFS_LOCKING_H
> =20
> -#define BTRFS_WRITE_LOCK 1
> -#define BTRFS_READ_LOCK 2
> -#define BTRFS_WRITE_LOCK_BLOCKING 3
> -#define BTRFS_READ_LOCK_BLOCKING 4
> +enum {
> +	BTRFS_WRITE_LOCK,
> +	BTRFS_READ_LOCK,
> +	BTRFS_WRITE_LOCK_BLOCKING,
> +	BTRFS_READ_LOCK_BLOCKING,
> +};
> =20
>  void btrfs_tree_lock(struct extent_buffer *eb);
>  void btrfs_tree_unlock(struct extent_buffer *eb);
>=20


--3NTM52CkQoyixe6CQN2HwZuDV2mO3NdN4--

--MxycawzFixtzp5iwxVl4eLlBPqPfSbqtB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv97qsACgkQwj2R86El
/qjt9wgAgrJfMigjAvIb/ZbVuC2icaTY+b74bTz36SrAUSXv+mCggORfqdfuX6U7
tLrt9dse5czxd344uL6HxhT39JDkFWXocpYi+7v5d+hKXi62E3yapghFB/9CyF7a
NPUTzspEVXhsVCN9GsCX5DyCvEVikmVIPzz0PtgguPBQ/zn/z2acOEPX7TS4Ov0d
tzwqA/Xau58mUs1oi+AM8GXzFUmyKB8ypTY9N7ncB0q0HU2tVSchOtWvNU+eDT6O
BHYxqmBvUMxulQucNOPU9TW0R3HrSOZkkBFctKTWSfuJmGsJ2kJhul1/MG87rVbx
HSF2LpSiaAdWGE7LvXjj2nAD2jtfNQ==
=T/Po
-----END PGP SIGNATURE-----

--MxycawzFixtzp5iwxVl4eLlBPqPfSbqtB--
