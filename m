Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2DA3CCFCE
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 15:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773327979; cv=none; b=f0iqQe7G5TE942K6rBtoPQJrWV5qsJLwjNWqQHSEoKhLf5R+78wDLrggCA5lezKeON15Uizb6OyD8itQRgcq3vRbcyDJn7lq2kVBNu8n6JHy73pG9uMld7QTvNpO6CNwrp/+w4cqDmv6oNhKqolVt+dOUK1oMsfEAz2s0DEaV9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773327979; c=relaxed/simple;
	bh=GV/uBOcBqntPAApAc0QTyoHwJkme8YR9+aADyAzFTy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t86gSHvtQJL/ryuQHcWhXCr+YSqHalPed0Kun8ryUP7K0EgFs78DbbdQIVOSyAPtQ5NcLeQ+BtBKyWc0biMqw3YLHU/ULh88sNTzgZ+GmALRmtA7I/MML+H5YmnCiCIg1PTMl0+m6Hl5tEuOjLu0W9ZEayUV7nLYb4UEuwYjKPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=AeEDQTCg; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="AeEDQTCg"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-466f59dbe4bso301378b6e.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 08:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1773327977; x=1773932777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Zkmp0oJNKpSbul8J/Gx58ohXxqsVTLVowypwRZJ2Ic=;
        b=AeEDQTCg4aLcYlKo4ASJ8EjfwE+MFEs877o9gs1JqRIK/JJYDOkK4Af4QvmkyYn097
         Rvvg350bwAQz+VEhkBBBJ3FlNdvs042mshOsNkHJyYhxjM1kpe7LxB3rIkuNOVqa994J
         sDTjqRUzuaOPgBCY8zgVRr/lz8rgjE+VlZqX5OQLxb6A/5OJMmueBTgsCmMokgXxfusZ
         ItbIU1O56oFsE6lmOhXmBkE4+4ILa+KGeQOCFh/5juMS/VLU8mbrpIwiPcg3uvoU1dWH
         dCA5bGceQC5nkDw+q66ucJh6Sya18kXjKhSoH+vnZ3zbBJPlsLboI+Jr1YjujYhwk8OY
         zp/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773327977; x=1773932777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6Zkmp0oJNKpSbul8J/Gx58ohXxqsVTLVowypwRZJ2Ic=;
        b=K4hxtPpqzJ+CRVeXrDeOUYa8TTf/nvm3tVD2Z5ABntUjMRN2OEztyivFKklCAmE2Jw
         B628k8HgYhSjqAAp0KiwJdozUo0FOCk9Ufw0Vl6zFZ9eLU062JvEcLlR/EvcGpuEMDr3
         EiFs852RhOp046Nzkspt1kPCOEeV5Hr1UtC5lEdVkInyqlxKmEG7HdVd/dpPgdang1o4
         lD6cwXO7OLtOnMqmVbKP1xRgTZGYF4mwSKO98kg4I8oVOQfyXOVFl8jgcx3wDdLC7GVg
         gc+h5X4nwBkIAqkQTNs40qdKqsWm7AqiGo+Ve39N1qSfTi/HN3BNgNwymMfT8vxdrI5m
         k38A==
X-Forwarded-Encrypted: i=1; AJvYcCXay19IInYctU9s+z7J86aLUcXcGnlygeWDA+cDIsgDdoOg6aATrcZMVJo/UE/k0UXlMr+n4YPCNbi6Ag==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8Jk982M0vnuD+DMftUezbxeL17LTGFGni9su2BPM9qERvB31J
	HMeM6nvP5lCUmi8I0J9S6XlfcPdvGDiRZh/Y2krdIwUQFNxSe6ucGHycC0gJ6LBrdj8=
