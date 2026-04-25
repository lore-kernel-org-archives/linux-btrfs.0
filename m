Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B53224AF7
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2026 06:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777097542; cv=none; b=ilLmj87/1rsgJWUmp86ui93pgoY7o5Z+DLPSEZljKyUskFLM8GDaWDt8R8MU8eGHzmZwKxT+aQUdaIwnIiNt354zE1qF3joIILwSt4OzBmEwFM9f+yRiAH27zbezrY5J6K3s1LquGQNSE44WQtZuYqjP2gmQIqxE7ogK3vJV5Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777097542; c=relaxed/simple;
	bh=/wWtL0skc+jocbWBnB+4tk9CxINY9JdBlAvMnz1/jXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IuXG1lpGzPYYQBFagxWb1bIqwYG9FnZrCgt5y3pKD/aLS/apNzYUfVrRvf08uqceaODIswMlZjwcf6pfa3y/UzKb80JzbPC7Sw7zpXV+baDZQJD2QH3IdjhLjMBoQqxRxoL703ybbsyIN4ASxH8aIAZSEzjf1BOQYoADdtv+0h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SwnxDyRs; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SwnxDyRs"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488a14c31eeso68146535e9.0
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 23:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777097539; x=1777702339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/Jwf2N1SytLwNqUr8+wWQIFhO6KrcsoB/C3ok2ZTXRU=;
        b=SwnxDyRsnsLM5agWjm8fGgYnk3Zu67y58WgRcnx8/arp5teyDz+X7PB3axXHA//9Hq
         7+CbdeDUdt3Mb2oVEdBLehhIJhpOx4WNcJBIxqu4QeY+sLVx/UvvApyih+/PgdxXTJGr
         F5lvHTs0aIVBLCUYC2LQiKCHAX8lYtO1A9QHTNTgcEOOdjad5xnGMaYDSSwgMhDfvq1Z
         1Mli37SEz3TpSP6IzUQ2tIF3btNnRFLFZD+mu3Ia74lBQi2gijG/M1gjf1ch1NihZHZl
         8B6qHUCPOhKKQuOBX/rOgWZLHtho39+gxucgpLGXmxF5miCFoXGcX2PqmH/j6E0gpsQ3
         sK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777097539; x=1777702339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Jwf2N1SytLwNqUr8+wWQIFhO6KrcsoB/C3ok2ZTXRU=;
        b=ClnPMa+lGf+JX80KtOgRP0ak0EqxHzS/u47eLSGyY78m+jNJp8Wqf/wWVpn6ERiOy4
         iuiplpCLmeH0y/5KnfEl8QxBh/OEQBsFdUFFjb80bmu4KIG+QJ+hOECmUSVfge0vz7Da
         bvtm+Zlqh6adzRjDgNElYpkPOIIOcaxmU3eQp34JRIVAw32VmsFgd/erPdqp3QfkOUO8
         m6lR5w1vEZbr3bLsqIOJj4zXu0/R+IJZRWC7Y6DoqXWUUfSYAmAO1kaLzPGlhSdZApxT
         XImWMtsenPjJ6Kkndu6oHJtF2t6Yy0WvcPJCXDxXpntOCuufCvRFnhvvqf2/MPJSAuni
         Dkig==
X-Gm-Message-State: AOJu0YzaXRDD3cK13RAev6zsomoAZTbgOGl+iRnJZYzZiJh1hWAXh+Jv
	huL7o5NdXW6oy9wLSsx+QcgzwfEtln4+w9Z+MR836+FOzidNtOLs8XPlToxX2ZLR
X-Gm-Gg: AeBDietA157Dr+SnOCWyuQnG288NzpKl7k44okUuVz1Pbwv3jH/UJmDobLYJ0z+ohIL
	a41zlZ5BRlydJefFtWLmKDqvjTTrXd7wfjDfEcqj86BmGBs0yWBxVKsjLOtG9yINUgUr6/l3UYB
	R+pr8eDLnRJ/iZqFdmnKvzRMPGMhpr2xrzyU9O37BLRKU3kMBDSY2/kqFL4MsjXKxhBaou6N7ub
	O+Y9pVLuKpXTwvS5VsSWWVp2+DXDdsad+kUVqLTrZyjGNdrHtvnehhdeEEFW0+gCqAcLIFS8OQb
	jJjfgvp1Zr2h5++O8UMbOVKgPT3s6vRXCOgIr41LKz2DQ9c3r4/Rn3a5cNa/FFSiCQvN5JOB746
	47k+6y7Owk39+vfiRdgtoLs37uO2BSjRTtv9Fy74aBpgbQAPZZJtZ3BrtaBDJFnmDyQOWQYf2Ov
	E6mZcABL7suZp6WI8COzYjl3gza03IIE9R
X-Received: by 2002:a05:600c:4f8c:b0:48a:58ae:993b with SMTP id 5b1f17b1804b1-48a58ae9faemr276643335e9.16.1777097538678;
        Fri, 24 Apr 2026 23:12:18 -0700 (PDT)
Received: from localhost ([145.40.214.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a5aa3ae83sm467290965e9.12.2026.04.24.23.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 23:12:18 -0700 (PDT)
From: Teng Liu <27rabbitlt@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	clm@fb.com,
	linux-kernel@vger.kernel.org,
	Teng Liu <27rabbitlt@gmail.com>,
	syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
Subject: [PATCH] btrfs: replace BUG_ON() with error return in get_new_location()
Date: Sat, 25 Apr 2026 08:10:46 +0200
Message-ID: <20260425061214.235982-1-27rabbitlt@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In get_new_location(), BUG_ON() crashes the kernel if the looked up
file extent item has any of offset, compression, encryption, or other
encoding set. While entries created by the relocation code itself are
not expected to have these fields set, the values come from on-disk
data and a malformed file system can reach this code with non-zero
values, panicking the kernel during a balance operation.

Replace the BUG_ON() with a return of -EUCLEAN, the established error
code in fs/btrfs/relocation.c for filesystem corruption. The caller in
replace_file_extents() already handles errors from get_new_location()
by breaking out of the loop without aborting the transaction so no
caller changes are needed.

Reported-by: syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3e20d8f3d41bac5dc9a2
Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
---
 fs/btrfs/relocation.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1c42c5180bdd..ce751c35945f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -835,10 +835,11 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
 
-	BUG_ON(btrfs_file_extent_offset(leaf, fi) ||
-	       btrfs_file_extent_compression(leaf, fi) ||
-	       btrfs_file_extent_encryption(leaf, fi) ||
-	       btrfs_file_extent_other_encoding(leaf, fi));
+	if (unlikely(btrfs_file_extent_offset(leaf, fi) ||
+		     btrfs_file_extent_compression(leaf, fi) ||
+		     btrfs_file_extent_encryption(leaf, fi) ||
+		     btrfs_file_extent_other_encoding(leaf, fi)))
+		return -EUCLEAN;
 
 	if (num_bytes != btrfs_file_extent_disk_num_bytes(leaf, fi))
 		return -EINVAL;
-- 
2.54.0

