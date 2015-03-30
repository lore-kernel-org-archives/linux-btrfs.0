Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36494 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbbC3T7x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 15:59:53 -0400
Received: by pdcp1 with SMTP id p1so94135326pdc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 12:59:52 -0700 (PDT)
Date: Mon, 30 Mar 2015 12:59:51 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix inode eviction infinite loop after
 extent_same ioctl
Message-ID: <20150330195951.GA7440@mew.dhcp4.washington.edu>
References: <1427736407-29521-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427736407-29521-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 30, 2015 at 06:26:47PM +0100, Filipe Manana wrote:
> If we pass a length of 0 to the extent_same ioctl, we end up locking an
> extent range with a start offset greater then its end offset (if the
> destination file's offset is greater than zero). This results in a warning
> from extent_io.c:insert_state through the following call chain:
> 
>   btrfs_extent_same()
>     btrfs_double_lock()
>       lock_extent_range()
>         lock_extent(inode->io_tree, offset, offset + len - 1)
>           lock_extent_bits()
>             __set_extent_bit()
>               insert_state()
>                 --> WARN_ON(end < start)
> 
> This leads to an infinite loop when evicting the inode. This is the same
> problem that my previous patch titled
> "Btrfs: fix inode eviction infinite loop after cloning into it" addressed
> but for the extent_same ioctl instead of the clone ioctl.
> 
> CC: <stable@vger.kernel.org>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Omar Sandoval <osandov@osandov.com>

Reproduced with https://github.com/markfasheh/duperemove/blob/master/btrfs-extent-same.c

./btrfs-extent-same 0 foo 4096 bar 4096

-- 
Omar
