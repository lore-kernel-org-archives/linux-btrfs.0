Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EFECC6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 15:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F21362082B
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 15:02:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F21362082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbeJZXkA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 19:40:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:44226 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726195AbeJZXj7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 19:39:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D8182AE1D;
        Fri, 26 Oct 2018 15:02:33 +0000 (UTC)
Subject: Re: [PATCH v2 rev log added] fstests: btrfs verify hardening agaist
 duplicate fsid
To:     Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
References: <1538383475-2532-1-git-send-email-anand.jain@oracle.com>
 <1539023301-4583-1-git-send-email-anand.jain@oracle.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 xsFNBFiKBz4BEADNHZmqwhuN6EAzXj9SpPpH/nSSP8YgfwoOqwrP+JR4pIqRK0AWWeWCSwmZ
 T7g+RbfPFlmQp+EwFWOtABXlKC54zgSf+uulGwx5JAUFVUIRBmnHOYi/lUiE0yhpnb1KCA7f
 u/W+DkwGerXqhhe9TvQoGwgCKNfzFPZoM+gZrm+kWv03QLUCr210n4cwaCPJ0Nr9Z3c582xc
 bCUVbsjt7BN0CFa2BByulrx5xD9sDAYIqfLCcZetAqsTRGxM7LD0kh5WlKzOeAXj5r8DOrU2
 GdZS33uKZI/kZJZVytSmZpswDsKhnGzRN1BANGP8sC+WD4eRXajOmNh2HL4P+meO1TlM3GLl
 EQd2shHFY0qjEo7wxKZI1RyZZ5AgJnSmehrPCyuIyVY210CbMaIKHUIsTqRgY5GaNME24w7h
 TyyVCy2qAM8fLJ4Vw5bycM/u5xfWm7gyTb9V1TkZ3o1MTrEsrcqFiRrBY94Rs0oQkZvunqia
 c+NprYSaOG1Cta14o94eMH271Kka/reEwSZkC7T+o9hZ4zi2CcLcY0DXj0qdId7vUKSJjEep
 c++s8ncFekh1MPhkOgNj8pk17OAESanmDwksmzh1j12lgA5lTFPrJeRNu6/isC2zyZhTwMWs
 k3LkcTa8ZXxh0RfWAqgx/ogKPk4ZxOXQEZetkEyTFghbRH2BIwARAQABzSJOaWtvbGF5IEJv
 cmlzb3YgPG5ib3Jpc292QHN1c2UuZGU+wsF4BBMBAgAiBQJYijkSAhsDBgsJCAcDAgYVCAIJ
 CgsEFgIDAQIeAQIXgAAKCRBxvoJG5T8oV/B6D/9a8EcRPdHg8uLEPywuJR8URwXzkofT5bZE
 IfGF0Z+Lt2ADe+nLOXrwKsamhweUFAvwEUxxnndovRLPOpWerTOAl47lxad08080jXnGfYFS
 Dc+ew7C3SFI4tFFHln8Y22Q9075saZ2yQS1ywJy+TFPADIprAZXnPbbbNbGtJLoq0LTiESnD
 w/SUC6sfikYwGRS94Dc9qO4nWyEvBK3Ql8NkoY0Sjky3B0vL572Gq0ytILDDGYuZVo4alUs8
 LeXS5ukoZIw1QYXVstDJQnYjFxYgoQ5uGVi4t7FsFM/6ykYDzbIPNOx49Rbh9W4uKsLVhTzG
 BDTzdvX4ARl9La2kCQIjjWRg+XGuBM5rxT/NaTS78PXjhqWNYlGc5OhO0l8e5DIS2tXwYMDY
 LuHYNkkpMFksBslldvNttSNei7xr5VwjVqW4vASk2Aak5AleXZS+xIq2FADPS/XSgIaepyTV
 tkfnyreep1pk09cjfXY4A7qpEFwazCRZg9LLvYVc2M2eFQHDMtXsH59nOMstXx2OtNMcx5p8
 0a5FHXE/HoXz3p9bD0uIUq6p04VYOHsMasHqHPbsMAq9V2OCytJQPWwe46bBjYZCOwG0+x58
 fBFreP/NiJNeTQPOa6FoxLOLXMuVtpbcXIqKQDoEte9aMpoj9L24f60G4q+pL/54ql2VRscK
 d87BTQRYigc+ARAAyJSq9EFk28++SLfg791xOh28tLI6Yr8wwEOvM3wKeTfTZd+caVb9gBBy
 wxYhIopKlK1zq2YP7ZjTP1aPJGoWvcQZ8fVFdK/1nW+Z8/NTjaOx1mfrrtTGtFxVBdSCgqBB
 jHTnlDYV1R5plJqK+ggEP1a0mr/rpQ9dFGvgf/5jkVpRnH6BY0aYFPprRL8ZCcdv2DeeicOO
 YMobD5g7g/poQzHLLeT0+y1qiLIFefNABLN06Lf0GBZC5l8hCM3Rpb4ObyQ4B9PmL/KTn2FV
 Xq/c0scGMdXD2QeWLePC+yLMhf1fZby1vVJ59pXGq+o7XXfYA7xX0JsTUNxVPx/MgK8aLjYW
 hX+TRA4bCr4uYt/S3ThDRywSX6Hr1lyp4FJBwgyb8iv42it8KvoeOsHqVbuCIGRCXqGGiaeX
 Wa0M/oxN1vJjMSIEVzBAPi16tztL/wQtFHJtZAdCnuzFAz8ue6GzvsyBj97pzkBVacwp3/Mw
 qbiu7sDz7yB0d7J2tFBJYNpVt/Lce6nQhrvon0VqiWeMHxgtQ4k92Eja9u80JDaKnHDdjdwq
 FUikZirB28UiLPQV6PvCckgIiukmz/5ctAfKpyYRGfez+JbAGl6iCvHYt/wAZ7Oqe/3Cirs5
 KhaXBcMmJR1qo8QH8eYZ+qhFE3bSPH446+5oEw8A9v5oonKV7zMAEQEAAcLBXwQYAQIACQUC
 WIoHPgIbDAAKCRBxvoJG5T8oV1pyD/4zdXdOL0lhkSIjJWGqz7Idvo0wjVHSSQCbOwZDWNTN
 JBTP0BUxHpPu/Z8gRNNP9/k6i63T4eL1xjy4umTwJaej1X15H8Hsh+zakADyWHadbjcUXCkg
 OJK4NsfqhMuaIYIHbToi9K5pAKnV953xTrK6oYVyd/Rmkmb+wgsbYQJ0Ur1Ficwhp6qU1CaJ
 mJwFjaWaVgUERoxcejL4ruds66LM9Z1Qqgoer62ZneID6ovmzpCWbi2sfbz98+kW46aA/w8r
 7sulgs1KXWhBSv5aWqKU8C4twKjlV2XsztUUsyrjHFj91j31pnHRklBgXHTD/pSRsN0UvM26
 lPs0g3ryVlG5wiZ9+JbI3sKMfbdfdOeLxtL25ujs443rw1s/PVghphoeadVAKMPINeRCgoJH
 zZV/2Z/myWPRWWl/79amy/9MfxffZqO9rfugRBORY0ywPHLDdo9Kmzoxoxp9w3uTrTLZaT9M
 KIuxEcV8wcVjr+Wr9zRl06waOCkgrQbTPp631hToxo+4rA1jiQF2M80HAet65ytBVR2pFGZF
 zGYYLqiG+mpUZ+FPjxk9kpkRYz61mTLSY7tuFljExfJWMGfgSg1OxfLV631jV1TcdUnx+h3l
 Sqs2vMhAVt14zT8mpIuu2VNxcontxgVr1kzYA/tQg32fVRbGr449j1gw57BV9i0vww==
