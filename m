Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39377 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933386AbdC3NMU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 09:12:20 -0400
Date: Thu, 30 Mar 2017 15:11:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/9] btrfs: qgroup: Re-arrange tracepoint timing to
 co-operate with reserved space tracepoint
Message-ID: <20170330131135.GJ4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
 <20170313075216.5125-3-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313075216.5125-3-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 13, 2017 at 03:52:09PM +0800, Qu Wenruo wrote:
> Newly introduced qgroup reserved space trace points are normally nested
> into several common qgroup operations.
> 
> While some other trace points are not well placed to co-operate with
> them, causing confusing output.
> 
> This patch re-arrange trace_btrfs_qgroup_release_data() and
> trace_btrfs_qgroup_free_delayed_ref() trace points so they are triggered
> before reserved space ones.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Reviewed-by: Jeff Mahoney <jeffm@suse.com>

I'll add 1 and 2 to the 4.12 queue, but please keep it in your patchset
so it's not dependent on the current development patch queue.
