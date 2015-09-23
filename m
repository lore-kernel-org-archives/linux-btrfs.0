Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27885 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752456AbbIWHUq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 03:20:46 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8N7KQK1027982
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 15:20:26 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 1/3] btrfs-progs: tests: Move extract_image out of check_all_images for common use
Date: Wed, 23 Sep 2015 15:19:04 +0800
Message-ID: <79b70366a2679adbc039ba11b92d874460fb6d0c.1442992715.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1442992715.git.zhaolei@cn.fujitsu.com>
References: <cover.1442992715.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move code for extract image file to a function from check_all_images()
for common use, so caller can use this function to extrace single
image file.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/common | 76 ++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 33 deletions(-)

diff --git a/tests/common b/tests/common
index 63b0d9f..320c4dd 100644
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
+			_fail "failed to decompress image $image" >&2
+		image=${image%%.xz}
+		rm -f $image.restored
+		cleanme=$image
+		;;
+	*.raw)
+		cp --sparse=auto $image $image.restored
+		;;
+	*.raw.xz)
+		xz --decompress --keep "$image" || \
+			_fail "failed to decompress image $image" >&2
+		image=${image%%.xz}
+		mv "$image" "$image".restored
+		;;
+	esac
+
+	if ! [ -f $image.restored ]; then
+		echo "restoring image $(basename $image)" >> $RESULTS
+		$TOP/btrfs-image -r $image $image.restored || \
+			_fail "failed to restore image $image" >&2
+	fi
+
+	[[ "$cleanme" ]] && rm -f "$cleanme"
+
+	echo "$image.restored"
+}
+
 # Process all image dumps in a given directory,
 # - raw btrfs filesystem images, suffix .raw
 # - dtto compressed by XZ, suffix .raw.xz
@@ -69,44 +107,16 @@ check_image()
 # - dtto compressed by XZ, suffix .img.xz
 check_all_images()
 {
-	dir=$1
+	local dir=$1
 	for image in $(find $dir \( -iname '*.img' -o	\
 				-iname '*.img.xz' -o 	\
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
+		local extracted
+		extracted=$(extract_image "$image")
+		check_image "$extracted"
+		rm -f "$extracted"
 	done
 }
 
-- 
1.8.5.1

