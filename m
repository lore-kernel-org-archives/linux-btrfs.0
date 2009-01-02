From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: Btrfs for mainline
Date: Sat, 03 Jan 2009 01:37:55 +0900 (JST)
Message-ID: <20090103.013755.42849152.ryusuke@osrg.net>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	<20081231104533.abfb1cf9.akpm@linux-foundation.org>
	<1230765549.7538.8.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1230765549.7538.8.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
On Wed, 31 Dec 2008 18:19:09 -0500, Chris Mason <chris.mason@oracle.com> wrote:
> 
> This has only btrfs as a module and would be the fastest way to see
> the .c files.  btrfs doesn't have any changes outside of fs/Makefile and
> fs/Kconfig

I found some overlapping (or cloned) functions in
btrfs-unstable.git/fs/btrfs, for example:

 - Declarations to apply hardware crc32c in fs/btrfs/crc32c.h:
   The same code is found in arch/x86/crypto/crc32c-intel.c

 - btrfs_wait_on_page_writeback_range() and btrfs_fdatawrite_range():
   These are clones of wait_on_page_writeback_range() and
   __filemap_fdatawrite_range() respectively, and can be removed if they
   are just exported.

 - Copies of add_to_page_cache_lru() found in compression.c and extent_io.c
   (can be replaced if it's exported)

How about including patches to resolve these in the btrfs kernel tree
(or patchset to be posted) ?

In addition, there seem to be well-separated reusable routines such as
async-thread (enhanced workqueue) and extent_map.  Do you intend to
move these into lib/ or so?

I also tried scripts/checkpatch.pl against btrfs, and it has detected
45 ERRORs and 93 WARNINGs.  I think it's a good opportunity to clean
up these violations.


With regards,
Ryusuke Konishi
