Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:44809 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab2KPOV7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Nov 2012 09:21:59 -0500
Date: Fri, 16 Nov 2012 15:21:55 +0100
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: fix a double free on pending snapshots in
 error handling
Message-ID: <20121116142154.GB3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1352119329-18716-1-git-send-email-bo.li.liu@oracle.com>
 <1352119329-18716-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1352119329-18716-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 05, 2012 at 08:42:09PM +0800, Liu Bo wrote:
> When creating a snapshot, failing to commit a transaction can end up
> with aborting the transaction, following by doing a cleanup for it, where
> we'll free all snapshots pending to disk.
> 
> So we check it and avoid double free on pending snapshots.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

I've reproduced this as well, so consider it tested.

david
