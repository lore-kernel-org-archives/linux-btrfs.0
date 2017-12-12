Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36148 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752564AbdLLVd2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 16:33:28 -0500
Date: Tue, 12 Dec 2017 22:31:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [Question] Two variants of SB reads can we move into bio read
 instead ?
Message-ID: <20171212213126.GC3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d9c5e650-5aaa-96e7-f6ff-653794c89f87@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d9c5e650-5aaa-96e7-f6ff-653794c89f87@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 08, 2017 at 06:27:10PM +0800, Anand Jain wrote:
> 
> David,
> 
>   There are two variants of SB read, one using the device cache [1]
>   and the other buffer head [2].
> 
>   [1] btrfs_read_disk_super()
>   [2] btrfs_read_dev_super()
> 
>   Patch, 6f60cbd3ae442cb35861bb522f388db123d42ec1
>    (btrfs: access superblock via pagecache in scan_one_device)
>   Embraced device caches to avoid blocksize set and thus avoid device
>   drop cache. But however its in the context of starting up with a new
>   mount and in practice, would it really matter if the device cache is
>   dropped in the context of mount, we any way drop it when the device
>   is successfully mounted though. I don't understand the actual problem
>   here.

The fix was like 4 years ago, I don't remember all the details but the
problem was reproducible and it's necessary to be fixed as it is by
6f60cbd3ae442cb358.

There is a potential race with udev that calls scan, mkfs that updates
the blocks and repeatedly opens the block device with rw flags (that
triggers udev). And if mount starts in between, funny things can happen
because of the unexpected set_blocksize calls.

>   Further [2] is still using buffer head, which works very well for us
>   in this context, any idea if there is any suggestion to move it to
>   newer bio read instead ?

No special reason to use buffer_head, just that it's been there and is
straightforward to use. Conversion to the bio interface is desired,
though this might not be that easy as it looks as the bh interface hides
some corner cases of the interaction with page cache.
