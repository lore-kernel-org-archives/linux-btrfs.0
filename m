Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbcFTLjD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 07:39:03 -0400
Date: Mon, 20 Jun 2016 13:39:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [PATCH V19 11/19] Btrfs: subpage-blocksize: Prevent writes to an
 extent buffer when PG_writeback flag is set
Message-ID: <20160620113914.GM4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1465888276-30670-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1465888276-30670-12-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1465888276-30670-12-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 14, 2016 at 12:41:08PM +0530, Chandan Rajendra wrote:
> In non-subpage-blocksize scenario, BTRFS_HEADER_FLAG_WRITTEN flag
> prevents Btrfs code from writing into an extent buffer whose pages are
> under writeback. This facility isn't sufficient for achieving the same
> in subpage-blocksize scenario, since we have more than one extent buffer
> mapped to a page.
> 
> Hence this patch adds a new flag (i.e. EXTENT_BUFFER_HEAD_WRITEBACK) and
> corresponding code to track the writeback status of the page and to
> prevent writes to any of the extent buffers mapped to the page while
> writeback is going on.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

This patch has a minor conflict with patch merged into 4.7-rc4 and I'm
not sure if the resolution is correct.

btrfs: account for non-CoW'd blocks in btrfs_abort_transaction
64c12921e11b3a0c10d088606e328c58e29274d8

introduces trans->dirty, the conflicts are in btrfs_cow_block and
btrfs_search_slot.
