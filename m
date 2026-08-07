Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF09A226CFE;
	Fri,  7 Aug 2026 03:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786072244; cv=none; b=cwhreTZqONaPaJnDbsw0cEW0qGWlCHhoQmOTcJEkT9j1R+kschkAvmI7KmGl5Z97fV5K1kzI/UkGamWVtFoQtSqLZ0zI88QKtYD2h/kRGKCb5U6/DgZSZ/yfCqjgAkRj4H92xSzS51o3ZuMkn1loy1yx7Q5HTsn1VQ71s5XEJSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786072244; c=relaxed/simple;
	bh=uzu7IiblMIugOa69mv/nq7P43Owx5u28hOENfFMtu68=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EyzqCURcPTBJSDaDXGKtEDVVeFx5tIJf+sdakF+ivsjWUqJz55zNxIlyZ4odDpsOITJst2t0E7Ou0DvVTv7karvK3Xamb01ph29DGW3401LXHH0T2lvl40HYNjKEtWshwwiUuFRHcoBMwEvqCwgW4As6tY+LYX4+PZWkMsYkEBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Rs/bscKC; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Rs/bscKC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ci
	I7LS+NgxvTd1Aep2x2CxdAP97q6NL8MCarB8jy0yQ=; b=Rs/bscKCQgU+xoNRRJ
	3spbk/8q+3nLO3wp+d3XnWI4jeH3i6A3q0of35IwnDuOFxXTTrV30HSy8bZMGc5x
	yhm8YpejAUVtigBO7n1Gj045ni4kH82fiUPtjyFtxZEV8h2QgCNfr/7RMqcchynD
	o8Aa1jtlKU4gyD0rlXr/30vPM=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgA3jfOaTHVqK5+vKA--.59903S2;
	Fri, 07 Aug 2026 11:10:19 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: fstests@vger.kernel.org
Cc: asj@kernel.org,
	fdmanana@suse.com,
	zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH] btrfs/333: also exercise io_uring encoded write
Date: Fri,  7 Aug 2026 11:10:16 +0800
Message-Id: <20260807031016.3605415-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgA3jfOaTHVqK5+vKA--.59903S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxurW8ZryrtF1UXFW7uw45KFg_yoWrZr48pr
	yakFW5Jry5Xr17ZFZ3JF45uryrGwn5Ka12q3sa9ryxZ3sxArnrKay2gw1rKr17JFZIqa4k
	Z392q34DWr1qy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jbSdgUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6hsxwWp1TJtGpAAA3r

btrfs_encoded_write already supports io_uring, but the test only wrote
via ioctl.  Also write via io_uring and verify each write with both
ioctl and io_uring reads.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 common/btrfs    | 36 ++++++++++++++++++++++++++++++++++++
 tests/btrfs/333 | 37 +++++++++++++++++++++----------------
 2 files changed, 57 insertions(+), 16 deletions(-)

diff --git a/common/btrfs b/common/btrfs
index 30288f07..937cc49b 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -1073,3 +1073,39 @@ _require_btrfs_iouring_encoded_read()
 		_notrun "btrfs io_uring encoded read failed with -EOPNOTSUPP"
 	fi
 }
+
+_require_btrfs_iouring_encoded_write()
+{
+	local fn
+	local tmpfile
+	local datafile
+	local ret
+
+	_require_command src/btrfs_encoded_write
+
+	_scratch_mkfs &> /dev/null
+	_scratch_mount
+
+	fn=`mktemp -p $SCRATCH_MNT`
+	tmpfile=`mktemp`
+	datafile=`mktemp`
+
+	dd if=/dev/urandom of=$datafile bs=64 count=1 status=none
+	src/btrfs_encoded_write io_uring $fn 0 64 64 0 1 < $datafile > $tmpfile
+	ret=$?
+
+	_scratch_unmount
+	rm -f $datafile
+
+	if [[ $ret -ne 0 ]]; then
+		rm -f $tmpfile
+		_fail "btrfs_encoded_write failed"
+	fi
+
+	read ret < $tmpfile
+	rm $tmpfile
+
+	if [[ $ret == -95 ]]; then
+		_notrun "btrfs io_uring encoded write failed with -EOPNOTSUPP"
+	fi
+}
diff --git a/tests/btrfs/333 b/tests/btrfs/333
index 6214d7c5..463af5d2 100755
--- a/tests/btrfs/333
+++ b/tests/btrfs/333
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. btrfs/333
 #
