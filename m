Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F88C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 13:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05177206C0
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 13:24:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="LecDcE43"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731031AbfDBNYN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:24:13 -0400
Received: from mout.gmx.net ([212.227.15.19]:35825 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729603AbfDBNYM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 09:24:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554211449;
        bh=k08DFTCjxXEg+Tb8AJzX8+MCYnuSGFd8jj6ITG/Y468=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=LecDcE43pZMOT4DvWUsBWQqBHHy7gw85q9w5U93LeVpD6i/1GXaRi084dPZiZa/Xa
         UsKmXuWZq63YvGFDMaWXbI1MupCbAJiRYpYwGeZyY8zsWIft+0SAzWCwVNTSVQaWFZ
         zOkoVw13sfi+z4wmZMXf/2hx/RVuO6s+EG/J2cas=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MRXzM-1hMDSq2FgG-00SeAU; Tue, 02
 Apr 2019 15:24:09 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>, linux-btrfs@vger.kernel.org
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
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
Message-ID: <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
Date:   Tue, 2 Apr 2019 21:24:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PUMnsA4Lz041cHrDthTLjCGrCWnCUxhTv"
X-Provags-ID: V03:K1:usaEv6nkAed7vS/RJLyrccJIc1R+SoBF7+OdDDCVLCiYKyOCgs/
 0f7iDq5DmZTpzfETrwXIAQQUoQbi16g3fJUhWBGba/sXlaeD7loo3t5l9ZTDaESI7jJdGIa
 J6bsdYEeMAVplV1O9GH7HNRNuxCb4zvqo5YTAFSPHXumYRe2vjVpDsC9cVEzZxgZHuWTN/R
 SB1ANagoNsfVfExDyLChQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Q+8vny9XHss=:tflccIREWX+fmfI/oUQYif
 xvczqU6XQjbrv1CgBTpUzbxToxGTqF/dKuhPgFC6BDLPI9d9YehLLIdaqN2AdfoUQv7nvtAX/
 AftAhZOzTh7p1DETnmd0nGKu4PpgJ9PPVUDMzC2L/j6/jwn5Duy0xi+bKlMLbNTCA5iv8rJFz
 r2zxAvmTrVXUVLlpsn3Cj8svJKAA/aZUCSCBSOON3TAvKJfYGCEa9Vb5/PmEHHK8CAoKoOZ/t
 JD+CEO0kOPXiavPdZJV6w7Kf4l8QyzHGSqvkdn9GuffZN1HH9tkiG9d3/pvQjzz7luWopEX6m
 JQAWxnWqi9P33T6j1V/cY+ee8Pp7KZwz254sVZQr2Bh5//mmGil+mBHphssns/O7SShK3gtew
 UB7w5Nr4aftCCOGcLiWaWM3L/ZMvmg0rAbG5hcvA4HyI93+d4iJb/Qx8yjH3BGmHm++B/kSwz
 1OK80WTUIprw1zVHva1UAeDFhc/EjGluLNJCe+vm+I40UHfPIebxTfAkuc+VfFC/MbXEAKPSN
 kFZf4XxmU/xVqmS0/v329NHoc0bHZBpa0VbsGgf+qsQTPSzBG58vdyMzS5cMZsisYfEStbb9O
 04iClqMsZtuy24qFXeEfOAx+r+rrBv+HTT3ioTQRjKzyk8gN9K9uSUSeG+wsNjK2ggEjvdwRq
 ORbGmJr9kTM+pode4lNOiXQg/y1UmYDCooCAJdSVIIRT7xARHJ4k8d+au6dYCcdgwoI5iQz1a
 JoYhhk3IBVNWqpcdT1dADIzj7dBHmh99h25GortieywHiUfNQn8pBq9Dlqaz4r8wdY5tmqsMu
 03FbDcj3bN6boROcZ3PyEFoGqEEZweJ4qQhzZpnE+W8MnJHuivdnLzlEtNt8LebCisP9ivsTe
 bvuVY3ilPjTyYUjx+oPTH7DAvysNaRZVDXKGni+94yUSlylKlTQijEpnGTZJ7U
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PUMnsA4Lz041cHrDthTLjCGrCWnCUxhTv
Content-Type: multipart/mixed; boundary="7WxOLvsmNhvlgVyTj9b7p4vLa5qfXZCR7";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>, linux-btrfs@vger.kernel.org
Message-ID: <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
In-Reply-To: <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>

--7WxOLvsmNhvlgVyTj9b7p4vLa5qfXZCR7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/2 =E4=B8=8B=E5=8D=889:06, Nik. wrote:
>=20
> 2019-04-02 02:24, Qu Wenruo:
>>
>> On 2019/4/1 =E4=B8=8A=E5=8D=882:44, btrfs@avgustinov.eu wrote:
>>> Dear all,
>>>
>>>
>>> I am a big fan of btrfs, and I am using it since 2013 - in the meanti=
me
>>> on at least four different computers. During this time, I suffered at=

>>> least four bad btrfs-failures leading to unmountable, unreadable and
>>> unrecoverable file system. Since in three of the cases I did not mana=
ge
>>> to recover even a single file, I am beginning to lose my confidence i=
n
>>> btrfs: for 35-years working with different computers no other file
>>> system was so bad at recovering files!
>>>
>>> Considering the importance of btrfs and keeping in mind the number of=

>>> similar failures, described in countless forums on the net, I have go=
t
>>> an idea: to donate my last two damaged filesystems for investigation
>>> purposes and thus hopefully contribute to the improvement of btrfs. O=
ne
>>> condition: any recovered personal data (mostly pictures and audio fil=
es)
>>> should remain undisclosed and be deleted.
>>>
>>> Should anybody be interested in this - feel free to contact me
>>> personally (I am not reading the list regularly!), otherwise I am goi=
ng
>>> to reformat and reuse both systems in two weeks from today.
>>>
>>> Some more info:
>>>
>>> =C2=A0=C2=A0 - The smaller system is 83.6GB, I could either send you =
an image of
>>> this system on an unneeded hard drive or put it into a dedicated
>>> computer and give you root rights and ssh-access to it (the network l=
ink
>>> is 100Mb down, 50Mb up, so it should be acceptable).
>>
>> I'm a little more interested in this case, as it's easier to debug.
>>
>> However there is one requirement before debugging.
>>
>> *NO* btrfs check --repair/--init-* run at all.
>> btrfs check --repair is known to cause transid error.
>=20
> unfortunately, this file system was used as testbed and even
> "btrfs check --repair --check-data-csum --init-csum-tree --init-extent
> tree ..." was attempted on it.
> So I assume you are not interested.

Then the fs can be further corrupted, so I'm not interested.

>=20
> On the larger file system only "btrfs check --repair --readonly ..." wa=
s
> attempted (without success; most command executions were documented, so=

> the results can be made available), no writing commands were issued.

--repair will cause write, unless it even failed to open the filesystem.

If that's the case, it would be pretty interesting for me to poking
around the fs, and obviously, all read-only.

>=20
>> And, I'm afraid even with some debugging, the result would be pretty
>> predictable.
>=20
> I do not need anything from the smaller file system and have (hopefully=

> fresh enough) backups from the bigger one.
> I would be good enough if it helps to find any bugs, which are still in=

> the code.
>=20
>> It will be 90% transid error.
>> And if it's tree block from future, then it's something barrier relate=
d.
>> If it's tree block from the past, then it's some tree block doesn't
>> reach disk.
>>
>> We have being chasing the spectre for a long time, had several
>> assumption but never pinned it down.
>=20
> IMHO spectre would lead to much bigger loses - at least in my case it
> could have happened all four times, but it did not.
>=20
>> But anyway, more info is always better.
>>
>> I'd like to get the ssh access for this smaller image.
>=20
> If you are still interested, please advise how to create the image of
> the file system.

If the larger fs really doesn't get any write (btrfs check --repair
failed to open the fs, thus have the output "cannot open file system"),
I'm interesting in that one.

