Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752411AbdESSVC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 14:21:02 -0400
Date: Fri, 19 May 2017 20:20:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH] Btrfs: add statx support
Message-ID: <20170519182003.GA4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b67a19fbb3d6e9e483cefd8373b35077d1c2eca3.1494626830.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b67a19fbb3d6e9e483cefd8373b35077d1c2eca3.1494626830.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 12, 2017 at 03:07:43PM -0700, Omar Sandoval wrote:
> From: Yonghong Song <yhs@fb.com>
> 
> Return enhanced file attributes from the btrfs, including:
>   (1). inode creation time as stx_btime, and
>   (2). Certain BTRFS_INODE_xxx flags are mapped to stx_attributes flags.
> 
> Example output:
> 	[root@localhost ~]# cat t.sh
> 	touch t
> 	chattr +aic t
> 	~/linux/samples/statx/test-statx t
> 	chattr -aic t
> 	touch t
> 	echo "========================================"
> 	~/linux/samples/statx/test-statx t
> 	/bin/rm t
> 	[root@localhost ~]# ./t.sh
> 	statx(t) = 0
> 	results=fff
>   	  Size: 0               Blocks: 0          IO Block: 4096    regular file
> 	Device: 00:1c           Inode: 63962       Links: 1
> 	Access: (0644/-rw-r--r--)  Uid:     0   Gid:     0
> 	Access: 2017-05-11 16:03:13.999856591-0700
> 	Modify: 2017-05-11 16:03:13.999856591-0700
> 	Change: 2017-05-11 16:03:14.000856663-0700
>  	 Birth: 2017-05-11 16:03:13.999856591-0700
> 	Attributes: 0000000000000034 (........ ........ ........ ........ ........ ........ ........ .-ai.c..)
> 	========================================
> 	statx(t) = 0
> 	results=fff
> 	  Size: 0               Blocks: 0          IO Block: 4096    regular file
> 	Device: 00:1c           Inode: 63962       Links: 1
> 	Access: (0644/-rw-r--r--)  Uid:     0   Gid:     0
> 	Access: 2017-05-11 16:03:14.006857097-0700
> 	Modify: 2017-05-11 16:03:14.006857097-0700
> 	Change: 2017-05-11 16:03:14.006857097-0700
>  	Birth: 2017-05-11 16:03:13.999856591-0700
> 	Attributes: 0000000000000000 (........ ........ ........ ........ ........ ........ ........ .---.-..)
> 	[root@localhost ~]#
> 
> Reviewed-by: Omar Sandoval <osandov@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
