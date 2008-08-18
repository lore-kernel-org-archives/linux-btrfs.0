From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] rewrite btrfs_readdir()
Date: Mon, 18 Aug 2008 20:08:03 +0100
Message-ID: <1219086483.3184.403.camel@pmac.infradead.org>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
	 <1218979817.3184.296.camel@pmac.infradead.org>
	 <1218982640.3184.307.camel@pmac.infradead.org>
	 <1218989400.3184.315.camel@pmac.infradead.org>
	 <1219085216.14063.9.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219085216.14063.9.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-08-18 at 14:46 -0400, Chris Mason wrote:
> It can happen today for the tree of tree roots (directory of
> subvolumes and named snapshots).  It happens when the name hashes
> collide.  For real directories we use the sequence number index
> instead of the name hash index, so it normally won't happen.

Ok, that's fine then. I've removed the WARN_ON() from the patch in my
git tree. This is what I have outstanding for you at
git://git.infradead.org/users/dwmw2/btrfs-kernel-unstable:

Balaji Rao (2):
      Introduce btrfs_iget helper
      NFS support for btrfs - v3

David Woodhouse (7):
      Implement our own copy of the nfsd readdir hack, for older kernels
      Discard sector data in __free_extent()
      Remove special cases for "." and ".."
      Minor cleanup of btrfs_real_readdir()
      Optimise NFS readdir hack slightly; don't call readdir() again when done
      Fill f_fsid field in btrfs_statfs()
      Mask root object ID into f_fsid in btrfs_statfs()

 Makefile      |    2 +-
 compat.h      |   17 ++++
 ctree.h       |    2 +
 export.c      |  208 +++++++++++++++++++++++++++++++++++++++++++++++
 export.h      |   19 +++++
 extent-tree.c |   25 ++++++
 inode.c       |  250 +++++++++++++++++++++++++++++++++++++-------------------
 super.c       |   12 +++
 8 files changed, 449 insertions(+), 86 deletions(-)

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



