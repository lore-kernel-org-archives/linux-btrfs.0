Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609384499BC
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 11:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522737; cv=none; b=NfEgtcvJK2VTfe6bFSvvK9yVJQJOVptB2xApK9m9wsFpMYDAYjfinUnmNnPx456iYKa+MQdF+cnDMT3IhwkKliKogz/ZCjq6NrXiTu495gZS7VAciHvj6vMONuR6KUzHj++WkAZGpFGvHb7coQ3P7efD+CEqTVuf6poeqWsxf1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522737; c=relaxed/simple;
	bh=J2jIpnwRwmawDH4c8lDRK1h7v6vJRlzFitCH/AeZlb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9txa1qS1bs4rWOQf19fR4lgTczYmkfBIJVimoVSy/hMFLcdbIMTFyFgFFM/nM2EbRTmpwZDBXleZArs/XrYLjndbKSMSCe0JQqOI/Qc1amJkLdUFrQz7njGs5MgLvsuGAh0htp8OIQkP0n2OGkARh47Aix/kYcTpklzqgcDh9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yjg54Kl4; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yjg54Kl4"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38e041ea211so718673a91.0
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Sep 2026 04:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788522733; x=1789127533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LLeMeXb2KNYqnZ18JT+L0ExYRqspXMX6i+NVk7wx/RY=;
        b=Yjg54Kl4Gq5Ymi+85zj+dPOUs2hdAIkaZkWFPAZ5sPEeOVi5vm3D0YNjM1IzOYnNXG
         mU9Okvcl2WrkVeUYcIw91UTjJe0no++U2BrZZ0UVZVSqxD0ctTL0LGuOdtD/fk1wUxJI
         oW+ES2wpmQ71Darc6WMTcxMBkjmB+RtfmZUtGVPQlLen9YDRVBqjHIWRkDh7dktzuYap
         Z8hzZZAkgGGaiPFSS1qt5C0oBsedevxjw03aui7eMEGJkuTAbepHm1+w/mn4NxD0lCMi
         8D49ss3lnxnQJ95sgQs9rDH+Fl9jfEooWiOIKpqI8hGR9+okHqEseGjyQ/CODg0nPNM3
         vOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788522733; x=1789127533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LLeMeXb2KNYqnZ18JT+L0ExYRqspXMX6i+NVk7wx/RY=;
        b=GzG+5nrw9/eSc3cqvSS6fSL/GzUCQw6cYpf2tqHxfdfKexW4SazlTPA9s4bMWxTOlQ
         TnTgtxztRkgEW2A6C+SonFeyZjwdqt90iG2w+E8zDH8XmoEajX9WWfXY3dHpdxCdV+Kg
         gbwsoGR1Gz2Pl1YpBkYsMYtXn+UmkisyTVFu0iELQbfQ77/3gKJMf50+xwYGF219FWJD
         z7VDyrDHWfuxgf9ug7Bk0J99rZjeHlFCMzwsdwvFsDxeHzIs0ET9e5RmEkBVvIid3i8K
         pEVGtGHTMqQQddKoT6uPiI4l2yEb32IbIHreFkMG0zPxNSck8iaWo7FSK03EfA7MP1wL
         KtIQ==
X-Forwarded-Encrypted: i=1; AKwUvBzfS5bP6W39BVfWCrNrtq4trbdCz/kamSnHQAfG+X2O4pncdcf4Uta0DWWaKvbBagwbSaBRld6BqON8hA==@vger.kernel.org
X-Gm-Message-State: AFuF++nfGo8tisW3fV9enayg4MgjBBPWBK+5Sl0ZYJx4MvAAvFkZnTgD
	bkxJipDFmtQRXTCgI23HXa3vsIj/tw7EkmKV6P6THsfsNqAd9jEvp181
X-Gm-Gg: AYBFou3r3dUB7+luLKUfUEOTKhlGE2R/HS01bsld0bmAL4ZihnEPO6tCO6VkCbqRaTs
	dhE5Sl3+k5h70x+05sVvsee5+TJuNs6IQFWml/ZUVI410qrWJG1nHfNWP87Ydn5jDvaH9VBDasN
	xeMeWYglmyiT5yr23ywEzyrlVUQ1vxtGzFc5HDxUpactImIZlX3F91hWOnbq2t25QvWcaPAfyX+
	7WoOf8RQ6iAlxLjLfLw5FV/hD/BYMeH6pVMton/xfvyW+s6Sgst61BRDVU/e54cQ2cFxy5A8vZf
	maWmYHQ6Pz8GhOGF2C0eUsxQKLzgq4zi9Mjl7vSGYlMoe21XpDjKVhj8w9xBzelNXjHQG8HnDhv
	zeXV1Ivcf4S4NTJhlFv/lSjjdnL9X2E+cdz4u3wmy9u052byAtKO/P+YodJH1QaqN7Qf7KsTmur
	nWpFOwtGgJq51yHRod5ebjz3V2l37KlVaqaX2tJR5LEeWXByEC8g8X6ZFAXCyeWSGyPluPZMWa+
	SAQvluQuA2iboQ=
X-Received: by 2002:a17:90b:17cd:b0:38f:aab1:5148 with SMTP id 98e67ed59e1d1-39b26272b4dmr7443008a91.13.1788522733237;
        Fri, 04 Sep 2026 04:52:13 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243f780csm6162943c88.13.2026.09.04.04.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:52:12 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: fix repeated words in comments
Date: Fri,  4 Sep 2026 17:22:00 +0530
Message-ID: <20260904115202.7113-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904115202.7113-1-hemanth.selam@gmail.com>
References: <20260904115202.7113-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop words accidentally written twice, reported by checkpatch.pl as a
possible repeated word.  Only touches comments, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 fs/btrfs/raid56.c               | 4 ++--
 include/uapi/linux/btrfs_tree.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 1ee52a9dcee3..577412b7886f 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -953,7 +953,7 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t status)
 
 	/*
 	 * Clear the data bitmap, as the rbio may be cached for later usage.
-	 * do this before before unlock_stripe() so there will be no new bio
+	 * do this before unlock_stripe() so there will be no new bio
 	 * for this bio.
 	 */
 	bitmap_clear(&rbio->dbitmap, 0, rbio->stripe_nsectors);
@@ -1451,7 +1451,7 @@ static int rmw_assemble_write_bios(struct btrfs_raid_bio *rbio,
 	ASSERT(bitmap_weight(&rbio->dbitmap, rbio->stripe_nsectors));
 
 	/*
-	 * Reset errors, as we may have errors inherited from from degraded
+	 * Reset errors, as we may have errors inherited from degraded
 	 * write.
 	 */
 	bitmap_clear(rbio->error_bitmap, 0, rbio->nr_sectors);
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 127aabd88639..81883beb3b7d 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -230,7 +230,7 @@
  *
  * Stored as an inline ref rather to avoid wasting space on a separate item on
  * top of the existing extent item. However, unlike the other inline refs,
- * there is one one owner ref per extent rather than one per extent.
+ * there is one owner ref per extent rather than one per extent.
  *
  * Because of this, it goes at the front of the list of inline refs, and thus
  * must have a lower type value than any other inline ref type (to satisfy the
-- 
2.48.1

