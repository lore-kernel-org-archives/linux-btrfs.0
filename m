Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793181106;
	b=dJeT9eFav2q6tUCKQnliMwEOlXSAfKI8LutFhGNbM1mdZXT3wvAqCyAFDC63G8wQYDKW
	 mz1M9avVtvWt8bR6q0UWDAoV2mwoKKqgZkSI9I78KuW7i6MQSbTQyMbi7mZvENPBz62QJ
	 aVhjb6dJY6M4ZwVGxoKHYzl9iBJOWFM5QnLcTeM/9Pk8mp1dTH/IGD/rUf7lk6RcoROvv
	 uk4PniDldZMnq2D5E5UqqPTLIRiyYzKfHSog6RcyMCjkBUm5vkagMjmfUjHrmc79YAj+Z
	 +vxudZ5R4DoLeiIDEuY4N+jvWVXJI/GPPV5nhUNgOlSVpUIOLMciY6vxPsYoQAN+E2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793181106;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DbKwU23jSrZK1UdP6vJH7WyOhF86zBsgvRqTgUfNiQ0=;
	b=cSp8WnX17lrZxon9Z2z+mqbb4YNbM/ip63SGIW6ddXOodT+DZy1asLEC3AUP3vNp41k7
	 uDd37GcbTKrzO3tYxWmsSdmK2qB0Z+ffaeEBFhFzEFY8wrnd8moV8zUj+wRrwM/0pYsQ8
	 CABCeEbVkGvJJ4T8o2lv8hNDmHmmlBeOQnLZYGxzq/NrAzJ6YhbMe6cC0tRnI7+KW3t9c
	 noGNqN0zn//gxU4moa332jM9nthu6y3th6qtQQbPAIoOVm78zjX70ePI1XCfv338srBUY
	 20mjPRLj9f9WQ3HSND6l8/H1ShwLGRQr5uWdpVql13TVHJvZX1y70m2BxV2GGDBiz0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BgEgNzyT;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3497A606A322
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 09:51:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3497A606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BgEgNzyT
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a20be3b39eso835325e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 02:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793181105; x=1793785905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DbKwU23jSrZK1UdP6vJH7WyOhF86zBsgvRqTgUfNiQ0=;
        b=BgEgNzyTIjMWtkSWmPLDCcn2YgLoG5EjawL2ES59oO1gO+nSzZrCvLXdNDqehm5nIQ
         xljOtI5a80Q511qxdKayhe03PC3vcrAdoiEqz9/1q1Cj3BW8euLKXdIbQlIhBSHNEqVG
         QCEvFlonWvrq22n1CyaGURkf0kGuiLODsUN4p/08GvaZ+OT8D9Dc1F1ERUXFx5XKMGYf
         ygPgBM8T1LwR8QI0jUgsjytn+NwyVlgvER8EVt/40C2Y90og2WgNPDZKHLXBHsEm4/Qn
         SgT/cAOWzaSWrcqwNhK3yPOrLJJSWGNkNYHYA+bG6plzSjcS8KbeyEL9mmuBfUm4mj1i
         BiOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793181105; x=1793785905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DbKwU23jSrZK1UdP6vJH7WyOhF86zBsgvRqTgUfNiQ0=;
        b=Uy8YKclAwknL+eM2z5RFqaB4WLQp6YKGCg4ItdxYXgdv6mgUQlkByMejwU/WUC6O64
         2q4uDZJdDV3om8WWqIsSU9tbhE7FyIu29+08yhc93rZSuR8wi0jxUBNo467Aoh0FJFEE
         Q2uYPDn1kWYZnkfVfNNDpl7MmvHNh+cjdIhnO4K6sZzIRgJNQ6MUWBgfwevt2wd6Ew/p
         4dlMN76jIa+wiI5r1SH88PQuXTQhoKdWf2JzAvgg9vjaAfhLbGEXGJv4zKrf8cXio54c
         n6EYIG3AoE38bBV1cVCnvdkIGOYu+kPYiandWiFJPQFBjyEJJK/H6466BNLtojnC570y
         O8kA==