Message-ID: <c2e09b66-6c15-9bbe-c340-0a6015ea4a0e@suse.com>
Date:   Fri, 26 Oct 2018 18:02:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1539023301-4583-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 8.10.18 г. 21:28 ч., Anand Jain wrote:
> We have a known bug in btrfs, that we let the device path be changed
> after the device has been mounted. So using this loop hole the new
> copied device would appears as if its mounted immediately after its
> been copied. So this test case reproduces this issue.
> 
> For example:
> 
> Initially.. /dev/mmcblk0p4 is mounted as /
> 
> lsblk
> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> mmcblk0     179:0    0 29.2G  0 disk
> |-mmcblk0p4 179:4    0    4G  0 part /
> |-mmcblk0p2 179:2    0  500M  0 part /boot
> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
> 
> btrfs fi show
> Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>     Total devices 1 FS bytes used 1.40GiB
>     devid    1 size 4.00GiB used 3.00GiB path /dev/mmcblk0p4
> 
> Copy mmcblk0 to sda
> dd if=/dev/mmcblk0 of=/dev/sda
> 
> And immediately after the copy completes the change in the device
> superblock is notified which the automount scans using
> btrfs device scan and the new device sda becomes the mounted root
> device.
> 
> lsblk
> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> sda           8:0    1 14.9G  0 disk
> |-sda4        8:4    1    4G  0 part /
> |-sda2        8:2    1  500M  0 part
> |-sda3        8:3    1  256M  0 part
> `-sda1        8:1    1  256M  0 part
> mmcblk0     179:0    0 29.2G  0 disk
> |-mmcblk0p4 179:4    0    4G  0 part
> |-mmcblk0p2 179:2    0  500M  0 part /boot
> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
> btrfs fi show /
> Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>     Total devices 1 FS bytes used 1.40GiB
>     devid    1 size 4.00GiB used 3.00GiB path /dev/sda4
> 
> The bug is quite nasty that you can't either unmount /dev/sda4 or
> /dev/mmcblk0p4. And the problem does not get solved until you take
> the sda out of the system on to another system to change its fsid using
> the 'btrfstune -u' command.

Is there a pending fix for this?

> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1->v2: 
>   dont play around with dev patch use it as it is.
>   do not use SCRATCH_MNT instead create it at the TEST_DIR and its related
>    changes.
>   golden out changes
>    
>  tests/btrfs/173     | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/173.out |  6 ++++
>  tests/btrfs/group   |  1 +
>  3 files changed, 95 insertions(+)
>  create mode 100755 tests/btrfs/173
>  create mode 100644 tests/btrfs/173.out
> 
> diff --git a/tests/btrfs/173 b/tests/btrfs/173
> new file mode 100755
> index 000000000000..b466ae921e19
> --- /dev/null
> +++ b/tests/btrfs/173
> @@ -0,0 +1,88 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Oracle. All Rights Reserved.
> +#
> +# FS QA Test 173
> +#
> +# Fuzzy test for FS image duplication.
> +#  Could be fixed by
> +#    [patch] btrfs: harden agaist duplicate fsid
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +mnt=$TEST_DIR/$seq.mnt
> +_cleanup()
> +{
> +	rm -rf $mnt > /dev/null 2>&1
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch_dev_pool 2
> +_scratch_dev_pool_get 2
> +
> +dev_foo=$(echo $SCRATCH_DEV_POOL | awk '{print $1}')
> +dev_bar=$(echo $SCRATCH_DEV_POOL | awk '{print $2}')

Naming devices _foo and _bar just shows you could not care less about
the test. Either use sane names - primary_dev/secondary dev or device_1
and device_2.

> +
> +echo dev_foo=$dev_foo >> $seqres.full
> +echo dev_bar=$dev_bar >> $seqres.full
> +echo | tee -a $seqres.full
> +
> +rm -rf $mnt > /dev/null 2>&1

So what is $mnt? I can see it's used by very few tests and it's not
obvious? Generally you should either define it as a local variable or
use one of the SCRATCH_MNT/TEST_MNT global variables. Also I checked
with Eric re. the use of $mnt in tests and his conclusion is :

"<sandeen> looks like a bug"

> +mkdir $mnt
> +_mkfs_dev $dev_foo
> +_mount $dev_foo $mnt
> +
> +check_btrfs_mount()
> +{
> +	local x=$(findmnt $mnt | grep -v TARGET | awk '{print $2}')
> +	[[ $x == $dev_foo ]] && echo DEV_FOO
> +	[[ $x == $dev_bar ]] && echo DEV_BAR
> +}

Same thing here re. DEV_(FOO|BAR).

> +
> +echo MNT $(check_btrfs_mount)
> +
> +for sb_bytenr in 65536 67108864
> +do
> +	echo -n "dd status=none if=$dev_foo of=$dev_bar bs=1 "\
> +		"seek=$sb_bytenr skip=$sb_bytenr count=4096" >> $seqres.full
> +	dd status=none if=$dev_foo of=$dev_bar bs=1 seek=$sb_bytenr \
> +				skip=$sb_bytenr count=4096 >> $seqres.full 2>&1
> +	echo ..:$? >> $seqres.full

This is an overkill, just use dd ... >/dev/null 2>&1, no one cares about
the output of that. Also use DIO so that sb's are directly written to
the devices.

> +done
> +
> +#Original device is mounted, scan of its clone should fail
> +$BTRFS_UTIL_PROG device scan $dev_bar >> $seqres.full 2>&1
> +echo btrfs device scan dev_bar ...:$?| tee -a $seqres.full
> +
> +echo MNT $(check_btrfs_mount)
> +
> +#Original device scan should be successful
> +$BTRFS_UTIL_PROG device scan $dev_foo >> $seqres.full 2>&1
> +echo btrfs device scan dev_foo ...:$?| tee -a $seqres.full
> +
> +umount $mnt > /dev/null 2>&1
> +_scratch_dev_pool_put
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/173.out b/tests/btrfs/173.out
> new file mode 100644
> index 000000000000..3c7e3fb4e3f7
> --- /dev/null
> +++ b/tests/btrfs/173.out
> @@ -0,0 +1,6 @@
> +QA output created by 173
> +
> +MNT DEV_FOO
> +btrfs device scan dev_bar ...:1
> +MNT DEV_FOO
> +btrfs device scan dev_foo ...:0

It seems the output is really pointless it should just be "Silence is
golden". Then in the test you would do all your run-time checks of
what's the source of the mount etc etc and if your expectations don't
match you fail the test and don't output "Silence is golden" which would
signal success. Check for example

> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 45782565c3b7..b2f1393f3e97 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -175,3 +175,4 @@
>  170 auto quick snapshot
>  171 auto quick qgroup
>  172 auto quick punch
> +173 volume
> 
