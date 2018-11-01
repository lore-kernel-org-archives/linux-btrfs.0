Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F62AC0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 10:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4B192081B
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 10:22:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="Wi5WYmY4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4B192081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=synology.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbeKATYT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 15:24:19 -0400
Received: from synology.com ([59.124.61.242]:60077 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbeKATYT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 15:24:19 -0400
Received: from _ (localhost [127.0.0.1])
        by synology.com (Postfix) with ESMTPA id E304A24E73C8;
        Thu,  1 Nov 2018 18:21:56 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1541067717; bh=FGzSVDX1SjsMPx2u/FSOiqpWLidJlW1pxIXEOywf+ZE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=Wi5WYmY4ta1Sjg14kcOgGoy52Gdl+2eNlmWLKGEwnjYgP0Fq9xwtK7K2+UB3HDiCA
         D0IGBqKzcYNv7uBdUlG2hbFcNGd8uu2+5B988hUITJ9gH9GoLzu7On+c2Eqftcw6Zo
         N5a/mzWnfxQYLfhU3MN9YlDKhgeLhtaLDZVI7oAU=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 01 Nov 2018 18:21:56 +0800
From:   ethanlien <ethanlien@synology.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH] btrfs: use tagged writepage to mitigate livelock of
 snapshot
In-Reply-To: <5ebd95dc-f684-baef-494d-1a40760e6157@suse.com>
References: <20181101064903.11638-1-ethanlien@synology.com>
 <2e566c40-f61e-6cea-42ba-c0c3fa3b9d76@suse.com>
 <33824f7912f4d590d2425ef0ecebd039@synology.com>
 <5ebd95dc-f684-baef-494d-1a40760e6157@suse.com>
Message-ID: <6404da122f4d63c5dfa6b6c256114b28@synology.com>
X-Sender: ethanlien@synology.com
User-Agent: Roundcube Webmail/1.1.2
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Nikolay Borisov 於 2018-11-01 18:01 寫到:
> On 1.11.18 г. 11:56 ч., ethanlien wrote:
>> Nikolay Borisov 於 2018-11-01 16:59 寫到:
>>> On 1.11.18 г. 8:49 ч., Ethan Lien wrote:
>>>> Snapshot is expected to be fast. But if there are writers steadily
>>>> create dirty pages in our subvolume, the snapshot may take a very 
>>>> long
>>>> time to complete. To fix the problem, we use tagged writepage for
>>>> snapshot
>>>> flusher as we do in the generic write_cache_pages(), so we can ommit
>>>> pages
>>>> dirtied after the snapshot command.
>>> 
>>> So the gist of this commit really is that you detect when 
>>> filemap_flush
>>> has been called from snapshot context and tag all pages at *that* 
>>> time
>>> as PAGECACHE_TAG_TOWRITE and then write them, ignoring any pages that
>>> might have been dirtied beforehand. Your description kind of dances
>>> around this idea without really saying it explicitly. Those semantics
>>> make sense, however i'd like to be stated more explicitly in the 
>>> change
>>>  log.
>>> 
>>> However, this is done at the expense of consistency, so we have 
>>> faster
>>> snapshots but depending the file which are stored in them they might 
>>> be
>>> broken (i.e a database) since they will be missing pages.
>>> 
>> 
>> tag_pages_for_writeback() will tag all pages with PAGECACHE_TAG_DIRTY.
>> If a dirty
>> page get missed here, it means someone has initiated the flush before
>> us, so we
>> will wait that dirty page to complete in create_snapshot() ->
>> btrfs_wait_ordered_extents().
> 
> And what happens in the scenario where you have  someone dirtying 
> pages,
> you issue the snapshot ioctl, mark all currently dirtied pages as
> TOWRITE and then you have more delalloc pages being dirtied following
> initial call to tag_pages_for_writeback , you will miss those, no ?
> 

We don't freeze the filesystem when doing snapshot, so there is no 
guarantee
the page dirtied right after we send the ioctl, will be included in 
snapshot.
If a page is dirtied while we scan the dirty pages and its offset is 
before our
current index, we miss it in our current snapshot implementation too.

