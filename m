Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751964AbeCZNYu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 09:24:50 -0400
Subject: Re: [PATCH 2/2] btrfs-progs: Add test for collision DIR_ITEM handling
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1521816494-22947-1-git-send-email-nborisov@suse.com>
 <1521816494-22947-2-git-send-email-nborisov@suse.com>
 <617236e1-acc0-33b7-8697-a29036296829@gmx.com>
Cc: David Sterba <dsterba@suse.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <558444ee-efb6-e0c6-ecd0-10776b06106d@suse.com>
Date: Mon, 26 Mar 2018 16:24:47 +0300
MIME-Version: 1.0
In-Reply-To: <617236e1-acc0-33b7-8697-a29036296829@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.03.2018 14:44, Qu Wenruo wrote:
> 
> 
> On 2018年03月23日 22:48, Nikolay Borisov wrote:
>> Verify that if we have an otherwise clean filesystem, containging collided 
>> DIR_ITEM, btrfs check lowmem's mode can correctly handle those and not produce
>> any false positives. 
>>
>> This if fixed by commit titled:
>>
>>  "btrfs-progs: Fix DIR_ITEM checking in lowmem" 
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Looks pretty good.
> 
> However a nitpick inlined below.
> 
>> ---
>>  .../031-lowmem-collission-dir-items/test.sh        | 27 ++++++++++++++++++++++
>>  1 file changed, 27 insertions(+)
>>  create mode 100755 tests/fsck-tests/031-lowmem-collission-dir-items/test.sh
>>
>> diff --git a/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh b/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh
>> new file mode 100755
>> index 0000000..8a01889
>> --- /dev/null
>> +++ b/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh
>> @@ -0,0 +1,27 @@
>> +#!/bin/bash
>> +# Ensure that running btrfs check in lowmem mode on a fs
>> +# which contains DIR_ITEM with collissions handles it
>> +# properly
>> +source "$TEST_TOP/common"
>> +
>> +check_prereq btrfs
>> +check_prereq mkfs.btrfs
>> +
>> +setup_root_helper
>> +prepare_test_dev
>> +
>> +run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
>> +run_check_mount_test_dev
>> +
>> +# Create 2 files whose names collide
>> +
>> +run_check $SUDO_HELPER touch "$TEST_MNT/5ab4e206~~~~~~~~XVT1U3ZF647YS2PD4AKAG826"
>> +run_check $SUDO_HELPER touch "$TEST_MNT/5ab4e26a~~~~~~~~AP1C3VQBE79IJOTVOEZIR9YU"
>> +
>> +run_check_umount_test_dev
>> +
>> +# The fs is clean so lowmem shouldn't produce any warnings
>> +run_check "$TOP/btrfs" check --mode=lowmem --readonly "$TEST_DEV"
> 
> I understand this is a pinpoint test case for lowmem mode, but for
> lowmem mode test, we set TEST_ENABLE_OVERRIDE and the whole test case
> will use lowmem mode.

So how exactly is this argument supposed to be used. I tried:

TEST_ENABLE_OVERRIDE=true TEST=031\* ./fsck-tests.sh  - no --lowmem is
appended

I modify the TEST_ENABLE_OVERRIDE=false to TEST_ENABLE_OVERRIDE=true in
common.local and then just run TEST=031\* ./fsck-tests.sh and it works.

TEST_ENABLE_OVERRIDE=true TEST_ARGS_CHECK=--mode=lowmem TEST=031\*
./fsck-tests.sh - this also works?


I'm not entirely sure what the ci config is but at this point I'm
beginning to worry that if I omit the explicit --mode option this test
might never be run in lowmem mode.

The whole TEST_ENABLE_OVERRIDE situation seems a bit finicky.

> 
> So it doesn't seem necessary to explicitly call lowmem check here.
> Just normal run_check "$TOP/btrfs" check would be enough.
> (And this will also test original mode)
> 
>> +if [ $? -ne 0 ]; then
>> +	_fail "check --lowmem doesn't handle collissioned DIR_ITEMs correctly"
>> +fi
>>
> IIRC run_check() will check the return value and exit if failure.
> So this seems not necessary.
> 
> Thanks,
> Qu
> 
