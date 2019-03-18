Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F3EC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 19:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3690C20989
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 19:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfCRTAg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:00:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:54822 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726832AbfCRTAg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 15:00:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E4728AF9A
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 19:00:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1B4A9DA829; Mon, 18 Mar 2019 20:01:49 +0100 (CET)
Date:   Mon, 18 Mar 2019 20:01:48 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Correctly free extent buffer in case
 btree_read_extent_buffer_pages fails
Message-ID: <20190318190148.GG3516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190312131847.20311-1-nborisov@suse.com>
 <20190313180314.GH31119@twin.jikos.cz>
 <6581c72e-7a26-2cbe-2bc6-d3bae313a255@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6581c72e-7a26-2cbe-2bc6-d3bae313a255@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 14, 2019 at 09:10:42AM +0200, Nikolay Borisov wrote:
> >> The correct way to free the buffer is call free_extent_buffer_stale.
> >> This function will correctly call atomic_dec explicitly for the buffer
> >> and subsequently call release_extent_buffer which will decrement the
> >> final reference thus correctly remove the invalid buffer from buffer
> >> cache. This change affects only newly allocated buffers since they have
> >> eb->refs == 2.
> > 
> > Following the same pattern, should every use of
> > btrfs_find_create_tree_block be followed by free_extent_buffer_stale in
> > case of errors?
> > 
> > There's almost the same sequence in readahead_tree_block as you update
> > in reada_tree_block_flagged:
> > 
> >   btrfs_find_create_tree_block
> >   read_extent_buffer_pages
> >   free_extent_buffer
> > 
> > so should be the _stale variant used there too?
> 
> You are right it should also be using the _stale variant. I will fix it.
> 
> Despite my cleanup of the extent buffer freeing code I'm still not
> entirely happy with the special cases we have with the stale or unmapped
> logic. That's why we need all these special cases ;\
> 
> > 
> > free_extent_buffer_stale is normally used in other contexts where the
> > 'stale' part means that the eb is known to be disconnected.
> > 
> > I think that btrfs_find_create_tree_block needs a dedicated freeing
> > function that will make sure all invariants (refs == 2, no other
> > structures connected) are met and then do effectively the same what
> > _stale does now.
> Sounds good though I'm a bit reluctant to add yet another
> free_extent_buffer variant. IMO the logic of the extent buffer radix
> tree need to be revised which could lead to simplifications in the whole
> ref counting code.

Revised maybe, but this is the core of the MM <-> FS interaction and
must be correct, even after the simplification. There's RCU in the mix,
non-standard refcounting, page tracking. This won't be easy. Adding a
admitedly why-yet-another special freeing helper would at least stop
abusing the API and annotate the context. That's an intermediate step.
