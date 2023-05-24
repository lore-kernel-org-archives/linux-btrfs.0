Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96371C77B7C
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 May 2023 05:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238980AbjEXFuL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 May 2023 01:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbjEXFuK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2023 01:50:10 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C29C1
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2023 22:50:09 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5969A68D08; Wed, 24 May 2023 07:50:04 +0200 (CEST)
Date:   Wed, 24 May 2023 07:50:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     David Sterba <dsterba@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH 13/21] btrfs: don't use btrfs_bio_ctrl for extent
 buffer writing
Message-ID: <20230524055003.GB19255@lst.de>
References: <20230503152441.1141019-1-hch@lst.de> <20230503152441.1141019-14-hch@lst.de> <20230523184541.GZ32559@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523184541.GZ32559@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 23, 2023 at 08:45:41PM +0200, David Sterba wrote:
> On Wed, May 03, 2023 at 05:24:33PM +0200, Christoph Hellwig wrote:
> > The btrfs_bio_ctrl machinery is overkill for writing extent_buffers
> > as we always operate on PAGE SIZE chunks (or one smaller one for the
> > subpage case) that are contigous and are guaranteed to fit into a
> > single bio.  Replace it with open coded btrfs_bio_alloc, __bio_add_page
> > and btrfs_submit_bio calls.
> 
> submit_extent_page hasn't been open coded completely, there's still call
> to wbc_account_cgroup_owner() but it's probably skipped for other
> reasons as this is metadata inode.

Hmm, I was under the impression that we never did cgroup accounting for
metadata.  While that is true for the rest of the kernel, I fear I might
have changed semantics for btrfs here (for better or worse).  Let me
dig into the code again, but I suspect I'll need to add
wbc_account_cgroup_owner and wbc_init_bio back to not change semantics
vs the old code.
