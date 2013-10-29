Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab3J2Odp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 10:33:45 -0400
Date: Tue, 29 Oct 2013 15:33:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: take ordered root lock when removing ordered
 operations inode
Message-ID: <20131029143340.GG28149@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1382966114-18764-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382966114-18764-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 28, 2013 at 09:15:14AM -0400, Josef Bacik wrote:
> A user reported a list corruption warning from btrfs_remove_ordered_extent, it
> is because we aren't taking the ordered_root_lock when we remove the inode from
> the ordered operations list.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

For stable; it's been there since day 1.
