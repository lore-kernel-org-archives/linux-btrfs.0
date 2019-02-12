Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B97C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 14:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 456A72075B
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 14:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbfBLO0O (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 09:26:14 -0500
Received: from mout.gmx.net ([212.227.17.21]:56307 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbfBLO0O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 09:26:14 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M34eJ-1hBm3813Jf-00swLA; Tue, 12
 Feb 2019 15:26:06 +0100
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
To:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20190116160057.22040-1-josef@toxicpanda.com>
 <2bdd075d-2c56-611b-c0a0-4126d27daec5@gmx.com>
 <20190212141916.GB2900@twin.jikos.cz>
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
Message-ID: <bb59bbb6-e7b4-1400-5db6-969122ff930d@gmx.com>
Date:   Tue, 12 Feb 2019 22:25:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190212141916.GB2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1PaWZ4CUarq4w4FEDdNJhHAcffmq1uxiO"
X-Provags-ID: V03:K1:twVnWs4IZ2h+aqS+Yldtmachn9YhUat/uAac6d697AjBdmTwPU5
 kZqjLHwHqEGoDueSf6fMXFeX0KYpXi/jb9AbZG6zwusm1TATvha2/BDc3fehuiRNT0AGGCN
 terRyJTPnXJKtrYkNSo26lcWRgZMYgBAiDkZzH3D2Rj3UmfbziAZIbcUFa3PGe/ml+Q24JZ
 E6bKPdjc/jVq9RbqKJOFw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:eQFi9v1eGSc=:xcS5BQuJ8lDece83J/Nxp1
 8/HK025Keq1mo14Qzf1hQAV5K+ot29LugLi/XBrkckOUubQv/tFlmxO8JdEO+sbKaAB1N9FsP
 n2taWvp5xp7aLf/12rYw7M3u6H1X64ulxaSFXNDWanFQqQXvsq/B8AbM3HTKe4d9eMkyufJOd
 JwhkdNvslJPVHyUa1897jbBpTOV5Z0VXg71rSXDyRklZY1xtWfnrvrtniWxMwPo9vjoVubC1n
 U2hHFIRquN5D6gFOuwjC3dgnBrPD1BpBBUS/iuWp5A5kUMO83aw0NzRpmiDdHcNxu6z4gJmyg
 +UlBRO80iFaVlKV2GpexmX3WI/P+HOKwDb3rt7f+v69ES4zIcw4yOH+x57Dc0b0yslqX9aLxi
 YcWI8mfNJ7m6HPBZ5CkdtI2FuRDfCKw+SgrgCgt+O5zLmhqAiOvf/86naEkdiVfIlFVenn9ou
 5BpujGVpK22Qu5fgwQNSBBRZXndXMUEEC6fbFL9Boumb3NNhiWiMqxfxEsSeb9qSoXSZE+11z
 p2XnNyFP5hOy0Mf5mUpz4vXXCfRzM3Gx1l0X94TBQKdErEnfi6pPTZJN2IM9nq/02yldr/I01
 8DO8isQ1lhsxMnkLHY8uZDB4tNgMams7dHBc+E/0R8bb8pa9qem2fhqMiVAJhq8DAabUeQj58
 RBe2rp+YhiakAxIBHxXLW3D+/G2cLekY9gfsw3a9SbB8dy3jCr+6otydrJsY40ER9rtAuwEQC
 d8Jm/9PhN23tvJI1dH0gYsgdzvaM7rlay2ExVDbLYZ2qC3N+ZSvzPz8cA5CvUvdJJFiBbw7/i
 sl4Se+arex5KJqU7kcBmo9XPFyT1+gkfcVGn1WiV68SoEpHtr9Xzhr0ge1l984rzMKjRGicRi
 UsDtF/lxeOkcsnluBOuvveF7snk2mM7lMFEx2sbN/YzJp4mitCeBkUNvVH5zJD
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1PaWZ4CUarq4w4FEDdNJhHAcffmq1uxiO
Content-Type: multipart/mixed; boundary="CsvEYwv7V5RcKCbUcWaFr42Fa8ohGGM0C";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
 linux-btrfs@vger.kernel.org, kernel-team@fb.com
Message-ID: <bb59bbb6-e7b4-1400-5db6-969122ff930d@gmx.com>
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
References: <20190116160057.22040-1-josef@toxicpanda.com>
 <2bdd075d-2c56-611b-c0a0-4126d27daec5@gmx.com>
 <20190212141916.GB2900@twin.jikos.cz>
In-Reply-To: <20190212141916.GB2900@twin.jikos.cz>

--CsvEYwv7V5RcKCbUcWaFr42Fa8ohGGM0C
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/12 =E4=B8=8B=E5=8D=8810:19, David Sterba wrote:
> On Tue, Feb 12, 2019 at 01:07:19PM +0800, Qu Wenruo wrote:
>>> @@ -1288,11 +1290,13 @@ static int find_parent_nodes(struct btrfs_tra=
ns_handle *trans,
>>>  					ret =3D -EIO;
>>>  					goto out;
>>>  				}
>>> -				btrfs_tree_read_lock(eb);
>>> +				if (!path->skip_locking)
>>> +					btrfs_tree_read_lock(eb);
>>>  				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>>
>> This btrfs_set_lock_blocking_rw() or the btrfs_set_lock_blocking_read(=
)
>> in latest misc-next call need @eb to be read locked first.
>>
>> So this line should also be in the (!path->skip_locking) branch, and
>> such modification solves the BUG_ON() caused by btrfs/007.
>=20
> Thanks.  btrfs_set_lock_blocking_rw is gone from misc-next so the patch=

> needs a refresh and resend, besides passing fstests of course.
>=20
Yup, although the conflict is pretty small, just change the
btrfs_set_lock_blocking_rw() to btrfs_set_lock_blocking_read() will do it=
=2E

Does Josef or me need to resend the patch or would you mind to fold the
change?

Thanks,
Qu


--CsvEYwv7V5RcKCbUcWaFr42Fa8ohGGM0C--

--1PaWZ4CUarq4w4FEDdNJhHAcffmq1uxiO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxi13cACgkQwj2R86El
/qjUPAf/SxG6tv+CAd2GvOjl8Q9PS+xX2LrrI5ocPPBVt6fACI6+vBNB2/9P1xve
YDqdnZzdBNoTIgw0SVI1AyS5RJ6K0OCyEwQeWElkqGQV7CES4HPzghUVrgZcWtdk
zZq+6/n4aI4cMEUjiABT3eUFL3Z0BrIrpfrx+G0HXvHc6CoIeKs/Ho5m/KveCGHb
Xa8HKGgESif2JDblCQnpiKJxjqVI4vl49UmMrWkfO7KJrXJ2HUA0OzFifEiu+1hq
NZXOBNFQ++oKQpua5qTuhbI9WnsxMfrOynW91ZpOIYXqrKDCudXFnwTK2urHegmT
pQzsOIcOHucUDnqMFr/o4tCzDnkvDA==
=Lk7O
-----END PGP SIGNATURE-----

--1PaWZ4CUarq4w4FEDdNJhHAcffmq1uxiO--
