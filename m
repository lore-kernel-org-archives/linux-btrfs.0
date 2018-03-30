Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45878 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750794AbeC3Ft7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 01:49:59 -0400
Subject: Re: [PATCH] btrfs-progs: Remove unused parameter
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1522378610-21838-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f4b12839-49c2-65b5-385d-54f7fd876e43@suse.com>
Date: Fri, 30 Mar 2018 08:49:55 +0300
MIME-Version: 1.0
In-Reply-To: <1522378610-21838-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.03.2018 05:56, Gu Jinxiang wrote:
> Parameter usagestr is not used, remove it.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  cmds-filesystem.c | 2 +-
>  help.c            | 2 +-
>  help.h            | 3 +--
>  3 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 467aff11..5fa8cf2b 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -1093,7 +1093,7 @@ static int cmd_filesystem_resize(int argc, char **argv)
>  	DIR	*dirstream = NULL;
>  	struct stat st;
>  
> -	clean_args_no_options_relaxed(argc, argv, cmd_filesystem_resize_usage);
> +	clean_args_no_options_relaxed(argc, argv);
>  
>  	if (check_argc_exact(argc - optind, 2))
>  		usage(cmd_filesystem_resize_usage);
> diff --git a/help.c b/help.c
> index 311a4320..f1dd3946 100644
> --- a/help.c
> +++ b/help.c
> @@ -115,7 +115,7 @@ void clean_args_no_options(int argc, char *argv[], const char * const *usagestr)
>   * - "-- option1 option2 ..."
>   * - "option1 option2 ..."
>   */
> -void clean_args_no_options_relaxed(int argc, char *argv[], const char * const *usagestr)
> +void clean_args_no_options_relaxed(int argc, char *argv[])
>  {
>  	if (argc <= 1)
>  		return;
> diff --git a/help.h b/help.h
> index efeded30..a1405942 100644
> --- a/help.h
> +++ b/help.h
> @@ -72,8 +72,7 @@ int check_argc_exact(int nargs, int expected);
>  int check_argc_min(int nargs, int expected);
>  int check_argc_max(int nargs, int expected);
>  void clean_args_no_options(int argc, char *argv[], const char * const *usage);
> -void clean_args_no_options_relaxed(int argc, char *argv[],
> -		const char * const *usagestr);
> +void clean_args_no_options_relaxed(int argc, char *argv[]);
>  
>  void fixup_argv0(char **argv, const char *token);
>  void set_argv0(char **argv);
> 
