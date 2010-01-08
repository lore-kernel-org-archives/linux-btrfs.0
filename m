From: jim owens <jowens@hp.com>
Subject: [RFC PATCH 00/01] Btrfs: add decompression code for direct I/O.
Date: Fri, 08 Jan 2010 12:10:18 -0500
Message-ID: <4B4766FA.3090004@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The following patch has the btrfs code changes/additions needed
to support reading compressed data in my directio code.

The code always runs in process context.

The callbacks:

int (*get_next_in)(struct bio_vec *vec, struct btrfs_inflate *icb);
int (*get_next_out)(struct bio_vec *vec, struct btrfs_inflate *icb);

track where we currently are in the compressed pages (get_next_in) and
uncompressed output user pages (get_next_out).  (in) is always full pages,
(out) may be partial pages with offsets as the user input to direct I/O is
a set of memory vectors/lengths.

The callback:

void (*done_with_out)(struct bio_vec *vec, struct btrfs_inflate *icb);

is currently coded in directio as:

static void btrfs_dio_done_with_out(struct bio_vec *ovec,
				struct btrfs_inflate *icb)
{
	flush_dcache_page(ovec->bv_page);
	if (!PageCompound(ovec->bv_page))
		set_page_dirty_lock(ovec->bv_page);
	page_cache_release(ovec->bv_page);
}

Again, this patch has no value without my directio code.

jim
