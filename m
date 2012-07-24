Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34628 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab2GXTrH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jul 2012 15:47:07 -0400
Date: Tue, 24 Jul 2012 21:47:02 +0200
From: David Sterba <dave@jikos.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] Btrfs: Check INCOMPAT flags on remount and add helper
 function
Message-ID: <20120724194702.GI17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1343152723-8856-1-git-send-email-mitch.harder@sabayonlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1343152723-8856-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 24, 2012 at 12:58:43PM -0500, Mitch Harder wrote:
> In support of the recently added capability to remount with lzo
> compression, provide a helper function to check the compression
> INCOMPAT flags when remounting with lzo compression, and set
> the flags if necessary.
> 
> Also, implement the new helper function when defragmenting with
> explicit lzo compression and when setting the default subvolume.
> 
> Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>

Thanks!

Reviewed-by: David Sterba <dsterba@suse.cz>
