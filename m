From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Btrfs: fix ctime update of on-disk inode
Date: Thu, 8 Dec 2011 21:03:50 -0500
Message-ID: <20111209020350.GA29118@infradead.org>
References: <4EE16713.2070907@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE16713.2070907@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 09, 2011 at 09:40:35AM +0800, Li Zefan wrote:
> To reproduce the bug:
> 
>     # touch /mnt/tmp
>     # stat /mnt/tmp | grep Change
>     Change: 2011-12-09 09:32:23.412105981 +0800
>     # chattr +i /mnt/tmp
>     # stat /mnt/tmp | grep Change
>     Change: 2011-12-09 09:32:43.198105295 +0800
>     # umount /mnt
>     # mount /dev/loop1 /mnt
>     # stat /mnt/tmp | grep Change
>     Change: 2011-12-09 09:32:23.412105981 +0800
> 
> We should update ctime of in-memory inode before calling
> btrfs_update_inode().

Can you submit this one as a test for xfstests?

