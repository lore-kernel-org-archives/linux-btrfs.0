Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFA2C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 14:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46DE720855
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 14:59:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="V+kwyVWB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfAQO7C (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 09:59:02 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:37348 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbfAQO7A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 09:59:00 -0500
Received: by mail-yb1-f195.google.com with SMTP id 2so3097697ybw.4
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 06:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vorGbBJJfj3uQCLAUVbzqnvDIqdjdJQtxejJRNcP3yI=;
        b=V+kwyVWBTrEb2y0/h1JL5rFK+wms5K6tTERF3aurgHglL7DzhpSlu5fRtAf0+AfCMB
         Snq3mK+xNLOdy7YDGiW0Rmh4rFfkftW0ZbPQOkLEKfA+8kUL3OpWXcfMiHHqAWoemskc
         qHK03zG+AnrWtBmA1LM/Kwarav4XOB24X8gz1RkHGVCqIkfERh9nQmldqVnnHjCNBek7
         OaKM7Rnd1JWsG74vycezMH8PA0+C+ZXE4AaJn39df8WBKbpBgj6lWnuHj03cOR2yClGJ
         ZIE3TwW+MolawqepAiSW9JX3dB6ZYU1CgBj+vzxfTFR+A5teRNIHaxuoe5rsdhdq+aFB
         7SXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vorGbBJJfj3uQCLAUVbzqnvDIqdjdJQtxejJRNcP3yI=;
        b=IXHWmnaAH9upc1U2k8qtewdJdSvUG3b8ZVkon7dJhmp3NkcesASWIKnt2dI92xWU7c
         SNdbNqdSlUKgIaRIuywfNeWE5bZZXA3rLmSjWG1PpubyNeaGu+3jThSIz2h8kzTlzQFF
         eSlT6WFhl61ZSfiJyKYf+I862I6U0IrfJxHKPREZGM6M9dM18oZX3UA0K3UQ3aICL8bf
         gGgVv8DgLiOkqlyO/+Uif1AMIR27o8cnUNTY1uuyhwf8g6RTtIgDRnNw8DwvnCxBkj0r
         nKw85H4cmr/1G7VwOy+Gojoa10R3NwOk1GkeJjee6l2dhqGPRSuLnrnXyphmL7+1ZjCq
         nVnQ==
X-Gm-Message-State: AJcUukcgmx/ro+Cjh1Hwzqz8K4H7nrQITMty4svKNhBSnO3HfYcAa81X
        FJq8/3Y7qrNGG+Ov6YGH5jaaGA==
X-Google-Smtp-Source: ALg8bN4SLXRTTLI9swv3FGJlt3nGpkUqMSMuZjgr8Vbe8oWUpwY/hRvzX/plKcTJU5MeWtl4g/kBpQ==
X-Received: by 2002:a25:dfc4:: with SMTP id w187mr2183906ybg.231.1547737139772;
        Thu, 17 Jan 2019 06:58:59 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:ec74])
        by smtp.gmail.com with ESMTPSA id e194sm782876ywa.85.2019.01.17.06.58.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 06:58:59 -0800 (PST)
Date:   Thu, 17 Jan 2019 09:58:59 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     David Sterba <dsterba@suse.cz>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 5/7] btrfs: just delete pending bgs if we are aborted
Message-ID: <20190117145858.wit2r2ffwyumk4oc@macbook-pro-91.dhcp.thefacebook.com>
References: <20181121190545.24798-1-josef@toxicpanda.com>
 <20181121190545.24798-6-josef@toxicpanda.com>
 <20190116145920.GO2900@twin.jikos.cz>
 <20190116152255.GP2900@twin.jikos.cz>
 <20190117145632.GS2900@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117145632.GS2900@twin.jikos.cz>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 17, 2019 at 03:56:32PM +0100, David Sterba wrote:
