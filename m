Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F6E36A022
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 21:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781213092; cv=none; b=Z18jnw4jC9crtbWCvqxfgi2nGfPlJCkcxyRlEKPD15QX7UaOzw09dDB4P0ZAXERfMOBbkHwGZm3/+N/bKgm+95MCg15cYqNjie0eReaZctav4pMR6t4sFJrdqhhm2F1xwY23pRlSznclQrvdaH3x9VLxJzgwDBBLK/HIt0/5gmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781213092; c=relaxed/simple;
	bh=jMN/1aQdUacQw37CoA5G1RDGKU9+Br07yXHh8f3cvGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=saZOF82e2j+SWL1XnFo2YKWJaRH2LEBPTY20ONo1iDk5HGLn226XZSQ8RYxpUaWv2GUEitOnKISN8r8IZ2acVkusXQyejjTJURsfmAmP6xCn1wptMyvArVXvAEBCua5j4b/7iOImxbX7L3jyShE6aqGtfKM6R+Pdk+uWfTiLygU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com; spf=pass smtp.mailfrom=openai.com; dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b=QiQ7l4z4; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b="QiQ7l4z4"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-9159477c893so42587785a.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 14:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1781213090; x=1781817890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oZb0xO5n0S2OTyc+rJ6TCTi3OZkKPUT9vDDGD9gSnOk=;
        b=QiQ7l4z4mHeOFhBSUrf9uZFSFGwaPnKViDMg51YBtaxhNGMHQVPrUoDFkPaop5D9pu
         Cfp95b2NPVcmrHtHjvvkAKUYNzE2LlJKaUmFm52ZBzbkMRb8/wv6XBDqGSNviOjqeytt
         F59YrlN/7gJT7n5IIVE8VUtKZRtdd9H9rZjOc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781213090; x=1781817890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZb0xO5n0S2OTyc+rJ6TCTi3OZkKPUT9vDDGD9gSnOk=;
        b=iu5mJTbbYVM+KsScLsr/TKJnmI3iiMk8kKSW+PdFFT+e98JUCb73QT1CMKUSNOWPo6
         M36jMUKTwEbN9mV7aMnk9BzxbhK3mmUhIlDYBDw+Xb3z8yClSHjmAMNVuEugHK171h++
         /qo6DQBqotHcopbk5iY7J+zxDxqFqhnh40fqYKuCdiiv6vPJu4uxqYinpmOWAdkkGTIR
         S2vWXKXWiFtLN3h2/IVAaAIFvtntgjVaoJE1lqQZAAODqqnLBbsLKvFMtEHgPoaAmGqU
         i4GzlZrv+UNr81VPVT6Ad3zkdgMdMWfBTJz8zqkBhoUN4HxCZ86oyTgXX2G9dD4naez9
         3tbw==
X-Gm-Message-State: AOJu0Yz3882fbq2Md7H3sEarmeuSnDDp//f+03jQ7bZdnVfUFFMqJfoD
	7FdzKUTFYEx3CLJVS7ioUjRk118FkGxSa7m/+j8fIeud82eXUcut16vX4QuGz5/RpcHqrxgXd33
	Q0YUdH8g=
X-Gm-Gg: Acq92OHpC8xPpWmiUeTerkC9/D3druVTrP2IJRUjiA89oNORZNW3qccvPv5vwo1ZETX
	JDAyXvKjxNrZkaOEWWNRFK5JZGoITpt3wKDNknIuuqr5eBe+6S/EzIJGEYbhaytTJkRkYoszS/w
	iuuDjflfcbsckfxJHqh7+HYKG87fL5dqhY4svhUHMPjevTO6CScoWeQMxb3AeFwphT2g3Xg07zV
	gGljAx9qp6C8gagjwE76cfAkat2sRXvbTDb4a7wE+wHtBbtkz1iDvPgKvnjyNz41ebpQcLqW16f
	aKINH543YB4pFk31ynH2xcV/zaEgtnwonFRzDcjXNh8GD7xFz7tNe7b+H0qwu4x3EPDC3EMUF7i
	eQkzvq2xiOY+rIkvr+Ztbz2qWsjnRxkby4mvZnNa/sZTLbgK8M/zQQODJj2mbpWDDENhTMvSL9+
	4Xyo8m0gBkFDx3fbxzVBPtVUYLRQ0s26PE/VWX+bbLSvWiyACrLeuKK7y6wckr/IjKmq4VV3RyV
	vr6ZlRO1UIZ5Q8jkMa2GnIeNO1RgB5ZN4c=
