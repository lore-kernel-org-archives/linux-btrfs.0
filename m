Received: from mail-dl2-f43.google.com (mail-dl2-f43.google.com [74.125.229.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1478B491583
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 19:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790107130; cv=none; b=ixUBT5VH1/vgwGl/iyz2PY+pI1a1ZNgCWvVXyOTZMIi5Ww3UqmxN1YikSuceholbRYMSMQCP2GF6IlY/yG1uyHuupJJXOBWFLrksUPV/7D3bu6rVh2ADXwF6j1UFC8CL2BYpDa3eS1s+JdumVaon92JcDM1BqT3DRm7XPlluSiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790107130; c=relaxed/simple;
	bh=WKOh/3rPUbo6AQsl6PxuNwCtS+HOGnoHYPfAzkfTmTU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rELYLGoc1ww5qIMtr7nN+Ru0XGutHmYTGjEb+nJ7jzKa8DBY4jmeV0CehATQip/LKZqgQFIW8GiX1ygVZ8UuUCw1t7hbN0QUA9LWPn1llxcb6Sg9cENbsK0QMbatc1I1307Inpj3oszyPbeg8TfZs0fNLHjOyXHvyU0gtx8YsJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=OPDp8dZC; arc=none smtp.client-ip=74.125.229.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="OPDp8dZC"
Received: by mail-dl2-f43.google.com with SMTP id a92af1059eb24-14373bcc010so265382c88.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 12:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1790107121; x=1790711921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BjX+mNuhQOmLJprMYKkZ8OPoLSpzkGrxDeWbqW/+m4I=;
        b=OPDp8dZC9ud72KyV3bUT7MLbrU2d8SjsIphqH7MnBzipGVTwlWGpBzHB4iwE6YHaXX
         na41k5QWFYXEGdHew5dek377TzotMn/0Haf7X7ztn+sTsZwfEXM87hao2bwQzhkJy1eH
         XcfglYVNz/jHmPO4rIrM7o5/nmsIhmqQvbqetHlxRfdLR3Jxg5/+xNuy8F0H+z9X9TJl
         3hDWS9zsCwfUz3bo9TSfsE6NsyxXKjGv7z7AtTwDwPq/NO4B1QAVjOOx8WfExJAvzeAf
         3W4+90DTKoI2fR/oZg5rPo0OWBX1jANqf6gOKTUQRalfjzJs6mNURZjaW+VcgfN1TKc7
         LTng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790107121; x=1790711921;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BjX+mNuhQOmLJprMYKkZ8OPoLSpzkGrxDeWbqW/+m4I=;
        b=vcdxJjeTtUq2rGfXDEiPhcUBurL83h1t0Wqak95O1EKT9O8aIyEtQersQx4cX9ici0
         Vd89DAlJ5Y04meX9D1ZrfwLy3LCshYbEIA2sPKYwKlAordPa8bBzffvZWbA/rwe6jiZl
         oG1YJ28FbyZUm0f0GujAYw7gDewomuAzIkCyZMFnEa62NsBwu1RtEsDiC6G2LwostT0n
         ASDDEYkJDvG3LC/pZ/4kP2wjYB5MfwNxJlWXjF4xGXxG0h2zC6QaLPSoAfK65X2+huvk
         JBEkRdhGEozfM5H9Hf67jrwoU2Y7g//1Tg3djJa+aObsNrLJZmPnzGMrhHT7rEfdvCID
         LBeA==
X-Forwarded-Encrypted: i=1; AKwUvBzyT8xBTCVn+UwiNbHFB5Vjr1qeaD0ykeQH1x/e+AHimWftNjYT4vCIlZ3ORLp1/9iULkcq6VeHdtGgtw==@vger.kernel.org
X-Gm-Message-State: AFuF++mK4zCznqA7CWaWp6DOCnuStxGJDhp1i22voP3bnd0zWwWYKebf
	sI14zikI9+4t+WahNN+HngZQSus6bhupwtaeiq8hYu0cYHF9omPS7OSQjn9TuNfks/c=
X-Gm-Gg: AYBFou2rxwYVi9jYOYSp9aDrnGozso0irwDUG5N3ykrXjGBz6EdOThMXHPL1XFUa7yb
	d4cg605WLDFUUx1Q+X4EmOzXiYiFmxwWmup35z9lki1y2Y+hn2Ni23bDSF2DVTBSn/uBiyofnzo
	EM1S1pzwYVmWNDTF1X2/u/glTTCIERRLNoHlq61lUat7q+jPOp2P6DjILQd90t1YRIKpkMD0PLo
	z9h9zOWrLoNpseb2lOelVUC5+Yg5NCeMvLbT3931qy906Lsb/u36WwTdLpCj/GMqDct29j+0UrM
	fV4QNIPO2Pq3St5bjWY4Bcja9CrGlWFMC8u+wuQ8UPW8Iu42DhX17o6kxs91c5CQF7xTBJxaaON
	LfmpnTfZTP6PYc2SdVQy51pr9V/Haa/aOdWTjAMXrwSuzxKQPtJcWOUiSlBMlBCOMQMJvTdlS9U
	yr3urS93zfHJcPneMzfclN7zh/38QQPaRTuwMsEHF3sbae+74NuTc9tcqNK1FIPmijFLuZBgQbi
	iUJyTph95PS2uHE0ttw8RhL9ebbGmmZNWDt3c2THINHZUycCS27gWB5u98+hSTsaRpWzFA=
X-Received: by 2002:a05:701b:4591:20b0:144:fa79:174 with SMTP id a92af1059eb24-144fa79031emr52410c88.44.1790107120989;
        Tue, 22 Sep 2026 12:58:40 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:c016:77a6:d382:7611])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e975223fcsm459820eec.31.2026.09.22.12.58.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 22 Sep 2026 12:58:40 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.1.y] btrfs: don't check PageError in __extent_writepage
