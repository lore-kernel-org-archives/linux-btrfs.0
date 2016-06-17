Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbcFQQjb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 12:39:31 -0400
Date: Fri, 17 Jun 2016 18:40:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, bo.li.liu@oracle.com
Subject: Re: [PATCH] Btrfs: btrfs_check_super_valid: Allow 4096 as stripesize
Message-ID: <20160617164006.GH4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466095078-25726-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466095078-25726-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 16, 2016 at 10:07:58PM +0530, Chandan Rajendra wrote:
> Older btrfs-progs/mkfs.btrfs sets 4096 as the stripesize. Hence
> restricting stripesize to be equal to sectorsize would cause super block
> validation to return an error on architectures where PAGE_SIZE is not
> equal to 4096.
> 
> Hence as a workaround, this commit allows stripesize to be set to 4096
> bytes.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Reviewed-by: David Sterba <dsterba@suse.com>

As we've discused on IRC, there's one more place to fix the stripesize,
but I'll take this one as it's fixing the validation side.
