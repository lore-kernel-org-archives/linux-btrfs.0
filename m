Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B38C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 14:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69462205C9
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 14:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393758AbfAPO7v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 09:59:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:47878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728675AbfAPO7v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 09:59:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1D288AC8A;
        Wed, 16 Jan 2019 14:59:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D675DDA828; Wed, 16 Jan 2019 15:59:20 +0100 (CET)
Date:   Wed, 16 Jan 2019 15:59:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 5/7] btrfs: just delete pending bgs if we are aborted
Message-ID: <20190116145920.GO2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20181121190545.24798-1-josef@toxicpanda.com>
 <20181121190545.24798-6-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121190545.24798-6-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 02:05:43PM -0500, Josef Bacik wrote:
> We still need to do all of the accounting cleanup for pending block
> groups if we abort.  So set the ret to trans->aborted so if we aborted
> the cleanup happens and everybody is happy.
> 
> Reviewed-by: Omar Sandoval <osandov@fb.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index b9b829c8825c..90423b6749b7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10500,11 +10500,17 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
>  	struct btrfs_root *extent_root = fs_info->extent_root;
>  	struct btrfs_block_group_item item;
>  	struct btrfs_key key;
> -	int ret = 0;
> +	int ret;
>  
>  	if (!trans->can_flush_pending_bgs)
>  		return;
>  
> +	/*
> +	 * If we aborted the transaction with pending bg's we need to just
> +	 * cleanup the list and carry on.
> +	 */
> +	ret = trans->aborted;

The cleanup is suitable for a separate helper that does only

while (!list_empty(&trans->new_bgs)) {
	list_del_init(&block_group->bg_list);
	btrfs_delayed_refs_rsv_release(fs_info, 1);
}

and does not rely on the transaction->abort in a function with 'create'
in it's name.

The related part is in a separate patch that ab-uses the fact that
setting ->abort will trigger the cleanup.

https://patchwork.kernel.org/patch/10693081/ will then simply call the
halper instead of

+	/* This cleans up the pending block groups list properly. */
+	if (!trans->aborted)
+		trans->aborted = ret;
+	btrfs_create_pending_block_groups(trans);

Setting aborted to an error code anywhere else than
__btrfs_abort_transaction does not sound right as it misses the whole
report.
