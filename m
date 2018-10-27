Return-Path: <SRS0=3TJ0=NH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14834ECDE44
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 23:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D48CE20856
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 23:27:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D48CE20856
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbeJ1IKH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Oct 2018 04:10:07 -0400
Received: from mout.gmx.net ([212.227.17.20]:41165 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728630AbeJ1IKH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Oct 2018 04:10:07 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LkSOt-1fkFVN2C1j-00cPxb; Sun, 28
 Oct 2018 01:27:27 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LkSOt-1fkFVN2C1j-00cPxb; Sun, 28
 Oct 2018 01:27:27 +0200
Subject: Re: Have 15GB missing in btrfs filesystem.
To:     Marc MERLIN <marc@merlins.org>
Cc:     linux-btrfs@vger.kernel.org
References: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
 <a8500d2d-2747-f250-75a8-2ec4c0533c6c@gmx.com>
 <20181027174245.4isfcb6nv4pkklmd@merlins.org>
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
Message-ID: <25bf6019-c4e8-1d36-e475-b37f79aecc59@gmx.com>
Date:   Sun, 28 Oct 2018 07:27:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181027174245.4isfcb6nv4pkklmd@merlins.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C3TMKhItbaWtubrnLi03sdTaze89e1KIJ"
X-Provags-ID: V03:K1:14HW/GhUg+mVuYE2uZDosXhbUpv7o0Wx3M4+eIskTP+syxnHVLB
 3nU6g1gs8tHsjuJaPrS+lkheYSZXxExvxbLz29gBls4qlr5rVjxZcmodREONlkFBfW/C6wn
 t4L+pagmGmHBJE/nSZ1k7uRUkp5tcxZOl8cvXBwTpgBKLVumzMovQ+BCZDpxc8fzxstkqTp
 e4a+gDNH+ENkUlxkXVaoQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:sT3Uanbp2T4=:FGV0eoRx3Q4LY5Cskyd0x1
 6fuIn6cOoqQLoPrJ4Uqlo8xrf3+2voIUpEi13sn/xrXAJ260LuAwLdJ0bZnGtbAd2xM5fTVQR
 TFN7JsrPrRsytovf+acbcShb2qWYwiWRuCSLiodlvYIAEnLacrsoEIUptB6uot4ts7l3PwTlP
 PfeJjKYvghKJBro9i5DWbHSBB9Z6hU4JLajNnQi5C7v6dx2Zokp++b9kFszcoKC+djICG4FKd
 F08BLffL5DLOOPxq0s0FMCJNgp9oJLck4kMu86iKOjxM1NhFTl0oeou0NiU/yX91+zOKSbAXS
 qHx7sQFISrjj10LAJgnAsnCdhhEdo/gDznlrtc1/HWuxVi2TuWIGMIwJNCDTNNbe2hs+2Ssm1
 apV/jj3vRkz5oTo4ko1QRVcpnkwITBrl+V7O/X5g2hhm7cjTJYBeLB3RtyIVWp5Eu8PkaZcML
 48suaPbydLVEGCXPmIH4UDPBCxvks+a4oLwESdw0rjbOzsH3pC7Yr2u3SqcxAcMkSz55uNwJ5
 5s/Kty/z+pBGfK/3wzyUPkGa3I6XecbDw9uqHx4xytgOpZaSHp0Djyl+dMvID0LdQYrsILTZb
 ymw4cWW9ha8fgecsJnFebRHqJrtjYVyhFXZdAUYGWMh7lgeUi0mTGilNhEwyqlcU8wuEWOEiE
 PG0pbs5qO2xmZdVzoD27B+T7URcQ4C6HZ9mHtQTftcLfCH3UWrk+PoeYHPxQhJVmH/+9ZYKUK
 AiJ/76ivyOd+LZnCdk6Sr275VEALkA4Xm8RrcCYG0MHAEXazbtB+bED8y8c0cg7rqLRgmrgzv
 Z9lJWOI/wojjL+9Zap6T4sVsHqerw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C3TMKhItbaWtubrnLi03sdTaze89e1KIJ
Content-Type: multipart/mixed; boundary="lTX407wTP5CvPVT6how2ndDkF9jnrGPRk";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <25bf6019-c4e8-1d36-e475-b37f79aecc59@gmx.com>
Subject: Re: Have 15GB missing in btrfs filesystem.
References: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
 <a8500d2d-2747-f250-75a8-2ec4c0533c6c@gmx.com>
 <20181027174245.4isfcb6nv4pkklmd@merlins.org>
In-Reply-To: <20181027174245.4isfcb6nv4pkklmd@merlins.org>

--lTX407wTP5CvPVT6how2ndDkF9jnrGPRk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/28 =E4=B8=8A=E5=8D=881:42, Marc MERLIN wrote:
> On Wed, Oct 24, 2018 at 01:07:25PM +0800, Qu Wenruo wrote:
>>> saruman:/mnt/btrfs_pool1# btrfs balance start -musage=3D80 -v .
>>> Dumping filters: flags 0x6, state 0x0, force is off
>>>   METADATA (flags 0x2): balancing, usage=3D80
>>>   SYSTEM (flags 0x2): balancing, usage=3D80
>>> Done, had to relocate 5 out of 202 chunks
>>> saruman:/mnt/btrfs_pool1# btrfs fi show .
>>> Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
>>> 	Total devices 1 FS bytes used 188.24GiB
>>> 	devid    1 size 228.67GiB used 203.54GiB path /dev/mapper/pool1
>>>
>>> and it's back to 15GB :-/
>>>
>>> How can I get 188.24 and 203.54 to converge further? Where is all tha=
t
>>> space gone?
>>
>> Your original chunks are already pretty compact.
>> Thus really no need to do extra balance.
>>
>> You may get some extra space by doing full system balance (no usage=3D=

>> filter), but that's really not worthy in my opinion.
>>
>> Maybe you could try defrag to free some space wasted by CoW instead?
>> (If you're not using many snapshots)
>=20
> Thanks for the reply.
>=20
> So right now, I have:
> saruman:~# btrfs fi show /mnt/btrfs_pool1/
> Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
> 	Total devices 1 FS bytes used 188.25GiB
> 	devid    1 size 228.67GiB used 203.54GiB path /dev/mapper/pool1

The fs is over 50G, so your metadata chunk will be allocated in 1G size.

>=20
> saruman:~# btrfs fi df /mnt/btrfs_pool1/
> Data, single: total=3D192.48GiB, used=3D184.87GiB

Your data usage is over 96%, so your data chunks are already pretty compa=
ct.

In theory you could reach the minimal data usage 185G, but I think any
new data write would cause new data chunks to be created in that case.

To reclaim that 7.5G, you need to use -dusage filter other than your
-musage filter.
And your usage parameter may be pretty low.

> System, DUP: total=3D32.00MiB, used=3D48.00KiB
> Metadata, DUP: total=3D5.50GiB, used=3D3.38GiB

Metadata looks more sparse than data.

But considering your metadata chunks are allocated in 1G size and CoW
happens more frequently, it's not that easy to reclaim more space.

And even you succeeded relocating all these metadata chunks, you could
only reclaim at most 2~4G.

> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> I've been using btrfs for a long time now but I've never had a
> filesystem where I had 15GB apparently unusable (7%) after a balance.

You really don't need to worry, and that "15G" is not unusable.

It's will mostly likely to be used by data, and from your "fi df"
output, your data:metadata ratio is over 10, so it should be completely
fine.

>=20
> I can't drop all the snapshots since at least two is used for btrfs
> send/receive backups.
> However, if I delete more snapshots, and do a full balance, you think
> it'll free up more space?

No.

You're already too worried about an non-existing problem.
Your fs looks pretty healthy.

Thanks,
Qu

> I can try a defrag next, but since I have COW for snapshots, it's not
> going to help much, correct?>
> Thanks,
> Marc
>=20


--lTX407wTP5CvPVT6how2ndDkF9jnrGPRk--

--C3TMKhItbaWtubrnLi03sdTaze89e1KIJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvU9FoACgkQwj2R86El
/qhiJQgAjnha57v7eImFqDknydyhXBEgiIzodGJwbUuuRG6hI1k0atSvUXjV9i+d
19v6VlN4vMQ2j+yREDPOkTTEUnthsAaSjDpm5XHJZLi5tdE3H0OvG5U8XP8h/6A0
x9Sm4WW+YAaBAClcxtINhnvmNnhTU4LJALGfUCLtpjpvHGjJbDzhF1n850J2Xtid
qvRAuySgpHqZecs3hTOqDUOSH/xAlIm88l2nuq+qseZW/D8D/tyVRnWwJ4WKX4Ew
aK5ci6DAnTOT/MeqH8X/T0nGWPB7GGJAmowjBOlqh0NNSdGfdbgKdLW3RNPRPBPi
P5ZGlUiFSs4jFbk4/mbLgjZH02iSUA==
=asuX
-----END PGP SIGNATURE-----

--C3TMKhItbaWtubrnLi03sdTaze89e1KIJ--
