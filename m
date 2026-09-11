Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D52370AE5
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 03:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789097640; cv=none; b=XMajOvby4OtbQ0A8j7TSdekCbDczeLYvV3reX5ECBPvjPVwR0ffLAncoRMLOf0f6JH2jJN4kauJIFWXn0Sj+AHwBCogUtAOfa8OixSPBA8bOInBn1KdHZwmJ++2mlnzVI5LjxIrWKIUjtcRrujNNcF+6sR7f734WinS7L2k4Ms4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789097640; c=relaxed/simple;
	bh=mo+M4WxlVeudge8H+ednqjMf1xNuskB2V4NIJYExa60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/BzhCDa6JguHW4y+a+LB6Dm3RlccLdhE5wgHTvpu5yMR9erLxfuyVv2qiBf3XEmekuHmBRC1PKEo41OzvUrQg/O5b4rutdq8tuYH04hBnwyHvUxN+f7ZbpHNBujhDDHQWjgVajzN3slESi93+pjsLDOPehZRda/S5Z0z+kLuX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ut7WpaHO; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ut7WpaHO"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd38e0f79so2355535e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 20:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789097636; x=1789702436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5cl10t76VYkno36ovaUOcHrrjyEAaNIH7dhahegRDZo=;
        b=Ut7WpaHOdeZ4CBBYnOkohtR+yG6W/O5vv1Hcfve6fZ1roBQJjdC0FTt0uXIPJjrLBt
         uy4LMvabmflVKQljUFWtTC9CLm4pWYiukH0AGDlFy0l6FhWNsn8EZXH4P138euu8utQ/
         Dv0uEoWDMZnLxpgYHkRq+Ump0Tdkodf5HCJbt5UKvwH/BBehkZOFEtYhGXrFqZadDhok
         zdKu7khuzzt7NMNZ2GyDJOGAYn159e3yWQycgXM4daNJvvIG/oQUP4B0wbmGvC5Ba9nQ
         SLmY/fDU0rENIwBFNHWLFrB1PHPmoaDP/FvMyNKomUPf4t0wBO0EhA2p+8DdfgN88r7L
         92Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789097636; x=1789702436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5cl10t76VYkno36ovaUOcHrrjyEAaNIH7dhahegRDZo=;
        b=kP3mfwCYMnUB0Ou6rmav0+CplU0D3hriWa/lIxMs5mMrFqBYj7P6s7HWkRt+T6o67j
         QZbLpmYbjWf64MTF7ln0uHD/+bVlIiXXQgCMD7elipjN9OJBaVNhmi17kKI1ifl3Q2zr
         vdB2GTi0yQ0YN+061QOpAvqUb0HyJD642CxawOCiOfNjPjCB5Ekh0uFNvTg8EnYvMEr7
         pqNHd9dR9aGGROf7PjEau33ng0D2yHi5xRX5VETRW7niCw04M9ahonNWn/doUTpMzJ1b
         pVF2SCb/jLBxQxz2IhfObsABz0LDqMngtGtT4oXNjagkPI118WC0eAaTmUxjzx9eADzN
         nqYA==
X-Forwarded-Encrypted: i=1; AKwUvBzfd1eiyhuGb+pazM0xSmEofgg57uDplCw+qNml1aKxqhl5yHb0cwHzyRTqh11uaOB44OLCdTUsawH1rg==@vger.kernel.org
X-Gm-Message-State: AFuF++mg5eF4702ZIRfzm+hL8Bf/q93ugwuGsrhEb/hDehDUFQs3P0Li
	2O69ljqLEEdm6tNVRxuh6CN2Nk/W+jKml2AOTPQGZn2c5S0LMqjlIWC6
