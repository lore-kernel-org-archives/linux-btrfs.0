Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42481 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750747AbdEEQho (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 May 2017 12:37:44 -0400
Date: Fri, 5 May 2017 18:37:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH] btrfs: cleanup qgroup trace event
Message-ID: <20170505163736.GE10575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170504140411.26723-1-anand.jain@oracle.com>
 <20170505020936.6016-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170505020936.6016-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 05, 2017 at 10:09:36AM +0800, Anand Jain wrote:
> Commit 81fb6f77a026 (btrfs: qgroup: Add new trace point for
> qgroup data reserve) added the following events which aren't used.
>   btrfs__qgroup_data_map
>   btrfs_qgroup_init_data_rsv_map
>   btrfs_qgroup_free_data_rsv_map
> So remove them.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>   cc: quwenruo@cn.fujitsu.com
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Patch queued, thanks.
