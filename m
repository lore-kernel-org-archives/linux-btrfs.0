Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab3KMPuc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 10:50:32 -0500
Date: Wed, 13 Nov 2013 16:50:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, bo.li.liu@oracle.com
Subject: Re: [PATCH] btrfs-progs: make it static if function isn't called
 outside
Message-ID: <20131113155030.GB18494@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384330779-16647-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384330779-16647-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 13, 2013 at 04:19:39PM +0800, Anand Jain wrote:
> --- a/cmds-dedup.c
> +++ b/cmds-dedup.c
> @@ -31,7 +31,7 @@ static const char * const dedup_cmd_group_usage[] = {
>  	NULL
>  };
>  
> -int dedup_ctl(char *path, struct btrfs_ioctl_dedup_args *args)
> +static int dedup_ctl(char *path, struct btrfs_ioctl_dedup_args *args)
>  {
>  	int ret = 0;
>  	int fd;

FYI, this hunk modifies code in the the dedup patch that's floating
above the other patches that may get merged to master eventually, so
I've folded it into the dedup patch itself.

david
