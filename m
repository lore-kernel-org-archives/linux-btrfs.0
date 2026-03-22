Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994FD40DFD8
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Mar 2026 06:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774161598; cv=none; b=j2GFAsO8sjPV9aK5Whg6O9Mti/zMSxpHpHdk7Rq4lDMiZkchuMLnezppRb/18D+jiZdHpV/4caLQmPtYFHwmyUyNS2IpLjEX+jI5Qr4PR1CNGi+2oi8QG3O9ejsYqRfgCvnR7rkcfj0U8vINpiCbEmn1JW4gSainnPs9Tb9UqkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774161598; c=relaxed/simple;
	bh=xLELIGiNO6Fs8r5/4l+9XnQ9bRVd121vGyz5x7OPLlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ur7waSvmHFiWSd50PIvALCbVjPXS3xBh23xWo9/sWRbTyKinrkWA6TAmgnQmZeZzEafAu8GtTs0hJkheU/mJCuwNXFXP4sZ+MvSeqQyfaJo+4AeE5jbeV5NTlzBGXRWWffxTvuKobu1jNTd82PbMgFskYJOKaBTCGPdq7tLQzZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KDZ4kfxK; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KDZ4kfxK"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43b7481f9d3so126853f8f.3
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Mar 2026 23:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774161595; x=1774766395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hu3DEgdQu80Dn/pBg+8yoFLGQaZ25mJD/ZymmZqeb7Y=;
        b=KDZ4kfxKnt+pnumIX+MnDCl4rdho1eKhCaJFnfscdzI0Uy5PWhRsNdhanUdfZXRKTh
         ocuqvrYEnHI2ty7icla31GeFER3R7RhzXHPTmROvOg4eAaNrwDnx2NchsG/cyMFHcmrB
         cenuJa1mnLP88MZWX0CvrrRoz/iIqTL3plTLB7HEahqBJrQbR6U1b29z1Ke2KSgJpFUm
         xzMD3qlHyt6GDOq5XPPl31oSuQsXliDAqFT18ux8/J8Ysc/Ct2e2DbgUq9J6sFjCV71N
         3p0o536Z+PVgRmqSEOwV91caT8C/GFxlxEN1CMIaTbX6nXLzFeEbEKc2kvPC9+ldtlgb
         7zOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774161595; x=1774766395;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hu3DEgdQu80Dn/pBg+8yoFLGQaZ25mJD/ZymmZqeb7Y=;
        b=Q9pnUiuZ80cnyIVJw32tbMNWrxOFLUCXub/DKpVflVKcJnlNPnkeWTy2PZVqtKjXoL
         efTyCwjVsSBs6MrD1BQLk62lZPNGrT7fc01GY1v9WlqkC1RChpDjjqyXfLv43dcONeBY
         7DsvMqcYMqqfPhdnoE5NtzAhQTe/B63KwdRVxfeNKymwOCdxtTG+6zeqngxk3pQ8aHrx
         IVSaN6Iybsn6ihNN+jfzZUA3MgWbgX/rAVpNOnyWr4HQh1RvM2W3VpWOGDXQEhM4d7SK
         Gwzzh+ZZWCQCF/5dma0rQHxhNyhAGczgMIlhrbvmV+8oI1VVmLyqXL6arI4GW7PHqjBD
         MzSw==
X-Forwarded-Encrypted: i=1; AJvYcCXeXlaFBy/twO6GGbYLDZBgtK6i0tSdvNzLB8ktOzyZWPk3R3LJA38WWRLVXE8efbroufMQTWuStOe2Kg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwRTzDEHhCD+ZIrviCqVikd/TIfccoFi6lqhyxAT9YJpII7zojZ
	T4Z8F+BJ96MszJwQOXEuWQP5ViuUx2I8/WUdSmqOMuaB6bT6PDIJNoBB
