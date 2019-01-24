Return-Path: <SRS0=zIKm=QA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E3CC282C5
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 18:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D9A2218A6
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 18:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbfAXSpg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:45:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:59404 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725974AbfAXSpf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 13:45:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3AE43B056;
        Thu, 24 Jan 2019 18:45:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8964CDA6F5; Thu, 24 Jan 2019 19:44:59 +0100 (CET)
Date:   Thu, 24 Jan 2019 19:44:58 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 5/7] btrfs: qgroup: Introduce per-root swapped blocks
 infrastructure
Message-ID: <20190124184457.GZ2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190115081604.785-1-wqu@suse.com>
 <20190115081604.785-6-wqu@suse.com>
 <20190122165554.GO2900@twin.jikos.cz>
 <507b96ec-86b1-6c23-2d16-b6b67b2f5920@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <507b96ec-86b1-6c23-2d16-b6b67b2f5920@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 23, 2019 at 07:07:50AM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/1/23 上午12:55, David Sterba wrote:
> > On Tue, Jan 15, 2019 at 04:16:02PM +0800, Qu Wenruo wrote:
> <snip>
> >> +
> >> +	block = kmalloc(sizeof(*block), GFP_NOFS);
> >> +	if (!block) {
> >> +		ret = -ENOMEM;
> > 
> > This goes to 'out' that marks quota as inconsistent, is this
> > intentional?
> 
> Yes
> 
> > Ie. if this function does not succed for whatever reason,
> > the quotas are indeed inconsistent.
> 
> If we hit this ENOMEM case, although it's possible later CoW doesn't
> touch this subtree, it's also possible later CoW touches this and make
> qgroup numbers inconsistent.
> 
> So we should mark qgroup inconsistent for the possibility of
> inconsistent qgroup numbers.

I see, thanks.

> [snip]
> > 
> >> +	while (*p) {
> >> +		struct btrfs_qgroup_swapped_block *entry;
> >> +
> >> +		parent = *p;
> >> +		entry = rb_entry(parent, struct btrfs_qgroup_swapped_block,
> >> +				 node);
> >> +
> >> +		if (entry->subv_bytenr < block->subv_bytenr)
> >> +			p = &(*p)->rb_left;
> >> +		else if (entry->subv_bytenr > block->subv_bytenr)
> >> +			p = &(*p)->rb_right;
> >> +		else {
> > 
> > I've pointed out missing { } around if/else if/else statemtents in patch
> > 1, would be good if you fix all patches.
> 
> Sorry, it's sometimes hard to apply the same comment to older branches.
> Normally I'll pay more attention for newly written code, but it's not
> that easy to spot older code.
> 
> > 
> >> +			if (entry->subv_generation != block->subv_generation ||
> >> +			    entry->reloc_bytenr != block->reloc_bytenr ||
> >> +			    entry->reloc_generation !=
> >> +			    block->reloc_generation) {
> >> +				WARN_ON_ONCE(1);
> > 
> > This would need some explanation why you want to see the warning.
> 
> The case here is, I don't want to populate the whole dmesg with tons of
> possible backtrace from this call sites, but I still hope user to report
> such error.
> 
> So I choose _ONCE() to inform user to report the error, as I don't
> really see it's possible.
> 
> > _ONCE
> > is for the whole lifetime of the module but I think you'd be interested
> > on a per-filesystem basis. If this is meant for developers it should go
> > under DEBUG, but otherwise I don't see what would this warning bring to
> > the users.
> 
> OK, I'll put it under DEBUG and change from ONCE to regular WARN_ON().

Works for me.

> [snip]
> >>  
> >> +/*
> >> + * Special performance hack for balance.
> > 
> > Is it really a hack? Hack sounds cool, but isn't it just an optimization?
> 
> It's optimization indeed.
> (But hack sounds really cool).
> 
> 
> >>  
> >> +struct btrfs_qgroup_swapped_block {
> >> +	struct rb_node node;
> >> +
> >> +	bool trace_leaf;
> >> +	int level;
> > 
> > Please reorder that so int goes before bool, othewise this adds
> > unnecessary padding.
> 
> Can we make compiler to do this work?

No, compiler must keep the order of definition and may add padding to
satify the alignment constraints. It can warn though, -Wpadded but it's
too noisy so you'd have to diff the warnings to see if your code adds
new paddings. For any new structure or new member I use the tool
'pahole' that prints the detailed layout.
