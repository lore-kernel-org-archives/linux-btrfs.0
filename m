Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbbJ2NQc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 09:16:32 -0400
Date: Thu, 29 Oct 2015 14:15:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] btrfs-progs: Avoid use pointer in handle_options
Message-ID: <20151029131505.GW13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
 <067592f9b350f23dbe4c255238bfebcc9e34964c.1446111097.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <067592f9b350f23dbe4c255238bfebcc9e34964c.1446111097.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 29, 2015 at 05:31:48PM +0800, Zhao Lei wrote:
> +static void check_options(int argc, char **argv)
>  {
> +	if (argc == 0)
> +		return;
> +
> +	const char *arg = argv[0];

Declaration after statements, fixed at commit time.

> +
> +	if (arg[0] != '-' ||
> +	    !strcmp(arg, "--help") ||
> +	    !strcmp(arg, "--version"))
> +		return;
> +
> +	fprintf(stderr, "Unknown option: %s\n", arg);
> +	fprintf(stderr, "usage: %s\n",
> +		btrfs_cmd_group.usagestr[0]);
> +	exit(129);
>  }
>  
