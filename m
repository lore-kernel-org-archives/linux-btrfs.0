Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792541092;
	b=dbcmKi+hQ/eyoDOV0RTyB3D0gJD361/D+ln7eYHq+BH9NmC2wnjV3RJsHJtCT9nqpPbz
	 4xKAzMQoBGypVAQ6BH6HqlcxkOcyasPvt91QXwkyg8SzS3+/pd4SuwP9BLFG8+c1HWgvf
	 f2kaYHd/Ren6q/ZrdSkxDpeoAWxwRpQR83rNDQjRXYAB+gRM5B+FckJil4hQIZIsCcC3Z
	 fDg76sxkL4OmXqdBSIj/4I70BAadF1qBBp8YHL3MqPcTwYOtbKwRdWUSDfMvT0cvwMgTI
	 cDzJTxpBbz3tLtjdabJ/og3uIU9tNqQQAiRYbRKBGSMsvYHg0+FHuDOsQosZ1zLTeyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792541092;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:To:Cc;
	bh=xUa6JaJZNycf/k/4rdNTJ5HfB0iwYIh1C+vAcX8S0EM=;
	b=puU0IR/6MC06k4nGYfJc1mr6s17SEvm3t5UNNdsSEYlCZC2UtorWC/4XTY0ctHldoxWa
	 RLiKBmfBDm9CwxLQOztV4Bc8zwyVM+lbdgshY6RJukYCdNIk6Nvn1vqnJB0beeMbaDBEv
	 28ex5bwyG3rR+KTI08z9v08EXwf/dVPvWFZ92jAIvTAozkk5Zjk1gUQ9BLUcDQROxgVMb
	 GaiPHFszz5t5gNpWQyFgExFjF5tgCgI85LnJvws1wRMdcaZSwDEdURRY3GHYK1AZdf3hi
	 RK7B94lzLYe1+MEJ54NdW9p1hA1Uu/4mUeFbOPw/DYirgmE9zkp84qWzYyIBVYlUb5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=RWHYEyHj;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687BE606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 00:04:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 687BE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=RWHYEyHj
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a19cba5c14so993235e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 17:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792541091; x=1793145891; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version:subject
         :date:from:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xUa6JaJZNycf/k/4rdNTJ5HfB0iwYIh1C+vAcX8S0EM=;
        b=RWHYEyHjGpdFczWWrkavawDH0N4jvigmgtftBFmrbFoGdPLg9RnJqiic+Zc3IXVJEo
         aV+cznzEXyrevWxUQfucmfl1rIP9JMUdW28xkNkl6I+UgQAFPrIZ6jLNA6U+KW7AqxyD
         Q5h5Un6iYIpVQ3mlh7V5YTOWHs7sPrf4H5EV+Yi7SRWHiosFuKx0c5oO9oIHNXSIAhfQ
         1R3bNFrZr1FIPC0FXZ6YYipKirHkBOAkWfJQaWvr9dM/p0eHXou3dmv/bsoSAF9AQRqV
         xHK4A4bvJJ690hht+LDcYE2D4/cyirjWdwcW/ITRCrQb/PhkOHjU5x+2z3bqncPyineN
         ZvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792541091; x=1793145891;
        h=cc:to:content-transfer-encoding:content-type:mime-version:subject
         :date:from:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xUa6JaJZNycf/k/4rdNTJ5HfB0iwYIh1C+vAcX8S0EM=;
        b=XhNad9RIc++J6r/RI1h+YQC5LQHzHbAok82pUO5NHznfc6yBVURF+zQTzRxSMSg8zE
         mbsZBNNnTOqxmugpWhfOV23A4OcbcaO6hQL+WRAe95o8OC174pT5BIlnFCoLOH4Fh63P
         5lbc4ZzhIDBDioPWh828DY3kBVIPuhw7REdWpJvmNCq4PDkeb0ricdaRR8XIjW70ERgw
         Lv6d9DQThYy8TVE1a/hcX5EurfVKx2ZRcuSdZpyRbud6TR6uO+3Js9M/z4rVPJxEPK2o
         v+k1MHQ6VcOjQcOTgF+HpNSm+vTsaKVDQuKPJDRg7/ZUv7xtWk8fhir6F5INOH/+ObIw
         SGMA==
