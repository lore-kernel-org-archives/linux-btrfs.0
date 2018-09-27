Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61355C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BD17204FD
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:35:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="tvTDwmDM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BD17204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbeI1Ayr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:54:47 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:54811 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727404AbeI1Ayr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:54:47 -0400
Received: from venice.bhome ([84.223.214.84])
        by smtp-34.iol.local with ESMTPA
        id 5b7zg9O8gq9Au5b82gnnll; Thu, 27 Sep 2018 20:35:11 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1538073311; bh=RayBzk9LTtuweLgKHLNpPxFO2WXNzLkV3EeK30aD8Vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=tvTDwmDMHK295zMzTOvq3I2f9jCOHjixEoxUumQ7JGFbT1I3+JGJIx7JPN6sBpjMO
         +SAzs+R+ApuBoql8nhdt3cgnqPv6baViiM1hasA05Iz8uwxHvUr19aXGUMGSHqwFdS
         y1XT2MRTS1yasN2GL9j16L0TT1A8i9661a1L+QEd6pMvqxG2fNz4MNtZYiPEp8TC0K
         PNTB+1RykSK9TIzQOQfy4jGXmSBORT8pQKVqWD5Y/4aU/3TR5vAGkhj6piV6xsAaVQ
         8AHwaFJJaSKvgruRt7rGNdJ61xEUNpbWwcZM2pDUSp2dyzmuVbltk81IDjNnie/URH
         tNA3xnhmiyGBg==
X-CNFS-Analysis: v=2.3 cv=OoWeNB3t c=1 sm=1 tr=0
 a=8ZjQKV1YVqnHfcWpVNE1cw==:117 a=8ZjQKV1YVqnHfcWpVNE1cw==:17
 a=OllNMU2MDXtvIN_fP3gA:9 a=_MINcdyXgKc-cRrr:21 a=4LBASU1KxRSeJgBc:21
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/9] btrfs: Add support for reading a filesystem with a RAID 5 or RAID 6 profile.
Date:   Thu, 27 Sep 2018 20:34:56 +0200
Message-Id: <20180927183504.18078-2-kreijack@libero.it>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927183504.18078-1-kreijack@libero.it>
References: <20180927183504.18078-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfECYO9/K1qboYXbb8hqMIdnfTMpldB55oi6MUAjXsv4RERKCmxiaLqUAcOfZhnI1+iHitiS+FZPxaCF1eNN6xfdbVWTuFXkiJVho9P/PWBgJE37Tzlxj
 IhxJWXsFdzkjLXZMNmfA2s8FmzL/RBfA9mBylIciLJQn5pxCXdLelGkQ0h07LzarlZKVYvJ4MMqwcXNO76mz2gPrbrS/iiGzSyWJMhsVNQCfzE6OqHJw007V
 Kv3OAQbNnUWJ4Xa3Os5mkaPEaOOxDUuGx7R2pbX217k=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 grub-core/fs/btrfs.c | 74 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
index be195448d..9bc6d399d 100644
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
@@ -764,6 +766,78 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
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
+	       * A RAID 6 layout consists of several stripes spread on the
+	       * disks, following a layout like the one below
+	       *
+	       *   Disk0  Disk1  Disk2  Disk3
+	       *
+	       *    A1     B1     P1     Q1
+	       *    Q2     A2     B2     P2
+	       *    P3     Q3     A3     B3
+	       *  [...]
+	       *
+	       *  Note that the placement of the parities depends on row index.
+	       *  Pay attention that the BTRFS terminolgy may be different
+	       *  from others RAID implementation (e.g. lvm/dm or md). In BTRFS
+	       *  a contiguous block of data of a disk (like A1) is called
+	       *  stripe.
+	       *  In the code below:
+	       *  - stripe_nr is the stripe number without the parities
+	       *    (A1 = 0, B1 = 1, A2 = 2, B2 = 3, ...),
+	       *  - high is the row number (0 for A1...Q1, 1 for Q2...P2, ...),
+	       *  - stripen is the disk number in a row (0 for A1,Q2,P3, 1 for
+	       *    B1...),
+	       *  - off is the logical address to read,
+	       *  - chunk_stripe_length is the size of a stripe (typically 64k),
+	       *  - nstripes is the number of disks of a row
+	       *  - low is the offset of the data inside a stripe,
+	       *  - stripe_offset is the data offset in an array,
+	       *  - csize is the "potential" data to read. It will be reduced to
+	       *    size if the latter is smaller.
+	       *  - nparities is the number of parities (1 for RAID5, 2 for
+	       *    RAID6); used only in RAID5/6 code.
+	       */
+	      stripe_nr = grub_divmod64 (off, chunk_stripe_length, &low);
+
+	      /*
+	       * stripen is computed without the parities (0 for A1, A2, A3...
+	       * 1 for B1, B2...).
+	       */
+	      high = grub_divmod64 (stripe_nr, nstripes - nparities, &stripen);
+
+	      /*
+	       * the stripes are spread across the disks, each row their
+	       * position is shifted by 1 place. So to compute the real disk
+	       * number occuped by a stripe, we need to sum also the
+	       * "row number" in modulo nstripes (0 for A1, 1 for A2, 2 for
+	       * A3....).
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

