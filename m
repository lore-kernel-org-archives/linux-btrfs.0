Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbcHQMWH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Aug 2016 08:22:07 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A392CABEF
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Aug 2016 12:22:05 +0000 (UTC)
Date: Wed, 17 Aug 2016 14:21:11 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: waiting on qgroup rescan should not always be
 interruptible
Message-ID: <20160817122111.GX30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1470708486-18547-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1470708486-18547-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 08, 2016 at 10:08:06PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> We wait on qgroup rescan completion in three places: file system
> shutdown, the quota disable ioctl, and the rescan wait ioctl.  If the
> user sends a signal while we're waiting, we continue happily along.  This
> is expected behavior for the rescan wait ioctl.  It's racy in the shutdown
> path but mostly works due to other unrelated synchronization points.
> In the quota disable path, it Oopses the kernel pretty much immediately.
> 
> Cc: <stable@vger.kernel.org> # v4.4+
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
