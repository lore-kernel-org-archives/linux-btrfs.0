From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfsck segmentation fault + trace
Date: Wed, 16 Jun 2010 12:31:09 -0400
Message-ID: <20100616163109.GX27466@think>
References: <4C18F348.80509@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: John Wyzer <john.wyzer@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C18F348.80509@gmx.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 16, 2010 at 05:52:40PM +0200, John Wyzer wrote:
> I tried 2.6.35-rc3 and got error messages during the boot process about not being able
> to dirty inodes and no space left on device.

Is 2.6.34 working normally?

> 
> 2.6.34.y runs fine and df -h shows
> rootfs                296G  255G   39G  87% /
> 
> I reverted back to 2.6.34 and gave btrfsck a try resulting in a segmentation fault.
> 
> # btrfsck /dev/mapper/root 
> parent transid verify failed on 217995780096 wanted 155238 found 155234
> btrfsck: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)' failed.
> Aborted (core dumped)

This shows a bad metadata block, basically a missed write.  It sounds
like something has gone wrong with this system.

-chris

