Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaF0Mfa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 08:35:30 -0400
Date: Fri, 27 Jun 2014 14:35:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] btrfs-progs: limit minimal num of args for
 btrfs-image
Message-ID: <20140627123528.GC1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403751186-31559-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1403751186-31559-5-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403751186-31559-5-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 26, 2014 at 10:53:05AM +0800, Gui Hecheng wrote:
> @@ -2521,6 +2521,9 @@ int main(int argc, char *argv[])
>  	}
>  
>  	argc = argc - optind;
> +	if (argc < 2)

Please use the check_argc_min helper instead. Thanks.

> +		print_usage();
> +
>  	dev_cnt = argc - 1;
>  
>  	if (create) {