Date: Tue, 22 Sep 2026 15:58:35 -0400
Message-ID: <20260922195836.27193-1-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3e92499e3b004baffb479d61e191b41b604ece9a ]

__extent_writepage currenly sets PageError whenever any error happens,
and the also checks for PageError to decide if to call error handling.
This leads to very unclear responsibility for cleaning up on errors.
In the VM and generic writeback helpers the basic idea is that once
I/O is fired off all error handling responsibility is delegated to the
end I/O handler.  But if that end I/O handler sets the PageError bit,
and the submitter checks it, the bit could in some cases leak into the
submission context for fast enough I/O.

Fix this by simply not checking PageError and just using the local
ret variable to check for submission errors.  This also fundamentally
solves the long problem documented in a comment in __extent_writepage
by never leaking the error bit into the submission context.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

[ Backport to 6.1.y: apply the PageError-to-ret change in this tree's
  pre-btrfs_bio_ctrl __extent_writepage(). ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
Hi Greg, Sasha, and Btrfs maintainers,

I am continuing with CVE backports still missing from 6.1.y.
This fix is inherited by v6.6 and every later mainline release, but 6.1.y
still has the affected code. The target-specific adjustment is described
in the bracketed note above.

Could you please queue it for 6.1.y?

Thanks,
Artem Dinaburg

CVE: CVE-2023-53429

Build: This patch was included in an x86_64 allmodconfig and
CONFIG_WERROR=y build.
It produced vmlinux and modules with no new warnings or errors.

AI assistance: An LLM helped find, adapt, and validate this
backport; I reviewed the patch and test output.

 fs/btrfs/extent_io.c | 33 +--------------------------------
 1 file changed, 1 insertion(+), 32 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 28dbac0bfab2f9..aeea8930b973fd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2299,38 +2299,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		set_page_writeback(page);
 		end_page_writeback(page);
 	}
-	/*
-	 * Here we used to have a check for PageError() and then set @ret and
-	 * call end_extent_writepage().
-	 *
-	 * But in fact setting @ret here will cause different error paths
-	 * between subpage and regular sectorsize.
-	 *
-	 * For regular page size, we never submit current page, but only add
-	 * current page to current bio.
-	 * The bio submission can only happen in next page.
-	 * Thus if we hit the PageError() branch, @ret is already set to
-	 * non-zero value and will not get updated for regular sectorsize.
-	 *
-	 * But for subpage case, it's possible we submit part of current page,
-	 * thus can get PageError() set by submitted bio of the same page,
-	 * while our @ret is still 0.
-	 *
-	 * So here we unify the behavior and don't set @ret.
-	 * Error can still be properly passed to higher layer as page will
-	 * be set error, here we just don't handle the IO failure.
-	 *
-	 * NOTE: This is just a hotfix for subpage.
-	 * The root fix will be properly ending ordered extent when we hit
-	 * an error during writeback.
-	 *
-	 * But that needs a bigger refactoring, as we not only need to grab the
-	 * submitted OE, but also need to know exactly at which bytenr we hit
-	 * the error.
-	 * Currently the full page based __extent_writepage_io() is not
-	 * capable of that.
-	 */
-	if (PageError(page))
+	if (ret)
 		end_extent_writepage(page, ret, page_start, page_end);
 	if (epd->extent_locked) {
 		/*
-- 
2.39.5

