Return-Path: <SRS0=jasM=MS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61CACC64EB8
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E0A721486
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:14:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hhBIJIeX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E0A721486
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbeJFRRi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Oct 2018 13:17:38 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41892 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbeJFRRi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2018 13:17:38 -0400
Received: by mail-pf1-f193.google.com with SMTP id m77-v6so6206288pfi.8;
        Sat, 06 Oct 2018 03:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TDC9gbh3CHJ29ZSxXpIlsrKYAlxjN3InpLa2IQ8lhWQ=;
        b=hhBIJIeX8TgM7YWMneY8YaqAhQVisrMenh3x4t6Vs1fCJwIK9tAjUYXnkPO41/NPgn
         5VaSNs3RapGg9Xpxw8uy7i9nmSSEl9Tc8wHD3d6WvCfvvagaQT7pRTNcbXAgd0+/9zRL
         1GovyaesAYXcj+9+4NOcO3nRXjityjgZgk3s9W8ajVQOCYC9Yod95TxAxPeOHU6IFOtC
         4aUnJZLMSeh5UoEXJ31Fb4uuoCWg7LQrKugxev3XCJJ80nYvinb/MYJhvsSqGf1qTKM3
         H8myvBWEcH7C/befR81ds32nhunPUAVtXfV4LlbBM7DB7BXTZ9LlbW5dqyAU0ub7Toti
         AIhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TDC9gbh3CHJ29ZSxXpIlsrKYAlxjN3InpLa2IQ8lhWQ=;
        b=ZjdP7S7Y4rECAIsGlTGFW6Tu9vgpmPITJWl0VxeMoJbJq2S8UXrkeBb0GDXCxyhNLK
         2caJegJwrUSzhL/7jxQ2CsrCdzICnn0OSabibt2oIeB0cD0lUKJeNxLVDjxM7cLrBBdg
         HBXSqJnaQVX9ZE+88kqkqonYl71q2IS0vX+bv431xVo8STkiuPaljEZo4oIXzKN1Dkp6
         ZQuZhGNEsRLwfCMyu2jjDSYoJglStwqpvO3v5KsQIUWl+SSLLeHGlOUwVzr0VijzQLuh
         CUom/6ZyKfa+MiuZW5g1xWlwpe7uhHHMh8Mixfv2rVg4P/+IW/wDgMywEEn7SjYVSZEE
         iWRw==
X-Gm-Message-State: ABuFfoga3KEWYMD30MgltvbgcMy7gk2YG3feRS91kvGOQnElxw0fcpzd
        U2Uv/8JWNuEj47CajIsnUfDMhpIYNys=
X-Google-Smtp-Source: ACcGV60wiLwcuqO4p1xRUc8HnIrGIKk5RktcfJ9ww29uxleAoLqh2y1HCdELy6TFeSvIPVMRVBVz4g==
X-Received: by 2002:a63:4563:: with SMTP id u35-v6mr13666446pgk.30.1538820896006;
        Sat, 06 Oct 2018 03:14:56 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id s23-v6sm14327839pgg.67.2018.10.06.03.14.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Oct 2018 03:14:55 -0700 (PDT)
