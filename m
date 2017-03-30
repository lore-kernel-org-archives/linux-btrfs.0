Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36825 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932930AbdC3Mui (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 08:50:38 -0400
Date: Thu, 30 Mar 2017 14:49:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/9] btrfs: qgroup: Add trace point for qgroup
 reserved space
Message-ID: <20170330124948.GH4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
 <20170313075216.5125-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313075216.5125-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 13, 2017 at 03:52:08PM +0800, Qu Wenruo wrote:
> Introduce the following trace points:
> qgroup_update_reserve
> qgroup_meta_reserve
> 
> These trace points are handy to trace qgroup reserve space related
> problems.
> 
> Also export btrfs_qgroup structure, as now we directly pass btrfs_qgroup
> structure to trace points, so that structure needs to be exported.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