-# Test btrfs encoded reads
+# Test btrfs encoded reads and writes (ioctl and io_uring)
 
 . ./common/preamble
 _begin_fstest auto quick compress rw io_uring ioctl
@@ -14,6 +14,7 @@ _begin_fstest auto quick compress rw io_uring ioctl
 _require_command src/btrfs_encoded_read
 _require_command src/btrfs_encoded_write
 _require_btrfs_iouring_encoded_read
+_require_btrfs_iouring_encoded_write
 # Encoded writes are reject for inodes with the NODATASUM flag, so we must skip
 # the test if running with either the nodatasum or nodatacow (which implies
 # nodatasum) mount options.
@@ -124,7 +125,7 @@ echo "$fn: btrfs encoded read had encryption of $encryption, expected 0" \
 do_encoded_write()
 {
 	local fn=$1
-	local exp_ret=$2
+	local type=$2
 	local len=$3
 	local unencoded_len=$4
 	local unencoded_offset=$5
@@ -133,9 +134,9 @@ do_encoded_write()
 
 	local tmpfile=`mktemp`
 
-echo "running btrfs_encoded_write ioctl $fn 0 $len $unencoded_len $unencoded_offset $compression < $data_file > $tmpfile" \
+echo "running btrfs_encoded_write $type $fn 0 $len $unencoded_len $unencoded_offset $compression < $data_file > $tmpfile" \
 	>>$seqres.full
-	src/btrfs_encoded_write ioctl $fn 0 $len $unencoded_len \
+	src/btrfs_encoded_write $type $fn 0 $len $unencoded_len \
 		$unencoded_offset $compression < $data_file > $tmpfile
 
 	if [[ $? -ne 0 ]]; then
@@ -172,27 +173,31 @@ test_file()
 	local unencoded_len=$3
 	local unencoded_offset=$4
 	local compression=$5
+	local wtype
 
-	local tmpfile=`mktemp -p $SCRATCH_MNT`
 	local randfile=`mktemp`
 
 	dd if=/dev/urandom of=$randfile bs=$size count=1 status=none
 	local md5=`md5sum $randfile | cut -d ' ' -f 1`
 
-	do_encoded_write $tmpfile $size $len $unencoded_len $unencoded_offset \
-		$compression $randfile \
-		|| _fail "encoded write ioctl failed"
+	for wtype in ioctl io_uring; do
+		local tmpfile=`mktemp -p $SCRATCH_MNT`
 
-	rm $randfile
+		do_encoded_write $tmpfile $wtype $len $unencoded_len \
+			$unencoded_offset $compression $randfile \
+			|| _fail "encoded write $wtype failed"
 
-	do_encoded_read $tmpfile ioctl $size $len $unencoded_len \
-		$unencoded_offset $compression $md5 \
-		|| _fail "encoded read ioctl failed"
-	do_encoded_read $tmpfile io_uring $size $len $unencoded_len \
-		$unencoded_offset $compression $md5 \
-		|| _fail "encoded read io_uring failed"
+		do_encoded_read $tmpfile ioctl $size $len $unencoded_len \
+			$unencoded_offset $compression $md5 \
+			|| _fail "encoded read ioctl failed after $wtype write"
+		do_encoded_read $tmpfile io_uring $size $len $unencoded_len \
+			$unencoded_offset $compression $md5 \
+			|| _fail "encoded read io_uring failed after $wtype write"
 
-	rm $tmpfile
+		rm $tmpfile
+	done
+
+	rm $randfile
 }
 
 _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
-- 
2.25.1

