Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793283151;
	b=IxpCjp+nVEiynKLMhhF6alSPq4F8HXvJkH52TgnHvrCSBb5BYGYde7prkas4YMxYShxN
	 qThfvO46gUd3MgoaQisKy+DvyVCj0U5wpfwW6yGJwJ8SCVMGV6nZy2cTdfHnuBTPMMcNy
	 uyUzBfG/T4u2L6rk99WFGg8aDHNkn1Igf8g6gkeKx60HF3r1w7BjzwnHGah+9GzhQXhsl
	 qnuqhCYM4+qa2dqLkw0pjtyYkCRY88uySDj2ySlGNITOJIdxhQOhEsVbbLYpwnGqIwjUs
	 u7MfWZF4qooGm0EdESXUGGvj8uPL8MJtx/qfcdTt0clSCvcpfj8k22leZk5PfuYtwOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793283151;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Z04WRROPPrp5uX+ZqPL+HyzsZieHk+OVtnfHzFqKFIY=;
	b=As2jt+zuhRpy2wkxwQSdrosQAAxeubcw30HK9wVz8nnu4Dtl4JNydt1JStKS9b0H7lvK
	 3bPv6VOcM5VBBBF/z59lJjzjgT4noIoJJIXI7lis6xBfQ70QAIN4Ce4LgzqeYk794A7ps
	 kPp6fHhpV1dZdzrTPJZpE7XbaHmXuaUaMgHGk+b/zC71gp9CeGatERtvZoZd5/ePp5bef
	 CnmqthlG8EqlpHP9WANqVfdFibEC+2N+pSyDcysBwhIQYXFPV5TUjO7lHW+UOlKIXy2ln
	 Lo+qlgOrzn6ZPbAZOopoQL0H9K1XdWsxB12cipmnnFee1XB8QemkHfwYkqpgrerDBIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=plMf+IvT;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6A5606A31E
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 14:12:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F6A5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=plMf+IvT
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-15ea896ddc8so3237576c88.0
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 07:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793283150; x=1793887950; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z04WRROPPrp5uX+ZqPL+HyzsZieHk+OVtnfHzFqKFIY=;
        b=plMf+IvTY7+LBN7OFHJ5S3/3UZK4x+bIrisZT5s/oWkJLkoDpW5BdnDYfJK8GYrxsT
         epMyvwB5DN7XSRCpPNF3tKj+hvwn2y6GBqH5h6jTViOnUWJFfUHrtpF9wg0WMNbvrIHe
         DoPbd98OQDC/en1E+VfU/L8u6HrYYV5kdhecIxDbxkcybx4qGAhtdEDOQHEGLBq/EUq1
         vq8uRITaB3u7K3w71p0R++LP0nqVeRkxoJlZhpM1IIt3l4+YH8/mYjgaq2TLrMHcCAwa
         ixHo546OzuEbKeWVnFnEdYrnEMNNVXbRYMuAAflW8FI+1Izp0CuSjFRsyxxqZgHVdiOU
         ezlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793283150; x=1793887950;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z04WRROPPrp5uX+ZqPL+HyzsZieHk+OVtnfHzFqKFIY=;
        b=G+5GwLeYgYFz7oem0eYZatODwzAFA5INvcyC9fu4ZQgoCl6DFbPpQkzPaqi6xCr/f2
         FThBBHbmiVuSeT3/yeubWlf0VGqqhR5AWdRN/ZlgY/zNVtrMZTJ0o/Zo9QU4O56+l9VU
         epu4OhrfBGWfr4r8rRdnfHqr0wl7fP/pSDcDPm1zUyVI768giPP1JdXZE6zpdbWr+p8h
         R7Vncwxb2iH57krN/g7AMGAjRSK9vFy/M4SSEMgOVsQxH0bMJawJMP7ZSLXQFIANZSsq
         U2xGzWASvf+Awko6aw7j/XOxTzBWXmTC4F8i1Fk2nO2bMxUNeVmAGyCZeTQFey2Edm51
         +5/Q==
X-Forwarded-Encrypted: i=1; AKwUvBz6CyNUXUmTF6fuaY4K5DchumJjpL2isd6e0AjLWNWR2wPT4BW/apmyiS/gE5ZNJHzJV/G74kX0aqzZRA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIOCnJ3s/sKtLRk/IwqFrGb47D75+zcnacVT5mHfm39j0EuBsjH
	Kqj+fXztXG4L45408CaujC7FzABtfwIbS7lTa5Z4NX6IozaL8colXmA1
