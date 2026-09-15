Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC30B3D649F;
	Tue, 15 Sep 2026 15:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486149; cv=none; b=WNhB6T3x2FWOowcwbXgN6zdqVOVNW35bvngNxmV0AibaGRyE4ElmM0LVdWTnJ+EzZH5zRkpTrRhi64FjX9W+4sb69c5iEPbi9RIa3iUxf1Za2gvxV+ux+0JGc8ISe+BXMTJ4uVhLkX/ZeHVjptahBP36lo0SISUQWOEVoC/i5q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486149; c=relaxed/simple;
	bh=MSIV4lx/c6VJzCw5B0oUPfJiH3Jr91nc2+9ssQivBqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WszW1y/hnzkY1N3DvF9RkLPwO6ijjQUWYdMes363GCToMpDHXo8nnndoC1dKoLUIcHi6u0aQsTcMmXs5ebS2RWAbrC/1D7cfy3FBv31HCkwNkKRcBsNbO90yqEFK0ApoM4u7zZYaVdg+iSJar4ZD2pUw36agOhRAHpSYI0cJU0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CqR2vLnN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CqR2vLnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805B21F000FF;
	Tue, 15 Sep 2026 15:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789486148;
	bh=puXMjAiXwpDB3tTK9aEvzK9/qSv1kWJTWfpayQO7Rkg=;
	h=From:To:Cc:Subject:Date;
	b=CqR2vLnN6aWIf+rGSYgdPeyAZrjJIUwVQd1P7eSnwSm6eTlT7d7rWBpLFUHunqfbq
	 PbXYN4wUbnNtmmZl3dyszYBozmoLmuWNoBIFgrwO6flDNsCLkKt6KmSiRgmcaQREZB
	 DvRoc2AnMt7G+Ed+kz1YzOFNUGK4cLAp+9jJj1HTZ6OW9Ep/QeN5bLMq0ABFTqMM/X
	 APINHS3uzBe7J0qNZZ7ViT4iymgBT+Y1TOI2Jfyl1+0NJ1bTMWB3u0lItv7hXTNDQw
	 m9wLBO0VDOqRcWw1mBD1flk0otcuIu1zaXQm33fqgoYbvxdMr6dE9SAAiqSJcklyRO
	 WcRw+LQx61VCA==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] common/btrfs: exercise all algorithms in _btrfs_stress_defrag()
Date: Tue, 15 Sep 2026 16:29:04 +0100
Message-ID: <97cbd58be421a2b35567031d58002f73493b3316.1789486109.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

_btrfs_stress_defrag() is testing only zlib and lzo compression with the
defrag tool, but we also have zstd support for some years now.

Change _btrfs_stress_defrag() to iterate over the list of all supported
compression algorithms given by _btrfs_compression_algos().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 common/btrfs | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/common/btrfs b/common/btrfs
index 3eb68beb..1854cf07 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -414,16 +414,17 @@ _btrfs_stress_defrag()
 {
 	local btrfs_mnt=$1
 	local compress=$2
+	local algo_list=($(_btrfs_compression_algos))
 
 	while true; do
 		if [ "$compress" == "nocompress" ]; then
 			find $btrfs_mnt \( -type f -o -type d \) -exec \
 			$BTRFS_UTIL_PROG filesystem defrag {} \;
 		else
-			find $btrfs_mnt \( -type f -o -type d \) -exec \
-			$BTRFS_UTIL_PROG filesystem defrag -clzo {} \;
-			find $btrfs_mnt \( -type f -o -type d \) -exec \
-			$BTRFS_UTIL_PROG filesystem defrag -czlib {} \;
+			for algo in ${algo_list[@]}; do
+				find $btrfs_mnt \( -type f -o -type d \) -exec \
+				     $BTRFS_UTIL_PROG filesystem defrag -c$algo {} \;
+			done
 		fi
 	done
 }
-- 
2.47.2

