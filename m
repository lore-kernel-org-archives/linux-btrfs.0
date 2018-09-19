Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:60002 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731419AbeITAUY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 20:20:24 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: grub-devel@gnu.org
Cc: Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/9] btrfs: Add support for reading a filesystem with a RAID 5 or RAID 6 profile.
Date: Wed, 19 Sep 2018 20:40:32 +0200
Message-Id: <20180919184040.22540-2-kreijack@libero.it>
In-Reply-To: <20180919184040.22540-1-kreijack@libero.it>
References: <20180919184040.22540-1-kreijack@libero.it>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 grub-core/fs/btrfs.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index be195448d..56c42746d 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -119,6 +119,8 @@ struct grub_btrfs_chunk_item
 #define GRUB_BTRFS_CHUNK_TYPE_RAID1         0x10
 #define GRUB_BTRFS_CHUNK_TYPE_DUPLICATED    0x20
 #define GRUB_BTRFS_CHUNK_TYPE_RAID10        0x40
+#define GRUB_BTRFS_CHUNK_TYPE_RAID5         0x80
+#define GRUB_BTRFS_CHUNK_TYPE_RAID6         0x100
   grub_uint8_t dummy2[0xc];
   grub_uint16_t nstripes;
   grub_uint16_t nsubstripes;
@@ -764,6 +766,70 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 	      stripe_offset = low + chunk_stripe_length
 		* high;
 	      csize = chunk_stripe_length - low;
+	      break;
+	    }
+	  case GRUB_BTRFS_CHUNK_TYPE_RAID5:
+	  case GRUB_BTRFS_CHUNK_TYPE_RAID6:
+	    {
+	      grub_uint64_t nparities, block_nr, high, low;
+
+	      redundancy = 1;	/* no redundancy for now */
+
+	      if (grub_le_to_cpu64 (chunk->type) & GRUB_BTRFS_CHUNK_TYPE_RAID5)
+		{
+		  grub_dprintf ("btrfs", "RAID5\n");
+		  nparities = 1;
+		}
+	      else
+		{
+		  grub_dprintf ("btrfs", "RAID6\n");
+		  nparities = 2;
+		}
+
+	      /*
+	       * A RAID 6 layout consists of several blocks spread on the disks.
+	       * The raid terminology is used to call all the blocks of a row
+	       * "stripe". Unfortunately the BTRFS terminology confuses block
+	       * and stripe.
+	       *
+	       *   Disk0  Disk1  Disk2  Disk3
+	       *
+	       *    A1     B1     P1     Q1
+	       *    Q2     A2     B2     P2
+	       *    P3     Q3     A3     B3
+	       *  [...]
+	       *
+	       *  Note that the placement of the parities depends on row index.
+	       *  In the code below:
+	       *  - block_nr is the block number without the parities
+	       *    (A1 = 0, B1 = 1, A2 = 2, B2 = 3, ...),
+	       *  - high is the row number (0 for A1...Q1, 1 for Q2...P2, ...),
+	       *  - stripen is the disk number (0 for A1,Q2,P3, 1 for B1...),
+	       *  - off is the logical address to read
+	       *  - chunk_stripe_length is the size of a block (typically 64k),
+	       *  - nstripes is the number of disks,
+	       *  - low is the offset of the data inside a stripe,
+	       *  - stripe_offset is the disk offset,
+	       *  - csize is the "potential" data to read. It will be reduced to
+	       *    size if the latter is smaller.
+	       */
+	      block_nr = grub_divmod64 (off, chunk_stripe_length, &low);
+
+	      /*
+	       * stripen is computed without the parities (0 for A1, A2, A3...
+	       * 1 for B1, B2...).
+	       */
+	      high = grub_divmod64 (block_nr, nstripes - nparities, &stripen);
+
+	      /*
+	       * stripen is recomputed considering the parities (0 for A1, 1 for
+	       * A2, 2 for A3....).
+	       */
+	      grub_divmod64 (high + stripen, nstripes, &stripen);
+
+	      stripe_offset = low + chunk_stripe_length * high;
+	      csize = chunk_stripe_length - low;
+
 	      break;
 	    }
 	  default:
-- 
2.19.0
