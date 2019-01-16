Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02B0C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 12:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DC2C20657
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 12:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392639AbfAPM0z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:26:55 -0500
Received: from mout.gmx.net ([212.227.17.22]:59159 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732749AbfAPM0z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 07:26:55 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LwJko-1hJh5Z48Ok-0186WG; Wed, 16
 Jan 2019 13:26:45 +0100
Subject: Re: [PATCH] btrfs: Do mandatory tree block check before submitting
 bio
To:     Hugo Mills <hugo@carfax.org.uk>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Leonard Lausen <leonard@lausen.nl>
References: <20190116115308.8687-1-wqu@suse.com>
 <20190116120113.GG5134@carfax.org.uk>
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
Message-ID: <702957e0-b7c9-bc5f-2409-bdc5ff8d39b6@gmx.com>
Date:   Wed, 16 Jan 2019 20:26:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190116120113.GG5134@carfax.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ERO1SynQIJ1MbB0kEXwYg6bgXYGf9Z9Ci"
X-Provags-ID: V03:K1:eKqmowpBZlYyTXMiYdh6LBlYsNYB7Yjvl6PETni2xaqwHbfmGoA
 3Fe8IwxcOaIyIweZ5Gmx/4YszfcP6pkXKgbGqodS7oKG/9hNbjlsyJUqiJjFHFUd+fxEybs
 zktrTQz9l0IG6hDd/Q5SHj7eqH3ULV+t6LmGwuMudhY+fL2nRuJS6BL00ARClWTzDcpuhKa
 fxbUIAObDmFElzF/u7W8Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:QoQE4ZYU5/M=:aotn6fCXYqXUwp+tFIozmC
 bXe8WTRZVg94thtDkptmxdQf976tPsrAuX5Kkq7QQ+7DidzjoG/TesbrFN3RqN3c8t4P4f0zw
 43SXVXvfDTXbQKSPSKY4tPoEnMDUWcy+htoKBPDoXtXQDdDMy42F7hcAqeEavcPv9Oj0S0U/E
 bjBxw0iiDIiKsBWcPRaBF51bURMEdRrYYVayfK7m48sx+80X0wjqS9ESEt3NMu/LN33/iL7O4
 TRTSH3Ifw2A6gyMkFIqyudIXz6pUi+bkTzQX44gQzrEmZJffdsyAbzAxy20lAItjXw3ydGQSx
 DOLSsn8ByT5Ma93syHPPt64y4YJ2KRVqQOpt/HpCriUZUqJ6dDihyO6GL9EvfDgzucrQmLccX
 Fu8JThsllBzTzR3Oi/UHSJ9xSpFz3hp90se2LNFheeMhetwxD0lvYrsFSSiGPpHTaIncxSgXR
 9f96ySYW+vYSkuLkEcYpE7L7H6Xn1pCao2Ywi/+adY5GcN83z69WMO8YFxTiuxsZKZIiANpOb
 R2RLCew9D17dnhsQrwb3eFlr4M58C4g1d7/rp/09jyejYeS+rKlkng9VcGBGEzqgumSXulqba
 H2fdHr4NXAS7IOg2ndAZc3wbMXB8uqeWEsKalnjPkDg0JEZRLmsgRieto2RzKEhKo665xNWiK
 QBZeERdHbuHdO29XZVIQQbEVBPB2ea8V/vD1+oags+DgGXfY2Kx1YaedoiSoQxThlHYeeW3AF
 q/dcVgY0mqHBLV11mRVZcwY6TzTsmLWWwdpIA1qYux92mW79Kvl6Q6Bbq62v13ZJ/ABKVOkG+
 iR8rUkjflAz0TZnueFscRLuKM63z8QzIguRSz6oLnUVebpY0csEP1/hXyqNSHRT1w74O3CU8U
 +c1Q1QcSfXKYLPk4Rn8qyEgi24QwmARBb9VlPnt2u2GLM1JQBHNGnNUdye9Kvy
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ERO1SynQIJ1MbB0kEXwYg6bgXYGf9Z9Ci
Content-Type: multipart/mixed; boundary="dLU5GvrXb85u9SX75hQD9JHmXnTqBmnZ2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hugo Mills <hugo@carfax.org.uk>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, Leonard Lausen <leonard@lausen.nl>
Message-ID: <702957e0-b7c9-bc5f-2409-bdc5ff8d39b6@gmx.com>
Subject: Re: [PATCH] btrfs: Do mandatory tree block check before submitting
 bio
References: <20190116115308.8687-1-wqu@suse.com>
 <20190116120113.GG5134@carfax.org.uk>
In-Reply-To: <20190116120113.GG5134@carfax.org.uk>

--dLU5GvrXb85u9SX75hQD9JHmXnTqBmnZ2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/16 =E4=B8=8B=E5=8D=888:01, Hugo Mills wrote:
>    Hi, Qu,
>=20
> On Wed, Jan 16, 2019 at 07:53:08PM +0800, Qu Wenruo wrote:
>> There are at least 2 reports about memory bit flip sneaking into on-di=
sk
>> data.
>>
>> Currently we only have a relaxed check triggered at
>> btrfs_mark_buffer_dirty() time, as it's not mandatory, only for
>> CONFIG_BTRFS_FS_CHECK_INTEGRITY enabled build.
>>
>> This patch will address the hole by triggering comprehensive check on
>> tree blocks before writing it back to disk.
>>
>> The timing is set to csum_tree_block() where @verify =3D=3D 0.
>> At that timing, we're generation csum for tree blocks before submittin=
g
>> the metadata bio, so we could avoid all the unnecessary calls at
>> btrfs_mark_buffer_dirty(), but still catch enough error.
>=20
>    I agree wholeheartedly with the idea of this change. Just one
> question:
>=20
>    How does this get reported to the user/administrator? As I
> understand it, a detectably corrupt metadata page will generate an I/O
> error from the filesystem before it's written to disk? How will this
> show up in kernel logs?

Well, you caught me.

I haven't try the error case, and in fact if it fails, it fails by
triggering kernel BUG_ON(), thus you may not have a chance to see the
error message from btrfs module.

> Is it distinguishable in any way from a
> similar error that was generated on reading such a corrupt metadata
> node from the disk?

Kind of distinguishable for this patch, when you hit kernel BUG_ON() at
fs/btrfs/extent_io.c:4016 then it's definitely from this patch. :P

>=20
>    Basically, I want to be able to distinguish this case (error
> detected when writing) from the existing case (error detected when
> reading) when someone shows up on IRC with a "broken filesystem".

Definitely, I'll address this and the BUG_ON() in next version.

Thanks,
Qu

>=20
>    Hugo.
>=20
>> Reported-by: Leonard Lausen <leonard@lausen.nl>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/disk-io.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 8da2f380d3c0..45bf6be9e751 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -313,6 +313,16 @@ static int csum_tree_block(struct btrfs_fs_info *=
fs_info,
>>  			return -EUCLEAN;
>>  		}
>>  	} else {
>> +		/*
>> +		 * Here we're calculating csum before writing it to disk,
>> +		 * do comprenhensive check here to catch memory corruption
>> +		 */
>> +		if (btrfs_header_level(buf))
>> +			err =3D btrfs_check_node(fs_info, buf);
>> +		else
>> +			err =3D btrfs_check_leaf_full(fs_info, buf);
>> +		if (err < 0)
>> +			return err;
>>  		write_extent_buffer(buf, result, 0, csum_size);
>>  	}
>> =20
>=20


--dLU5GvrXb85u9SX75hQD9JHmXnTqBmnZ2--

--ERO1SynQIJ1MbB0kEXwYg6bgXYGf9Z9Ci
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw/IvwACgkQwj2R86El
/qjhvwf/efSaUznvxLQUxfwqGm4kBwy3GKxjl1ibIlv8CEicP8I4RC/RTGMKGyMK
vg3QzIkmXJAE5DINAeFS0aNVZWtc1EXqbu0DxF+XFRFaQWzp2EhhPX9hrF74gnD3
iT6D1Jf87uOn4RGcaymfSmyE+sarbFWEgmwlWw/CR6QxUoc5KtPqOy/h7BR8Gb68
zE46U1DW6OSm8Fhq9yZIAbsttnWT275IVsoSp4Ig4Aldb6LiAwaQO2lOsQa0SYay
G8BQpi9vIeWK6/b1RztRAlJlMw0BScA2pIJB/IXWTie+B+KTS6wRb/9LijObxv4L
i/ld1aTqI8iTrNNL3tVYdoie5lDS0A==
=rRlJ
-----END PGP SIGNATURE-----

--ERO1SynQIJ1MbB0kEXwYg6bgXYGf9Z9Ci--
