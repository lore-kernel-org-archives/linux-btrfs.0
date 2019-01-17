Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EE3C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 14:57:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 298D920851
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 14:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfAQO5F (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 09:57:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:33262 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726913AbfAQO5E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 09:57:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8421BAC1F;
        Thu, 17 Jan 2019 14:57:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 13FE7DA83D; Thu, 17 Jan 2019 15:56:32 +0100 (CET)
Date:   Thu, 17 Jan 2019 15:56:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 5/7] btrfs: just delete pending bgs if we are aborted
Message-ID: <20190117145632.GS2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20181121190545.24798-1-josef@toxicpanda.com>
 <20181121190545.24798-6-josef@toxicpanda.com>
 <20190116145920.GO2900@twin.jikos.cz>
 <20190116152255.GP2900@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116152255.GP2900@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 16, 2019 at 04:22:55PM +0100, David Sterba wrote:
> On Wed, Jan 16, 2019 at 03:59:20PM +0100, David Sterba wrote:
> > On Wed, Nov 21, 2018 at 02:05:43PM -0500, Josef Bacik wrote:
> > > We still need to do all of the accounting cleanup for pending block
> > > groups if we abort.  So set the ret to trans->aborted so if we aborted
> > > the cleanup happens and everybody is happy.
> > > 
> > > Reviewed-by: Omar Sandoval <osandov@fb.com>
> > > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > > ---
> > >  fs/btrfs/extent-tree.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > > index b9b829c8825c..90423b6749b7 100644
> > > --- a/fs/btrfs/extent-tree.c
> > > +++ b/fs/btrfs/extent-tree.c
> > > @@ -10500,11 +10500,17 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
> > >  	struct btrfs_root *extent_root = fs_info->extent_root;
> > >  	struct btrfs_block_group_item item;
> > >  	struct btrfs_key key;
> > > -	int ret = 0;
> > > +	int ret;
> > >  
> > >  	if (!trans->can_flush_pending_bgs)
> > >  		return;
> > >  
> > > +	/*
> > > +	 * If we aborted the transaction with pending bg's we need to just
> > > +	 * cleanup the list and carry on.
> > > +	 */
> > > +	ret = trans->aborted;
> > 
> > The cleanup is suitable for a separate helper that does only
> > 
> > while (!list_empty(&trans->new_bgs)) {
> > 	list_del_init(&block_group->bg_list);
> > 	btrfs_delayed_refs_rsv_release(fs_info, 1);
> > }
> > 
> > and does not rely on the transaction->abort in a function with 'create'
> > in it's name.
> > 
> > The related part is in a separate patch that ab-uses the fact that
> > setting ->abort will trigger the cleanup.
> > 
> > https://patchwork.kernel.org/patch/10693081/ will then simply call the
> > halper instead of
> > 
> > +	/* This cleans up the pending block groups list properly. */
> > +	if (!trans->aborted)
> > +		trans->aborted = ret;
> > +	btrfs_create_pending_block_groups(trans);
> > 
> > Setting aborted to an error code anywhere else than
> > __btrfs_abort_transaction does not sound right as it misses the whole
> > report.
> 
> Like this:
> 
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1901,6 +1901,20 @@ static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
>                 btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
>  }
> 
> +static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
> +{
> +       struct btrfs_fs_info *fs_info = trans->fs_info;
> +       struct btrfs_block_group_cache *block_group;
> +
> +       while (!list_empty(&trans->new_bgs)) {
> +               block_group = list_first_entry(&trans->new_bgs,
> +                                              struct btrfs_block_group_cache,
> +                                              bg_list);
> +               btrfs_delayed_refs_rsv_release(fs_info, 1);
> +               list_del_init(&block_group->bg_list);
> +       }
> +}
> +
>  int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  {
>         struct btrfs_fs_info *fs_info = trans->fs_info;
> @@ -2270,6 +2284,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>         btrfs_scrub_continue(fs_info);
>  cleanup_transaction:
>         btrfs_trans_release_metadata(trans);
> +       btrfs_cleanup_pending_block_groups(trans);
>         btrfs_trans_release_chunk_metadata(trans);
>         trans->block_rsv = NULL;
>         btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
> ---
> 
> The call to btrfs_trans_release_chunk_metadata is not duplicated now as it
> would happen twice in you version (within btrfs_create_pending_block_groups and
> in transaction commit).

FYI, this passed the 475 test (with accounting warnings that are
possibly fixed by the other patches) + no blowups in the following
tests.