X-Gm-Gg: AYBFou0IGzsCfH2/bskXpcANtT2IDvy4pHuPtx6nX1ehnmn2rFDqwiKdC1R5uFkVHAL
	v7m4faDiOnWSxYS61JCYB2HorwinBSo0WM5o027cJdsJE21NYvHZ0mv+C4h4LxDK0GxDiEZWDbJ
	EFQ7wzRaIbmL+yj7Im7kfpyeEH/guPLUgh2YhoGbJimhxnFfnN+JM12kujfvjgXRA5p752L7DRT
	2qb+tz0AJefxUpkMDJbQtRgt3YyZWdWXKW6CcBfUjb4YzfzJmn8LX9SJstl82Sm1tqv7cBHjwFt
	JFUwzzD5n9dO/sfc44zmxrRzTvxHCz6tc2d4+AIwPaU+mJ5VB0/R8yBG+KZLaOeS0s8FMQOIDdo
	ggCX/K6SmFVSAb7wQnROPzsiBulqv4xuQHS0VREwEdis9gHv1CZOYEyLMHcAB3ZlREdMn9XPx2M
	lhknoRg8qpy7cFFoyX0osh1U0cUFivBWvVJfm3EK+mrKsTufl1VL+otGZqGdZ6sx62uAqMZ+wPF
	aiMW1dbX8Tyo8b6xwckwspZWOeH4CTBwyGxFbJTmbcPZuRFLmyZzJHYPAjarVrUBOjlb6NxIl91
	di3MLHtdwQfx+wnPta/3H0AbFvE9WBMwUzGylXCMuixGjqT70lGq+g==
X-Received: by 2002:a05:7022:423:b0:137:5b9d:cf87 with SMTP id a92af1059eb24-1a6c2e5b801mr9762994c88.0.1793283149798;
        Thu, 29 Oct 2026 07:12:29 -0700 (PDT)
Received: from [127.0.1.1] (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75d76814bsm15197319c88.10.2026.10.29.07.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 07:12:28 -0700 (PDT)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: reject zero num_stripes in the system chunk array
Date: Thu, 29 Oct 2026 07:12:20 -0700
Message-ID: <179328314071.648427.12527832319954042748@gmail.com>
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
Content-Transfer-Encoding: 8bit

validate_sys_chunk_array() reads the on-disk num_stripes and passes it to
btrfs_chunk_item_size() to check that the chunk item fits in the system
chunk array.  btrfs_chunk_item_size() has ASSERT(num_stripes), and the
only num_stripes == 0 rejection is in btrfs_check_chunk_valid(), which is
called later.  A crafted superblock with a BTRFS_CHUNK_ITEM_KEY entry
whose btrfs_chunk has num_stripes == 0 therefore trips the assertion
before the invalid chunk is rejected:

  assertion failed: num_stripes, in fs/btrfs/volumes.h:714
  kernel BUG at fs/btrfs/volumes.h:714!
  RIP: 0010:btrfs_validate_super+0x3ce7/0x4210
  Call Trace:
   open_ctree
   btrfs_get_tree
   vfs_get_tree
   do_new_mount

Commit 2a9bb78cfd36 ("btrfs: validate system chunk array at
btrfs_validate_super()") moved the validation out of
btrfs_read_sys_array(), which rejected num_stripes == 0 explicitly.
Reject zero stripes in validate_sys_chunk_array() before calling
btrfs_chunk_item_size(), so the crafted superblock is rejected with
-EUCLEAN before the assertion is evaluated.  open_ctree() turns the
validation failure into -EINVAL for the mount.

Fixes: 2a9bb78cfd36 ("btrfs: validate system chunk array at btrfs_validate_super()")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
---
 fs/btrfs/disk-io.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c628c50..920ca4b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2389,6 +2389,19 @@ static int validate_sys_chunk_array(const struct btrfs_fs_info *fs_info,
 
 		chunk = (struct btrfs_chunk *)(sb->sys_chunk_array + cur);
 		num_stripes = btrfs_stack_chunk_num_stripes(chunk);
+		/*
+		 * btrfs_chunk_item_size() cannot represent a chunk without
+		 * stripes; such a chunk is also invalid in the system chunk
+		 * array (system chunks are never remapped).  Check before
+		 * btrfs_chunk_item_size() so a crafted super block is rejected
+		 * with -EUCLEAN instead of tripping its ASSERT().
+		 */
+		if (unlikely(num_stripes == 0)) {
+			btrfs_err(fs_info,
+				  "invalid chunk num_stripes 0 in sys_array at offset %u",
+				  cur);
+			return -EUCLEAN;
+		}
 		if (unlikely(cur + btrfs_chunk_item_size(num_stripes) > sys_array_size))
 			goto short_read;
 		type = btrfs_stack_chunk_type(chunk);
-- 
2.34.1

