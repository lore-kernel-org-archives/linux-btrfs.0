Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbbATQBG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 11:01:06 -0500
Date: Tue, 20 Jan 2015 17:01:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH RFC v2 1/5] btrfs: Fix the bug that
 fs_info->pending_changes is never cleared.
Message-ID: <20150120160104.GG13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1421744737-16586-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421744737-16586-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 20, 2015 at 05:05:33PM +0800, Qu Wenruo wrote:
> Fs_info->pending_changes is never cleared since the original code uses
> cmpxchg(&fs_info->pending_changes, 0, 0), which will only clear it if
> pending_changes is already 0.
> 
> This will cause a lot of problem when mount it with inode_cache mount
> option.
> If the btrfs is mounted as inode_cache, pending_changes will always be
> 1, even when the fs is frozen.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

Chris, please add this to 3.19-rc, introduced in this dev cycle.
