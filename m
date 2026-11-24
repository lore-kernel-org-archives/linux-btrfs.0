Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795535234;
	b=H1rGJ6smbcylPPcy1EQWol+phh/HqFAxJH6xYpyas8dMWOlQRynqVBWezzVXzAwG25/r
	 ZnJS+WUn+MOFv+psPKvndBRN3lfFdgVAPb8do7bgEJ8fMsHw0r/kIHpp8M6nghqHNwvdu
	 pBw1eRnylNBXzFrRtuVIjJF34wSgp5azcFie5UWQHH0K0TP0sbr/v8bfyiazYBibE1J4v
	 d2TijrdHut+aLD7knjmtmIIxRh6qxtGAFcSH4me6AlSHn5fs2Ux9FrfkWcO/ar3kh3BO4
	 SudPx0yrNCx5sahKdPivfylDXEjBHx44H11EmBo8g1RZVTrmonbIhv+xTqj6FlGsm6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795535234;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=c+M74FJOsT5YQLJ08JqifNowztZ/oGKZWIre0sbqMpY=;
	b=utSYSHQgE4EBjKLzdNnvY3okfocUAofhmUZMCD10OSFR7Bu80bJYUeRg5yJULPImndNo
	 n89LihECbVJn6Yx0O8s+11oo+dihEA7BueLeYV3oOYKgofEId8XO0c8QWAd7CskqXo7SY
	 IYEjIWTnppL1nslQAGuz1GSg8uVbpqxho0Cw24NVqtOuGK52O58GhUKyuZaZZ0XmqA7Nq
	 tQrSoJ2hIC8pRsvo2Qexzs4cMgHEGoIRNwQSkoJUIaraEsaeWR7YYX5W116/KgN+yW7zw
	 HZ1exe8A+dR3JAkSum8xJ0oTqKHa45fG0QLXrys4bbtDfVY8PT+fLhNx2YU0A2+lJYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ZftFBMZb;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE8C606A321
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2026 15:47:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBE8C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ZftFBMZb
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso50704945e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2026 07:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795535232; x=1796140032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=c+M74FJOsT5YQLJ08JqifNowztZ/oGKZWIre0sbqMpY=;
        b=ZftFBMZbn0LcIRHZnzSsxbJlCymavz+w+LluUE3GdSb1gt7+ej3Dstzvhlcejgj559
         jtVlxolwZJ2FVVlh1rTZSC7ngZZlWL5UqaHwPtYfqU01PnFh2173/eKTW6nlOR0vbVqw
         0tFBYRBuxpXIwH03MMcTtFOdsMUaq82qx9vBnHQlYIk60nvSvs6gkfHOa6pIvXVB019S
         MzuNWMaKOJ7x/xGrzhL8ZRJwy0u4yKwZ/BOYX2ECRRCMtdf3zscK3N69GU6Dt85/ltMD
         NFYZVgZTieIAjSo5r2Jo+4+E/8Nu0+CZESCFN+DJi5EYGEwVTf6708tTA6+YRVIwd2Fz
         7ntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795535232; x=1796140032;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c+M74FJOsT5YQLJ08JqifNowztZ/oGKZWIre0sbqMpY=;
        b=jFlMz34hojY8sJKfJFVcGaD36VM+nBlXfu+iVsayKKC/Ri6AgKsvbHBGv4UZwuUqTR
         rt4M0oyu6Mx1oEdcmo4xJDjTGVdnP4G2pn+cMUDnVuhDpTDLC7CXS1tQP3d8gpPoVIHH
         xGwLgUh55biujhV3W2uiA6BLJRGhuToCecUap0Kx6Reyuyy1POG5YVSTB7rB+wfL1xyj
         hdlcW4V2m6QXC0ocXw7+9SNyGImK5PvP42mYjnvUI+vzt1e1BOLSznMerwcTJJKZplsN
         aCN6xiukX98jkLXSmjN6mrayvYmpspfLM1OYM5BfOZno1kPK5wkuJ9d6yMpTJbfVb3/K
         +tvQ==
