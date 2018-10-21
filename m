Return-Path: <SRS0=ymi4=NB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44614ECDE43
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Oct 2018 10:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAEB420869
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Oct 2018 10:26:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="raJgxKvd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAEB420869
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbeJUSjx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Oct 2018 14:39:53 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39741 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbeJUSjw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Oct 2018 14:39:52 -0400
Received: by mail-pf1-f195.google.com with SMTP id c25-v6so18485421pfe.6;
        Sun, 21 Oct 2018 03:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hUWJZg4j0jB2zF1ITtOaMc3F8tXhDnnQe2FFo3/OT6c=;
        b=raJgxKvdDjS/1Sd5/Hj8pSlXmo+bqcvV/38UntsTlCB4xdFqiu8IA4L66OhI3mjnxn
         /r2cF9mgc/R+S7uL6HtUnDKGgF89nQZewG1Xj0JnLeNxfQhNzbA01o+M4qH6MkJS4PD1
         GAZRfTad56inp1PTKESAzhXf9dlSWtMlIxfTYzV2Q+CJN/TcmGV8j9T+xC9x+zvGle3H
         mPhW31gFBY/HSth1d4r6XO2RfungWu8LegNr/dDwgzXXXmSsKcQuaq2/o+picQgb01HI
         lvFbVYYMOC/zrsZVI6IwVAfPY7b10UDfTaMS4mgOYXUqoiUovi9LXLFwowzXdvR5LE8x
         I2dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hUWJZg4j0jB2zF1ITtOaMc3F8tXhDnnQe2FFo3/OT6c=;
        b=LBhBR8NURxjGxMVb9rha572cUdwpZVbgUN4FWq+lN+hBLsApTKG8ghLM83d9yci2Av
         cId1Csg0CbG5m6yGtz45G30tfVqXle+RCKJYOEEmBAs8K2rq5SMrFxvadm1NnbM9cFXf
         BLAVCcl/OcidPmgAcpwzahlcnl/szU6JZOgzUSOPUTL2dd4YiYHn51XBYKi0xKSW2OrP
         Q4feIGIEGvKZTujyunI6Zg9A6r/nOK01IlKc+vjvOSPq+zAKCjeQ2rwG+9j2Tom0zslq
         KsYNWceCAseaM7vPvXYxqkjgtyTZyqtGzFvx+P+j0ZTtoQDHqlGZBDsnZ8HTR78URRTZ
         C3+g==
X-Gm-Message-State: ABuFfog50LaKBP+/yPn/MyH75Szki2lUsSqXH+Vo+SFh/DbuYCDpv0jV
        ormP0kM4U8VkRHxN/JarA6U=
X-Google-Smtp-Source: ACcGV60P6tyOPbvPfhfZ/zr27x2Av9idUT5vC0zRGp9eyuyaLFWOkG/Lt0bFakZcyEfEs+TDB7xJvQ==
X-Received: by 2002:a62:6ac4:: with SMTP id f187-v6mr9595275pfc.103.1540117561560;
        Sun, 21 Oct 2018 03:26:01 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id y144-v6sm42003437pfb.81.2018.10.21.03.25.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 21 Oct 2018 03:26:00 -0700 (PDT)
Date:   Sun, 21 Oct 2018 18:25:54 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc:     fstests@vger.kernel.org
Subject: Re: [PATCH v2 rev log added] fstests: btrfs verify hardening agaist
 duplicate fsid
Message-ID: <20181021102554.GR17817@desktop>
References: <1538383475-2532-1-git-send-email-anand.jain@oracle.com>
 <1539023301-4583-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539023301-4583-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 09, 2018 at 02:28:21AM +0800, Anand Jain wrote:
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

Hi btrfs folks,

Please help review if this patch adds a valid test for btrfs. It looks
fine to me from fstests' perspective of view, though it needs some
really minor tweaks that I can fix on commit (e.g. format of for loop,
adding space after '#' in comments line). Thanks a lot!

Eryu

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
> +
> +echo dev_foo=$dev_foo >> $seqres.full
> +echo dev_bar=$dev_bar >> $seqres.full
> +echo | tee -a $seqres.full
> +
> +rm -rf $mnt > /dev/null 2>&1
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
