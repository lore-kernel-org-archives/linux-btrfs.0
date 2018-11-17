Return-Path: <SRS0=Z2Dq=N4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB46BC43441
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 10:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 677EB206BB
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 10:05:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 677EB206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbeKQUV0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 17 Nov 2018 15:21:26 -0500
Received: from mout.gmx.net ([212.227.17.20]:44239 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbeKQUV0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Nov 2018 15:21:26 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MTSmp-1fvWZS2ADf-00SK4o; Sat, 17
 Nov 2018 11:05:14 +0100
Subject: Re: btrfs convert problem
To:     Serhat Sevki Dincer <jfcgauss@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAPqC6xSUYc-hphH2UeG3b=JxBheJy6bejtwLc=8m5znugwH0Xw@mail.gmail.com>
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
Message-ID: <380f334f-c67a-c3cb-f007-987cd95276d2@gmx.com>
Date:   Sat, 17 Nov 2018 18:05:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <CAPqC6xSUYc-hphH2UeG3b=JxBheJy6bejtwLc=8m5znugwH0Xw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="851J1rOq1pBdSqFGFbX55ZZ6sPPmN1c9R"
X-Provags-ID: V03:K1:1gMzIw0ePm+oj/P0z3ANHKmR9VkRdL4zZapXHyNIg7khIxPESBC
 CmGmkXBbwuw+huCScEU58iurwNC8QHEf8UmsCXQhfzFsZ7TU1CowrBwmsYolChTg9cgIpHu
 eHiKqNY+u05USudE62b+606rEmuLOyHvFoPl89aVBcwtEZcHk/9RvfoC+6GjDWNTJyG7b6o
 JyKTzPirhlrSYBv3XOZVw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:GHoTja91ttw=:whw0TbeD+uxO5onRoG8tXf
 Nz5xGZX/tTxhxl1Ed+UHZ5JZa+Qw/S/PkmlRGgF4tKoSqEii+qaZtf+qrVdfqYHbB5rhSI03S
 8O3O8lnip07L0pf5FF2BNrV/3r6xTGq1haKqAp12aG5YBPqPcjh7LIGHly0rklPAKF2w0hsyW
 KkDdsoiOx7WZz3HZJ8WwKH3k21dGlSAntKJNhSE2uBZQOiMS0n/3tarxZtmXuHaOelVl5eynz
 R8q7qvJKj/vUFi142MNdMofiI0Fy/Rgk5GK7arXtvJYtGDcPe/RZtcgyrLV+86zJd3a8mlFcc
 1HlR5SzQtFoLjvOh93CTDvY6/sIh5OcsvlPmH83sBMW+5H8Veatwvzx2HzUTSLlgwEOULDJwt
 nqQWTI8ch05mSv39vCPbNvJHX1TIs2mtFIHJtKyATVXpaemjRKZOnapPl7amKU++APEQNVugz
 dT8/E5FRVev+ulLYKxHugyCoSEMEBDdHqsZjzAl+N3tXXbgagHSqQskfXuEvSbhIh92iWejMz
 IOdKtvyqRhaCK75hpL2s9BGucd+YKwk4B0jCSB8aUjC1rOyIPuYqTduszk08AlUCYM43nLttN
 rrMP+ioMT7rcBHrstT+VhE3LqJmg6teI0MfRbGxYglFX/ZT+pTRGARpxG2pdcO/sDyt57+6bA
 uj+s0RrkKumhaHjB4J1YwnVq78HSB9YxVpOEefF4VgS6QhqPsR48rjHacUomtA2mRfKXT2j1X
 BGDAVISTghNhUKMu/TTVIemr8gtQurVSuR4kqq/DX7hV3iQIj/fRbhr1vo3lscBJJYdJXkmVW
 wEbCUxtsy7N+POjFc8zbCRbm+Mi7JyfpcIzXqjoByM0+NYVWKk6WhBxgDASB3cExYK4iZkg6S
 uUwhE13yntNRrK1ElGv1ddlP94jsHAL2Hnwkc2lc/AFPvsnaHcdCjAZ0g/rQnA
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--851J1rOq1pBdSqFGFbX55ZZ6sPPmN1c9R
Content-Type: multipart/mixed; boundary="JQOd3RxRkkGTlEVG3U3HnURv8EsB9GRvf";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Serhat Sevki Dincer <jfcgauss@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <380f334f-c67a-c3cb-f007-987cd95276d2@gmx.com>
Subject: Re: btrfs convert problem
References: <CAPqC6xSUYc-hphH2UeG3b=JxBheJy6bejtwLc=8m5znugwH0Xw@mail.gmail.com>
In-Reply-To: <CAPqC6xSUYc-hphH2UeG3b=JxBheJy6bejtwLc=8m5znugwH0Xw@mail.gmail.com>

--JQOd3RxRkkGTlEVG3U3HnURv8EsB9GRvf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/17 =E4=B8=8B=E5=8D=885:49, Serhat Sevki Dincer wrote:
> Hi,
>=20
> On my second attempt to convert my 698 GiB usb HDD from ext4 to btrfs
> with btrfs-progs 4.19 from Manjaro (kernel 4.14.80):
>=20
> I identified bad files with
> $ find . -type f -exec cat {} > /dev/null \;
> This revealed 6 corrupted files, I deleted them. Tried it again with
> no error message.
>=20
> Then I checked HDD with
> $ sudo fsck.ext4 -f /dev/sdb1
> e2fsck 1.44.4 (18-Aug-2018)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> HDD: 763513/45744128 files (0.3% non-contiguous), 131674747/182970301 b=
locks
> It is mountable & usable.
>=20
> Now my attempt to convert
> $ LC_ALL=3Den_US.utf8 sudo strace -f -s 10 -a 4 -o convert-strace.log
> btrfs-convert /dev/sdb1
> create btrfs filesystem:
>     blocksize: 4096
>     nodesize:  16384
>     features:  extref, skinny-metadata (default)
> creating ext2 image file
> Unable to find block group for 0
> Unable to find block group for 0
> Unable to find block group for 0

It's ENOSPC.
Since it won't damage your original ext* fs, you could try to check if
there are enough *continuous* space for btrfs to use.

Please keep in mind that, due to the nature ext* data layout, it may
contain a lot of small free space fragments, and in that case
btrfs-convert may not be able to take use of them.

Or you could try to disable csum to make btrfs take less space so it may
have a chance to convert.

Thanks,
Qu
> ctree.c:2244: split_leaf: BUG_ON `1` triggered, value 1
> btrfs-convert(+0x162d6)[0x561fbd26b2d6]
> btrfs-convert(btrfs_search_slot+0xf21)[0x561fbd26c881]
> btrfs-convert(btrfs_csum_file_block+0x499)[0x561fbd27e8e9]
> btrfs-convert(+0xe6f5)[0x561fbd2636f5]
> btrfs-convert(main+0x194f)[0x561fbd26296f]
> /usr/lib/libc.so.6(__libc_start_main+0xf3)[0x7f658a93a223]
> btrfs-convert(_start+0x2e)[0x561fbd26328e]
> Aborted
>=20
> It crashed :) The log is 2.4G, I compressed it and put it at
> https://drive.google.com/drive/folders/0B5oVWFBM47D9aVpJY2s4UTdMdUU
>=20
> What else can I do to debug further?
> Thanks..
>=20


--JQOd3RxRkkGTlEVG3U3HnURv8EsB9GRvf--

--851J1rOq1pBdSqFGFbX55ZZ6sPPmN1c9R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvv59YACgkQwj2R86El
/qiclwf/U4nA/gDQg9KzVXvYjULCKTJCC8VbR3M1NzfT9jlftt3S+sKnjBgkLHv0
H1i/O+wr35EIP23ec+aBTkogBDyieG74WVYbsprTdH/IjeaU0ns4c1JFiT0fxXSV
QrL+MnNc/cgSAtTB0h1SLwN76PNy7GZkMTpU6W0bel5HXzQpscKV2vvUJ6VpR/5+
1FbMWUYISMzWNxivgBChzKHYR/9QjyU+ljukAJarYqouSkvYxJCy2cBNmmOFJZCx
+FmrWZtv61n4XtHxv+dndTJlspPnot0hdp1P1o1XosrvuGQAq/wOh3vs3+nH7DAo
FxLDqCKaNeG5Cjv2O3MNvvRTrn/asg==
=eG/D
-----END PGP SIGNATURE-----

--851J1rOq1pBdSqFGFbX55ZZ6sPPmN1c9R--
