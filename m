Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C37481661;
	Tue, 15 Sep 2026 15:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486098; cv=none; b=NK8yZ3IqGA25pjVQZ6Pgf3XZ97yIqzbOZLiInNHzEMYTIQhMUL+DuPP7mq4A3JADa5VYY2TSjE6BAuT5uZf0Ozv/7yHmXKE83Jo02peXenmoW9OAIuh4hIRNZY0tONmX1exGBXm29lv5z3n/XeqkVgs8wOzmEy/lOIFuAi+2kn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486098; c=relaxed/simple;
	bh=JOdEfRTtMZN6n6VGu0E6F3Hk9pPD6V56mSdxTH9IcU8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bvj0BEPNU4xZjI0MBkFk9NWL0isM/ceASpJ9USLeFKay3zdabz976r5J/c98qhrHNo1T4+u/c0NZkXsfkcQNEPWc57zQkrpYk2JRNkha1hq2MCxSNE5zhU4JTJOjr0HFvaMg8qMXDBqyPJPKdS7nMUBPsvGsQvgxXtgB9Q/bdvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jpvF0HSI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jpvF0HSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2C61F000FF;
	Tue, 15 Sep 2026 15:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789486096;
	bh=5DGCZcHHdkA+UN8dpXqZ/x6neiJo+BN7XDoFIp2bcj4=;
	h=From:To:Cc:Subject:Date;
	b=jpvF0HSIJgOOBcqOWJpov3Fjjc5L650ruvhQS7oFNXg2PIf5akkn5xx3qAHfAZYSJ
	 8Ewnwh/EFdsrVA+nlIUU4DlGo75rnrIOYJXx8abQoxhoevI9zVugNKWmuppa0uGOcC
	 xyGr71ZfpeoB9kUUj6bafKMnPsIpR+I+SlGrZ2qEldI2xKEaXQQklvZXYZB4R5j59O
	 LdWFnZwXixtcL0GR/oOVWYgb0pNy0Oj6zlAiPBGZ3xuUo77zjyIWDMFQjmp1nbre7s
	 ADn1dSqWrHVfBrVP3AbTLePSbz9JRTtQQ9WIOM1Wsk/bimwZ+AYwNw0ReaDD7/5ohc
	 heoZ7/OBr2EOg==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] common/btrfs: exercise all algorithms in _btrfs_stress_remount_compress()
Date: Tue, 15 Sep 2026 16:28:12 +0100
Message-ID: <cc052d6b35788720c6cdc93be7eb6af637a9fc96.1789486070.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

_btrfs_stress_remount_compress() is using a hard coded list of algorithms
which is incomplete as zstd is missing as is supported for some years now.

So remove the hard coded list and use _btrfs_compression_algos() to get
the list of supported compression algorithms.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 common/btrfs | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/common/btrfs b/common/btrfs
index 0bfb02dd..3eb68beb 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -449,8 +449,10 @@ _btrfs_kill_stress_defrag_pid()
 _btrfs_stress_remount_compress()
 {
 	local btrfs_mnt=$1
+	local algo_list=("no" $(_btrfs_compression_algos))
+
 	while true; do
-		for algo in no zlib lzo; do
+		for algo in ${algo_list[@]}; do
 			_mount -o remount,compress=$algo $btrfs_mnt
 		done
 	done
-- 
2.47.2

