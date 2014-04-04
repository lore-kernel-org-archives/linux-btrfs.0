Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbaDDOJ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Apr 2014 10:09:57 -0400
Date: Fri, 4 Apr 2014 16:09:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix unlock in __start_delalloc_inodes()
Message-ID: <20140404140956.GW29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1396439612-6076-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1396439612-6076-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 02, 2014 at 07:53:32PM +0800, Wang Shilong wrote:
> This patch fix a regression caused by the following patch:
> Btrfs: don't flush all delalloc inodes when we doesn't get s_umount lock
> 
> break while loop will make us call @spin_unlock() without
> calling @spin_lock() before, fix it.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
