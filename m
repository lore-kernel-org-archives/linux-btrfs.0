Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbaESQUd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 12:20:33 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4CA01AC9A
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 16:20:32 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 5/5] btrfs-progs: doc: update the Availability section
Date: Mon, 19 May 2014 18:20:31 +0200
Message-Id: <7d0ac617c30edb0a65b85d0e759573f687a46a2b.1400515868.git.dsterba@suse.cz>
In-Reply-To: <cover.1400515867.git.dsterba@suse.cz>
References: <cover.1400515867.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Does not reflect the current state. The wiki contains more details on
the first page.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/btrfs-balance.txt          | 4 +---
 Documentation/btrfs-check.txt            | 4 +---
 Documentation/btrfs-device.txt           | 4 +---
 Documentation/btrfs-filesystem.txt       | 4 +---
 Documentation/btrfs-inspect-internal.txt | 4 +---
 Documentation/btrfs-property.txt         | 4 +---
 Documentation/btrfs-qgroup.txt           | 4 +---
 Documentation/btrfs-quota.txt            | 4 +---
 Documentation/btrfs-receive.txt          | 4 +---
 Documentation/btrfs-replace.txt          | 4 +---
 Documentation/btrfs-rescue.txt           | 4 +---
 Documentation/btrfs-restore.txt          | 4 +---
 Documentation/btrfs-scrub.txt            | 4 +---
 Documentation/btrfs-send.txt             | 4 +---
 Documentation/btrfs-subvolume.txt        | 4 +---
 Documentation/btrfs.txt                  | 4 +---
 Documentation/mkfs.btrfs.txt             | 4 +---
 17 files changed, 17 insertions(+), 51 deletions(-)

diff --git a/Documentation/btrfs-balance.txt b/Documentation/btrfs-balance.txt
index d34833d6f380..37d8781eee4e 100644
--- a/Documentation/btrfs-balance.txt
+++ b/Documentation/btrfs-balance.txt
@@ -68,9 +68,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-check.txt b/Documentation/btrfs-check.txt
index 073667265c13..027032b2efb8 100644
--- a/Documentation/btrfs-check.txt
+++ b/Documentation/btrfs-check.txt
@@ -38,9 +38,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
index 4f847763bb66..0f7917d894a0 100644
--- a/Documentation/btrfs-device.txt
+++ b/Documentation/btrfs-device.txt
@@ -105,9 +105,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index e3e270ff0957..0ee79cbabc34 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -108,9 +108,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-inspect-internal.txt b/Documentation/btrfs-inspect-internal.txt
index fe76217365b0..5ae4997b9bc0 100644
--- a/Documentation/btrfs-inspect-internal.txt
+++ b/Documentation/btrfs-inspect-internal.txt
@@ -57,9 +57,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-property.txt b/Documentation/btrfs-property.txt
index 4b0f49e04b20..6b23e2e52aad 100644
--- a/Documentation/btrfs-property.txt
+++ b/Documentation/btrfs-property.txt
@@ -56,9 +56,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-qgroup.txt b/Documentation/btrfs-qgroup.txt
index 12321926b25b..55c4747449ff 100644
--- a/Documentation/btrfs-qgroup.txt
+++ b/Documentation/btrfs-qgroup.txt
@@ -97,9 +97,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-quota.txt b/Documentation/btrfs-quota.txt
index f7b0fd13b0db..c092e328593c 100644
--- a/Documentation/btrfs-quota.txt
+++ b/Documentation/btrfs-quota.txt
@@ -46,9 +46,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-receive.txt b/Documentation/btrfs-receive.txt
index fba39269f929..82611603102f 100644
--- a/Documentation/btrfs-receive.txt
+++ b/Documentation/btrfs-receive.txt
@@ -46,9 +46,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-replace.txt b/Documentation/btrfs-replace.txt
index 46ff08d960ab..eecf9b00ae5f 100644
--- a/Documentation/btrfs-replace.txt
+++ b/Documentation/btrfs-replace.txt
@@ -71,9 +71,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-rescue.txt b/Documentation/btrfs-rescue.txt
index 0b75befade47..82297fa4455c 100644
--- a/Documentation/btrfs-rescue.txt
+++ b/Documentation/btrfs-rescue.txt
@@ -47,9 +47,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-restore.txt b/Documentation/btrfs-restore.txt
index 1882f0d0362d..d774343b91b1 100644
--- a/Documentation/btrfs-restore.txt
+++ b/Documentation/btrfs-restore.txt
@@ -63,9 +63,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-scrub.txt b/Documentation/btrfs-scrub.txt
index 2928e1d1afb8..7b27d63c99b6 100644
--- a/Documentation/btrfs-scrub.txt
+++ b/Documentation/btrfs-scrub.txt
@@ -87,9 +87,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-send.txt b/Documentation/btrfs-send.txt
index 2fbb4cb6094d..ce926a77e58f 100644
--- a/Documentation/btrfs-send.txt
+++ b/Documentation/btrfs-send.txt
@@ -48,9 +48,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs-subvolume.txt b/Documentation/btrfs-subvolume.txt
index 3fd29282e32f..a5191316b24d 100644
--- a/Documentation/btrfs-subvolume.txt
+++ b/Documentation/btrfs-subvolume.txt
@@ -158,9 +158,7 @@ returned in case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/btrfs.txt b/Documentation/btrfs.txt
index d0b3f35aaeb0..2d121a805d72 100644
--- a/Documentation/btrfs.txt
+++ b/Documentation/btrfs.txt
@@ -92,9 +92,7 @@ case of failure.
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/Documentation/mkfs.btrfs.txt b/Documentation/mkfs.btrfs.txt
index 634e486105a2..0cab626b2c3c 100644
--- a/Documentation/mkfs.btrfs.txt
+++ b/Documentation/mkfs.btrfs.txt
@@ -122,9 +122,7 @@ to the arguments like 'k' for KBytes, 'm' for MBytes...
 
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
-development,
-and not suitable for any uses other than benchmarking and review.
+*btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
-- 
1.9.0

