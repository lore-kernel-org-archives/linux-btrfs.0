From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [2.6.31-rc4] uninitialised memory during read_sb...
Date: Wed, 29 Jul 2009 09:03:07 -0400
Message-ID: <20090729130307.GG13940@think>
References: <6278d2220907271505y65c98631o8a117d86140a1785@mail.gmail.com>
 <6278d2220907290242p1d8bb168g818e4e517847ad5f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6278d2220907290242p1d8bb168g818e4e517847ad5f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 29, 2009 at 10:42:09AM +0100, Daniel J Blueman wrote:
> When mounting a btrfs filesystem on my server running 2.6.31-rc4,
> kmemcheck spotted some believed-uninitialised memory [1] 128 bytes
> into the inode structure access from BTRFS_I [2,3].
> 
> The filesystem was created with btrfstools-0.18 under 2.6.30 - perhaps
> an issue relating to the forward rolling disk format changes - or
> simply relating to the inode size? Should
> be reproducible.

Ok, this is coming from the RB_CLEAR_NODE() call, which reads the
current value of the parent pointer.  I'll fix it up, thanks for sending
the bug report along.

-chris
