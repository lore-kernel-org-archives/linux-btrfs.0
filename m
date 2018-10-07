Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2917BC677F5
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 10:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9E422087D
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 10:51:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9E422087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbeJGR6H (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 13:58:07 -0400
Received: from mout.gmx.net ([212.227.15.18]:60847 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbeJGR6H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Oct 2018 13:58:07 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M7YF5-1foI6i3PEd-00xKCP; Sun, 07
 Oct 2018 12:51:12 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M7YF5-1foI6i3PEd-00xKCP; Sun, 07
 Oct 2018 12:51:12 +0200
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS
 filesystem
To:     evan d <forumscollective@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com>
 <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
 <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com>
 <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
 <2122b08c-0fa9-b774-cbad-67b71f5084d4@gmx.com>
 <CAG__1a75dV6zVzMQFrnN-6u0iPXQRgvKebTkM1kxoiKgm3bcwg@mail.gmail.com>
 <14c82713-72c8-a243-293b-5c482031f70a@gmx.com>
 <CAG__1a4_jPWJ2LcBQ2ubWeuXR3AWa4vS7vrV3Ysm-wFORddH7g@mail.gmail.com>
 <7ffc25c7-1442-99da-8600-add6b3ce2dd4@gmx.com>
 <CAG__1a63yUA3N4N2HjsTS7ng3tkxei6Vpo3QdckPu1CDLyv0yg@mail.gmail.com>
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
Message-ID: <8968c012-7732-2338-c505-2027539cbe56@gmx.com>
Date:   Sun, 7 Oct 2018 18:51:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CAG__1a63yUA3N4N2HjsTS7ng3tkxei6Vpo3QdckPu1CDLyv0yg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="H5x3yGwpBkY2bGsiMw2FO9i6qMDcxfghd"
X-Provags-ID: V03:K1:5AfmDd5ZVSWVI4WrQ1fRXkJLVrkkreAgPMcM3PTbhFEKCiZXw+m
 lKOKdpCfGrMo9hgFQa/LK45wxcQ/8+yizThlaME6rpm94QbpMMuOmDVWpNUTyW3EofZdkOS
 Yr0YV+/HLlHd+ZsOKpc9cttE+wmhX9uhxpzZKDHCAzN4Zc6/m3STZ2YB7xfdEOIDDJENQN2
 VmYEeFd2NhUFmwhyPQVfw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:rovAAS8Mln4=:2wFAvam+FRyEID2qhWE11b
 IAxFL0BDJ0XFvorl2yHaZ0Hf/YWhRUbIrVG9wap5cvyiRvyZpEEpc1OZVUAc0Wg3lDZtWZRvt
 I7JG5/tqChT41aS7DEsmEXPKWXW8s0es20jV3bHaT5UWIKJvXLEyjDg3Wl5RLRse8v4bHX27b
 Rzdtnoc5c6Y0IMZnmNcKvzwWGpxT6kFQJDEJ3nt1NSsCgkeMoO9oXctNPFFRmE7b20ul5DyoD
 wmSrK17Onp7bCluzQZpaviYbRMTjAuA6VQteuXxRdbSJVznOvKFOH31DsehezMeGpSJpNsV+J
 sTGfj3KQFi2k42NL0U6WzpzUlSN/B/G/sL2U4AfPrkpNwP5HWwy0WloM53RtErlm6JGBJaMTV
 qFQ/EunzQl3gnUZ35DTyHWuk/8TkM0TBS8jtR3934NvCa7sDMDYg70qzL2o/uC0MdedUPh8zO
 MVwGSPgIjESB6g+Y95QBIgkO39YvyYHBR2r/qHzewSfb5wdsEmdWKLwaRf773hEcefc+D60aK
 Rmr0TRVvyTZPgSMP+fV0M8P5Yy0a8YENIJ3cLXHUQflJNTzgmowV8QMGZAfhdWgSIrysLgaRT
 AkrZj+FcYrzfDerW5tlfMSMqwWMezOd1g4tYumbr/tsQCaO0/wfqPOowfYVCcqye8XtpVV9jb
 SqXkJmxZIl6WZ9D/svWWRbyElBgNMK13oF0FjokU/6y1ftQxE/j70VZqlmchR0zZalSTSm8FQ
 T02lfUqpWCuTwGkURjFJ/uB81cGVjI2q/XWCH0rYk8TlhOHIqYn54BZPQyDkYIqLMy8X/g8Ta
 BTcbUnpOnE2KCPEBGF3fFfp6w7pTA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--H5x3yGwpBkY2bGsiMw2FO9i6qMDcxfghd
Content-Type: multipart/mixed; boundary="h6xU4VMnzgoS3Z6myjU9zQmo9sudUSSHu";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: evan d <forumscollective@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <8968c012-7732-2338-c505-2027539cbe56@gmx.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS
 filesystem
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com>
 <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
 <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com>
 <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
 <2122b08c-0fa9-b774-cbad-67b71f5084d4@gmx.com>
 <CAG__1a75dV6zVzMQFrnN-6u0iPXQRgvKebTkM1kxoiKgm3bcwg@mail.gmail.com>
 <14c82713-72c8-a243-293b-5c482031f70a@gmx.com>
 <CAG__1a4_jPWJ2LcBQ2ubWeuXR3AWa4vS7vrV3Ysm-wFORddH7g@mail.gmail.com>
 <7ffc25c7-1442-99da-8600-add6b3ce2dd4@gmx.com>
 <CAG__1a63yUA3N4N2HjsTS7ng3tkxei6Vpo3QdckPu1CDLyv0yg@mail.gmail.com>
In-Reply-To: <CAG__1a63yUA3N4N2HjsTS7ng3tkxei6Vpo3QdckPu1CDLyv0yg@mail.gmail.com>

--h6xU4VMnzgoS3Z6myjU9zQmo9sudUSSHu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/7 =E4=B8=8B=E5=8D=886:39, evan d wrote:
>>> like so?:
>>> grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" /dev/sdc
>>>
>> Yes. And it will be very slow, since you're going to read out the whol=
e
>> disk.
>>
>> But I don't really think you would get some hit, according to current
>> result.
>=20
> Ok, so it is what it is.  Based on what you're telling me, whilst the
> data may be there and intact, the superblock is irretrievably damaged
> and the data is thus for all intents and purposes lost.

Although the result is the same (data all lost), but I don't believe
it's only super block corrupted.
If you have some special magic string, like "#!/bin/bash" or "\x7f\x45
\x4c\x46\x02\x01\x01\x00" (elf header) , you could try to grep through
the whole disk.

I believe the data (or at least part of the data) is also corrupted in
this case.

>=20
> I may as well use wipefs to clear crud from both drives, partition and
> format them and then use them elsewhere.   -- this more or less
> accurately summarise the situation?

Unfortunately, yes.

Thanks,
Qu

>=20


--h6xU4VMnzgoS3Z6myjU9zQmo9sudUSSHu--

--H5x3yGwpBkY2bGsiMw2FO9i6qMDcxfghd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu55RsACgkQwj2R86El
/qgo9wf/epbzoyhIU7/YrZjVH3ozoekrYxe9yc32079mRWheZkiAKkUToRJOwuR3
0RZ+2wfnKWHHnzRzohBXEfAkJlXxukI+KhXxbnLkds5ejqSwMym7+4mKmht3zGqg
nhos8JM8aHQajOZz8KoFkSowrLELfrCooHQO83loXfdtKEZRASRyLz1NiFh+KLjK
sVxygZrz18exo0F5TLTFqdCE8h6tZ8O1AaRFZ4dfH0CECpqrBwbvfDpHTV98Ue6t
xC8vEaertlmtQZrRZzHzqGa8A7PNLnySmw1jiIM5l7EQXf9WmjTzSMPhgOO83rbE
HKNgGG2Jieh4xsm1dzJyVMHZddp0Jw==
=39jv
-----END PGP SIGNATURE-----

--H5x3yGwpBkY2bGsiMw2FO9i6qMDcxfghd--
