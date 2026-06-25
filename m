Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2FF3EB10D
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 17:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782408296; cv=none; b=flGuBycFmkWh+c4+/Y1Fp8eqhyL8AvmLbSSXM49Z7Fw7xR6hujGFkTRBgJsl3XAzXkHiKC67ZpGVy9szvalLi+e+L3L7KCrEipNXVOVDlM0pJP0s5r9tioxESYIDpdXuGc98sa8fbjPHZ6c1BW3wjxciu2BkZEnYPBqefyDwASI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782408296; c=relaxed/simple;
	bh=HPc9KiFewGFxcjuXSS5JQGLOe88A69dyt5yVBlQUUUI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TvS777eua6p2UlY7miBTvnvmUl6rZW/6ew2fXOf0I3biqJ19MwcxHNNM2gZpyGd9XrZ4p+/4kZEApypHWg+PjUz3lb/5sMEBhgkiXwXDp3GgX6Ud3OB2og296SOdV2/rurRihr4llmKY7r3mg0/4xkCfM4p9VMj3TjjQ1Dma/0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=jjtdiU/x; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="jjtdiU/x"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490b64c8311so1161995e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 10:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1782408293; x=1783013093; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HAy5E/RT9dtJBEcYwCOZkE4Y70iWOvGi1RgfWX7kUvw=;
        b=jjtdiU/xCsJuQ23gW9iajrYOqVsNmjCpvAGpMOlSSGLxvaoCQjDT7ctsUpQuMNIWmr
         PQuNBbZSJqTl0exra8QIoHy+A+DTxZmcmDrb+3RpZp8iNJiaUyhMBMJ4KMkhyvqPk7V+
         vy+dIYj+2vt2ncruuj3j/PfxirGEbFlbr2P0tvuad/tx7nLTul3A7aus/i4LKRzLoQIR
         HAYIGUGWyolDY753b1Mahur4uEjciK6NLfKS0dC6bfJElpw9YyBv95xIdTcGoJHUZs3H
         7pUb8DL3D7v/Ajj77HbNzsc1WUihQoDoRW7jJoA98AY6PSPle4wAIVEKHdHQ2i/psWqJ
         bysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782408293; x=1783013093;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HAy5E/RT9dtJBEcYwCOZkE4Y70iWOvGi1RgfWX7kUvw=;
        b=hCTa4focmzfoqzXaK7PoIniECDYUoTvO069wZPAT8+I0oHUfk4rnLHlgwSZJYWS0mU
         TuROK47+hCErSrCJWEM0BazDNRsBYx4XDhy7CsC9cgLHQJ9NUChSqCMV8lbehBxR8hTG
         VcqinUtawUeYpnpfjX+pkI7CTkoWKQmGB177lZjJWPP+O+vYfkW+xCnR63jMkW6rjEuz
         xkHIDzgI0Hx4j7c08YNgphrNk1l7/LxIvMwHDOZNX8oY3o9GSnCMuXGHjy9WhR2NFsIz
         e9HhLI7IGJsUneC6p/1XhD4fWDrVUa8Q+TASaT2IPAJOLkkHCVycJnOF1JUCt/1klumU
         PFxg==
X-Forwarded-Encrypted: i=1; AFNElJ8kV8cMdqNTquak1FnUOFh0XrEN6eSgR7JPe9EvrwXz1W6ZVIptMUS4FF6ONjfgWgu2ZwWNQF1bKmf0UQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzujCbcoQbuR5ZCv5b0XbA7wvSL8MpOmdmgg74EV2MSDHPgLwg5
	jIXb3RksvTpKinZk9H61FUHQlpzriez7bz0ZJnfS/C8aNn8DQzGGJL4ZtQwGWbcu2j8=
X-Gm-Gg: AfdE7cmH2A0syGEkns2pvRfXFOl6iQR1rMhG4YynR2fT3u3BXXKy1w9lXo4PIIH/Z+f
	Gcb/m8Kehlwm3XRTF0AiCNWIssWTTJhcqgfB7u0EDW4xWBWu/H0jEuzKoxyn6uGGxNDhrCfEU/a
	TNDquEsMyhhkINyxqQcMvct8iOTTuFQ29AL68ECzQZcrllccSdCPYkc0wn9Bg9OPKo3yUVk8JEJ
	Uv5yq0YooBAMlM8W7I4FtEdiVVnXPmXEFbBa/6BT/LBIicMBQ8Ovdgbv5y2TMGCsCGOdBEQ3eY/
	Wx8eAneQTMF9pOO6UW67oCyaYsGvNe/aYFTAXmcAoTD9xojLV4SNHJq8dn+v5blyb72WBcha3mz
	Thi9KlGPz0iz+RmnwOSkm/wXO8G5T8j72PDmC1UtCmfhwbZoq4YMrdmLX+u+dELhlJEhOIWvJ+C
	e7idKBHfq8JPj7Ah1xn+UOXboOXN7B7A==
X-Received: by 2002:a05:600c:3e0d:b0:492:4723:166b with SMTP id 5b1f17b1804b1-49266873f80mr46441545e9.13.1782408293091;
        Thu, 25 Jun 2026 10:24:53 -0700 (PDT)
