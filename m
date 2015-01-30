Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762055AbbA3TM1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 14:12:27 -0500
Date: Fri, 30 Jan 2015 20:12:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 3/9] btrfs: Introduce per-transaction mount_opt to
 keep mount option consistent during transaction.
Message-ID: <20150130191225.GX3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422609654-19519-4-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422609654-19519-4-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2015 at 05:20:48PM +0800, Qu Wenruo wrote:
> Before this patch, mount_opt is not consistent during a transaction.
> btrfs_parse_options() can race with transaction.
> 
> Now each transaction will keep a copy of fs_info->mount_opt upon
> creation, and new btrfs_test_trans_opt() macro is introduced to get the
> mount_opt in the transaction.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
