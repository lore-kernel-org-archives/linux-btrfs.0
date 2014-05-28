Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbaE1QY7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 12:24:59 -0400
Date: Wed, 28 May 2014 18:24:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: cleanup btrfs-rescue output msgs
Message-ID: <20140528162457.GP5346@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400117349-2851-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400117349-2851-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 15, 2014 at 09:29:07AM +0800, Gui Hecheng wrote:
> Use enum defined error codes to represent different kinds of errs
> for super-recover and chunk-recover.

I think this change hides the low-level errors (like ENOMEM) that can
possibly result into "recovery not possible", though it can be restarted
and could work fine.

The human readable error messages are good, but should also reflect if
the error was fatal or not and say "why".

Examples:

> @@ -2092,12 +2113,14 @@ int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
>  	ret = recover_prepare(&rc, path);
>  	if (ret) {
>  		fprintf(stderr, "recover prepare error\n");
> +		ret = ERR_CR_FAILED_TO_RECOVER;

eg. recover_prepare can fail if it does not find the path or due to ENOMEM

>  		return ret;
>  	}
>  
>  	ret = scan_devices(&rc);
>  	if (ret) {
>  		fprintf(stderr, "scan chunk headers error\n");
> +		ret = ERR_CR_FAILED_TO_RECOVER;

device open fails, or ENOMEM

>  		goto fail_rc;
>  	}

So, somehow wrap both values into one and convert into the enhanced
messages.
