Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956294CDDE0;
	Thu, 17 Sep 2026 15:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660384; cv=none; b=L8BTW7vGlP5fnUH5D+iAKHymW7Q9KMbeZq7F2GydCu3IlS0hfCpaT2vdoYmHZdgoXFRStAFJebFYEEG3x93oz5Aa0BU/5bNH8X/x5E/nen+qYsGXrbd1WfoyKQKWXD0Oy4L3IjQTEdsCglNUKsHQXx6oa8zfPMZyTB7tJVxmk/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660384; c=relaxed/simple;
	bh=0bf0MYbSOecCzcSYDFxF0YXCZWgHG7WRRmRj1RyIbwk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DC66sAoisdNAdEslbIxuXxr7h7JvnQmu1Y9tWC/CazXSwqGgybS2GIrKYI4OLJoY708Euz3itzIglwCsNzj00xn6DIVPTPte0vfMbnnbvFYmHC/i5OME1FgJaXtVC64Tefnx9GsYmBAmEKpWAvSHOIoSS3ORI15fHoJAkH6YJlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8QbDGF4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8QbDGF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899D51F000FF;
	Thu, 17 Sep 2026 15:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789660383;
	bh=bHJ/582H+tZ7Jr9mJxgEi6QsveBKis8MwA6V9mgj2+Q=;
	h=From:To:Cc:Subject:Date;
	b=Q8QbDGF4LiJlm2VQG/ARlXfE2bSavjJm1Zx47z5SpjsPsBNHVXlURJNH9wrY3eatc
	 ggmv0FQDeS58Gal8gUyLqSGBesGMGcvgvmwA1W8IjoeSzFBZrKZxGHhr+7jMtMnsTg
	 /JtfObB3i3lB4OaXbau3Ml3VLLtZ87kB4PlfJxuaYLm0+Mea+iO02bDa+qzewMM/Pv
	 qvvJ+gvhYo9qGzfgguSD909EER5UrnAB3e1vqy0+T3Is+VpwMN5fGQptCtSLvzt63I
	 pRi9t5KmEIFJ838hwnJUdOU5lTl5OswYtV3Jqsan9/axAeA5nOC1X5KmI7JlwM99aZ
	 qhToCZntYN6VQ==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs/255: add _cleanup function to kill the balance stress process
Date: Thu, 17 Sep 2026 16:52:56 +0100
Message-ID: <a6bc4f66b0217153cb55ea987c26de70c50eba48.1789660025.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Currently if we interrupt the test and balance stress process is already
running, it keeps running after the test is interrupted, requiring the
user to manually kill the balance stress process before it can run any
fstest that uses the scratch device. So add a _cleanup function that
ensures the balance stress process is killed when the test is interrupted.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/255 | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tests/btrfs/255 b/tests/btrfs/255
index 14c12904..fbcbf57c 100755
--- a/tests/btrfs/255
+++ b/tests/btrfs/255
@@ -12,6 +12,15 @@
 . ./common/preamble
 _begin_fstest auto qgroup balance
 
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+	if [ -n "$balance_pid" ]; then
+		_btrfs_kill_stress_balance_pid $balance_pid
+	fi
+}
+
 _require_scratch
 
 _scratch_mkfs >> $seqres.full 2>&1
@@ -40,8 +49,6 @@ for ((i = 0; i < 20; i++)); do
 	$BTRFS_UTIL_PROG quota disable $SCRATCH_MNT
 done
 
-_btrfs_kill_stress_balance_pid $balance_pid
-
 echo "Silence is golden"
 status=0
 exit
-- 
2.47.2

