Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46244 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab3IDIaJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 04:30:09 -0400
Received: by mail-pb0-f48.google.com with SMTP id ma3so7024272pbc.7
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 01:30:02 -0700 (PDT)
Subject: Input/output error in btrfs using a new deflate compatible compression algorithm
From: Yu Yao <yuyao0417@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <3C9C0927-B61E-4377-A634-AD085636D6EE@gmail.com>
Date: Wed, 4 Sep 2013 16:29:57 +0800
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a problem while replacing the zlib compression algorithm in btrfs
with another deflate compatible compression algorithm,
the new algorithm does not include zlib header, and it supports compression
only currently.

So I replace the zlib_deflate related logic in zlib_compress_pages with the
new method, and make minor changes in both zlib_decompress_biovec
and zlib_decompress: comment out the zlib header processing logic.

However, I will get the kernel dumped message like "bytes left 0 compress len
4096 nr 2" while trying to copy a lot of files from an ext3 partition to
the btrfs partition mounted with the option of replaced zlib compression. I
think it's printed by function
"btrfs_submit_compressed_write" of file compression.c


I traced the code, and guessed the zero byte was due to the zero value of
async_extent->compressed_size in function
submit_compressed_extents of file inode.c


And I think the zero compression_size in async_extent is inserted
by add_async_extent in function compress_file_range of file inode.c,
there're 2 places of invocation of add_async_extent, and I checked it's
always caused by the second one.


In addition, if I enable the checksum option, a warning will be dumped due
to the only WARN_ON in function
btrfs_add_ordered_sum of file ordered-data.c

And furthermore, when I try to copy the files being copied from the ext3
partition previously from btrfs partition to the ext3 partition, I will get
Input/Output error while I think btrfs tries to read data and with
decompressing.

Thanks
Yu
