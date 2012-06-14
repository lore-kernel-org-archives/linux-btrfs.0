Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:37096 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121Ab2FNOFt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 10:05:49 -0400
Date: Thu, 14 Jun 2012 16:05:45 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use rcu to protect device->name V3
Message-ID: <20120614140545.GS32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1339596359-5514-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339596359-5514-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 13, 2012 at 10:05:59AM -0400, Josef Bacik wrote:
> Al pointed out that we can just toss out the old name on a device and add a
> new one arbitrarily, so anybody who uses device->name in printk could
> possibly use free'd memory.  Instead of adding locking around all of this he
> suggested doing it with RCU, so I've introduced a struct rcu_string that
> does just that and have gone through and protected all accesses to
> device->name that aren't under the uuid_mutex with rcu_read_lock().  This
> protects us and I will use it for dealing with removing the device that we
> used to mount the file system in a later patch.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

I'm not going to stall this patch further due to minor things, thanks
for addressing the comments, leaving the rest for later.

david
