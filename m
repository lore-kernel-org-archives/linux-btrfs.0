Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E068C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 23:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DE632190A
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 23:56:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="GJJlkZ7B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfCUX4y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 19:56:54 -0400
Received: from mout.gmx.net ([212.227.17.21]:33145 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbfCUX4y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 19:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553212602;
        bh=Te7mobYwSDg2otHnfukY3JBG8BJQ7LdD5OoC1sZTg5k=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=GJJlkZ7BlGDA3c1GkzwMIrljuYNrvHFGwpcDQAdici7b79LFegonnCnULTrTfVFTN
         Cv0JcDHcixMpcOely6+8wBiZ0ShPKgGMd4slJe3BSVnesU6HMVZLaSl+PiwOEAcjLi
         xKW5zy0EyR9SO0IG+v7WvgxCAp3PRbMaqscE2ynw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MIzGn-1h9baS2DOL-002Tfv; Fri, 22
 Mar 2019 00:56:42 +0100
Subject: Re: [PATCH v5.3 00/11] btrfs: tree-checker: Write time tree checker
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190320062749.30953-1-wqu@suse.com>
 <20190321143406.GF26179@twin.jikos.cz>
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
Message-ID: <ec2d0bb8-49bf-a7ec-3bc5-7c0f80adf018@gmx.com>
Date:   Fri, 22 Mar 2019 07:56:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190321143406.GF26179@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QNCkRKFxMA8v5NMpiKatGsfhUBvmnsKHZ"
X-Provags-ID: V03:K1:n4dX6j0q/pDwbjVD30rj/0b25ncWpeoT6OAC83hBHFCZjiifacL
 YeRxXcdkS+TA74athTJ3mBlP0NO2fpFWe3e4JrjfqEYZVvtZ2PsjDoiD/QJ1cx0ewtw91VE
 gz+TzkiEvVovvb0NBdZNmcRrWrqAto9Mp2qyC89zIjdqqfzlqvZoV3Zy5JvykkDrdyhho+t
 vZBTUhNA7FQ9+TlccCkNw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:yv0ALUC6J9Y=:Bcu84hchc0FoPZiugoE6iZ
 bScO/tcNYzjx/cHsvCFavg8Jpuz0b7CHAW9gdQTfxVBVoCruwROuNHe7jLaZjKD7y/MQG/AUB
 xqouT+R21QtVTcI0Ji46/fi5JEbN8mPZk0+SD/EM4J2Zhiv/3V0I0jtVtFNiUs8+CaAS2baBj
 DbH9y/HeIFgtpB/BQYUpxuG7aT2AJGAQI9+9gqxJU4V+A1uJeSjhDZnVTWbz436thxIGQpoAN
 q78ZshT1lYwmBmO3TZ1dmamXvZByOkqEoyJYBOgXIUaeQx9BjZ5wUkzajTzfRDf1+1oUjyJrJ
 fJZyhJQo1JtNAPea99UD4hcEM3cZ0FoW3f4XSxwE8HRo89RFe3NJfDPDfvVhPbD8i1YaF5oqJ
 +GczzwwjRw3LSfMN1hApGC3Ewxm8lkVaBw9hDvjdTZheZDFgQlcF+pp1mxnT7vsQVArF4iyzY
 1xzvFQfd5yp/AC3IRSB7FDwojZ3PEB1zuDpEiG6gDm0hN6sAH6Io00XZ1aitld3mR9NRTdMON
 c81jnHr+DGcAYsQIbZlJ0QoyP4JgJf/TXHaQJHzmeaprYpUtzFvXN9tglEjHLncQdcklwna7E
 xA4e/mr+J4TOQzlCVH9xOdP8CiZwt4fWPFgQJ1MpHBqwK4lskb3v8avLawHoh+H4ufL3rB90s
 qbB2Z9EhlvZ8PjeIGDPTB2+jX5C20s5drKFt0N/c1JtI8mS8wWNxygNLRwR5qJNgYk7ovcZQ1
 NVFuNQNnHp1zXCgwI4taxtG+ll19LX2ukPrYEzZcbxaw1L36iRmBMSI9Vry+rz9Ill+l+XXGU
 cVPsstWpQ7WmW2M56iO5wSeqDg87HPQZHuG6LMwyUXm58vQuQbqFsg4MfKd2IBs8DHMnOEUnq
 XXMg53uNZboWxw587+PMVObMa7Q5FmGfTWsGSC91xr/CskkHElkxfx/5/sY2AV
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QNCkRKFxMA8v5NMpiKatGsfhUBvmnsKHZ
Content-Type: multipart/mixed; boundary="NlEzyXmElUClC1b6RNFqjprfCwGAU37Dd";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <ec2d0bb8-49bf-a7ec-3bc5-7c0f80adf018@gmx.com>
Subject: Re: [PATCH v5.3 00/11] btrfs: tree-checker: Write time tree checker
References: <20190320062749.30953-1-wqu@suse.com>
 <20190321143406.GF26179@twin.jikos.cz>
In-Reply-To: <20190321143406.GF26179@twin.jikos.cz>

--NlEzyXmElUClC1b6RNFqjprfCwGAU37Dd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/21 =E4=B8=8B=E5=8D=8810:34, David Sterba wrote:
> On Wed, Mar 20, 2019 at 02:27:38PM +0800, Qu Wenruo wrote:
>> Patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/write_time_tree_checker
>> Which is based on v5.1-rc1 tag.
>>
>> This patchset has the following 3 features:
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
>>     BTRFS error (device dm-3): block=3D1350630375424 write time tree b=
lock corruption detected
>>     BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=
=3D-5 IO failure (Error while writing out transaction)
>>     BTRFS info (device dm-3): forced readonly
>>     BTRFS warning (device dm-3): Skipping commit of aborted transactio=
n.
>>     BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=3D-5=
 IO failure
>>     BTRFS info (device dm-3): delayed_refs has NO entry
>>
>> - Better error handling before calling flush_write_bio()
>>   One hidden reason of calling flush_write_bio() under all cases is,
>>   flush_write_bio() will trigger endio function and endio function of
>>   epd->bio will free the bio under all cases.
>>   So we're in fact abusing flush_write_bio() as cleanup.
>>
>>   Since now flush_write_bio() has its own return value, we shouldn't c=
all
>>   flush_write_bio() no-brain, here we introduce proper cleanup helper,=

>>   end_write_bio(). Now we call flush_write_bio() like:
>>               New                 |           Old
>>   --------------------------------------------------------------
>>   ret =3D do_some_evil(&epd);       | ret =3D do_some_evil(&epd);
>>   if (ret < 0) {                  | flush_write_bio(&epd);
>>   	end_write_bio(&epd, ret); | ^^^ submitting half-backed epd->bio?
>>   	return ret;               | return ret;
>>   }                               |
>>   ret =3D flush_write_bio(&epd);    |
>>   return ret;                     |
>>
>>   Above code should be more streamline for the error handling part.
>>
>> Changelog:
>> v2:
>> - Unlock locked pages in lock_extent_buffer_for_io() for error handlin=
g.
>> - Added Reviewed-by tags.
>>
>> v3:
>> - Remove duplicated error message.
>> - Use IS_ENABLED() macro to replace #ifdef.
>> - Added Reviewed-by tags.
>>
>> v4:
>> - Re-organized patch split
>>   Now each BUG_ON() cleanup has its own patch
>> - Dig much further into the call sites to eliminate unexpected >0 retu=
rn
>>   May be a little paranoid and abuse some ASSERT(), but it should be
>>   much safer against further code change.
>> - Fix the false alert caused by balance and memory pressure
>>   The fix it skip owner checker for non-essential tree at write time.
>>   Since owner root can't always be reliable, either due to commit root=

>>   created in current transaction or balance + memory pressure.
>>
>> v5:
>> - Do proper error-out handling other than relying on flush_write_bio()=

>>   to clean up.
>>   This has a side effect that no Reviewed-by tags for modified patches=
=2E
>> - New comment for why we don't need to do anything about ebp->bio when=

>>   submit_one_bio() fails.
>> - Add some Reviewed-by tag.
>>
>> v5.1:
>> - Add "block=3D%llu " output for write/read time error line.
>> - Also output read time error message for fsid/start/level check.
>>
>> v5.2:
>> - Fix a missing page_unlock() in error hanlding
>>
>> v5.3:
>> - Rebase to v5.1-rc1 tag
>>
>> Qu Wenruo (11):
>>   btrfs: Always output error message when key/level verification fails=

>>   btrfs: disk-io: Show the timing of corrupted tree block explicitly
>>   btrfs: extent_io: Move the BUG_ON() in flush_write_bio() one level u=
p
>>   btrfs: extent_io: Handle error better in extent_write_full_page()
>>   btrfs: extent_io: Handle error better in btree_write_cache_pages()
>>   btrfs: extent_io: Kill the dead branch in extent_write_cache_pages()=

>>   btrfs: extent_io: Handle error better in extent_write_locked_range()=

>>   btrfs: extent_io: Kill the BUG_ON() in lock_extent_buffer_for_io()
>>   btrfs: extent_io: Kill the BUG_ON() in extent_write_cache_pages()
>>   btrfs: extent_io: Handle error better in extent_writepages()
>>   btrfs: Do mandatory tree block check before submitting bio
>=20
> All except 9 and 11 are going to misc-next after a final test. The two
> patches are only postponed, one for review and the other one due to
> conflict with another patch in misc-next.

Do I need to resend the last patch to solve the conflict by myself?

Thanks,
Qu

>=20


--NlEzyXmElUClC1b6RNFqjprfCwGAU37Dd--

--QNCkRKFxMA8v5NMpiKatGsfhUBvmnsKHZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyUJLUACgkQwj2R86El
/qj8kggArCMEkfvQkeeje6wzBPX/y6NPMP6tNVs3WoemxlDgp7gRFrjWQnQqh2Mt
SwJkk20qrd1Sa/Hk4wXj89U75yWbJGgo/BNam/tc4xEGuPmgnX3phhtL2Rc8Wj38
Qcj2Pn/N/Vir3gKx7Rgngy0dPbaAv2HwOn2W7E10Z3HywcvbweV8Zoy5nI0zJt3X
GYHT/jo077lfFTDtu7zwH5OGte7DRbiosICuQsMCW1ArY3xsb9k2XaY4YYstqwnm
tm/v/J4Get44QuWKFzhDiLu6iW0/B6ZZb93Ar6FlfbfvVs8wzHfxYLP081RUD1Ca
pfPmRGNGm87FRFgb07fsVTutcEJCcA==
=BFAH
-----END PGP SIGNATURE-----

--QNCkRKFxMA8v5NMpiKatGsfhUBvmnsKHZ--
