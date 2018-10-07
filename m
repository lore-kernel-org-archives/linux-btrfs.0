Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7452C65C30
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 08:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69A702088F
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 08:19:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69A702088F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbeJGPZu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 11:25:50 -0400
Received: from mout.gmx.net ([212.227.15.18]:40891 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbeJGPZt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Oct 2018 11:25:49 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Ldq55-1fRF9b48J9-00j2o5; Sun, 07
 Oct 2018 10:19:18 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Ldq55-1fRF9b48J9-00j2o5; Sun, 07
 Oct 2018 10:19:18 +0200
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
Message-ID: <14c82713-72c8-a243-293b-5c482031f70a@gmx.com>
Date:   Sun, 7 Oct 2018 16:19:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CAG__1a75dV6zVzMQFrnN-6u0iPXQRgvKebTkM1kxoiKgm3bcwg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lUetEOkQrXHuEiQLHm2blZgJw4NlSTwPA"
X-Provags-ID: V03:K1:N+xk2Ye6XPE1kNSJb1ZqV/LR4Wqea/RS0Te4Pt1J3qKz8/W4IS1
 9PNRitYZcCuYvnyvjKgNcDL/+nQxag4MhJFr9nattIjlT9vFrc9FH1ZVdWFUhOM9W/Kvu1g
 rcpgfI96mnbageQ/mYiKhZ/+RWgYPOtv+YAN2Tz+DwyQT7Wswgj3/oTHopTR4lmnUlqxBFE
 r2haEgzp2KBYwvjcqXczw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:iHfP8Bhu8M8=:YX+k48t4aBVt2PCv6Kn9Xi
 FxLXTY5W2ohzWJs/gSPrIhssbheIxvPzpDkjWihi9IiHIMKAJQTmCoyAw8e+tx0AbJQLh4LHf
 jNnq5HOHm9dbVmHCwk1Jp8+61dyhnpqPoimAiWeATGy3ozCbkZSfh20r+L6TfayqkxIiRlaVq
 DYpuCFqjn6pn9tZKSZvnHUOaUvckqgCpJtRiY3OGIvwwDvyaUXBU+Gcltj6mQ7b+eJzxWxY57
 lgluPCBzmz8PdrAgxxzRaerATN5EVixMFbO+k5E3HsvkuYDJvnE202Fxq+AeKByaIqRAVH+Dy
 MXkFkTkle/BT124hxU7uhHOZd7CoXHPWB1CgsMLoiErwfMulBiAU0CsoDdx/ESSTr3uFxtgzV
 PD444qG2SBSJ0OdDZLjyV/3jjG3pcolzSUOhSv+xD8N0d98aMIlMe3MQU6ApkDZr3E3/Db3L5
 6j5Ak/oQ8VoXgC+Lr0KCHpmjSv7ugPf+YQqxvT5VurFU44qncDJjopb6Hky92FzLMT4mFK6Xi
 7TyY4AZk1A+3PDnn4PFs4jRLoVnADEQy+v0LfEPz2/m6CCQOxoYh7+M8HhnhmKhRaFQJo7hsy
 gDx5Ag/hT8EAmx43rNW0WvXbKniNj1Pp7vws0S/2ZVz1eKMilPR3CNeuR+DaiaAKTmHW3QbYq
 T3lYjjjoSUx5yeHkhjBSJK4YEm8o4dkriJUEso/+HE2WSGWrC13d9SSmwMpM+qhFxQKtgZdjR
 V7MCeoTUF6/GPE9o6NkvA5PUgRHgmdmfJpr2Bk73T/RN3SY3j3zUEKd84yPHZ+7Q6lmWHV0x5
 5xNWvfrPZjthTQJ5ZNu4QAzkAo9Ag==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lUetEOkQrXHuEiQLHm2blZgJw4NlSTwPA
Content-Type: multipart/mixed; boundary="XhKHoadgxrhdNHWORWBpZ6dT6aJXISYol";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: evan d <forumscollective@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <14c82713-72c8-a243-293b-5c482031f70a@gmx.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS
 filesystem
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com>
 <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
 <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com>
 <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
 <2122b08c-0fa9-b774-cbad-67b71f5084d4@gmx.com>
 <CAG__1a75dV6zVzMQFrnN-6u0iPXQRgvKebTkM1kxoiKgm3bcwg@mail.gmail.com>
In-Reply-To: <CAG__1a75dV6zVzMQFrnN-6u0iPXQRgvKebTkM1kxoiKgm3bcwg@mail.gmail.com>

--XhKHoadgxrhdNHWORWBpZ6dT6aJXISYol
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/7 =E4=B8=8B=E5=8D=884:09, evan d wrote:
>> If first 128M doesn't hit, I highly doubt something more strange happe=
ned.
>=20
> Not sure I follow, do you mean if it doesn't hit then it's likely
> something else went wrong?

Yes.

If it's just a simple offset, it should hit.
If it's some simple corruption like bit rot, it shouldn't cause all
super blocks to be corrupted so seriously.

>=20
>=20
>> I'm considering something like encryption.
>> Maybe the disk is already encrypted by hardware?
>=20
> The drives were never encrypted, none of my drives are
>=20
>=20
>> Windows is just a black box, I have no idea what a Windows could do to=
 a
>> disk.
>>
>> But it doesn't explain why the 2nd super block can't be located, unles=
s
>> Windows is wipe more data than the first 128M.
>=20
> I'm thinking Windows may have tried to convert them to Dynamic disk on
> detecting them and assuming they're empty.

If that's the case, and sharing with Windows can't be avoided, then next
time please use partition table (GPT/MBR) other than raw disks.

>=20
>>
>> If the disk is larger than 256G, would you please try to locate the la=
st
>> possible super at 256G?
>=20
> They're both 6TB drives
>=20
>>
>> # dd if=3D/dev/sdb bs=3D1M of=3Dlast_chance.raw count=3D128 skip=3D256=
M
>> # grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" last_chance.raw
>=20
> dd returns:
> dd: /dev/sdb: cannot skip: Invalid argument

My fault, skip should be 256K not 256M.

Thanks,
Qu

>=20


--XhKHoadgxrhdNHWORWBpZ6dT6aJXISYol--

--lUetEOkQrXHuEiQLHm2blZgJw4NlSTwPA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu5wYEACgkQwj2R86El
/qi6zwgAros80Cw2oVDpYCMjObDqtASe9BcC34JE2DOTvcjTZfhCyf+BD1a1OMDJ
zolnST+Zh37QF4ttyUw+OO16885RQPapVP5e3ublPN7Smq+FH1K892NTmexuqoAr
NILxtiXSeyMUeKozm+NT4dyDkuAWp8SAm+9PUHVAAxWDmmz23THQDZGuUGWxkRzk
wknZmZ0O0/G8ySUeQhoM+87iwkdB4EeU+na5x8525CUjnkmj0gWpetp8XOpmE0z1
iTGGKhBqrRDP+1Iv5ndaCYMb2Y5LwwwDYsAv0LHGVif07XXXJr5HLnsw/qzW3M0Y
d7GzmrcoU/G4uV1ZX5OISwtf5Tx/5Q==
=YXFy
-----END PGP SIGNATURE-----

--lUetEOkQrXHuEiQLHm2blZgJw4NlSTwPA--
