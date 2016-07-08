Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617AbcGHOrs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 10:47:48 -0400
Date: Fri, 8 Jul 2016 16:47:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix BUG_ON in btrfs_submit_compressed_write
Message-ID: <20160708144737.GK13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466645526-27128-1-git-send-email-bo.li.liu@oracle.com>
 <20160623090952.GV4915@twin.jikos.cz>
 <20160623174110.GB13924@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160623174110.GB13924@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 10:41:11AM -0700, Liu Bo wrote:
> On Thu, Jun 23, 2016 at 11:09:52AM +0200, David Sterba wrote:
> > On Wed, Jun 22, 2016 at 06:32:06PM -0700, Liu Bo wrote:
> > > This is similar to btrfs_submit_compressed_read(), if we fail after
> > > bio is allocated, then we can use bio_endio() and errors are saved
> > >  in bio->bi_error.  But please note that we don't return errors to
> > > its caller because the caller assumes it won't call endio to cleanup
> > > on error.
> > 
> > This sounds strange, where do we notice that some of the bios failed?
> 
> bio_endio()
>   -> end_compressed_bio_write()
>      -> end_compressed_writeback()
>         -> mapping_set_error(inode->i_mapping, -EIO);

Thanks. We use the same logic in btrfs_submit_compressed_read as you
mention but I missed that first. Good riddance of the bug-ons.
