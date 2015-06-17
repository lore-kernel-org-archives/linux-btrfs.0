Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757581AbbFQR1c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 13:27:32 -0400
Date: Wed, 17 Jun 2015 19:27:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix typo in the error log
Message-ID: <20150617172730.GC6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434376943-382-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434376943-382-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 15, 2015 at 10:02:23PM +0800, Anand Jain wrote:
> ---
>  fs/btrfs/disk-io.c | 2 +-
>  fs/btrfs/super.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 57d48f8..5147cb7 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2896,7 +2896,7 @@ retry_root_backup:
>  	     fs_info->num_tolerated_disk_barrier_failures &&
>  	    !(sb->s_flags & MS_RDONLY)) {
>  		printk(KERN_WARNING "BTRFS: "
> -			"too many missing devices, writeable mount is not allowed\n");
> +			"too many missing devices, writable mount is not allowed\n");

I see both forms are accepted:

http://dictionary.reference.com/browse/writeable
http://dictionary.reference.com/browse/writable

Though not here:

http://www.merriam-webster.com/dictionary/writable
