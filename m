Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18AEC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 13:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A40AE2086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 13:56:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JymWNFdX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A40AE2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gelma.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbeK1AyW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 19:54:22 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36991 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbeK1AyV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 19:54:21 -0500
Received: by mail-wm1-f68.google.com with SMTP id g67so8839202wmd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 05:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4aQujJUGUylbrhe4fCg97LMNFiXvbzk2NCHeL6QGya4=;
        b=JymWNFdXzzGvNgqVp+nsBENNGnm/ctOEAifTHvF97l3Wq9DNVd7s3a5RBm6I04mjM6
         k+Y0y25pu0x/fSrxeVae3SyZsEixxoArn7Mg241hNtvfePQDVukw8PQEq81Tl8apaezO
         9uPGpIrIiXvsQ5bJQZ6JWiqbNUIljsfooMmhJZts8R6RCVDZxa56KDkVR/SQgtLCuJ7i
         lw5bwQn6SyRL2f5b4xDHAAjqAgP4bFUiOZ9pGhYtABVPzyTPkTQNLzxAja4eIhawvk7Y
         4wEPEkYRIt9HrbDwOVKpmfRjNsNFLgbqbd78KGmon1Myn4qK+q8cW6t4ZoQOqUBrVi8A
         L01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=4aQujJUGUylbrhe4fCg97LMNFiXvbzk2NCHeL6QGya4=;
        b=lYZooTpvtR4AHqLtTKaIqSvUtm3Aem1T0kM6eWgJcYDwVmEJIdTU4IwRVXy+g9i9M0
         3w/ijb2wjrHBTATyEfudNirMjA1rWTxO6pEkMc+ZkG9N4NKjQnr/kOewKV2eMc7CgHlh
         Ilcsa0evqQW4wyqLAFKjFZ/mRgSVfQto8qYJ/moQuHpewMNYpucbfxM2lsijLl5EtIT5
         HOdN83N3MWKzyQU89RptxHyq2gPp9Ec7NlgiNRpFBDtI3ERUhga0xYdrQUluoyFqIzv9
         pE130AgMtsOewdN5dv2t7uiFiqnsmEfnzi6TPg3Bqz5Cqpza0YRj8yJRwh77JacA9nNQ
         0iBQ==
X-Gm-Message-State: AA+aEWb+WmjtImwQxZVfU8aqoc0BTOVgQqNGlZjfjgomwOvPcqELaN93
        oVsFmUaeO3sEzkEN0H3+MmM93EO7zu0=
X-Google-Smtp-Source: AFSGD/UwFKp2OjrJQKYKJuahPnej+k85gKdsNPq6tXkMjY0vJgKW2Z8qyS0dbTb1dJgyHegGhDsqRg==
X-Received: by 2002:a1c:c2d5:: with SMTP id s204mr17457127wmf.144.1543326979449;
        Tue, 27 Nov 2018 05:56:19 -0800 (PST)
Received: from localhost.localdomain ([185.197.228.4])
        by smtp.gmail.com with ESMTPSA id y13sm2827184wrw.85.2018.11.27.05.56.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Nov 2018 05:56:18 -0800 (PST)
From:   Andrea Gelmini <andrea.gelmini@gelma.net>
To:     linux-btrfs@vger.kernel.org
Cc:     Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH] Fix typos in docs (second try...)
Date:   Tue, 27 Nov 2018 14:56:15 +0100
Message-Id: <20181127135615.22912-1-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 2.20.0.rc1.28.g8a4ee09a8a
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 Documentation/DocConventions          | 4 ++--
 Documentation/ReleaseChecklist        | 4 ++--
 Documentation/btrfs-man5.asciidoc     | 8 ++++----
 Documentation/btrfs-property.asciidoc | 2 +-
 Documentation/btrfs-qgroup.asciidoc   | 4 ++--
 Documentation/mkfs.btrfs.asciidoc     | 2 +-
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/DocConventions b/Documentation/DocConventions
index e84ed7a..969209c 100644
--- a/Documentation/DocConventions
+++ b/Documentation/DocConventions
@@ -23,7 +23,7 @@ Quotation in subcommands:
 - command reference: bold *btrfs fi show*
 - section references: italics 'EXAMPLES'
 
-- argument name in option desciption: caps in angle brackets <NAME>
+- argument name in option description: caps in angle brackets <NAME>
   - reference in help text: caps NAME
     also possible: caps italics 'NAME'
 
@@ -34,6 +34,6 @@ Quotation in subcommands:
   - optional parameter with argument: [-p <path>]
 
 
-Refrences:
+References:
 - full asciidoc syntax: http://asciidoc.org/userguide.html
 - cheatsheet: http://powerman.name/doc/asciidoc
diff --git a/Documentation/ReleaseChecklist b/Documentation/ReleaseChecklist
index d8bf50c..ebe251d 100644
--- a/Documentation/ReleaseChecklist
+++ b/Documentation/ReleaseChecklist
@@ -4,7 +4,7 @@ Release checklist
 Last code touches:
 
 * make the code ready, collect patches queued for the release
