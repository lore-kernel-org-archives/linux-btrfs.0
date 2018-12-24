Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E6CFC43613
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 14:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41F3521773
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 14:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbeLXOTX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Dec 2018 09:19:23 -0500
Received: from mout.gmx.net ([212.227.15.18]:32833 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbeLXOTX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Dec 2018 09:19:23 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MHHdb-1gXqIp0vYJ-00E92V; Mon, 24
 Dec 2018 15:19:17 +0100
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
To:     =?UTF-8?B?VG9tw6HFoSBNZXRlbGth?= <tomas.metelka@metaliza.cz>
Cc:     Peter Chant <pete@petezilla.co.uk>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
 <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
 <0024a4b2-7117-8d76-45c5-240e23edc29b@gmx.com>
 <5670f5ac-b9e9-8bed-67ee-d113a385a304@metaliza.cz>
 <d29c3f7f-33b8-e1fc-e6ae-672a5bf52376@gmx.com>
 <682fc519-49c4-8537-bd48-cff246a39092@metaliza.cz>
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
Message-ID: <8f59acfd-4d97-86d4-2063-25213e2770d0@gmx.com>
Date:   Mon, 24 Dec 2018 22:19:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <682fc519-49c4-8537-bd48-cff246a39092@metaliza.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="s3KjIBQj56pvWxWnS4Fp9KvdtccGGD3KP"
X-Provags-ID: V03:K1:XNMV67Rv1kxvvkPT6ulv2A2XdyvEFhmxHfH3aMoitVNo+zyZJkD
 VYy+oBUktamKOY6RofV4MuY/NhknzzNC1p5WXijKQSYUVQ+QS60/3nzIPazRFD+l5z60BeR
 RoF/7pW66sK53KzDxLtuJD2rNKOOmqBBkjQeHyl5jawUOZ/Y1UOadlTZB65ZWFXxrt0twmU
 tAu1MZiUe9Yeb6WDexb2A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tfoeWDju7B4=:aVEfO6GLWufj1jsRc+5PZ+
 o9GPiYTqz+YKct6zSvUcayMYwQkcfuRLa9l4+jxW2yR3Wo8QthXwXKuKJgDoS6oEgjl/KwBuW
 im3Y8wo68d+WkrEA6cyZXLPWazUfClS5txf4KaWSXwEe6uiPUh1u71de1egsR5tJNQYmc2tjy
 ROaKfJ5YxTUkjXrZnqJyml/GFjPM1Ei2WTy3poAkbBEacnHTZdz9E0wSSjRA+kyN4dtA1awfJ
 4vXNLqJ50+h3FUrgHH4jQ/eXwC4AHXgay94U9sCBioJzzK6zJ7cl+h5ClOveSNXLIpw3Z9qed
 AGRukK8abn04V7KhzAukWSm1ru9oYuqT7FfQh4c4GvgsFtgE0GkNwppiMReqW5QZgiDXxe0nT
 D9hwMrMIZ45DgyBUEHBoiCxbLfmAwwRKbO4WqTBSsJiDiB79jEj0+fJwc0fsaTW5Fd/qi6mdb
 ZQQ0VgVGHkrJIjYiBDQLudaRcGxt64lcKtPwNtdYIihzlDobUipVvmvONtSdwJnbKD5vReQxy
 l3nKM1xM5Q+YOd2n5SZG3nKH9A4YR4Fl3+XtwqyiRMOAXTv0F3cTN2By8LiXH+DzdOk2gTCoF
 xplmgfuOJW0chQiWV3wF8RVM3fWufXclmbJo61OBxOE54LEJ0W20sb6LGzMM57qrJ1Xtthcar
 vUpv7OUuOLRPuYSRBIvOAwHFkNEAlZqc+FIwcpynGrUMwm7ZhkHcYQQN+h9dqnCVFrXqc1smg
 dBnzd8OOSeuRq3KeUhqii+vuN3zcStC+FGRW4VcerxOVrH+KNGsnOOlORVC4kfzCRYFp3CCDa
 MQnbDfjdQrw0L/s6qm4/pH5Ukzp3P5T9+JwaCMC09whcx7PDaQiVs5dykprsO16nFTC1DCR4f
 KitO0T/RIigFWVM0acZrrBLwvUuwVAd+wXc7hIuP3ROk6QlhpM8YaCh/JSuFEp
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s3KjIBQj56pvWxWnS4Fp9KvdtccGGD3KP
Content-Type: multipart/mixed; boundary="3GrjQ2enK1K7VNRNWy7wZBA5miNrB3TcR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?B?VG9tw6HFoSBNZXRlbGth?= <tomas.metelka@metaliza.cz>
Cc: Peter Chant <pete@petezilla.co.uk>, Chris Murphy
 <lists@colorremedies.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <8f59acfd-4d97-86d4-2063-25213e2770d0@gmx.com>
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
 <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
 <0024a4b2-7117-8d76-45c5-240e23edc29b@gmx.com>
 <5670f5ac-b9e9-8bed-67ee-d113a385a304@metaliza.cz>
 <d29c3f7f-33b8-e1fc-e6ae-672a5bf52376@gmx.com>
 <682fc519-49c4-8537-bd48-cff246a39092@metaliza.cz>
In-Reply-To: <682fc519-49c4-8537-bd48-cff246a39092@metaliza.cz>

--3GrjQ2enK1K7VNRNWy7wZBA5miNrB3TcR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/24 =E4=B8=8B=E5=8D=889:52, Tom=C3=A1=C5=A1 Metelka wrote:
> On 24. 12. 18 14:02, Qu Wenruo wrote:
>> btrfs check --readonly output please.
>>
>> btrfs check --readonly is always the most reliable and detailed output=

>> for any possible recovery.
>=20
> This is very weird because it prints only:
> ERROR: cannot open file system

A new place to enhance ;)

