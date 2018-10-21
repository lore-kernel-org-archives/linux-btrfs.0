Return-Path: <SRS0=ymi4=NB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D611ECDE3D
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Oct 2018 09:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24D8B2083E
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Oct 2018 09:20:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24D8B2083E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbeJURdv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Oct 2018 13:33:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:47680 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726975AbeJURdv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Oct 2018 13:33:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 856AAAE6C;
        Sun, 21 Oct 2018 09:20:10 +0000 (UTC)
Subject: Re: [PATCH] btrfs/154: test for device dynamic rescan
To:     fdmanana@gmail.com, Anand Jain <anand.jain@oracle.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20171113022541.7413-1-anand.jain@oracle.com>
 <CAL3q7H41dQpiVaCyre3sCgAaVXd19-cWbLO68z4ovJz2F1E2-g@mail.gmail.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <a83fb0ce-dff8-9389-2371-f2e7a5164153@suse.com>
Date:   Sun, 21 Oct 2018 10:20:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H41dQpiVaCyre3sCgAaVXd19-cWbLO68z4ovJz2F1E2-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 21.10.2018 10:16, Filipe Manana wrote:
> On Mon, Nov 13, 2017 at 2:26 AM Anand Jain <anand.jain@oracle.com> wrote:
>>
>> Make sure missing device is included in the alloc list when it is
>> scanned on a mounted FS.
>>
>> This test case needs btrfs kernel patch which is in the ML
>>   [PATCH] btrfs: handle dynamically reappearing missing device
>> Without the kernel patch, the test will run, but reports as
>> failed, as the device scanned won't appear in the alloc_list.
> 
> So that patch was never merged, at least not with that subject.
> What happened?

https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/tests/btrfs/154

