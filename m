Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:49939 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab2FZJpc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 05:45:32 -0400
Date: Tue, 26 Jun 2012 11:45:16 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fusionio.com
Subject: Re: [PATCH] Btrfs: fix wrong check during log recovery
Message-ID: <20120626094516.GO28144@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1340683149-19940-1-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340683149-19940-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 11:59:09AM +0800, Liu Bo wrote:
> When we're evicting an inode during log recovery, we need to ensure that the inode
> is not in orphan state any more, which means inode's run_time flags has _no_
> BTRFS_INODE_HAS_ORPHAN_ITEM.  Thus, the BUG_ON was triggered because of a wrong
> check for the flags.

Right. I looked into the original commit 8a35d95ff4680a45, this was the
only case where the conversion to the atomics was reversed. Thanks for
the quick fix!

Patch should go to 3.5-rc

> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
