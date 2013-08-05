Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3HEQxq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 12:53:46 -0400
Date: Mon, 5 Aug 2013 18:53:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 05/11] btrfs-progs: btrfs_scan_one_dir not to skip links
 when /dev/mapper is provided
Message-ID: <20130805165344.GD5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373866257-10519-6-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
 <1373866257-10519-6-git-send-email-anand.jain@oracle.com>

On Mon, Jul 15, 2013 at 01:30:51PM +0800, Anand Jain wrote:
> @@ -1048,6 +1049,9 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
>  		return -ENOMEM;
>  	strcpy(pending->name, dirname);
>  
> +	if (!strncmp(dirname, "/dev/mapper", strlen("/dev/mapper")))
> +		skip_link = 0;

This would break if it's called with "/dev/mapper/", I suggest to use
realpath on the dirname argument first. And you can use strcmp.

david
