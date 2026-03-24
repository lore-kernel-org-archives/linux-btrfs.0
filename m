Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9923537DB
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 20:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774384806; cv=none; b=ct6dVoAcmyzAV7JYTBaRe9LpuL9cs0mXyF9bJ44ZSUv+mT2hae8r4HvShiD7shebjjQqRxOcip7Qu/wy7k7UMmFIGTAZHF7yeIndUzT4i3NI+2M35B0NqfRH+nb9LzX8BwJdRwaO/qGGLXwQ+H8k5P+RmZujmc73xEn+TwQ9pKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774384806; c=relaxed/simple;
	bh=Jyvm+hAJgOFR/cXUU6E8c/lAFJ2joNdyKFhBWNxRSbc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=nfKFekj52Jy9ybBHvIkwTlv6t5i8ePenXF4X7GrlC7UPykBkIS+GE2M2xBQ7CI4+8OrPJU9ueE+4SLCT/poHsZqkEV78SwsGf9vU/KmGVZG93pcoDbSPzxELl6bnXoWwqE4j3BImi1XjcxjkvI6H+29QOBbyYoPBdqRmj8eAVFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SlBNQhti; arc=none smtp.client-ip=209.85.128.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SlBNQhti"
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-7986fb839f5so57484977b3.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 13:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774384803; x=1774989603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=SV5y3qN1rapkvhai2SfnVgrSnlR+8z62Znia9g0GMWw=;
        b=SlBNQhti2yPECySDVvVVkXRG7amlyc/FXFl9vzX3soSSX/jycu6ehFBRk+bW1QIvWL
         8MUHHr44WAVrjhwF7q8Pd2rbGNqIIO+TV8giBMgf/jwV5BXNQZxL5Ik0Iqko9arZYMzU
         D7c3cWaA/DjIqxbZ0mThfuHC022IxRrGWDtRDYlXd578yZxR5EVCYNUESATUdMhgd4sW
         0OzDTGXK+HRIkzArIT0KykXT/oQtKb09gLgybNvFf2leGwSOmJan7XwFU9s0Q9WAKr6k
         iH26oDK7E8cC9Zg/x8RC8gNMLeg3SjmG3ebhL1Sv9/kj1RWDubIDtA9EM1WuzpvRn3jV
         4P7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774384804; x=1774989604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SV5y3qN1rapkvhai2SfnVgrSnlR+8z62Znia9g0GMWw=;
        b=PqpA0rMy48sgvv+W0eZ7T0tYuYPLNqLmJqa2PrlLxKx3c9MC3QyYdgxXKOjKoK6as4
         h2ZqrUbJUGS34LBv45dKn4OZzXwwKxJH76rGM7PwLslAshG88Nvgl3RvKSsCFptXPaIQ
         jnPHmkjTy3YZ8OSpcKLT4PziPa7fve1R3i4tPBfPeJAVfWMQa2g5aSqFm3uNcGlCZtsp
         Lfsp6+EUZdQrTrwcjBD62urA9cWJvtTPuZMwfnSapA50OK1xxvT/hBdvc00Q6r1ToHHP
         ZvZ+KxwV8XTlzkA0RwZLxOdxD/AYPmM2B06N+Z/1dI9DtDWvwF7WpFSpvn2IzZdvuf6+
         2c4A==
X-Gm-Message-State: AOJu0Yyw3kv1xdY/0Bn4xIgNOaKmpw8up+xu4rQwc2ACNIkgZWeUKBjA
	jEVWCzcDo879reFKM6i9wvduFPc8tNSvTPe2ZKa1Vtshj3K4pY/Uug4ZrBbnmaYQ
X-Gm-Gg: ATEYQzyBSOrvtcD4JL9gdkT8pfEHncgmay0USd/kT8steoK03Zo/6d9J4SYUPOgIVnU
	c2F/r/vG3u2hzFAYFyTxp8oaXB0fg9Xd+otyfmP6TJAzYOdQSADuqYeFTZ5Luhxj2JQLHup/12Z
	VYOrCX5oZvmznnPKk9uAozds8A/HuhABBheZAHkR0klfvu2SHEP2jTbKqmOYZGhfmoHOo5cSlgH
	Ya1PeSGwZKtO1IDa9zCmTiHAx5yOscf1sYQj33NrFbzUzv4uOACbQIvg+3gRrghvnzg7vZ6dMz2
	oWekrBp//nL7+8fVWUxVRT3GSB9AucyGKZIzuCdsHYbdznwUm545Tb2aAhsZQ6Zi3igQwRMB3uP
	Kh9TPXppo/wrZMYtjc//R7y5raLjVSrphcsjL35z6PpTEJKtkMo2USvJmBw5xBFTl2NeRUHLZeQ
	MVNAryp8CuPADQixSeMg==
X-Received: by 2002:a05:690c:22c9:b0:79a:c98d:2bb2 with SMTP id 00721157ae682-79acf69623emr13165777b3.55.1774384803410;
        Tue, 24 Mar 2026 13:40:03 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:59::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a9057eb37sm77707147b3.33.2026.03.24.13.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 13:40:02 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	fstests@vger.kernel.org
Subject: [PATCH] generic/301: skip extent count check on btrfs
Date: Tue, 24 Mar 2026 13:40:00 -0700
Message-ID: <c56960b514baf810f2929b5e955a966d9955c468.1774383226.git.loemra.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 2/3 fragmentation threshold was designed for XFS's cowextsize
mechanism and is not applicable to btrfs. After commit 0dc118b3c327
("btrfs: be less aggressive with metadata overcommit when we can do
full flushing"), btrfs commits transactions more frequently during
writeback, reducing the extent allocator's opportunity to coalesce
adjacent CoW extents. This causes the extent count to sometimes cross
the threshold, making the test flaky on btrfs.

Skip only the extent count assertion for btrfs while keeping the CoW
write + remount + md5sum data integrity checks, which remain useful.

Signed-off-by: Leo Martins <loemra.dev@gmail.com>
---
 tests/generic/301 | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tests/generic/301 b/tests/generic/301
index 0303f25d..985d943a 100755
--- a/tests/generic/301
+++ b/tests/generic/301
@@ -62,7 +62,12 @@ new_extents=$(_count_extents $testdir/file2)
 echo "old extents: $old_extents" >> $seqres.full
 echo "new extents: $new_extents" >> $seqres.full
 echo "maximum extents: $internal_blks" >> $seqres.full
-test $new_extents -lt $((internal_blks * 2 / 3)) || echo "file2 badly fragmented"
+# btrfs CoW extent allocation depends on transaction commit frequency and
+# metadata reservation behavior, so the 2/3 fragmentation threshold (designed
+# for XFS cowextsize) is not applicable.
+if [ "$FSTYP" != "btrfs" ]; then
+	test $new_extents -lt $((internal_blks * 2 / 3)) || echo "file2 badly fragmented"
+fi
 
 # success, all done
 status=0
-- 
2.52.0

