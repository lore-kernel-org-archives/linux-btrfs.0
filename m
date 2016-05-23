Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34795 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750867AbcEWGGM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 May 2016 02:06:12 -0400
Subject: Re: [RFC PATCH] btrfs: correct inode's outstanding_extents
 computation
To: <fdmanana@gmail.com>
References: <1463654949-8295-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <CAL3q7H67C_6N8vBLs7uQ49aXNL6ek6hJ=C5-_8QG6geOS4U4gg@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57429DBC.80300@cn.fujitsu.com>
Date: Mon, 23 May 2016 14:05:48 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H67C_6N8vBLs7uQ49aXNL6ek6hJ=C5-_8QG6geOS4U4gg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 05/19/2016 07:01 PM, Filipe Manana wrote:
> On Thu, May 19, 2016 at 11:49 AM, Wang Xiaoguang
> <wangxg.fnst@cn.fujitsu.com> wrote:
>> This issue was revealed by modifing BTRFS_MAX_EXTENT_SIZE(128MB) to 64KB,
>> When modifing BTRFS_MAX_EXTENT_SIZE(128MB) to 64KB, fsstress test often gets
>> these warnings from btrfs_destroy_inode():
>>          WARN_ON(BTRFS_I(inode)->outstanding_extents);
>>          WARN_ON(BTRFS_I(inode)->reserved_extents);
>>
>> Simple test program below can reproduce this issue steadily.
>>          #include <string.h>
>>          #include <unistd.h>
>>          #include <sys/types.h>
>>          #include <sys/stat.h>
>>          #include <fcntl.h>
>>
>>          int main(void)
>>          {
>>                  int fd;
>>                  char buf[1024*1024];
>>
>>                  memset(buf, 0, 1024 * 1024);
>>                  fd = open("testfile", O_CREAT | O_EXCL | O_RDWR);
>>                  pwrite(fd, buf, 69954, 693581);
>>                  return;
>>          }
>>
>> Assume the BTRFS_MAX_EXTENT_SIZE is 64KB, and data range is:
>> 692224                                                                             765951
>> |----------------------------------------------------------------------------------|
>>                           len(73728)
>> 1) for the above data range, btrfs_delalloc_reserve_metadata() will reserve
>> metadata and BTRFS_I(inode)->outstanding_extents will be 2.
>> (73728 + 65535) / 65536 == 2
>>
>> 2) then btrfs_dirty_page() will be called to dirty pages and set EXTENT_DELALLOC
>> flag. In this case, btrfs_set_bit_hook will be called 3 times. For first call,
>> there will be such extent io map.
>> 692224                 696319 696320                                                765951
>> |----------------------|      |-----------------------------------------------------|
>>         len(4096)                                len(69632)
>>      have EXTENT_DELALLOC
>> and because of having EXTENT_FIRST_DELALLOC, btrfs_set_bit_hook() won't change
>> BTRFS_I(inode)->outstanding_extents, still be 2. see code logic in btrfs_set_bit_hook();
>>
>> 3) second btrfs_set_bit_hook() call.
>> Because of EXTENT_FIRST_DELALLOC have been unset by previous btrfs_set_bit_hook(),
>> btrfs_set_bit_hook will increase BTRFS_I(inode)->outstanding_extents by one, so now
>> BTRFS_I(inode)->outstanding_extents, sitll is 3. There will be such extent_io map:
>> 692224               696319 696320                761855 761856                     765951
>> |--------------------|      |---------------------|      |--------------------------|
>>      len(4096)                     len(65536)                     len(4096)
>>      have EXTENT_DELALLOC      have EXTENT_DELALLOC
>>
>> And because (692224, 696319) and (696320, 761855) is adjacent, btrfs_merge_extent_hook()
>> will merge them into one delalloc extent, but according to the compulation logic in
>> btrfs_merge_extent_hook(), BTRFS_I(inode)->outstanding_extents will still be 3.
>> After merge, tehre will bu such extent_io map:
>> 692224                                            761855 761856                     765951
>> |-------------------------------------------------|      |--------------------------|
>>                 len(69632)                                         len(4096)
>>            have EXTENT_DELALLOC
>>
>> 4) third btrfs_set_bit_hook() call.
>> Also because of EXTENT_FIRST_DELALLOC have not been set, btrfs_set_bit_hook will increase
>> BTRFS_I(inode)->outstanding_extents by one, so now BTRFS_I(inode)->outstanding_extents is 4.
>> The extent io map is:
>> 692224                                            761855 761856                     765951
>> |-------------------------------------------------|      |--------------------------|
>>                 len(69632)                                         len(4096)
>>            have EXTENT_DELALLOC                                have EXTENT_DELALLOC
>>
>> Also because (692224, 761855) and (761856, 765951) is adjacent, btrfs_merge_extent_hook()
>> will merge them into one delalloc extent, according to the compulation logic in
>> btrfs_merge_extent_hook(), BTRFS_I(inode)->outstanding_extents will decrease by one, be 3.
>> so after merge, tehre will bu such extent_io map:
>> 692224                                                                              765951
>> |-----------------------------------------------------------------------------------|
>>                                       len(73728)
>>                                 have EXTENT_DELALLOC
>>
>> But indeed for original data range(start:692224 end:765951 len:73728), we just should
>> have 2 outstanding extents, so it will trigger the above WARNINGs.
>>
>> The root casue is that btrfs_delalloc_reserve_metadata() will always add needed outstanding
>> extents first, and if later btrfs_set_extent_delalloc call multiple btrfs_set_bit_hook(),
>> it may wrongly update BTRFS_I(inode)->outstanding_extents, This patch choose to also add
>> BTRFS_I(inode)->outstanding_extents in btrfs_set_bit_hook() according to the data range length,
>> and the added value is the correct number of outstanding_extents for this data range, then
>> decrease the value which was added in btrfs_delalloc_reserve_metadata().
>>
>> As for why BTRFS_MAX_EXTENT_SIZE(128M) does not trigger above WARNINGs, this is because
>> __btrfs_buffered_write() internally have write limits for every iteration(it seems 2MB),
>> so btrfs_dirty_pages() will always make data range into one outstanding extent.
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> I haven't reviewed the code nor the the changelog, but from reading
> the test program and regardless of your fix, this should be trivial to
> test with xfs_io and make a test case for xfstests.
> So please write and submit a testcase for xfstests (taking into
> account the extent splitting happens at 128Mb of course).
Sorry, this WARNINGs was only triggered when I manually modify 
BTRFS_MAX_EXTENT_SIZE to
64 KB. For 128MB, because btrfs_dirty_pages() will not handle data range 
lager than
128MB, it will always be be involved in one outstanding extent, so the 
WARNINGs will
not happen. See that _btrfs_buffered_write has a write limitation for 
every iteration(it seems 2MB).

