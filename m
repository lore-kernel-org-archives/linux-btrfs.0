Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35910 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab3CNXKg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 19:10:36 -0400
Date: Fri, 15 Mar 2013 00:10:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, djmarcin@google.com
Subject: Re: [PATCH 04/10] btrfs-progs: Fix error handling for failed reads
 in restore tool when mirrors exist
Message-ID: <20130314231034.GY7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
 <1363109897-7931-5-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363109897-7931-5-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 01:38:11PM -0400, Josef Bacik wrote:
> From: David Marcin <djmarcin@google.com>

Missing signed-off from David, please let us know if it's ok to add it.

thanks,
david

---
>  cmds-restore.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/cmds-restore.c b/cmds-restore.c
> index 617f507..9781801 100644
> --- a/cmds-restore.c
> +++ b/cmds-restore.c
> @@ -198,7 +198,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
>  	int compress;
>  	int ret;
>  	int dev_fd;
> -	int mirror_num = 0;
> +	int mirror_num = 1;
>  	int num_copies;
>  
>  	compress = btrfs_file_extent_compression(leaf, fi);
> @@ -241,14 +241,15 @@ again:
>  
>  	if (size_left < length)
>  		length = size_left;
> -	size_left -= length;
>  
>  	done = pread(dev_fd, inbuf+count, length, dev_bytenr);
> -	if (done < length) {
> +	/* Need both checks, or we miss negative values due to u64 conversion */
> +	if (done < 0 || done < length) {
>  		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
>  					      bytenr, length);
>  		mirror_num++;
> -		if (mirror_num >= num_copies) {
> +		/* mirror_num is 1-indexed, so num_copies is a valid mirror. */
> +		if (mirror_num > num_copies) {
>  			ret = -1;
>  			fprintf(stderr, "Exhausted mirrors trying to read\n");
>  			goto out;
> @@ -257,6 +258,8 @@ again:
>  		goto again;
>  	}
>  
> +	mirror_num = 1;
> +	size_left -= length;
>  	count += length;
>  	bytenr += length;
>  	if (size_left)
> -- 