X-Forwarded-Encrypted: i=1; AKwUvByC2AdmzGYH14CIvgcib2PkTiWL0ybuH1mfPQBV8d/RK6kESl6ZFOREPQ1JkAjFR+owg/Xre8AND3mhaA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKAsl+Csg3BMkhoAs08ZHl2/Xco1xhLaipr3ilL29Q0ucoOrgh8
	3z7cNx6645AMP9VVTnA/JlbeZ173C3TrYnNSI4Pln+AzIOroWOpcesNH
X-Gm-Gg: AYBFou0hEf9SzulTwqbZXkl8/oPSg7MMILy6bBhyqNQP7ElqDgNJfDxuSn6me8W5Wme
	BAFZVcoVngwKgelsKs3jZMFD+RUy8mB90TUqekppsj7n9QLzSusQpt06gRMFRun2mhzsTjfyOeA
	jRqkQD5BJ80fBOxOAvkf2m10m6B0lnkfw0WOYAQG+tGpueb7AtDX2v+RAswoQMLPyZQEyADZOYg
	RRJZxfUODIJFGv4mzaniMzTXKmws7az4qSYOBUUxBxb88MUkiJlgoCQHEWxY27V6MIIu2y5VOlY
	Z7Un2q9R0Y9PsWSlBZ3bDb/0FHagudUZAepKDrnE6SFaTv20hGmmGcGWPPnfJmqma2YOae2yxA2
	NaL5/LamwtIoqP8gRwF0NilZ3dCxBLeAeFT1aGdOiZ9Epi/gLoJ/xVGOyegCGsgCD8p6zYayRvb
	p2PRi1UVUzAWZWuv1aNTyjipEdUvJH2oGbCy0HGgnuhZT5MIZ84Hmos6qKVQwKOkj5UVgrxHvvH
	3DAQHlW+JC4BjB5zGq9HuuFBP674P/FkZs+N1Z6dmyqZprOWJuD8fcxdjoLUthdgXcrzg==
X-Received: by 2002:a05:600c:5252:b0:4a1:d52e:c2d9 with SMTP id 5b1f17b1804b1-4a1fdb1c387mr5049285e9.23.1792541090451;
        Tue, 20 Oct 2026 17:04:50 -0700 (PDT)
Received: from btrfs-unify.eml ([171.22.87.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fcd234fasm10213285e9.3.2026.10.20.17.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 17:04:49 -0700 (PDT)
Message-ID: <6ad801a1.7e3d83f3.3d770c.7180@mx.google.com>
From: =?UTF-8?q?Adri=C3=A1n=20Garc=C3=ADa=20Casado?=
 <adriangarciacasado42@gmail.com>
Date: Wed, 21 Oct 2026 01:35:30 +0200
Subject: [PATCH] btrfs: unify __printf and __cold annotations on error
 reporting definitions
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: David Sterba <dsterba@suse.com>
Cc: Filipe Manana <fdmanana@suse.com>,
    Chris Mason <mason@kernel.org>,
    linux-btrfs@vger.kernel.org,
    linux-kernel@vger.kernel.org

In fs/btrfs/messages.h, _btrfs_printk(), __btrfs_handle_fs_error(), and
__btrfs_panic() are all declared with both __printf() and __cold
attributes.

However, in fs/btrfs/messages.c, only _btrfs_printk() has both
__printf(3, 4) and __cold on its definition, while
__btrfs_handle_fs_error() and __btrfs_panic() only have __cold.

Add __printf(5, 6) to the definitions of __btrfs_handle_fs_error() and
__btrfs_panic() in fs/btrfs/messages.c so that all three functions have
consistent __printf() and __cold annotations on both their declarations
and definitions.

Suggested-by: David Sterba <dsterba@suse.com>
Signed-off-by: Adrián García Casado <adriangarciacasado42@gmail.com>
---
 fs/btrfs/messages.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index 0704be7be..73acb69c3 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -116,7 +116,7 @@ const char * __attribute_const__ btrfs_decode_error(int error)
  * Decodes expected errors from the caller and invokes the appropriate error
  * response.
  */
-__cold
+__printf(5, 6) __cold
 void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function,
 		       unsigned int line, int error, const char *fmt, ...)
 {
@@ -276,7 +276,7 @@ void __cold btrfs_err_32bit_limit(struct btrfs_fs_info *fs_info)
  * Decode unexpected, fatal errors from the caller, issue an alert, and either
  * panic or BUGs, depending on mount options.
  */
-__cold
+__printf(5, 6) __cold
 void __btrfs_panic(const struct btrfs_fs_info *fs_info, const char *function,
 		   unsigned int line, int error, const char *fmt, ...)
 {
-- 
2.56.0


