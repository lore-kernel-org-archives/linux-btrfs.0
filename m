Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbaA0S1b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 13:27:31 -0500
Date: Mon, 27 Jan 2014 19:27:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: update INSTALL file
Message-ID: <20140127182729.GE6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390371577-1789-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390371577-1789-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 22, 2014 at 02:19:37PM +0800, Anand Jain wrote:
> --- a/INSTALL
> +++ b/INSTALL
> @@ -12,7 +12,8 @@ complete:
>  modprobe libcrc32c
>  insmod btrfs.ko
>  
> -The Btrfs utility programs require libuuid to build.  This can be found
> +The Btrfs utility programs (btrfs-progs) require libattr zlib libacl
> +e2fsprogs libblkid lzo2 to build.  This can be found

The following sentence does not make sense in the context of the
extended list, also I think that the dependencies should be listed one
per-line so it's more clear.

>  in the e2fsprogs sources, and is usually available as libuuid or
>  e2fsprogs-devel from various distros.

The whole file looks very obsolete, mentions kernel module dependencies
as well. Not a priority, but I wouldn't mind trimming the unrelated
information and keep just what's related to userspace, eg. how to build,
run local tests, where to find git sources.
