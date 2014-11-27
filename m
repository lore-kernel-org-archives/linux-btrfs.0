Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43938 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaK0DbW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 22:31:22 -0500
Date: Thu, 27 Nov 2014 11:31:08 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can't cp --reflink files on a Ext4-converted FS w/o checksums
Message-ID: <20141127033107.GA2224@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20141127005527.42a7fe59@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141127005527.42a7fe59@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 27, 2014 at 12:55:27AM +0500, Roman Mamedov wrote:
> Hello,
> 
> I used btrfs-convert to switch my FS from Ext4 to Btrfs. As it was a rather
> large 10 TB filesystem, to save on the conversion time, I used the "-d,
> disable data checksum" option of btrfs-convert.
> 
> Turns out now I can't "cp --reflink" any files that were already on the FS
> prior to conversion. The error message from cp is "failed to clone [...]
> Invalid argument".
> 
> I assume this is because of the lack of checksums; the only way to make old
> files cloneable is to plain copy them to a different place and then delete the
> originals, but that's what I was trying to avoid in the first place.
> 
> Also I thought maybe defragmenting will help, but nope, doesn't seem to be the
> case, even ordering it to recompress data to a different method doesn't fix
> the problem. (Even if it did, it's still a lot of unnecessary rewriting).
> 
> Is there really a good reason to stop these files without checksums from being
> cloneable? It's not like they have the noCoW attribute, so I'd assume any new
> write to these files would cause a CoW and proper checksums for all new blocks
> anyways.

Just FYI, I recently send a patch[1] to fix btrfs-convert's checksum
problem, it'll produce checksum for empty extents, which makes slow
btrrfs-convert even slower.

With this patch, you may try to convert your ext4 without disabling checksum and see if time is improved. 

[1]: Btrfs-progs: fix a bug of converting sparse ext2/3/4
https://patchwork.kernel.org/patch/5374741/

thanks,
-liubo
> 
> -- 
> With respect,
> Roman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
