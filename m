From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs-progs (unstable) failing to compile successfully
Date: Sat, 28 Aug 2010 10:09:43 -0400
Message-ID: <20100828140943.GF2638@dhcp231-156.rdu.redhat.com>
References: <AANLkTikMDSzNejaEhJdjqxVdiX4GhTuePYnXh4TbhQ2c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, Josef Bacik <josef@redhat.com>,
	linux-btrfs@vger.kernel.org
To: Mat <jackdachef@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikMDSzNejaEhJdjqxVdiX4GhTuePYnXh4TbhQ2c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 28, 2010 at 01:10:20PM +0200, Mat wrote:
> Hi guys,
> 
> when trying to compile btrfs-progs from the unstable repo
> (git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git)
> via the live-ebuild (on Gentoo)
> 
> it keeps on failing for me no matter what (sane) CFLAGS or LDFLAGS I use:
>

You will need this patch

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03891.html

Thanks,

Josef 
