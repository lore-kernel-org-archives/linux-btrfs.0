Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793371120;
	b=lVgXuLAaWfv/tfguFs8iCkfzPyNUNeNwJCndgYvyDHHMq67oqDR2k6nokYnAi9UYzVX5
	 rQdqSmgHD7XTwsxsZSyJjWiycgSh8C+nGOEvzHUW7mdxYFjGudv6nTYMJCJGZGEK5yTjh
	 nFk0gsfqotxyhVp6dXCVXcSsLt5fjfh7JvZjOEJEbiDvcNBCDiatTRa9uuOCBlei7oVCz
	 j5De6GVzFBsd5XQJ+87cDhmsOrfLgtzTTQHD5pzCYeMsFbbdN61yJ3WDM98+JO22Cbl4q
	 +4myH0owEYBF0oMcjzFmDsPh16RRRJOd3/vDxAKRISQn1QBMBniMxeiWop5w2NoUpSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793371120;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=WjjyRi4tupTzbJkDr3stKVd4gLMEfuLz9mMt/2TKXi4=;
	b=l7BfbT8x8Y9ZoGdQORHfeG+TGRbR4RlFuAtoqGqAM0IwZGqsIZxGdLFTk3vgtkZ+DMW7
	 vJE/JzAgpYn73cvlRaXYBlC26YznJEo26l16RozbCqeb5XbP7uCHeLeHBto7bTWw/4qdm
	 Ss3BpkR58fZx4s2hABw2dSNdXSxrCp1EpJRr+gSxnCam5iSfoJA12WsPKjJNTkvtUynnD
	 dS8o2LzatbU6pVI0g6LTcAR2w8/ORmcwIZxWOeOQVr9Qq/s1Op51gv9KJNuoR/p7wOaRT
	 QW0Rf1H9WzY+e1L3adKwtk30NQfBQbrb5qLpy6UAYdNHY6GG6WSP91y6sx94qwF7gjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b="Gvfih/jy";
	arc=none smtp.remote-ip=209.85.160.173
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2A860A2602
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 14:38:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB2A860A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=Gvfih/jy
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-53669f7b518so8157991cf.2
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 07:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793371119; x=1793975919; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WjjyRi4tupTzbJkDr3stKVd4gLMEfuLz9mMt/2TKXi4=;
        b=Gvfih/jydP+S2kc56d5DUagGJ/G3CgkYcA1FiGPEc4iFncpHFPwxKejcrsnta7v+km
         eDihh5ttKHPs9ptBfcHkU7qInB263Vuj8HBcqobcBtDctbNE3ESAaDG/neroqr7614Fu
         FGuz1KYMtJj2YpF40XieO4LT9SfEyYV+fhkSijCC/HoWZJk/cI7m4cFnnkF6u/g6jXyw
         p0MCgX9b6IOGkwFdgAGMQ/LXRmyqDLLztJmchiXOZJJvP9rxt9h+I3NDF4WeTiUQNu3s
         OhSKGoaHnKyfP8WEzyYDMdpZ0faVI/jfmJrOwmNE19iZQcTyHHwvxu8uUbfH/mAUBiQ4
         V3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793371119; x=1793975919;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WjjyRi4tupTzbJkDr3stKVd4gLMEfuLz9mMt/2TKXi4=;
        b=QMYG9NsN9qlMiG3joobiVR8foqc6OWcdF6tK3pJxAhOAKtP9ulS5CUUK0J5H2Tkt4b
         gq5wbOgS0Z5x9M/7RmWUkzV6F/Xkq5d0C5xgKWy/piIlDTv7iQBJ1UD+NsleIrSl3xIg
         y88+mqowDM/q+zgPIueB35W6ZUzexlg04dn3hkEM0Y45wV+1LV/fqHNQf668CaKI2DlI
         eB3yxrv2fEBeAAW0KiB0V9XrLNBuVRkte1jslo5MnjN79y/1X2h1Q0kNh9qsghC4lY1A
         AM5fWkgXk9IVV/FRVG6Ma5IVpty22rp2moo9dKolr2Z4WhnOpqgtoYIqBqpY+771te30
         mkTw==
X-Gm-Message-State: AFq9FYJjAlbrL21fttnC+5vBF82yZglbmkHFVQfWxw8rdFEKKY3NzSV3
	A+XRnGFTpjlMdZ07r74so0ZhTWH2fXMnaD9lZFAsW31SgEFFMFK/WJdOFe7kGd/IZh0=
