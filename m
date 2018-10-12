Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AFFC67872
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 16:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7FBF205F4
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 16:50:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7FBF205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbeJMAYN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 20:24:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:57894 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725902AbeJMAYN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 20:24:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C1A96AE85;
        Fri, 12 Oct 2018 16:50:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 376A3DA862; Fri, 12 Oct 2018 18:50:46 +0200 (CEST)
Date:   Fri, 12 Oct 2018 18:50:46 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     dsterba@suse.cz, kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/42] btrfs: check if free bgs for commit
Message-ID: <20181012165046.GV29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20180928111821.24376-1-josef@toxicpanda.com>
 <20180928111821.24376-8-josef@toxicpanda.com>
 <20181004112424.GC29418@twin.jikos.cz>
 <20181011183354.mxcpedy4dmbirgri@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011183354.mxcpedy4dmbirgri@destiny>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 02:33:55PM -0400, Josef Bacik wrote:
> On Thu, Oct 04, 2018 at 01:24:24PM +0200, David Sterba wrote:
> > On Fri, Sep 28, 2018 at 07:17:46AM -0400, Josef Bacik wrote:
> > > may_commit_transaction will skip committing the transaction if we don't
> > > have enough pinned space or if we're trying to find space for a SYSTEM
> > > chunk.  However if we have pending free block groups in this transaction
> > > we still want to commit as we may be able to allocate a chunk to make
> > > our reservation.  So instead of just returning ENOSPC, check if we have
> > > free block groups pending, and if so commit the transaction to allow us
> > > to use that free space.
> > > 
> > > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > > Reviewed-by: Omar Sandoval <osandov@fb.com>
> > > ---
> > >  fs/btrfs/extent-tree.c | 33 +++++++++++++++++++--------------
> > >  1 file changed, 19 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > > index 1213f573eea2..da73b3e5bc39 100644
> > > --- a/fs/btrfs/extent-tree.c
> > > +++ b/fs/btrfs/extent-tree.c
> > > @@ -4830,10 +4830,18 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
> > >  	if (!bytes)
> > >  		return 0;
> > >  
> > > -	/* See if there is enough pinned space to make this reservation */
> > > -	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
> > > -				   bytes,
> > > -				   BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
> > > +	trans = btrfs_join_transaction(fs_info->extent_root);
> > > +	if (IS_ERR(trans))
> > > +		return -ENOSPC;
> > 
> > Why do you set override the error to ENOSPC, instead of passing
> > PTR_ERR(trans)? There are more reasons why btrfs_join_transaction could
> > fail: EROFS after error, EDQUOT when quotas say no, ENOMEM from
> > ulist_add, that's just a sample I quickly found.
> 
> (argh I hit r instead of g, sending again)
> 
> Because may_commit_transaction is only called during flushing, we don't actually
> care about the value, just that it failed.  Thanks,

No, we do care about error values. If anything, here it's used in the
tracepoint as the reason why the flushing failed. Conflating them into
one without a good reason is a bad practice I don't want to let spread
in the code.
