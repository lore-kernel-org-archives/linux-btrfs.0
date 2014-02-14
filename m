Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbaBNR5i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 12:57:38 -0500
Date: Fri, 14 Feb 2014 18:57:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs-progs: use usage() to replace the warning msg
 on no-arg usage
Message-ID: <20140214175737.GA16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1392261398-6197-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392261398-6197-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 13, 2014 at 11:16:35AM +0800, Gui Hecheng wrote:
> --- a/cmds-receive.c
> +++ b/cmds-receive.c
> @@ -951,10 +951,8 @@ int cmd_receive(int argc, char **argv)
>  		}
>  	}
>  
> -	if (optind + 1 != argc) {
> -		fprintf(stderr, "ERROR: receive needs path to subvolume\n");
> -		return 1;
> -	}
> +	if (optind + 1 != argc)

FYI, I've replaced this with check_argc_exact

> +		usage(cmd_receive_usage);
>  
>  	tomnt = argv[optind];
>  
