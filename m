Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:45525 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933480Ab2JYPSP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 11:18:15 -0400
Date: Thu, 25 Oct 2012 17:18:01 +0200
From: David Sterba <dave@jikos.cz>
To: Rock Lee <zimilo@code-trick.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [BUG][PATCH][BTRFS-PROGS] Bug overflow fix
Message-ID: <20121025151801.GG10679@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAMRmmpLvLEC_SayRxBJHs=-sunrn_oA6Cy=-pRd+s1v4XDE24g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMRmmpLvLEC_SayRxBJHs=-sunrn_oA6Cy=-pRd+s1v4XDE24g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 24, 2012 at 04:24:02PM +0800, Rock Lee wrote:
> If there's is a long name directory exists in the /dev, then an
> overflow will hit in function utils.c btrfs_scan_one_dir:1013!
> 
> The minimal fix is to use snprintf instead of strcpy.
> 
> The reason why not using strncpy is that, if there is no null byte
> among the first n bytes of src, the string  placed  in  dest
> will not be null - terminated.
> 
> ---
> index 3c88d2e..7200aef 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -969,7 +969,7 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
>  	pending = malloc(sizeof(*pending));
>  	if (!pending)
>  		return -ENOMEM;
> -	strcpy(pending->name, dirname);
> +	snprintf(pending->name, sizeof(pending->name), "%s", dirname);

pending is defined as

919 struct pending_dir {
920         struct list_head list;
921         char name[256];
922 };

and name is supposed to hold a full path, so it should be of PATH_MAX
(4096) size, 256 is a limit for a single filename.

There's another hardcoded value for a path

971         dirname_len = strlen(pending->name);
972         pathlen = 1024;
^^^
973         fullpath = malloc(pathlen);
974         dirname = pending->name;

that shuld be of PATH_MAX size.

thanks,
david
