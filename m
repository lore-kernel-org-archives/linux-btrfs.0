Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762845AbbA3S21 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 13:28:27 -0500
Date: Fri, 30 Jan 2015 19:28:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 2/9] btrfs: Make btrfs_parse_options() parse mount
 option in a atomic way
Message-ID: <20150130182825.GQ3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422609654-19519-3-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422609654-19519-3-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2015 at 05:20:47PM +0800, Qu Wenruo wrote:
> v5:
>   Add ACCESS_ONE() macro to avoid aggressive compiler optimization to
>   not read fs_info->mount_opt to new_opt but always use fs_info->mount_opt.

This holds only up to this patch, ie. that there are other threads that
could change value of fs_info->mount_opt concurrently. But then the
per-transaction mount options will avoid that as space cache status will
be unmodified by remounts (through parse_options).

So either drop ACCESS_ONCE or please write a comment and explain why
it's still needed.
