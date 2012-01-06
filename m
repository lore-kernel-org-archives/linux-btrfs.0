From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Fri, 6 Jan 2012 18:57:13 +0100
Message-ID: <20120106175713.GS7322@twin.jikos.cz>
References: <cover.1301542804.git.larry@elder-gods.org> <20110401133405.GA17956@infradead.org> <1301665083-sup-3969@think> <201112222324.16871.chris@csamuel.org> <4F06E33C.8090104@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F06E33C.8090104@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 06, 2012 at 02:04:12PM +0200, Konstantinos Skarlatos wrote:
> Me too wants cp --reflink across subvolumes. Please make this feature 
> available to us, as its a "poor man's dedupe" and would give big space 
> savings for many use cases.

The simple case of 'cp --reflink' works fine, the only remaining case is
the unimplemented clone of part of a compressed inline extent. And it has
to be:
  * at least 2 blocks uncompressed
  * the cloned range does not span the whole extent

The ioctl needs ranges and length aligned up to blocksize, ie. 4096,
cloning of short inline extents work.

The missing case can be reproduced with this:

---
#!/bin/sh

# assume, that fs is mounted with compression on
src=test-clone-compressed-inline
dd if=/dev/zero of="$src" bs=1K count=3 oflag=sync
sync
filefrag -vbs "$src"
clone_range "$src" 4096 4096 subvol2/"$src"-dest0 0
clone_range "$src" 4096 4096 subvol2/"$src"-dest4096 4096
clone_range "$src" 4096 4096 subvol2/"$src"-dest8192 8192

---

$ ./test-clone-range-inline
3+0 records in
3+0 records out
3072 bytes (3.1 kB) copied, 0.0487466 s, 63.0 kB/s
Filesystem type is: 9123683e
File size of test-clone-compressed-inline is 3072 (3 blocks, blocksize 1024)
 ext logical physical expected length flags
   0       0        0            4096 not_aligned,inline,eof
test-clone-compressed-inline: 1 extent found
clone_range test-clone-compressed-inline 3 4096~4096 to subvol2/test-clone-compressed-inline-dest0 4 0 = -1 Invalid argument
clone_range test-clone-compressed-inline 3 4096~4096 to subvol2/test-clone-compressed-inline-dest4096 4 4096 = -1 Invalid argument
clone_range test-clone-compressed-inline 3 4096~4096 to subvol2/test-clone-compressed-inline-dest8192 4 8192 = -1 Invalid argument

---

This does not work on a single subvolume, so extending clone to span
subvolumes should not break anything that hasn't been broken already.


david
