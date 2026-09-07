Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CAB525A94
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811585; cv=none; b=fysvmO0xWfk9TXUSVByen0QJasoNpc24yM2XPV1LAGLU3HK14qO3/CaDpC2vlDmty8Tg+V9gCuebz89RXnO/jf+lbwRZrCWnB+HW4EzBf7XJlRhuSZbVFCo3DUPlyJxZDu2WoT3Ycf/+KI0x7HHkLy6NEAAwm3S8FXysqB6IFAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811585; c=relaxed/simple;
	bh=w9bAhlU/qn8FlMBX4Jzg0dED95rdfnFDxGqARYs0o/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AH8Lgy80JizRX8tez3lrLzu6rOoXSoKDBdCSVJ/T6MJgeR+5vzoNh3VYNph6CdMBSddUfgYkLEcbf5KvO7LfVdyi5EQ+gFYcn99Tje3U4PPPi2Wh5/NM9wHB2cUpva1kkWfqeD7xQy2IaJY81bzF7l07GHZwIhrsv8nIwgdvwws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k9RXXHKt; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k9RXXHKt"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ce364488dso1819815e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788811580; x=1789416380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qlyy4tEQWi8wjlIjs3jWR6xb5LmzcQEpEL9ylV8tc3A=;
        b=k9RXXHKtleLC+CRkWjRSjsCENFuvylNhPhY4J1oG4ATkFme3KRWAzdppBNS89WacXU
         PoqLl0OIWmigekMW9TJMWAqQx59gOM1q2izSlqVrVFBBwkCJ6LPF7pY8s7bTSJ0kV4cX
         9TGDq0Wsl3yD+i/H+eCOdLD5nxruXZNQj5ALQWtQKHETnzwiFHkRRsgwPNv2XcqKS6aH
         gsk/ZWjcuSANO+G6tSXgW7XWF4mnQ6HIQQRa2PpNbJcHhFGcSw9vE50aSFWICfTdwLww
         gRlXfpeZJJDT45iiaujqUcxWTrC+9Vy+ZWX1lotupkFrSdv9zLAabFYg0nrgeb42fJIC
         hpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788811580; x=1789416380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qlyy4tEQWi8wjlIjs3jWR6xb5LmzcQEpEL9ylV8tc3A=;
        b=g4LCBXYFUN4hEVZ3WIUl5jp4ZrnMK3dzO6H9EyWmQummXbYvi27xZztGuHT8yUkyrf
         T0SFEtQxNU2MslFraVphGIKI12qeXr8LR1jaJQsh9PIgO74OxFCb7G36yPg0Q3uTmlMw
         vVj6Wy6FrE40IX95Ct9HA+6Ul8ApOfNRqKw/EgYgrpAry3HYwGOWMKIhDT/V5u3nKRou
         wEmwPU+hxeJukhTWtvAN58cuBVYPUfu1Ho4Kp9BqfcBO0Du8JexyxV7uE406/Rwcalq2
         WP7Qu/6lngSI9XPCISyvL/UerJTyptozScYxeP/jVSPe4I98CGY2ewvmtFF+y1ahzqk/
         t7Qw==
X-Forwarded-Encrypted: i=1; AKwUvBwT3sQUzUCxhgWubq5rMJ3WB7JHrhpL8PgGPre4t7rnAMTIV8Wljx7yFeZDo5Or92jy2t3DLDUokZ800A==@vger.kernel.org
X-Gm-Message-State: AFuF++lbSPFCHTsOpNmDMBKtSisNWZgUGrR9wDK5mQXiGcE/70rEC+Aq
	Uo0WF5YxO5tHs8XwnvsTcu/y4hkP4DyTUK7fl3sqgXHY5P09BiZAbL/x