Also don't you think the outstanding_extents computation in current 
btrfs code is
not that nice. I think we should not do the 
"BTRFS_I(inode)->outstanding_extents++;"
operation at all, we should always add number of extents according to 
the data rang length:

     num_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1, + 
BTRFS_MAX_EXTENT_SIZE);
     spin_lock(&BTRFS_I(inode)->lock);
     BTRFS_I(inode)->outstanding_extents += num_extents;
     spin_unlock(&BTRFS_I(inode)->lock);

Also let me explain more why I modify BTRFS_MAX_EXTENT_SIZE to 64KB to 
have test.
When developing btrfs inband-dedupe feature, we often got ENOSPC error for
metadata reservation, it's because when a file goes through in-band dedupe,
its max extent size will be limited by in-band dedupe block size, so the 
compulation
method based on 128MB in btrfs_delalloc_reserve_metadata() is not 
correct, obviously
it should be based on in-band dedupe blocksize. So later I will also try 
to make
BTRFS_MAX_EXTENT_SIZE configurable.

Regards,
Xiaoguang Wang
> Thanks.
>
>> ---
>>   fs/btrfs/ctree.h |  2 ++
>>   fs/btrfs/inode.c | 47 ++++++++++++++++++++++++++++++++++++++++++-----
>>   fs/btrfs/ioctl.c |  5 ++---
>>   3 files changed, 46 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 84a6a5b..da9ee24 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -4072,6 +4072,8 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
>>                                 int nr);
>>   int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
>>                                struct extent_state **cached_state);
>> +int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
>> +                           struct extent_state **cached_state);
>>   int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
>>                               struct btrfs_root *new_root,
>>                               struct btrfs_root *parent_root,
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 41a5688..5144f45 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -1713,13 +1713,16 @@ static void btrfs_set_bit_hook(struct inode *inode,
>>          if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
>>                  struct btrfs_root *root = BTRFS_I(inode)->root;
>>                  u64 len = state->end + 1 - state->start;
>> +               u64 num_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
>> +                                           BTRFS_MAX_EXTENT_SIZE);
>>                  bool do_list = !btrfs_is_free_space_inode(inode);
>>
>> -               if (*bits & EXTENT_FIRST_DELALLOC) {
>> +               if (*bits & EXTENT_FIRST_DELALLOC)
>>                          *bits &= ~EXTENT_FIRST_DELALLOC;
>> -               } else {
>> +
>> +               if (root != root->fs_info->tree_root) {
>>                          spin_lock(&BTRFS_I(inode)->lock);
>> -                       BTRFS_I(inode)->outstanding_extents++;
>> +                       BTRFS_I(inode)->outstanding_extents += num_extents;
>>                          spin_unlock(&BTRFS_I(inode)->lock);
>>                  }
>>
>> @@ -1960,9 +1963,43 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
>>   int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
>>                                struct extent_state **cached_state)
>>   {
>> +       int ret;
>> +       struct btrfs_root *root = BTRFS_I(inode)->root;
>> +       u64 num_extents = div64_u64(end - start + BTRFS_MAX_EXTENT_SIZE,
>> +                                   BTRFS_MAX_EXTENT_SIZE);
>> +
>> +       WARN_ON((end & (PAGE_CACHE_SIZE - 1)) == 0);
>> +       ret = set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
>> +                                 cached_state, GFP_NOFS);
>> +
>> +       if (root != root->fs_info->tree_root) {
>> +               spin_lock(&BTRFS_I(inode)->lock);
>> +               BTRFS_I(inode)->outstanding_extents -= num_extents;
>> +               spin_unlock(&BTRFS_I(inode)->lock);
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>> +int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
>> +                           struct extent_state **cached_state)
>> +{
>> +       int ret;
>> +       struct btrfs_root *root = BTRFS_I(inode)->root;
>> +       u64 num_extents = div64_u64(end - start + BTRFS_MAX_EXTENT_SIZE,
>> +                                   BTRFS_MAX_EXTENT_SIZE);
>> +
>>          WARN_ON((end & (PAGE_CACHE_SIZE - 1)) == 0);
>> -       return set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
>> -                                  cached_state, GFP_NOFS);
>> +       ret = set_extent_defrag(&BTRFS_I(inode)->io_tree, start, end,
>> +                               cached_state, GFP_NOFS);
>> +
>> +       if (root != root->fs_info->tree_root) {
>> +               spin_lock(&BTRFS_I(inode)->lock);
>> +               BTRFS_I(inode)->outstanding_extents -= num_extents;
>> +               spin_unlock(&BTRFS_I(inode)->lock);
>> +       }
>> +
>> +       return ret;
>>   }
>>
>>   /* see btrfs_writepage_start_hook for details on why this is required */
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 21423dd..149d11e 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -1227,9 +1227,8 @@ again:
>>          }
>>
>>
>> -       set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
>> -                         &cached_state, GFP_NOFS);
>> -
>> +       btrfs_set_extent_defrag(inode, page_start,
>> +                               page_end - 1, &cached_state);
>>          unlock_extent_cached(&BTRFS_I(inode)->io_tree,
>>                               page_start, page_end - 1, &cached_state,
>>                               GFP_NOFS);
>> --
>> 1.8.3.1
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



