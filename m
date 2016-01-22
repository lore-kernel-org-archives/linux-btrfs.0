Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbcAVODT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 09:03:19 -0500
Date: Fri, 22 Jan 2016 15:03:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: async-thread: Fix a use-after-free error for trace
Message-ID: <20160122140311.GT4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1453426118-11198-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453426118-11198-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 22, 2016 at 09:28:38AM +0800, Qu Wenruo wrote:
> Parameter of trace_btrfs_work_queued() can be freed in its workqueue.
> So no one use use that pointer after queue_work().
> 
> Fix the user-after-free bug by move the trace line before queue_work().
> 
> Reported-by: Dave Jones <davej@codemonkey.org.uk>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
