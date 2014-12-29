Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbaL2Q3x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 11:29:53 -0500
Date: Mon, 29 Dec 2014 17:29:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: refine btrfs-debug-tree error prompt
 when a mount point given
Message-ID: <20141229162951.GL6490@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1419470195-2889-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1419470195-2889-2-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1419470195-2889-2-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 25, 2014 at 09:16:35AM +0800, Gui Hecheng wrote:
> Now, if exec:
> 	# btrfs-debug-tree <mount_point>
> it echos:
> 	: Superblock bytenr is larger than device size
> 
> But it is quite misleading, because it is a valid btrfs.
> In this case, we should tell the developer to provide a block device.
> 
> After apply:
> 	: '<mount_point>' is not a block device
> 	: 'usage: btrfs-debug-tree [options] device
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>  btrfs-debug-tree.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
> index e46500d..7f079a9 100644
> --- a/btrfs-debug-tree.c
> +++ b/btrfs-debug-tree.c
> @@ -179,6 +179,12 @@ int main(int ac, char **av)
>  	if (check_argc_exact(ac, 1))
>  		print_usage();
>  
> +	ret = check_arg_type(av[optind]);
> +	if (ret != BTRFS_ARG_BLKDEV) {
> +		fprintf(stderr, "'%s' is not a block device\n", av[optind]);
> +		print_usage();

The current widespread pattern is to print_usage() after most errors in
commandline arguments but I find it quite annoying. The help is always
available under --help for each command. As the bugfix is good I'm going
to apply it and replace it with exit().

We can start removing misues of print_usage() from the codebase in the
next dev cycle.
