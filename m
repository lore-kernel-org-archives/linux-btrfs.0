Return-Path: <SRS0=Zefw=B7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C538C433DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Aug 2020 10:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7973420732
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Aug 2020 10:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgHUKXG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Aug 2020 06:23:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:55536 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgHUKXG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Aug 2020 06:23:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3FA2BB5E2;
        Fri, 21 Aug 2020 10:23:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 48C9FDA730; Fri, 21 Aug 2020 12:21:58 +0200 (CEST)
Date:   Fri, 21 Aug 2020 12:21:58 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: check the right variable in
 btrfs_del_dir_entries_in_log
Message-ID: <20200821102158.GD2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
References: <20200810213116.795789-1-josef@toxicpanda.com>
 <20200819162236.GS2026@twin.jikos.cz>
 <CAL3q7H4Rge7qSVgPokXHPVw6q246wKVn8aWixp8NzXitLPekhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H4Rge7qSVgPokXHPVw6q246wKVn8aWixp8NzXitLPekhw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 20, 2020 at 11:29:11AM +0100, Filipe Manana wrote:
> On Wed, Aug 19, 2020 at 5:25 PM David Sterba <dsterba@suse.cz> wrote:
> >
> > On Mon, Aug 10, 2020 at 05:31:16PM -0400, Josef Bacik wrote:
> > > With my new locking code dbench is so much faster that I tripped over a
> > > transaction abort from ENOSPC.  This turned out to be because
> > > btrfs_del_dir_entries_in_log was checking for ret == -ENOSPC, but this
> > > function sets err on error, and returns err.  So instead of properly
> > > marking the inode as needing a full commit, we were returning -ENOSPC
> > > and aborting in __btrfs_unlink_inode.  Fix this by checking the proper
> > > variable so that we return the correct thing in the case of ENOSPC.
> > >
> > > Fixes: 4a500fd178c8 ("Btrfs: Metadata ENOSPC handling for tree log")
> > > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> >
> > Added to misc-next, with updated changelog and comment explaining the
> > ENOENT.
> 
> Looking at the part added to the changelog:
> 
> "The ENOENT needs to be checked, because btrfs_lookup_dir_item() can
> return -ENOENT if the dir item isn't in the tree log (which would happen
> if we hadn't fsync'ed this guy).  We actually handle that case in
> __btrfs_unlink_inode, so it's an expected error to get back."
> 
> btrfs_lookup_dir_item() returns NULL when the dir item does not exist
> in the log.
> What can return -ENOENT is btrfs_lookup_dir_index_item(), which we
> call right after calling btrfs_lookup_dir_item().
> The fact that one returns NULL and the other returns -ENOENT is what
> made me question why the special handling for -ENOENT.
> 
> Other than the wrong function name, it looks good to me.

Function name updated in the patch, thanks.