X-Received: by 2002:a05:620a:19a6:b0:914:b65f:6b00 with SMTP id af79cd13be357-9160ac7d1eamr718436685a.6.1781213089949;
        Thu, 11 Jun 2026 14:24:49 -0700 (PDT)
Received: from com-75606.node.ndb.openai.org ([209.249.37.146])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9161a0541d3sm24925085a.39.2026.06.11.14.24.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Jun 2026 14:24:49 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	outbounddisclosures@openai.com,
	Kyle Zeng <kylebot@openai.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: validate root ref item size and name length
Date: Thu, 11 Jun 2026 14:24:45 -0700
Message-ID: <20260611212445.4848-1-kylebot@openai.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ROOT_REF and ROOT_BACKREF items contain a struct btrfs_root_ref followed
by one variable-length name.  The tree checker validates only generic leaf
geometry for these item types, so corrupted metadata can expose a root-ref
item whose item size does not match the embedded name_len field.

Several readers later trust the item size or the name_len field when
copying the name into fixed-size buffers.  For example,
BTRFS_IOC_GET_SUBVOL_INFO subtracts sizeof(struct btrfs_root_ref) from
the item size and copies that many bytes into the 256-byte subvolume name
field.  A crafted ROOT_BACKREF item can therefore trigger a kernel heap
out-of-bounds write.

Validate root refs in the tree checker before other Btrfs code consumes
them.  Reject items that are too small for the fixed header, names larger
than BTRFS_NAME_LEN, and item sizes that do not exactly match
sizeof(struct btrfs_root_ref) plus the embedded name length.

Fixes: 23d0b79dfaed ("btrfs: Add unprivileged version of ino_lookup ioctl")
Fixes: b64ec075bded ("btrfs: Add unprivileged ioctl which returns subvolume information")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
 fs/btrfs/tree-checker.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 1f15d0793a9c..fb072045ca18 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1915,6 +1915,40 @@ static int check_inode_extref(struct extent_buffer *leaf,
 	return 0;
 }
 
+static int check_root_ref(struct extent_buffer *leaf, int slot)
+{
+	struct btrfs_root_ref *rref;
+	const u32 item_size = btrfs_item_size(leaf, slot);
+	u32 expect_size;
+	u16 name_len;
+
+	if (unlikely(item_size < sizeof(*rref))) {
+		generic_err(leaf, slot,
+			    "invalid root ref item size, have %u expect >= %zu",
+			    item_size, sizeof(*rref));
+		return -EUCLEAN;
+	}
+
+	rref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
+	name_len = btrfs_root_ref_name_len(leaf, rref);
+	if (unlikely(name_len > BTRFS_NAME_LEN)) {
+		generic_err(leaf, slot,
+			    "root ref name too long, have %u max %u",
+			    name_len, BTRFS_NAME_LEN);
+		return -EUCLEAN;
+	}
+
+	expect_size = sizeof(*rref) + name_len;
+	if (unlikely(item_size != expect_size)) {
+		generic_err(leaf, slot,
+			    "invalid root ref item size, have %u expect %u",
+			    item_size, expect_size);
+		return -EUCLEAN;
+	}
+
+	return 0;
+}
+
 static int check_raid_stripe_extent(const struct extent_buffer *leaf,
 				    const struct btrfs_key *key, int slot)
 {
@@ -2226,6 +2260,10 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_ROOT_ITEM_KEY:
 		ret = check_root_item(leaf, key, slot);
 		break;
+	case BTRFS_ROOT_REF_KEY:
+	case BTRFS_ROOT_BACKREF_KEY:
+		ret = check_root_ref(leaf, slot);
+		break;
 	case BTRFS_EXTENT_ITEM_KEY:
 	case BTRFS_METADATA_ITEM_KEY:
 		ret = check_extent_item(leaf, key, slot, prev_key);
-- 
2.54.0
