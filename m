Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39863 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbcFWRlZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 13:41:25 -0400
Date: Thu, 23 Jun 2016 10:41:11 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix BUG_ON in btrfs_submit_compressed_write
Message-ID: <20160623174110.GB13924@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1466645526-27128-1-git-send-email-bo.li.liu@oracle.com>
 <20160623090952.GV4915@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160623090952.GV4915@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 11:09:52AM +0200, David Sterba wrote:
> On Wed, Jun 22, 2016 at 06:32:06PM -0700, Liu Bo wrote:
> > This is similar to btrfs_submit_compressed_read(), if we fail after
> > bio is allocated, then we can use bio_endio() and errors are saved
> >  in bio->bi_error.  But please note that we don't return errors to
> > its caller because the caller assumes it won't call endio to cleanup
> > on error.
> 
> This sounds strange, where do we notice that some of the bios failed?

bio_endio()
  -> end_compressed_bio_write()
     -> end_compressed_writeback()
        -> mapping_set_error(inode->i_mapping, -EIO);

Thanks,

-liubo
