Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA79A3ED105
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 08:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780992722; cv=none; b=NZGgquLJSt/LMIT6bUcxx/WOfVoYMeQF9ncqJhTAfKgxgwiTzG8OQek7p51sDxhGMRYdheTKTFvS3Rb4zUYqEhfUZAJEHrYBcchowe9XyOpPOgG7VjSHV0cWWPWAfzrl0BUAMoywbx688a3yhzuoIe7vhWnA9kk0zSwm8P8sn7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780992722; c=relaxed/simple;
	bh=P84PufrgIjIWLysvdx9UUJaO9spRCqQvE7ip2aij5m8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XcKvwYnM0BzJmx3HvGOhPPAjuSlPnooGGn5RtbnxX3RCkqYSA0/jW4wD0MnfjF0HQaGi+z2CONm0CNrMcgyP+UQO28Zbn/F4E/88u4jROIP3VsySIxXf97XGCAZNoRmGnCXgblX1qNTVJH5m+CKKO9+EKC9oKbtXtQwWfZ394O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=c7DTux9l; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="c7DTux9l"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8422f148dfcso2914897b3a.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2026 01:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1780992720; x=1781597520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xRXRowKdLLClJMEr/Ve952KL4WB0mWncWAIorXzxDO4=;
        b=c7DTux9lcM0z9TgqA+IQ4PkxD07Od4X+St/pLHtv0LspbqFLjeQM1uhgjHZHhGWi+Y
         odgmyCz070ogyhqP1XkbV7gREF9NOjIoUxOInYt7zRNnQwlqdgKSz6gCGLS3YkZP+3SB
         d+LFf9ZvXwXO9axwCBKnudDWkxmexIlIJ+2GMReVIHBWgLhQN1UQFW7sfVspHA/vV87r
         7lb4UhpzXaom9NxEg8+1c87PoV0n7s1DZ+HliGYLXti30La0ugHFTFpletuneVMW9tBM
         +nZmdTUYD4kQTF2dgkH6dfsNhKwfmnIAn3qnrRGaYGypardYB/qhRCOI6Ja+RA/VBZ3N
         2e1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780992720; x=1781597520;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRXRowKdLLClJMEr/Ve952KL4WB0mWncWAIorXzxDO4=;
        b=clv01cS1C/8uwwcG5UCzciQlHE9MBe6ZU4GzDmOMkprwyXXciTvLcAdob1t8haCOpx
         3Hkf0ybV1X7YCPXTn/RiW40385GdRCBTzl2H+Sw1hAv/nxU9JNVA7ZRHlbFaQoeqSoKI
         gCZSnfKt5OIp+Hr5/Fb2n6clrOJoKahspjlsgBjIFts7dIfdM+N1T8Mhq8HSmLvBVSI6
         odmaqyHyvkcSFlKpg91e8kKBNkvXGJvyjTsI0XmLuSjP8OPa64sZblvRXB1Aiy6zZ8zK
         u8F1zjWsYkSdbvZAFzegiFqGAzOhF9Gta6VV0L1ExpziPGvxqJivCM7fpvukjrk8IrC+
         JoTg==
X-Gm-Message-State: AOJu0Yw8LUlLCpl1FpqGb3McbRbA5DSDJ5WpdZl/Rf1yeK87aAWdk1A3
	dI2LGd/AXD4a8sGTzWldDkjvX0SvhVDx714qP0xg9wVWJDkmNAqtqIB7jEn7NjM8kBsqlu72hI4
	m+13hvVOo
X-Gm-Gg: Acq92OHlu1VbzQ8PB12w3FHzFXgfpww8qkManI3998WVje1hEKX76tC+5vyXR9hwFjV
	aFkKRX7nx3kwryWEuw7/Ihf+fmaunybTpM5Gge6x3quZVvCThVs9RRsZ4oMoJ1uJZyaudO4ChHq
	dMQ+k/bk1ArDZGW+qY5yucO9PYhw2U36C0lsu206Rwwh+sF6uUmO6Rw/bqL32UHR2g+8xN7dKvQ
	dJM9HK3oitzfn23j+nFcAshLK1epRcG9Bf65g92nJgI+wPyP4ahUXHhf6tk092FGq9X+Su+2DxP
	R6iFYUjr9iPETjdKbBw6s/BXPbYq+91z342P1C0L+BYuDXSlO+yP1T/HuVngAUbCxHjI6oy+Ion
	nIagNylkk4tFBpyD2hAJpt3lYZObqale/u5IafTe5axx4NZC4JosQRJXBTPiZ7aeo9/QvF2IMqI
	LDVWBKvTesAMKhJsQ=
X-Received: by 2002:a05:6a00:2d0d:b0:842:5711:9a2f with SMTP id d2e1a72fcca58-842b0fb2273mr19375714b3a.36.1780992720111;
        Tue, 09 Jun 2026 01:12:00 -0700 (PDT)
Received: from p1.. ([73.140.210.38])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428288217bsm23489874b3a.37.2026.06.09.01.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 01:11:59 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <clm@fb.com>,
	Josef Bacik <josef@redhat.com>,
	wqu@suse.com,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH btrfs] btrfs: reject free space cache with more entries than pages
Date: Tue,  9 Jun 2026 01:11:35 -0700
Message-ID: <20260609081135.2972081-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__load_free_space_cache() reads num_entries/num_bitmaps from the on-disk
struct btrfs_free_space_header, which the tree-checker does not validate.
The load loops consume that many records, remapping each exhausted page via
io_ctl_check_crc() -> io_ctl_map_page() (io_ctl->pages[io_ctl->index++]).
The write path bounds this index (io_ctl_add_entry()/io_ctl_add_bitmap()
check io_ctl->index >= io_ctl->num_pages before mapping), but the read path
does not, so a crafted header reads past the kzalloc'd pages[] array:

  BUG: KASAN: slab-out-of-bounds in io_ctl_check_crc
  Read of size 8 at addr ffff88800f948780 by task kworker/u8:3/58
  ...
   io_ctl_check_crc
   __load_free_space_cache
   load_free_space_cache
   caching_thread
   btrfs_work_helper
   ...

Bound io_ctl->index in io_ctl_check_crc() too. An over-long stream is then
treated as a corrupt cache, which the caller drops and rebuilds from the
extent tree, so no valid cache is rejected.

Fixes: 5b0e95bf607d ("Btrfs: inline checksums into the disk free space cache")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 fs/btrfs/free-space-cache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ab22e4f9ffdd..bbc4db7fe74b 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -555,6 +555,9 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
 	u32 crc = ~(u32)0;
 	unsigned offset = 0;
 
+	if (index >= io_ctl->num_pages)
+		return -EIO;
+
 	if (index == 0)
 		offset = sizeof(u32) * io_ctl->num_pages;
 
-- 
2.43.0

