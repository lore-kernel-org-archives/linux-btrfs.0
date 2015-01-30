Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763145AbbA3TON (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 14:14:13 -0500
Date: Fri, 30 Jan 2015 20:14:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 1/9] Revert "btrfs: add support for processing pending
 changes" related commits
Message-ID: <20150130191411.GY3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422609654-19519-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422609654-19519-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2015 at 05:20:46PM +0800, Qu Wenruo wrote:
> This reverts commit 572d9ab7845 ~ a6f69dc8018.
> 
> This pending commits patches introduce deadlock with freeze, and fix for
> it will introduce extra checks on freeze and read only case.
> 
> For mount option change, later patches will introduce per-transaction
> mount option to keep mount options consistent during transaction.
> 
> For sysfs interface to change label/features, it will use
> mnt_want_write() to do the ro/freeze check and keep the 'btrfs pro set'
> synchronized behavior.
> 
> Revert them to a clean base for later changes.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

With the improved fix in place

Acked-by: David Sterba <dsterba@suse.cz>
