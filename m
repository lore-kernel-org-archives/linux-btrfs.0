Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92824347BA9
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Aug 2026 02:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786156532; cv=none; b=KHYQERn3VQcIIsHQ0XvwCRYIdSpZ0orZbdta75vThw9jRg3Rnq55ayFYpGRDTv79k/zC49y9esd+iUCaAfu8Y4lnorawnqcuru9zNo1vym2AYDKP4WLfiW1+KbAMcG9UaUBE+g3KB0jQ7q54ixQ2XPutgvGnVgLFiwoHhMCDwuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786156532; c=relaxed/simple;
	bh=uL4E3uMK1tzR+d6f2g3RxMR2ZfGdKMi5Lb7ggwg7OWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijxCqltXfCIFmu6hSyxlkvTlKfaCiAqqINtkJBTpOFNXCq3jjI44um3WZutoQOVPIRuHg9KMqyTA8pAePQScuwPaQ+DuA0Rsq3VnbrvaaK9Fh9tgEnnNmUIcapbBfk5Rnt/MG9tDjk3n2Md8I+eqJU3I3ft/Q5sHfCZyWJz5ZpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HhoHAHWd; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HhoHAHWd"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so121487f8f.1
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2026 19:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786156518; x=1786761318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HMkT9+Cc90LTsISGyMoYzSdvxcwrzY6r/5xfFoOuS6k=;
        b=HhoHAHWdFeTFPQhjJoISWBCy3b7PtO5Qz3clslu7oJBJppihb4J3J0nUrRV+tXScyG
         9TRU4B2fQ4SKUvUxgPu03VT4FXzS/aPr169tmj8q8ls8by2Sww/i1zwWiwutTa9iFABY
         ZgpW9ztD48/a/sZodiOYoi3/SeGu/L6OEYK0RJTLM4RfhDZamD43InN3D0dSgnyQLG0w
         0tsq9npLcgi3/8z8P+PnAlvcaiOaxE89Jdzywl/kUdByahGgzac2b9n9mrJwe8O8Sc7H
         N1lFCP6FDP70blvvtNsPIEZCrJ2ENNE9vFd7S4hM7vDCzoL6TLhkbFme4MPccxL4Sa+2
         9W2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786156518; x=1786761318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HMkT9+Cc90LTsISGyMoYzSdvxcwrzY6r/5xfFoOuS6k=;
        b=tSm23Mvn9DubHYMPp1QF3Q6ejxJnx5aupT/qxdl3dsfwOemgyQkkXjxPG5RD/oJahy
         F226WtOSRWodyqdEMF3XyfSVYMhwh7dEYetzywLqXuGmWZ5+lLxpc9IUI7MHQySM995w
         f5TC7ecVCk1wWXcmKcJvUN/B0HnuWapcYPNiJpGFo7A8WWRuFX7SUiLRp74LQ3A2RRan
         VM33eT2z25V8x1v0ASmA9CyehNrf8LzUFf94Pe5xJD6k5JQqRItyIWRCEKb1ohgAxWYr
         3oNub7nGGw0XFw+ktVxtOBhDfkhQL/F7oAbbIcamwCAeXftoGKtSjD0B7qUFIjF3W3lV
         clLA==
X-Gm-Message-State: AOJu0YzeLgMUqF1vBaJHGIpZ7sDk1FR2VcoxJFOEa2HRztDWxOX7oYLV
	pOfEe0cyCun+fKTD2qDllrY3g4SL5Yrc+L9DhGahdm6VYHMDT9blN+n7
X-Gm-Gg: AR+sD13OoS0Ly4ftu80P1pLM/zEbfcuQmUl8VmwO3PbhXG0xwJAZ3I4FVfKD0B7fF0x
	yRFlIUfdVVU6OT9HoSJ0MqajjKxBcF3n31sUVWIpiz+ymSBgESqi4a9k8htQ/a0B4MeiW+5ofuS
	Yy1PMGsQ1rrs8nQNglGmpusFoEkoR4m2vDjrbSEl1gWgwgZIklLOiAIIsBx2rM1NwfqD2e9TMoU
	9sHqzD0MrycfWwuwxCGGUcnLehGEPRLuUdAlrkGo6paetPba9G/buBx4xXTJoTrjZSxtmHKmV9e
	CQ1gdRUmIfVeV/7ezfzV637YHCgAEpiVnLTL5FbhuXoOB1GqiUVGy5OaEW4iUOJF1HazSS9Z2MW
	O8pjeyTCeqj9nlEv9QrMojE8TNOelEfZbVz5lq9dLr7eBxs0T5HAngGJAiLz/cXLH8xJPhSlh8U
	GZicfJgANy2pj68X2lV+ssPvA2UCji3tjGudr+LVJGeELqq1ClymIsHRY=
X-Received: by 2002:a05:6000:4212:b0:47f:81a9:3f36 with SMTP id ffacd0b85a97d-47ffd924dffmr18662897f8f.18.1786156517688;
        Fri, 07 Aug 2026 19:35:17 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4800214557esm10571244f8f.2.2026.08.07.19.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 19:35:16 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH 2/4] btrfs: also validate compression levels in btrfs_compress_is_valid_type()
Date: Sat,  8 Aug 2026 04:34:57 +0200
Message-ID: <20260808023459.1494928-3-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260808023459.1494928-1-koray.fra@gmail.com>
References: <20260808023459.1494928-1-koray.fra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change btrfs_compress_is_valid_type() to use btrfs_match_compress_type()
and btrfs_compress_str2level() instead of a simple strncmp, which would
validate even incorrect strings (e.g. "zstd:invalid" or "zstdinvalid").

This also makes the function validate levels in the same way the compress=
option gets parsed, allowing bigger or smaller values, but still clamping
them to the min or max supported.

Furthermore, remove the len parameter, since now it requires a
NUL-terminated string because of btrfs_compress_str2level(); this change is
fine because btrfs_compress_is_valid_type() is used only once in props.c

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/compression.c | 11 ++++++++---
 fs/btrfs/compression.h |  2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 58138f300b58..833c5f45afec 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -70,18 +70,23 @@ static struct compressed_bio *alloc_compressed_bio(struct btrfs_inode *inode,
 	return to_compressed_bio(bbio);
 }
 
-bool btrfs_compress_is_valid_type(const char *str, size_t len)
+bool btrfs_compress_is_valid_type(const char *str)
 {
+	size_t len = strlen(str);
 	int i;
 
 	for (i = 1; i < ARRAY_SIZE(btrfs_compress_types); i++) {
 		size_t comp_len = strlen(btrfs_compress_types[i]);
+		const char *comp_type = btrfs_compress_types[i];
+		int tmp_level;
 
 		if (len < comp_len)
 			continue;
 
-		if (!strncmp(btrfs_compress_types[i], str, comp_len))
-			return true;
+		if (btrfs_match_compress_type(str, comp_type, true)) {
+			if (btrfs_compress_str2level(i, str + comp_len, &tmp_level) == 0)
+				return true;
+		}
 	}
 	return false;
 }
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index e67ba47b4cdc..c63bed9f4152 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -132,7 +132,7 @@ extern const struct btrfs_compress_levels btrfs_lzo_compress;
 extern const struct btrfs_compress_levels btrfs_zstd_compress;
 
 const char* btrfs_compress_type2str(enum btrfs_compression_type type);
-bool btrfs_compress_is_valid_type(const char *str, size_t len);
+bool btrfs_compress_is_valid_type(const char *str);
 
 int btrfs_compress_heuristic(struct btrfs_inode *inode, u64 start, u64 end);
 
-- 
2.55.0

