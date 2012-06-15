Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:30191 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440Ab2FOTtd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 15:49:33 -0400
Date: Fri, 15 Jun 2012 22:49:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jbacik@redhat.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: Btrfs: add support for multiple csum algorithms
Message-ID: <20120615194922.GA2278@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef Bacik,

The patch 607d432da054: "Btrfs: add support for multiple csum 
algorithms" from Dec 2, 2008, leads to the following warning:
fs/btrfs/disk-io.c:298 csum_tree_block()
	 error: memcpy() '&found' too small (4 vs 9)

fs/btrfs/disk-io.c
   284          if (csum_size > sizeof(inline_result)) {
   285                  result = kzalloc(csum_size * sizeof(char), GFP_NOFS);
   286                  if (!result)
   287                          return 1;
   288          } else {
   289                  result = (char *)&inline_result;
   290          }
   291  
   292          btrfs_csum_final(crc, result);
   293  
   294          if (verify) {
   295                  if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
   296                          u32 val;
   297                          u32 found = 0;
   298                          memcpy(&found, result, csum_size);
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Before that commit we used to memcpy() 4 bytes and it was fine, but now
csum_size can be larger than 4 bytes and there is a potential for
memory corruption.

   299  
   300                          read_extent_buffer(buf, &val, 0, csum_size);
                                                        ^^^^
Smatch complains that "val" is too small as well.

   301                          printk_ratelimited(KERN_INFO "btrfs: %s checksum verify "
   302                                         "failed on %llu wanted %X found %X "
   303                                         "level %d\n",
   304                                         root->fs_info->sb->s_id,
   305                                         (unsigned long long)buf->start, val, found,
   306                                         btrfs_header_level(buf));
   307                          if (result != (char *)&inline_result)
   308                                  kfree(result);
   309                          return 1;

regards,
dan carpenter

