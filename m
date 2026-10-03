Received: from mail-dy2-f41.google.com (mail-dy2-f41.google.com [74.125.229.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E0E3AE198
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 11:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791026417; cv=none; b=DrC63YkQJzJWqf3YMYGITRpXfREzc6dE06basCs2SietihINhZlKGtHxhHZPUfwXHgqbDE296vlsFwFbBPgi8k8jqI2ucW46r9roCIUeNJpvmVpAgY9JsyKQduRMcb9z+TczDmG4BtdHJWlhybv6QeoFoSBng85uwQ/Es+xOUiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791026417; c=relaxed/simple;
	bh=8F2/r5gMwPr76pGM/0VjyU1pcn2Clktvo8cWtilrWfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P6n5rMD5U5CXdPE+4XwWGmXDNrdGU6fSKinvYrnxnn/iH5HdvsZA7TfQ2dX9k/cSsMVU7IaQzNOPGrcPygAEzOT6DfosyusAGFfRD5ATTVeRwOvrpLvAgmkFXSXzSmc8f7r7ypG6jcwnUww74mcEyqx5lca4/nBU0Kq+sEoE5cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qQWkojkw; arc=none smtp.client-ip=74.125.229.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qQWkojkw"
Received: by mail-dy2-f41.google.com with SMTP id 5a478bee46e88-34c0b552ccfso107404eec.3
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Oct 2026 04:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791026415; x=1791631215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kOSpg+Altzka7mc69KDPVCvTE45NVTC17QyZ1Q1TodI=;
        b=qQWkojkwh6SdiRZFnRxSwVOzdAxqZhlthTz4s+X26NFJROGQTsC2k22117EIdy/zyn
         NLVlcFtink0UD5cIuBoJyVK3HdzHQb8UBT9nsi+99gM6lHouSC6RNZ0qOYUgDZtAn29E
         qwmTfcBHxSH2pYUT4NMkgPyGVINmmCBIJW/AoCcPAB8foR/NTNMzjnXdld0ST70irS9n
         7KeV8nEy2ATbQ5Fd9EfVS9EQsqJRKgkb+fr/epGnwSP11nEj3Y9eepEUXaZizZuVv9/z
         d5h7CRG9+rBfQYUn8nXk8dYjHiyElN2V75mZuANLHHczm0SIZqrdjcSx7rHzXxYf2LT4
         3BdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791026415; x=1791631215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kOSpg+Altzka7mc69KDPVCvTE45NVTC17QyZ1Q1TodI=;
        b=Ig/YuTFTt4+MNV3wW0unQBSDZsiqio9tn0hfjM06j528M/HTwmbSu207On7Uliia1D
         1RE6DLW3x5s7GVPfnHfWkXFJX0j5sfJJ/eYKkmDFxC58aXEme67xJ4EzxdneMr9sNAwg
         h5GMcK/CcyjV02wvVSTiUS5s0YiXZ6H/weT+FsSpKdN1zEVZfDtd//K2xopKl66DtRX0
         SJTwm9hQa0loiivIuh4FbqsmGGu6qq6UY2m+If1zTo2LQE1oLySL7Gb50Xiz9bLuyKNL
         u29Y5PdCe0vY0bFHPCxN/o6oFwwJOelRkg559oCPPKl24/GvdvFyDwdc7WzJ05HBh4OO
         QbJw==
X-Gm-Message-State: AFq9FYJOda3XttGcrrIRJqNv1IDHjqU5eA8/VA/BtxCokOldrDklcgpP
	5Ytt0qKNdSGrqyhHqpejrl2jbw1VXFyJkCfkjUnHRW2J/ujDuexAfq2GU2CcXYXhlLY=
X-Gm-Gg: AYBFou1NPLf25nsEbio93w3HlRnXJ51FyB3GVJGzkKN8SfqvizPMTh9JDa+5r4yY45d
	GUub0OQw1R+YNJiHSKufZB5dPgXP+HrHG82rnw/FDy1uiLoOmk3dxkEW+rTEPMG/Ra6WfKxJSUK
	0zszNN6prxrDyyU537nOAZRzyXm75Hihft88hLbCDEiDbgjAySmumtiWfeEYmn1D40nSYB79lzz
	+F8ZCtFgomSDfynTs+MpZXL/c2pJ/p1Mn/FnfVQSXx0+EHENOctX0P0i6QLHWO5q2rqsI5lo2hH
	t0o6qwQPmzP0P5rjlINkM757OwV/7TcEtkA0q4WTHAHKo33s2C8f+OBS3K6h7+fjEfjUOGsRT0t
	YPbDsNxtXH09HZiVBj47CAuHY7idRVsQB0yo5R8u34PVVZ+6G8fLUJU77MShxBp0Z0saDaJrSJg
	ZD2E54pQrOUgjuT9MMtIFQy0W/PPc0yPAvMN6tnWYPsQEKgjVXEjr4VWlffd8G29sZj7Y599YRW
	A==
X-Received: by 2002:a05:693c:4150:10b0:33c:379:4857 with SMTP id 5a478bee46e88-34f14f12dadmr6803277eec.1.1791026415018;
        Sat, 03 Oct 2026 04:20:15 -0700 (PDT)
Received: from archlinux ([2402:e280:411b:ec:aa93:b1ec:5a6b:5fce])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3511d87d043sm1494874eec.21.2026.10.03.04.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 04:20:14 -0700 (PDT)
From: Adarsh Das <adarshdas950@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	mason@kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com,
	Adarsh Das <adarshdas950@gmail.com>
Subject: [PATCH] btrfs: unwind device add when sysfs registration fails
Date: Sat,  3 Oct 2026 16:49:51 +0530
Message-ID: <20261003111951.24527-1-adarshdas950@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_init_new_device() ignored the return value of
btrfs_sysfs_add_device(). When sysfs link creation failed (e.g. -EEXIST),
the add path continued, aborted the transaction with the same errno, and
tripped WARN_ON(btrfs_abort_should_print_stack()) while leaving the device
half-registered in memory.

Unwind through error_sysfs when sysfs registration fails, matching other
failure paths after the device lists are updated.

Reported-by: syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a791c94.01d0871a.3a0d52.0099.GAE@google.com
Tested-by: syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
Assisted-by: LLM
Signed-off-by: Adarsh Das <adarshdas950@gmail.com>
---
 fs/btrfs/volumes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 85ea9c5d4536..1517ed3da22c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3066,7 +3066,11 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	mutex_unlock(&fs_info->chunk_mutex);
 
 	/* Add sysfs device entry */
-	btrfs_sysfs_add_device(device);
+	ret = btrfs_sysfs_add_device(device);
+	if (ret) {
+		mutex_unlock(&fs_devices->device_list_mutex);
+		goto error_sysfs;
+	}
 
 	mutex_unlock(&fs_devices->device_list_mutex);
 
