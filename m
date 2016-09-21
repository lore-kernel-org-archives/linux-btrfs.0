Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46320 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936013AbcIUPi7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 11:38:59 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8F039AB9F
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 15:38:57 +0000 (UTC)
Date: Wed, 21 Sep 2016 17:36:58 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 4/5] btrfs: convert pr_* to btrfs_* where possible
Message-ID: <20160921153658.GK16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1474380303-25995-1-git-send-email-jeffm@suse.com>
 <1474380303-25995-5-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474380303-25995-5-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 10:05:02AM -0400, jeffm@suse.com wrote:
>  static struct btrfs_block_group_cache *
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 6fdc701..c9bb727 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2186,6 +2187,7 @@ void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end)
>  int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
>  		struct io_failure_record **failrec_ret)
>  {
> +	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);

I get a compiler warning:

fs/btrfs/extent_io.c: In function 'btrfs_get_io_failure_record':
fs/btrfs/extent_io.c:2191:24: warning: unused variable 'fs_info' [-Wunused-variable]

as btrfs_debug is compiled out. The following diff silences the warning for me:

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2188,7 +2188,7 @@ void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end)
 int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
                struct io_failure_record **failrec_ret)
 {
-       struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+       struct btrfs_fs_info *fs_info;
        struct io_failure_record *failrec;
        struct extent_map *em;
        struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
@@ -2197,6 +2197,8 @@ int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
        int ret;
        u64 logical;

+       fs_info = btrfs_sb(inode->i_sb);
+
        ret = get_state_failrec(failure_tree, start, &failrec);
        if (ret) {
                failrec = kzalloc(sizeof(*failrec), GFP_NOFS);
---

so to keep the build clean we might need to do some more tweaks. I'll look if I
can kill the warning quickly, the remaing are

fs/btrfs/send.c: In function 'send_rename':
fs/btrfs/send.c:726:24: warning: unused variable 'fs_info' [-Wunused-variable]
fs/btrfs/send.c: In function 'send_link':
fs/btrfs/send.c:751:24: warning: unused variable 'fs_info' [-Wunused-variable]
fs/btrfs/send.c: In function 'send_unlink':
fs/btrfs/send.c:775:24: warning: unused variable 'fs_info' [-Wunused-variable]
fs/btrfs/send.c: In function 'send_rmdir':
fs/btrfs/send.c:798:24: warning: unused variable 'fs_info' [-Wunused-variable]
fs/btrfs/send.c: In function 'send_truncate':
fs/btrfs/send.c:2425:24: warning: unused variable 'fs_info' [-Wunused-variable]
fs/btrfs/send.c: In function 'send_chmod':
fs/btrfs/send.c:2455:24: warning: unused variable 'fs_info' [-Wunused-variable]
fs/btrfs/send.c: In function 'send_chown':
fs/btrfs/send.c:2485:24: warning: unused variable 'fs_info' [-Wunused-variable]
fs/btrfs/send.c: In function 'send_utimes':
fs/btrfs/send.c:2517:24: warning: unused variable 'fs_info' [-Wunused-variable]
fs/btrfs/send.c: In function 'send_create_inode':
fs/btrfs/send.c:2580:24: warning: unused variable 'fs_info' [-Wunused-variable]
fs/btrfs/send.c: In function 'process_recorded_refs':
fs/btrfs/send.c:3646:24: warning: unused variable 'fs_info' [-Wunused-variable]
fs/btrfs/send.c: In function 'send_write':
fs/btrfs/send.c:4669:24: warning: unused variable 'fs_info' [-Wunused-variable]
