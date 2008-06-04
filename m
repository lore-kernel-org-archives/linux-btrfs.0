From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Block size limited to Linux page size?
Date: Tue, 3 Jun 2008 21:26:27 -0400
Message-ID: <20080604012627.GB7805@think.oraclecorp.com>
References: <38655.143.166.255.40.1212512274.squirrel@tomslinux.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Thomas King <kingttx@tomslinux.homelinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <38655.143.166.255.40.1212512274.squirrel@tomslinux.homelinux.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 03, 2008 at 11:57:54AM -0500, Thomas King wrote:
> To fill in one piece of information, I'm reading the maximum block size can be
> limited by the Linux page size, 4K on x86. Is this true in btrfs?

The kernel code supports much larger block sizes for metadata, but there
is a current limitation that the checksum error handling code may have
some races on larger block sizes.

So, the default is the same as the page size, but larger sizes will soon
work again (once better btree locking code is in place).

-chris
