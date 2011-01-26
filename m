From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [RFC][PATCH] Btrfs: New inode number allocator
Date: Wed, 26 Jan 2011 19:30:01 +0100
Message-ID: <4D406829.3040700@libero.it>
References: <4D3F7E7C.6080903@cn.fujitsu.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Li Zefan <lizf@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D3F7E7C.6080903@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/26/2011 02:53 AM, Li Zefan wrote:
> Here comes the compatability issue. It's fine to mount old btrfs, because
> we'll just use the original way to find free ino. But we can't mount new btrfs
> in older kernels, because the OFFSET makes highest objectid overflow when it
> is cast to unsigned long in 32bits system.
> 
> We can store ino extents to a seperate btree, and then the new btrfs can
> be mounted in older kernels, but another problem will arise when remounting it
> in new kernels - creating new files will probably fail (but not oops)
> because the ino extent items are not consistent with inode items.
> 
> If the above behavior (failing to create files) is not acceptable, we'll
> have to add an incompat flag.

I can't comment the patch from a technical point of view. However I want
to add a my comment about the compatibility issues.

I remember that Linus was not happy about a filesystem which is not
compatible when the the kernel version decrease. IIRC during the switch
from ext3 to ext4 there were some issues during a git bis-sect process.

So my suggestions are:
- don't allow that an automatic switch to the new inode allocation
policy. It should be the user to force this switch ( via a mount option
for example)
- in case the performance regression are noticeable, allow the user to
use the old policy, which, if I understood correctly, work fine on a 64
bit system [*].

Regards
G.Baroncelli


[*] Supposing to create continuously 1000 file per sec, it needs
2^64/1000 sec = ~ 573.000.000 years to exhaust all the available inode
numbers.

