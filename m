Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED3A1F3FED
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2025 11:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740049503; cv=none; b=U2iypj536ynN2+8uJHV+9ZlKoAGZorTmmF4B+zKhzQd1CgG9KgvK8s4+DEIBBRQbj8Cv21W2ROA5UEWrodvqbMuedAk15ggmHU/HbkBGeHcs2hgiHb4VBQmdHQ+b7slXlKhm480KZsFx0qBZdfFPf5w1VzltW82Bm4egJVBIsDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740049503; c=relaxed/simple;
	bh=8ihYbfEmW/bqLw/MsLra7UmB8oJ2hM1pKiPbv9n1Dqo=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sZ/vvAaVtETsIpLqzyMYcS2EQ1/fXKWrGNeE4aa9KWMqqWvZ9KolYkqVobEeCFSwRTNGico4hpQIyYRLvRmlmnEe/z9iosAdn0rBYn1gczCf2tEXOVfQPCMFnQKTNAz3yiD9VmYuoIeUhupTQS6hzwy2ZBg5ytZMb/c8DLPQRcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bw1BAAuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bw1BAAuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76740C4CED1
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2025 11:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740049503;
	bh=8ihYbfEmW/bqLw/MsLra7UmB8oJ2hM1pKiPbv9n1Dqo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Bw1BAAuFzP9U1aZvJIXRqSYyaNFzdfJc1Tu/BLNRdxSfe5CmR8N+uQCpHLlWs4xmC
	 6mtul9m6svoC/P1x3LJezzzFnmX8/XMQzWrJg8+2BcdMwDorDFZq33Pceuz8TdkqiO
	 HekX8Q9/KwLyvj/oBFgCaaL2mZkEIzvGlEA+oYvYwL7wpU8Boirge1buSeKks8thAD
	 dPeJHlsjpxAQLOvHS0RVbZAswgRxQdBBK6xfnGSjkoXHg3BoWdHSsV6FsrbKhwmywt
	 +yWYeKHBqbcOXHqPShDY7+s920fhaapdk4vRHd/faucVk8KUsJlcaCh4X0TEK1XEh2
	 68Wo3Dy3dI7vQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 15/30] btrfs: send: simplify return logic from send_remove_xattr()
Date: Thu, 20 Feb 2025 11:04:28 +0000
Message-Id: <1df434f6ef3b9eb144e3d22c9c6022a14a9632bf.1740049233.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1740049233.git.fdmanana@suse.com>
References: <cover.1740049233.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no need for the 'out' label as there are no resources to cleanup
in case of an error and we can directly return if begin_cmd() fails.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/send.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 653e0b9a94ca..5fd3deaf14d6 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4886,11 +4886,11 @@ static int send_remove_xattr(struct send_ctx *sctx,
 			  struct fs_path *path,
 			  const char *name, int name_len)
 {
-	int ret = 0;
+	int ret;
 
 	ret = begin_cmd(sctx, BTRFS_SEND_C_REMOVE_XATTR);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, path);
 	TLV_PUT_STRING(sctx, BTRFS_SEND_A_XATTR_NAME, name, name_len);
@@ -4898,7 +4898,6 @@ static int send_remove_xattr(struct send_ctx *sctx,
 	ret = send_cmd(sctx);
 
 tlv_put_failure:
-out:
 	return ret;
 }
 
-- 
2.45.2