X-Gm-Gg: AYBFou0ai150yYQpKyJQIVg1jZ1leVvPJGkRMDApLOJUj6l8x61dD8o70KlMxaSQLeP
	8k/Ws3S/Xc9FcnbklYaOAsDlI7+2+MNL34nFg/hMnDFJmY6KiTY8PgUIXv/+yZ5gE1h9J3pJ9if
	W30/GXB+wk4DEzv2jql01wsZlxgUe1kZyq+wpyjUulFbcH95V5fApzNr7iwPNWxOSIHQOAwVZav
	ktZJKXIx1+HJzsc5gerq7YC+XiBW4yA9v6U5xfy3h+J6wKXohbzMZjd3UYeo3mlihU0Z/UADLK2
	NGDupF+fLb/N8k7yan0iiZgdE3uFqmL6DuTLf0uWJBkfZhp4j6o1T8L9c4C4Imi716DYHZJIEIr
	Pq7blEV8/sGcSbjipyntpLsOp14Lh7Sy7mdbwircHuPW3G2vOwg1BEjaqt5BjvLcHg1+W1xn8GL
	yJ6fW2SI+ASytomWnZEpLGJ9vnqc5Dhbaf809KcH4yx3eS2EhLhjFQrFS1a09Ak2AuWw==
X-Received: by 2002:a05:600c:a0b:b0:49c:e1f1:3dd5 with SMTP id 5b1f17b1804b1-49e618863bcmr43498245e9.4.1789097636328;
        Thu, 10 Sep 2026 20:33:56 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e60ac42b9sm38935095e9.6.2026.09.10.20.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 20:33:55 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 4/6] btrfs: support inheritance for per-inode compression levels
Date: Fri, 11 Sep 2026 05:33:34 +0200
Message-ID: <20260911033336.957102-5-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911033336.957102-1-koray.fra@gmail.com>
References: <20260911033336.957102-1-koray.fra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change prop_handler's extract() signature to take an output buffer and
its length. This allows for the algo:level string to be generated
dynamically, but now the caller is in charge of managing that buffer
memory. Before this patch prop_compression_extract() would return only
the address of statically compiled string without being able to add the
level, now it concatenates the level to that statically compiled string.

This signature change is fine because the only currently supported prop
is compression, so there is only 1 extract() function.

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/props.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 7b966b9e4c8d..1a6b0103bbfa 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -36,7 +36,7 @@ struct prop_handler {
 	int (*validate)(const struct btrfs_inode *inode, const char *value,
 			size_t len);
 	int (*apply)(struct btrfs_inode *inode, const char *value, size_t len);
-	const char *(*extract)(const struct btrfs_inode *inode);
+	const char *(*extract)(const struct btrfs_inode *inode, char *buf, size_t len);
 	bool (*ignore)(const struct btrfs_inode *inode);
 	int inheritable;
 };
@@ -411,12 +411,19 @@ static bool prop_compression_ignore(const struct btrfs_inode *inode)
 	return false;
 }
 
-static const char *prop_compression_extract(const struct btrfs_inode *inode)
+static const char *prop_compression_extract(const struct btrfs_inode *inode,
+					    char *buf, size_t len)
 {
 	switch (inode->prop_compress) {
 	case BTRFS_COMPRESS_ZLIB:
 	case BTRFS_COMPRESS_LZO:
 	case BTRFS_COMPRESS_ZSTD:
+		if (inode->prop_compress_level) {
+			snprintf(buf, len, "%s:%d",
+				 btrfs_compress_type2str(inode->prop_compress),
+				 inode->prop_compress_level);
+			return buf;
+		}
 		return btrfs_compress_type2str(inode->prop_compress);
 	default:
 		break;
@@ -453,6 +460,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		const struct prop_handler *h = &prop_handlers[i];
 		const char *value;
 		u64 num_bytes = 0;
+		char buf[BTRFS_COMPRESS_PROP_MAX_LEN];
 
 		if (!h->inheritable)
 			continue;
@@ -460,7 +468,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		if (h->ignore(inode))
 			continue;
 
-		value = h->extract(parent);
+		value = h->extract(parent, buf, sizeof(buf));
 		if (!value)
 			continue;
 
-- 
2.55.0

