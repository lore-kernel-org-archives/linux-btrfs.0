Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F730C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 22:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CD8C20870
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 22:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfAVWyB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 17:54:01 -0500
Received: from mout.gmx.net ([212.227.15.19]:38899 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfAVWyA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 17:54:00 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MPUlV-1gqBek3llB-004izh; Tue, 22
 Jan 2019 23:53:48 +0100
Subject: Re: [PATCH v3 0/5] btrfs: Enhancement to tree block validation
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190118021956.22949-1-wqu@suse.com>
 <20190122174756.GR2900@twin.jikos.cz>
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
Message-ID: <fa80cf1b-927d-305c-74b9-2fea4a0448a2@gmx.com>
Date:   Wed, 23 Jan 2019 06:53:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122174756.GR2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6g77YDTKzC3A6KRUXE3t2t7UDpzfZC1Fc"
X-Provags-ID: V03:K1:3j7OZLtg5iBnbFD0F/MnmBdsce51gxjCalyTOsM3FP+KgfqH36p
 Z8VfzlPSY/pB3bCdFeAAxpLPjhJyDOp3sfppEGckgMrPWDHNIEJ0yzmUHthErtCEQtsR6IW
 1kXKFJr6fZzg+VbQCOeng+HLMpTPtTswZWQ0/x8dCnVVQCjHR4uu483Hk+LKjEKq3NQ4SJy
 05TYdZ1rIreU+gfPlY+0Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:MvIeTZBhfv0=:Wdl5g/i3ids099aBExMYSV
 o7ANk857xXv6sAkjKw4kBqQbo3u3RQejnqOWweSayqij1oRN76W9jN2YU8jGS0xr3iK3Kf1M9
 12+KM5rcj7bhqZ2s15+M2KSt8hDEezYgVw7OVJ3VhLsE6XaBozUnpw2DRL2/zGX6MuwxXM/Sk
 nciK8au1tjkNwI+tO7M3kqlhuD6IZQsdsYX7dkuOmaKT1wlpNodx4PQzDGU3d8zD5f0NYQjnH
 5s3gKKtptf/Oz6KKKk85bdVs6kVxYwp0tK0uXYKN7ChtyBBVqhJ27aFlgApK++uLx6e1aNKAX
 dmcJAsjYwzxZPjXfQF/WvH9VwZb873iphqITeO8W6vzHhWCgxkoKBXckZVaEOSvirEZFsi6AY
 IXqtJMyIlwqaFlHWAFbdbiS0svjyxiw9Te8vEPD6vhnuPQwmfC9mjE1HIowXAokzGmxD/upWA
 L083uzj5I6DaACof7jrkciByNM+hZp6ck+qLXDLs4uc+PcDE7+5FENj7sOVOiW4i9xEWHQVzb
 JJuwUqWZwHcNmvuXz5MCb7SmFmBEMe7Gz5GJsSRFHU8WOOjZdEGtr2aC39ASlF+n70Cyo8wU1
 4e+CyRGbzXLoadc96VBCOo9689pIGW74E9fwIaPbfG+5qoG3QNNeDbDsq74lqDjznUdojWRbO
 Ehpsb63Z65EU9rxGt9BbusCJ0+YmieCe4yIl1HvSawLTChx2A425KP24oFHKb8OQSXB2lz6Xq
 h1xE5eDvJdf8l67bZ0DEVjd0EgSpQ6LgeSmSwPmYRTkUAcI3j9rrgrgvYkGJ7hrRMNMZGRl2T
 zsajJEfJ0UlJPjSL0VaYFflIdyxUUv3N3edWthdrfC9wV4VnytN82N4tITEGmF4np1ag+9qD8
 Fto0dJpK1YuDncN/w7RxN/6zWNDv98IpOSBQ99CAgH8lFpuH+0BcSuYxcK0YBO
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6g77YDTKzC3A6KRUXE3t2t7UDpzfZC1Fc
Content-Type: multipart/mixed; boundary="CaS3XDZbFSwYW3SqjXPrKQqVTOhSTchEQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <fa80cf1b-927d-305c-74b9-2fea4a0448a2@gmx.com>
Subject: Re: [PATCH v3 0/5] btrfs: Enhancement to tree block validation
References: <20190118021956.22949-1-wqu@suse.com>
 <20190122174756.GR2900@twin.jikos.cz>
In-Reply-To: <20190122174756.GR2900@twin.jikos.cz>

--CaS3XDZbFSwYW3SqjXPrKQqVTOhSTchEQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/23 =E4=B8=8A=E5=8D=881:47, David Sterba wrote:
> On Fri, Jan 18, 2019 at 10:19:51AM +0800, Qu Wenruo wrote:
>> Patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/write_time_tree_checker
>> Which is based on v5.0-rc1 tag.
>>
>> This patchset has the following two features:
>> - Tree block validation output enhancement
>>   * Output validation failure timing (write time or read time)
>>   * Always output tree block level/key mismatch error message
>>     This part is already submitted and reviewed.
>>
>> - Write time tree block validation check
>>   To catch memory corruption either from hardware or kernel.
>>   Example output would be:
>>
>>     BTRFS critical (device dm-3): corrupt leaf: root=3D2 block=3D13506=
30375424 slot=3D68, bad key order, prev (10510212874240 169 0) current (1=
714119868416 169 0)
>>     BTRFS error (device dm-3): write time tree block corruption detect=
ed
>>     BTRFS critical (device dm-3): corrupt leaf: root=3D2 block=3D13506=
30375424 slot=3D68, bad key order, prev (10510212874240 169 0) current (1=
714119868416 169 0)
>>     BTRFS error (device dm-3): write time tree block corruption detect=
ed
>=20
> Would it be possible to print this message only once?

I think it's caused by DUP profile.

I'll change to make it abort.

> It's correct when
> it's the last message after all the corruptions are detected as there
> could be a lot of text that can scroll off the screen. The real reason
> what happend would stay and give enough clue what happened.
>=20
>>     BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=
=3D-5 IO failure (Error while writing out transaction)
>>     BTRFS info (device dm-3): forced readonly
>>     BTRFS warning (device dm-3): Skipping commit of aborted transactio=
n.
>>     BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=3D-5=
 IO failure
>>     BTRFS info (device dm-3): delayed_refs has NO entry
>=20
> That's not from your patch es but now that I see it, it's not for the
> 'info' level, maybe 'debug' or not printed at all.
>=20
> The extra checks will cause some slowdown, do we have an estimate how
> much?

In theory it should be no slower than an extra csum run for tree blocks.

Thanks,
Qu


--CaS3XDZbFSwYW3SqjXPrKQqVTOhSTchEQ--

--6g77YDTKzC3A6KRUXE3t2t7UDpzfZC1Fc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxHnvgACgkQwj2R86El
/qi1cQf+OtT/sO2Ya9PcQlmQ+7TsFZNcbTKsLlQ/eMlOLwAPc4ZbQzeTPZTA5Mag
ZkWjdI2yirRE44ujgEh4UH6TSbSsFV/xtn5vt07P+8OWfMTGgTHSizs78zxU9l9G
DEu3DUmA7L2FTJshLXiJxzdzqih7Ju/tKdGPnBPRU4Ei/Wok9xzckr6C7JUOhSsV
aCfumd82cpRz92Hxlu6GGrPN4LhaxheQ3EoDxKiH/pMoppL32q0LOE2LCJzhEubw
caV7BcOdXASUyWeASUf+LGgOXC0zSHXspj03ZQGvCHATUd4EfXs7Vg7UxrN8vY0d
Faa0trhdUDeuKwDUb7SrxW/whUWx4w==
=t00K
-----END PGP SIGNATURE-----

--6g77YDTKzC3A6KRUXE3t2t7UDpzfZC1Fc--
