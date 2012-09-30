Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34086 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab2I3B2q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Sep 2012 21:28:46 -0400
Received: by lbon3 with SMTP id n3so3096086lbo.19
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Sep 2012 18:28:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120929162140.GI14582@twin.jikos.cz>
References: <CANW9uyu_-DFmggZUyAc1OOd0knMxEp-O3GPcs_8ZsoXAxm0DZg@mail.gmail.com>
	<20120929162140.GI14582@twin.jikos.cz>
Date: Sun, 30 Sep 2012 10:28:44 +0900
Message-ID: <CANW9uys+9BHixw-sG3xbH5AyaOCFYW_o5XyAgBTiioczygcsfg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: shrink_delalloc check bdi write congested
From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resubmit this after the checkpatch test.

In srhink_delalloc(), writeback starts if idle, also check the bdi is
not write congested.
The patch is against the head of the btrfs-next.

Signed-off-by: Itaru Kitayama <kitayama@cl.bb4.ne.jp>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index efb044e..1aae046 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3712,8 +3712,9 @@ static void shrink_delalloc(struct btrfs_root
*root, u64 to_reclaim, u64 orig,
        while (delalloc_bytes && loops < 3) {
                max_reclaim = min(delalloc_bytes, to_reclaim);
                nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
-               writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages,
-                                              WB_REASON_FS_FREE_SPACE);
+               if (!bdi_write_congested(root->fs_info->sb->s_bdi))
+                       writeback_inodes_sb_nr_if_idle(root->fs_info, nr_page,
+                                                      WB_REASON_FS_FREE_SPACE);

                /*
                 * We need to wait for the async pages to actually start before


On Sun, Sep 30, 2012 at 1:21 AM, David Sterba <dave@jikos.cz> wrote:
> On Sat, Sep 29, 2012 at 10:20:09PM +0900, Itaru Kitayama wrote:
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -3712,7 +3712,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 t
>>         while (delalloc_bytes && loops < 3) {
>>                 max_reclaim = min(delalloc_bytes, to_reclaim);
>>                 nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
>> -               writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages,
>> +               if (!bdi_write_congested(root->fs_info->sb->s_bdi)) writeback_in
>>                                                WB_REASON_FS_FREE_SPACE);
>
> malformed patch
