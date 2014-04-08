Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393AbaDHPnC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Apr 2014 11:43:02 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, fdmanana@gmail.com, david@fromorbit.com,
        Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/3] xfstests: Fix setting FSTYP automatically
Date: Tue,  8 Apr 2014 17:42:50 +0200
Message-Id: <1396971770-23553-3-git-send-email-lczerner@redhat.com>
In-Reply-To: <1396971770-23553-1-git-send-email-lczerner@redhat.com>
References: <20140404211224.GX17603@dastard>
 <1396971770-23553-1-git-send-email-lczerner@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently if the FSTYP is not set, the code to get FSTYP using blikd
would not work. This is because we're using HOSTOS environment variable
which might not be set (at least not on my system) and because it's
already late in the code path.

Fix this by using OSTYP environment variable as a fallback in the case
that HOSTOS does not work and move the check to common/config.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 check         |  8 --------
 common/config | 18 +++++++++++++-----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/check b/check
index 8f1a6e1..ed1834d 100755
--- a/check
+++ b/check
@@ -58,14 +58,6 @@ then
     exit 1
 fi
 
-# Autodetect fs type based on what's on $TEST_DEV unless it's been set
-# externally
-if [ -z "$FSTYP" -a "$HOSTOS" == "Linux" ]; then
-    FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
-fi
-FSTYP=${FSTYP:=xfs}
-export FSTYP
-
 SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
 SRC_GROUPS="generic shared"
 export SRC_DIR="tests"
diff --git a/common/config b/common/config
index 3163801..00249e6 100644
--- a/common/config
+++ b/common/config
@@ -297,11 +297,6 @@ _fsck_opts()
 	esac
 }
 
-[ -z "$FSTYP" ] && export FSTYP=xfs
-[ -z "$MOUNT_OPTIONS" ] && _mount_opts
-[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
-[ -z "$FSCK_OPTIONS" ] && _fsck_opts
-
 known_hosts()
 {
 	[ "$HOST_CONFIG_DIR" ] || HOST_CONFIG_DIR=`pwd`/configs
@@ -446,6 +441,19 @@ get_next_config() {
 if [ -z "$CONFIG_INCLUDED" ]; then
 	get_next_config `echo $HOST_OPTIONS_SECTIONS | cut -f1 -d" "`
 	export CONFIG_INCLUDED=true
+
+	# Autodetect fs type based on what's on $TEST_DEV unless it's been set
+	# externally
+	if [ -z "$FSTYP" ] && \
+	   [ "$HOSTOS" == "Linux" -o "$OSTYPE" == "linux-gnu" ] && \
+	   [ ! -z "$TEST_DEV" ]; then
+		FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
+	fi
+	FSTYP=${FSTYP:=xfs}
+	export FSTYP
+	[ -z "$MOUNT_OPTIONS" ] && _mount_opts
+	[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
+	[ -z "$FSCK_OPTIONS" ] && _fsck_opts
 fi
 
 # make sure this script returns success
-- 
1.8.3.1