X-Forwarded-Encrypted: i=1; AKwUvBxXlxp6/plWYcIdTGWiiudzist/dyCRqXSv1mB8uO+DDA956SKGR10nLRHhoOdNMVVgUggH8u0hr3aEvQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLGSsu3gw9YpbK3HFVipQ2xnjinLuzcSS85KrRuzsvTBqtcGFIH
	FT97AL5W5XNEs853M0zqTlsBwyOIsvGGjbStSqeVwn+Vw2/h/ogBuq5Jii22Lg==
X-Gm-Gg: AYBFou1jMVHLf0qj8Rtlnk75ixHGy+EkPooiizupnTc8mmYVzxWvqFBYgmHOWh2Rvpu
	yV7fSWfY3ODWVDX5R7gAvrwAgDaqzrTWTMp3bUiEFJam6ZDZez8TnrbPsoOZTkF7DJ4ZtkmoMDU
	J3eZ9ox3jR4J/DegdAzHb7XkytszCy0RZgFda6odInAAcbf2aUMQaQzMXb+sP1UrCfKUHJL6UaO
	5LvsnIpHDyD/0KMecB94SahO5h3HIVMR4bqVac5rld0thuSidhyuLl8d3dU3t35Pan1yRnCsy9Z
	HQ67iI7770dzRfcDqM4rnY6qckJobIFqgKfvERLxp1tDiBqYEmkwtRRb6mgT0P7ZpRw6Dia7MpS
	BUIcW/JVK1w5E6EWg8/1YmDzy9fUUhq3h7W/5QbNVaVi2NKiQqpLDe3K+3Rc3MIbyuwxFPQ0P20
	kjUaFp2dLNSaup2MgwSo+8wxBD6UMW0KHsA+9EbhqyKBxalYZjGQg6PYt7eTzhecC9+S36ssdS7
	kd4QDm4QZLTa9cuTN1XKzhib/yHK3jWByi52xcmRXUdz1pGztMEvZUSZ4hGFWfijzOxhm9SHS8m
	doZcaO3qthHT8CfOnq56LoK5PHPtqPYtK04btUn+is2TDcnnQSx3MSdzGWFh0JIfxEOJC48tUrC
	WjIEetWDLnL4pNV6mGmY+6Q==
X-Received: by 2002:a05:600c:c3cc:20b0:4a0:1f9e:5f78 with SMTP id 5b1f17b1804b1-4a96179c9d9mr26099685e9.0.1793181104449;
        Wed, 28 Oct 2026 02:51:44 -0700 (PDT)
Received: from thomas-precision3591.paris.inria.fr (wifi-pro-83-149.paris.inria.fr. [128.93.83.149])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-48e3ebd4bc5sm27552365f8f.34.2026.10.28.02.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 02:51:44 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] btrfs: zoned: fix double free of bitmaps on clone failure
Date: Wed, 28 Oct 2026 10:50:51 +0100
Message-ID: <20261028095053.20459-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_clone_dev_zone_info() duplicates the original orig_dev->zone_info
with kmemdup(), which also copies the seq_zones, empty_zones and
active_zones pointers. The clone then replaces them one by one with
fresh bitmaps. If one of the allocations fails, the error path frees all
three pointers, including those not yet replaced, which still point to
the bitmaps owned by the original device.

Clear the three pointers right after kmemdup() so the error path only frees
what this function allocated.

Fixes: 21e61ec6d0bb ("btrfs: zoned: clone zoned device info when cloning a device")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 fs/btrfs/zoned.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 08a15465a087..7dab7aac7b96 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -645,6 +645,11 @@ struct btrfs_zoned_device_info *btrfs_clone_dev_zone_info(struct btrfs_device *o
 	if (!zone_info)
 		return NULL;
 
+	/* Don't let the error path free the bitmaps still owned by @orig_dev. */
+	zone_info->seq_zones = NULL;
+	zone_info->empty_zones = NULL;
+	zone_info->active_zones = NULL;
+
 	zone_info->seq_zones = bitmap_zalloc(zone_info->nr_zones, GFP_KERNEL);
 	if (!zone_info->seq_zones)
 		goto out;
-- 
2.53.0