X-Gm-Gg: ATEYQzxtEqrRiR0lgcjfpnQKR/y7SsSRz9NgIrIum6PeXs39nF6DaTV8dxJ3FrYcjii
	GaBrv1HwjUWqR4XTmfh5QMKo6rhq2wqx4rQO7SmD2hSXBqeft1LSsNLTHWqHAAFHM31PLEJO5Ny
	rVdnLMSsbRwRx2u27GbwHTi+A5AS9sbtpJ2PXWvazlY3aULKyW6eJb8TeQkkxWwlR3SwM8OzgPG
	tZR63+WuRj82QC0NJG7A4YSbIKS1eM5GRVgM+YHdxcMgDt7oW8qf6iDOxhG03c4kp1TBiCgmDWz
	3TavKmP8Hqwxw5cRxWKKAuYofRVKb5AnK3Riv/siZimpsHtVTonpTGCKA2KrgTUR8sqfFjWZCkd
	fZNzdOPYE+xNe+29/CUX2pbG0+jeZbk5KzMHwGNS8Vz9Qg5ghQZl8/iObkConkNm/PM44WMUzF6
	uMyv92MD8xYnPDyL0Ct+ijhZRY2rVw/4oZPPPqd0E+AvxrSR8ZVeg6UsTaeUDVI7dhcjsL3TTWo
	DMd
X-Received: by 2002:a05:6808:2225:b0:467:1e5:6764 with SMTP id 5614622812f47-467335bf7f2mr3426441b6e.54.1773327976888;
        Thu, 12 Mar 2026 08:06:16 -0700 (PDT)
Received: from vinmini.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76aedae57sm4321776a34.28.2026.03.12.08.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 08:06:16 -0700 (PDT)
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
Subject: [PATCH 15/15] btrfs: Use trace_invoke_##name() at guarded tracepoint call sites
Date: Thu, 12 Mar 2026 11:05:10 -0400
Message-ID: <20260312150523.2054552-16-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312150523.2054552-1-vineeth@bitbyteword.org>
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace trace_foo() with the new trace_invoke_foo() at sites already
guarded by trace_foo_enabled(), avoiding a redundant
static_branch_unlikely() re-evaluation inside the tracepoint.
trace_invoke_foo() calls the tracepoint callbacks directly without
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
index 095a561d733f0..fadb676fc4e90 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -1318,7 +1318,7 @@ static void btrfs_extent_map_shrinker_worker(struct work_struct *work)
 	if (trace_btrfs_extent_map_shrinker_scan_enter_enabled()) {
 		s64 nr = percpu_counter_sum_positive(&fs_info->evictable_extent_maps);
 
-		trace_btrfs_extent_map_shrinker_scan_enter(fs_info, nr);
+		trace_invoke_btrfs_extent_map_shrinker_scan_enter(fs_info, nr);
 	}
 
 	while (ctx.scanned < ctx.nr_to_scan && !btrfs_fs_closing(fs_info)) {
@@ -1358,7 +1358,7 @@ static void btrfs_extent_map_shrinker_worker(struct work_struct *work)
 	if (trace_btrfs_extent_map_shrinker_scan_exit_enabled()) {
 		s64 nr = percpu_counter_sum_positive(&fs_info->evictable_extent_maps);
 
-		trace_btrfs_extent_map_shrinker_scan_exit(fs_info, nr_dropped, nr);
+		trace_invoke_btrfs_extent_map_shrinker_scan_exit(fs_info, nr_dropped, nr);
 	}
 
 	atomic64_set(&fs_info->em_shrinker_nr_to_scan, 0);
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index b4511f560e929..c6de0c5bd6ef6 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1743,7 +1743,7 @@ static void submit_read_wait_bio_list(struct btrfs_raid_bio *rbio,
 			struct raid56_bio_trace_info trace_info = { 0 };
 
 			bio_get_trace_info(rbio, bio, &trace_info);
-			trace_raid56_read(rbio, bio, &trace_info);
+			trace_invoke_raid56_read(rbio, bio, &trace_info);
 		}
 		submit_bio(bio);
 	}
@@ -2420,7 +2420,7 @@ static void submit_write_bios(struct btrfs_raid_bio *rbio,
 			struct raid56_bio_trace_info trace_info = { 0 };
 
 			bio_get_trace_info(rbio, bio, &trace_info);
-			trace_raid56_write(rbio, bio, &trace_info);
+			trace_invoke_raid56_write(rbio, bio, &trace_info);
 		}
 		submit_bio(bio);
 	}
-- 
2.53.0

