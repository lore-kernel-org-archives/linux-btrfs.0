Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB59DC282CD
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 19:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A87E421741
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 19:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbfA1Tfj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 14:35:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:34996 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726862AbfA1Tfj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 14:35:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6048FAD70;
        Mon, 28 Jan 2019 19:35:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6D46DDA78C; Mon, 28 Jan 2019 20:35:02 +0100 (CET)
Date:   Mon, 28 Jan 2019 20:35:01 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] btrfs: clean up pending block groups when transaction
 commit aborts
Message-ID: <20190128193501.GK2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20190128164550.17826-1-dsterba@suse.com>
 <dc40cb8e-e557-21cc-9e17-67849e7521c9@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc40cb8e-e557-21cc-9e17-67849e7521c9@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 06:57:41PM +0200, Nikolay Borisov wrote:
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
> 
> This is much cleaner and understandable, thanks.
> 
> nit:Can't we use list_for_each_entry_safe though and save the explicit
> list_first_entry. IMO this is fine here since the transaction is aborted
> hence no new pending bgs can be added to the ->new_bgs list. In any case:

@@ -1898,12 +1898,9 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
 static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
 {
        struct btrfs_fs_info *fs_info = trans->fs_info;
-       struct btrfs_block_group_cache *block_group;
+       struct btrfs_block_group_cache *block_group, *tmp;

-       while (!list_empty(&trans->new_bgs)) {
-               block_group = list_first_entry(&trans->new_bgs,
-                                              struct btrfs_block_group_cache,
-                                              bg_list);
+       list_for_each_entry_safe(block_group, tmp, &trans->new_bgs, bg_list) {
                btrfs_delayed_refs_rsv_release(fs_info, 1);
                list_del_init(&block_group->bg_list);

Looks better than the version I copied from create_pending_bgs, the
transaction is going to be freed soon so there should be no new entries,
indeed.
