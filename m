Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41573 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750811AbdE3RVH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 May 2017 13:21:07 -0400
Date: Tue, 30 May 2017 19:20:06 +0200
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, dsterba <dsterba@suse.cz>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: btrfs-convert: Add larger device support
Message-ID: <20170530172006.GY14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170513125632.GA10846@giis.co.in>
 <b9f29fde-1e8a-d481-971a-b1951bf9b2a8@cn.fujitsu.com>
 <20170515083653.GA5902@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170515083653.GA5902@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 15, 2017 at 02:06:54PM +0530, Lakshmipathi.G wrote:
> On Mon, May 15, 2017 at 09:40:29AM +0800, Qu Wenruo wrote:
> > >bug: https://bugzilla.kernel.org/show_bug.cgi?id=194795
> > 
> > Errr, it seems that you forgot to update ext2_open_fs() to update how we get
> > cctx->block_counts.
> > 
> > Without that update, we still get wrong total size of original fs, so
> > converted image will be corrupted.
> > 
> > In this 22T case, it can't pass convert test since after conversion,
> > converted image can't pass e2fsck.
> > 
> > Thanks,
> > Qu
> > 
> 
> Thanks for pointing out the issue. So we need to update 
> common.h/cctx->block_count from u32 to u64?

I think we should use the 64bit types just to be safe.

> do we also need to change other fields like inodes_count and
> free_inode_count?

Yes please.