Received: from alchark-surface.localdomain ([5.194.92.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492697ba453sm2585755e9.0.2026.06.25.10.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 10:24:52 -0700 (PDT)
From: Alexey Charkov <alchark@flipper.net>
Date: Thu, 25 Jun 2026 21:24:22 +0400
Subject: [PATCH 2/2] fs: btrfs: use fs_ls_generic() and drop custom
 implementation
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260625-btrfs-readdir-v1-2-dd781a2b3965@flipper.net>
References: <20260625-btrfs-readdir-v1-0-dd781a2b3965@flipper.net>
In-Reply-To: <20260625-btrfs-readdir-v1-0-dd781a2b3965@flipper.net>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 u-boot@lists.denx.de
Cc: =?utf-8?q?Marek_Beh=C3=BAn?= <kabel@kernel.org>, 
 Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
 =?utf-8?q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>, 
 Peng Fan <peng.fan@nxp.com>, Patrice Chotard <patrice.chotard@foss.st.com>, 
 Yao Zi <me@ziyao.cc>, Alexey Charkov <alchark@flipper.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3452; i=alchark@flipper.net;
 h=from:subject:message-id; bh=HPc9KiFewGFxcjuXSS5JQGLOe88A69dyt5yVBlQUUUI=;
 b=owGbwMvMwCW2adGNfoHIK0sZT6slMWTZpsRN3sA25dK7Yj6tBqa/MQVuLp/iXC/Xzj7HzDNVr
 9A1L3Fqx0QWBjEuBksxRZa535bYTjXim7XLw+MrzBxWJpAh0iINDEDAwsCXm5hXaqRjpGeqbahn
 aKRjrGPEwMUpAFPtsYGRoaOze4pEk9j02HVqstk1nn1z+6Q/iT6X5diSNH3lr7PStxgZbrgZbHo
 0Ob5zdt+cOR0MYcYP25Z9ePiHX8BRtES8eeNhVgA=
X-Developer-Key: i=alchark@flipper.net; a=openpgp;
 fpr=9DF6A43D95320E9ABA4848F5B2A2D88F1059D4A5

Now that generic callbacks for opendir/readdir/closedir are implemented,
the custom btrfs_ls() implementation is no longer needed, along with the
btrfs_iter_dir() callback iterator.

Use fs_ls_generic() instead.

Signed-off-by: Alexey Charkov <alchark@flipper.net>
---
 fs/btrfs/dir-item.c | 59 +++--------------------------------------------------
 fs/fs.c             |  2 +-
 include/btrfs.h     |  1 -
 3 files changed, 4 insertions(+), 58 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 8cf5be3790e7..e8aebc0c7366 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -114,65 +114,12 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 	return btrfs_match_dir_item_name(root, path, name, name_len);
 }
 
-int btrfs_iter_dir(struct btrfs_root *root, u64 ino,
-		   btrfs_iter_dir_callback_t callback)
-{
-	struct btrfs_path path;
-	struct btrfs_key key;
-	int ret;
-
-	btrfs_init_path(&path);
-	key.objectid = ino;
-	key.type = BTRFS_DIR_INDEX_KEY;
-	key.offset = 0;
-
-	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
-	if (ret < 0)
-		return ret;
-	/* Should not happen */
-	if (ret == 0) {
-		ret = -EUCLEAN;
-		goto out;
-	}
-	if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
-		ret = btrfs_next_leaf(root, &path);
-		if (ret < 0)
-			goto out;
-		if (ret > 0) {
-			ret = 0;
-			goto out;
-		}
-	}
-	do {
-		struct btrfs_dir_item *di;
-
-		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
-		if (key.objectid != ino || key.type != BTRFS_DIR_INDEX_KEY)
-			break;
-		di = btrfs_item_ptr(path.nodes[0], path.slots[0],
-				    struct btrfs_dir_item);
-		if (verify_dir_item(root, path.nodes[0], di)) {
-			ret = -EUCLEAN;
-			goto out;
-		}
-		ret = callback(root, path.nodes[0], di);
-		if (ret < 0)
-			goto out;
-	} while (!(ret = btrfs_next_item(root, &path)));
-
-	if (ret > 0)
-		ret = 0;
-out:
-	btrfs_release_path(&path);
-	return ret;
-}
-
 /*
  * btrfs_next_dir_entry() - read one directory entry at or after a cursor
  *
- * Streaming counterpart to btrfs_iter_dir() for the fs-layer readdir, which
- * is re-entered once per entry: returns the first real entry whose
- * BTRFS_DIR_INDEX_KEY offset is >= *offset and advances *offset past it.
+ * Iterator for the fs-layer readdir, which is re-entered once per entry:
+ * returns the first real entry whose BTRFS_DIR_INDEX_KEY offset is
+ * >= *offset and advances *offset past it.
  *
  * @root, @ino:		directory to read
  * @offset:		in/out cursor; DIR_INDEX offset to resume from
diff --git a/fs/fs.c b/fs/fs.c
index 4694a88f776b..1ebda6f4ee2a 100644
--- a/fs/fs.c
+++ b/fs/fs.c
@@ -320,7 +320,7 @@ static struct fstype_info fstypes[] = {
 		.null_dev_desc_ok = false,
 		.probe = btrfs_probe,
 		.close = btrfs_close,
-		.ls = btrfs_ls,
+		.ls = fs_ls_generic,
 		.exists = btrfs_exists,
 		.size = btrfs_size,
 		.read = btrfs_read,
diff --git a/include/btrfs.h b/include/btrfs.h
index 6fff45a497ee..3878b7817ea6 100644
--- a/include/btrfs.h
+++ b/include/btrfs.h
@@ -15,7 +15,6 @@ struct fs_dirent;
 
 int btrfs_probe(struct blk_desc *fs_dev_desc,
 		struct disk_partition *fs_partition);
-int btrfs_ls(const char *);
 int btrfs_exists(const char *);
 int btrfs_size(const char *, loff_t *);
 int btrfs_read(const char *, void *, loff_t, loff_t, loff_t *);

-- 
2.53.0

