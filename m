Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC724C33CA
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789576228; cv=none; b=EpmsrDUM7wxRLbaOCmEhjpn0WI6vHCoVZNw/x38x2Zvn+/kTpSGFZXQW0isBdwsJbFsWvNBpueAG7M17jQDm0MiVR1wBrhMzCb6bkujEQOdu9sc51kEljUSVgNhu5/8legPxzo0hcuyI47owNiJE8LUqMvMWr4c2lGU6ajWfU6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789576228; c=relaxed/simple;
	bh=AvIEA4jYNE+J1o30vnzzb0KE9vap54v1UyRF3Rj6xqc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxPTfJsL398ggcj3zvTi0IoRCyngzRbikHeYwKaf+VJjt7CFX2AwIt+OJ5OR404r8jQ/GCc2HtHcT4z9kkNYtFbCWJtYNsitx+HjjdRRbosEBVCL9l7BUYuJ0NkIrETYIhvAUSCqbv9+ktoubc9rF9ZpASL4m2TGQYZxnHOU8nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MfwrSaPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MfwrSaPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335F71F00899
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789576226;
	bh=TyoRTPRsdzUOJyVz8minV8CHlPNE4BQaTCPd3tbBmEY=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=MfwrSaPUCqMAvKfwOaQ3HC6kn7KL2gKbsNvv64JWc6Yn2ACBXbyA/VW7FhWK09ZdH
	 hmhaidTjTwGT1ex1k9u0EvmSwUOy9OXRAwT1zwm3W//ICLYQUxtDK9BioT0y+lkvNu
	 yUOwz7k5dZKOU0OLV+mfQDpxTMPvWzFz2e4ecRG5Y+XqwtRe3ttpenoWWotDfHLGgI
	 fm+vXxnv6ppDSAV3Rlrj8qEz6T3erT3zUvgjWknqthIoX/JYno0T8j1p9Psn7Oi5qQ
	 LVXBqLJ/WXElp4nezcOiCFjSHoh8BAGendrEur/p9u3wv4v0ej8YwoxDLODB7Fl1xG
	 PmLHM4D6VYcSQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: remove reduntant eb generation check in btrfs_buffer_uptodate()
Date: Wed, 16 Sep 2026 17:30:24 +0100
Message-ID: <7fb642c266224d8ccdb3fcafcf4de1cab9f9c419.1789576145.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <9d46a922c893b72ffcd82c82ee552b661b163be0.1789575886.git.fdmanana@suse.com>
References: <9d46a922c893b72ffcd82c82ee552b661b163be0.1789575886.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

It's pointless to check if the extent buffer's generation does not match
the value of 'parent_transid' because if it does, then we have already
entered the previous if statement and returned from the function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Fix the logic, wrong return value and missing error message and call to
    clear_extent_buffer_uptodate().

 fs/btrfs/disk-io.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 21b72c90bd90..5947d24152fb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -125,15 +125,12 @@ int btrfs_buffer_uptodate(struct extent_buffer *eb, u64 parent_transid,
 		return 1;
 	}
 
-	if (btrfs_header_generation(eb) != parent_transid) {
-		btrfs_err_rl(eb->fs_info,
+	btrfs_err_rl(eb->fs_info,
 "parent transid verify failed on logical %llu mirror %u wanted %llu found %llu",
 			eb->start, eb->read_mirror,
 			parent_transid, btrfs_header_generation(eb));
-		clear_extent_buffer_uptodate(eb);
-		return 0;
-	}
-	return 1;
+	clear_extent_buffer_uptodate(eb);
+	return 0;
 }
 
 static bool btrfs_supported_super_csum(u16 csum_type)
-- 
2.47.2

