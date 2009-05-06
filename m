From: Raskin Michael <raskin@mccme.ru>
Subject: [BUG] fallocate behavior when crossing end-of-file
Date: Wed, 06 May 2009 17:03:12 +0400
Message-ID: <4A018A90.7050109@mccme.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

		Hello.
	I found the following bug in BtrFS:

	1. Create and open an empty file
	2. fallocate (fd, 0, 1)
	
Desired: something (probably, one block) is allocated/reserved for the
file. File length is set to 1 byte.

Actual: A block is allocated. File length is set to 1 block (4096
bytes). The rest of the file is filled with zeros.

	last_byte = min(extent_map_end(em), alloc_end);
	last_byte = (last_byte + mask) & ~mask;
	if (em->block_start == EXTENT_MAP_HOLE) {
		ret = prealloc_file_range(trans, inode, cur_offset,
				last_byte, locked_end + 1,
				alloc_hint, mode);

That part seems strange to me. You make an effort for block size to
divide last_byte. But last_byte should be
max(i_size_read(inode), offset+len)
- without any rounding.

Michael Raskin
