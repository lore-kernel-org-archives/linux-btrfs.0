Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbcFWKMr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 06:12:47 -0400
Date: Thu, 23 Jun 2016 12:13:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, bo.li.liu@oracle.com
Subject: Re: [PATCH] Btrfs: Force stripesize to the value of sectorsize
Message-ID: <20160623101310.GY4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466675204-31299-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466675204-31299-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 03:16:44PM +0530, Chandan Rajendra wrote:
> Btrfs code currently assumes stripesize to be same as
> sectorsize. However Btrfs-progs (until commit
> df05c7ed455f519e6e15e46196392e4757257305) has been setting
> btrfs_super_block->stripesize to a value of 4096.
> 
> This commit makes sure that the value of btrfs_super_block->stripesize
> is a power of 2. Later, it unconditionally sets btrfs_root->stripesize
> to sectorsize.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Reviewed-by: David Sterba <dsterba@suse.com>
