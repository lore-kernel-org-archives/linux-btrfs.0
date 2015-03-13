Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:59684 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbbCMJBO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 05:01:14 -0400
Received: from mailnull by bh-25.webhostbox.net with sa-checked (Exim 4.82)
	(envelope-from <linux@roeck-us.net>)
	id 1YWLSy-002rqi-PQ
	for linux-btrfs@vger.kernel.org; Fri, 13 Mar 2015 09:01:13 +0000
Date: Fri, 13 Mar 2015 02:01:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fs: btrfs: Add missing include file
Message-ID: <20150313090106.GA9881@roeck-us.net>
References: <1426237126-9700-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426237126-9700-1-git-send-email-linux@roeck-us.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 13, 2015 at 01:58:46AM -0700, Guenter Roeck wrote:
> Building alpha:allmodconfig fails with
> 
> fs/btrfs/inode.c: In function 'check_direct_IO':
> fs/btrfs/inode.c:8050:2: error: implicit declaration of function 'iov_iter_alignment'
> 
> due to a missing include file.
> 
> Fixes: 3737c63e1fb0 ("fs: move struct kiocb to fs.h")
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---

Forgot to mention: This is for -next.

Guenter

>  fs/btrfs/inode.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 37dc84c..5b6e5bd 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -42,6 +42,7 @@
>  #include <linux/btrfs.h>
>  #include <linux/blkdev.h>
>  #include <linux/posix_acl_xattr.h>
> +#include <linux/uio.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> -- 
> 2.1.0
> 
