Return-Path: <SRS0=9xGW=PH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C882C43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 04:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32808213F2
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 04:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbeL3EeX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Dec 2018 23:34:23 -0500
Received: from mout.gmx.net ([212.227.15.19]:47861 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbeL3EeW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Dec 2018 23:34:22 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MhiPD-1h0EaG3jmN-00MwOc; Sun, 30
 Dec 2018 05:34:13 +0100
Subject: Re: Firefox cache entries directory prevents rw mounting due to
 corrupt leaf. No way to fix this unmounted.
To:     Jesse Emeth <jesse.emeth@gmail.com>, linux-btrfs@vger.kernel.org
References: <CADXXWGzodu1EMVj+PxEiX53H-G0ZLUfqF4SvMWTqkZQRx4P2XQ@mail.gmail.com>
 <d326eed6-212e-8bce-3972-ae6f5c956f5a@gmx.com>
 <CADXXWGwK76qMrfRyCf=nPRs5nwMvvvvazMw0y70PpBcA2S2Uww@mail.gmail.com>
 <00381dd3-e8ac-f002-8344-c76c24f1553f@gmx.com>
 <CADXXWGzJFUJCN7-P4onvTYNDnC7jk3zrctCDa3garwao4oj9-g@mail.gmail.com>
 <f1600095-0c40-5559-032e-d67037b8e79b@gmx.com>
 <CADXXWGyv07ufaA5WdP65mCMac39wWOurG=vaGjCpr+Z8Q5F3Tg@mail.gmail.com>
 <50bf817e-8683-9307-948e-f66a1919c1a8@gmx.com>
 <CADXXWGx=HAT1AR2EL+BDyanGNyF1WK-Efw0zOmAqYLMf4UhC9Q@mail.gmail.com>
 <CADXXWGxf2tOoeuOXVBMvKPbA_L+Z-as_JM35cnYU9HB7=9RnOA@mail.gmail.com>
 <3001610a-8377-2213-6482-acdeeefb4995@gmx.com>
 <CADXXWGxCwQP+LBh9cZQsyCKaCTer7kTCzxF7fefsdB9h93-_Pg@mail.gmail.com>
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
Message-ID: <62a4f056-ab0e-6a93-54b5-50e9017d84c8@gmx.com>
Date:   Sun, 30 Dec 2018 12:34:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CADXXWGxCwQP+LBh9cZQsyCKaCTer7kTCzxF7fefsdB9h93-_Pg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qmGFOI4mvAlk6aoHlqSQpZQ5dSIpmJFAk"
X-Provags-ID: V03:K1:qRUsOKvkNsE6qwExiYJ4G1KzxKefCJPDqSXUvLuYt++hcx+DNmL
 2RSHtLH42cU85C1zZ7q4CaCu4iaVX8V0GkUS1NSpyVbdjiCJcwGmMCvBt/00/8T0m1IDhjE
 lLQJMUSR4/HcstPinxsfIGc1HWpQ+zdrQohXsdOkeHgrDCWJxxkULtBFbIMxZocFLfAXZ0M
 HtlEnDadXn8rm65SYvw0Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:DqJfgZMU1H8=:CHwwAG/wJYK9zbg1v3qMk6
 oMOuPp9P27MsVAY/dJOI+wcNfq8Ac8rsua671gF/2912fjElZwnATYMoU6WRVMnc43tq5Bpdg
 wrPfsXP1qK12iZAjF/aAanPbIsIpfqh/0uhoLDNjZzTTnUPXWehmUIp5h6k2UnyFLf37Lixgk
 wE7FOQxvSb1YHGrWBVjP0DHR7EiexuAKLGmkKmcsgVlnk1AkxV7kQ8FLoXWbArsbJZJfCUBFu
 Bzq/dGWqnEVJQ+eqP3GoVG8klw/Xl3Z3a2SKIjhDf6nK52UoEVH2kssepfXZvZBljnklcZrd8
 ykk4jzQk4/9YWJTQxyPwg9HG8XCOeea1TjwodxeswvTEA17NdOMh2+ClUj2o8aOuDNI0tWnP8
 NBjBOYsHP+piXLSQfQfp4pjofWyFPN/MZG3zmvcy5uqGbrsxJtGrSqgG8TWnQujDZX0EJMXhF
 JSlUC2BS2si3gPCIIwTXdxC7okOT2eOS+9WIhpc1ZcZRKyWF6I2wALcj8uEjSat9IUj4Bjrv0
 wEGXEIv+2lZfuLbqFaXrD9u1+F4ILK24pNv3j4/U0ljXOPCujTFyzropg+6yWDrekeQtAcV7E
 j65C28etS0V3uk6CHh0TjchmTWXblPcy4w7mLsK5DLyVDxzkvrpsJn8M2w9PLtGHXFeMr9Dba
 A/p8e3/nErTaVHClpj+UlmwInbkNUhgHaamdGPVIVqNCT6WGhP+XEDNHL5ihWJT5HITxFvOMg
 OWpfqjnfTF7e5oHyKBZHcXXBNlxvgpczUV62LwnG8OXBFZsvicPAFPvSEzss1ABBCN8xT5UON
 xgE9b0BorwsSWpBtUxt/6sgIr3mpaAw1nA39RfZmRoRbPWJ1a7D/G+mw0HhN6nqCG+u7h9V1y
 b7y40rZXacxHtu+omiMPx9ldagNwVbhHhFr6RrjTCqR6y3vTzoCU8di5+w8Zdv
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qmGFOI4mvAlk6aoHlqSQpZQ5dSIpmJFAk
Content-Type: multipart/mixed; boundary="MJdL4RXV7QKPln3tgfckzmvhhxx83cJWb";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Jesse Emeth <jesse.emeth@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <62a4f056-ab0e-6a93-54b5-50e9017d84c8@gmx.com>
Subject: Re: Firefox cache entries directory prevents rw mounting due to
 corrupt leaf. No way to fix this unmounted.
References: <CADXXWGzodu1EMVj+PxEiX53H-G0ZLUfqF4SvMWTqkZQRx4P2XQ@mail.gmail.com>
 <d326eed6-212e-8bce-3972-ae6f5c956f5a@gmx.com>
 <CADXXWGwK76qMrfRyCf=nPRs5nwMvvvvazMw0y70PpBcA2S2Uww@mail.gmail.com>
 <00381dd3-e8ac-f002-8344-c76c24f1553f@gmx.com>
 <CADXXWGzJFUJCN7-P4onvTYNDnC7jk3zrctCDa3garwao4oj9-g@mail.gmail.com>
 <f1600095-0c40-5559-032e-d67037b8e79b@gmx.com>
 <CADXXWGyv07ufaA5WdP65mCMac39wWOurG=vaGjCpr+Z8Q5F3Tg@mail.gmail.com>
 <50bf817e-8683-9307-948e-f66a1919c1a8@gmx.com>
 <CADXXWGx=HAT1AR2EL+BDyanGNyF1WK-Efw0zOmAqYLMf4UhC9Q@mail.gmail.com>
 <CADXXWGxf2tOoeuOXVBMvKPbA_L+Z-as_JM35cnYU9HB7=9RnOA@mail.gmail.com>
 <3001610a-8377-2213-6482-acdeeefb4995@gmx.com>
 <CADXXWGxCwQP+LBh9cZQsyCKaCTer7kTCzxF7fefsdB9h93-_Pg@mail.gmail.com>
In-Reply-To: <CADXXWGxCwQP+LBh9cZQsyCKaCTer7kTCzxF7fefsdB9h93-_Pg@mail.gmail.com>

--MJdL4RXV7QKPln3tgfckzmvhhxx83cJWb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/30 =E4=B8=8A=E5=8D=8810:57, Jesse Emeth wrote:
>  Hi Qu
>=20
> How old a kernel needs to be used to "work around this by using an
> older kernel to finish the balance, and then repair.(due to relocroot
> is a special corner case I didn't take into consideration)?

For kernel, at one earlier than v4.18 should be OK.

> What version of btrfs-progs/tools should be used in this case?

For "btrfs check --repair" you still need that special branch.

>=20
> Also the problem as mentioned in this thread is that the volume cannot
> be mounted rw. Are there versions of balance that can work on
> unmounted devices?

No. Balance can't be done/canceled in btrfs-progs IIRC.

> Or is this now another catch 22 problem where balance is required to
> enable rw mount but rw mount is required to balance?

An older kernel will allow balance and ignore the error.

>=20
> Are there really not any manual dev tools where a specific directory
> and its referenced inodes can be manually specified for foremoval?

Yes, but will be even more complex than "btrfs check --repair"

Thanks,
Qu

>=20
> Thankyou
> Jesse
>=20
>>
>=20
>=20
>=20
>=20
>=20
> On Sun, Dec 30, 2018 at 8:16 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrot=
e:
>>
>>
>>
>> On 2018/12/29 =E4=B8=8B=E5=8D=8811:07, Jesse Emeth wrote:
>>> Hi Qu
>>>
>>> It does not look very successful. For completeness btrfs shows versio=
n 4.19.1
>>> btrfs in /usr/local/btrfs shows version 4.19, which is the one I used=
 below
>>>
>>> # /usr/local/bin/btrfs check /dev/sda7 2>&1 | tee
>>> /home/jesse/Data/btrfs-check-4.19alpha-sda7.txt
>>> [1/7] checking root items
>>> [2/7] checking extents
>>> [3/7] checking free space cache
>>> [4/7] checking fs roots
>>> root 263 inode 455338 errors 40000
>>> Dir items with mismatch hash:
>>> root 263 inode 463979 errors 2000, link count wrong
>>>     unresolved ref dir 455338 index 5857 namelen 40 name
>>> 648C5FC8D5C2CB828ED86E44DD9E5FB3A6430332 filetype 1 errors 1, no dir
>>> item
>>> relocroot 263 inode 455338 errors 40000
>>> Dir items with mismatch hash:
>>> relocroot 263 inode 463979 errors 2000, link count wrong
>>>     unresolved ref dir 455338 index 5857 namelen 40 name
>>> 648C5FC8D5C2CB828ED86E44DD9E5FB3A6430332 filetype 1 errors 1, no dir
>>> item
>>> ERROR: errors found in fs roots
>>> Opening filesystem to check...
>>> Checking filesystem on /dev/sda7
>>> UUID: 133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5
>>> found 32441643008 bytes used, error(s) found
>>> total csum bytes: 28041192
>>> total tree bytes: 826359808
>>> total fs tree bytes: 739311616
>>> total extent tree bytes: 48562176
>>> btree space waste bytes: 171286636
>>> file data blocks allocated: 41396502528
>>>  referenced 47784960000
>>>
>>>
>>> # /usr/local/bin/btrfs check --repair /dev/sda7 2>&1 | tee
>>> /home/jesse/Data/btrfs-check-4.19alpha-repair-sda7.txt
>>> [1/7] checking root items
>>> Fixed 0 roots.
>>> [2/7] checking extents
>>> [3/7] checking free space cache
>>> [4/7] checking fs roots
>>> root 263 inode 455338 errors 40000
>>> Dir items with mismatch hash:
>>> relocroot 263 inode 455338 errors 40000
>>
>> relocroot is a special corner case I didn't take into consideration.
>>
>> You could word around this by using an older kernel to finish the
>> balance, and then repair.
>>
>> Thanks,
>> Qu
>>
>>> Dir items with mismatch hash:
>>> btrfs unable to find ref byte nr 37142528 parent 0 root
>>> 18446744073709551608  owner 0 offset 0
>>> transaction.c:168: btrfs_commit_transaction: BUG_ON `ret` triggered, =
value -5
>>> /usr/local/bin/btrfs(btrfs_commit_transaction+0x1ab)[0x44086b]
>>> /usr/local/bin/btrfs[0x457efc]
>>> /usr/local/bin/btrfs[0x45ade4]
>>> /usr/local/bin/btrfs(cmd_check+0x1ef8)[0x462a95]
>>> /usr/local/bin/btrfs(main+0x8b)[0x40e022]
>>> /lib64/libc.so.6(__libc_start_main+0xeb)[0x7f34dab41feb]
>>> /usr/local/bin/btrfs(_start+0x2a)[0x40dd0a]
>>>
>>> Thanks
>>>
>>> On Sat, Dec 29, 2018 at 10:47 PM Jesse Emeth <jesse.emeth@gmail.com> =
wrote:
>>>>
>>>> Hi Qu
>>>> Just replying for posterity for anyone else with same problem. The
>>>> make now works I think. I will proceed with btrfs repair attempt.
>>>> I was using the git version which seems to lack autogen.sh and thus =
in
>>>> turn configure. The git clone version also contains a different
>>>> INSTALL file.
>>>>
>>>> I have since tried the zip version which contains autogen.sh
>>>>
>>>> Additional installs required for Tumbleweed turned out to be:
>>>> zypper in libuuid-devel libacl-devel libblkid-devel lzo-devel
>>>> zlib-devel zstd libzstd-devel libext2fs-devel autoconf automake
>>>> python3 python3-devel
>>>>
>>>> Then the following make worked:
>>>> ./autogen.sh
>>>> ./configure --disable-documentation --disable-convert
>>>> make
>>>>
>>>> # make install
>>>> /usr/bin/install -c -m755 -d /usr/local/bin
>>>> /usr/bin/install -c btrfs mkfs.btrfs btrfs-map-logical btrfs-image
>>>> btrfs-find-root btrfstune btrfs-select-super /usr/local/bin
>>>> /usr/bin/install -c fsck.btrfs /usr/local/bin
>>>> # btrfsck is a link to btrfs in the src tree, make it so for install=
ed
>>>> file as well
>>>> ln -s -f btrfs /usr/local/bin/btrfsck
>>>> /usr/bin/install -c -m755 -d /usr/lib/udev/rules.d
>>>> /usr/bin/install -c -m644 64-btrfs-dm.rules /usr/lib/udev/rules.d
>>>> /usr/bin/install -c -m755 -d /usr/local/lib
>>>> /usr/bin/install -c  libbtrfs.so.0.1 libbtrfsutil.so.1.0.0
>>>> libbtrfs.so.0 libbtrfs.so libbtrfsutil.so.1 libbtrfsutil.so libbtrfs=
=2Ea
>>>> libbtrfsutil.a /usr/local/lib
>>>> cp -d libbtrfs.so.0 libbtrfs.so libbtrfsutil.so.1 libbtrfsutil.so /u=
sr/local/lib
>>>> /usr/bin/install -c -m755 -d /usr/local/include/btrfs
>>>> /usr/bin/install -c -m644 send-stream.h send-utils.h send.h
>>>> kernel-lib/rbtree.h btrfs-list.h kernel-lib/crc32c.h kernel-lib/list=
=2Eh
>>>> kerncompat.h kernel-lib/radix-tree.h kernel-lib/sizes.h
>>>> kernel-lib/raid56.h extent-cache.h extent_io.h ioctl.h ctree.h
>>>> btrfsck.h version.h /usr/local/include/btrfs
>>>> /usr/bin/install -c -m644 libbtrfsutil/btrfsutil.h /usr/local/includ=
e
>>>>
>>>> Thanks Qu, I will try the repair now.
>>>>
>>>> Jesse
>>>>
>>>> On Sat, Dec 29, 2018 at 10:02 PM Qu Wenruo <quwenruo.btrfs@gmx.com> =
wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 2018/12/29 =E4=B8=8B=E5=8D=889:56, Jesse Emeth wrote:
>>>>>> Thanks again, but ./configure seems to be missing.
>>>>>> Why is that?
>>>>>
>>>>> Oh, you missed all the configuration phrase.
>>>>>
>>>>> The proper way to compile btrfs-progs is: (also noted in INSTALL)
>>>>>
>>>>> $ ./autogen.sh
>>>>> $ ./configure --disable-documentation --disable-convert
>>>>> $ make
>>>>>
>>>>> Then
>>>>>
>>>>> $ sudo ./btrfs check --repair <your_device>
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>>
>>>>>> On Sat, Dec 29, 2018 at 9:15 PM Qu Wenruo <quwenruo.btrfs@gmx.com>=
 wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On 2018/12/29 =E4=B8=8B=E5=8D=889:05, Jesse Emeth wrote:
>>>>>>>> Thanks again Qu
>>>>>>>> However, it is still problematic.
>>>>>>>> Have installed
>>>>>>>> #zypper in libuuid-devel libacl-devel libblkid-devel lzo-devel
>>>>>>>> zlib-devel zstd libzstd-devel libext2fs-devel
>>>>>>>>
>>>>>>>> There are still errors for executable builds of: kerncompat.h:30=
0:
>>>>>>>> warning: "__bitwise" redefined
>>>>>>>> up to btrfs-zero-log
>>>>>>>
>>>>>>> That's just warning and should be fixed in later btrfs-progs.
>>>>>>> No need to be too anxious about such warning.
>>>>>>>
>>>>>>>>
>>>>>>>> Then there are problems with btrfs-convert as below:
>>>>>>>> CC]     btrfs-convert.o
>>>>>>>> In file included from btrfs-convert.c:22:
>>>>>>>> kerncompat.h:300: warning: "__bitwise" redefined
>>>>>>>>  #define __bitwise
>>>>>>>>
>>>>>>>> In file included from kerncompat.h:30,
>>>>>>>>                  from btrfs-convert.c:22:
>>>>>>>> /usr/include/linux/types.h:22: note: this is the location of the=

>>>>>>>> previous definition
>>>>>>>>  #define __bitwise __bitwise__
>>>>>>>>
>>>>>>>> btrfs-convert.c: In function =E2=80=98ext2_xattr_check_entry=E2=80=
=99:
>>>>>>>> btrfs-convert.c:626:13: error: =E2=80=98struct ext2_ext_attr_ent=
ry=E2=80=99 has no
>>>>>>>> member named =E2=80=98e_value_block=E2=80=99; did you mean =E2=80=
=98e_value_offs=E2=80=99?
>>>>>>>>   if (entry->e_value_block !=3D 0 || value_size > size ||
>>>>>>>>              ^~~~~~~~~~~~~
>>>>>>>>              e_value_offs
>>>>>>>> make: *** [Makefile:131: btrfs-convert.o] Error 1
>>>>>>>
>>>>>>> That's due to some change in e2fsprogs.
>>>>>>>
>>>>>>> This can be fixed by disable convert by using "./configure
>>>>>>> --disable-convert", and recompile.
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Qu
>>>>>>>
>>>>>>>>
>>>>>>>> On Sat, Dec 29, 2018 at 8:25 PM Qu Wenruo <quwenruo.btrfs@gmx.co=
m> wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 2018/12/29 =E4=B8=8B=E5=8D=888:11, Jesse Emeth wrote:
>>>>>>>>>> Hi Qu
>>>>>>>>>>
>>>>>>>>>> Thankyou for that reference.
>>>>>>>>>> As per the logs I provided above, this was the kernel
>>>>>>>>>> localhost:/ # uname -a
>>>>>>>>>> Linux localhost.localdomain 4.18.13-1-default #1 SMP PREEMPT W=
ed Oct
>>>>>>>>>> 10 18:47:28 UTC 2018 (c434d5c) x86_64 x86_64 x86_64 GNU/Linux
>>>>>>>>>>
>>>>>>>>>> Is the kernel version relevant to
>>>>>>>>>> 1) The kernel at the time of btrfs repair being run?
>>>>>>>>>
>>>>>>>>> No.
>>>>>>>>> Repair is completely independent from kernel version, so kernel=
 doesn't
>>>>>>>>> have anything to do with it.
>>>>>>>>>
>>>>>>>>>> 2) The kernel at the time of fault originally occurring?
>>>>>>>>>
>>>>>>>>> I don't think the fault is caused by that v4.18 kernel, but a m=
uch older
>>>>>>>>> kernel.
>>>>>>>>> It's v4.18+ kernel that introduces such sanity check and expose=
d such
>>>>>>>>> old corruption.
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> I am now running OpenSuse Tumbleweed to repair this:
>>>>>>>>>> # uname -a
>>>>>>>>>> Linux linux-h5nt 4.19.8-1-default #1 SMP PREEMPT Sun Dec 9 20:=
08:37
>>>>>>>>>> UTC 2018 (9cae63f) x86_64 x86_64 x86_64 GNU/Linux
>>>>>>>>>>
>>>>>>>>>> I have run the https://github.com/adam900710/btrfs-progs/tree/=
check-next
>>>>>>>>>> with latest commit of 13th Nov 2018.
>>>>>>>>>> When I run make, it fails.
>>>>>>>>>> Could you please advise if I am missing something?
>>>>>>>>>>
>>>>>>>>>> Below are the make errors. Thankyou
>>>>>>>>>>
>>>>>>>>> [snip]
>>>>>>>>>>     [CC]     print-tree.o
>>>>>>>>>> print-tree.c:21:10: fatal error: uuid/uuid.h: No such file or =
directory
>>>>>>>>>>  #include <uuid/uuid.h>
>>>>>>>>>>           ^~~~~~~~~~~~~
>>>>>>>>>> compilation terminated.
>>>>>>>>>> make: *** [Makefile:131: print-tree.o] Error 1
>>>>>>>>>
>>>>>>>>> You just lacks a lot of development headers.
>>>>>>>>>
>>>>>>>>> You may need but not limited development headers of:
>>>>>>>>>
>>>>>>>>> libuuid, libacl, libblkid, lzo, zlib, zstd, e2fsprogs.
>>>>>>>>> (Name may var for different distros, either with lib prefix or =
without)
>>>>>>>>>
>>>>>>>>> And you may need to disable documentation by using "./configure=