Date:   Sat, 6 Oct 2018 18:14:49 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs verify hardening agaist duplicate fsid
Message-ID: <20181006101449.GJ17817@desktop>
References: <1538383475-2532-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538383475-2532-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 01, 2018 at 04:44:35PM +0800, Anand Jain wrote:
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
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Looks like that the test will break the whole test env as it leaves an
unmountable $SCRATCH_MNT. I'd wait for the fix to get in first before
merging the test, in case it breaks normal regression tests. (I noticed
that the test is not in 'auto' group, so it's not that dangerous.)

Also, it'd be great if test can be reviewed by btrfs folks too!

> ---
>  tests/btrfs/173     | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/173.out |  5 ++++
>  tests/btrfs/group   |  1 +
>  3 files changed, 78 insertions(+)
>  create mode 100755 tests/btrfs/173
>  create mode 100644 tests/btrfs/173.out
> 
> diff --git a/tests/btrfs/173 b/tests/btrfs/173
> new file mode 100755
> index 000000000000..f59a62e206c3
> --- /dev/null
> +++ b/tests/btrfs/173
> @@ -0,0 +1,72 @@
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
> +_cleanup()
> +{
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
> +dev_foo=$(echo $SCRATCH_DEV_POOL | awk '{print $1}' | rev | cut -d"/" -f1 | rev)
> +dev_bar=$(echo $SCRATCH_DEV_POOL | awk '{print $2}' | rev | cut -d"/" -f1 | rev)

This doesn't work if the devices in SCRATCH_DEV_POOL are symlinks, e.g.
lvm devices: /dev/mapper/testvg-testlv1, dev_foo is "testvg-testlv1" in
this case.

> +
> +_mkfs_dev /dev/$dev_foo

But /dev/testvg-testlv1 isn't existed.

_short_dev and/or _real_dev is useful in this case. e.g.

dev_foo=$(echo $SCRATCH_DEV_POOL | awk '{print $1}')
# dev_foo is like "dm-1"
dev_foo=$(_short_dev $dev_foo)
# dev_foo is like "/dev/dm-1"
dev_foo=$(_real_dev $dev_foo)

> +_mount /dev/$dev_foo $SCRATCH_MNT

It'd better to mount non-SCRATCH_DEV to other mount point, e.g.
$TEST_DIR/$seq.mnt

Thanks,
Eryu

> +
> +echo mount before btrfs image clone | tee -a $seqres.full
> +findmnt /dev/$dev_foo | grep -v TARGET | awk '{print $1" "$2}' | \
> +	sed -e "s/$dev_foo/dev_foo/g" | _filter_scratch | tee -a $seqres.full
> +findmnt /dev/$dev_bar | grep -v TARGET | awk '{print $1" "$2}' | \
> +	sed -e "s/$dev_bar/dev_bar/g" | _filter_scratch | tee -a $seqres.full
> +
> +for sb_bytenr in 65536 67108864
> +do
> +	echo -n "dd status=none if=/dev/$dev_foo of=/dev/$dev_bar bs=1 "\
> +		"seek=$sb_bytenr skip=$sb_bytenr count=4096" >> $seqres.full
> +	dd status=none if=/dev/$dev_foo of=/dev/$dev_bar bs=1 seek=$sb_bytenr \
> +				skip=$sb_bytenr count=4096 >> $seqres.full 2>&1
> +	echo ..:$? >> $seqres.full
> +done
> +
> +echo mount after btrfs image clone | tee -a $seqres.full
> +findmnt /dev/$dev_foo | grep -v TARGET | awk '{print $1" "$2}' | \
> +	sed -e "s/$dev_foo/dev_foo/g" | _filter_scratch | tee -a $seqres.full
> +findmnt /dev/$dev_bar | grep -v TARGET | awk '{print $1" "$2}' | \
> +	sed -e "s/$dev_bar/dev_bar/g" | _filter_scratch | tee -a $seqres.full
> +
> +_scratch_dev_pool_put
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/173.out b/tests/btrfs/173.out
> new file mode 100644
> index 000000000000..a2ef7a26f4b9
> --- /dev/null
> +++ b/tests/btrfs/173.out
> @@ -0,0 +1,5 @@
> +QA output created by 173
> +mount before btrfs image clone
> +SCRATCH_MNT /dev/dev_foo
> +mount after btrfs image clone
> +SCRATCH_MNT /dev/dev_foo
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 45782565c3b7..b2f1393f3e97 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -175,3 +175,4 @@
>  170 auto quick snapshot
>  171 auto quick qgroup
>  172 auto quick punch
> +173 volume
> -- 
> 1.8.3.1
> 
