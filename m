Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30092C3251
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 11:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775041353; cv=none; b=rUimgH2Hps/m9UkxmD5uwHIiB1ENwf/vuxRGB6vfgYdEI+M1OJEuV+FDpEpFTGYIrZKjpk+VsAGaaS3BlyOxXU8bVcUAuj5Bfio5EW4fh//a9akogIfgzTOr0o68BEoDu0Ox/zjbnagMnJwYp8t6Jl5e2H/1A2R2y7kgmMZLIs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775041353; c=relaxed/simple;
	bh=SbqRNhVI3Sgg9eZpNawZvYKHn4MdY9ZbL6RY8LFSIjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cgkaSfGUzF8N1B4jR/I91TIJDfN6uDrBWQ4idGRcAXXSWpVSzayFGuzbXvWC6z+hOH8qgut+q2htzp9e+s9kKUzDp8VUvTRH418mbPq2WZlbQF6V+Q6Cz+HQZEIBvNdFe7B/HymVoedZ/Hu6jGykUeWjQNtiIdP6DWIoOkUd8uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n5V5aRTm; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n5V5aRTm"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35c1a131946so500220a91.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 04:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775041351; x=1775646151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HirRrF/8RjBfg411Yn+GABwevBrUwvnGEoVcLWmnLPc=;
        b=n5V5aRTmgjSYRFS/JeajMKCd6eVvqsLLjjalILqW2n0U18iqBWgZHt7RU23L2RP0jd
         1g+AG9MtgVT4AG5U4p+mqtXpR/dCvNSl50YJjuSCq6eApt89SnTQV6zqwkqPfh8pS+R/
         WQQCCt3j8fSjrD4tRuUcxBe1goOS8PJotNXyJY98J1GE66kZUb7FCBHKMhAN7rs2ijtd
         tzcu3X17j1hhiQr2moYaTY742SuL9WSH5C7UmXQlFhxL/tTESRsuysVAbgJMezGecOQM
         s9fFun3mn0Wu3Q2Lrd4cGGAcG4btaQHvi3Wa1qVRhcDBn5LRgJX0iijtjUXPmxJ8374S
         ZtXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775041351; x=1775646151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HirRrF/8RjBfg411Yn+GABwevBrUwvnGEoVcLWmnLPc=;
        b=I5BKj0Q+OKjvfKuuIXaBqf+vCHGQrRoZBmYxa+k8xgLNdKxDZdCzJ+j926y9y+4DIE
         UGaRsEvGB5Ek4w6m1ltDVzUyOnzRrDOum0LQxNERak/VbmeAfWVYNETDEx3OX290xM+/
         uWBih88L/dtj4eosFrVeVxiTsZjWggYF4E3zMCVRaYTJMzb9gtvTngn0ejSkEMW6Re8+
         j8+/1hum4PK6rO6BFoR2cQmetLjiLTXiMOGXfc2EuunbFD/82WxbubEh/vwmHxUc6SNb
         fV/iph574/MM7ro9P8GUpWn4aFcK+9u7YntIazrh7WOjGT580e1vKGryRpVwkXSXxpIC
         kwmA==
X-Forwarded-Encrypted: i=1; AJvYcCVyLHSPg8XG5ohqW/kzec02IrlbAJra0YWKzzqHYLfGmFLLD0gMWhTPeX+Xvj/Y/Ei7cIttigPTNWen7g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzI6cq4pjRkFTwW2UrsfMuD9ZI+54SqYP5PUsZ8LGbR3v3+vnyx
	5BPqkv2GW3SFaOO2iUGyR5GuSJMpCsNgH5KVuLYgTsBxQfKUZYZEUG5e
X-Gm-Gg: ATEYQzz3SSVf178iTO/LYi1wAL3Xt1NXy8TzOoBo6M4l6G6Jw4ElSsyp0eraXBozS9v
	jsr7vKZneFA0ML4bMo3dFSZnHUnwdNpIdB3y8JDDMj9hE7XmRnWBhaYgLGdNWNzmnggaEqaiO+5
	gIfX/pwatx4yYvoQcXlJlk48iszHSIc1PyjrgzJxdTksWD6qMoGlVP09l9i5KdX5DUmYyLOkqh9
	0j7FtiHm8swUg5fSKVyK+Bt8NvHbL/gZrCFR6DWXXDJHFA7mw1Yorlu98VgrtRVJ7DZi1NZRT9j
	i995sDK5rGCpeXK9q+OmwLmU4M06DvLK1oPZFlfvByCuEIhdVl45VghJN8+W78EOC6Fc5tuQ+W1
	7ChBU1+IEnqY7EYTZVqmDFJziWoT2Azy+qKJQd4dOeh6eqf/HpoYmTJhCx7Hc1ejaaBC45AqXlf
	sOAh+6C1urJCJKpmY=
X-Received: by 2002:a17:90b:1d03:b0:35b:9d0c:a2f3 with SMTP id 98e67ed59e1d1-35dc7027dbemr2379083a91.15.1775041351018;
        Wed, 01 Apr 2026 04:02:31 -0700 (PDT)
Received: from lgs.. ([199.182.234.55])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe977031sm4604626a91.17.2026.04.01.04.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 04:02:30 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: fix double free in create_space_info_sub_group() error path
Date: Wed,  1 Apr 2026 19:02:19 +0800
Message-ID: <20260401110219.1517804-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When kobject_init_and_add() fails, the call chain is:

create_space_info_sub_group()
-> btrfs_sysfs_add_space_info_type()
-> kobject_init_and_add()
-> failure
-> kobject_put(&sub_group->kobj)
-> space_info_release()
-> kfree(sub_group)

Then control returns to create_space_info_sub_group(), where:

btrfs_sysfs_add_space_info_type() returns error
-> kfree(sub_group)

Thus, sub_group is freed twice.

Keep parent->sub_group[index] = NULL for the failure path, but after
btrfs_sysfs_add_space_info_type() has called kobject_put(), let the
kobject release callback handle the cleanup.

Fixes: f92ee31e031c ("btrfs: introduce btrfs_space_info sub-group")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 fs/btrfs/space-info.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index d7176eb2fcbf..f5d0f587b755 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -277,7 +277,6 @@ static int create_space_info_sub_group(struct btrfs_space_info *parent, u64 flag
 
 	ret = btrfs_sysfs_add_space_info_type(sub_group);
 	if (ret) {
-		kfree(sub_group);
 		parent->sub_group[index] = NULL;
 	}
 	return ret;
-- 
2.43.0

