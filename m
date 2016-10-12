Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from startkeylogger.hungrycats.org ([207.192.69.118]:39197 "EHLO
        neville.hungrycats.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751972AbcJLCeW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 22:34:22 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: [PATCH] btrfs: fix silent data corruption while reading compressed inline extents
Date: Tue, 11 Oct 2016 22:28:48 -0400
Message-Id: <1476239328-24649-1-git-send-email-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

rsync -S causes a large number of small writes separated by small seeks
to form sparse holes in files that contain runs of zero bytes.  Rarely,
this can lead btrfs to write a file with a compressed inline extent
followed by other data, like this:

Filesystem type is: 9123683e
File size of /try/./30/share/locale/nl/LC_MESSAGES/tar.mo is 61906 (16 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..    4095:          0..      4095:   4096:             encoded,not_aligned,inline
   1:        1..      15:     331372..    331386:     15:          1: last,encoded,eof
/try/./30/share/locale/nl/LC_MESSAGES/tar.mo: 2 extents found

The inline extent size is less than the page size, so the ram_bytes field
in the extent is smaller than 4096.  The difference between ram_bytes and
the end of the first page of the file forms a small hole.  Like any other
hole, the correct value of each byte within the hole is zero.

When the inline extent is not compressed, btrfs_get_extent copies the
inline extent data and then memsets the remainder of the page to zero.
There is no corruption in this case.

When the inline extent is compressed, uncompress_inline uses the
ram_bytes field from the extent ref as the size of the uncompressed data.
ram_bytes is smaller than the page size, so the remainder of the page
(i.e. the bytes in the small hole) is uninitialized memory.  Each time the
extent is read into the page cache, userspace may see different contents.

Fix this by zeroing out the difference between the size of the
uncompressed inline extent and PAGE_CACHE_SIZE in uncompress_inline.

Only bytes within the hole are affected, so affected files can be read
correctly with a fixed kernel.  The corruption happens after IO and
checksum validation, so the corruption is never reported in dmesg or
counted in dev stats.

The bug is at least as old as 3.5.7 (the oldest kernel I can conveniently
test), and possibly much older.

The code may not be correct if the extent is larger than a page, so add
a WARN_ON for that case.

To reproduce the bug, run this on a 3072M kvm VM:

	#!/bin/sh
	# Use your favorite block device here
	blk=/dev/vdc

	# Create test filesystem and mount point
	mkdir -p /try
	mkfs.btrfs -dsingle -mdup -O ^extref,^skinny-metadata,^no-holes -f "$blk" || exit 1
	mount -ocompress-force,flushoncommit,max_inline=8192,noatime "$blk" /try || exit 1

	# Create a few inline extents in larger files.
	# Multiple processes seem to be necessary.
	y=/usr; for x in $(seq 10 19); do rsync -axHSWI "$y/." "$x"; y="$x"; done &
	y=/usr; for x in $(seq 20 29); do rsync -axHSWI "$y/." "$x"; y="$x"; done &
	y=/usr; for x in $(seq 30 39); do rsync -axHSWI "$y/." "$x"; y="$x"; done &
	y=/usr; for x in $(seq 40 49); do rsync -axHSWI "$y/." "$x"; y="$x"; done &
	wait

	# Make a list of the files with inline extents
	touch /try/list
	find -type f -size +4097c -exec sh -c 'for x; do if filefrag -v "$x" | sed -n "4p" | grep -q "inline"; then echo "$x" >> list; fi; done' -- {} +

	# Check the inline extents to see if they change as they are read multiple times
        while read -r x; do
                sum="$(sha1sum "$x")"
                for y in $(seq 0 99); do
                        sysctl vm.drop_caches=1
                        sum2="$(sha1sum "$x")"
                        if [ "$sum" != "$sum2" ]; then
                                echo "Inconsistent reads from '$x'"
                                exit 1
                        fi
                done
        done < list

The reproducer may need to run up to 20 times before it finds a
corruption.

Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
---
 fs/btrfs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e6811c4..34f9c80 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6791,6 +6791,12 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	max_size = min_t(unsigned long, PAGE_SIZE, max_size);
 	ret = btrfs_decompress(compress_type, tmp, page,
 			       extent_offset, inline_size, max_size);
+	WARN_ON(max_size > PAGE_SIZE);
+	if (max_size < PAGE_SIZE) {
+		char *map = kmap(page);
+		memset(map + max_size, 0, PAGE_SIZE - max_size);
+		kunmap(page);
+	}
 	kfree(tmp);
 	return ret;
 }
-- 
2.1.4

