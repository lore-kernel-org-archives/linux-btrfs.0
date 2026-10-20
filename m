Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792525632;
	b=uXnRoToiK35HEUjWtmsqGRddX2wbYJ1EWQayoorUw7CXnnoQQRF8hrO8osM7uMXyPRaj
	 WMyMxxoSebte+07r01Zu/1rUGwgZEVeRu+jeQbSbPHv9QHdbD/gJVAXdfqw2mbQUeRkbD
	 O0LnSOmBDXTc02V2hZQ1aRTeR5d6XZCoikRXwDcGlRCSZwVgS6X+06wz0cHUgRumOM8tF
	 RtFQXHTfzKnaTOTfF9DfeiqAfp4RHUa4R+gr+nDhNmHeL3J638JfOHo2OxXICW+9dL97v
	 tBgu7h53b3bOVb8iHVuCE6AHPw+H+Y6xXeEM51XTYQBDjsLQBYgv5y7OLPi6oQ1JcSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792525632;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=y+sSUnHde30RD2/J7ts5O/Z4HnAlTV31DI3NhnWgYf8=;
	b=qg6tS8iePJA7s0jD5pe7y02pdk1EpSrHM4Doihw3p9XxVJviRRDqIF4zSN9EtFs+yFvv
	 WFjxQSbAJZErccV0wlGUpqV2E2WJqVCx4snEDaHs0qlUupOwbJkAIv5S7Y1IJTP+qXFnJ
	 FTMfeYZHb/WSQVn+gImQwAddF7Z5izeTI5aa5WLFOPMOfcrk8N49YSE/BLLS/xoADcbZw
	 nF6XwCuNye/yi7//k9rEUsd2VboW4v48tTfI4zbYV2UZgZQtNLs/tcwK+GTQZkj+ZUfav
	 +IRDswAkWOJP32Nu2HwuHlgY5eeyVPa7COx7zBDGK5h4qF2FQ48kYMoUm3eUVhoIAGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="rZG+/Kr7";
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF6E606A31A
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 19:47:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AF6E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rZG+/Kr7
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a1dec056ddso20522655e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 12:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792525630; x=1793130430; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y+sSUnHde30RD2/J7ts5O/Z4HnAlTV31DI3NhnWgYf8=;
        b=rZG+/Kr7OgHG5o0r4x60PwIDYM9dRqh0JLPQ4hlqE96/1PFDX5lfGwdwxOHNHhrvKW
         kf/QTLGiZK5tOZxxYZXAUVbTAqabvK1CXnj/opPIIFJQPmD9rx/JNfW9sbAA2g/3u6e3
         ZX8DT8+yuKIROGhF6hQxLzYNbimbHtQg/6N4T7EeJyndyUJkWl7yiUez1L2B3JOuOHZl
         x/IbYF9NGnWjiT3rya8Ki6o7ZmkTiEX/7Rhh5VWlSnNsjnApPiw1+L2KfexlkMXlapyI
         h70tIlbLBEKmCkxcLFtD4wVlK7jdFt+SkWC7BtYXebpVuClQDpQCjTVKbZJ5X7NdAQaT
         Ltyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792525630; x=1793130430;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y+sSUnHde30RD2/J7ts5O/Z4HnAlTV31DI3NhnWgYf8=;
        b=S/CCNXY9mF0UJEibz6nqykYR0rx0FtPo/Gzy51YuPCb3Uv0BtxI/9Do1NWrXSoK6oR
         36DBWeT1Wi+Ue1nsDfh4m3YLwFoUMZ87mfgY/PaWQhJiN/DCH0rJ4BQ00tynI0KkY3Au
         1hvZ08VGjXC8ahQz2kcflMNlT3Yv8G2Ug3W0FVjRDvMbseOTlTW4oMfOkwofTajGWg4f
         EK/gajaVbSjjvAhqSppHakMr2tN47Qr8ORuchgAHMJIRMH8ePitY2QcPJg8dQzE6XuDO
         mLBakez6DPXfYD9e/ZxiLqhzlGgI350vmhSjAzic92rMAnAPseouwcM9CafvRy1FgVs6
         u5NQ==
