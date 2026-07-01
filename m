Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E293F1EEE6
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 00:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864687; cv=none; b=EmXXCB7e/Yxhv8KPY+GdSLDDtdkEpngqIKygO4AKQcfbys7/4rx9RfW7vEGobZwku71ndWpgE3ky3bD8i0jFBmzbsdNeGsyZbdJrgm8mvJq6Ed865Ez4w7kUD5Yq6XQ2+vVvT5YDEw5/tUW1O9cu3qpG0LLszHALJhnUyw5rrCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864687; c=relaxed/simple;
	bh=9jDUUSF45JpFQnRkUrWsjS/oeR43J06XYXTdT3am7Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMl6zEd87MQ11HqDjAvICFBYRelG9Qj7mS3ubF+p2a8/nmyTLR50BklXHRqUAylZFeiqaL9fPUgpEkDqYpqRjqWjmNXELKZ5ewWP30DKSEElWfD+A2yV049G4xfhGxKXDCKQmvRJaKhdLLMotk0oid1oxA64BF3Ik6t4Z7lMJ6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cNCQQuP3; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cNCQQuP3"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7e9c7174e98so46735a34.2
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 17:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864685; x=1783469485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9IPoaiq299I1HUPiBAuCUjHeHK2h2Bef04kfA8xK7zE=;
        b=cNCQQuP3W3pFkkb3usWtu7yr3/i298KPBttEJBqlfXp4lHEXScOnW7qe3b4KjbyXmZ
         yyVxtHV89YWtgOAm94xhaQhfhLDM1AgLmzB/QAVF1YC/qJTTSbGgAZEfMkkD5AUeCDve
         ldKZxa9frb5FVsc8MKmHp/1hzFl96CGAFbPe9Doun+O6TRpE39OenTQM7ZZDAhP2anvg
         rdGmGXBt4PcqQBWzowxy2+l/aTN19pGU/KcxMMaZxaxFAxFNt+Paqbm/4EEVWsm3EKwP
         ZyGGyx6oSla/0ktMbz00JgAbvVFuby8/JWON2P9PzDniCZbbv+qMpY/2J+N4tKj4LidD
         bDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864685; x=1783469485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9IPoaiq299I1HUPiBAuCUjHeHK2h2Bef04kfA8xK7zE=;
        b=R6aKpwHlsFMFY8YcICTmnypGJzUNH35X/qvyJqR2NPSmYFgABXyNhfZWU2qbIHRYno
         aGHfKuV9aK1m2UiTIn+yhk9xiy4j493YRc0O9QRbBJUM1wRelON4HCHiHTj94uM83eEH
         vFKD7OsaHmcVBTvfQ3ENxZnjJVNosR6gMN2W1uGQ3SX7MCf15OywmH0rYcKZ6F4VdSd+
         +66qj5MArPemzv3ewp7xg4DpwjPUWN/vysFPfLnW33knln4yF6wqUmgd7mwBACdSLviV
         VXldCkZ1RJ2E7CiCKdcYMh5mumYyPiYy481zvgUpGVXu0AOJJ96jBgZOqlHp2aDcHKVi
         uVsA==
X-Forwarded-Encrypted: i=1; AFNElJ/RTYxY/NQeF335E/qBpqXXA97OQXvWKixmjl171Lsoj0Q7n3WFJre4nLGzh9fEAfQ3RVwYmwijGD5PuA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/tSdOLtlQGCoRM6jftxMNqWAY8YqqJDz8TKGveFN5g0eIOew1
	8uuVcqa/qMRE0d/zPLjzh41nJcmf2HOaCGad9a7RLLCHjzOfNqFv13DLbb2Stg==
X-Gm-Gg: AfdE7cnLsnosrqQhk3ryi+YZd34gE5V80MN3GzMk5NR4rMk20jsXggxUgc+tvAYlP34
	gdgJQccHx2/vVuMMMw8Z28uPkkiSZpvoL4UoG+k/S3FdPToDRc7IB5qSGw2qyID9kL9lDggyige
	RsjrCBO5D8ziqi5dyFbJBoO9/UaCw3aHy1/WK2nPrdnOsID9cZg2Rqk2Z02sNehUOSIacNmS4zE
	JOspREgM8n39vPggnp8Jv8yAbHShA90gyPSw5naZNqUnMU+xfQGgWON+4/utw944yujg3+3WAj0
	xKzcq94q8xVKGOFFAm0jIy7F+XtHiAYTIfuxNqRRqVWh8ufySUWVsFSAmehKKpsb8CmIpWnbKk6
	BlGqV8Yad2O1WDu6p5Vh6H1C5SdxvR6Jd6XuYr3zIxyb5lscDpnIsiG+YWcpeXHx+1kNlJV4YI/
	51aG+9Z0m+dN6scmGBrU/wbfiVNe/uKm7B00XBCMk3F1ObU24Q3v6/iAT0Td2gWyY=
X-Received: by 2002:a05:6808:1924:b0:48c:b2d1:8c97 with SMTP id 5614622812f47-495fd7c3489mr1618454b6e.40.1782864684945;
        Tue, 30 Jun 2026 17:11:24 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-49606b5d273sm255437b6e.17.2026.06.30.17.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:11:23 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 03/18] btrfs: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:18 -0700
Message-ID: <20260701000949.1666714-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260701000949.1666714-1-joannelkoong@gmail.com>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert btrfs iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/btrfs/direct-io.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 460326d34143..46dd72982fba 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -798,9 +798,15 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 	btrfs_submit_bbio(bbio, 0);
 }
 
+static int btrfs_dio_iomap_next(const struct iomap_iter *iter,
+				struct iomap *iomap, struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, btrfs_dio_iomap_begin,
+			     btrfs_dio_iomap_end);
+}
+
 static const struct iomap_ops btrfs_dio_iomap_ops = {
-	.iomap_begin            = btrfs_dio_iomap_begin,
-	.iomap_end              = btrfs_dio_iomap_end,
+	.iomap_next             = btrfs_dio_iomap_next,
 };
 
 static const struct iomap_dio_ops btrfs_dio_ops = {
-- 
2.52.0

