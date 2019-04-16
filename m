Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE1A7C10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B9112073F
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:56:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="L27oMmtq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfDPH4m (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 03:56:42 -0400
Received: from mout.gmx.net ([212.227.17.21]:50015 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbfDPH4m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 03:56:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555401398;
        bh=oM01hfF/Bfo0cyBXaazVVe+cRTignjLVwAS15QY9Cnc=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=L27oMmtq2Tdh1wQ2msZSQ1Aq+zPglA7CRUruk9bA9x7XGvOkoyEehaFhPodGGy9zg
         QeZvQcA0Ln4GcL/KG5F8JFBUhcRcEHs2RJBvptLKvj8gRXcmWaoMWeSQSQdmmh8ATt
         95yJ4HRKRsn42OSdKJSk5o9Z//ITbpZ+ZXj4CxWw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lmwpk-1gdgLZ1KQ8-00h2s9; Tue, 16
 Apr 2019 09:56:38 +0200
Subject: Re: Corrupted files support needed
To:     Daniel Brunner <daniel@brunner.ninja>, linux-btrfs@vger.kernel.org
References: <CAD7Y51iQMJQiTBBW9AqQ_-aJ6A4fMVEswyNwPMYnj5iAaLOXjw@mail.gmail.com>
 <CAD7Y51jD5HDjDHWNZwycYYb2UHjuao_X4bTT2ATeMiX1gOUi_w@mail.gmail.com>
 <d762e0b9-034e-9386-3ecc-ee182493a82e@gmx.com>
 <CAD7Y51jX2x39tLaDOL9LcBxSmGecG92-Xytku0TWsU4B5d=EcA@mail.gmail.com>
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
Message-ID: <6947fcc2-7db9-d796-0ed6-308ef8110d72@gmx.com>
Date:   Tue, 16 Apr 2019 15:56:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAD7Y51jX2x39tLaDOL9LcBxSmGecG92-Xytku0TWsU4B5d=EcA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Jat8LTvj27uH0SxVbiYmLXw2L4m4ZNcpT"
X-Provags-ID: V03:K1:0pcKTl6rmIbXI40tXJK0c5uu2CKxSBNor8JjsoQ8BObHBVi+/gE
 O4V7vBDMUa7qzTkp05OfDzs4yGi9J94uvFlPskb4Hdb0N6QbMFoDZCYDXpZLCqLX/f6QRJl
 ht+7sOlxpq7aRwV+SMZbeQHhabThKLmHcrr5il6O47PXfHuq2r+fzk8iF9QcShs7ojEDIvH
 VR0GrBcaqRPWRWH9o7JHg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:mUo6I+IncY0=:GpGQSwEaO3asdFvTfxeRST
 +cntkFiwBj9vSAhGG1hPzT5fYVNNBSDrY/+IgympRegb2VvgvxjbqYy6syGl6gVgHfpiB3JW9
 IkFVGd9qDsdeaDIbxgYrliz19Bxw76vEUKEQLYV8xQvxkG11Qe3gQ4tFeBPEdA5Wm6eG18VVr
 AJbOp5sosTWJo5mKRsawzUbz/UBrKQkOxxJkXuWcHwYV48jObsNVFAGOPxHkGh7XMr4RcsMTT
 xXVXHu4IvjIW1f62X+61vRPh/GdcbNoVym5M5mZnLhXdVEGjGoUf1xGf9o+d0XTFTw8HrC6d6
 hXA8ChdQYdFXEpMgYuE73VYescPHzG3SiWMyyxy0F9AVNjAkPTr67rQjKTvqOtqIWkQ47ltP0
 KCWeo4aeyJEHWUTTBcHGEuoNMeWQAq/I3GLLOoa6oGsS2MQj+xq5EWhda71pGutXCq5shXYXU
 VVvW1a2hIU0hltXbtmIo5PlLRJTe0MQbDo7BIAisBzgyqThcTdFHn/G0jqtxdiNQ9MNiD0xBP
 +n1+xu9Ttv/Hv8eeJAAyKm+pDBeqmd0JwSNpmkeJPoxmkP66AVc1AjujPx6uk3oNcu8HwpQQ2
 GuDOd4khr4PA9CurL26g5ecDn/b0FhkaNKQDPfgtdAuCin8aSG5djdjpsLzVm9JANglouSMY0
 IBII5E+307mf8ePqaOhET6jdhmhMHh/qJgFfXf5hDduAzp6yfAmWFe8tuNyWc/ujizhKjPqR7
 465g4sMGf4XxIfYObGR/yTQgdXJBQ5cEsq2me+nV0ChB+uhvLVum9MsBBWhG0F0ZlWaI/lDzl
 dON3zDgHdQLHTetNoNFXGul0F/AJHvJ35pQhqMcPhFp9RApKMG6/tnzOp+HwXpls7Mg+++zXB
 FfXjUpeUxFpn90JvP9LBPd+GeP/lo0KCVgV/kU1g/Q3MV9UYO49aLeWsIioWwe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Jat8LTvj27uH0SxVbiYmLXw2L4m4ZNcpT
Content-Type: multipart/mixed; boundary="tgo4nKNrws1X2H14VJKV1oiDEMMcmUD6Q";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Daniel Brunner <daniel@brunner.ninja>, linux-btrfs@vger.kernel.org
Message-ID: <6947fcc2-7db9-d796-0ed6-308ef8110d72@gmx.com>
Subject: Re: Corrupted files support needed
References: <CAD7Y51iQMJQiTBBW9AqQ_-aJ6A4fMVEswyNwPMYnj5iAaLOXjw@mail.gmail.com>
 <CAD7Y51jD5HDjDHWNZwycYYb2UHjuao_X4bTT2ATeMiX1gOUi_w@mail.gmail.com>
 <d762e0b9-034e-9386-3ecc-ee182493a82e@gmx.com>
 <CAD7Y51jX2x39tLaDOL9LcBxSmGecG92-Xytku0TWsU4B5d=EcA@mail.gmail.com>
In-Reply-To: <CAD7Y51jX2x39tLaDOL9LcBxSmGecG92-Xytku0TWsU4B5d=EcA@mail.gmail.com>

--tgo4nKNrws1X2H14VJKV1oiDEMMcmUD6Q
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/16 =E4=B8=8B=E5=8D=883:46, Daniel Brunner wrote:
> Hi,
>=20
> thanks for the quick response.
>=20
> The filesystem went read-only on its own right at the first read error.=


Then the fs metadata should get corrupted.

> I unmounted all mounts and rebooted (just to be sure).
>=20
> I ran the command you suggested with --progress
> All output is flushed away with thousands of lines like those at the
> end of the log paste.

Then please stop that running command, as it won't help much.

Regular "btrfs check --readonly" should be able to report the metadata
corruption.

>=20
> Does it make sense to let it run until the end or can I assume that 2
> drives are bad?

No need to continue, there should be some metadata corruption.

Above command should report something.

For the device corruption part, I'm not sure. But I think there is
definitely something wrong.

Please start salvage your data, as I'm afraid the fs is already damaged,
although not sure how serious it is.

Thanks,
Qu

> Also I checked SMART values but they seem to be ok.
>=20
> https://0x0.st/zNg6.log
>=20
> -- Daniel
>=20
> Am Mo., 15. Apr. 2019 um 13:58 Uhr schrieb Qu Wenruo <quwenruo.btrfs@gm=
x.com>:
>>
>>
>>
>> On 2019/4/15 =E4=B8=8B=E5=8D=887:44, Daniel Brunner wrote:
>>> Hi,
>>>
>>> after normal a reboot I noticed that many files fail to open / read
>>> (Input/Output error). I don't really have a backup of it (only
>>> snapshots which also seem to be corrupted too).
>>> The machine is remote, I can only ssh into it (at the moment). The
>>> raid consists of 8x 10TB drives.
>>>
>>> System & Metadata is RAID1
>>> Data is RAID6
>>>
>>> kernel is the most recent from arch linux repositories:
>>> 5.0.7-arch1-1-ARCH #1 SMP PREEMPT Mon Apr 8 10:37:08 UTC 2019 x86_64 =
GNU/Linux
>>>
>>> Disk layout & usage:
>>> https://0x0.st/zNBl.log
>>>
>>> Output of btrfs check:
>>> https://0x0.st/zNJs.log
>>
>> Strange, btrfs check reports no error at all.
>>
>> Would you please try btrfs check unmounted just in case.
>>
>>>
>>> Kernel messages:
>>> http://cwillu.com:8080/84.115.44.105/2
>>
>> According to the dmesg, it looks like one device is bad, affecting bot=
h
>> data and metadata.
>>
>> And thanks to recent RAID6 enhancement to try all possible mirror
>> combination, it doesn't cause too many problem to metadata at least.
>>
>> Although data csum is not that good.
>> Quite a lot of combination doesn't match checksum, and even more, some=

