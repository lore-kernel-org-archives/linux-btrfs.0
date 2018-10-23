Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F31DC67863
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 187212075D
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:45:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 187212075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbeJWSIe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 14:08:34 -0400
Received: from mout.gmx.net ([212.227.15.15]:51669 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbeJWSIe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 14:08:34 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lbdl5-1flpyM2079-00lB3R; Tue, 23
 Oct 2018 11:45:46 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lbdl5-1flpyM2079-00lB3R; Tue, 23
 Oct 2018 11:45:46 +0200
Subject: Re: [PATCH 00/13] btrfs-progs: fixes of file extent in original and
 lowmem check
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
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
Message-ID: <75e8466f-3391-b063-6f88-e67acfb7a462@gmx.com>
Date:   Tue, 23 Oct 2018 17:45:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:AZDDC0igRHBU86tvKQ09Yn9nzzLK6h5Y3+PAqPx0WqYQ5f6DIjo
 vUhXpnYcXA8lOskFY7dksCRdp1deUMJZW+sjoUZCY5QnRf81Nf5qIHa+6g/AnesLtLyZoin
 ZM3uGKl83/hHSVoIUHPvp3oJ2BVQKOYZYAjHa/tvNDYzJ6fTWBSTnK1VW/g3KwjeDCkhyYx
 ywqALznylYOwhYhY8d5/g==
X-UI-Out-Filterresults: notjunk:1;V01:K0:fMERSybm964=:bh2BkU0O/krD/kmlOahDYu
 kfyWQ5XAb1Zb/qMtTOfK3/ay8Hu/yx5lekQl7diYC6FyHDlos1MnPIsKI8Fq/vXzMDrtvxNJN
 i2WQidb6qOu/prPOjd8l5FuM4ofkl+Pcwhy3mPw3TRjSP+IzEtztyqznbZLzlZTc4PSoLWX1K
 ACuqy9bFCRedsZGu1pfzPHdySpF7cZ/E1HW9Jf4K1bZb50NGwugLckF9MzJxLY3cJPY03WCG3
 tmVrRm3vsI21ONoQWj85yL1pmTim/tMmM2wlZgO92fSV5WW/Ld4yCOURFkhogRhmv4M3wT2fm
 HJUco/U9vyjJ5iR5n6QBlEP9OGrOBvz9iNo3sEd5KzC12+v5BFVPzdA30SU+MkMiVu5sdMqan
 wHYqmtursu3lm2DizMoEYQcvR8L9rfh69Yz823CJSRQVWVe/oZAzETKFaAhqOAPHOPwUbCBK4
 wkXzILEeqKhL3+1fibO1w8gfSJW12ojs2jb186lpbsDZZcFgoV7lNDYR6tzDeayKh4RY/LpJq
 Sq2stGRJtQNMJl5+kdh6V5TSqL1V3nUPtdos9BMC9Rn2s37H9XN1oRgfh/pxHFY4MSKW0jlSf
 QjaVS1nUOg4vlSRMDkxEZOhVqEhHc15BYXaTRk/j5OOUzn+/kKbkBCof3onAWhgxRudxx60LC
 b/IypNZnGlU1zCONoxP0OFdW/zMWOybsx13RoRdNkpR9ELaS9sfNws9Pu1eltyIALVYzIHz/0
 0pWttmdvNRJ6iaIgQVkmk58cSWojZ7pd/qkNtM/dBFTqhhxD34JO8JMYgm52IBlu0L8jP9s31
 OLNwxAEQdW7npBh+rQ0vnREOqoVyrSvRCVCD7VGQnXErXV1Vms=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/23 下午5:41, Su Yue wrote:
> This patchset can be fetched from my repo:
> https://github.com/Damenly/btrfs-progs/tree/file_extent_fixes
> which is based on kdave/devel whose HEAD is:
> commit 4f20c27ab33aab3efffe13cdae1b8837c821d0d7 (kdave/devel)
> Author: Nikolay Borisov <nborisov@suse.com>
> Date:   Fri Jun 15 07:13:50 2018 +0000
> 
>     btrfs-progs: tests: test for FST corruption detection/repair
> 
> This set fixes bugs of checking unaligned disk_bytenr extent_data and
> orphan extent. Lowmem part patches can be used in common, so I put
> this two fixes together.
> 
> For unaligned disk_bytenr extent_data, now original and lowmem check
> both delete the corrupted part and punch a hole.

This method looks pretty valid.

> 
> For orphan extent, lowmem mode has no change here.
> Original mode discards function of detect and repair orphan extents
> according extent items. Because as corruptions the community reported,
> extent tree is more problematic than fs trees.

This also looks pretty nice to me.

Extent tree can't really be trusted, not to mention under most case it's
extent tree itself corrupted.

More over, even we lost every tree block of extent tree, it's still
possible for btrfs-progs to recover the whole fs using btrfs-restore.

(In theory, we should provide a mount option to allow RO mount to read
the fs without a valid extent tree).

So this is the correct way to do.

Thanks,
Qu
> 
> patch[1-2] fix minor bugs in lowmem repair.
> patch[3] fixes false alert about repaired extent item in lowmem mode.
> patch[4] fixes annoying alerts about gap in file extent in lowmem mode.
> patch[5,6,7] enable check and repair unaligned disk_bytenr file extent
> 	     in lowmem mode.
> patch[8,9] revert support for orphan extent in original mode.
> patch[10] fixes bug about finding right backrefs in original mode.
> patch[11] adds support to detect and delete unaligned file extents
> 	       in original.
> patch[12] adds a test image which lacks of a file extent.
> patch[13] enables lowmem repair of test case fsck-tests/001 which has
> 	  	  unaligned disk_bytenr file extent.
> 
> 
> Lu Fengqi (2):
>   btrfs-progs: lowmem: fix false alert about the existence of gaps in
>     the check_file_extent
>   btrfs-progs: tests: add case for inode lose one file extent
> 
> Su Yanjun (4):
>   btrfs-progs: Revert "btrfs-progs: Add repair and report function for
>     orphan file extent."
>   btrfs-progs: Revert "btrfs-progs: Record orphan data extent ref to
>     corresponding root."
>   btrfs-progs: check: fix bug in find_possible_backrefs
>   btrfs-progs: check: Delete file extent item with unaligned extent
>     backref
> 
> Su Yue (7):
>   btrfs-progs: lowmem: add argument path to punch_extent_hole()
>   btrfs-progs: lowmem: move nbytes check before isize check
>   btrfs-progs: lowmem: fix false alert if extent item has been repaired
>   btrfs-progs: lowmem: check unaligned disk_bytenr for extent_data
>   btrfs-progs: lowmem: rename delete_extent_tree_item() to delete_item()
>   btrfs-progs: lowmem: delete unaligned bytes extent data under repair
>   btrfs-progs: fsck-test: enable lowmem repair for case 001
> 
>  check/main.c                                  | 581 +++++++++++-------
>  check/mode-lowmem.c                           | 272 ++++----
>  check/mode-original.h                         |  30 +-
>  ctree.h                                       |  10 +-
>  disk-io.c                                     |   2 +-
>  .../.lowmem_repairable                        |   0
>  .../.lowmem_repairable                        |   0
>  .../default_case.img                          | Bin 0 -> 3072 bytes
>  8 files changed, 538 insertions(+), 357 deletions(-)
>  create mode 100644 tests/fsck-tests/001-bad-file-extent-bytenr/.lowmem_repairable
>  create mode 100644 tests/fsck-tests/038-missing-one-file-extent/.lowmem_repairable
>  create mode 100644 tests/fsck-tests/038-missing-one-file-extent/default_case.img
> 
