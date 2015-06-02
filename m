Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759345AbbFBPMg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jun 2015 11:12:36 -0400
Date: Tue, 2 Jun 2015 17:12:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: avoid duplicate checks on user provided
 devid
Message-ID: <20150602151234.GH6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433139918-820-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433139918-820-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 01, 2015 at 02:25:17PM +0800, Anand Jain wrote:
> kernel is already checking it (rightly), we don't need to check that in the user land.

Sometimes it's useful to duplicate the checks in userspace because we
can fail early and return the error message directly, compared to
messages in syslog or a simple errno.

Have you observed that the userspace checks were problematic?

> @@ -214,33 +213,7 @@ static int cmd_start_replace(int argc, char **argv)
>  	}
>  
>  	if (is_numerical(srcdev)) {
> -		struct btrfs_ioctl_fs_info_args fi_args;
> -		struct btrfs_ioctl_dev_info_args *di_args = NULL;
> -
>  		start_args.start.srcdevid = arg_strtou64(srcdev);
> -
> -		ret = get_fs_info(path, &fi_args, &di_args);

This does additional checks, like checking where it's mounted.
