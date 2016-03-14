Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964890AbcCNMXk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 08:23:40 -0400
Date: Mon, 14 Mar 2016 13:23:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/4] btrfs-progs: fix a reression that "property" with -t
 option doesn't work
Message-ID: <20160314122315.GB18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56E5FF9A.4020609@jp.fujitsu.com>
 <56E601F4.9070908@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56E601F4.9070908@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 09:12:36AM +0900, Satoru Takeuchi wrote:
> --- a/cmds-property.c
> +++ b/cmds-property.c
> @@ -379,9 +379,7 @@ static int cmd_property_get(int argc, char **argv)
>  	char *name = NULL;
>  	int types = 0;
> 
> -	clean_args_no_options(argc, argv, cmd_property_get_usage);
> -
> -	if (check_argc_min(argc, 2) || check_argc_max(argc, 5))
> +	if (check_argc_min(argc, 2))
>  		usage(cmd_property_get_usage);
> 
>  	parse_args(argc, argv, cmd_property_get_usage, &types, &object, &name,

We still need to check the number of non-option arguments here, when the
optind is set from parse_args.

> @@ -415,9 +413,7 @@ static int cmd_property_set(int argc, char **argv)
> -	if (check_argc_min(argc, 4) || check_argc_max(argc, 6))
> +	if (check_argc_min(argc, 4))
>  		usage(cmd_property_set_usage);

...

>  	parse_args(argc, argv, cmd_property_set_usage, &types,
> @@ -446,9 +442,7 @@ static int cmd_property_list(int argc, char **argv)
> -	if (check_argc_min(argc, 2) || check_argc_max(argc, 4))
> +	if (check_argc_min(argc, 2))

...
