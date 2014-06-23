Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:41567 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaFWXgJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 19:36:09 -0400
Received: by mail-ig0-f177.google.com with SMTP id c1so3659448igq.10
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 16:36:09 -0700 (PDT)
Message-ID: <53A8B9E7.7060206@gmail.com>
Date: Mon, 23 Jun 2014 18:36:07 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: [PATCH] handle start_unlink_transaction the same for an exceded quota
 , limit as an out of space error.
References: <53A62E89.6040900@gmail.com> <53A7069E.5010003@fb.com>	<53A718CE.9030701@gmail.com> <pan$d6c28$7dab67c8$466f1e49$ff456a63@cox.net>
In-Reply-To: <pan$d6c28$7dab67c8$466f1e49$ff456a63@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ec8766..41209e8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3751,10 +3751,10 @@ static struct btrfs_trans_handle
*__unlink_start_trans(struct inode *dir)
    * 1 for the inode
    */
   trans = btrfs_start_transaction(root, 5);
-  if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
+  if (!IS_ERR(trans) || (PTR_ERR(trans) != -ENOSPC && PTR_ERR(trans) !=
-EDQUOT))
      return trans;
.
-  if (PTR_ERR(trans) == -ENOSPC) {
+  if (PTR_ERR(trans) == -ENOSPC || PTR_ERR(trans) == -EDQUOT) {
      u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
.
      trans = btrfs_start_transaction(root, 0);
--.
2.0.0

On 06/22/2014 08:53 PM, Duncan wrote:
> Kevin Brandstatter posted on Sun, 22 Jun 2014 12:56:30 -0500 as excerpted:
>
>> One thing i note is that I can unlink from a full filesystem.
>> I tested it by writing a file until the device ran out of space, and
>> then rm it, the same method that i used to cause the disk quota error,
>> and it was able to remove without issue.
> It's worth noting that due to the btrfs separation between data and 
> metadata and the fact that btrfs space allocation happens in two steps 
> but it can only automatically free one of them (with a rebalance normally 
> used to deal with the other), there's three different kinds of "full 
> filesystem", (1) "all space chunk allocated", which isn't yet /entirely/ 
> full but means a significant loss of flexibility in filling up the rest, 
> (2) "all space chunk-allocated and metadata space ran out of room first 
> but there's still room in the data chunks", which is what happens most of 
> the time in normal usage, and (3) "all space chunk-allocated and data 
> space ran out first but there's still room in the metadata chunks", which 
> can produce decidedly non-intuitive behavior for people used to standard 
> filesystem behavior.
>
> Data/metadata chunk allocation is only one-way.  Once a chunk is 
> allocated to one or the other, the system cannot (yet) reallocate chunks 
> of one type to the other without a rebalance, so once all previously 
> unallocated space is allocated to either data or metadata chunks, it's 
> only a matter of time until one or the other runs out.
>
> In normal usage with a significant amount of file deletion, the spread 
> between data chunk allocation and actual usage tends to get rather large, 
> because file deletion normally frees much more data space than it does 
> metadata.  As such, the most common out-of-space condition is all 
> unallocated space gone, with most of the still actually unused space 
> allocated to data and thus not available to be used for metadata, such 
> that metadata space runs out first.
>
> When metadata space runs out, normal df will likely still report a decent 
> amount of space remaining, but btrfs filesystem df combined with btrfs 
> filesystem show will reveal that it's all locked up in data chunks -- a 
> big spread, often multiple gigabytes between data used and total (which 
> given the 1 GiB data chunk size means multiple data chunks could be 
> freed), a much smaller spread between metadata used and total (the system 
> reserves some metadata space, typically 200-ish MiB, so it should never 
> show as entirely gone, even when it's triggering ENOSPC).
>
> But due to COW, even file deletion requires available metadata space in 
> ordered to create the new/modified copy of the (normally 4-16 KiB 
> depending on mkfs.btrfs age and parameters supplied) metadata block, and 
> if there's no metadata space left and no more unallocated space to 
> allocate, ENOSPC even on file deletion!
>
> OTOH, in use-cases where there is little file deletion, the spread 
> between data chunk total and data chunk used tends to be much smaller, 
> and it can happen that there's still free metadata chunk space when the 
> last free data space is used and another data chunk needs allocated, but 
> there's no more unallocated space to allocate.  Of course btrfs 
> filesystem df (to see how allocated space is used) in combination with 
> btrfs filesystem show (to see whether all space is allocated) should tell 
> the story, in this case, reporting all or nearly all data space used but 
> a larger gap (> 200 MiB) between metadata total and used.
>
> This triggers a much more interesting and non-intuitive failure mode.  In 
> particular, because there's still metadata space available, attempts to 
> create a new file will succeed, but actually putting significant content 
> in that file will fail, often resulting in the creation of zero-length 
> files that won't accept data!  However, because btrfs stores very small 
> files (generally something under 16 MiB, the precise size depends on 
> filesystem parameters) entirely within metadata without actually 
> allocating a data extent for them, attempts to copy small enough files 
> will generally succeed as well -- as long as they're small enough to fit 
> in metadata only and not require a data allocation.
>
> Now I don't deal with quotas here and thus haven't looked into how quotas 
> account for metadata in particular, but it's worth noting that your 
> "write a file until there's no more space" test could well have triggered 
> the latter, all space chunk-allocated and data filled up first, 
> condition.  If that's the case, deleting a file wouldn't be a problem 
> because there's metadata space still available to record the deletion.  
> As I said above, another characteristic would be that attempts to create 
> new files and fill them with data (> 16 MiB at a time) would result in 
> zero-length files, as there's metadata space available to create them, 
> but no data space available to fill them.
>
> So your test may have been testing an *ENTIRELY* different failure 
> condition!
>