X-Forwarded-Encrypted: i=1; AKwUvBzjwxadqSVMwrgmqsth4y3wQSHJvCU4Ju+YKOs+/gC/f5XE7zNZyLVUEwUCom5qoarzqsE2/fQmO9OdUw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIolwPs8MVEXC4ZeblDoMSN7S5vhxdhGoxoVtdcvdUFM8ctqHQn
	8DMPXWbnUFOaTq+aRyk6PG2PjZnz7fGhrocOKaOFeE2MytDR8FzsnAiMn95Ibxh0bVH7hQ==
X-Gm-Gg: AYBFou2+nYAssp6f0R8Y/zf7ea+NHHb3t9vw9a0O1aNxnL5XTh5iAJqznnU7B9uFMV9
	5a44aF5FSLNB/v4/itJgamnm+oq7R3r39BpMDL1B+HyFn43hUVEdCt31+iJxQqQ39Vfv5wbzJBO
	bNqkfF13J7LMEwi89zOeC4ffTiB/AEq9j3LcPYr05Vt/XHrERYQZJY3BUG9gvwjvJzfH6GwKGcV
	3uP/JeRPy9APHUm+oFcc2i3+bcTvGDg0VJyNErXUeWfHqdj5fmOP4oRLKce+/zuUCnWf3K8kPTJ
	X4NHLIU2Mn62hyP2t5j5tFRgBU782tNdP5HfwR7B/AvzrpAEEv6feALB7mDkibWMgrtBaM61hU8
	sZu+eVYdZgMxP+KMw+Qdght0zCErus70MliRIY7iyOcvnnZKhrD37rBgHbdilaNU5ltwJhqaMUd
	go1Lsxu4FvL/N205qPxIaVmVJQ/iuMApfx19R5HkuRYLlXnEEJJL8wPXTIipFghQ6K2XVIdeCnE
	dEoYESub6s=
X-Received: by 2002:a05:600c:4e03:b0:4a1:d292:9d9d with SMTP id 5b1f17b1804b1-4a1d7644192mr276958415e9.35.1792525629690;
        Tue, 20 Oct 2026 12:47:09 -0700 (PDT)
Received: from ADRIAN-PC.lan ([171.22.87.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828caesm450994f8f.29.2026.10.20.12.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 12:47:07 -0700 (PDT)
From: =?UTF-8?q?Adri=C3=A1n=20Garc=C3=ADa=20Casado?= <adriangarciacasado42@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Adri=C3=A1n=20Garc=C3=ADa=20Casado?= <adriangarciacasado42@gmail.com>
Subject: [PATCH] btrfs: add __printf and __cold attributes to do_abort_log_replay()
Date: Tue, 20 Oct 2026 21:46:59 +0200
Message-Id: <20261020194659.246816-1-adriangarciacasado42@gmail.com>
X-Mailer: git-send-email 2.39.5
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

do_abort_log_replay() formats its variadic arguments via struct va_format
and %pV, and is only called in error paths when aborting log replay via
the btrfs_abort_log_replay() macro.

Because %pV hides the format string from the compiler, GCC does not warn
about the missing format attribute under -Wsuggest-attribute=format, and
callers do not get compile-time format string validation.

Add the __printf(5, 6) and __cold attributes to do_abort_log_replay(),
matching __btrfs_handle_fs_error() and __btrfs_panic().

Signed-off-by: Adrián García Casado <adriangarciacasado42@gmail.com>
---
 fs/btrfs/tree-log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a00094604e..5ecc585061 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -158,6 +158,7 @@ struct walk_control {
 	struct btrfs_path *subvol_path;
 };
 
+__printf(5, 6) __cold
 static void do_abort_log_replay(struct walk_control *wc, const char *function,
 				unsigned int line, int error, const char *fmt, ...)
 {
-- 
2.39.5