>> 
>>>> 
>>>> We do a simple snapshot speed test on a Intel D-1531 box:
>>>> 
>>>> fio --ioengine=libaio --iodepth=32 --bs=4k --rw=write --size=64G
>>>> --direct=0 --thread=1 --numjobs=1 --time_based --runtime=120
>>>> --filename=/mnt/sub/testfile --name=job1 --group_reporting & sleep 
>>>> 5;
>>>> time btrfs sub snap -r /mnt/sub /mnt/snap; killall fio
>>>> 
>>>> original: 1m58sec
>>>> patched:  6.54sec
>>> 
>>> Nice.
>>> 
>>>> 
>>>> This is the best case for this patch since for a sequential write 
>>>> case,
>>>> we omit nearly all pages dirtied after the snapshot command.
>>>> 
>>>> For a multi writers, random write test:
>>>> 
>>>> fio --ioengine=libaio --iodepth=32 --bs=4k --rw=randwrite --size=64G
>>>> --direct=0 --thread=1 --numjobs=4 --time_based --runtime=120
>>>> --filename=/mnt/sub/testfile --name=job1 --group_reporting & sleep 
>>>> 5;
>>>> time btrfs sub snap -r /mnt/sub /mnt/snap; killall fio
>>>> 
>>>> original: 15.83sec
>>>> patched:  10.35sec
>>>> 
>>>> The improvement is less compared with the sequential write case, 
>>>> since
>>>> we omit only half of the pages dirtied after snapshot command.
>>>> 
>>>> Signed-off-by: Ethan Lien <ethanlien@synology.com>
>>>> ---
>>>>  fs/btrfs/btrfs_inode.h |  1 +
>>>>  fs/btrfs/ctree.h       |  2 +-
>>>>  fs/btrfs/extent_io.c   | 16 ++++++++++++++--
>>>>  fs/btrfs/inode.c       | 10 ++++++----
>>>>  fs/btrfs/ioctl.c       |  2 +-
>>>>  5 files changed, 23 insertions(+), 8 deletions(-)
>>>> 
>>>> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
>>>> index 1343ac57b438..4182bfbb56be 100644
>>>> --- a/fs/btrfs/btrfs_inode.h
>>>> +++ b/fs/btrfs/btrfs_inode.h
>>>> @@ -29,6 +29,7 @@ enum {
>>>>      BTRFS_INODE_IN_DELALLOC_LIST,
>>>>      BTRFS_INODE_READDIO_NEED_LOCK,
>>>>      BTRFS_INODE_HAS_PROPS,
>>>> +    BTRFS_INODE_TAGGED_FLUSH,
>>> 
>>> IMO the name of the flag should be different. Something like "lie 
>>> flush"
> 
> I meant "lite flush" or "strict flush" or something like that, alluding
> to the fact we are restricting the set of pages being flushed.
> 
>>> or whatever. Because all flushes are tagged i.e TAG_DIRTY or 
>>> TAG_TOWRITE.
>>> 
>> 
>> OK I'll use another name.
>> 
>>>>  };
>>>> 
>>>>  /* in memory btrfs inode */
>>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>>> index 2cddfe7806a4..82682da5a40d 100644
>>>> --- a/fs/btrfs/ctree.h
>>>> +++ b/fs/btrfs/ctree.h
>>>> @@ -3155,7 +3155,7 @@ int btrfs_truncate_inode_items(struct
>>>> btrfs_trans_handle *trans,
>>>>                     struct inode *inode, u64 new_size,
>>>>                     u32 min_type);
>>>> 
>>>> -int btrfs_start_delalloc_inodes(struct btrfs_root *root);
>>>> +int btrfs_start_delalloc_snapshot(struct btrfs_root *root);
>>>>  int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int 
>>>> nr);
>>>>  int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 
>>>> end,
>>>>                    unsigned int extra_bits,
>>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>>> index 4dd6faab02bb..c21d8a0e010a 100644
>>>> --- a/fs/btrfs/extent_io.c
>>>> +++ b/fs/btrfs/extent_io.c
>>>> @@ -3928,12 +3928,24 @@ static int extent_write_cache_pages(struct
>>>> address_space *mapping,
>>>>              range_whole = 1;
>>>>          scanned = 1;
>>>>      }
>>>> -    if (wbc->sync_mode == WB_SYNC_ALL)
>>>> +
>>>> +    /*
>>>> +     * We don't care if we are the one who set
>>>> BTRFS_INODE_TAGGED_FLUSH in
>>>> +     * start_delalloc_inodes(). We do the tagged writepage as long
>>>> as we are
>>>> +     * the first one who do the filemap_flush() on this inode.
>>>> +     */
>>> 
>>> I think the first sentence of this comment could be removed.
>>> 
>> 
>> OK.
>> 
>>>> +    if (range_whole && wbc->nr_to_write == LONG_MAX &&
>>>> +            wbc->sync_mode == WB_SYNC_NONE &&
>>>> +            test_and_clear_bit(BTRFS_INODE_TAGGED_FLUSH,
>>>> +                &BTRFS_I(inode)->runtime_flags))
>>>> +        wbc->tagged_writepages = 1;
>>>> +
>>>> +    if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
>>>>          tag = PAGECACHE_TAG_TOWRITE;
>>>>      else
>>>>          tag = PAGECACHE_TAG_DIRTY;
>>>>  retry:
>>>> -    if (wbc->sync_mode == WB_SYNC_ALL)
>>>> +    if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
>>>>          tag_pages_for_writeback(mapping, index, end);
>>>>      done_index = index;
>>>>      while (!done && !nr_to_write_done && (index <= end) &&
>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>> index 3ea5339603cf..3df3cbbe91c5 100644
>>>> --- a/fs/btrfs/inode.c
>>>> +++ b/fs/btrfs/inode.c
>>>> @@ -9975,7 +9975,7 @@ static struct btrfs_delalloc_work
>>>> *btrfs_alloc_delalloc_work(struct inode *inode
>>>>   * some fairly slow code that needs optimization. This walks the 
>>>> list
>>>>   * of all the inodes with pending delalloc and forces them to disk.
>>>>   */
>>>> -static int start_delalloc_inodes(struct btrfs_root *root, int nr)
>>>> +static int start_delalloc_inodes(struct btrfs_root *root, int nr,
>>>> int snapshot)
>>> 
>>> snapshot is a boolean value, so define it as such and not an int. I 
>>> know
>>> the codebase is inconsistent in that manner but long-term all boolean
>>> 'int's shall be converted to bools.
>>> 
>> 
>> OK i'll use boolean here.
>> 
>>>>  {
>>>>      struct btrfs_inode *binode;
>>>>      struct inode *inode;
>>>> @@ -10003,6 +10003,8 @@ static int start_delalloc_inodes(struct
>>>> btrfs_root *root, int nr)
>>>>          }
>>>>          spin_unlock(&root->delalloc_lock);
>>>> 
>>>> +        if (snapshot)
>>>> +            set_bit(BTRFS_INODE_TAGGED_FLUSH, 
>>>> &binode->runtime_flags);
>>>>          work = btrfs_alloc_delalloc_work(inode);
>>>>          if (!work) {
>>>>              iput(inode);
>>>> @@ -10036,7 +10038,7 @@ static int start_delalloc_inodes(struct
>>>> btrfs_root *root, int nr)
>>>>      return ret;
>>>>  }
>>>> 
>>>> -int btrfs_start_delalloc_inodes(struct btrfs_root *root)
>>>> +int btrfs_start_delalloc_snapshot(struct btrfs_root *root)
>>>>  {
>>>>      struct btrfs_fs_info *fs_info = root->fs_info;
>>>>      int ret;
>>>> @@ -10044,7 +10046,7 @@ int btrfs_start_delalloc_inodes(struct
>>>> btrfs_root *root)
>>>>      if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
>>>>          return -EROFS;
>>>> 
>>>> -    ret = start_delalloc_inodes(root, -1);
>>>> +    ret = start_delalloc_inodes(root, -1, 1);
>>>>      if (ret > 0)
>>>>          ret = 0;
>>>>      return ret;
>>>> @@ -10073,7 +10075,7 @@ int btrfs_start_delalloc_roots(struct
>>>> btrfs_fs_info *fs_info, int nr)
>>>>                     &fs_info->delalloc_roots);
>>>>          spin_unlock(&fs_info->delalloc_root_lock);
>>>> 
>>>> -        ret = start_delalloc_inodes(root, nr);
>>>> +        ret = start_delalloc_inodes(root, nr, 0);
>>>>          btrfs_put_fs_root(root);
>>>>          if (ret < 0)
>>>>              goto out;
>>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>>> index d60b6caf09e8..d1293b6c31f6 100644
>>>> --- a/fs/btrfs/ioctl.c
>>>> +++ b/fs/btrfs/ioctl.c
>>>> @@ -775,7 +775,7 @@ static int create_snapshot(struct btrfs_root
>>>> *root, struct inode *dir,
>>>>      wait_event(root->subv_writers->wait,
>>>>             percpu_counter_sum(&root->subv_writers->counter) == 0);
>>>> 
>>>> -    ret = btrfs_start_delalloc_inodes(root);
>>>> +    ret = btrfs_start_delalloc_snapshot(root);
>>>>      if (ret)
>>>>          goto dec_and_free;
>>>> 
>>>> 
>> 
>> 