X-Forwarded-Encrypted: i=1; AL+hErFbIyANjqJLt85sVspasoFziLt88hAC+odfnAtKVkA3+wfMwkKsR5nclffdjnbA3KzT7xaGk6LZvfRRsA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+JGkpCvS2y8Hu9pjq3cNruy8sVoZJhkxf2PhHcSERWpFK7L6Cp
	Ycjk0lezvS6AUfevoyZjcrIEKXP/SkH61S7kem+ghSwUHFazCzo4BvdDW5MZZ3+tQWMscpJlHVv
	njs2lWXLp
X-Gm-Gg: AZFdTZdxwZFKYb3OLpM3PEam2/tabNPv2eCRRUm2Ab4CwBLhRrR96wsQAdpr13VzT+Y
	nBs3jxUjrDpc6oNi0308q7Bi1b38qtbt7mvhZ/J4xBOfDKakzdkXV2w66/yNLL80ZsFP2Rikcdh
	H+zGpPFHu4B1DiVNZyfBy4TrMERfnHdhPHP4GkazQBqu34BSkso6KYHNZm7SHWSG66SP8c1l8wv
	xB86d5ux8fJwT9PKOiazcI9kAO5Bca5moRmEvwWhZbgRnrHAzVP2Pxo5g7bJedOKVrxPkxclIWF
	Ob+r+Jf+ghRbaTrvxbZXZuxkIMRXfE3SHvbQUlJEcnMNfeR7+4V61aD9Oqj/V26/DQHg4EBhDsE
	WRPJD0WEQZTFrEEJ3Hahv5ZMJIsEhZH6CyvFDMwt5VibbPsRS0aKC64Y/JFovEiy+TL1Oi1Lk3p
	2qCfKywrUgMvVFa5KB8YFGzv1bQ093vyaFxR5nVvFSK6qirhm5yXrYq2Kdyary7fnjyFpwZSO+H
	ylhsLHGQXsgkaVIzWgVwR7c+L8UbbHsN79GkH4ITrHJrZEx3SejDuQXiWA4of451Zj1m0kfAeIQ
	aX3cWj8BQ8Yi6lwTWc64emnGB7D5tR1BApDfKNVjjZG/Iv3GXCkWqBNJ8cM9V+zv7ktIO2cZsZv
	47J8KC722EA/h2d8=
X-Received: by 2002:a05:600c:154c:b0:4bb:6a78:7c42 with SMTP id 5b1f17b1804b1-4bb887c3428mr314460225e9.1.1795535232298;
        Tue, 24 Nov 2026 07:47:12 -0800 (PST)
Received: from alex-t14g7.lan (p200300cf572c28000f8773503e2ef921.dip0.t-ipconnect.de. [2003:cf:572c:2800:f87:7350:3e2e:f921])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a9846sm525023365e9.11.2026.11.24.07.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 07:47:11 -0800 (PST)
From: Alexander Mikhalitsyn <alex@amutable.com>
To: dsterba@suse.com
Cc: mason@kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Lennart Poettering <lennart@amutable.com>,
	linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use super_set_uuid to support FS_IOC_GETFSUUID
Date: Tue, 24 Nov 2026 16:46:04 +0100
Message-ID: <20261124154604.77736-1-alex@amutable.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, FS_IOC_GETFSUUID fails with ENOTTY. To fix that we should
use super_set_uuid() as other filesystems do.

Reported-by: Lennart Poettering <lennart@amutable.com>
Signed-off-by: Alexander Mikhalitsyn <alex@amutable.com>
---
 fs/btrfs/disk-io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d8d433ac458b..fde9f4c4ea11 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3616,9 +3616,9 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	 * on-disk UUID directly from the super_copy.
 	 */
 	if (fs_info->fs_devices->temp_fsid)
-		memcpy(&sb->s_uuid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
+		super_set_uuid(sb, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
 	else
-		memcpy(&sb->s_uuid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE);
+		super_set_uuid(sb, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE);
 
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(fs_info);
-- 
2.47.3

