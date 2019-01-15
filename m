Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7071FC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4148520657
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbfAOMbg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 07:31:36 -0500
Received: from mout.gmx.net ([212.227.15.15]:33581 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727703AbfAOMbg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 07:31:36 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0McVKy-1h0ulG2yxM-00HjXn; Tue, 15
 Jan 2019 13:31:31 +0100
Subject: Re: BTRFS critical corrupt leaf bad key order
To:     Leonard Lausen <leonard@lausen.nl>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <87d0oyw46b.fsf@lausen.nl>
 <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
 <20190115120359.GG2900@twin.jikos.cz>
 <338c02b6-4cbd-87fb-88ea-8165b41b9208@gmx.com> <87a7k2je9m.fsf@lausen.nl>
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
Message-ID: <8f505efd-359f-e5bf-bbac-9dbe9a4eb0a9@gmx.com>
Date:   Tue, 15 Jan 2019 20:31:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <87a7k2je9m.fsf@lausen.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NaWaKBzEdQP4a9Sx9ev2yYiCfYkt6zgq1"
X-Provags-ID: V03:K1:LK+QTww965B9Wt4jeX6juxsFrt7nkaJmxOq/MApYkBvwHveLeLF
 hRqwO5uTkCnW42kxnqtTA3f0UajsjwJWKtnMaRixiIIzdDifhcjZbpF+lXMOS0ZWcMulyiE
 P598yLhX5c2o4rSXlhR4ZYCcgdMdigWjmaQAja6MIQAcTsUGc2LvjeULxxCLQE4dw9VecKo
 49nmRM4pYRZMjdpBmVc9w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:mQWfb1eBWIE=:uK2phlfQbjN04qc5oea7h6
 RzmPZNlWHN4thcYuyREDepBsUdqj1YfZHma03g4kJtTogncjFr2XGgLz1pd67Ba433OOaWz4C
 /xcc9WhBrHApDvKQcE2x7xSTewO3yaWfEtg3h5qB3qUdnFqAPH6iGtBHEx78hpCfEZfdI7brb
 wbhhxdvj01Yx7QzoVi2c22Vg+wSUj+0FAjCXlX0NUfEKnlYM8EUxjtuEad5308Rrn4edInvFM
 L+9ypHrSX72zP9vAZUcTsXHNTLxPiry7QWgGTpcXU26hRC8IcWMbF1nHKHbKLHIJu+rFrLSdz
 JPpwjpUs2g3Ssm7bTpgqFHbLyKfg11AXRFK+xBPaaoek3PPW6Q1gqUFSKuetJVu0oLakuIpbM
 WIfj8+9cm9+5sNvRA5xnBWzDG9Oq6j51wuYhaqGzClLMDxD8hTtxjnTdhtr1DLKeMgjuqKm4q
 ikwuwVkzqk1yciZf6CB/D43CImC4Jsgof1AHcVWXFcNjWhJNmvhJfZzfAEhCG+tBlgtTEME8J
 SCdRXLF9YcnDl+XbyGJbFOJaZkvTCRvAoP0nh0nSMQw0WvEz4DSpUKIFYEPjhLF3bli1lddTg
 h5Bd5qklv+2ONfriKhgJJrKNMllRChVweCQNW3JOEcMMK4l8WIauSlxBGKrQ8v2BZzQuu8oF9
 SSlpvSgGCp62JGNZry1EZ4sco7mob7jEQ1I/1VVcf2xYXrVfbtFADrNfyKci54CpkuD686lIc
 1DK5H8KL5pzTRmGqIYNpvro/P07QXE9j4sKAb2doGfdt+ZDE707Se72+AO09vnjdAEoxvxrwB
 P5IsjKVyKFLXIi2nWDM0zusXqp09SfsC4dkxxfdvGT9pfKkV3mF0ESQ+VJD9gb8ul1ybOwKaF
 177dIQ5s4EQR30q58h7ZajfTTAcIMKhesJ0Yl/S7QntjoudUPYcQ7kqQsz+4bo
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NaWaKBzEdQP4a9Sx9ev2yYiCfYkt6zgq1
Content-Type: multipart/mixed; boundary="P7EC00HD3HtGyTRQ2s9SA9TbZzhw5sgxM";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Leonard Lausen <leonard@lausen.nl>, dsterba@suse.cz,
 linux-btrfs@vger.kernel.org
Message-ID: <8f505efd-359f-e5bf-bbac-9dbe9a4eb0a9@gmx.com>
Subject: Re: BTRFS critical corrupt leaf bad key order
References: <87d0oyw46b.fsf@lausen.nl>
 <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
 <20190115120359.GG2900@twin.jikos.cz>
 <338c02b6-4cbd-87fb-88ea-8165b41b9208@gmx.com> <87a7k2je9m.fsf@lausen.nl>
In-Reply-To: <87a7k2je9m.fsf@lausen.nl>

--P7EC00HD3HtGyTRQ2s9SA9TbZzhw5sgxM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/15 =E4=B8=8B=E5=8D=888:28, Leonard Lausen wrote:
>=20
> Thanks Qu and David for your prompt attention!
>=20
> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>>> following tree-dumps:
>>>
>>>   sudo btrfs inspect dump-tree -t root /dev/mapper/vg1-root > /tmp/bt=
rfsdumproot
>>>   sudo btrfs inspect dump-tree -b 1350630375424 /dev/mapper/vg1-root =
> /tmp/btrfsdump1350630375424
>>>
>>> The root dump is at https://termbin.com/lz0l and the block dump at
>>> https://termbin.com/oev5 . The number 1350630375424 does not occur in=

>>> the root dump. The root dump has 16715 lines, the block dump only 645=
=2E
>>
>> Super nice move, it shows the corruption and the cause.
>>
>> 	item 66 key (1714119835648 METADATA_ITEM 0) itemoff 13325 itemsize 33=

>> 	item 67 key (10510212874240 METADATA_ITEM 0) itemoff 13283 itemsize 4=
2
>> 	item 68 key (1714119868416 METADATA_ITEM 0) itemoff 13250 itemsize 33=

>>
>> See the key objectid of key 67 is way larger than item 66/68.
>>
>> And furthermore, it indeed looks like a bit rot:
>> 0x18f19810000 (1714119835648)
>> 0x98f19814000 (10510212874240)
>> 0x18f19818000 (1714119868416)
>>
>> See one bit got flipped.
>=20
> Thanks for the explanation!
>=20
>> I don't know it's corrupted in memory or on the SSD, although I tend t=
o
>> believe it's caused by memory bit flip.
>> But anyway, it can be fixed by patching the corrupted leaf manually.
>>
>> I'm working on the fix.
>> Please make sure there is no write into the fs (just in case, since th=
e
>> fs should be RO).
>>
>> And prepare a LiveUSB on which you could compile btrfs-progs (needs so=
me
>> dependency).
>>
>> It shouldn't take me too long time crafting the fix.
>=20
> Thanks Qu! I see that ArchLinux LiveUSB is based on linux 4.20.0, but
> 4.20.1 contains some btrfs fixes. Should I make sure to be at least on
> 4.20.1 for this?

You won't even need to try mount the fs, so kernel version doesn't
matter here.

BTW, archlinux ISO is really a nice tool as liveUSB, your needed
dependency could be found by checking the PKGBUILD of btrfs-progs.

Thanks,
Qu
>=20
> David Sterba <dsterba@suse.cz> writes:
>> On Tue, Jan 15, 2019 at 07:48:47PM +0800, Qu Wenruo wrote:
>>> See the key objectid of key 67 is way larger than item 66/68.
>>>
>>> And furthermore, it indeed looks like a bit rot:
>>> 0x18f19810000 (1714119835648)
>>> 0x98f19814000 (10510212874240)
>>> 0x18f19818000 (1714119868416)
>>>
>>> See one bit got flipped.
>=20
>>> I don't know it's corrupted in memory or on the SSD, although I tend =
to
>>> believe it's caused by memory bit flip.
>>
>> Single bit flips are almost always caused by RAM, not storage (that
>> fails in larger blocks or does not even return any data)
>>> But anyway, it can be fixed by patching the corrupted leaf manually.
>>
>> That will fix one instance of the corrupted key, without an analysis h=
ow
>> far the wrong key got spred it's still risky.
>=20
> How could I analyse this?
>=20


--P7EC00HD3HtGyTRQ2s9SA9TbZzhw5sgxM--

--NaWaKBzEdQP4a9Sx9ev2yYiCfYkt6zgq1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw90pwACgkQwj2R86El
/qgZ6Af+J7FahcGaM+huXuzhvkYZVOcxGEAJDluwIdrRLqa6UQkmcwTdhWgl0+rE
ZFvhjOy/57UNyezjd/SqxyYRVkUuy+tlFZKKkrQTyP+aqUhVQaOO3Y4muaxOXDCq
2Sw72u+5WrHUkEgAMXwZllnglaGPhwyzdqdTf0OZzklEpExATXIgBr6jWuTNisl3
Gxey4VVRX46p3xeKRqtnNjmJbm+j+LsN1qxCgHByKrxZ1Ymldgwxk8GjAC7Alw7w
irJ929FrPXWRMKeyWKSBga93xX4bAKl4I/y7p2WXL42ZJm6wFTbFzq3Ld7WZspWn
uwZyOnmUs7Y5UzHMjNqWwt/F7WzqvQ==
=9/7k
-----END PGP SIGNATURE-----

--NaWaKBzEdQP4a9Sx9ev2yYiCfYkt6zgq1--
