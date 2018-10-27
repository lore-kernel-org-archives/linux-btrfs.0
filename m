Return-Path: <SRS0=3TJ0=NH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787E8ECDE44
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 00:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 222D02082C
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 00:04:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 222D02082C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbeJ0In5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 27 Oct 2018 04:43:57 -0400
Received: from mout.gmx.net ([212.227.17.21]:46715 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728129AbeJ0In5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Oct 2018 04:43:57 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MdK8t-1fxpti0W39-00IWxC; Sat, 27
 Oct 2018 02:04:50 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MdK8t-1fxpti0W39-00IWxC; Sat, 27
 Oct 2018 02:04:50 +0200
Subject: Re: Kernel crash related to LZO compression
To:     Dmitry Katsubo <dma_k@mail.ru>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <63eaecce7b60646b7322146ea3f707ba@mail.ru>
 <CAJCQCtQrPKMUaGgg-t+0q8fACy0cys_CBi_5CSp2mr+xa5TeNQ@mail.gmail.com>
 <456e4b3d-50f7-1f88-c503-fb3213abccca@mail.ru>
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
Message-ID: <ca80af3e-b28f-6e62-0eb5-76079d193c61@gmx.com>
Date:   Sat, 27 Oct 2018 08:04:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <456e4b3d-50f7-1f88-c503-fb3213abccca@mail.ru>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="D8IH4jM687xTmRnLo5bmxCH19frvIrfry"
X-Provags-ID: V03:K1:nvZepL7qZMdmtz2WONBWmGJKEc4suqtiSaS0xvEU4tLKlFd3K7R
 uuGi7Swtgdpm7JS0TdAu9AVjOnLV0uxJoXrrYmzdKv217X5+vDR1GhbSqcuEmDOnLU5Y9vY
 Prtb8g66ZAVe2nrmYw4rc/Og1RsuUkVXYxJryCwusB8e7Oz3tgIGYiAJYmokgIi8k3Ath2N
 KPhgSZM6lRUwpjPPxBtLA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:7scBGsnftd4=:cG+vZRmb1DLaPWH+5fyxRB
 Dt6oxcYBRZQJyN+09vVoTgGf2MWQ57x68ylsDCVAvnaMob29ZhTBtIkkmZe/Zb5Tr/6v6t8iI
 rCDJ3dPLZh+OtXIoar53mW6kc8mIbgc9Z9fbmIHVCn3+IDJdiUUAcPzIlb5pKOAqHG0lFnWpd
 tRUwPPBEKa6YNGeFt0Edagg8tMQfJz1MCfd25BOl7v5c2H7TtE8R+BFRYSNOuoltqRsvUDxpr
 TphCrIy7DfG8I25KjhhYELTEkAMXBCib9jgGg7RF7Cdfv6EODNN9Xew/VKpc5AYVmt6Ojc23C
 JENR3LgOIiRmTopNHjmU4F6JAtVt42vE4ynu7LSTLNmqtuJceTbbpYeJtAiLEbxBSjznJXm/x
 KvgD+Jmafbr2JrbZMsr0L0rsv4v+Vg/yMLZEYA69EUwM6qq7/oJPgblZ8iHbX0fBEayHUO7RC
 FJf0CI2AW9uktzxWBBkT/51Dt55PsWyy7i25yhsOMrygPxzUEwCGXsLVUy7Yq9X2WIuCCtduB
 Sif9YgHWJH1IVt2VALknbTrHnCFSQ4SURtmqJoorvWfZb8UYiy070xDcRvHLdBudwUHW7rOP0
 ciDpAjDTVw9n1hsqU6Q90HiiiTkJ5ibDQDEkaoIQSVaS+W1AQ4VijKl1gH2VWJ4ruuStuuXeo
 YOfi1zsn4tZy39Op2Xa2cLE5wJvgFtBbqjJiFTIB1zhlUjS2U6gejOZbjuAU/N3SGGTn9DDa5
 owsTlgSbtO39SR+gDUFb7n1/RuxczqUAo4p/rUwH4eQeq90+RS5uZiVRQtknXnrJt86ef5p+B
 Fhm77iU5G32Xh0fu/vOdYV87ypvCA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--D8IH4jM687xTmRnLo5bmxCH19frvIrfry
Content-Type: multipart/mixed; boundary="Czh7vbKm3hOnFa6KoPkLUJ4tVxm8kuRPq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dmitry Katsubo <dma_k@mail.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <ca80af3e-b28f-6e62-0eb5-76079d193c61@gmx.com>
Subject: Re: Kernel crash related to LZO compression
References: <63eaecce7b60646b7322146ea3f707ba@mail.ru>
 <CAJCQCtQrPKMUaGgg-t+0q8fACy0cys_CBi_5CSp2mr+xa5TeNQ@mail.gmail.com>
 <456e4b3d-50f7-1f88-c503-fb3213abccca@mail.ru>
In-Reply-To: <456e4b3d-50f7-1f88-c503-fb3213abccca@mail.ru>

--Czh7vbKm3hOnFa6KoPkLUJ4tVxm8kuRPq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/26 =E4=B8=8B=E5=8D=8810:57, Dmitry Katsubo wrote:
> On 2018-10-25 20:49, Chris Murphy wrote:
>> I would say the first step no matter what if you're using an older
>> kernel, is to boot a current Fedora or Arch live or install media,
>> mount the Btrfs and try to read the problem files and see if the
>> problem still happens. I can't even being to estimate the tens of
>> thousands of line changes since kernel 4.9.
>=20
> Good point Chris. Indeed booting a fresh kernel is never a problem.
> Actually I forgot to mention that I've seen the same problem with
> kernel 4.12.13 (attached).
>=20
>> What profile are you using for this Btrfs? Is this a raid56? What do
>> you get for 'btrfs fi us <mountpoint>' ?
>=20
> It is RAID1 volume for both metadata and data, but unfortunately I
> haven't recorded the actual output before the failure. The configuratio=
n
> was like this:
>=20
> # btrfs filesystem show /var/log
> Label: none=C2=A0 uuid: 5b45ac8e-fd8c-4759-854a-94e45069959d
> =C2=A0=C2=A0=C2=A0=C2=A0Total devices 2 FS bytes used 11.13GiB
> =C2=A0=C2=A0=C2=A0=C2=A0devid=C2=A0=C2=A0=C2=A0 3 size 50.00GiB used 14=
=2E03GiB path /dev/sda3
> =C2=A0=C2=A0=C2=A0=C2=A0devid=C2=A0=C2=A0=C2=A0 4 size 50.00GiB used 14=
=2E03GiB path /dev/sdc1
>=20
> On 2018-10-25 20:49, Chris Murphy wrote:
>> It should be safe even with that kernel. I'm not sure this is
>> compression related. There is a corruption bug related to inline
>> extents and corruption that had been fairly elusive but I think it's
>> fixed now. I haven't run into it though.
>=20
> On 2018-10-26 02:09, Qu Wenruo wrote:
>>> Are there any updates / fixes done in that area? Is lzo option safe
>>> to use?
>>
>> Yes, we have commits to harden lzo decompress code in v4.18:
>>
>> de885e3ee281a88f52283c7e8994e762e3a5f6bd btrfs: lzo: Harden inline lzo=

>> compressed extent decompression
>> 314bfa473b6b6d3efe68011899bd718b349f29d7 btrfs: lzo: Add header length=

>> check to avoid potential out-of-bounds acc
>>
>> And for the root cause, it's compressed data without csum, then scrub
>> could make it corrupted.
>>
>> It's also fixed in v4.18:
>>
>> 665d4953cde6d9e75c62a07ec8f4f8fd7d396ade btrfs: scrub: Don't use inode=

>> page cache in scrub_handle_errored_block()
>> ac0b4145d662a3b9e34085dea460fb06ede9b69b btrfs: scrub: Don't use inode=

>> pages for device replace
>=20
> Thanks, Qu, for this information. Actually one time I've seen the binar=
y
> crap (not zeros) in text log files (/var/log/*.log) and I was surprised=

> that btrfs returned me data which is corrupted instead of signalling I/=
O
> error. Could it be because of "compressed data without csum" problem?

Yes, pretty much the case, especially for your RAID1 setup.

The root fix should has been backported to stable kernel after 4.0, but
the lzo decompression harden part isn't sent to stable kernel, so you
may still hit such problem.

Thanks,
Qu

>=20
> Thanks!
>=20


--Czh7vbKm3hOnFa6KoPkLUJ4tVxm8kuRPq--

--D8IH4jM687xTmRnLo5bmxCH19frvIrfry
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvTq50ACgkQwj2R86El
/qh9+Qf9HpF9Scb6qv62Cm834gVBeVonOCoCMIIz0MeQzH1iXGHK0W7Zrjyfbnd4
sgUJLgxWv8o+1Iyuhedjx4NIqebgsKgRmh6YlOulFwYLiqCHECmmLEoCZ1r648P5
agSdY47GG71EJ+NQwT3vkakuiQ8HpSFL6jkVQKzdrQ6o+mqNkLKJsXbyKbV8ZgFy
4rgSKSdS/pOH9NL3FAJlCYkBD0+8jMrcGydac6NKWLbAxTJfX6yvZpC2lkROSBbN
lNhlOlGfa3l3oAYk5mj60Mxoj/qr1QyVOptGM3HFbJbRRIW7TUZixaXoRf2+dOCr
DacDkrwasXdWoVvLyxvhn3LdRUhOJQ==
=3Aek
-----END PGP SIGNATURE-----

--D8IH4jM687xTmRnLo5bmxCH19frvIrfry--
