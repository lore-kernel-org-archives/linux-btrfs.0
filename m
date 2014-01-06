Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597AbaAFQtq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 11:49:46 -0500
Date: Mon, 6 Jan 2014 17:49:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 4/4] Btrfs: handle EAGAIN case properly in
 btrfs_drop_snapshot()
Message-ID: <20140106164945.GY6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389000339-15388-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1389000339-15388-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389000339-15388-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 06, 2014 at 05:25:39PM +0800, Wang Shilong wrote:
> We may return early in btrfs_drop_snapshot(), we shouldn't
> call btrfs_std_err() for this case, fix it.

Somebody reported this 2 days ago on IRC. I think it should go to stable
as well, so it would be good to squeeze it to the next rc kernel.

The visible effect of the bug is that the filesystem incorrectly flips
to read-only and the currently running transaction is not committed.

david
