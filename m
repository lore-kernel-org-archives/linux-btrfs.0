Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46758 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaEVBjg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 21:39:36 -0400
Date: Wed, 21 May 2014 18:39:32 -0700
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH v2] Btrfs: send, fix corrupted path strings for long paths
Message-ID: <20140522013932.GB17040@merlins.org>
References: <1400689419-13446-1-git-send-email-fdmanana@gmail.com>
 <1400690293-14506-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400690293-14506-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 21, 2014 at 05:38:13PM +0100, Filipe David Borba Manana wrote:
> If a path has more than 230 characters, we allocate a new buffer to
> use for the path, but we were forgotting to copy the contents of the
> previous buffer into the new one, which has random content from the
> kmalloc call.

I've confirmed this fixes the problem I was seeing when applied to
3.15rc5.
Thanks for taking that down.

Tested-by: Marc MERLIN <marc@merlins.org>

(while we're at it, I post with my personal address, but I work at
Google, I'm supposed to state that :) )

Marc

> Test:
> 
>     mkfs.btrfs -f /dev/sdd
>     mount /dev/sdd /mnt
> 
>     TEST_PATH="/mnt/fdmanana/.config/google-chrome-mysetup/Default/Pepper_Data/Shockwave_Flash/WritableRoot/#SharedObjects/JSHJ4ZKN/s.wsj.net/[[IMPORT]]/players.edgesuite.net/flash/plugins/osmf/advanced-streaming-plugin/v2.7/osmf1.6/Ak#"
>     mkdir -p $TEST_PATH
>     echo "hello world" > $TEST_PATH/amaiAdvancedStreamingPlugin.txt
> 
>     btrfs subvolume snapshot -r /mnt /mnt/mysnap1
>     btrfs send /mnt/mysnap1 -f /tmp/1.snap
> 
> A test for xfstests follows.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> Cc: Marc Merlin <marc@merlins.org>
> ---
> 
> V2: Fix change title, "paths" to "path".
> 
>  fs/btrfs/send.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index f6bbc1e..70c5e8c 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -368,10 +368,13 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
>  	/*
>  	 * First time the inline_buf does not suffice
>  	 */
> -	if (p->buf == p->inline_buf)
> +	if (p->buf == p->inline_buf) {
>  		tmp_buf = kmalloc(len, GFP_NOFS);
> -	else
> +		if (tmp_buf)
> +			memcpy(tmp_buf, p->buf, old_buf_len);
> +	} else {
>  		tmp_buf = krealloc(p->buf, len, GFP_NOFS);
> +	}
>  	if (!tmp_buf)
>  		return -ENOMEM;
>  	p->buf = tmp_buf;
> -- 
> 1.9.1
> 
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
