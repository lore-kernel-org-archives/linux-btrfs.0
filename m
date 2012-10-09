Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:50816 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab2JIOoQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 10:44:16 -0400
Date: Tue, 9 Oct 2012 16:44:06 +0200
From: David Sterba <dave@jikos.cz>
To: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: introduce '-p' option and <fullpath> into
 subvolume set-default command
Message-ID: <20121009144406.GR4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348468933-14839-1-git-send-email-chenyang.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348468933-14839-1-git-send-email-chenyang.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 02:42:13PM +0800, Chen Yang wrote:
> In command "btrfs subvolume set-default", we used subvolume <id> and <path>
> to set the default subvolume of a filesystem. It's not easy for a common
> user,

What is not easy? How often do you set-default subvolume that it's a
concern to do it in two steps (list and set-default)?

> so I improved it and the <fullpath> of a subvolume can be used to
> set the default subvolume of a filesystem.

Setting the default directly from a given path would be a good UI
improvement.

> @@ -601,23 +602,66 @@ static int cmd_subvol_get_default(int argc, char **argv)
>  static const char * const cmd_subvol_set_default_usage[] = {
> -	"btrfs subvolume set-default <subvolid> <path>",
> +	"btrfs subvolume set-default [-p] [<subvolid>] <path>",

This new syntax allows these forms:

	1. set-default /path
	2. set-default -p /path
	3. set-default id /path
	4. set-default -p id /path

3 is the current behaviour, can you please explain the rest to me? I'm
afraid I'm not following the idea.

>  	"Set the default subvolume of a filesystem",
> +	"-p    Set the parent tree(subvolume) of the PATH",
> +	"      as the default subvolume, if PATH is not a subvolume",

"if PATH is not a subvolume" -- so I don't specify the mountpoint for
PATH and I'm supposed to know if the path is or is not a subvolume --
this is another step I need to do (because I want to be sure that I'm
setting the right subvol), this does not save the commands compared to
the current status.

>  	NULL
>  };

thanks,
david
