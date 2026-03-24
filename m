Received: from mail-yx1-f68.google.com (mail-yx1-f68.google.com [74.125.224.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF333B6346
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 19:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774379400; cv=none; b=g0VWQQqYZ3IUmVD61xQJEnKMNv/WGNBerAtcwLkl1IOrWdQ84LLjnkY/nDztB1ugwSwYaGSE941QB8G3nmuBnd2VGhIF1htRIQ8PFtpalB+M0R4f5By5AMF1h+XbPyKDSg/eyTgVdJDdCU1PJO5Jm3BrNOBKRAwmK8BYvT1v+sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774379400; c=relaxed/simple;
	bh=hiKo4P2ioUwDqXVsJrK6fVhCAj0j1Tr0U0GoV9gFqB4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wqp23YPJ+Qzxndx+slmrNAutCMZNl9qjO3r5Lv6DIT2992YHJMXtBigJjqAhd47jL1c9201fx/SDEPZMMcl7DNabvj8zY0lb3rXv7Lw+Y6T/+OlM32a2LdH+QGg3afShAMIWHj9DRiwAn0stGpTPcWmykzA/bDL8+15Y8vG8dbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sBhsesRh; arc=none smtp.client-ip=74.125.224.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sBhsesRh"
Received: by mail-yx1-f68.google.com with SMTP id 956f58d0204a3-64ad46a44easo5446688d50.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 12:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774379396; x=1774984196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JwC92OC9Eg/R+FN4RRdXyFHlBa0jRNcNvQJ2ENSTAJI=;
        b=sBhsesRhit6twro9ugChhl0zn3SRK7YKbRoYhdvwJ5uJTy41tyaIqFWOQyTapn5VHQ
         G4p7LFp6Aegl/DNzOE+sWCCOlajOUCCa3sAJ18XUz+yXsze9Ao5uLkwAU8Sypp/YYY4F
         5hw+6BxVGxTGTqj2chFDtMD9eMLGZVB7yyPg3/ocX+5a4dCAMri7lDzHjqgWdIlAoPom
         V4+Z/w8SMd+fAhREek0HKJLjP0RPQCLxKHReDm1anpv1dFuj4iv71Hj4C3rbd82McHMn
         /1PfVUjm5bBeYyXCyaoxOw3LXVkrlAT5ShFaQocepBKHn0LMrk3UXfPwpvR3RsSilLFY
         WSRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774379396; x=1774984196;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JwC92OC9Eg/R+FN4RRdXyFHlBa0jRNcNvQJ2ENSTAJI=;
        b=oFqG2rDMyKauZIoJ9gBZXbhu3l1r9D64QTkujFfXUQOOJkZJic3NxoVmjD5hTIeu/d
         nCE1sc8/KMTj64EdOJibDGrW6ZaTMEb6aga+sEl5AaM+eCkDxhbYL8SCMxn4hwxJqqcA
         uyHBaE/FB87ogNRlt1w6gKkAddCd7A1lzzRHm5t0qbxQTInXjjVnYmvUxBEELcI64O/n
         jHlt7MMeTSBcaCbyGSlYYgWGPfrZRn6vbJA2ys571Xld1HjoRVAaqdM7kojhenZmmcDE
         pzk1UQQmDTlQ5JBdg6J++VJe9GG+aOV2PldltHWmJ6tnaImwhDzwQaSHXcimEWDueyaf
         If5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXj1R/o0WqAh8zKy5gcQ2hrZS+GYYnv6u7Prj+TfzS7uB6hWuTfzCJtmzAZlf1BQFrU4CJdEaLZQbLdBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzupoXV32/jzcOCGCBEEA8h5vpEKLqvBPxj8RHVriOhxXS2k+bB
	g4YsvoLXD41EhWCSrUC1uBO2TFkOsJWpuOT24r+zZlquE+/p/vo6EzeL
X-Gm-Gg: ATEYQzxD1R1ombZA9EcfAmTSl+zCVmEMiOUTz/q8xQX4MsZEVeNoUytG4jipsJuGfBp
	ZZB8OXkFgYIJ4kjJkoJCKkOeLSQafdqs9TJ0SpfwCyq0UeoIfep+LxjSFzE2vDkCKPlgEDTNqWQ
	rqWhx2VjMH6uA3B9pAWJlqwPC59n277qdZqH+qIdAZBfBySfVkmnR9LNv8P/qyY5vhAYT/05Tz1
	2tETG9hF0+g/oKFWrujAm8M1FP6kkRI6yP3OSHXIScSYogVvDuPMBwl4R8IBkSlxLoWoMnAifoB
	R+PkyFn+rOfcAcXYT5hwDINqNZwgBXf/NQw7/iSZ36v/0esYd5MOE+35YqrylYjFKp1JyaF5F7S
	Mufom+smsmW/AhskNeNiqBskrtaj1NruWk5qTaBIQ36ALMS7x37+c6icVSVJI/u0tWzcntV9yAA
	h04PTPBLvcWP8LUi9Nyg==
X-Received: by 2002:a05:690e:1289:b0:644:45a9:c0d7 with SMTP id 956f58d0204a3-64ee613eea4mr664994d50.55.1774379395765;
        Tue, 24 Mar 2026 12:09:55 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:55::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64eabecdbd3sm8159672d50.18.2026.03.24.12.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 12:09:55 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH] btrfs: fix stale errno check in btrfs_encoded_read/write helpers
Date: Tue, 24 Mar 2026 12:09:52 -0700
Message-ID: <39eac6cef5afd99734483fa0e775a3e75407552b.1774303837.git.loemra.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The atoll() error check `if (offset == 0 && errno != 0)` can falsely
trigger because errno is not cleared before the call. Library
initialization code (e.g. libcap calling prctl(PR_CAPBSET_READ) which
fails with EINVAL) can leave errno set to a non-zero value. When the
caller passes offset=0 (a valid value), atoll() returns 0 without
modifying errno, and the stale errno causes the helper to print usage
and exit.

This caused btrfs/333 to fail consistently on systems where libcap is
linked, since every call with offset 0 would bail out.

Fix by clearing errno before the atoll() calls in both
btrfs_encoded_read and btrfs_encoded_write helpers.

Signed-off-by: Leo Martins <loemra.dev@gmail.com>
---
 src/btrfs_encoded_read.c  | 1 +
 src/btrfs_encoded_write.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/src/btrfs_encoded_read.c b/src/btrfs_encoded_read.c
index 3ee0d8b0..c7c25b74 100644
--- a/src/btrfs_encoded_read.c
+++ b/src/btrfs_encoded_read.c
@@ -178,6 +178,7 @@ int main(int argc, char *argv[])
 
 	filename = argv[2];
 
+	errno = 0;
 	offset = atoll(argv[3]);
 	if (offset == 0 && errno != 0) {
 		usage();
diff --git a/src/btrfs_encoded_write.c b/src/btrfs_encoded_write.c
index 7e46d9fe..bc05cc3b 100644
--- a/src/btrfs_encoded_write.c
+++ b/src/btrfs_encoded_write.c
@@ -179,6 +179,7 @@ int main(int argc, char *argv[])
 
 	filename = argv[2];
 
+	errno = 0;
 	offset = atoll(argv[3]);
 	if (offset == 0 && errno != 0) {
 		usage();
-- 
2.52.0