>> check doesn't exist in csum tree.
>>
>> An unmounted btrfs check is recommended.
>> # btrfs check --check-data-csum --readonly
>>
>> This would be better than scrub.
>>
>> And please check the SMART info, some devices look suspicious.
>>
>> Also, please remount the fs read only at least to prevent further
>> corruption.
>>
>> Thanks,
>> Qu
>>
>>>
>>> btrfs scrub is running but it seems like it will take weeks to finish=
=2E..
>>>
>>> Do you think my data is gone or is there anything I can try? An rsync=

>>> is already running, but every 5th file fails to read.
>>>
>>> Best regards,
>>> Daniel
>>>
>>


--tgo4nKNrws1X2H14VJKV1oiDEMMcmUD6Q--

--Jat8LTvj27uH0SxVbiYmLXw2L4m4ZNcpT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly1irEACgkQwj2R86El
/qhj0wf+OTvBFC1NxsmFPB78Y7eVbAzRzJNngmE3VOORBlsp6kwzQUVQyWsAOK/t
WC377fenttcUfbEMR8Mo+K0DF6N4QvNSwICMHvreQDwiDohk8t0tMwAi6ABzCpkM
ooqUh/N6CHUEDqMtTR9vLPQGM54uBMn1xb4YU521AItmbBcmE/BkBpD5LY1N+FnE
CvhJl9RorMSTb+KtXpJKzttjEyhuPeODu6yhlP6qWO7/drYFJZmi/RJd8b/a/7xk
SemKkDkb6bYwyeQhHDWFv5GIgOZIb7DePmbygztj6yLwqqItGKk9h/zp0frujpkK
Lhk74DWcHizd9ZjIMO5GWB49mLk2ZA==
=J4Sm
-----END PGP SIGNATURE-----

--Jat8LTvj27uH0SxVbiYmLXw2L4m4ZNcpT--
