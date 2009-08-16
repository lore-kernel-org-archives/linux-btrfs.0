From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] Install programs into sbin
Date: Sun, 16 Aug 2009 14:17:50 +0200
Message-ID: <1250425070-5262-1-git-send-email-jengelh@medozas.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Administrative utitilies, especially those for filesystems, belong
into sbin, not bin. (Cf. xfsprogs.)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 8097b5a..1abf9dc 100644
--- a/Makefile
+++ b/Makefile
@@ -13,7 +13,7 @@ DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 
 INSTALL= install
 prefix ?= /usr/local
-bindir = $(prefix)/bin
+bindir = $(prefix)/sbin
 LIBS=-luuid
 
 progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck
-- 
1.6.4

