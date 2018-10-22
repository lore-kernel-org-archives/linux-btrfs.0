Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254A7C67863
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 17:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0B5320645
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 17:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="K6/RPAmG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0B5320645
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbeJWBtg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 21:49:36 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:52199 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728550AbeJWBtf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 21:49:35 -0400
Received: from venice.bhome ([94.38.16.140])
        by smtp-34.iol.local with ESMTPA
        id Ee1mgPeG98KmnEe1ngfjqr; Mon, 22 Oct 2018 19:30:07 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1540229408; bh=CUQsVc80lMhXUTtNLr7dJdbhnCqVLGPeIgG4l+HtXx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=K6/RPAmG3wfE6Go40eglHuwqlkmc0H+jaIYRDF8eR9toTeyOMth9uP0siAU5/E7Fj
         JNCPr3lw2bKHwPUFK3d3UyGUNO0fpy5GpILGzViFjg4t1MuB72cswhLfDrBFXILyA2
         kEHizh8igHY3dOrKXZ7cXYkAiSVszR0Nzd1+k4RbqvbEF4Swk/8ggk2zqcMQYQLv3F
         tk+VsGkrmC2wmfx0+9PN05fHXzKRkQH0SlNp47094i15wwD/6oU6e/KQXZXY9u9yOA
         iqhJZCBqH8Ij6sNfdSk7YHGzSq5Vxczg9fNa9eygGFwPmmDYGmnHcMIK7IjFA/ROPW
         SwIUJZ6bhCpmw==
X-CNFS-Analysis: v=2.3 cv=ZbLMyfdA c=1 sm=1 tr=0
 a=nqgIlLay6LNLiZJCVl9G2Q==:117 a=nqgIlLay6LNLiZJCVl9G2Q==:17 a=yPCof4ZbAAAA:8
 a=10E2XUvmTi6NHy_q8tMA:9 a=O12Uk9nZU-Ayzfzf:21 a=BXEPnZTIIX6eRtaI:21
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/9] btrfs: Add support for reading a filesystem with a RAID 5 or RAID 6 profile.
Date:   Mon, 22 Oct 2018 19:29:31 +0200
Message-Id: <20181022172938.7936-2-kreijack@libero.it>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181022172938.7936-1-kreijack@libero.it>
References: <20181022172938.7936-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfHqgJISiJS6fR51Hz35O38qAU8jUYCd2mJjZwGQXqLnn0oSVIrdq4xL/N1oHu5RaWXKhBDG2g33WOvfIQhz8nCztBY4TelCEE9R4D4V6NaZZcRC6OiIN
 NHlwiqryoAHta9tk86WAaS12ILtL2HQvqHFcOybCzoK8bPalDOibCl+Gsk4QE+7a/0npPpRJk9Usrq17L792ao2bFEPzvD5IqXn5X67WZ2JbmUhAi+1nztyF
 KvCFs62XgqPcB9H8xIhigY7THSiJd3z1ENgIUiT9Uug=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 grub-core/fs/btrfs.c | 73 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index be195448d..9122169aa 100644
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
@@ -764,6 +766,77 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
 	      stripe_offset = low + chunk_stripe_length
 		* high;
 	      csize = chunk_stripe_length - low;
+	      break;
+	    }
+	  case GRUB_BTRFS_CHUNK_TYPE_RAID5:
+	  case GRUB_BTRFS_CHUNK_TYPE_RAID6:
+	    {
+	      grub_uint64_t nparities, stripe_nr, high, low;
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
+	       * RAID 6 layout consists of several stripes spread over
+	       * the disks, e.g.:
+	       *
+	       *   Disk_0  Disk_1  Disk_2  Disk_3
+	       *     A0      B0      P0      Q0
+	       *     Q1      A1      B1      P1
+	       *     P2      Q2      A2      B2
+	       *
+	       * Note: placement of the parities depend on row number.
+	       *
+	       * Pay attention that the btrfs terminology may differ from
+	       * terminology used in other RAID implementations, e.g. LVM,
+	       * dm or md. The main difference is that btrfs calls contiguous
+	       * block of data on a given disk, e.g. A0, stripe instead of chunk.
+	       *
+	       * The variables listed below have following meaning:
+	       *   - stripe_nr is the stripe number excluding the parities
+	       *     (A0 = 0, B0 = 1, A1 = 2, B1 = 3, etc.),
+	       *   - high is the row number (0 for A0...Q0, 1 for Q1...P1, etc.),
+	       *   - stripen is the disk number in a row (0 for A0, Q1, P2,
+	       *     1 for B0, A1, Q2, etc.),
+	       *   - off is the logical address to read,
+	       *   - chunk_stripe_length is the size of a stripe (typically 64 KiB),
+	       *   - nstripes is the number of disks in a row,
+	       *   - low is the offset of the data inside a stripe,
+	       *   - stripe_offset is the data offset in an array,
+	       *   - csize is the "potential" data to read; it will be reduced
+	       *     to size if the latter is smaller,
+	       *   - nparities is the number of parities (1 for RAID 5, 2 for
+	       *     RAID 6); used only in RAID 5/6 code.
+	       */
+	      stripe_nr = grub_divmod64 (off, chunk_stripe_length, &low);
+
+	      /*
+	       * stripen is computed without the parities
+	       * (0 for A0, A1, A2, 1 for B0, B1, B2, etc.).
+	       */
+	      high = grub_divmod64 (stripe_nr, nstripes - nparities, &stripen);
+
+	      /*
+	       * The stripes are spread over the disks. Every each row their
+	       * positions are shifted by 1 place. So, the real disks number
+	       * change. Hence, we have to take into account current row number
+	       * modulo nstripes (0 for A0, 1 for A1, 2 for A2, etc.).
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
2.19.1

