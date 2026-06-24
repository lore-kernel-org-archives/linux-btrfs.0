Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3C8388E50
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 07:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284900; cv=none; b=o7AahA/w4ldNNv43tED/yTm6oyZfRdOqo2L0f59rM8h6SYGo+SZ+Qf5qCie+JzF3Rmg3xBoQm/bcrlGocqIjd4vP5cJCL3jgmSTfwF8JMaTn5IwOtLFQnidpvJ0FO6BhPs1xluAQFFw52U4uSCAOgQBVlWminPwdfBfSNN+kZZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284900; c=relaxed/simple;
	bh=AMZsavkC8FklpfYctrTLn0ToSzq6Q6hCQGTI+SfFzUw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gQINXolVKfjGFx2SdM8kHfH7NoZRcPLR6dWyKYDnUxWG7nXIwSWOp3XGDwEkyBpepUjZdc4w4F00BHdIJC6jEwQnc8vv37HeCvZgGQH+rVWxGsUZyq0ltY3p3EjIdr4sn9z16/JsGsshmpWhSKjJaiPe4z9x4V+6GfWNXxPkZR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NXJCc4I+; arc=none smtp.client-ip=74.125.227.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NXJCc4I+"
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2c6cfe68fbeso169205ad.0
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 00:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782284899; x=1782889699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DqfAPLivLaEKxEjXrJ1o2niNyIWE3jgdfKWFG2lpuNw=;
        b=NXJCc4I+OVG/K0UIW10q/iEjs82JVqNbbtEJn5IM5Y5QBXgkhdRVYNZ9RCCvD93whh
         z/K+hpS6OPjj//uy9LQ5VMo6PQ8fM1D1skY0CID6L58PC/tUMRoxXVOISyTr+lYax+Bg
         4kCUWh1cpxIiT6hjBI+0cWejKqS7x2Mi7crbomamL1n3m8fbvrv8/Fwo0v9pO+8Sz7mC
         mI1qEFPP2gDMnZ5g0wHKgMsVM0phokpDoJIIhRlTmclW5pEYRgrf+Umh7EKCKPtdnHDO
         PLLfYmsUmXOinYGlsk8HSou8cSGVJL6lliw6y06X/XxW0y6mzmjf7hihF+ttGp6g0SP7
         OXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782284899; x=1782889699;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DqfAPLivLaEKxEjXrJ1o2niNyIWE3jgdfKWFG2lpuNw=;
        b=UHOJ2cSqucNr2QfbmbqEqh9/weUCMRTwj2AzYvWvQVrEM83PmXZrdxdIzFICtRIDDz
         F2dpvXI4fg55emRvmq2YKN7UwT/r2ilxt7TTh+f/6WEdSJ7O5SlCYHaE25o8Tjf0aLbW
         ZXFmxRVQWvKiKNK5H/bf5oK+jovlhGEsLhFNrOFzvL6P2lp2iziPRxam/+SfJ2JoKypu
         j21na5W733ooIXZOU2edXEJumUd3thhwk6l/lI7AP0Z2Qpc7098aqBM17DwXfXg2wIPk
         Wkyqar2BnK63W80X6WJWJ4hg7NyKtvNHVqKwbGItxU+6aUhAwDgqp/VNpjAcjB1jYgJJ
         p1FA==
X-Gm-Message-State: AOJu0Yy5fKqY7+arjUsunK4kCOIRrwpwXPobdERr87R10Qc74bou7mlv
	fYKbwrCt55MiahmWx4K7K0vHGpBCD7NwYpiL2i5W4JuJSQq7HZeKQI+fkBttk6vxTxkmKg==
X-Gm-Gg: AfdE7ck6B36J1LnztOfm/3L2a1/7EnzBOPHbjgKcqtEUqB4rE0s6qCL0sQSag+O/kWo
	0wCraAplcc6DoqOLc3XUJy5H39N3FIg/4xtGApS4oORAgv09ar2/JfS9YvE4OLXUYhtSZxnzH8b
	lh1Ju8rc1AeNz67MyP5ucdH1AzZcYqgW8zoKkfM1tzF4nwsfUfB7OASG8LIp6o+f15iFib0Kwwz
	uNcCCaoKeyc0rtySO2cytAhTW4o+46IBe3+/iARFNj6RJcs3FIVPMstHOiiwkEZSeu5L2uGQyuy
	eaZx/zsB3cd1WClPS9KY5zsGi2czW9wTUTeDi+uBb1us/+k/iVRUYUBcie7zm6EVYSBjvW59V2O
	KVrqxi2lQWHs7o5kPVYMaCzJUVDZ0vk/nPRq9gkKUZ9RpIVrPPtxOgYnCNxcZigXXyCXHIam/XR
	o4USf1KOEvY2K3DAKV6kDO2pjqeJ/nv+dRxNh2ZcDw
X-Received: by 2002:a17:902:d4d0:b0:2c0:b359:99c1 with SMTP id d9443c01a7336-2c7bf10e092mr38442355ad.2.1782284898452;
        Wed, 24 Jun 2026 00:08:18 -0700 (PDT)
Received: from SaltyKitkat ([154.83.91.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8bc563c131sm13378600a12.18.2026.06.24.00.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 00:08:18 -0700 (PDT)
From: Sun YangKai <sunk67188@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Sun YangKai <sunk67188@gmail.com>
Subject: [PATCH] btrfs: uapi: fix stale BTRFS_SYSTEM_CHUNK_ARRAY_SIZE comment
Date: Wed, 24 Jun 2026 15:08:01 +0800
Message-ID: <20260624070806.4534-1-sunk67188@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The comment claims room for "14 chunks with 3 stripes each", which
was correct when the structs were smaller.  Since then three additions
grew each entry:

  commit e17cade25ff8 ("Btrfs: Add chunk uuids and update multi-device back references")
    added btrfs_chunk.length (+8) and stripe.dev_uuid (+16)

  commit 321aecc65671 ("Btrfs: Add RAID10 support")
    added btrfs_chunk.sub_stripes (+2)

A 3-stripe entry now takes:

  sizeof(btrfs_disk_key) + btrfs_chunk_item_size(3)
    = 17 + 80 + 32 * (3 - 1)
    = 161 bytes

2048 / 161 ≈ 12.7, so "14" is no longer achievable.  Update to 12
and add the explicit calculation so it does not rot again.

Signed-off-by: Sun YangKai <sunk67188@gmail.com>
---
 include/uapi/linux/btrfs_tree.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index cc3b9f7dccaf..78404abc4ba2 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -504,7 +504,11 @@ struct btrfs_header {
 
 /*
  * This is a very generous portion of the super block, giving us room to
- * translate 14 chunks with 3 stripes each.
+ * translate 12 chunks with 3 stripes each.
+ *
+ * Each entry takes sizeof(btrfs_disk_key) + btrfs_chunk_item_size(n),
+ * which for a 3-stripe chunk is 17 + 80 + 32 * (3 - 1) = 161 bytes.
+ * 2048 / 161 ≈ 12.7, so at most 12 entries fit.
  */
 #define BTRFS_SYSTEM_CHUNK_ARRAY_SIZE 2048
 
-- 
2.54.0