If not, then no.

> I can imagine that it is preferable to use the
> original, but in my case it is a (not mounted) partition of a bigger
> hard drive, and the other partitions are in use. The "btrfs-image" seem=
s
> inappropriate to me, "dd" will probably screw things up?

Since the fs is too large, I don't think either way is good enough.

So in this case, the best way for me to poke around is to give me a
caged container with only read access to the larger fs.

Thanks,
Qu

>=20
> Kind regards,
>=20
> Nik.


--7WxOLvsmNhvlgVyTj9b7p4vLa5qfXZCR7--

--PUMnsA4Lz041cHrDthTLjCGrCWnCUxhTv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyjYnMACgkQwj2R86El
/qiZMggAmNwGeelb0w6zr/gz8991CEChMydqAm/GZD75NqW9l9itazS8+fAUc/gc
5KaU4yik4eGR+CmFQULSJWQRCa4xf69GqIlSJ6zGBF3hNn42Tb4jzVltSJVnt19Q
88/keNX5u9dHadVXplqct/D8JVyMOkRWmpaMoaPRaoIdMAy3KenBmdLgLqBTT5cW
vtyJIZYdvVscUvTzRUZyuQrDEyUvUhCoM5wosFDV+WlLQmtF0MvSRq7V6/snh9m5
IvLeHyPnBOy+OG7M7CTLa5yvMFhz6ibO68WSYpD/sz8GNJkcPasRA2H1tLCBuUDd
G8hz9EtQNNqeMzBsIctCVU+mwu1FrA==
=YRAl
-----END PGP SIGNATURE-----

--PUMnsA4Lz041cHrDthTLjCGrCWnCUxhTv--
