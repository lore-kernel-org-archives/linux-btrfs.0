Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59E53DEAE3
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 10:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775040996; cv=none; b=Py5ZLJNShPUFnyNYE8MVu5ntUqOtkwruIOVM+oDDLuGPczRWIj68y2DyJJDd4LSII+g8dwZB7LW6Skf8hKQDtpFI0Yc1GT4sLW3W6w4y/UfZrPDcQ0NrZ5gK7bp/ySZIyUyXXbzQaTLoprQeuE9QMcPjuZuvit8uy3pkcfoOMM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775040996; c=relaxed/simple;
	bh=MyXYeM8EOJ+bWpDLvDHhshEwu7kHHDCWmI93VztoV1s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EokcxD0cusLKUKbTW0Qek9DQzh/JXD9e4ibatAQOx8ZfP63jFLrV83H+0fuE8TooijhwSdKcolpuip3gjK8KfXOznAQfY0/tlD0mNseZQoYpY+4fJx83lVK46SYr3nQga4mA/IhIXUjO8O/r5JTNye8BTA80Edv4Uli4XWKwzbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rUinOOsy; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rUinOOsy"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-356337f058aso4001123a91.2
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 03:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775040992; x=1775645792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FmAkJIVOiyu2su4iByfPKFkvSEqhCvUzVY7v1mQwfiI=;
        b=rUinOOsyoZVrTFi8jkClv7cWjcfLOYBk/FI2/VPXzGCmXGnF+lY8ySybDZjU/PX+7m
         0Jfgdv4WnTBW5ErbMFev/wD8UK7TNFpvX4K+MS81UnkL/Vso/XOsk00+02H8GXvHWVI6
         iHs9IFDp5T1yF/wwxyuNl7VizZkywOCRKPltF3vQX+LQ0cz0ppJsLHLbsEytzXfrtyFi
         A+LqP9nff0dcu9tvL97hUA53PpNqk6a2pxtAirB8h7mB9jDBswkDVcA//bNykUBlyR4o
         RrW+YM1ym+47yhtrhHzccdwD8P/Jlab4yFxhNzUOG7YQ44inHOfDnVHz9qAwlFTzoJYo
         5lMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775040992; x=1775645792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FmAkJIVOiyu2su4iByfPKFkvSEqhCvUzVY7v1mQwfiI=;
        b=QHWi+YlXg3wibV3YIvI8dMiORF4ZaG9aTM1f0y5Pk2G2i9MQfel2VwRIH0WSzouOoZ
         1oFbV0b4I4IRBza2rwOLlTqUgxJgyOjtPh6c0dsT9MIhuNbq0sVxKjDi7jYtuozHf/0M
         dUbEdB8mAUYROuWxP7AO7mTz3bi/Jh0yVcO2t6s5NjpHtSKU7hnaxwym3kzYGNgebihY
         z13NvUmYjdPiOqhvNnTkz9kP4JDjh5kaZqRjDgzmnlNsDk1lMR7I1Zj4e2gvW/3Jv1mK
         ymGQPUsoH4klpcCGzhXegnOL3OJtzDSUEVKr1KTG84vtTCNYVR+jkcvz6WXk/lEHkpJs
         Uuvg==
X-Forwarded-Encrypted: i=1; AJvYcCXAg8Mdz4JVlXdJhD5pO3EaUUHsh+UAFQLgXZEa81lNjfdFzMXRWFW9Wws+HIoW1P2c/g9I9zhYGA+E4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzIJh8Uq+sSrmOcA9xj/LECqfimunBgM92QAIsRAfGV2ecdfJQY
	eiwOXDMn8wZLAWHbWxmj95Rt/YKSZu1At+NOZ5JZCApmo1XT+IUeg2qb
X-Gm-Gg: ATEYQzwaO4BkM5aTzdluDAi4Liv7b2yMLPS2hcoBMc1yfF5nJT/fuxqXKO2aFx7+Whj
	zYbMG/ac6LvJf83SU47Jia3cXUovL8mMgE7NP2nHaYloLDT0lsEuOe/8ywi0D3D4/iMkpdrib68
	J6SrWRk3413C0G8N/SX5hzUEU0kNEurEAee9ODN8O3Vanzy9HLo+EDEwgZY54OIQoEA/2A91qCk
	ge25Jg6IlT1VQeBW+zCr1J6gveWtZsl98WX/0VL+FvoVqhgCtkdk0c7Onw/FiEygp0yJ9tZ2nCy
	ouPk6gaEiem/h5dEqhwmrbhFFy7P7KI+Gol1Ij5G6SmR1WeyPRk50nKGc5wDUCnVXbZJSrZvzcV
	RSmE2e0PtSNN1oijx28F6OWFhF+YakF08oFWSOk5Gq2xloGDU2PsTFBr6T+ny9nOHYe3/y8gO3X
	lK1MbrpE59XdI7cHNuAQr3
X-Received: by 2002:a17:90b:510d:b0:35a:18b1:c239 with SMTP id 98e67ed59e1d1-35dc6e9a466mr2738424a91.10.1775040991785;
        Wed, 01 Apr 2026 03:56:31 -0700 (PDT)
Received: from lgs.. ([223.80.110.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dba63e80bsm1679868a91.4.2026.04.01.03.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 03:56:31 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] btrfs: fix double free in create_space_info() error path
Date: Wed,  1 Apr 2026 18:56:19 +0800
Message-ID: <20260401105619.1506398-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When kobject_init_and_add() fails, the call chain is:

create_space_info()
-> btrfs_sysfs_add_space_info_type()
-> kobject_init_and_add()
-> failure
-> kobject_put(&space_info->kobj)
-> space_info_release()
-> kfree(space_info)

Then control returns to create_space_info():

btrfs_sysfs_add_space_info_type() returns error
-> goto out_free
-> kfree(space_info)

This causes a double free.

Keep the direct kfree(space_info) for the earlier failure path, but
after btrfs_sysfs_add_space_info_type() has called kobject_put(), let
the kobject release callback handle the cleanup.

Fixes: a11224a016d6d ("btrfs: fix memory leaks in create_space_info() error paths")
Cc: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
v2:
  - add the full failure path to the changelog

 fs/btrfs/space-info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 3f08e450f796..d7176eb2fcbf 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -311,7 +311,7 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 
 	ret = btrfs_sysfs_add_space_info_type(space_info);
 	if (ret)
-		goto out_free;
+		return ret;
 
 	list_add(&space_info->list, &info->space_info);
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
-- 
2.43.0