X-Gm-Gg: AYBFou3qgxAjxwNOCJel2ClbEvIZzPiEdEZfYjtJ62QlsLA2uRqpqhdoi+fsXO0sycv
	ze+HDh6P8e1AtUME4wRYe2gVfw65t1iIAAHX6g0KACErL0Rr1nfLM3qSlWd1lKeu0wx+4BR2xPm
	BYMP7VwRaSqVHndGajV4CVWv/8+X4KOer86KHTTqevCZcGOU7+AQcZOcjWW0NV93PSvSLY51aW9
	tb6FqJQP/halxbY0TGhn5jGRgx+ZmckjgTI+6fJ+uzEYXzc4LRpcq0yZmNaN5z7oWmozThwyX5Y
	1gMhLFvI2Z99LchHbJjt1IL+bOCoLkaSnHmHz13mJbNdGrdqsBBB/I5NKP0rP1BKes37expltfV
	cXUECSovWOmUV/22dyrk86+NPnhmozx6Q/J9wWcMNvBpRbFJy69Z0prymKB0mJwLydCDLDOdh5p
	uaDsYTkX7eoyzge4tlmRz2F5QapaeDa0qjQs/Ce26e/1u5Hk7q5g1TTykUy/PGQQDOOrxdGxsoY
	ogtJCfgzjy7753U/iKqyRwF/PLy6hGNmJNs2lBKnNOLvnO6S8Wv+KO0IkI0wavLa3q9MCCXTkLG
	t/l4y8HlZgMbjiQAJ6OHT+iHZUY6GHvDc4gEsmhW5NaT
X-Received: by 2002:ac8:5dd1:0:b0:536:7cc1:4b6b with SMTP id d75a77b69052e-542b6d60c04mr37510031cf.27.1793371118632;
        Fri, 30 Oct 2026 07:38:38 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.255])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54311f775a2sm14756131cf.14.2026.10.30.07.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:38:38 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 30 Oct 2026 14:38:11 +0000
Subject: [PATCH 5/5] btrfs: don't trim the target of a device replace
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-b4-btrfs-data-integrity-v1-5-f4d4196731e6@toxicpanda.com>
References: <20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com>
In-Reply-To: <20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, 
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793371105; l=2371;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=ztZDF1ZqGxtS4T/4NOiKbH7gRDfFsw+EMU9xNlQqIGQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QBjJtw2SeJqqjavV2wfqU2RgOh+bTq9opRfgFQHFXWauOl3PmQxQwkv8EuRgek+7TziAL7tAr7K
 rPi98RgidgAg=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

FITRIM also discards the space of every device that is not allocated to a
chunk. btrfs_trim_free_extents() goes over fs_devices->devices and, for
each device that is writeable, discards the ranges that have neither
CHUNK_ALLOCATED nor CHUNK_TRIMMED set in device->alloc_state.

The target device of a running replace operation is on that list and it is
writeable. But its alloc_state is empty. The allocated ranges of the
source device are only copied to it by btrfs_set_target_alloc_state(),
when the replace finishes. Until then the whole device looks unallocated,
so an fstrim discards everything that was copied to it so far, and what is
being written to it in parallel to the source device.

The replace finishes without any error and the source device is dropped.
With a single device filesystem, 700M of data and fstrim called in a loop
while the replace runs:

  BTRFS info: dev_replace from /dev/vdb (devid 1) to /dev/vdc finished
  BTRFS error: bad tree block start, mirror 1 want 30638080 have 0
  BTRFS error: bad tree block start, mirror 2 want 30638080 have 0
  BTRFS info: scrub: not finished on devid 1 with status: -5

Skip the target device. The flag is cleared with the device list mutex
held, after the alloc_state was set up, and the trimming code holds that
mutex while it works on a device.

Fixes: 499f377f49f0 ("btrfs: iterate over unused chunk space in FITRIM")
CC: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b0a5c6b96f3..22155507f905 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6641,6 +6641,14 @@ static int btrfs_trim_free_extents_throttle(struct btrfs_device *device,
 	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) || !device->bdev)
 		return 0;
 
+	/*
+	 * The target of a running device replace has nothing in its alloc_state
+	 * until the replace finishes, all of it would look unallocated and we
+	 * would discard what was already copied to it.
+	 */
+	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
+		return 0;
+
 	/* Discard not supported = nothing to do. */
 	if (!bdev_max_discard_sectors(device->bdev))
 		return 0;

-- 
2.55.0

