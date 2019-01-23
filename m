Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C8DC282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 05:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7432F21019
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 05:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbfAWFoK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 00:44:10 -0500
Received: from mout.gmx.net ([212.227.17.22]:57605 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbfAWFoJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 00:44:09 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MIuft-1go64N0wsD-002VEN; Wed, 23
 Jan 2019 06:43:59 +0100
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190115081604.785-1-wqu@suse.com>
 <20190122162807.GL2900@twin.jikos.cz>
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
Message-ID: <1d057f36-71fb-d02f-551b-cdf596f87c21@gmx.com>
Date:   Wed, 23 Jan 2019 13:43:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122162807.GL2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="A12NkStjEFeQbGUNBQVwhtjH5CQNGuqWt"
X-Provags-ID: V03:K1:aYktn5N8NuWFG8VuR+Bej1Uf+ycqas6m+WZqSnl9E4e2IAXNnP5
 I4Ar0pCjZ3q7jBLDaoHI85xFFAsJnIRwbc3AW+0TMJlt3yFNagzk2yKassr/7cYYIg5M6LL
 PvICIJibfSfIkU2y6DKPXzB+Ukz2z/j1HXUj8E3lHAOwrTd8G3QcL1sLgfCMx8KErn981h0
 9c5GTLLT9PzmX21PB6dKQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:BgEEr4So6mU=:4Mtwevako7mSXDlh/VuhL1
 m9Z3Htv9XwTDBsL1Pa/ih1k9PSTEPnDy9fZChaPDMmGi6R9RJwXSoEJYgpLiOtrrw01tlvlhc
 5bwpCRzV14Yc6A2oya1N0qQxjbgZyqunxPX2ePnr+cJOlG36ye27rCp6LGTabagvbvvVVnNDn
 snpdzNd2rfJI8RUxV1S5mPv+3QOnzdTnMKiYVc2s28m1TU/VnlJW2VA9pXFKRje7bmzeHyv3e
 q6VuudprY+IFAt1wago5iihg8tQ0UsnpvjgWtpPXUjKeuW634FbwMEVd3GPxaq+C18GIZhIZk
 3qcyL7e6ogXeIccxyF14s9mTxg9KCYCcSsS5zGMGchh8YnUR9Ai1bWBkbLWuEEf2h5yNWkTAG
 lzmIaGWbxFA1bpm1YXd9XIZILuTbKhM/WC8981y6f5LBz7KQgOyYCgONyMk0iX51kPYv7a0va
 bnyCxnJi3LW9buNNdPUO5hjk/NHAzm6eAnJYlpfBL7TzeJVKNWRuSFPVf4wPj/VS/F5FuKOQB
 OauaUD5oGeSYZQnR+RdP4q8rUeAph6pv3F+Yg4yw3btAnjv4L4pBO+kW1rVHX3WbQaeNjmfF4
 sCZNRQJWgBAgHk5CKyR49vDMfssec3LjC5PA10NH628ga3+8xcmzKi0UEP4oleecxcUSUeJmD
 XftxbmY3qYt6F/laD+l0GH+crqAseOcoN/7LOvCkEbl2yZp5VucD4N4v934DeKyAbfS11CPZO
 q2lD7JN2m9DZ7OpSioSIMopenkVZRhsib4MY3en/6NFGh5bTZM9OIeIAEIA8xVbdHFzdSPz67
 SblJM5SkupfaKiba1KD9a7b0A3hcaPDjBnNyh3gLEp3Z8lySoMXqHY7uNSSpIfspf8pPJ5RCt
 rXdVNM6daVbWzahzZCPbj/cdSwEghHEZmFI0uPVihd7CnSM1N1bZcccYo8R9an
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A12NkStjEFeQbGUNBQVwhtjH5CQNGuqWt
Content-Type: multipart/mixed; boundary="1ighRLhnTV5ZUpQhhLCim1Twfhj7TQscq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <1d057f36-71fb-d02f-551b-cdf596f87c21@gmx.com>
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20190115081604.785-1-wqu@suse.com>
 <20190122162807.GL2900@twin.jikos.cz>
In-Reply-To: <20190122162807.GL2900@twin.jikos.cz>

--1ighRLhnTV5ZUpQhhLCim1Twfhj7TQscq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/23 =E4=B8=8A=E5=8D=8812:28, David Sterba wrote:
> On Tue, Jan 15, 2019 at 04:15:57PM +0800, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree
>>
>> Which is based on v5.0-rc1.
>>
>> This patch address the heavy load subtree scan, but delaying it until
>> we're going to modify the swapped tree block.
>=20
> I'd like to merge this patchset, the overall logic is fine but I've
> found lots of coding style issues, too many to fix them just myself.
>=20
>> v4:
>> - Renaming members from "file_*" to "subv_*".
>>   Members like "file_bytenr" is pretty confusing, renaming it to
>>   "subv_bytenr" avoid the confusion.
>=20
> The naming change is incomplete, there are many more references to 'fil=
e
> tree' in comments and changelogs, the naming should be unified
> everywhere. Also I'd prefer to use 'subvol' though it's a bit longer
> than 'subv', the former seems to be the most common form.

I have to admit this 'subv' naming is completely my bad.

I tend to keep the naming as long as the original 'file' so no format
change is needed at all.
But it turns out that trick doesn't work at all.

I'll get rid of the bad behavior.

Thanks,
Qu

>=20
> I'll comment the patches with the rest.
>=20


--1ighRLhnTV5ZUpQhhLCim1Twfhj7TQscq--

--A12NkStjEFeQbGUNBQVwhtjH5CQNGuqWt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxH/xkACgkQwj2R86El
/qiDgwf/SOZDLsIyqzd+GTQuN9prCe12+ul/HpfbdnSJBMo4AyW6Dw/qTxNk0PPW
wzWQVy8UskL9Pys48gnwYUR45vfm29wKCWO4Ij0wjm+laOQ3woKGEQcdtzFmSZ5E
huwlffUqiqUmYo7utM8QaWLEnBPnWg4n1pGNdxS+iOF53oRlCDvdf69vraFBlmZV
hsyt4hfp4BBsBqP0hhHT9Nr1tXnE8Bcvuk6KHy0vyodnbCUS1iuSskeHM9CW2F25
GKlEBks3YRmX37UBu7G+U4SO/clgFpo+uDjMxXot1bhyY/Ht957KhI72klSuAnqi
Gqf0QT+rtznuSxyW3PdnhEHWnxUaAw==
=FwIe
-----END PGP SIGNATURE-----

--A12NkStjEFeQbGUNBQVwhtjH5CQNGuqWt--