In my testing of misc-next this test has been failing for me.
> 
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>  tests/btrfs/154     | 188 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/154.out |  10 +++
>>  tests/btrfs/group   |   1 +
>>  3 files changed, 199 insertions(+)
>>  create mode 100755 tests/btrfs/154
>>  create mode 100644 tests/btrfs/154.out
>>
>> diff --git a/tests/btrfs/154 b/tests/btrfs/154
>> new file mode 100755
>> index 000000000000..8b06fc4d9347
>> --- /dev/null
>> +++ b/tests/btrfs/154
>> @@ -0,0 +1,188 @@
>> +#! /bin/bash
>> +# FS QA Test 154
>> +#
>> +# Test for reappearing missing device functionality.
>> +#   This test will fail without the btrfs kernel patch
>> +#   [PATCH] btrfs: handle dynamically reappearing missing device
>> +#
>> +#---------------------------------------------------------------------
>> +# Copyright (c) 2017 Oracle.  All Rights Reserved.
>> +# Author: Anand Jain <anand.jain@oracle.com>
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#---------------------------------------------------------------------
>> +#
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1       # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +       cd /
>> +       rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/module
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_scratch_dev_pool 2
>> +_test_unmount
>> +_require_loadable_fs_module "btrfs"
>> +
>> +_scratch_dev_pool_get 2
>> +
>> +DEV1=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
>> +DEV2=`echo $SCRATCH_DEV_POOL | awk '{print $2}'`
>> +
>> +echo DEV1=$DEV1 >> $seqres.full
>> +echo DEV2=$DEV2 >> $seqres.full
>> +
>> +# Balance won't be successful if filled too much
>> +DEV1_SZ=`blockdev --getsize64 $DEV1`
>> +DEV2_SZ=`blockdev --getsize64 $DEV2`
>> +
>> +# get min
>> +MAX_FS_SZ=`echo -e "$DEV1_SZ\n$DEV2_SZ" | sort | head -1`
>> +# Need disks with more than 2G
>> +if [ $MAX_FS_SZ -lt 2000000000 ]; then
>> +       _scratch_dev_pool_put
>> +       _test_mount
>> +       _notrun "Smallest dev size $MAX_FS_SZ, Need at least 2G"
>> +fi
>> +
>> +MAX_FS_SZ=100000000
>> +bs="1M"
>> +COUNT=$(($MAX_FS_SZ / 1000000))
>> +CHECKPOINT1=0
>> +CHECKPOINT2=0
>> +
>> +setup()
>> +{
>> +       echo >> $seqres.full
>> +       echo "MAX_FS_SZ=$MAX_FS_SZ COUNT=$COUNT" >> $seqres.full
>> +       echo "setup"
>> +       echo "-----setup-----" >> $seqres.full
>> +       _scratch_pool_mkfs "-mraid1 -draid1" >> $seqres.full 2>&1
>> +       _scratch_mount >> $seqres.full 2>&1
>> +       dd if=/dev/urandom of="$SCRATCH_MNT"/tf bs=$bs count=1 \
>> +                                       >>$seqres.full 2>&1
>> +       _run_btrfs_util_prog filesystem show -m ${SCRATCH_MNT}
>> +       _run_btrfs_util_prog filesystem df $SCRATCH_MNT
>> +       COUNT=$(( $COUNT - 1 ))
>> +       echo "unmount" >> $seqres.full
>> +       _scratch_unmount
>> +}
>> +
>> +degrade_mount_write()
>> +{
>> +       echo >> $seqres.full
>> +       echo "--degraded mount: max_fs_sz $max_fs_sz bytes--" >> $seqres.full
>> +       echo
>> +       echo "degraded mount"
>> +
>> +       echo "clean btrfs ko" >> $seqres.full
>> +       # un-scan the btrfs devices
>> +       _reload_fs_module "btrfs"
>> +       _mount -o degraded $DEV1 $SCRATCH_MNT >>$seqres.full 2>&1
>> +       cnt=$(( $COUNT/10 ))
>> +       dd if=/dev/urandom of="$SCRATCH_MNT"/tf1 bs=$bs count=$cnt \
>> +                                       >>$seqres.full 2>&1
>> +       COUNT=$(( $COUNT - $cnt ))
>> +       _run_btrfs_util_prog filesystem show -m $SCRATCH_MNT
>> +       _run_btrfs_util_prog filesystem df $SCRATCH_MNT
>> +       CHECKPOINT1=`md5sum $SCRATCH_MNT/tf1`
>> +       echo $SCRATCH_MNT/tf1:$CHECKPOINT1 >> $seqres.full 2>&1
>> +}
>> +
>> +scan_missing_dev_and_write()
>> +{
>> +       echo >> $seqres.full
>> +       echo "--scan missing $DEV2--" >> $seqres.full
>> +       echo
>> +       echo "scan missing dev and write"
>> +
>> +       _run_btrfs_util_prog device scan $DEV2
>> +
>> +       echo >> $seqres.full
>> +
>> +       _run_btrfs_util_prog filesystem show -m ${SCRATCH_MNT}
>> +       _run_btrfs_util_prog filesystem df ${SCRATCH_MNT}
>> +
>> +       dd if=/dev/urandom of="$SCRATCH_MNT"/tf2 bs=$bs count=$COUNT \
>> +                                               >>$seqres.full 2>&1
>> +       CHECKPOINT2=`md5sum $SCRATCH_MNT/tf2`
>> +       echo $SCRATCH_MNT/tf2:$CHECKPOINT2 >> $seqres.full 2>&1
>> +}
>> +
>> +balance_convert()
>> +{
>> +       echo >> $seqres.full
>> +       echo "----- run balance -----" >> $seqres.full
>> +       echo
>> +       echo "run balance"
>> +
>> +       _run_btrfs_util_prog bal start --full-balance -dconvert=raid1 \
>> +                               -mconvert=raid1 ${SCRATCH_MNT}
>> +}
>> +
>> +verify()
>> +{
>> +       echo >> $seqres.full
>> +       echo "--mount reconstructed dev only and check md5sum--" >> $seqres.full
>> +       echo
>> +       echo "mount reconstructed dev only and check md5sum"
>> +       echo "unmount" >> $seqres.full
>> +
>> +       _scratch_unmount
>> +       _reload_fs_module "btrfs"
>> +       _mount -o degraded $DEV2 $SCRATCH_MNT >>$seqres.full 2>&1
>> +       verify_checkpoint1=`md5sum $SCRATCH_MNT/tf1`
>> +       verify_checkpoint2=`md5sum $SCRATCH_MNT/tf2`
>> +
>> +       if [ "$verify_checkpoint1" != "$CHECKPOINT1" ]; then
>> +               echo "checkpoint1 does not match with after scrub"
>> +       fi
>> +
>> +       if [ "$verify_checkpoint2" != "$CHECKPOINT2" ]; then
>> +               echo "checkpoint2 does not match with after scrub"
>> +       fi
>> +}
>> +
>> +setup
>> +degrade_mount_write
>> +scan_missing_dev_and_write
>> +balance_convert
>> +verify
>> +
>> +$UMOUNT_PROG $DEV2
>> +_scratch_dev_pool_put
>> +_test_mount
>> +
>> +status=0
>> +exit
>> diff --git a/tests/btrfs/154.out b/tests/btrfs/154.out
>> new file mode 100644
>> index 000000000000..4a4939d448aa
>> --- /dev/null
>> +++ b/tests/btrfs/154.out
>> @@ -0,0 +1,10 @@
>> +QA output created by 154
>> +setup
>> +
>> +degraded mount
>> +
>> +scan missing dev and write
>> +
>> +run balance
>> +
>> +mount reconstructed dev only and check md5sum
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index 15c2ecbf553c..c98cf823224e 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -156,3 +156,4 @@
>>  151 auto quick
>>  152 auto quick metadata qgroup send
>>  153 auto quick qgroup
>> +154 auto quick
>> --
>> 2.13.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
