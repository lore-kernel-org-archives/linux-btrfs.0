Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9298AC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 17:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E6A620651
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 17:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbfCSR56 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 13:57:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:40344 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727388AbfCSR56 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 13:57:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 105E7AC3A
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 17:57:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 18C79DAC36; Tue, 19 Mar 2019 18:59:10 +0100 (CET)
Date:   Tue, 19 Mar 2019 18:59:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: reloc: Fix NULL pointer dereference due to
 expanded reloc_root lifespan
Message-ID: <20190319175909.GN3516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190318024819.18716-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318024819.18716-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 18, 2019 at 10:48:19AM +0800, Qu Wenruo wrote:
> Commit 514e70150b60 ("btrfs: relocation: Delay reloc tree deletion after
> merge_reloc_roots()") expands the life span of root->reloc_root.

Commit 514e70150b60 does not exist in linus.git, by the subject it's
d2311e69857815a .

> This breaks certain check on fs_info->reloc_ctl.
> Before that commit, if we have a root with valid reloc_root, then it's
> ensured to have fs_info->reloc_ctl.
> 
> But now since reloc_root doesn't always mean a valid fs_info->reloc_ctl,
> such check is unreliable and can cause the following NULL pointer
> dereference:
> BUG: unable to handle kernel NULL pointer dereference at 00000000000005c1
> IP: btrfs_reloc_pre_snapshot+0x20/0x50 [btrfs]
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> CPU: 0 PID: 10379 Comm: snapperd Not tainted 4.12.14-lp150.12.53-default #1 openSUSE Leap 15.0

This is probably a backport to 4.12, the patch that caused that has been
merged to master recently. I wonder if this can also be triggered on
unpatched mainline, ie. if we're missing a test for that.

I'll fix the commit and add it to misc-next, thanks.

Reviewed-by: David Sterba <dsterba@suse.com>

> Call Trace:
>  create_pending_snapshot+0xd7/0xfc0 [btrfs]
>  create_pending_snapshots+0x8e/0xb0 [btrfs]
>  btrfs_commit_transaction+0x2ac/0x8f0 [btrfs]
>  btrfs_mksubvol+0x561/0x570 [btrfs]
>  btrfs_ioctl_snap_create_transid+0x189/0x190 [btrfs]
>  btrfs_ioctl_snap_create_v2+0x102/0x150 [btrfs]
>  btrfs_ioctl+0x5c9/0x1e60 [btrfs]
>  do_vfs_ioctl+0x90/0x5f0
>  SyS_ioctl+0x74/0x80
>  do_syscall_64+0x7b/0x150
>  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> RIP: 0033:0x7fd7cdab8467
> 
> Fix it by explicitly checking fs_info->reloc_ctl other than using the
> implied root->reloc_root.
> 
> Fixes: 514e70150b60 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots()")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/relocation.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index ddf028509931..351fa506dc9b 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4667,14 +4667,12 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
>  void btrfs_reloc_pre_snapshot(struct btrfs_pending_snapshot *pending,
>  			      u64 *bytes_to_reserve)
>  {
> -	struct btrfs_root *root;
> -	struct reloc_control *rc;
> +	struct btrfs_root *root = pending->root;
> +	struct reloc_control *rc = root->fs_info->reloc_ctl;
>  
> -	root = pending->root;
> -	if (!root->reloc_root)
> +	if (!root->reloc_root || !rc)
>  		return;
>  
> -	rc = root->fs_info->reloc_ctl;
>  	if (!rc->merge_reloc_tree)
>  		return;
>  
> @@ -4703,10 +4701,10 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
>  	struct btrfs_root *root = pending->root;
>  	struct btrfs_root *reloc_root;
>  	struct btrfs_root *new_root;
> -	struct reloc_control *rc;
> +	struct reloc_control *rc = root->fs_info->reloc_ctl;
>  	int ret;
>  
> -	if (!root->reloc_root)
> +	if (!root->reloc_root || !rc)
>  		return 0;
>  
>  	rc = root->fs_info->reloc_ctl;
> -- 
> 2.21.0
