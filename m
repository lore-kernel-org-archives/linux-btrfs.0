Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab3KLQCo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 11:02:44 -0500
Date: Tue, 12 Nov 2013 17:02:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: remove unused function
 btrfs_get_inode_ref_index()
Message-ID: <20131112160242.GC9132@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384255924-15851-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384255924-15851-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 12, 2013 at 07:32:03PM +0800, Wang Shilong wrote:
> Since commit d52be818e6(Btrfs: simplify unlink reservations),
> btrfs_get_inode_ref_index() is no loner called.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

http://www.spinics.net/lists/linux-btrfs/msg26646.html
Reviewed-by: David Sterba <dsterba@suse.cz>
