Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7682 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933115AbbIDNZe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2015 09:25:34 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t84DPHId029996
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Sep 2015 21:25:17 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: tests: Move extract_image out of check_all_images for common use
Date: Fri, 4 Sep 2015 21:23:49 +0800
Message-ID: <154afcdd14c259551d843a157814fd0ff3589e8f.1441373012.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move code for extract image file to a function from check_all_images()
for common use, so caller can use this function to extrace single
image file.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/common | 73 ++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 32 deletions(-)

diff --git a/tests/common b/tests/common
index 63b0d9f..0c0efef 100644
--- a/tests/common
+++ b/tests/common
@@ -62,6 +62,44 @@ check_image()
 	run_check $TOP/btrfs check $image
 }
 
+extract_image()
+{
+	local image="$1"
+
+	local cleanme=
+	case "$image" in
+	*.img)
+		rm -f $image.restored
+		: ;;
+	*.img.xz)
+		xz --decompress --keep "$image" || \
+			_fail "failed to decompress image $image"
+		image=${image%%.xz}
+		rm -f $image.restored
+		cleanme=$image
+		;;
+	*.raw)
+		cp --sparse=auto $image $image.restored
+		;;
+	*.raw.xz)
+		xz --decompress --keep "$image" || \
+			_fail "failed to decompress image $image"
+		image=${image%%.xz}
+		mv "$image" "$image".restored
+		;;
+	esac
+
+	if ! [ -f $image.restored ]; then
+		echo "restoring image $(basename $image)" >> $RESULTS
+		$TOP/btrfs-image -r $image $image.restored || \
+			_fail "failed to restore image $image"
+	fi
+
+	[[ "$cleanme" ]] && rm -f "$cleanme"
+
+	EXTRACT_IMAGE_OUTPUT="$image.restored"
+}
+
 # Process all image dumps in a given directory,
 # - raw btrfs filesystem images, suffix .raw
 # - dtto compressed by XZ, suffix .raw.xz
@@ -75,38 +113,9 @@ check_all_images()
 				-iname '*.raw' -o 	\
 				-iname '*.raw.xz' \) | sort)
 	do
-		cleanme=
-		case "$image" in
-		*.img)
-			rm -f $image.restored
-			: ;;
-		*.img.xz)
-			xz --decompress --keep "$image" || \
-				_fail "failed to decompress image $image"
-			image=${image%%.xz}
-			rm -f $image.restored
-			cleanme=$image
-			;;
-		*.raw)
-			cp --sparse=auto $image $image.restored
-			;;
-		*.raw.xz)
-			xz --decompress --keep "$image" || \
-				_fail "failed to decompress image $image"
-			image=${image%%.xz}
-			mv "$image" "$image".restored
-			;;
-		esac
-
-		if ! [ -f $image.restored ]; then
-			echo "restoring image $(basename $image)" >> $RESULTS
-			$TOP/btrfs-image -r $image $image.restored || \
-				_fail "failed to restore image $image"
-		fi
-
-		check_image $image.restored
-
-		rm -f $image.restored $cleanme
+		extract_image "$image"
+		check_image "$EXTRACT_IMAGE_OUTPUT"
+		rm -f "$EXTRACT_IMAGE_OUTPUT"
 	done
 }
 
-- 
1.8.5.1

