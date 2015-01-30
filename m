Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbbA3TMF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 14:12:05 -0500
Date: Fri, 30 Jan 2015 20:12:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 5/9] btrfs: Use btrfs_test_trans_opt() to handle
 INODE_CACHE if it's under transaction protect.
Message-ID: <20150130191204.GV3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422609654-19519-6-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422609654-19519-6-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2015 at 05:20:50PM +0800, Qu Wenruo wrote:
> Convert btrfs_test_opt() to btrfs_test_trans_opt() if it's called under
> transaction protection.
> 
> This will ensure SPACE_CACHE bit is consistent during transaction.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
