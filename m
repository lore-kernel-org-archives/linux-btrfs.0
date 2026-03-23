Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACD43B9611
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 16:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774281699; cv=none; b=FpejMbk88Rh8hug5wQnWLQw0TipUatcD00nnHNkfhms7Ys3cEUiypzgrAl7jIQC82H7nn9LO4F4Iw6RTN53GyTIYQqfM+ef72gPtsFs9eKLOk3/r698/VkA2Pby3azfLa9Z7nEh9tA4/eylzSW6GJEMojLY7HQTzeQ8E37WbI2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774281699; c=relaxed/simple;
	bh=MZnmVAxJf+X6cHJOBPvDd6V2H0nUoF4Hno5Kv0ax+0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrzVWeZkKFpmVT1tSmXd/eCc3Ec8r4yTPNSXosKKkoJNZa2vpOm1iTV45lPcpawzusNL58UbH44bti0c1CCq23Wkmm7r2GI2Sl4KtWCbDq5cS5bx/BPR96T3GQ0RFvH6eCdyHVX7mAHNs7ieb7e1+5xFD+FaF8YGOHXFU9Lg6FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=pObiQh1M; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="pObiQh1M"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-67df618d095so1977eaf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 09:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1774281696; x=1774886496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3hqD+qM2Gta/bzpbgYsOccfWP/3yL/YGd5soFmEVY9Q=;
        b=pObiQh1M3Uzo476arwskTOTfu5mJRY56RVmXEgcOiYczx3bT9M+dzcWDX9KL6jw8M0
         xRVDVuQiCyzR44SPeMc8FFmjpR4YmaM6TqtOwPhBzHn2mL7+nSRbGw66qF3PtJ2KHJIN
         a1oPZqCgFkqoZvMHQ7KkHftpbrnB0sgX1rAivw3LXstdsrlTzB1r3IzUj0lCyXqtgB6v
         GiXbW47ihgEKqUK2XjPRoaGfwhdNWaaGUjWJcwHemf1PMQT8R+94g5oockhCCuQwit5N
         HBP4bkh/wFW0KlysQ+I5PwKWW3/s7gMAo4rqIBPtLXBCgw/7gV4voYrOPK3KtG/G4EBA
         2vyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774281696; x=1774886496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3hqD+qM2Gta/bzpbgYsOccfWP/3yL/YGd5soFmEVY9Q=;
        b=hthF1tvqSI+pfLwnLY9IQovFTZw5tDR98X7moDe6/29DD2ICglzwilurGNt5p9seRM
         azrLfTMt/QkWDrsGipmXvnOBvzyJtp/sGlt/y4bosW1SCI+dXE1Rn/LcI0l6GB57HmSX
         OZ+uMXQ+ZNgpmM8D6xkIyAHIBDTlLDssJkOV4YyN+JsnieeAJCm7aTsopuiwcKaS+JcL
         7OaFNlCscLfJTzSWxeiMRSe9KtWUXYW+Yhbizgkneat1pAoPvOtTq3h8Ax7gSP/WHNG+
         4ahBwDEKH+OLCnGEYI/g1JIFp32E3y8TbIPp3GboeHnbMXw/tILLOdacrDnH/ZxN8jGp
         C6uQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3fReeEFlS3k0jPve+ZE32qrs8zdvKPd3wAkmojZR90OFJTuj134Xf35CjxWBPqlR4X+tAK8v2wMZkTw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxE5riz6zqxnBsUxArHVq+4Xv5wr9HKfFPnMzdmFsWYaBali0Ah
	zVp6bIJo5MVBBQVXHidBn1X2ROl6R6Gc6DDOkEhfor/XnIXKr1W8L9Aaq4sRgrKJSko=