X-Gm-Gg: ATEYQzwe/YN0POzh0hD6wtdqirST1EaUA7wHkq5NEy3mRnIb/ZtRWafKus2vwf01+uB
	+1Fzra9LQEDt1O5dTZbqgLgAzcTv2FIkAw8CF7P3VusG+jH7NyT6Vk6p6UWlRHveuqCZJ4w6Sav
	Bc5Z3q9yrZLmOeSzuTLmyN4OltiCpZiYVH94wo9Gtzkan9xxblXEwYgVk8CgcRTZhMidaavPtof
	8r1xfSW5ummzi6sExOewSy0rpuqMncYArYwPJFtBN0y2c+jYo3opqR0257LfxD9rdx2/QTwpwn1
	oZ6Z007B05+qzp9FmKAhdOAncHqaTLrkg6QYVkf2iaS3ijfqMuCtuqbxbVA6EXkh1wSs4rILnro
	LogtfZyIwtvJdkPJzafHrUmKofc7moeDRco4R8V9Oo/B7aMm7pjZtb+ShRdVwkZTpS44pk37WMb
	5Z8GKCtx0YUIo=
X-Received: by 2002:a05:6000:2f84:b0:43b:4273:a6ce with SMTP id ffacd0b85a97d-43b6423ebe4mr11429559f8f.3.1774161594784;
        Sat, 21 Mar 2026 23:39:54 -0700 (PDT)
Received: from yepc2 ([87.68.133.22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b647177e8sm19503814f8f.34.2026.03.21.23.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 23:39:53 -0700 (PDT)
From: Yochai Eisenrich <echelonh@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Yochai Eisenrich <yochaie@sweet.security>,
	David Sterba <dsterba@suse.com>,
	security@kernel.org,
	linux-btrfs@vger.kernel.org,
	Yochai Eisenrich <echelonh@gmail.com>
Subject: [PATCH] fs: btrfs: fix btrfs_ioctl_space_info() slot_count  TOCTOU which can lead to info-leak
Date: Sun, 22 Mar 2026 08:39:35 +0200
Message-ID: <20260322063935.3951728-1-echelonh@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yochai Eisenrich <yochaie@sweet.security>

btrfs_ioctl_space_info() has a TOCTOU race between two passes over the
block group RAID type lists. The first pass counts entries to determine
the allocation size, then the second pass fills the buffer. The
groups_sem rwlock is released between passes, allowing concurrent block
group removal to reduce the entry count.

When the second pass fills fewer entries than the first pass counted,
copy_to_user() copies the full alloc_size bytes including trailing
uninitialized kmalloc bytes to userspace.

Fix by copying only total_spaces entries (the actually-filled count from
the second pass) instead of alloc_size bytes, and switch to kzalloc so 
any future copy size mismatch cannot leak heap data.

Fixes: 7fde62bffb57 ("Btrfs: buffer results in the space_info ioctl")

Signed-off-by: Yochai Eisenrich <echelonh@gmail.com>

---
 fs/btrfs/ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d75d31b606e4..93c5ea91f401 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2897,7 +2897,7 @@ static long btrfs_ioctl_space_info(struct btrfs_fs_info *fs_info,
 		return -ENOMEM;

 	space_args.total_spaces = 0;
-	dest = kmalloc(alloc_size, GFP_KERNEL);
+	dest = kzalloc(alloc_size, GFP_KERNEL);
 	if (!dest)
 		return -ENOMEM;
 	dest_orig = dest;
@@ -2953,7 +2953,8 @@ static long btrfs_ioctl_space_info(struct btrfs_fs_info *fs_info,
 	user_dest = (struct btrfs_ioctl_space_info __user *)
 		(arg + sizeof(struct btrfs_ioctl_space_args));

-	if (copy_to_user(user_dest, dest_orig, alloc_size))
+	if (copy_to_user(user_dest, dest_orig,
+		 space_args.total_spaces * sizeof(*dest_orig)))
 		return -EFAULT;

 out:
--
2.53.0
