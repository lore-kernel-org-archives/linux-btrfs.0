Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:55020 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbcEOOTc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 May 2016 10:19:32 -0400
Received: from tux.wizards.de (p579D0052.dip0.t-ipconnect.de [87.157.0.82])
	by mail02.iobjects.de (Postfix) with ESMTPSA id 779D94160141
	for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2016 16:19:29 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id BFDE511C01D2
	for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2016 16:19:28 +0200 (CEST)
Subject: Re: [PATCH 1/7] Btrfs: replace BUG() with WARN_ONCE in raid56
To: linux-btrfs@vger.kernel.org
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <57388570.1050607@applied-asynchrony.com>
Date: Sun, 15 May 2016 16:19:28 +0200
MIME-Version: 1.0
In-Reply-To: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/14/16 02:06, Liu Bo wrote:
> This BUG() has been triggered by a fuzz testing image, but in fact
> btrfs can handle this gracefully by returning -EIO.
> 
> Thus, use WARN_ONCE for warning purpose and don't leave a possible
> kernel panic.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/raid56.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 0b7792e..863f7fe 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -2139,7 +2139,7 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
>  
>  	rbio->faila = find_logical_bio_stripe(rbio, bio);
>  	if (rbio->faila == -1) {
> -		BUG();
> +		WARN_ONCE(1, KERN_WARNING "rbio->faila is -1\n");

I'm generally in favor of not BUGing out for no good reason, but what
is e.g. an admin (or user) supposed to do when he sees this message?
Same for the other rather cryptic WARNs - they contain no actionable
information, and are most likely going to be ignored as "debug spam".
IMHO things that can be ignored can be deleted.

thanks,
Holger