X-Gm-Gg: ATEYQzyx9UrTpBoka2lHSxA6aGUptHoPKGInil8eWVHvHJNbusrY+HysoQyxzvCqNOy
	x8uQkIfOxE5XixOiVMstgULrOU8xg0Gwcf96aYSgdzk+TFwALKT4mPZzfJ0BvxJpi1RNqsyCGh0
	JAC+pPLakv4sQF3BAStQUpenWLEeOHtX/Hjkz532GJRXAHAFPErI7N3IyRsJLnswfHqifNhz6F9
	9hv4dlJGUg9mY4dtK/2lupTwCw7lxQG+g1I6gpFYX5mg+aUTgPvZq5QZPJtVtVP7HjgYSjObvDd
	GzYBwVQqCnJbarKrtG+DH1WeqhPmO5R/Rp0bhA50+CoMgrgDAcimFhlOCIU9bVROkWSyBiYG3hl
	VvolfflodccsUVIZLTM09eBt7G9gm/GUGvxCwvGCKAwaTmmSN7quuq22IZ/2bWyBl5DL1aSbhmn
	jQxSvYUV4WIhfPW5n+o2SXfrv3ByuOSbd62YB7s7xaKsj9NwkS9Yon7R63a1yQGpqSYw==
X-Received: by 2002:a05:6820:2085:b0:67b:ab68:b5ed with SMTP id 006d021491bc7-67c22f2703bmr9958074eaf.21.1774281694519;
        Mon, 23 Mar 2026 09:01:34 -0700 (PDT)
Received: from vinmini.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc9088df1sm843364185a.25.2026.03.23.09.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 09:01:34 -0700 (PDT)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: 
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v2 15/19] btrfs: Use trace_call__##name() at guarded tracepoint call sites
Date: Mon, 23 Mar 2026 12:00:34 -0400
Message-ID: <20260323160052.17528-16-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323160052.17528-1-vineeth@bitbyteword.org>
References: <20260323160052.17528-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace trace_foo() with the new trace_call__foo() at sites already
guarded by trace_foo_enabled(), avoiding a redundant
static_branch_unlikely() re-evaluation inside the tracepoint.
trace_call__foo() calls the tracepoint callbacks directly without
utilizing the static branch again.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Assisted-by: Claude:claude-sonnet-4-6
---
 fs/btrfs/extent_map.c | 4 ++--
 fs/btrfs/raid56.c     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 095a561d733f0..9284c0a81befb 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -1318,7 +1318,7 @@ static void btrfs_extent_map_shrinker_worker(struct work_struct *work)
 	if (trace_btrfs_extent_map_shrinker_scan_enter_enabled()) {
 		s64 nr = percpu_counter_sum_positive(&fs_info->evictable_extent_maps);
 
-		trace_btrfs_extent_map_shrinker_scan_enter(fs_info, nr);
+		trace_call__btrfs_extent_map_shrinker_scan_enter(fs_info, nr);
 	}
 
 	while (ctx.scanned < ctx.nr_to_scan && !btrfs_fs_closing(fs_info)) {
@@ -1358,7 +1358,7 @@ static void btrfs_extent_map_shrinker_worker(struct work_struct *work)
 	if (trace_btrfs_extent_map_shrinker_scan_exit_enabled()) {
 		s64 nr = percpu_counter_sum_positive(&fs_info->evictable_extent_maps);
 
-		trace_btrfs_extent_map_shrinker_scan_exit(fs_info, nr_dropped, nr);
+		trace_call__btrfs_extent_map_shrinker_scan_exit(fs_info, nr_dropped, nr);
 	}
 
 	atomic64_set(&fs_info->em_shrinker_nr_to_scan, 0);
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index b4511f560e929..0b5b2432aedf6 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1743,7 +1743,7 @@ static void submit_read_wait_bio_list(struct btrfs_raid_bio *rbio,
 			struct raid56_bio_trace_info trace_info = { 0 };
 
 			bio_get_trace_info(rbio, bio, &trace_info);
-			trace_raid56_read(rbio, bio, &trace_info);
+			trace_call__raid56_read(rbio, bio, &trace_info);
 		}
 		submit_bio(bio);
 	}
@@ -2420,7 +2420,7 @@ static void submit_write_bios(struct btrfs_raid_bio *rbio,
 			struct raid56_bio_trace_info trace_info = { 0 };
 
 			bio_get_trace_info(rbio, bio, &trace_info);
-			trace_raid56_write(rbio, bio, &trace_info);
+			trace_call__raid56_write(rbio, bio, &trace_info);
 		}
 		submit_bio(bio);
 	}
-- 
2.53.0

