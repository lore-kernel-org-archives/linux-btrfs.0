Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbbG0NcE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 09:32:04 -0400
Date: Mon, 27 Jul 2015 15:31:53 +0200
From: David Sterba <dsterba@suse.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH] Btrfs: btrfs_submit_bio_hook: Use btrfs_wq_endio_type
 values instead of integer constants
Message-ID: <20150727133153.GD6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1437991003-5901-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437991003-5901-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 27, 2015 at 03:26:43PM +0530, Chandan Rajendra wrote:
> btrfs_submit_bio_hook() uses integer constants instead of values from "enum
> btrfs_wq_endio_type". Fix this.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Reviewed-by: David Sterba <dsterba@suse.com>
