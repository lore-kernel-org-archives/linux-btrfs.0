From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 4/4] xfstests: Changed test 079 to be generic for all
 filesystems
Date: Sat, 30 Jul 2011 10:28:54 -0400
Message-ID: <20110730142854.GB31200@infradead.org>
References: <cover.1311953979.git.sbehrens@giantdisaster.de>
 <d63d92aa14e5fa81b4a40d0903001e70f7da9249.1311953979.git.sbehrens@giantdisaster.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <d63d92aa14e5fa81b4a40d0903001e70f7da9249.1311953979.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 29, 2011 at 06:07:01PM +0200, Stefan Behrens wrote:
> Changed the test 079 to be generic for all filesystems and to be
> executed for all filesystems.
> In src/t_immutable.c which is compiled for Linux only, replaced the
> old style XFS and ext2 specific code for setting the append-only and
> immutable flags by generic code that makes use of the
> ioctl(FS_IOC_SETFLAGS) and ioctl(FS_IOC_GETFLAGS).
> Therefore the check for the specific filesystem type was removed.
> FS_IOC_GETFLAGS/FS_IOC_SETFLAGS is always used. This code is inside an
> '#ifdef FS_IOC_SETFLAGS' block in order to never fail compilation.
> Without support for FS_IOC_SETFLAGS, the test completes with _notrun.

A little nitpicking for the subject again, I'd rather see something like:

	xfstests: make t_immutable and 079 filesystem-agnostic

> +$timmutable -c $SCRATCH_MNT/$seq >$tmp.out 2>&1
> +if grep -q 'Operation not supported' $tmp.out
> +then

if grep -q 'Operation not supported' $tmp.out; then

please

