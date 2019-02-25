Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391C6C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 00:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E98A120989
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 00:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfBYA2L (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 24 Feb 2019 19:28:11 -0500
Received: from mout.gmx.net ([212.227.15.19]:34047 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbfBYA2L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Feb 2019 19:28:11 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LrNE4-1hALBx1IFA-013ANH; Mon, 25
 Feb 2019 01:28:06 +0100
Subject: Re: RAID1 device deletion feedback
To:     Nemo <me@captnemo.in>, linux-btrfs@vger.kernel.org
References: <d1eac64c-056b-a95b-7890-875d313a7ab4@captnemo.in>
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
Message-ID: <50bda293-891a-6c6f-8696-77037880fc12@gmx.com>
Date:   Mon, 25 Feb 2019 08:27:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <d1eac64c-056b-a95b-7890-875d313a7ab4@captnemo.in>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gJAJt2kw2ZSbXmb0bUg1q8L4TGL8o3oWu"
X-Provags-ID: V03:K1:FNUeNBd8g6MQd/55Hzg6tVBBlt5MXxFBLswDFMv2yCchrAqSrQY
 Eq1s/xefJEZ1MkvU7jykIOvqEmWEcZLUe6bMkMWqnVsyHk1uI/5DoFZnCjM4Jzkx1jv5B6z
 YK2NPDgc1w61BtVzI1OizEkxY8yR+6qUVfiR7U+zTlLbyDGvoAB7XC0z5KQzWChfZpSgAoE
 nsYvz58yjgltkDRqI7MxA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tYW30v8ZZZw=:osvyOclB4dYKXLkvYuwxE0
 9BWKluor0FRV2ZHchKJkIAONQ35JVoju/tDGnyGXEJWt432CpMmwSNh44tqjiv86FEDlERe8+
 K2afCxJOeMgM0BKVt1Oj7OJdAK6mV01VmYWCPSM940fjnWkQFJ+lZfno+BfhDIH2BrXsDsKeA
 KDtLFvf9iJZspN/WWhBnf32ZnisXhgBXz0Zw2ciB0CIgyomZm7M7sdsIKno26W1aeIVGasOIq
 Vq6FQDW8k3T1glWtvZLrUPeq/h3yhd4SH1S6Uf5HaCbLT7CSfqINlg5WHDLuCZ7n/LcNQa2GY
 ZA7qJgI1km3RV7eu13OCtIGrpktItwR64Kpis0aWiqd8WQlwVLE6oW6CqoWViU+e70jkRmaSk
 vsWKOGmyn9bCYetXe92FEOr1jI6OeWLxvVorEahFSnDWkJKxOtOmGU214+YBbgQB97IwuhZh8
 JMJrmjxxhZ5BVsDPJk7fKH1rBA6Rq/QCQ2yph4bx2O1JuP5OkLd7Sl0UTuidSQHz9ZWWi8vYI
 /qCjuN8LiESvY2YYcjNpUXF2S+gtC7HcL0kwEVScRjB0NQhcWCQpilajlLlnf0feZswiMPDO7
 0rbdjf33OhzJZFliLoePmUw4NdYTPsys/TXZ+GLbvcZ0luGpEy39iuK+a76hvcB68RCXn3LYf
 Vt9kR6anRZEInKathd3joHw4tvJZLHB7MamDXntk6hMgrsGSqCcYHVEJDfW2eONoy1q0hLCee
 LIB7puUORxebSdOhp8q03Y8AeeW/lHDuczhOT8fqd26/3gPooU8maxuDUbA1dhHs52M7dAQ2T
 MVELU/Oby/d/XM4kEPY6wnAUwL2FAxns83u3j9CKF9nGBxCtanGZE1CKPGMZ0QOyfSZrTw3eo
 UWtNgLKdshg9m0w6YtFRGlpKZluQTm16jPvOcYZ0UDlWsCI7/6GABc9ygjzsI4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gJAJt2kw2ZSbXmb0bUg1q8L4TGL8o3oWu
Content-Type: multipart/mixed; boundary="cB2PpCmdOOn8vQoRRQ2cx493Ztv8gh20s";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nemo <me@captnemo.in>, linux-btrfs@vger.kernel.org
Message-ID: <50bda293-891a-6c6f-8696-77037880fc12@gmx.com>
Subject: Re: RAID1 device deletion feedback
References: <d1eac64c-056b-a95b-7890-875d313a7ab4@captnemo.in>
In-Reply-To: <d1eac64c-056b-a95b-7890-875d313a7ab4@captnemo.in>

--cB2PpCmdOOn8vQoRRQ2cx493Ztv8gh20s
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/25 =E4=B8=8A=E5=8D=881:32, Nemo wrote:
> Hi,
>=20
> I had a RAID1 disk failure recently, and a limitation in number of SATA=

> connectors meant I could not do a live replace.

Then you should go USB or other interfaces.
In your case, device deletion is not possible due to reasons explained
below.

> I'm still in the
> progress of resolving the issue, but posting some feedback here on the
> issues I faced and what could have helped.
>=20
> **What all I did**
>=20
> - remove the dying disk and mount in degraded mode. This didn't work,
> but _didn't provide me a failure reason_

It provides a failure reason, in dmesg.

> - swap the dead disk post boot with the new one. Tried a btrfs device
> add, but it failed as well because of too many failing reads from the
> dead disk (which wasn't even attached).
> - Started a btrfs device delete, which finally pointed me to the root
> cause:
>=20
> `ERROR: error removing device '/dev/sdb1': No space left on device`
>=20
> In short:
>=20
> 1. My 2.7TBx3 setup was storing 2.9TB of data

If using RAID1, it takes 5.8T of your 7.1T total capacity.
Removing one missing device will cause ENOSPC failure, as 2 devices will
only be 5.4TB.

What you should do is replace, as during replace you only need one extra
chunk and your current device free space is completely fine for replacing=
=2E

> 2. Removing any one the disks was not possible without losing some data=

>=20
> However, getting to this error message took me hours of effort, despite=

> having read the btrfs wiki.
>=20
> **Feedback**
>=20
> 1. The `btrfs device delete` command should have failed immediately
> instead of making me wait for ages.

Not that easy, as btrfs replace/delete/relocate all happens at chunk
level, we can only do educated guess to determine if it's possible,
especially all those operations are done online, user can do whatever
they want, initial estimation is not reliable.

Thanks,
Qu

> 2. A delete command should stop writes to a disk, unless avoidable. Thi=
s
> would have left some data on the disk, and a subsequent delete could
> have cleaned it up much faster. It failed in the worst manner possible,=

> because all deletion progress reversed once it failed: it balanced back=

> to complete usage, causing more strain on a dying disk.
> 3. A degraded mount failure should provide some error message.
>=20
> *Status*: I cleared up some disk space, and ran another delete which is=

> still ongoing. I don't have physical access to the system for a few mor=
e
> days, so adding the new disk will take me some time.
>=20
> ---
>=20
> ## Debug Details
>=20
>=20
> ```
> uname -a
> Linux tatooine.captnemo.in 4.20.10-arch1-1-ARCH #1 SMP PREEMPT Fri Feb
> 15 17:49:06 UTC 2019 x86_64 GNU/Linux
>=20
> btrfs --version
> btrfs-progs v4.20.1
> ```
>=20
> A few more details are on a reddit post[0] I made to help debug the
> issue and a gist[1] has disk usage and filesystem details.
>=20
> [0]:
> https://www.reddit.com/r/archlinux/comments/asrlam/btrfscleaner_at_100_=
cpu_usage_on_raid1_setup/egwc047/
> [1]: https://paste.ubuntu.com/p/GDNKNBqqFy/
>=20


--cB2PpCmdOOn8vQoRRQ2cx493Ztv8gh20s--

--gJAJt2kw2ZSbXmb0bUg1q8L4TGL8o3oWu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxzNo0ACgkQwj2R86El
/qgaCAf+I7Ah3KAVFMJkte97j8vlTu/ZQb+s4NtvIp6TRSVEKKLUXxKHPM+d7KKu
otupv28jemA6l9pzBRDfdxoVXIGb8C91V6p8uNtAVdKsuuQWGT2rZX3VNMcOLoqc
ebiyo9ob9qBJJx9q7aoCXr4irmOJR4O/uQ4htLLKCEjOer7oKWUq/FG3+tckjhnL
A6r930FDJs4XggvlD4NWzYkTU/FX5NTCLwh9TX35ndUn3rc1Fr1j4N0h3yrkj53T
yMOQGlXCpf56g7jiTLqn8p+zq43EvucIkNy6/xqcr9deUvqgMkSQd/vOmUeRgJXx
fZ/EiPuldm7YpNBaqUIcposJx+Lzzw==
=EGa8
-----END PGP SIGNATURE-----

--gJAJt2kw2ZSbXmb0bUg1q8L4TGL8o3oWu--