X-Gm-Gg: AYBFou2ns70VoX3Psh+9lycy8vrwmvBxxrG7J+p0N8mGU9rxtr6HFab98ASqwtjaoq9
	Jbgbzi7a3jmKdS41wqhtrMW+74tZJ3HevO2vtSFdkMc578biri49UvXe891USO1RGN9XAv38gnZ
	2Ey3OfueznrpJx9wSwUhim2/+wLyN619JKzvrcnz/4x9gKs7+3MExLaDIlqKj0fRxyKy1BUGWx1
	GSVqURPHZoRzkCzJJXds1pNAXy0JcUrMH68xcVSqxQLbtELbLM7H3X7PV2f3DSipVBvN3vG0Iy1
	r8U6ScTeLc5ykFMqGrnFkjrYiE17Y6W7z4HQwLe/uQzBYktoNydpQAvmOQ8PHlFY+R6hgSbJolz
	UwbK2eVNJD0/Ev4sryAVLN8zM43LXjsNC5GmZIVvFX2xXAeN5/85hbEj3j4Y2u2KdgBR132gAh0
	5D1MHe5DdpH5mc2FkQKDDH+/c28vIfYfRmHxqaXrfR3Unj2bgl3B20jH1P
X-Received: by 2002:a05:600c:5743:b0:49c:f13e:e52 with SMTP id 5b1f17b1804b1-49d1758cbf6mr21483545e9.15.1788811579606;
        Mon, 07 Sep 2026 13:06:19 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5f912esm431050225e9.4.2026.09.07.13.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:06:17 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v5 1/6] btrfs: export btrfs_match_compress_type(), move it to compression.h
Date: Mon,  7 Sep 2026 22:05:13 +0200
Message-ID: <20260907200518.428277-2-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907200518.428277-1-koray.fra@gmail.com>
References: <20260907200518.428277-1-koray.fra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Export btrfs_match_compress_type() from being a static and locally used
function in super.c and move it to compression.c, exporting it in
compression.h.  This allows it to be used in the next patches as
validation for compression algorithm names.

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/compression.c | 17 +++++++++++++++++
 fs/btrfs/compression.h |  1 +
 fs/btrfs/super.c       |  8 --------
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c62b5148d5ac..65d8b88b9732 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1650,3 +1650,20 @@ int btrfs_compress_str2level(unsigned int type, const char *str, int *level_ret)
 	*level_ret = btrfs_compress_set_level(type, level);
 	return 0;
 }
+
+/**
+ * btrfs_match_compress_type - Check if the string matches the compression type
+ * @string:         The string to check
+ * @type:           The compression type string (name) to match against (e.g. "zstd")
+ * @may_have_level: If true, the string may have a level suffix (e.g., ":1")
+ *
+ * Return: %true if the string matches the type and, if %may_have_level is %true,
+ * has a level suffix, %false otherwise.
+ */
+bool btrfs_match_compress_type(const char *string, const char *type, bool may_have_level)
+{
+	const int len = strlen(type);
+
+	return (strncmp(string, type, len) == 0) &&
+		((may_have_level && string[len] == ':') || string[len] == '\0');
+}
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 1022dc53ec51..e67ba47b4cdc 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -97,6 +97,7 @@ void btrfs_submit_compressed_write(struct btrfs_ordered_extent *ordered,
 void btrfs_submit_compressed_read(struct btrfs_bio *bbio);
 
 int btrfs_compress_str2level(unsigned int type, const char *str, int *level_ret);
+bool btrfs_match_compress_type(const char *string, const char *type, bool may_have_level);
 
 struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info, gfp_t gfp);
 void btrfs_free_compr_folio(struct folio *folio);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 464129b1b0d4..00452ed872d3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -261,14 +261,6 @@ static const struct fs_parameter_spec btrfs_fs_parameters[] = {
 	{}
 };
 
-static bool btrfs_match_compress_type(const char *string, const char *type, bool may_have_level)
-{
-	const int len = strlen(type);
-
-	return (strncmp(string, type, len) == 0) &&
-		((may_have_level && string[len] == ':') || string[len] == '\0');
-}
-
 static int btrfs_parse_compress(struct btrfs_fs_context *ctx,
 				const struct fs_parameter *param, int opt)
 {
-- 
2.55.0

