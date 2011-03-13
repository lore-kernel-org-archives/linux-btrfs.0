From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] BTRFS: Fix mem leak in btrfs_submit_direct()
Date: Sun, 13 Mar 2011 22:03:28 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1103132202450.29706@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1103132145250.29706@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1103132145250.29706@swampdragon.chaosbits.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 13 Mar 2011, Jesper Juhl wrote:

> When memory is low and the allocation for 'dip->csums' fail in 
> fs/btrfs/inode.c:btrfs_submit_direct() we make the situation worse by 
> leaking the memory allocated to 'dip'.
> This patch removes the leak by kfree()'ing 'dip' before jumping to the 
> 'free_ordered' label.
> 

Ignore this patch. I see now that Daniel J Blueman already submitted a fix 
for this issue. Sorry about the noise.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

