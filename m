Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49842 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752660AbeBSPnk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Feb 2018 10:43:40 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E5C49ABE0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Feb 2018 15:43:38 +0000 (UTC)
Subject: Re: [PATCH] btrfs: use kvzalloc to allocate btrfs_fs_info
To: dsterba@suse.cz, jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180216035947.31590-1-jeffm@suse.com>
 <20180219153326.GK10193@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f9bc21d8-6e50-c850-2aeb-442b31227c8c@suse.com>
Date: Mon, 19 Feb 2018 17:43:37 +0200
MIME-Version: 1.0
In-Reply-To: <20180219153326.GK10193@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.02.2018 17:33, David Sterba wrote:
> On Thu, Feb 15, 2018 at 10:59:47PM -0500, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> The srcu_struct in btrfs_fs_infoa scales in size with NR_CPUS.  On
>> kernels built with NR_CPUS=8192, this can result in kmalloc failures
>> that prevent mounting.
>>
>> There is work in progress to try to resolve this for every user of
>> srcu_struct but using kvzalloc will work around the failures until
>> that is complete.
> 
> Interesting, the subvol_srcu is the worst contirbutor of the fs_info
> size, on a config with NR_CPUS=512:
> 
>         struct srcu_struct         subvol_srcu;          /*  1064  3480 */
> 	...
> 	/* size: 6496, cachelines: 102, members: 181 */
> 
> Using kvzalloc makes sense and is a minimal fix. In the longterm I'd
> rather allocate subvol_rcu dynamically so the whole fs_info is not
> vmalloced (in the rare case when kmalloc would not work). As this is
> unpredictable and almost invisible, I'm worried about some random
> effects (performance, virtual mappings), so it would be better to avoid
> them if possible.

The interesting bit is the "there is WIP trying to address this". Are
there any patches that have been sent to lkml?


> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
