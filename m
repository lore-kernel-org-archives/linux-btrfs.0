Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaCZSTU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 14:19:20 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 205EEAC04
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Mar 2014 18:19:20 +0000 (UTC)
Date: Wed, 26 Mar 2014 19:19:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix lockdep warning with reclaim lock inversion
Message-ID: <20140326181919.GV29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5333184E.3090609@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5333184E.3090609@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 26, 2014 at 02:11:26PM -0400, Jeff Mahoney wrote:
> When encountering memory pressure, testers have run into the following
> lockdep warning. It was caused by __link_block_group calling kobject_add
> with the groups_sem held. kobject_add calls kvasprintf with GFP_KERNEL,
> which gets us into reclaim context. The kobject doesn't actually need
> to be added under the lock -- it just needs to ensure that it's only
> added for the first block group to be linked.
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 3.14.0-rc8-default #1 Not tainted
> ---------------------------------------------------------
> kswapd0/169 just changed the state of lock:
>  (&delayed_node->mutex){+.+.-.}, at: [<ffffffffa018baea>] __btrfs_release_delayed_node+0x3a/0x200 [btrfs]
> but this lock took another, RECLAIM_FS-unsafe lock in the past:
>  (&found->groups_sem){+++++.}
> 
> and interrupts could create inverse lock ordering between them.
> 
> other info that might help us debug this:
>  Possible interrupt unsafe locking scenario:
>        CPU0                    CPU1
>        ----                    ----
>   lock(&found->groups_sem);
>                                local_irq_disable();
>                                lock(&delayed_node->mutex);
>                                lock(&found->groups_sem);
>   <Interrupt>
>     lock(&delayed_node->mutex);
> 
>  *** DEADLOCK ***
> 2 locks held by kswapd0/169:
>  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff81159e8a>] shrink_slab+0x3a/0x160
>  #1:  (&type->s_umount_key#27){++++..}, at: [<ffffffff811bac6f>] grab_super_passive+0x3f/0x90
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

For the record, fixes https://bugzilla.kernel.org/show_bug.cgi?id=72501
