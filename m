Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57938 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731699AbeHCP5F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 11:57:05 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39490ACF7
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 14:00:35 +0000 (UTC)
Date: Fri, 3 Aug 2018 16:00:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: completion: Use _filedir() to replace
 _btrfs_devs()
Message-ID: <20180803140031.GY3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180717061532.11857-1-wqu@suse.com>
 <20180717061532.11857-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180717061532.11857-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 17, 2018 at 02:15:31PM +0800, Qu Wenruo wrote:
> For developers it's pretty common to call "btrfs check" on a raw image
> dump other than real block device.

I'd be less concerned about developers' environment rather than the
situations where users want to run check and won't accidentally screw
up. So completing from filenames should be safe here, the typical
use will probably want something starting with /dev/ and confusion with
random files named 'sda' is highly unlikely.

> So current _btrfs_devs() is really making things worse. Use _filedir()
> to replace _btrfs_devs() so it can complete any filenames, no matter if
> it's just a file or a real block device.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  btrfs-completion | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/btrfs-completion b/btrfs-completion
> index ae683f4ecf61..33830e827977 100644
> --- a/btrfs-completion
> +++ b/btrfs-completion
> @@ -6,9 +6,7 @@
>  
>  _btrfs_devs()
>  {
> -	local DEVS
> -	DEVS=''; while read dev; do DEVS+="$dev "; done < <(lsblk -pnro name)
> -	COMPREPLY+=( $( compgen -W "$DEVS" -- "$cur" ) )
> +	_filedir

This is not a good style, the function is says "devices" and actually
does "all files". It's used for several other commands where completing
files might not be a good idea.

If you want to use _filedir, then use it and don't obscure it.