-* look to mailinglist for any relevant last-minute fixes
+* look to mailing list for any relevant last-minute fixes
 
 Pre-checks:
 
@@ -31,7 +31,7 @@ Release:
 
 Post-release:
 
-* write and send announcement mail to mailinglist
+* write and send announcement mail to mailing list
 * update wiki://Main_page#News
 * update wiki://Changelog#btrfs-progs
 * update title on IRC
diff --git a/Documentation/btrfs-man5.asciidoc b/Documentation/btrfs-man5.asciidoc
index 448710a..4a269e2 100644
--- a/Documentation/btrfs-man5.asciidoc
+++ b/Documentation/btrfs-man5.asciidoc
@@ -156,7 +156,7 @@ under 'nodatacow' are also set the NOCOW file attribute (see `chattr`(1)).
 NOTE: If 'nodatacow' or 'nodatasum' are enabled, compression is disabled.
 +
 Updates in-place improve performance for workloads that do frequent overwrites,
-at the cost of potential partial writes, in case the write is interruted
+at the cost of potential partial writes, in case the write is interrupted
 (system crash, device failure).
 
 *datasum*::
@@ -171,7 +171,7 @@ corresponding file attribute (see `chattr`(1)).
 NOTE: If 'nodatacow' or 'nodatasum' are enabled, compression is disabled.
 +
 There is a slight performance gain when checksums are turned off, the
-correspoinding metadata blocks holding the checksums do not need to updated.
+corresponding metadata blocks holding the checksums do not need to be updated.
 The cost of checksumming of the blocks in memory is much lower than the IO,
 modern CPUs feature hardware support of the checksumming algorithm.
 
@@ -185,7 +185,7 @@ missing, for example if a stripe member is completely missing from RAID0.
 Since 4.14, the constraint checks have been improved and are verified on the
 chunk level, not an the device level. This allows degraded mounts of
 filesystems with mixed RAID profiles for data and metadata, even if the
-device number constraints would not be satisfied for some of the prifles.
+device number constraints would not be satisfied for some of the profiles.
 +
 Example: metadata -- raid1, data -- single, devices -- /dev/sda, /dev/sdb
 +
@@ -649,7 +649,7 @@ inherent limit of btrfs is 2^64^ (16 EiB) but the linux VFS limit is 2^63^ (8 Ei
 
 maximum number of subvolumes::
 2^64^ but depends on the available metadata space, the space consumed by all
-subvolume metadata includes bookeeping of the shared extents can be large (MiB,
+subvolume metadata includes bookkeeping of the shared extents can be large (MiB,
 GiB)
 
 maximum number of hardlinks of a file in a directory::
diff --git a/Documentation/btrfs-property.asciidoc b/Documentation/btrfs-property.asciidoc
index b562717..4bad88b 100644
--- a/Documentation/btrfs-property.asciidoc
+++ b/Documentation/btrfs-property.asciidoc
@@ -34,7 +34,7 @@ specify what type of object you meant. This is only needed when a
 property could be set for more then one object type.
 +
 Possible types are 's[ubvol]', 'f[ilesystem]', 'i[node]' and 'd[evice]', where
-the first lettes is a shortcut.
+the first letter is a shortcut.
 +
 Set the name of property by 'name'. If no 'name' is specified,
 all properties for the given object are printed. 'name' is one of
diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
index dff0867..dc4c93b 100644
--- a/Documentation/btrfs-qgroup.asciidoc
+++ b/Documentation/btrfs-qgroup.asciidoc
@@ -52,7 +52,7 @@ assignment would lead to quota inconsistency. See 'QUOTA RESCAN' for more
 information.
 --no-rescan::::
 Explicitly ask not to do a rescan, even if the assignment will make the quotas
-inconsitent. This may be useful for repeated calls where the rescan would add
+inconsistent. This may be useful for repeated calls where the rescan would add
 unnecessary overhead.
 
 *create* <qgroupid> <path>::
@@ -140,7 +140,7 @@ force sync of the filesystem identified by <path> before getting information.
 
 QUOTA RESCAN
 ------------
-The rescan reads all extent sharing metadata and updates the respective qgoups
+The rescan reads all extent sharing metadata and updates the respective qgroups
 accordingly.
 
 The information consists of bytes owned exclusively ('excl') or shared/referred
diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 2a1c359..84e9cc0 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -314,7 +314,7 @@ layer between the logical and physical view of the device. The data lifetime
 may be affected by frequent plugging. The memory cells could get damaged,
 hopefully not destroying both copies of particular data in case of DUP.
 
-The wear levelling techniques can also lead to reduced redundancy, even if the
+The wear leveling techniques can also lead to reduced redundancy, even if the
 device does not do any deduplication. The controllers may put data written in
 a short timespan into the same physical storage unit (cell, block etc). In case
 this unit dies, both copies are lost. BTRFS does not add any artificial delay
-- 
2.20.0.rc1.28.g8a4ee09a8a

