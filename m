Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbbBXOWt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 09:22:49 -0500
Date: Tue, 24 Feb 2015 15:22:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix a infinite loop when fixing nlink if
 file name conflicts twice.
Message-ID: <20150224142248.GX8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1424678404-5493-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424678404-5493-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 23, 2015 at 04:00:04PM +0800, Qu Wenruo wrote:
> There is a case that can cause nlink fix function.
> 
> For example, lost+found dir already has the following files:
> ---------------------------
> |ino	|filename	  |
> |-------------------------|
> |258	|normal_file	  |
> |259	|normal_file.260  |
> ---------------------------
> The next inode to be fixed is the following:
> ---------------------------
> |260	|normail_file	  |
> ---------------------------
> 
> And when trying to move inode to lost+found dir, its file name conflicts
> with inode 258, and even add ".INO" suffix, it still conflicts with
> inode 259.
> 
> Since the move failed, the LINK_COUNT_ERR flag is not cleared, the inode
> record will not be freed, btrfsck will try fix it again and again,
> causing the infinite loop.
> 
> The patch will first change the ".INO" suffix naming to a loop behavior,
> and clear the LINK_COUNT_ERR flag anyway to avoid infinite loop.
> 
> Reported-by: Naohiro Aota <naota@elisp.net>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
