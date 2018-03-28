Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751072AbeC1OkG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 10:40:06 -0400
Date: Wed, 28 Mar 2018 16:37:39 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: fix fsync after hole punching when using
 no-holes feature
Message-ID: <20180328143739.GI30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180326225900.9979-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180326225900.9979-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 26, 2018 at 11:59:00PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When we have the no-holes mode enabled and fsync a file after punching a
> hole in it, we can end up not logging the whole hole range in the log tree.
> This happens if the file has extent items that span more than one leaf and
> we punch a hole that covers a range that starts in a leaf but does not go
> beyond the offset of the first extent in the next leaf.
> 
> Example:
> 
>   $ mkfs.btrfs -f -O no-holes -n 65536 /dev/sdb
>   $ mount /dev/sdb /mnt
>   $ for ((i = 0; i <= 831; i++)); do
> 	offset=$((i * 2 * 256 * 1024))
> 	xfs_io -f -c "pwrite -S 0xab -b 256K $offset 256K" \
> 		/mnt/foobar >/dev/null
>     done
>   $ sync
> 
>   # We now have 2 leafs in our filesystem fs tree, the first leaf has an
>   # item corresponding the extent at file offset 216530944 and the second
>   # leaf has a first item corresponding to the extent at offset 217055232.
>   # Now we punch a hole that partially covers the range of the extent at
>   # offset 216530944 but does go beyond the offset 217055232.
> 
>   $ xfs_io -c "fpunch $((216530944 + 128 * 1024 - 4000)) 256K" /mnt/foobar
>   $ xfs_io -c "fsync" /mnt/foobar
> 
>   <power fail>
> 
>   # mount to replay the log
>   $ mount /dev/sdb /mnt
> 
>   # Before this patch, only the subrange [216658016, 216662016[ (length of
>   # 4000 bytes) was logged, leaving an incorrect file layout after log
>   # replay.
> 
> Fix this by checking if there is a hole between the last extent item that
> we processed and the first extent item in the next leaf, and if there is
> one, log an explicit hole extent item.
> 
> Fixes: 16e7549f045d ("Btrfs: incompatible format change to remove hole extents")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

1 and 2 added to next, thanks.
