Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44092 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2I3CLL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Sep 2012 22:11:11 -0400
Received: by lbon3 with SMTP id n3so3107575lbo.19
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Sep 2012 19:11:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANW9uys+9BHixw-sG3xbH5AyaOCFYW_o5XyAgBTiioczygcsfg@mail.gmail.com>
References: <CANW9uyu_-DFmggZUyAc1OOd0knMxEp-O3GPcs_8ZsoXAxm0DZg@mail.gmail.com>
	<20120929162140.GI14582@twin.jikos.cz>
	<CANW9uys+9BHixw-sG3xbH5AyaOCFYW_o5XyAgBTiioczygcsfg@mail.gmail.com>
Date: Sun, 30 Sep 2012 11:11:10 +0900
Message-ID: <CANW9uytWQ2DmpkAEg+Q=ZOenqdhe=NiRL9=Yq-7-Y6QVXQRFLQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: shrink_delalloc check bdi write congested
From: Itaru Kitayama <itaru.kitayama@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the correct one.

Signed-off-by: Itaru Kitayama <kitayama@cl.bb4.ne.jp>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index efb044e..c032dbe 100644
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
+                       writeback_inodes_sb_nr_if_idle(root->fs_info, nr_pages,
+                                                      WB_REASON_FS_FREE_SPACE);

                /*
                 * We need to wait for the async pages to actually start before


On Sun, Sep 30, 2012 at 10:28 AM, Itaru Kitayama <kitayama@cl.bb4u.ne.jp> wrote:
> Resubmit this after the checkpatch test.
>
> In srhink_delalloc(), writeback starts if idle, also check the bdi is
> not write congested.
> The patch is against the head of the btrfs-next.
>
> Signed-off-by: Itaru Kitayama <kitayama@cl.bb4.ne.jp>
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index efb044e..1aae046 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3712,8 +3712,9 @@ static void shrink_delalloc(struct btrfs_root
> *root, u64 to_reclaim, u64 orig,
>         while (delalloc_bytes && loops < 3) {
>                 max_reclaim = min(delalloc_bytes, to_reclaim);
>                 nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
> -               writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages,
> -                                              WB_REASON_FS_FREE_SPACE);
> +               if (!bdi_write_congested(root->fs_info->sb->s_bdi))
> +                       writeback_inodes_sb_nr_if_idle(root->fs_info, nr_page,
> +                                                      WB_REASON_FS_FREE_SPACE);
>
>                 /*
>                  * We need to wait for the async pages to actually start before
>
>
> On Sun, Sep 30, 2012 at 1:21 AM, David Sterba <dave@jikos.cz> wrote:
>> On Sat, Sep 29, 2012 at 10:20:09PM +0900, Itaru Kitayama wrote:
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -3712,7 +3712,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 t
>>>         while (delalloc_bytes && loops < 3) {
>>>                 max_reclaim = min(delalloc_bytes, to_reclaim);
>>>                 nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
>>> -               writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages,
>>> +               if (!bdi_write_congested(root->fs_info->sb->s_bdi)) writeback_in
>>>                                                WB_REASON_FS_FREE_SPACE);
>>
>> malformed patch
