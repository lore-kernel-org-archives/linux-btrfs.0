Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:33881 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbdF3AtL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 20:49:11 -0400
Received: by mail-pg0-f54.google.com with SMTP id t186so55785486pgb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Jun 2017 17:49:11 -0700 (PDT)
Date: Thu, 29 Jun 2017 17:49:09 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Nick Terrell <terrelln@fb.com>
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        linux-btrfs@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs: Keep one more workspace around
Message-ID: <20170630004909.GD20229@vader.DHCP.thefacebook.com>
References: <20170629175726.1246810-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170629175726.1246810-1-terrelln@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 29, 2017 at 10:57:26AM -0700, Nick Terrell wrote:
> find_workspace() allocates up to num_online_cpus() + 1 workspaces.
> free_workspace() will only keep num_online_cpus() workspaces. When
> (de)compressing we will allocate num_online_cpus() + 1 workspaces, then
> free one, and repeat. Instead, we can just keep num_online_cpus() + 1
> workspaces around, and never have to allocate/free another workspace in the
> common case.
> 
> I tested on a Ubuntu 14.04 VM with 2 cores and 4 GiB of RAM. I mounted a
> BtrFS partition with -o compress-force={lzo,zlib,zstd} and logged whenever
> a workspace was allocated of freed. Then I copied vmlinux (527 MB) to the
> partition. Before the patch, during the copy it would allocate and free 5-6
> workspaces. After, it only allocated the initial 3. This held true for lzo,
> zlib, and zstd. The time it took to execute cp vmlinux /mnt/btrfs && sync
> dropped from 1.70s to 1.44s with lzo compression, and from 2.04s to 1.80s
> for zstd compression.

Good catch! It seems to me like it might be easier to just allocate them
all upfront anyways, but that's a battle for another day.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Nick Terrell <terrelln@fb.com>
> ---
>  fs/btrfs/compression.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 3beb0d0..1a0ef55 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -874,7 +874,7 @@ static void free_workspace(int type, struct list_head *workspace)
>  	int *free_ws			= &btrfs_comp_ws[idx].free_ws;
> 
>  	spin_lock(ws_lock);
> -	if (*free_ws < num_online_cpus()) {
> +	if (*free_ws <= num_online_cpus()) {
>  		list_add(workspace, idle_ws);
>  		(*free_ws)++;
>  		spin_unlock(ws_lock);
> --
> 2.9.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
