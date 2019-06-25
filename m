Return-Path: <SRS0=RfiN=UY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C9B5C48BD5
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Jun 2019 18:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 157112086D
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Jun 2019 18:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbfFYSY3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Jun 2019 14:24:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:44540 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727070AbfFYSY3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jun 2019 14:24:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0F014ACB4;
        Tue, 25 Jun 2019 18:24:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 53FE7DA8F6; Tue, 25 Jun 2019 20:25:12 +0200 (CEST)
Date:   Tue, 25 Jun 2019 20:25:11 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/8] btrfs: cleanup the target logic in
 __btrfs_block_rsv_release
Message-ID: <20190625182511.GX8917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20190619174724.1675-1-josef@toxicpanda.com>
 <20190619174724.1675-5-josef@toxicpanda.com>
 <3e9708a2-7316-08a4-6cb3-d81842e9b2ab@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e9708a2-7316-08a4-6cb3-d81842e9b2ab@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jun 20, 2019 at 11:23:36AM +0300, Nikolay Borisov wrote:
> 
> 
> On 19.06.19 г. 20:47 ч., Josef Bacik wrote:
> > This works for all callers already, but if we wanted to use the helper
> > for the global_block_rsv it would end up trying to refill itself.  Fix
> > the logic to be able to be used no matter which block rsv is passed in
> > to this helper.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/btrfs/extent-tree.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index d6aff56337aa..6995edf887e1 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -4684,12 +4684,20 @@ u64 __btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
> >  {
> >  	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
> >  	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_refs_rsv;
> > -	struct btrfs_block_rsv *target = delayed_rsv;
> > +	struct btrfs_block_rsv *target = NULL;
> >  
> > -	if (target->full || target == block_rsv)
> > +	/*
> > +	 * If we are the delayed_rsv then push to the global rsv, otherwise dump
> > +	 * into the delayed rsv if it is not full.
> > +	 */
> > +	if (block_rsv == delayed_rsv) {
> >  		target = global_rsv;
> > +	} else if (block_rsv != global_rsv) {
> > +		if (!delayed_rsv->full)
> > +			target = delayed_rsv;
> > +	}
> 
> nit:
> 
> } else if (block_rsv != global_rsv && !delayed_rs->full) {
> 
> doesn't surpass the 80 character limit and IMO makes it a bit more
> readable but it's minor.

Agreed, updated.