> On Wed, Jan 16, 2019 at 04:22:55PM +0100, David Sterba wrote:
> > On Wed, Jan 16, 2019 at 03:59:20PM +0100, David Sterba wrote:
> > > On Wed, Nov 21, 2018 at 02:05:43PM -0500, Josef Bacik wrote:
> > > > We still need to do all of the accounting cleanup for pending block
> > > > groups if we abort.  So set the ret to trans->aborted so if we aborted
> > > > the cleanup happens and everybody is happy.
> > > > 
> > > > Reviewed-by: Omar Sandoval <osandov@fb.com>
> > > > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > > > ---
> > > >  fs/btrfs/extent-tree.c | 8 +++++++-
> > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > > > index b9b829c8825c..90423b6749b7 100644
> > > > --- a/fs/btrfs/extent-tree.c
> > > > +++ b/fs/btrfs/extent-tree.c
> > > > @@ -10500,11 +10500,17 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
> > > >  	struct btrfs_root *extent_root = fs_info->extent_root;
> > > >  	struct btrfs_block_group_item item;
> > > >  	struct btrfs_key key;
> > > > -	int ret = 0;
> > > > +	int ret;
> > > >  
> > > >  	if (!trans->can_flush_pending_bgs)
> > > >  		return;
> > > >  
> > > > +	/*
> > > > +	 * If we aborted the transaction with pending bg's we need to just
> > > > +	 * cleanup the list and carry on.
> > > > +	 */
> > > > +	ret = trans->aborted;
> > > 
> > > The cleanup is suitable for a separate helper that does only
> > > 
> > > while (!list_empty(&trans->new_bgs)) {
> > > 	list_del_init(&block_group->bg_list);
> > > 	btrfs_delayed_refs_rsv_release(fs_info, 1);
> > > }
> > > 
> > > and does not rely on the transaction->abort in a function with 'create'
> > > in it's name.
> > > 
> > > The related part is in a separate patch that ab-uses the fact that
> > > setting ->abort will trigger the cleanup.
> > > 
> > > https://patchwork.kernel.org/patch/10693081/ will then simply call the
> > > halper instead of
> > > 
> > > +	/* This cleans up the pending block groups list properly. */
> > > +	if (!trans->aborted)
> > > +		trans->aborted = ret;
> > > +	btrfs_create_pending_block_groups(trans);
> > > 
> > > Setting aborted to an error code anywhere else than
> > > __btrfs_abort_transaction does not sound right as it misses the whole
> > > report.
> > 
> > Like this:
> > 
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -1901,6 +1901,20 @@ static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
> >                 btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
> >  }
> > 
> > +static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
> > +{
> > +       struct btrfs_fs_info *fs_info = trans->fs_info;
> > +       struct btrfs_block_group_cache *block_group;
> > +
> > +       while (!list_empty(&trans->new_bgs)) {
> > +               block_group = list_first_entry(&trans->new_bgs,
> > +                                              struct btrfs_block_group_cache,
> > +                                              bg_list);
> > +               btrfs_delayed_refs_rsv_release(fs_info, 1);
> > +               list_del_init(&block_group->bg_list);
> > +       }
> > +}
> > +
> >  int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
> >  {
> >         struct btrfs_fs_info *fs_info = trans->fs_info;
> > @@ -2270,6 +2284,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
> >         btrfs_scrub_continue(fs_info);
> >  cleanup_transaction:
> >         btrfs_trans_release_metadata(trans);
> > +       btrfs_cleanup_pending_block_groups(trans);
> >         btrfs_trans_release_chunk_metadata(trans);
> >         trans->block_rsv = NULL;
> >         btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
> > ---
> > 
> > The call to btrfs_trans_release_chunk_metadata is not duplicated now as it
> > would happen twice in you version (within btrfs_create_pending_block_groups and
> > in transaction commit).
> 
> FYI, this passed the 475 test (with accounting warnings that are
> possibly fixed by the other patches) + no blowups in the following
> tests.

I'm fine with it if you want to throw it in there.  I'm still trying to get my
fix for the balance thing through xfstests.  Thanks,

Josef