>>>>>>>>> --disable-documentation"
>>>>>>>>>
>>>>>>>>> Thanks,
>>>>>>>>> Qu
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On Sun, Dec 23, 2018 at 8:51 AM Qu Wenruo <quwenruo.btrfs@gmx.=
com> wrote:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> On 2018/12/23 =E4=B8=8A=E5=8D=882:12, Jesse Emeth wrote:
>>>>>>>>>>>> BTRFS /@/ with home as subvolume results in Firefox cache en=
tries
>>>>>>>>>>>> corrupt leaf that in turn prevents rw mounting.
>>>>>>>>>>>> BTRFS Standard Repair Tools are unsuccessful to fix what see=
ms a small
>>>>>>>>>>>> localised error to a non critical directory.
>>>>>>>>>>>> I could not find any BTRFS type tool to remove just that dir=
ectory
>>>>>>>>>>>> without the volume mounted rw.
>>>>>>>>>>>> And there is the catch 22 of not being able to mount it ro w=
hile the
>>>>>>>>>>>> "corrupt leaf" error occurs.
>>>>>>>>>>>> Initially btrfs rescue zero-log gave rw access.
>>>>>>>>>>>> I could not delete the "entries" directory associated with t=
he Firefox
>>>>>>>>>>>> cache "entries" directory.
>>>>>>>>>>>> I was permitted to rename it so I renamed "entries" as "brok=
en-inode-455338"
>>>>>>>>>>>> The system shortly thereafter set itself again to ro. Since =
then rw
>>>>>>>>>>>> mount is not possible.
>>>>>>>>>>>>
>>>>>>>>>>>> The steps at https://lists.opensuse.org/opensuse/2017-02/msg=
00930.html
>>>>>>>>>>>> were attempted to repair the system.
>>>>>>>>>>>> There Richard Brown said "can we please bury the nonsense th=
at btrfs
>>>>>>>>>>>> is lacking when it comes to repair and recovery tools"
>>>>>>>>>>>> I say hell no!
>>>>>>>>>>>> As a user there seems to be a lack of granular ability to re=
move
>>>>>>>>>>>> corrupt entries.
>>>>>>>>>>>> There also seems to be no way of denying a subvolume (eg: in=
 this case
>>>>>>>>>>>> "home") from consideration when mounting the main volume.
>>>>>>>>>>>> Or to remove a subvolume from the main volume.
>>>>>>>>>>>> If there was, I could remove the "home" subvolume and recrea=
te just that.
>>>>>>>>>>>> So in this example it seems a very small and trivial error o=
f a cache
>>>>>>>>>>>> dir trashes the entire btrfs subvolume.
>>>>>>>>>>>>
>>>>>>>>>>>> What suggestions exist to prevent such problems occuring aga=
in other
>>>>>>>>>>>> than separating out all subvolumes onto separate partitions =
or LVM's?
>>>>>>>>>>>> And are there any tools available to manually repair a probl=
em like I
>>>>>>>>>>>> am experiencing with "entries" dir.
>>>>>>>>>>>>
>>>>>>>>>>>> Thankyou
>>>>>>>>>>>>
>>>>>>>>>>>> Relevant logs and settings are below as sent to bugzilla
>>>>>>>>>>>> (https://bugzilla.kernel.org/show_bug.cgi?id=3D202041)
>>>>>>>>>>>>
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> # Note: block 537133056 inode 455338 is the entries dir of t=
he cache
>>>>>>>>>>>> directories for firefox
>>>>>>>>>>>> /home/USER/.cache/mozilla/firefox/PROFILENAME/cache2/entries=

>>>>>>>>>>>> # I was unable to delete the broken dir, but managed to rena=
me
>>>>>>>>>>>> ./entries to ./broken-inode-455338 and to create a new empty=
 ./entries
>>>>>>>>>>>> dir
>>>>>>>>>>>> # Then was able to initiate scrub etc
>>>>>>>>>>>> # But it later failed again that day. There was no way I cou=
ld
>>>>>>>>>>>> ascertain to remove the broken inode.
>>>>>>>>>>>> # Mounted ro, the ./broken-inode-455338 dir can be opened bu=
t appears empty
>>>>>>>>>>>> # It becomes problematic seemingly only when volume is mount=
ed rw
>>>>>>>>>>>>
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> localhost:/ # mount -t btrfs -o ro
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /mnt/sda7
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> localhost:/ # uname -a
>>>>>>>>>>>> Linux localhost.localdomain 4.18.13-1-default #1 SMP PREEMPT=
 Wed Oct
>>>>>>>>>>>> 10 18:47:28 UTC 2018 (c434d5c) x86_64 x86_64 x86_64 GNU/Linu=
x
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> localhost:/ #   btrfs --version
>>>>>>>>>>>> btrfs-progs v4.17.1
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> localhost:/ #   btrfs fi show
>>>>>>>>>>>> Label: 'pt_osa1'  uuid: 133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5=

>>>>>>>>>>>>     Total devices 2 FS bytes used 30.23GiB
>>>>>>>>>>>>     devid    1 size 97.66GiB used 39.03GiB path /dev/sda7
>>>>>>>>>>>>     devid    2 size 97.66GiB used 39.03GiB path /dev/sdb7
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> localhost:/ # btrfs fi df /mnt/sda7
>>>>>>>>>>>> Data, RAID1: total=3D37.00GiB, used=3D29.46GiB
>>>>>>>>>>>> System, RAID1: total=3D32.00MiB, used=3D16.00KiB
>>>>>>>>>>>> Metadata, RAID1: total=3D2.00GiB, used=3D787.94MiB
>>>>>>>>>>>> GlobalReserve, single: total=3D82.91MiB, used=3D0.00B
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> localhost:/ # mount -t btrfs -o ro
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /mnt/sda7
>>>>>>>>>>>> [Thu Dec 20 02:29:52 2018] BTRFS info (device sda7): disk sp=
ace
>>>>>>>>>>>> caching is enabled
>>>>>>>>>>>> [Thu Dec 20 02:29:52 2018] BTRFS info (device sda7): has ski=
nny extents
>>>>>>>>>>>> [Thu Dec 20 02:35:12 2018] BTRFS info (device sda7): disk sp=
ace
>>>>>>>>>>>> caching is enabled
>>>>>>>>>>>> [Thu Dec 20 02:35:12 2018] BTRFS info (device sda7): has ski=
nny extents
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> # Note: Mounting ro as above works without any error. Attemp=
ts to
>>>>>>>>>>>> mount rw fails...
>>>>>>>>>>>> localhost:/ # mount -t btrfs -o rw
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /mnt/sda7
>>>>>>>>>>>> mount: /mnt/sda7: wrong fs type, bad option, bad superblock =
on
>>>>>>>>>>>> /dev/sda7, missing codepage or helper program, or other erro=
r.
>>>>>>>>>>>> [Thu Dec 20 02:36:06 2018] BTRFS info (device sda7): disk sp=
ace
>>>>>>>>>>>> caching is enabled
>>>>>>>>>>>> [Thu Dec 20 02:36:06 2018] BTRFS info (device sda7): has ski=
nny extents
>>>>>>>>>>>> [Thu Dec 20 02:36:25 2018] BTRFS critical (device sda7): cor=
rupt leaf:
>>>>>>>>>>>> root=3D263 block=3D537133056 slot=3D98 ino=3D455338, name ha=
sh mismatch with
>>>>>>>>>>>> key, have 0x000000007dd7ffcb expect 0x00000000dfc274ff
>>>>>>>>>>>
>>>>>>>>>>> Known bug for older kernel.
>>>>>>>>>>>
>>>>>>>>>>> If btrfs check reports no other error, you could use this bra=
nch to fix it:
>>>>>>>>>>>
>>>>>>>>>>> https://github.com/adam900710/btrfs-progs/tree/check-next
>>>>>>>>>>>
>>>>>>>>>>> Thanks,
>>>>>>>>>>> Qu
>>>>>>>>>>>
>>>>>>>>>>>> [Thu Dec 20 02:36:25 2018] BTRFS: error (device sda7) in
>>>>>>>>>>>> merge_reloc_roots:2466: errno=3D-5 IO failure
>>>>>>>>>>>> [Thu Dec 20 02:36:25 2018] BTRFS warning (device sda7): fail=
ed to
>>>>>>>>>>>> recover relocation: -30
>>>>>>>>>>>> [Thu Dec 20 02:36:25 2018] BTRFS error (device sda7): cleane=
r
>>>>>>>>>>>> transaction attach returned -30
>>>>>>>>>>>> [Thu Dec 20 02:36:25 2018] BTRFS error (device sda7): open_c=
tree failed
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> # Immediately after failing rw mount, attempts to mount ro r=
esults in
>>>>>>>>>>>> no errors recorded...
>>>>>>>>>>>> mount -t btrfs -o subvol=3D@/home,ro
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /mnt/sda7/home
>>>>>>>>>>>> [Thu Dec 20 02:46:36 2018] BTRFS info (device sda7): disk sp=
ace
>>>>>>>>>>>> caching is enabled
>>>>>>>>>>>> [Thu Dec 20 02:46:36 2018] BTRFS info (device sda7): has ski=
nny extents
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> # Note: block 537133056 inode 455338 is the entries dir of t=
he cache
>>>>>>>>>>>> directories for firefox
>>>>>>>>>>>> /home/USER/.cache/mozilla/firefox/PROFILENAME/cache2/entries=

>>>>>>>>>>>> btrfs inspect-internal dump-tree -b 537133056 /dev/sda7
>>>>>>>>>>>> btrfs-progs v4.17.1
>>>>>>>>>>>> leaf 537133056 items 107 free space 6118 generation 40120 ow=
ner 263
>>>>>>>>>>>> leaf 537133056 flags 0x1(WRITTEN) backref revision 1
>>>>>>>>>>>> fs uuid 133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5
>>>>>>>>>>>> chunk uuid 4cab7492-6459-4bda-8703-dcc6a81e622b
>>>>>>>>>>>>     item 0 key (455338 DIR_ITEM 3540219901) itemoff 16213 it=
emsize 70
>>>>>>>>>>>>         location key (703987 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 38014 data_len 0 name_len 40
>>>>>>>>>>>>         name: 26F2BD5CBF294474EFDC521833782B585603C132
>>>>>>>>>>>>     item 1 key (455338 DIR_ITEM 3543270328) itemoff 16143 it=
emsize 70
>>>>>>>>>>>>         location key (672675 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 36034 data_len 0 name_len 40
>>>>>>>>>>>>         name: 916D2EF147007C80F33481F0A09AD58A888F8298
>>>>>>>>>>>>     item 2 key (455338 DIR_ITEM 3544258744) itemoff 16073 it=
emsize 70
>>>>>>>>>>>>         location key (740437 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39752 data_len 0 name_len 40
>>>>>>>>>>>>         name: 96F356C0B80602F7AB7F4E3FF275EE4DBD336271
>>>>>>>>>>>>     item 3 key (455338 DIR_ITEM 3544529700) itemoff 16003 it=
emsize 70
>>>>>>>>>>>>         location key (709017 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 38469 data_len 0 name_len 40
>>>>>>>>>>>>         name: FF4C65653A11DA7C8347A167FD102215A413B215
>>>>>>>>>>>>     item 4 key (455338 DIR_ITEM 3545202969) itemoff 15933 it=
emsize 70
>>>>>>>>>>>>         location key (743829 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39908 data_len 0 name_len 40
>>>>>>>>>>>>         name: 5A3773135BB7C4EC175D49BE6AD5E1224DBA75B9
>>>>>>>>>>>>     item 5 key (455338 DIR_ITEM 3545219250) itemoff 15863 it=
emsize 70
>>>>>>>>>>>>         location key (708981 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 38469 data_len 0 name_len 40
>>>>>>>>>>>>         name: ABD2DE84D78B2C2A3EE916D07A92C12C12B3C3E1
>>>>>>>>>>>>     item 6 key (455338 DIR_ITEM 3549445695) itemoff 15793 it=
emsize 70
>>>>>>>>>>>>         location key (628487 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 32986 data_len 0 name_len 40
>>>>>>>>>>>>         name: E9C8F43EA235B6242185C11C228006598AB082E0
>>>>>>>>>>>>     item 7 key (455338 DIR_ITEM 3550270602) itemoff 15723 it=
emsize 70
>>>>>>>>>>>>         location key (672521 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 36013 data_len 0 name_len 40
>>>>>>>>>>>>         name: F1AE1CAA304E26FB7B958B378D82E9AE6908138E
>>>>>>>>>>>>     item 8 key (455338 DIR_ITEM 3551081767) itemoff 15653 it=
emsize 70
>>>>>>>>>>>>         location key (606103 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 31799 data_len 0 name_len 40
>>>>>>>>>>>>         name: 0A32BF6A7C953D49771C50CB0AF0089E9199BADB
>>>>>>>>>>>>     item 9 key (455338 DIR_ITEM 3551473600) itemoff 15583 it=
emsize 70
>>>>>>>>>>>>         location key (743666 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39904 data_len 0 name_len 40
>>>>>>>>>>>>         name: 1B19A547B7A941B1FFDC6B925C87BE84FE450BC1
>>>>>>>>>>>>     item 10 key (455338 DIR_ITEM 3552535997) itemoff 15513 i=
temsize 70
>>>>>>>>>>>>         location key (747975 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40093 data_len 0 name_len 40
>>>>>>>>>>>>         name: 20B58F19DDE2FF597F1AA61A17BB81A8E1863954
>>>>>>>>>>>>     item 11 key (455338 DIR_ITEM 3552617813) itemoff 15443 i=
temsize 70
>>>>>>>>>>>>         location key (748024 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40099 data_len 0 name_len 40
>>>>>>>>>>>>         name: DB5935F2CD0F86A42C78564B1573A66250F41F60
>>>>>>>>>>>>     item 12 key (455338 DIR_ITEM 3553072248) itemoff 15373 i=
temsize 70
>>>>>>>>>>>>         location key (705792 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 38124 data_len 0 name_len 40
>>>>>>>>>>>>         name: BA9C9EB537E08CB934F619FCE024B0A1B04B6789
>>>>>>>>>>>>     item 13 key (455338 DIR_ITEM 3556227308) itemoff 15303 i=
temsize 70
>>>>>>>>>>>>         location key (672519 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 36013 data_len 0 name_len 40
>>>>>>>>>>>>         name: 528A13E779F25327387CAB8899CB6959084211D7
>>>>>>>>>>>>     item 14 key (455338 DIR_ITEM 3559866104) itemoff 15233 i=
temsize 70
>>>>>>>>>>>>         location key (674207 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 36203 data_len 0 name_len 40
>>>>>>>>>>>>         name: 0DC777254D09ABA2A2B006B60ABF992E61ABE739
>>>>>>>>>>>>     item 15 key (455338 DIR_ITEM 3561750798) itemoff 15163 i=
temsize 70
>>>>>>>>>>>>         location key (533670 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 28154 data_len 0 name_len 40
>>>>>>>>>>>>         name: 0D0C40C9672F8AD8E90A8203AE4CDB95C36CBFC5
>>>>>>>>>>>>     item 16 key (455338 DIR_ITEM 3563343870) itemoff 15093 i=
temsize 70
>>>>>>>>>>>>         location key (715390 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 38958 data_len 0 name_len 40
>>>>>>>>>>>>         name: BB9EE7A607C8376330A362493B1B03FAE8CE6CD6
>>>>>>>>>>>>     item 17 key (455338 DIR_ITEM 3565357061) itemoff 15023 i=
temsize 70
>>>>>>>>>>>>         location key (747886 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40082 data_len 0 name_len 40
>>>>>>>>>>>>         name: C537315B35C7FAB43883B35DED2520C41535D022
>>>>>>>>>>>>     item 18 key (455338 DIR_ITEM 3566632272) itemoff 14953 i=
temsize 70
>>>>>>>>>>>>         location key (748213 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40119 data_len 0 name_len 40
>>>>>>>>>>>>         name: 3DB7349A911B49C887794FDA1C4A25956428FF05
>>>>>>>>>>>>     item 19 key (455338 DIR_ITEM 3569767930) itemoff 14883 i=
temsize 70
>>>>>>>>>>>>         location key (748145 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40115 data_len 0 name_len 40
>>>>>>>>>>>>         name: F4B7DAD8C7C19D2CCBFE0B275F3F8270A467A3E3
>>>>>>>>>>>>     item 20 key (455338 DIR_ITEM 3574885100) itemoff 14813 i=
temsize 70
>>>>>>>>>>>>         location key (533671 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 28154 data_len 0 name_len 40
>>>>>>>>>>>>         name: D3D42E2A85CCC7A8BE8438AE0108991EF5CD10AC
>>>>>>>>>>>>     item 21 key (455338 DIR_ITEM 3576528956) itemoff 14743 i=
temsize 70
>>>>>>>>>>>>         location key (737057 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39652 data_len 0 name_len 40
>>>>>>>>>>>>         name: C1CBEE3CC5CE7A5B67A7AAAAB10266176520B506
>>>>>>>>>>>>     item 22 key (455338 DIR_ITEM 3580167920) itemoff 14673 i=
temsize 70
>>>>>>>>>>>>         location key (721805 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39118 data_len 0 name_len 40
>>>>>>>>>>>>         name: 518239E4365BD4E676342DD9F0B7E1196D9D841A
>>>>>>>>>>>>     item 23 key (455338 DIR_ITEM 3581640365) itemoff 14603 i=
temsize 70
>>>>>>>>>>>>         location key (748167 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40115 data_len 0 name_len 40
>>>>>>>>>>>>         name: ED27985E756E933FDE644F2B61B6CC3DA41070F1
>>>>>>>>>>>>     item 24 key (455338 DIR_ITEM 3581786665) itemoff 14533 i=
temsize 70
>>>>>>>>>>>>         location key (723909 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39161 data_len 0 name_len 40
>>>>>>>>>>>>         name: 9705B0DDA3A2692C61AA8EB9EA4355830406CFA2
>>>>>>>>>>>>     item 25 key (455338 DIR_ITEM 3585461396) itemoff 14463 i=
temsize 70
>>>>>>>>>>>>         location key (721872 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39119 data_len 0 name_len 40
>>>>>>>>>>>>         name: F550399651D3ECB2D8423E679003B9EDB934F0F9
>>>>>>>>>>>>     item 26 key (455338 DIR_ITEM 3585785349) itemoff 14393 i=
temsize 70
>>>>>>>>>>>>         location key (718026 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 38973 data_len 0 name_len 40
>>>>>>>>>>>>         name: C2DA49917D6EA33F2222B8047496FE2E43380B7F
>>>>>>>>>>>>     item 27 key (455338 DIR_ITEM 3588342327) itemoff 14323 i=
temsize 70
>>>>>>>>>>>>         location key (488206 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 26430 data_len 0 name_len 40
>>>>>>>>>>>>         name: 88AA2F9BCD50A077C3BB0939CA5BBC0A74E534FF
>>>>>>>>>>>>     item 28 key (455338 DIR_ITEM 3590588501) itemoff 14253 i=
temsize 70
>>>>>>>>>>>>         location key (740286 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39751 data_len 0 name_len 40
>>>>>>>>>>>>         name: 7E7866EEAB4187500F9B095A58E7253597829F54
>>>>>>>>>>>>     item 29 key (455338 DIR_ITEM 3590966466) itemoff 14183 i=
temsize 70
>>>>>>>>>>>>         location key (742925 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39890 data_len 0 name_len 40
>>>>>>>>>>>>         name: A94E037DD13AB3650AC5944EC415D7F6CE5BF10D
>>>>>>>>>>>>     item 30 key (455338 DIR_ITEM 3597960049) itemoff 14113 i=
temsize 70
>>>>>>>>>>>>         location key (510354 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 27443 data_len 0 name_len 40
>>>>>>>>>>>>         name: 4F57891BCA7658840766E630C89391EE7A68A5F4
>>>>>>>>>>>>     item 31 key (455338 DIR_ITEM 3604605848) itemoff 14043 i=
temsize 70
>>>>>>>>>>>>         location key (718309 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 38979 data_len 0 name_len 40
>>>>>>>>>>>>         name: 7CFCF8F6BD34050A1968520DB6F949FCEBD12E64
>>>>>>>>>>>>     item 32 key (455338 DIR_ITEM 3609530285) itemoff 13973 i=
temsize 70
>>>>>>>>>>>>         location key (748230 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40119 data_len 0 name_len 40
>>>>>>>>>>>>         name: 452EB0DC55745F028BCF234F4DCDF145EA7EFD6B
>>>>>>>>>>>>     item 33 key (455338 DIR_ITEM 3611260488) itemoff 13903 i=
temsize 70
>>>>>>>>>>>>         location key (748105 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40115 data_len 0 name_len 40
>>>>>>>>>>>>         name: 0438BEED00306F645E77E4148DBA443B51897DDE
>>>>>>>>>>>>     item 34 key (455338 DIR_ITEM 3612117440) itemoff 13833 i=
temsize 70
>>>>>>>>>>>>         location key (746140 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39955 data_len 0 name_len 40
>>>>>>>>>>>>         name: F6699F90B9CE154E405DFC1E267D375A8933E98C
>>>>>>>>>>>>     item 35 key (455338 DIR_ITEM 3614206064) itemoff 13763 i=
temsize 70
>>>>>>>>>>>>         location key (685102 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 36975 data_len 0 name_len 40
>>>>>>>>>>>>         name: A0F75674AD3236A255CC935AE8B46B3F53ACC5A8
>>>>>>>>>>>>     item 36 key (455338 DIR_ITEM 3615805654) itemoff 13693 i=
temsize 70
>>>>>>>>>>>>         location key (723905 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39161 data_len 0 name_len 40
>>>>>>>>>>>>         name: 2992C077438E24213F3112AEF08D0F5D9413FAA3
>>>>>>>>>>>>     item 37 key (455338 DIR_ITEM 3618281876) itemoff 13623 i=
temsize 70
>>>>>>>>>>>>         location key (533683 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 28154 data_len 0 name_len 40
>>>>>>>>>>>>         name: DDE4B366316A69C82ECDF34D024A9E8836ED8C2E
>>>>>>>>>>>>     item 38 key (455338 DIR_ITEM 3619435883) itemoff 13553 i=
temsize 70
>>>>>>>>>>>>         location key (722488 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39124 data_len 0 name_len 40
>>>>>>>>>>>>         name: EE587AF1D944164C0D79F972F0BCCC869A30D594
>>>>>>>>>>>>     item 39 key (455338 DIR_ITEM 3620627949) itemoff 13483 i=
temsize 70
>>>>>>>>>>>>         location key (747961 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40087 data_len 0 name_len 40
>>>>>>>>>>>>         name: 9E37BA6E31688B40EA48F7B9CCEF300484DF1A83
>>>>>>>>>>>>     item 40 key (455338 DIR_ITEM 3625881422) itemoff 13413 i=
temsize 70
>>>>>>>>>>>>         location key (486419 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 26394 data_len 0 name_len 40
>>>>>>>>>>>>         name: EACDAFDF8FEAE395873968F32530823A424E3ABF
>>>>>>>>>>>>     item 41 key (455338 DIR_ITEM 3627328070) itemoff 13343 i=
temsize 70
>>>>>>>>>>>>         location key (672668 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 36034 data_len 0 name_len 40
>>>>>>>>>>>>         name: 224889CDDE3EC628E576C34EC316AAB3B6F07A96
>>>>>>>>>>>>     item 42 key (455338 DIR_ITEM 3628696658) itemoff 13273 i=
temsize 70
>>>>>>>>>>>>         location key (743661 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39904 data_len 0 name_len 40
>>>>>>>>>>>>         name: 28CF3A95E7619F3B9609EDCE3DBC4687C46BFDD8
>>>>>>>>>>>>     item 43 key (455338 DIR_ITEM 3629164829) itemoff 13203 i=
temsize 70
>>>>>>>>>>>>         location key (720978 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39075 data_len 0 name_len 40
>>>>>>>>>>>>         name: 7ACA397D3C1C4B8741369DF9CD14D7CB43CA97B4
>>>>>>>>>>>>     item 44 key (455338 DIR_ITEM 3629987493) itemoff 13133 i=
temsize 70
>>>>>>>>>>>>         location key (718043 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 38973 data_len 0 name_len 40
>>>>>>>>>>>>         name: 4D98DFF0D37045959AA5EDCC2DD6B62F4AB780C0
>>>>>>>>>>>>     item 45 key (455338 DIR_ITEM 3631714652) itemoff 13063 i=
temsize 70
>>>>>>>>>>>>         location key (743660 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39904 data_len 0 name_len 40
>>>>>>>>>>>>         name: 173EEF0EE25CDEF2C0342F4A17EDD9DF877403DF
>>>>>>>>>>>>     item 46 key (455338 DIR_ITEM 3632140034) itemoff 12993 i=
temsize 70
>>>>>>>>>>>>         location key (675700 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 36417 data_len 0 name_len 40
>>>>>>>>>>>>         name: 4546137398A7132293045280BAC85B1CDF0DDD08
>>>>>>>>>>>>     item 47 key (455338 DIR_ITEM 3633101708) itemoff 12923 i=
temsize 70
>>>>>>>>>>>>         location key (745997 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39952 data_len 0 name_len 40
>>>>>>>>>>>>         name: 9ED004F33F28E1A156BEBE964A54C2326CF87D1D
>>>>>>>>>>>>     item 48 key (455338 DIR_ITEM 3634237337) itemoff 12853 i=
temsize 70
>>>>>>>>>>>>         location key (728022 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39395 data_len 0 name_len 40
>>>>>>>>>>>>         name: D859107532CF31FCC07079192ADB70BEAD4ACE7D
>>>>>>>>>>>>     item 49 key (455338 DIR_ITEM 3634926962) itemoff 12783 i=
temsize 70
>>>>>>>>>>>>         location key (559120 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 29350 data_len 0 name_len 40
>>>>>>>>>>>>         name: 63DD56997CCE610ADDFC64A39385D3D990C27B8E
>>>>>>>>>>>>     item 50 key (455338 DIR_ITEM 3635467687) itemoff 12713 i=
temsize 70
>>>>>>>>>>>>         location key (748171 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40115 data_len 0 name_len 40
>>>>>>>>>>>>         name: 1186652803403AFF8BD77E06EE7A70786A8C3027
>>>>>>>>>>>>     item 51 key (455338 DIR_ITEM 3637659684) itemoff 12643 i=
temsize 70
>>>>>>>>>>>>         location key (707060 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 38304 data_len 0 name_len 40
>>>>>>>>>>>>         name: D677F8D490F289C02F627AF11F3FBEB31092BDC2
>>>>>>>>>>>>     item 52 key (455338 DIR_ITEM 3637784372) itemoff 12573 i=
temsize 70
>>>>>>>>>>>>         location key (748036 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40101 data_len 0 name_len 40
>>>>>>>>>>>>         name: 648E1C5F16781C8F09EC712A919D07A7C8B1B7A6
>>>>>>>>>>>>     item 53 key (455338 DIR_ITEM 3640348841) itemoff 12503 i=
temsize 70
>>>>>>>>>>>>         location key (747957 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40086 data_len 0 name_len 40
>>>>>>>>>>>>         name: BC072B06E15B00C70AE9CDE465E8D83FFFA504C7
>>>>>>>>>>>>     item 54 key (455338 DIR_ITEM 3641770295) itemoff 12433 i=
temsize 70
>>>>>>>>>>>>         location key (739130 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39703 data_len 0 name_len 40
>>>>>>>>>>>>         name: 50C0CA1EC7A1830120CE6D06207068A0DB70CAF6
>>>>>>>>>>>>     item 55 key (455338 DIR_ITEM 3644894944) itemoff 12363 i=
temsize 70
>>>>>>>>>>>>         location key (698969 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 37862 data_len 0 name_len 40
>>>>>>>>>>>>         name: 2F9F459DD398D935E86D8F5B292D43F81AEAFBD6
>>>>>>>>>>>>     item 56 key (455338 DIR_ITEM 3645220470) itemoff 12293 i=
temsize 70
>>>>>>>>>>>>         location key (623302 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 32668 data_len 0 name_len 40
>>>>>>>>>>>>         name: C0E12AAF3195D5E087A7CE7A0B31F28BA3058D71
>>>>>>>>>>>>     item 57 key (455338 DIR_ITEM 3645623761) itemoff 12223 i=
temsize 70
>>>>>>>>>>>>         location key (533705 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 28154 data_len 0 name_len 40
>>>>>>>>>>>>         name: C9BFC591A6D12F3C56F3B7902FC3B1CF06348925
>>>>>>>>>>>>     item 58 key (455338 DIR_ITEM 3649162755) itemoff 12153 i=
temsize 70
>>>>>>>>>>>>         location key (462609 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 25423 data_len 0 name_len 40
>>>>>>>>>>>>         name: 56FEA1E9F2BF21EAB6083E016C2C23E20208CDF5
>>>>>>>>>>>>     item 59 key (455338 DIR_ITEM 3652086063) itemoff 12083 i=
temsize 70
>>>>>>>>>>>>         location key (684279 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 36880 data_len 0 name_len 40
>>>>>>>>>>>>         name: A9ADAB90995786D3E9F63F2D35BDFE3C1DC6B71F
>>>>>>>>>>>>     item 60 key (455338 DIR_ITEM 3652963450) itemoff 12013 i=
temsize 70
>>>>>>>>>>>>         location key (659537 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 35340 data_len 0 name_len 40
>>>>>>>>>>>>         name: 235634D26D2310CD96EEBFCB542E1F4C2D811C5E
>>>>>>>>>>>>     item 61 key (455338 DIR_ITEM 3655857212) itemoff 11943 i=
temsize 70
>>>>>>>>>>>>         location key (748182 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40115 data_len 0 name_len 40
>>>>>>>>>>>>         name: B57F0BF40786D5D1958A0677503D8DE94924B9EF
>>>>>>>>>>>>     item 62 key (455338 DIR_ITEM 3658920190) itemoff 11873 i=
temsize 70
>>>>>>>>>>>>         location key (506044 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 27340 data_len 0 name_len 40
>>>>>>>>>>>>         name: 5DA9677EA409AD078E8D4AFB8BFC29E860CF20FC
>>>>>>>>>>>>     item 63 key (455338 DIR_ITEM 3660985214) itemoff 11803 i=
temsize 70
>>>>>>>>>>>>         location key (610677 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 32073 data_len 0 name_len 40
>>>>>>>>>>>>         name: 555EAD998AFD7BBF7910E79DC9661FA0CDD6D13B
>>>>>>>>>>>>     item 64 key (455338 DIR_ITEM 3672308714) itemoff 11733 i=
temsize 70
>>>>>>>>>>>>         location key (594973 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 31412 data_len 0 name_len 40
>>>>>>>>>>>>         name: C06F8EB522A0BFE544E8F7B5A9078990D29C61B1
>>>>>>>>>>>>     item 65 key (455338 DIR_ITEM 3676127134) itemoff 11663 i=
temsize 70
>>>>>>>>>>>>         location key (673249 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 36105 data_len 0 name_len 40
>>>>>>>>>>>>         name: 0EE61AD03B75E992962B9CBD717D961D61E5E049
>>>>>>>>>>>>     item 66 key (455338 DIR_ITEM 3677090874) itemoff 11593 i=
temsize 70
>>>>>>>>>>>>         location key (688758 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 37414 data_len 0 name_len 40
>>>>>>>>>>>>         name: 36DCB89CFAAE18F513590C822A6A92E02D41B95B
>>>>>>>>>>>>     item 67 key (455338 DIR_ITEM 3677906830) itemoff 11523 i=
temsize 70
>>>>>>>>>>>>         location key (746143 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39955 data_len 0 name_len 40
>>>>>>>>>>>>         name: FA85FCD3191A6EB62E586311BE4B124B7F5196F3
>>>>>>>>>>>>     item 68 key (455338 DIR_ITEM 3678002633) itemoff 11453 i=
temsize 70
>>>>>>>>>>>>         location key (672660 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 36034 data_len 0 name_len 40
>>>>>>>>>>>>         name: 609D6ECE91EB638695DB7F1FAA116770D6C863E5
>>>>>>>>>>>>     item 69 key (455338 DIR_ITEM 3678870153) itemoff 11383 i=
temsize 70
>>>>>>>>>>>>         location key (747880 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40081 data_len 0 name_len 40
>>>>>>>>>>>>         name: C97C1F26950AD34A95CCFF9F7270F3D63D0F23D4
>>>>>>>>>>>>     item 70 key (455338 DIR_ITEM 3681403536) itemoff 11313 i=
temsize 70
>>>>>>>>>>>>         location key (728604 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39422 data_len 0 name_len 40
>>>>>>>>>>>>         name: 757BF61AFEB83742183033A093C37DD30872A312
>>>>>>>>>>>>     item 71 key (455338 DIR_ITEM 3686024358) itemoff 11243 i=
temsize 70
>>>>>>>>>>>>         location key (685064 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 36975 data_len 0 name_len 40
>>>>>>>>>>>>         name: 1609D27BED5901460B635A8216B01CF2CDAF2026
>>>>>>>>>>>>     item 72 key (455338 DIR_ITEM 3686235831) itemoff 11173 i=
temsize 70
>>>>>>>>>>>>         location key (722181 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39120 data_len 0 name_len 40
>>>>>>>>>>>>         name: 80DCED3DD26B94C02333319BDB926BEAE098CE92
>>>>>>>>>>>>     item 73 key (455338 DIR_ITEM 3686322830) itemoff 11103 i=
temsize 70
>>>>>>>>>>>>         location key (719166 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39005 data_len 0 name_len 40
>>>>>>>>>>>>         name: B0518CA181298747E191183A9D5D151F18BE977C
>>>>>>>>>>>>     item 74 key (455338 DIR_ITEM 3687033727) itemoff 11033 i=
temsize 70
>>>>>>>>>>>>         location key (720132 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39028 data_len 0 name_len 40
>>>>>>>>>>>>         name: B003849A4BBBBA0E10A4D41EC27BFBD9A113BF13
>>>>>>>>>>>>     item 75 key (455338 DIR_ITEM 3687167174) itemoff 10963 i=
temsize 70
>>>>>>>>>>>>         location key (695892 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 37735 data_len 0 name_len 40
>>>>>>>>>>>>         name: 1B74B4425F854DAD1AA02E6D3202B4697E770716
>>>>>>>>>>>>     item 76 key (455338 DIR_ITEM 3693689369) itemoff 10893 i=
temsize 70
>>>>>>>>>>>>         location key (737971 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39662 data_len 0 name_len 40
>>>>>>>>>>>>         name: F722EBDED3D4E1D8D028753455AC5CA8013FF059
>>>>>>>>>>>>     item 77 key (455338 DIR_ITEM 3695370307) itemoff 10823 i=
temsize 70
>>>>>>>>>>>>         location key (727391 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39365 data_len 0 name_len 40
>>>>>>>>>>>>         name: C5F6A9DBF0F81A13E1453C367DD193A369B9E20F
>>>>>>>>>>>>     item 78 key (455338 DIR_ITEM 3695472464) itemoff 10753 i=
temsize 70
>>>>>>>>>>>>         location key (745532 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39940 data_len 0 name_len 40
>>>>>>>>>>>>         name: A59BB01F7C4DA74929E2F8207D99D2E7F70CBE16
>>>>>>>>>>>>     item 79 key (455338 DIR_ITEM 3697884434) itemoff 10683 i=
temsize 70
>>>>>>>>>>>>         location key (737773 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39656 data_len 0 name_len 40
>>>>>>>>>>>>         name: C6B70A61FA7B5FC6403FD2A1803C5C6FE28EC156
>>>>>>>>>>>>     item 80 key (455338 DIR_ITEM 3700659568) itemoff 10613 i=
temsize 70
>>>>>>>>>>>>         location key (721890 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39119 data_len 0 name_len 40
>>>>>>>>>>>>         name: 60DD9D127CF4D59E27972FAFF57B63E326A010ED
>>>>>>>>>>>>     item 81 key (455338 DIR_ITEM 3701461322) itemoff 10543 i=
temsize 70
>>>>>>>>>>>>         location key (743657 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39904 data_len 0 name_len 40
>>>>>>>>>>>>         name: 1EDE36E65181CD92DEC34281EEF08FCEC0541745
>>>>>>>>>>>>     item 82 key (455338 DIR_ITEM 3702531124) itemoff 10473 i=
temsize 70
>>>>>>>>>>>>         location key (714153 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 38907 data_len 0 name_len 40
>>>>>>>>>>>>         name: 7EF6235586E1FEE458EF2C3560F690ACF00D64A3
>>>>>>>>>>>>     item 83 key (455338 DIR_ITEM 3709878314) itemoff 10403 i=
temsize 70
>>>>>>>>>>>>         location key (748270 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40120 data_len 0 name_len 40
>>>>>>>>>>>>         name: 5CCACDD44241E3EBEEA33570219B0F19F91D10CC
>>>>>>>>>>>>     item 84 key (455338 DIR_ITEM 3711939545) itemoff 10333 i=
temsize 70
>>>>>>>>>>>>         location key (718030 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 38973 data_len 0 name_len 40
>>>>>>>>>>>>         name: 55BFCF28726B22E68AAF2C393B4CF5D2DF8397E2
>>>>>>>>>>>>     item 85 key (455338 DIR_ITEM 3714383304) itemoff 10263 i=
temsize 70
>>>>>>>>>>>>         location key (708140 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 38357 data_len 0 name_len 40
>>>>>>>>>>>>         name: 50CD01B20F1AFEDC318FEB46A467557A2878B9CC
>>>>>>>>>>>>     item 86 key (455338 DIR_ITEM 3717994042) itemoff 10193 i=
temsize 70
>>>>>>>>>>>>         location key (722031 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39119 data_len 0 name_len 40
>>>>>>>>>>>>         name: C6C8588E91B54622066E8462DA69681505C0EF32
>>>>>>>>>>>>     item 87 key (455338 DIR_ITEM 3720066625) itemoff 10123 i=
temsize 70
>>>>>>>>>>>>         location key (721870 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39119 data_len 0 name_len 40
>>>>>>>>>>>>         name: 7ED965594B3BF9BA68AAB6EAE62490E28B9A7277
>>>>>>>>>>>>     item 88 key (455338 DIR_ITEM 3720757208) itemoff 10053 i=
temsize 70
>>>>>>>>>>>>         location key (740718 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39757 data_len 0 name_len 40
>>>>>>>>>>>>         name: 067B3AA0A501EC22CC7E87D4AEFDD5F6C140C938
>>>>>>>>>>>>     item 89 key (455338 DIR_ITEM 3721224365) itemoff 9983 it=
emsize 70
>>>>>>>>>>>>         location key (736920 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39651 data_len 0 name_len 40
>>>>>>>>>>>>         name: EC355701D5BAF931F6D0D3F1F4B64891227BFBDE
>>>>>>>>>>>>     item 90 key (455338 DIR_ITEM 3728042486) itemoff 9913 it=
emsize 70
>>>>>>>>>>>>         location key (691232 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 37527 data_len 0 name_len 40
>>>>>>>>>>>>         name: 2430E27DEC60EEDD6B26F9BBD890B03097AE141D
>>>>>>>>>>>>     item 91 key (455338 DIR_ITEM 3728903590) itemoff 9843 it=
emsize 70
>>>>>>>>>>>>         location key (747885 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 40082 data_len 0 name_len 40
>>>>>>>>>>>>         name: 898EA51F7C37A05B570675AD499423BF2D1BC6D0
>>>>>>>>>>>>     item 92 key (455338 DIR_ITEM 3734264028) itemoff 9773 it=
emsize 70
>>>>>>>>>>>>         location key (722185 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39120 data_len 0 name_len 40
>>>>>>>>>>>>         name: 24469A256D4FE3814D33B6975D49E3A28EF16EC9
>>>>>>>>>>>>     item 93 key (455338 DIR_ITEM 3738964685) itemoff 9703 it=
emsize 70
>>>>>>>>>>>>         location key (685067 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 36975 data_len 0 name_len 40
>>>>>>>>>>>>         name: 044D06846635A0CF7C9E32ABD4AFE5EEDAFDB5CD
>>>>>>>>>>>>     item 94 key (455338 DIR_ITEM 3748117366) itemoff 9633 it=
emsize 70
>>>>>>>>>>>>         location key (692538 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 37622 data_len 0 name_len 40
>>>>>>>>>>>>         name: 860CBC7964C9F41AAB9A0BFDAA57DBCB01163779
>>>>>>>>>>>>     item 95 key (455338 DIR_ITEM 3749145932) itemoff 9563 it=
emsize 70
>>>>>>>>>>>>         location key (728144 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39404 data_len 0 name_len 40
>>>>>>>>>>>>         name: 5E3F61D6678EDD6BBDBD9F16E5871D825357F695
>>>>>>>>>>>>     item 96 key (455338 DIR_ITEM 3750982353) itemoff 9493 it=
emsize 70
>>>>>>>>>>>>         location key (721315 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39117 data_len 0 name_len 40
>>>>>>>>>>>>         name: FCE0F0D3C3A3D1DF147BCC410EC03235BECF877E
>>>>>>>>>>>>     item 97 key (455338 DIR_ITEM 3751215179) itemoff 9423 it=
emsize 70
>>>>>>>>>>>>         location key (675576 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 36353 data_len 0 name_len 40
>>>>>>>>>>>>         name: 79606EABD028C5A6DFC0AA2F60B06EB61FFF5CDA
>>>>>>>>>>>>     item 98 key (455338 DIR_ITEM 3754063103) itemoff 9353 it=
emsize 70
>>>>>>>>>>>>         location key (463979 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 25552 data_len 0 name_len 40
>>>>>>>>>>>>         name: 648C5FC8D5C2BB828ED86E44DD9E5FB3A6430332
>>>>>>>>>>>>     item 99 key (455338 DIR_ITEM 3759476008) itemoff 9283 it=
emsize 70
>>>>>>>>>>>>         location key (695411 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 37702 data_len 0 name_len 40
>>>>>>>>>>>>         name: EA0D80B3AC2EB5A79D44A9E36279688B4F4F4571
>>>>>>>>>>>>     item 100 key (455338 DIR_ITEM 3760671333) itemoff 9213 i=
temsize 70
>>>>>>>>>>>>         location key (742035 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39862 data_len 0 name_len 40
>>>>>>>>>>>>         name: 3ACDD6CB0A6CB9AA9C9D9F6EA2AA3339963B7A9C
>>>>>>>>>>>>     item 101 key (455338 DIR_ITEM 3769483178) itemoff 9143 i=
temsize 70
>>>>>>>>>>>>         location key (570869 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 30187 data_len 0 name_len 40
>>>>>>>>>>>>         name: 85A9CF3B7F369C806A0D8768216748C516DD0844
>>>>>>>>>>>>     item 102 key (455338 DIR_ITEM 3770386312) itemoff 9073 i=
temsize 70
>>>>>>>>>>>>         location key (463983 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 25552 data_len 0 name_len 40
>>>>>>>>>>>>         name: 088AFB851C028D9E256D0B7C68348F277FC77557
>>>>>>>>>>>>     item 103 key (455338 DIR_ITEM 3770577855) itemoff 9003 i=
temsize 70
>>>>>>>>>>>>         location key (746148 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39955 data_len 0 name_len 40
>>>>>>>>>>>>         name: 02D103922E00747EE0CA600BAB1DBB820E19945F
>>>>>>>>>>>>     item 104 key (455338 DIR_ITEM 3774765965) itemoff 8933 i=
temsize 70
>>>>>>>>>>>>         location key (728088 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 39396 data_len 0 name_len 40
>>>>>>>>>>>>         name: 9DCEAF9793EA0EF13D1967FDD3CDCA1DE361106F
>>>>>>>>>>>>     item 105 key (455338 DIR_ITEM 3776729019) itemoff 8863 i=
temsize 70
>>>>>>>>>>>>         location key (699983 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 37906 data_len 0 name_len 40
>>>>>>>>>>>>         name: A48EC9DA3C204DF9C124C10C231D1D478BFB6BFA
>>>>>>>>>>>>     item 106 key (455338 DIR_ITEM 3781356904) itemoff 8793 i=
temsize 70
>>>>>>>>>>>>         location key (610716 INODE_ITEM 0) type FILE
>>>>>>>>>>>>         transid 32073 data_len 0 name_len 40
>>>>>>>>>>>>         name: 8B37E9EF2812C5B70E7B0FF7EBCB317B4323BD8A
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> localhost:/ # btrfs inspect-internal dump-super /dev/sda7
>>>>>>>>>>>> superblock: bytenr=3D65536, device=3D/dev/sda7
>>>>>>>>>>>> ---------------------------------------------------------
>>>>>>>>>>>> csum_type        0 (crc32c)
>>>>>>>>>>>> csum_size        4
>>>>>>>>>>>> csum            0x9c238f67 [match]
>>>>>>>>>>>> bytenr            65536
>>>>>>>>>>>> flags            0x1
>>>>>>>>>>>>             ( WRITTEN )
>>>>>>>>>>>> magic            _BHRfS_M [match]
>>>>>>>>>>>> fsid            133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5
>>>>>>>>>>>> label            pt_osa1
>>>>>>>>>>>> generation        429428
>>>>>>>>>>>> root            31473664
>>>>>>>>>>>> sys_array_size        129
>>>>>>>>>>>> chunk_root_generation    429386
>>>>>>>>>>>> root_level        1
>>>>>>>>>>>> chunk_root        154484604928
>>>>>>>>>>>> chunk_root_level    0
>>>>>>>>>>>> log_root        0
>>>>>>>>>>>> log_root_transid    0
>>>>>>>>>>>> log_root_level        0
>>>>>>>>>>>> total_bytes        209715200000
>>>>>>>>>>>> bytes_used        32460804096
>>>>>>>>>>>> sectorsize        4096
>>>>>>>>>>>> nodesize        16384
>>>>>>>>>>>> leafsize (deprecated)        16384
>>>>>>>>>>>> stripesize        4096
>>>>>>>>>>>> root_dir        6
>>>>>>>>>>>> num_devices        2
>>>>>>>>>>>> compat_flags        0x0
>>>>>>>>>>>> compat_ro_flags        0x0
>>>>>>>>>>>> incompat_flags        0x17b
>>>>>>>>>>>>             ( MIXED_BACKREF |
>>>>>>>>>>>>               DEFAULT_SUBVOL |
>>>>>>>>>>>>               COMPRESS_LZO |
>>>>>>>>>>>>               COMPRESS_ZSTD |
>>>>>>>>>>>>               BIG_METADATA |
>>>>>>>>>>>>               EXTENDED_IREF |
>>>>>>>>>>>>               SKINNY_METADATA )
>>>>>>>>>>>> cache_generation    429428
>>>>>>>>>>>> uuid_tree_generation    363
>>>>>>>>>>>> dev_item.uuid        f8bfb24e-353d-43fa-8d37-c2f61d966f32
>>>>>>>>>>>> dev_item.fsid        133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 [m=
atch]
>>>>>>>>>>>> dev_item.type        0
>>>>>>>>>>>> dev_item.total_bytes    104857600000
>>>>>>>>>>>> dev_item.bytes_used    41909485568
>>>>>>>>>>>> dev_item.io_align    0
>>>>>>>>>>>> dev_item.io_width    0
>>>>>>>>>>>> dev_item.sector_size    0
>>>>>>>>>>>> dev_item.devid        1
>>>>>>>>>>>> dev_item.dev_group    0
>>>>>>>>>>>> dev_item.seek_speed    0
>>>>>>>>>>>> dev_item.bandwidth    0
>>>>>>>>>>>> dev_item.generation    0
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> localhost:/ # mount | grep '/mnt/sda7'; blkid | grep
>>>>>>>>>>>> '133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5'; btrfs inspect-intern=
al
>>>>>>>>>>>> inode-resolve 455338 /mnt/sda7
>>>>>>>>>>>> /dev/sda7 on /mnt/sda7 type btrfs
>>>>>>>>>>>> (ro,relatime,space_cache,subvolid=3D260,subvol=3D/@/.snapsho=
ts/1/snapshot)
>>>>>>>>>>>> /dev/sda7: LABEL=3D"pt_osa1" UUID=3D"133e69bd-65d0-4af6-8a4b=
-5d2ddd6fefb5"
>>>>>>>>>>>> UUID_SUB=3D"f8bfb24e-353d-43fa-8d37-c2f61d966f32" TYPE=3D"bt=
rfs"
>>>>>>>>>>>> PTTYPE=3D"dos" PARTLABEL=3D"pt_osa1"
>>>>>>>>>>>> PARTUUID=3D"738e830b-3c58-4ce2-97f4-8e7503b92dce"
>>>>>>>>>>>> /dev/sdb7: LABEL=3D"pt_osa1" UUID=3D"133e69bd-65d0-4af6-8a4b=
-5d2ddd6fefb5"
>>>>>>>>>>>> UUID_SUB=3D"a11e8a7a-5fd2-4f9b-a9cc-b051b211bcbb" TYPE=3D"bt=
rfs"
>>>>>>>>>>>> PTTYPE=3D"dos" PARTLABEL=3D"pt_osb1"
>>>>>>>>>>>> PARTUUID=3D"738e830b-3c58-4ce2-97f4-8e7503b92dce"
>>>>>>>>>>>> ERROR: ino paths ioctl: No such file or directory
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> localhost:/ # btrfs su li /mnt/sda7
>>>>>>>>>>>> ID 258 gen 253 top level 5 path @
>>>>>>>>>>>> ID 259 gen 428546 top level 258 path @/.snapshots
>>>>>>>>>>>> ID 260 gen 428625 top level 259 path @/.snapshots/1/snapshot=

>>>>>>>>>>>> ID 263 gen 429383 top level 258 path @/home
>>>>>>>>>>>> ID 264 gen 429288 top level 258 path @/opt
>>>>>>>>>>>> ID 265 gen 11660 top level 258 path @/srv
>>>>>>>>>>>> ID 266 gen 429332 top level 258 path @/tmp
>>>>>>>>>>>> ID 267 gen 429177 top level 258 path @/usr/local
>>>>>>>>>>>> ID 268 gen 429365 top level 258 path @/var
>>>>>>>>>>>> ID 269 gen 427718 top level 258 path @/root
>>>>>>>>>>>> ID 307 gen 24177 top level 259 path @/.snapshots/6/snapshot
>>>>>>>>>>>> ID 308 gen 24177 top level 259 path @/.snapshots/7/snapshot
>>>>>>>>>>>> ID 309 gen 24177 top level 259 path @/.snapshots/8/snapshot
>>>>>>>>>>>> ID 311 gen 24177 top level 259 path @/.snapshots/9/snapshot
>>>>>>>>>>>> ID 320 gen 24220 top level 259 path @/.snapshots/16/snapshot=

>>>>>>>>>>>> ID 321 gen 24220 top level 259 path @/.snapshots/17/snapshot=

>>>>>>>>>>>> ID 330 gen 27036 top level 259 path @/.snapshots/24/snapshot=

>>>>>>>>>>>> ID 331 gen 27077 top level 259 path @/.snapshots/25/snapshot=

>>>>>>>>>>>> ID 353 gen 73635 top level 259 path @/.snapshots/46/snapshot=

>>>>>>>>>>>> ID 354 gen 73635 top level 259 path @/.snapshots/47/snapshot=

>>>>>>>>>>>> ID 355 gen 73635 top level 259 path @/.snapshots/48/snapshot=

>>>>>>>>>>>> ID 356 gen 73635 top level 259 path @/.snapshots/49/snapshot=

>>>>>>>>>>>> ID 358 gen 176335 top level 259 path @/.snapshots/50/snapsho=
t
>>>>>>>>>>>> ID 359 gen 176335 top level 259 path @/.snapshots/51/snapsho=
t
>>>>>>>>>>>> ID 361 gen 176335 top level 259 path @/.snapshots/52/snapsho=
t
>>>>>>>>>>>> ID 362 gen 176335 top level 259 path @/.snapshots/53/snapsho=
t
>>>>>>>>>>>> ID 363 gen 176335 top level 259 path @/.snapshots/54/snapsho=
t
>>>>>>>>>>>> ID 364 gen 176335 top level 259 path @/.snapshots/55/snapsho=
t
>>>>>>>>>>>> ---------------------------------
>>>>>>>>>>>> #cat /etc/fstab
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 / btrfs compress=
=3Dlzo,rw,noatime 0 0
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /.snapshots btrf=
s
>>>>>>>>>>>> subvol=3D@/.snapshots,compress=3Dlzo 0 0
>>>>>>>>>>>> #UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /boot btrfs
>>>>>>>>>>>> subvol=3D@/boot,rw,noatime 0 0
>>>>>>>>>>>> #UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /boot/grub2/i38=
6-pc btrfs
>>>>>>>>>>>> subvol=3D@/boot/grub2/i386-pc,rw,noatime 0 0
>>>>>>>>>>>> #UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /boot/grub2/x86=
_64-efi
>>>>>>>>>>>> btrfs subvol=3D@/boot/grub2/x86_64-efi,rw,noatime 0 0
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /home btrfs
>>>>>>>>>>>> subvol=3D@/home,compress=3Dlzo,rw,noatime 0 0
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /opt btrfs
>>>>>>>>>>>> subvol=3D@/opt,compress=3Dlzo,rw,noatime 0 0
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /root btrfs
>>>>>>>>>>>> subvol=3D@/root,compress=3Dlzo,rw,noatime 0 0
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /srv btrfs
>>>>>>>>>>>> subvol=3D@/srv,compress=3Dlzo,rw,noatime 0 0
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /tmp btrfs
>>>>>>>>>>>> subvol=3D@/tmp,compress=3Dlzo,rw,noatime 0 0
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /usr/local btrfs=

>>>>>>>>>>>> subvol=3D@/usr/local,compress=3Dlzo,rw,noatime 0 0
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /var btrfs
>>>>>>>>>>>> subvol=3D@/var,compress=3Dlzo,rw,noatime 0 0
>>>>>>>>>>>> UUID=3D9471d962-1890-4624-9d89-2356bd5f0269 swap swap defaul=
ts 0 0
>>>>>>>>>>>> -----------------------------------
>>>>>>>>>>>> #btrfs check --readonly /dev/sda7 2>&1 | tee
>>>>>>>>>>>> /mnt/archive01/--RepairBTRFS/btrfs-check-sda7-20181221.txt
>>>>>>>>>>>> [1/7] checking root items
>>>>>>>>>>>> [2/7] checking extents
>>>>>>>>>>>> [3/7] checking free space cache
>>>>>>>>>>>> [4/7] checking fs roots
>>>>>>>>>>>> ERROR: DIR_ITEM[455338 3754063103] name
>>>>>>>>>>>> 648C5FC8D5C2BB828ED86E44DD9E5FB3A643033276b6353640.first-shu=
tdown.jsonlz4D19A0BCFCB.20181103140737858.wpsnda%202%20Questions%20Answer=
ed%20Lavaughn%20being%20a%20Nazi%20SS_20181029_1033.html0actor_20180213_2=
0181028.html-25-17-.png=3D907-24%2011-57-47%7D.html
>>>>>>>>>>>> namelen 40 filetype 1 mismatch with its hash, wanted 3754063=
103 have
>>>>>>>>>>>> 2111307723
>>>>>>>>>>>> root 263 inode 455338 errors 10, odd dir item
>>>>>>>>>>>>     unresolved ref dir 455338 index 0 namelen 40 name
>>>>>>>>>>>> 648C5FC8D5C2BB828ED86E44DD9E5FB3A6430332 filetype 1 errors 6=
, no dir
>>>>>>>>>>>> index, no inode ref
>>>>>>>>>>>>     unresolved ref dir 455338 index 5857 namelen 40 name
>>>>>>>>>>>> 648C5FC8D5C2CB828ED86E44DD9E5FB3A6430332 filetype 1 errors 1=
, no dir
>>>>>>>>>>>> item
>>>>>>>>>>>> relocroot 263 inode 455338 errors 10, odd dir item
>>>>>>>>>>>>     unresolved ref dir 455338 index 0 namelen 40 name
>>>>>>>>>>>> 648C5FC8D5C2BB828ED86E44DD9E5FB3A6430332 filetype 1 errors 6=
, no dir
>>>>>>>>>>>> index, no inode ref
>>>>>>>>>>>>     unresolved ref dir 455338 index 5857 namelen 40 name
>>>>>>>>>>>> 648C5FC8D5C2CB828ED86E44DD9E5FB3A6430332 filetype 1 errors 1=
, no dir
>>>>>>>>>>>> item
>>>>>>>>>>>> ERROR: errors found in fs roots
>>>>>>>>>>>> Opening filesystem to check...
>>>>>>>>>>>> Checking filesystem on /dev/sda7
>>>>>>>>>>>> UUID: 133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5
>>>>>>>>>>>> found 32460804096 bytes used, error(s) found
>>>>>>>>>>>> total csum bytes: 28059520
>>>>>>>>>>>> total tree bytes: 826228736
>>>>>>>>>>>> total fs tree bytes: 739164160
>>>>>>>>>>>> total extent tree bytes: 48562176
>>>>>>>>>>>> btree space waste bytes: 171226092
>>>>>>>>>>>> file data blocks allocated: 41388740608
>>>>>>>>>>>>  referenced 47772729344
>>>>>>>>>>>> -----------------------------------
>>>>>>>>>>>> localhost:/home/linux # mount -t btrfs -o
>>>>>>>>>>>> subvol=3D@/home,rw,usebackuproot
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /mnt/sda7-home
>>>>>>>>>>>> mount: /mnt/sda7-home: wrong fs type, bad option, bad superb=
lock on
>>>>>>>>>>>> /dev/sdb7, missing codepage or helper program, or other erro=
r.
>>>>>>>>>>>> [Sat Dec 22 12:20:36 2018] BTRFS info (device sda7): trying =
to use
>>>>>>>>>>>> backup root at mount time
>>>>>>>>>>>> [Sat Dec 22 12:20:36 2018] BTRFS info (device sda7): disk sp=
ace
>>>>>>>>>>>> caching is enabled
>>>>>>>>>>>> [Sat Dec 22 12:20:36 2018] BTRFS info (device sda7): has ski=
nny extents
>>>>>>>>>>>> [Sat Dec 22 12:20:55 2018] BTRFS critical (device sda7): cor=
rupt leaf:
>>>>>>>>>>>> root=3D263 block=3D537133056 slot=3D98 ino=3D455338, name ha=
sh mismatch with
>>>>>>>>>>>> key, have 0x000000007dd7ffcb expect 0x00000000dfc274ff
>>>>>>>>>>>> [Sat Dec 22 12:20:55 2018] BTRFS critical (device sda7): cor=
rupt leaf:
>>>>>>>>>>>> root=3D263 block=3D537133056 slot=3D98 ino=3D455338, name ha=
sh mismatch with
>>>>>>>>>>>> key, have 0x000000007dd7ffcb expect 0x00000000dfc274ff
>>>>>>>>>>>> [Sat Dec 22 12:20:55 2018] BTRFS: error (device sda7) in
>>>>>>>>>>>> merge_reloc_roots:2425: errno=3D-5 IO failure
>>>>>>>>>>>> [Sat Dec 22 12:20:55 2018] BTRFS warning (device sda7): fail=
ed to
>>>>>>>>>>>> recover relocation: -30
>>>>>>>>>>>> [Sat Dec 22 12:20:55 2018] BTRFS error (device sda7): cleane=
r
>>>>>>>>>>>> transaction attach returned -30
>>>>>>>>>>>> [Sat Dec 22 12:20:55 2018] BTRFS error (device sda7): open_c=
tree failed
>>>>>>>>>>>> -----------------------------------
>>>>>>>>>>>> localhost:/home/linux # mount -t btrfs -o subvol=3D@,rw,useb=
ackuproot
>>>>>>>>>>>> UUID=3D133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5 /mnt/sda7
>>>>>>>>>>>> mount: /mnt/sda7: wrong fs type, bad option, bad superblock =
on
>>>>>>>>>>>> /dev/sdb7, missing codepage or helper program, or other erro=
r
>>>>>>>>>>>> [Sat Dec 22 12:22:11 2018] BTRFS info (device sda7): trying =
to use
>>>>>>>>>>>> backup root at mount time
>>>>>>>>>>>> [Sat Dec 22 12:22:11 2018] BTRFS info (device sda7): disk sp=
ace
>>>>>>>>>>>> caching is enabled
>>>>>>>>>>>> [Sat Dec 22 12:22:11 2018] BTRFS info (device sda7): has ski=
nny extents
>>>>>>>>>>>> [Sat Dec 22 12:22:29 2018] BTRFS critical (device sda7): cor=
rupt leaf:
>>>>>>>>>>>> root=3D263 block=3D537133056 slot=3D98 ino=3D455338, name ha=
sh mismatch with
>>>>>>>>>>>> key, have 0x000000007dd7ffcb expect 0x00000000dfc274ff
>>>>>>>>>>>> [Sat Dec 22 12:22:29 2018] BTRFS critical (device sda7): cor=
rupt leaf:
>>>>>>>>>>>> root=3D263 block=3D537133056 slot=3D98 ino=3D455338, name ha=
sh mismatch with
>>>>>>>>>>>> key, have 0x000000007dd7ffcb expect 0x00000000dfc274ff
>>>>>>>>>>>> [Sat Dec 22 12:22:29 2018] BTRFS: error (device sda7) in
>>>>>>>>>>>> merge_reloc_roots:2425: errno=3D-5 IO failure
>>>>>>>>>>>> [Sat Dec 22 12:22:29 2018] BTRFS warning (device sda7): fail=
ed to
>>>>>>>>>>>> recover relocation: -30
>>>>>>>>>>>> [Sat Dec 22 12:22:29 2018] BTRFS error (device sda7): cleane=
r
>>>>>>>>>>>> transaction attach returned -30
>>>>>>>>>>>> [Sat Dec 22 12:22:29 2018] BTRFS error (device sda7): open_c=
tree failed
>>>>>>>>>>>> -----------------------------------
>>>>>>>>>>>> localhost:/home/linux # btrfs rescue super-recover /dev/sda7=

>>>>>>>>>>>> All supers are valid, no need to recover
>>>>>>>>>>>> -----------------------------------
>>>>>>>>>>>> localhost:/home/linux # btrfs rescue zero-log /dev/sda7
>>>>>>>>>>>> Clearing log on /dev/sda7, previous log_root 0, level 0
>>>>>>>>>>>> localhost:/home/linux # btrfs rescue zero-log /dev/sdb7
>>>>>>>>>>>> Clearing log on /dev/sdb7, previous log_root 0, level 0
>>>>>>>>>>>> -----------------------------------
>>>>>>>>>>>> localhost:/home/linux # btrfs rescue chunk-recover /dev/sda7=

>>>>>>>>>>>> Scanning: DONE in dev0, DONE in dev1
>>>>>>>>>>>> We are going to rebuild the chunk tree on disk, it might des=
troy the
>>>>>>>>>>>> old metadata on the disk, Are you sure? [y/N]: y
>>>>>>>>>>>> Chunk tree recovered successfully
>>>>>>>>>>>> -----------------------------------
>>>>>>>>>>>> localhost:/home/linux # btrfs check --repair /dev/sda7 2>&1 =
| tee
>>>>>>>>>>>> /mnt/archive01/--RepairBTRFS/btrfs-check-sda7-repair-2018122=
2.txt
>>>>>>>>>>>> [1/7] checking root items
>>>>>>>>>>>> Fixed 0 roots.
>>>>>>>>>>>> [2/7] checking extents
>>>>>>>>>>>> [3/7] checking free space cache
>>>>>>>>>>>> [4/7] checking fs roots
>>>>>>>>>>>> ERROR: DIR_ITEM[455338 3754063103] name
>>>>>>>>>>>> 648C5FC8D5C2BB828ED86E44DD9E5FB3A643033276b6353640.first-shu=
tdown.jsonlz4D19A0BCFCB.20181103140737858.wpsnda%202%20Questions%20Answer=
ed%20Lavaughn%20being%20a%20Nazi%20SS_20181029_1033.html0actor_20180213_2=
0181028.html-25-17-.png=3D907-24%2011-57-47%7D.html
>>>>>>>>>>>> namelen 40 filetype 1 mismatch with its hash, wanted 3754063=
103 have
>>>>>>>>>>>> 2111307723
>>>>>>>>>>>> root 263 inode 455338 errors 10, odd dir item
>>>>>>>>>>>>     unresolved ref dir 455338 index 0 namelen 40 name
>>>>>>>>>>>> 648C5FC8D5C2BB828ED86E44DD9E5FB3A6430332 filetype 1 errors 6=
, no dir
>>>>>>>>>>>> index, no inode ref
>>>>>>>>>>>>     unresolved ref dir 455338 index 5857 namelen 40 name
>>>>>>>>>>>> 648C5FC8D5C2CB828ED86E44DD9E5FB3A6430332 filetype 1 errors 1=
, no dir
>>>>>>>>>>>> item
>>>>>>>>>>>> relocroot 263 inode 455338 errors 10, odd dir item
>>>>>>>>>>>>     unresolved ref dir 455338 index 0 namelen 40 name
>>>>>>>>>>>> 648C5FC8D5C2BB828ED86E44DD9E5FB3A6430332 filetype 1 errors 6=
, no dir
>>>>>>>>>>>> index, no inode ref
>>>>>>>>>>>>     unresolved ref dir 455338 index 5857 namelen 40 name
>>>>>>>>>>>> 648C5FC8D5C2CB828ED86E44DD9E5FB3A6430332 filetype 1 errors 1=
, no dir
>>>>>>>>>>>> item
>>>>>>>>>>>> ERROR: errors found in fs roots
>>>>>>>>>>>> enabling repair mode
>>>>>>>>>>>> Opening filesystem to check...
>>>>>>>>>>>> Checking filesystem on /dev/sda7
>>>>>>>>>>>> UUID: 133e69bd-65d0-4af6-8a4b-5d2ddd6fefb5
>>>>>>>>>>>> No device size related problem found
>>>>>>>>>>>> cache and super generation don't match, space cache will be =
invalidated
>>>>>>>>>>>> found 32460181504 bytes used, error(s) found
>>>>>>>>>>>> total csum bytes: 28059520
>>>>>>>>>>>> total tree bytes: 826392576
>>>>>>>>>>>> total fs tree bytes: 739328000
>>>>>>>>>>>> total extent tree bytes: 48562176
>>>>>>>>>>>> btree space waste bytes: 171278836
>>>>>>>>>>>> file data blocks allocated: 41415008256
>>>>>>>>>>>>  referenced 47803871232
>>>>>>>>>>>> -----------------------------------
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>
>>>>>>>
>>>>>
>>


--MJdL4RXV7QKPln3tgfckzmvhhxx83cJWb--

--qmGFOI4mvAlk6aoHlqSQpZQ5dSIpmJFAk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwoSsAACgkQwj2R86El
/qjvNAf/SnRQdxmAuXsIRXIgLBcRdKMnBz4FW3cZHWwB3GAREue1YPVpHO19/m06
6/FeZQtOEQ4+7X5D6Rbcwab07LxsJnsIvAV2HUWCH0UHD94/Pgejla8kpMnEVwjp
Prp2lI8UCGfYGScnq/063hCFMW62kmHqpLyBiyJwvAO46PnMWrIwTYtT3bg85AWC
3tcDLDnR7lthO5+j+IAKcueJALm5jRuvV3vDtbAHiwY3AiomCUp3csd7/chjTqlZ
7wA4ouV20aoE3w6hOd1oZhGCDcp65dRHYSccy/QvDAXExuCOdhDa+FsafishBcfn
BEWcy7nENGmA3VWyqpwsG0gQOVLs/w==
=hExR
-----END PGP SIGNATURE-----

--qmGFOI4mvAlk6aoHlqSQpZQ5dSIpmJFAk--
