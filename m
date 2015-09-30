Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33691 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbbI3K0g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 06:26:36 -0400
Received: by igbkq10 with SMTP id kq10so101265428igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 03:26:35 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <010e01d0fb67$be055c50$3a1014f0$@cn.fujitsu.com>
References: <585889cfca0895674926445c0a8caa84f8fc6184.1443534660.git.zhaolei@cn.fujitsu.com>
	<CAL3q7H5To-_nEez_yKgLeGt-Ak4mXeSdqgAbSxDJ8cHKtwXFGQ@mail.gmail.com>
	<010e01d0fb67$be055c50$3a1014f0$@cn.fujitsu.com>
Date: Wed, 30 Sep 2015 11:26:35 +0100
Message-ID: <CAL3q7H6cPZ5C383ok6ay4i76qWLDsJrOupxLXKAMRiqjLXFiDw@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: Fix lost-data-profile caused by auto removing bg
From: Filipe Manana <fdmanana@gmail.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 30, 2015 at 11:06 AM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
> Hi, Filipe Manana
>
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org
>> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Filipe Manana
>> Sent: Wednesday, September 30, 2015 3:43 PM
>> To: Zhao Lei <zhaolei@cn.fujitsu.com>
>> Cc: linux-btrfs@vger.kernel.org
>> Subject: Re: [PATCH 1/2] btrfs: Fix lost-data-profile caused by auto removing bg
>>
>> On Tue, Sep 29, 2015 at 2:51 PM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
>> > Reproduce:
>> >  (In integration-4.3 branch)
>> >
>> >  TEST_DEV=(/dev/vdg /dev/vdh)
>> >  TEST_DIR=/mnt/tmp
>> >
>> >  umount "$TEST_DEV" >/dev/null
>> >  mkfs.btrfs -f -d raid1 "${TEST_DEV[@]}"
>> >
>> >  mount -o nospace_cache "$TEST_DEV" "$TEST_DIR"
>> >  umount "$TEST_DEV"
>> >
>> >  mount -o nospace_cache "$TEST_DEV" "$TEST_DIR"
>> >  btrfs filesystem usage $TEST_DIR
>> >
>> > We can see the data chunk changed from raid1 to single:
>> >  # btrfs filesystem usage $TEST_DIR
>> >  Data,single: Size:8.00MiB, Used:0.00B
>> >     /dev/vdg        8.00MiB
>> >  #
>> >
>> > Reason:
>> >  When a empty filesystem mount with -o nospace_cache, the last  data
>> > blockgroup will be auto-removed in umount.
>> >
>> >  Then if we mount it again, there is no data chunk in the  filesystem,
>> > so the only available data profile is 0x0, result  is all new chunks
>> > are created as single type.
>> >
>> > Fix:
>> >  Don't auto-delete last blockgroup for a raid type.
>> >
>> > Test:
>> >  Test by above script, and confirmed the logic by debug output.
>> >
>> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> > ---
>> >  fs/btrfs/extent-tree.c | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c index
>> > 79a5bd9..3505649 100644
>> > --- a/fs/btrfs/extent-tree.c
>> > +++ b/fs/btrfs/extent-tree.c
>> > @@ -10012,7 +10012,8 @@ void btrfs_delete_unused_bgs(struct
>> btrfs_fs_info *fs_info)
>> >                                                bg_list);
>> >                 space_info = block_group->space_info;
>> >                 list_del_init(&block_group->bg_list);
>> > -               if (ret || btrfs_mixed_space_info(space_info)) {
>> > +               if (ret || btrfs_mixed_space_info(space_info) ||
>> > +                   block_group->list.next == block_group->list.prev)
>> > + {
>>
>> This isn't race free. The list block_group->list is protected by the groups_sem
>> semaphore. Need to take before doing this check.
>
> Thanks for pointing out this.
>
>> You can do that in the "if" statement below this one, where we're holding
>> &space_info->groups_sem [1]
>>
> It is hard to do check in btrfs_remove_block_group(), because it is common
> function used by both balance and auto-remove bg.

I didn't say to move it to or touch btrfs_remove_block_group() at all.
What I meant is to do check still inside btrfs_delete_unused_bgs but
in the other "if" statement that is done while holding the groups
semaphore, i.e.:

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9f96042..627ac3b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10022,7 +10022,8 @@ void btrfs_delete_unused_bgs(struct
btrfs_fs_info *fs_info)
                spin_lock(&block_group->lock);
                if (block_group->reserved ||
                    btrfs_block_group_used(&block_group->item) ||
-                   block_group->ro) {
+                   block_group->ro ||
+                   lock_group->list.next == block_group->list.prev) {
                        /*
                         * We want to bail if we made new allocations or have
                         * outstanding allocations in this block group.  We do


>
> For balance operation, we can remove lattest bg in some case, or we need
> add additional argument to separate these two operation(complex).
>
> So I decided to take groups_sem semaphore in place of checking.

Not sure I follow. The problem I was pointing is doing the check
without holding the groups semaphore.

> Thanks for notice this lock problem.
>
> btw, could I add your signed-off-by or reviewed-by in patch 2/2?

Yeah, once I see the updated version I can add a reviewed-by tag.

thanks

>
> Thanks
> Zhaolei
>
>> thanks
>>
>> [1]
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/exte
>> nt-tree.c?id=refs/tags/v4.3-rc3#n10021
>>
>> >                         btrfs_put_block_group(block_group);
>> >                         continue;
>> >                 }
>> > --
>> > 1.8.5.1
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>> > in the body of a message to majordomo@vger.kernel.org More majordomo
>> > info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Filipe David Manana,
>>
>> "Reasonable men adapt themselves to the world.
>>  Unreasonable men adapt the world to themselves.
>>  That's why all progress depends on unreasonable men."
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body
>> of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
