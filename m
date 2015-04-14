Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172AbbDNNHD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 09:07:03 -0400
Date: Tue, 14 Apr 2015 15:07:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/1] Btrfs-progs: fix compile warnings
Message-ID: <20150414130701.GP25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1428936534-2502-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1428936534-2502-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 13, 2015 at 10:48:54PM +0800, Anand Jain wrote:
> simple compile time warning fixes.
> 
> cmds-check.c: In function ‘del_file_extent_hole’:
> cmds-check.c:289: warning: ‘prev.len’ may be used uninitialized in this function
> cmds-check.c:289: warning: ‘prev.start’ may be used uninitialized in this function
> cmds-check.c:290: warning: ‘next.len’ may be used uninitialized in this function
> cmds-check.c:290: warning: ‘next.start’ may be used uninitialized in this function
> 
> btrfs-calc-size.c: In function ‘print_seek_histogram’:
> btrfs-calc-size.c:221: warning: ‘group_start’ may be used uninitialized in this function
> btrfs-calc-size.c:223: warning: ‘group_end’ may be used uninitialized in this function
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  btrfs-calc-size.c | 4 ++--
>  cmds-check.c      | 3 +++
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
> index 1372084..88f92e1 100644
> --- a/btrfs-calc-size.c
> +++ b/btrfs-calc-size.c
> @@ -218,9 +218,9 @@ static void print_seek_histogram(struct root_stats *stat)
>  	struct rb_node *n = rb_first(&stat->seek_root);
>  	struct seek *seek;
>  	u64 tick_interval;
> -	u64 group_start;
> +	u64 group_start = 0;
>  	u64 group_count = 0;
> -	u64 group_end;
> +	u64 group_end = 0;
>  	u64 i;
>  	u64 max_seek = stat->max_seek_len;
>  	int digits = 1;
> diff --git a/cmds-check.c b/cmds-check.c
> index ed8c698..de22185 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -293,6 +293,9 @@ static int del_file_extent_hole(struct rb_root *holes,
>  	int have_next = 0;
>  	int ret = 0;
>  
> +	memset(&prev, 0, sizeof(struct file_extent_hole));
> +	memset(&next, 0, sizeof(struct file_extent_hole));

While this fixes the warning, I've found that we're not using the
file_extent_hole in a good way. It contains a rb_node that's unused, the
initializtion to 0 is IMO wrong here. Would be better to use plain
variables for prev/next + start/len.

I'll drop that hunk from the patch and apply the first one.

Thanks.
