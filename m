Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33499 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdAQQQk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 11:16:40 -0500
Date: Tue, 17 Jan 2017 17:15:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/24] tree-log inode vs btrfs_inode cleanups
Message-ID: <20170117161550.GW12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 12, 2017 at 04:00:26PM +0200, Nikolay Borisov wrote:
> So here is a new set of patches cleaning up tree-log function 
> w.r.t inode vs btrfs_inode. There are still some which remain 
> but I didn't find compelling arguments to cleaning them up, so 
> I've left them unchanged. This time there are some size shrinkage:
> 
>    text	   data	    bss	    dec	    hex	filename
>    2530598	 174661	  28288	2733547	 29b5eb	fs/btrfs/btrfs.ko - upstream master
> 
>  	text	   data	    bss	    dec	    hex	filename
>  	2530774	 174661	  28288	2733723	 29b69b	fs/btrfs/btrfs.ko - before tree-log cleanup
> 
>     text	   data	    bss	    dec	    hex	filename
> 	2530163	 174661	  28288	2733112	 29b438	fs/btrfs/btrfs.ko - both series applied 
> 
> So the net result of the 2 series is 435 bytes and I assume there 
> will be further reduction in size once further cleanups are made 

Thanks. I was about to apply the series but patch 06/24 fails to apply
on anytihing that I could use (master, cmason's integration or the
cleanups-next branch). Can you please refresh it on top of master? The
conflict looks like the patch tries to apply the same change twice to
btrfs_del_dir_entries_in_log, so it would be better is you check.
Thanks.
