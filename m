Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbaE1N4q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 09:56:46 -0400
Message-ID: <5385EB18.6020402@redhat.com>
Date: Wed, 28 May 2014 08:56:40 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs-progs: fsck: only allow partial opening under
 repair mode
References: <1401276041-18349-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1401276041-18349-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The subject and the comment say what this change does, but
that's obvious from reading the code.  Nothing says *why*
the change has been made.  What does this fix, and how does
it fix it?

Can you add/update the commit log so that some reader in the future
(or for that matter, a reviewer in the present) will have an idea
about the reason for this change?  What was the failure case, what
was the failure mode, why does this change fix it, etc.

Thanks,
-Eric 

On 5/28/14, 6:20 AM, Wang Shilong wrote:
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index db7df80..0e4e042 100644
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
> +
>  	info = open_ctree_fs_info(argv[optind], bytenr, 0, ctree_flags);
>  	if (!info) {
>  		fprintf(stderr, "Couldn't open file system\n");
> 

