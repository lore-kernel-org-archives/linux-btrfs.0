From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: BUG: Bonnie++ stresstest with parallel balanceing chunks across all devices
Date: Fri, 27 Feb 2009 00:06:02 +0300
Message-ID: <20090226210602.GB6215@ioremap.net>
References: <20090226203608.GB4024@256bit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Marc Schoechlin <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090226203608.GB4024@256bit.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 26, 2009 at 09:36:08PM +0100, Marc Schoechlin (linux-btrfs@vger.kernel.org) wrote:
> [  359.658789] btrfs allocation failed flags 68, wanted 4096
> [  359.659966] space_info has 932491264 free, is full
> [  359.660007] block group 14802485248 has 936378368 bytes, 3522560 used 364544 pinned 0 reserved
> [  359.660076] 87 blocks of free space at or bigger than bytes is
> [  359.660226] ------------[ cut here ]------------
> [  359.660273] kernel BUG at fs/btrfs/extent-tree.c:3190!

Looks like a no-space-left feature.

-- 
	Evgeniy Polyakov
