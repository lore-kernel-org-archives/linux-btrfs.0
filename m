Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7019CC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 11:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49D6B206B8
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 11:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733016AbfC0LAz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 07:00:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:43222 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732499AbfC0LAz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 07:00:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4216DACC5;
        Wed, 27 Mar 2019 11:00:54 +0000 (UTC)
Date:   Wed, 27 Mar 2019 06:00:52 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/15] btrfs: create a mount option for dax
Message-ID: <20190327110052.pvn5dag2xwy2tnkv@merlin>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-2-rgoldwyn@suse.de>
 <20190326191001.GP10344@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326191001.GP10344@bombadil.infradead.org>
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12:10 26/03, Matthew Wilcox wrote:
> On Tue, Mar 26, 2019 at 02:02:47PM -0500, Goldwyn Rodrigues wrote:
> > This sets S_DAX in inode->i_flags, which can be used with
> > IS_DAX().
> > 
> > The dax option is restricted to non multi-device mounts.
> > dax interacts with the device directly instead of using bio, so
> > all bio-hooks which we use for multi-device cannot be performed
> > here. While regular read/writes could be manipulated with
> > RAID0/1, mmap() is still an issue.
> > 
> > Auto-setting free space tree, because dealing with free space
> > inode (specifically readpages) is a nightmare.
> > Auto-setting nodatasum because we don't get callback for writing
> > checksums after mmap()s.
> 
> Congratulations on getting the bear to dance.  But why?
> 

Why not ? ;)

> To me, the point of btrfs is all the cool stuff it does with built-in
> checksumming and snapshots and RAID and so on.  DAX doesn't let you do
> any of that, so why would somebody want to use btrfs to manage DAX?
> 

There are users who are asking for advantages of dax on btrfs.

I have tried to make it work with snapshots in this series.
Checksumming should be possible, but would require some more hacks. I am
looking into it.
multi-device is an issue for mmap() and I don't think we can work around
it.

I agree there is a price to pay to use dax, but I am sure the users
would know about that.

-- 
Goldwyn
