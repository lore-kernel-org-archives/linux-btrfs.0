Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:47100 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751204AbeDQT5o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 15:57:44 -0400
Received: by mail-wr0-f173.google.com with SMTP id d1so38740969wrj.13
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Apr 2018 12:57:44 -0700 (PDT)
To: Grub-devel@gnu.org
Reply-To: kreijack@inwind.it
From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [RFC] Add support for BTRFS raid5/6 to GRUB
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <2708f56e-1dac-481e-af8a-d81066df8b42@gmail.com>
Date: Tue, 17 Apr 2018 21:57:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

Below you can find a patch to add support for accessing files from grub in a RAID5/6 btrfs filesystem. This is a RFC because it is missing the support for recovery (i.e. if some devices are missed). In the next days (weeks ?) I will extend this patch to support also this case.

Comments are welcome.

BR
G.Baroncelli


---

commit 8c80a1b7c913faf50f95c5c76b4666ed17685666
Author: Goffredo Baroncelli <kreijack@inwind.it>
Date:   Tue Apr 17 21:40:31 2018 +0200

    Add initial support for btrfs raid5/6 chunk

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index be195448d..4c5632acb 100644
--- a/grub-core/fs/btrfs.c
+++ b/grub-core/fs/btrfs.c
@@ -119,6 +119,8 @@ struct grub_btrfs_chunk_item
 #define GRUB_BTRFS_CHUNK_TYPE_RAID1         0x10
 #define GRUB_BTRFS_CHUNK_TYPE_DUPLICATED    0x20
 #define GRUB_BTRFS_CHUNK_TYPE_RAID10        0x40
+#define GRUB_BTRFS_CHUNK_TYPE_RAID5         0x80
+#define GRUB_BTRFS_CHUNK_TYPE_RAID6        0x100
   grub_uint8_t dummy2[0xc];
   grub_uint16_t nstripes;
   grub_uint16_t nsubstripes;
@@ -764,6 +766,39 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 	      stripe_offset = low + chunk_stripe_length
 		* high;
 	      csize = chunk_stripe_length - low;
+	      break;
+	    }
+	  case GRUB_BTRFS_CHUNK_TYPE_RAID5:
+	  case GRUB_BTRFS_CHUNK_TYPE_RAID6:
+	    {
+	      grub_uint64_t nparities;
+	      grub_uint64_t parity_pos;
+	      grub_uint64_t stripe_nr, high;
+	      grub_uint64_t low;
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
+	      stripe_nr = grub_divmod64 (off, chunk_stripe_length, &low);
+
+	      high = grub_divmod64 (stripe_nr, nstripes - nparities, &stripen);
+	      grub_divmod64 (high+nstripes-nparities, nstripes, &parity_pos);
+	      grub_divmod64 (parity_pos+nparities+stripen, nstripes, &stripen);
+
+	      stripe_offset = low + chunk_stripe_length * high;
+	      csize = chunk_stripe_length - low;
+
 	      break;
 	    }
 	  default:


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