>=20
> I've tried also "btrfs check -r 75152310272" but it only says:
> parent transid verify failed on 75152310272 wanted 2488742 found 248874=
1
> parent transid verify failed on 75152310272 wanted 2488742 found 248874=
1
> Ignoring transid failure
> ERROR: cannot open file system
>=20
> I've tried that because:
> =C2=A0=C2=A0=C2=A0=C2=A0backup 3:
> =C2=A0backup_tree_root:=C2=A0=C2=A0=C2=A0 75152310272=C2=A0=C2=A0=C2=A0=
 gen: 2488741 level: 1
>=20
>> Also kernel message for the mount failure could help.
>=20
> Sorry, my fault, I should start from this point:
>=20
> Dec 23 21:59:07 tisc5 kernel: [10319.442615] BTRFS: device fsid
> be557007-42c9-4079-be16-568997e94cd9 devid 1 transid 2488742 /dev/loop0=

> Dec 23 22:00:49 tisc5 kernel: [10421.167028] BTRFS info (device loop0):=

> disk space caching is enabled
> Dec 23 22:00:49 tisc5 kernel: [10421.167034] BTRFS info (device loop0):=

> has skinny extents
> Dec 23 22:00:50 tisc5 kernel: [10421.807564] BTRFS critical (device
> loop0): corrupt node: root=3D1 block=3D75150311424 slot=3D245, invalid =
NULL
> node pointer
This explains the problem.

Your root tree has one node pointer which is not correct.
For pointer it should never points to 0.

This is pretty weird, at least some corruption pattern I have never seen.=


Since your tree root get corrupted, there isn't much thing we can do,
but try to use older tree roots.

You could go try all backup roots, starting from the newest backup (with
highest generation), and check the backup root bytenr using:
# btrfs check -r <backup root bytenr> <device>

To see which one get least error, but normally the chance is near 0.

> Dec 23 22:00:50 tisc5 kernel: [10421.807653] BTRFS error (device loop0)=
:
> failed to read block groups: -5
> Dec 23 22:00:50 tisc5 kernel: [10421.877001] BTRFS error (device loop0)=
:
> open_ctree failed
>=20
>=20
> So i tried to do:
> 1) btrfs inspect-internal dump-super (with the snippet posted above)
> 2) btrfs inspect-internal dump-tree -b 75150311424
>=20
> And it showed (header + snippet for items 243-248):
> node 75150311424 level 1 items 249 free 244 generation 2488741 owner 2
> fs uuid be557007-42c9-4079-be16-568997e94cd9
> chunk uuid dbe69c7e-2d50-4001-af31-148c5475b48b
> ...
> =C2=A0 key (14799519744 EXTENT_ITEM 4096) block 233423224832 (14247023)=
 gen
> 2484894
> =C2=A0 key (14811271168 EXTENT_ITEM 135168) block 656310272 (40058) gen=
 2488049


> =C2=A0 key (1505328190277054464 UNKNOWN.4 366981796979539968) block 0 (=
0) gen 0
> =C2=A0 key (0 UNKNOWN.0 1419267647995904) block 6468220747776 (39478886=
4) gen
> 7786775707648

Pretty obviously, these two nodes are garbage.
Something corrupted the memory at runtime, and we don't have runtime
check against corruption yet.

So IMHO, I think the problem is, some kernel code, either btrfs or other
parts, corrupted the memory.
And then btrfs fails to detect it, write it back to disk, and finally
kernel get its chance to read the tree block from disk and finally
caught the problem.

I could add such check for node, but normally it needs
CONFIG_BTRFS_FS_CHECK_INTEGRITY, so makes no sense for normal user.

> =C2=A0 key (12884901888 EXTENT_ITEM 24576) block 816693248 (49847) gen =
2484931
> =C2=A0 key (14902849536 EXTENT_ITEM 131072) block 75135844352 (4585928)=
 gen
> 2488739
>=20
>=20
> I looked at that numbers quite a while (also in hex) trying to figure
> out what has happened (bit flips (it was on SSD), byte shifts (I
> suspected bad CPU also ... because it has died after 2 months from
> that)) and tried to guess "correct" values for that items ... but no
> idea:-(

I'm not that sure, unless you're super lucky (or unlucky in this case),
or it will normally get caught by csum first.

>=20
> So this why I have asked about that log_root and whether there is a
> chance to "log-replay things":-)

For your case, definitely not related to log replay.

Thanks,
Qu

>=20
>=20
> Thanks
> M.


--3GrjQ2enK1K7VNRNWy7wZBA5miNrB3TcR--

--s3KjIBQj56pvWxWnS4Fp9KvdtccGGD3KP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwg6tkACgkQwj2R86El
/qgz2wf/XK93y+BXN9TOzgt8v73eJUYnDF2mBgao21Yn5kCD7OH0eeX/Iggo4jSY
mpFakyHfORUxcXZRaImdzg217OfHn4UZQJIdEdYf9KsMe9MxL44z1eR0ikuSBOqz
mTIqWUoUxOkKtpuP9cG9XK5x8f4GLWWkuspjhhrVYgBI3ClVqCqd0a1+GwzJRLe+
6gDjfWch7YIXZqiWHewVTKD2hGZ/3SVhufHEnmGxPtAS2CrFOHjAZLiarID7pgp2
DPc/g7UX/yvxoAxr8Ot5+tIecJHT4rG/OQoamD6pTTSOd89F/NNdOL496gswZVN4
pe7UszwbD8KQe9FZVY/sywhcI6Mazg==
=aJ8B
-----END PGP SIGNATURE-----

--s3KjIBQj56pvWxWnS4Fp9KvdtccGGD3KP--
