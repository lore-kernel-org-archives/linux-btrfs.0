Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbaFBQG1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jun 2014 12:06:27 -0400
Date: Mon, 2 Jun 2014 18:06:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs-progs: fsck: only allow partial opening under
 repair mode
Message-ID: <20140602160625.GC22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401276041-18349-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401276041-18349-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 28, 2014 at 07:20:38PM +0800, Wang Shilong wrote:
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -6810,8 +6810,7 @@ int cmd_check(int argc, char **argv)
>  	int option_index = 0;
>  	int init_csum_tree = 0;
>  	int qgroup_report = 0;
> -	enum btrfs_open_ctree_flags ctree_flags =
> -		OPEN_CTREE_PARTIAL | OPEN_CTREE_EXCLUSIVE;
> +	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_EXCLUSIVE;
>  
>  	while(1) {
>  		int c;
> @@ -6877,6 +6876,10 @@ int cmd_check(int argc, char **argv)
>  		goto err_out;
>  	}
>  
> +	/* only allow partial opening under repair mode */
> +	if (repair)
> +		ctree_flags |= OPEN_CTREE_PARTIAL;

I'm curious why. The usual way is to run fsck, look at errors and call
with --repair eventually, expecting the repair mode do fix what's
fixable.

Now this would not return the same set of errors in the non-repair mode?

This of course depends on the damage of the filesystem, but I think we
should try to let it continue as far as possible and then stop. This
probably means extra checks of the data structures before use, but this
a good pattern for fsck anyway.

> +
>  	info = open_ctree_fs_info(argv[optind], bytenr, 0, ctree_flags);
>  	if (!info) {
>  		fprintf(stderr, "Couldn't open file system\n");
