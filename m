Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:33294 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482AbbIUNhV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Sep 2015 09:37:21 -0400
Received: by iofh134 with SMTP id h134so119424212iof.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 06:37:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAL3q7H5o-gprcTGz5hNGdvoQNR7h55+tOsiM9CK27fA_61_7KQ@mail.gmail.com>
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
	<CAL3q7H5o-gprcTGz5hNGdvoQNR7h55+tOsiM9CK27fA_61_7KQ@mail.gmail.com>
Date: Mon, 21 Sep 2015 14:37:20 +0100
Message-ID: <CAL3q7H5tRcjTP3DUVMOs2vZVP_wwFJZJ_Fc2G=4mDC0Cro_qpg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
From: Filipe David Manana <fdmanana@gmail.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 21, 2015 at 2:27 PM, Filipe David Manana <fdmanana@gmail.com> wrote:
> On Mon, Sep 21, 2015 at 1:59 PM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
>> btrfs in v4.3-rc1 failed many xfstests items with '-o nospace_cache'
>> mount option.
>>
>> Failed cases are:
>>  btrfs/008,016,019,020,026,027,028,029,031,041,046,048,050,051,053,054,
>>  077,083,084,087,092,094
>
> Hi Zhao,
>
> So far I tried a few of those against Chris' integration-4.3 branch
> (same btrfs code as 4.3-rc1):
>
> MOUNT_OPTIONS="-o nospace_cache" ./check btrfs/008 btrfs/016 btrfs/019 btrfs/020
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 debian3 4.2.0-rc5-btrfs-next-12+
> MKFS_OPTIONS  -- /dev/sdc
> MOUNT_OPTIONS -- -o nospace_cache /dev/sdc /home/fdmanana/btrfs-tests/scratch_1
>
> btrfs/008 2s ... 1s
> btrfs/016 4s ... 3s
> btrfs/019 4s ... 2s
> btrfs/020 2s ... 1s
> Ran: btrfs/008 btrfs/016 btrfs/019 btrfs/020
> Passed all 4 tests
>
> And none of the tests failed...
>
>>  generic/004,010,014,023,024,074,075,080,086,087,089,091,092,100,112,123,
>>  124,125,126,127,131,133,192,193,198,207,208,209,213,214,215,228,239,240,
>>  246,247,248,255,263,285,306,313,316,323
>>
>> We can reproduce this bug with following simple command:
>>  TEST_DEV=/dev/vdh
>>  TEST_DIR=/mnt/tmp
>>
>>  umount "$TEST_DEV" >/dev/null
>>  mkfs.btrfs -f "$TEST_DEV"
>>  mount "$TEST_DEV" "$TEST_DIR"
>>
>>  umount "$TEST_DEV"
>>  mount "$TEST_DEV" "$TEST_DIR"
>>
>>  cp /bin/bash $TEST_DIR
>>
>> Result is:
>>  (omit previous commands)
>>  # cp /bin/bash $TEST_DIR
>>  cp: writing `/mnt/tmp/bash': No space left on device
>>
>> By bisect, we can see it is triggered by patch titled:
>>  commit e44163e17796
>>  ("btrfs: explictly delete unused block groups in close_ctree and ro-remount")
>>
>> But the wrong code is not in above patch, btrfs delete all chunks
>> if no data in filesystem, and above patch just make it obviously.
>>
>> Detail reason:
>>  1: mkfs a blank filesystem, or delete everything in filesystem
>>  2: umount fs
>>     (current code will delete all data chunks)
>>  3: mount fs
>>     Because no any data chunks, data's space_cache have no chance
>>     to init, it means: space_info->total_bytes == 0, and
>>     space_info->full == 1.
>
> Right, and that's the problem. When the space_info is initialized it
> should never be flagged as full, otherwise any buffered write attempts
> fail immediately with enospc instead of trying to allocate a data
> block group (at extent-tree.c:btrfs_check_data_free_space()).
>
> That was fixed recently by:
>
> https://patchwork.kernel.org/patch/7133451/
>
> (with a respective test too, https://patchwork.kernel.org/patch/7133471/)
>
>>  4: do some write
>>     Current code will ignore chunk allocate because space_info->full,
>>     and return -ENOSPC.
>>
>> Fix:
>>  Don't auto-delete last blockgroup for a raid type.
>>  If we delete all blockgroup for a raidtype, it not only cause above bug,
>>  but also may change filesystem to all-single in some case.
>
> I don't get this. Can you mention in which cases that happens and why
> (in the commit message)?
>
> It isn't clear when reading the patch why we need to keep at least one
> block of each type/profile, and seems to be a workaround for a
> different problem.

Plus it would be a bad fix for such a problem, as anyone can still
trigger deletion of the last block group via a balance operation (like
in the test at https://patchwork.kernel.org/patch/7133471/), i.e.,
preventing deletion by the cleaner kthread is not enough to guarantee
the last block group of a kind isn't deleted...

>
> thanks
>
>>
>> Test:
>>  Test by above script, and confirmed the logic by debug output.
>>
>> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> ---
>>  fs/btrfs/extent-tree.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 5411f0a..35cf7eb 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -10012,7 +10012,8 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>>                                                bg_list);
>>                 space_info = block_group->space_info;
>>                 list_del_init(&block_group->bg_list);
>> -               if (ret || btrfs_mixed_space_info(space_info)) {
>> +               if (ret || btrfs_mixed_space_info(space_info) ||
>> +                   block_group->list.next == block_group->list.prev) {
>>                         btrfs_put_block_group(block_group);
>>                         continue;
>>                 }
>> --
>> 1.8.5.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
