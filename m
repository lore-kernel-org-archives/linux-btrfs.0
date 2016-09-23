Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:37142 "EHLO
        smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030211AbcIWNn0 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 23 Sep 2016 09:43:26 -0400
Subject: Re: [PATCH] qgroup: Prevent qgroup->reserved from going subzero
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org
References: <1474570050-4715-1-git-send-email-rgoldwyn@suse.de>
 <a5707357-38d1-f2c3-41cf-b9d76bd992a3@cn.fujitsu.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Message-ID: <628e1dcd-ddc3-3f37-8a47-c01c912db970@suse.com>
Date: Fri, 23 Sep 2016 08:43:19 -0500
MIME-Version: 1.0
In-Reply-To: <a5707357-38d1-f2c3-41cf-b9d76bd992a3@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/22/2016 08:06 PM, Qu Wenruo wrote:
> 
> 
> At 09/23/2016 02:47 AM, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> While free'ing qgroup->reserved resources, we must check
>> if the page is already commmitted to disk or still in memory.
>> If not, the reserve free is doubly accounted, once while
>> invalidating the page, and the next time while free'ing
>> delalloc. This results is qgroup->reserved(u64) going subzero,
>> thus very large value. So, no further I/O can be performed.
>>
>> This is also expressed in the comments, but not performed.
>>
>> Testcase:
>> SCRATCH_DEV=/dev/vdb
>> SCRATCH_MNT=/mnt
>> mkfs.btrfs -f $SCRATCH_DEV
>> mount -t btrfs $SCRATCH_DEV $SCRATCH_MNT
>> cd $SCRATCH_MNT
>> btrfs quota enable $SCRATCH_MNT
>> btrfs subvolume create a
>> btrfs qgroup limit 50m a $SCRATCH_MNT
>> sync
>> for c in {1..15}; do
>> dd if=/dev/zero  bs=1M count=40 of=$SCRATCH_MNT/a/file;
>> done
>>
>> sleep 10
>> sync
>> sleep 5
>>
>> touch $SCRATCH_MNT/a/newfile
>>
>> echo "Removing file"
>> rm $SCRATCH_MNT/a/file
>>
>> Fixes: b9d0b38928 ("btrfs: Add handler for invalidate page")
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>  fs/btrfs/inode.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index e6811c4..2e2a026 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -8917,7 +8917,8 @@ again:
>>       * 2) Not written to disk
>>       *    This means the reserved space should be freed here.
>>       */
>> -    btrfs_qgroup_free_data(inode, page_start, PAGE_SIZE);
>> +    if (PageDirty(page))
>> +        btrfs_qgroup_free_data(inode, page_start, PAGE_SIZE);
>>      if (!inode_evicting) {
>>          clear_extent_bit(tree, page_start, page_end,
>>                   EXTENT_LOCKED | EXTENT_DIRTY |
>>
> Thanks for the test case.
> 
> However for the fix, I'm afraid it may not be the root cause.
> 
> Here, if the pages are dirty, then corresponding range is marked
> EXTENT_QGROUP_RESERVED.
> Then btrfs_qgroup_free_data() will clear that bit and reduce the number.
> 
> If the pages are already committed, then corresponding range won't be
> marked EXTENT_QGROUP_RESERVED.
> Later btrfs_qgroup_free_data() won't reduce any bytes, since it will
> only reduce the bytes if it cleared EXTENT_QGROUP_RESERVED bit.
> 
> If everything goes well there is no need to check PageDirty() here, as
> we have EXTENT_QGROUP_RESERVED bit for that accounting.
> 
> So there is some other thing causing EXTENT_QGROUP_RESERVED bit out of
> sync with dirty pages.
> Considering you did it 15 times to reproduce the problem, maybe there is
> some race causing the problem?
> 

You can have pages marked as not dirty with EXTENT_QGROUP_RESERVED set
for a truncate operation. Performing dd on the same file, truncates the
file before overwriting, while the pages of the previous writes are
still in memory and not committed to disk.

truncate_inode_page() -> truncate_complete_page() clears the dirty flag.
So, you can have a case where the EXTENT_QGROUP_RESERVED bit is set
while the page is not listed as dirty because the truncate "cleared" all
the dirty pages.

-- 
Goldwyn
