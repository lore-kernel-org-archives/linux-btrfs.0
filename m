Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57852 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751000AbdE2Oji (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 10:39:38 -0400
Date: Mon, 29 May 2017 16:38:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: clear EXTENT_DEFRAG bits in finish_ordered_io
Message-ID: <20170529143837.GJ14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1494370935-19965-1-git-send-email-bo.li.liu@oracle.com>
 <20170526234423.25913-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170526234423.25913-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 26, 2017 at 05:44:23PM -0600, Liu Bo wrote:
> Before this, we use 'filled' mode here, ie. if all range has been
> filled with EXTENT_DEFRAG bits, get to clear it, but if the defrag
> range joins the adjacent delalloc range, then we'll have EXTENT_DEFRAG
> bits in extent_state until releasing this inode's pages, and that
> prevents extent_date from being freed.
> 
> This clears the bit if any was found within the ordered extent.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
