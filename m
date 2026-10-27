Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135389;
	b=VaxV8ypYHdtkxHv9zYXRzAJUVOf7rzxv2U5cnPhGjce4L3OwPqDfdLYpBaKF3+XcdE/X
	 JeXoXtAuDC+cTPTVfAvAHr5VcY8Ny4SUBxrqBc9D6ZDn5vs9hQtWRIefoLuVkJK3wtTYV
	 3GBG5SFXUSxIyHue2z0ETLamzaKswuJ2PUf8poeTfDSAzu5WtR+zUxAzyXV3nT/CEabRc
	 S3SJNqJJ4ElZRpbegx5Jsm8cDT6JyqD9/9EhpKpnr9yUEOTX/L0KHgfy9OeqXZInePD+w
	 mn3d9TwcDI6ieI9daGyBVvzQgM26TUfIZGLotCJPlh+ORIxbHukxqQKdSSB2PqhtTWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135389;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=JKFrLSjwDHREmSvEFmSCml+HwjIVnw6Jy3aXf6F/H+Y=;
	b=VH+6oXeJyl7Al0QzlqR3A40WYCEkuMQPJ+CVd6cfIJVk/Jqj29Z4OmJ0Gi4IWgJXcNRl
	 W4Qdh4AFU2N2fz8OMex5Qy2/onuEM7B22zMCYuCd8RF9Q0f8H+7yqzlYJ3s6G3P5b3hbZ
	 r3QCzDSSlvDDOlZ2lpRFebEL2WFPd9DU7/0uHzA2T4VKq7jvmafznOhhPXkjyoBDGEwv4
	 yH5yKCllwO65Y4557Rhqy64E7pAumJWMoa9UhKOK+PsEamibECTj7lcbNBRryoBOn5P5W
	 8mJ1FdlDwZ7e2vwCpHa3o1bf75jGSWZtBYGsxAT63YVIcthwb2QqpmHp2SZnIOMAZbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=n6hOQTUU;
	arc=none smtp.remote-ip=209.85.219.52
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EE8606A323
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87EE8606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=n6hOQTUU
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91c5e31bea9so4550636d6.1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135388; x=1793740188; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JKFrLSjwDHREmSvEFmSCml+HwjIVnw6Jy3aXf6F/H+Y=;
        b=n6hOQTUUqngfoaAVe+wP7OipaQREpIZUTmr+9ABQ9A+RccYPbJ0xQON28EvRuyVBqt
         r9HM2iZE5cGg3PPNbG9WI93phORSXncFRdrjqv+ei/9HVJWZHrloHKm4dVwJcpKUsKIZ
         1pKz0CoBUEo0w1+Bv4ggVwqXdAraxzEKTXRBNPzZwya47RBli+DIhmUMFp4Ur5xfJGEB
         DVacZ4aD4hdYD/qdT08/V59jlYOFpWLjCJ5MJCxwT0+od31pmaugcsv9ZAAyt0DtpK6/
         FP7MKuzv8SSpxsigqar6AIaK6iqcvukWr6ltLO/guLJuuQgKnfFpDgSU6h1AfRjjYQvv
         B6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135388; x=1793740188;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JKFrLSjwDHREmSvEFmSCml+HwjIVnw6Jy3aXf6F/H+Y=;
        b=CBExKpC6IvuP35lBGisvri3fPLS/CRGPaEQ+qEkGBIeeM5g4M+EjNE1vrWcJpW1P7q
         GcFVAzEC9467PUjM/UDFeRpqZrFxlyyeVqhGzR4Xp/sytGlguQiPHsuR08iXJItwawHl
         T2YSDQjJefhnx+PF3hlmGB4N2Ohds9IFuPYRqYFa3e4wyZKcll3enNCbB7OVVLPlvZPv
         RXq2xxHt3ppyF4RO51xacl3DaEzdeg/91XlkTi9tpOc6yyVymWB24JJAQbtEHiY4FarF
         EIYDMH80bzzURCFw1Ah2S2DptcUvAHdsos/yQB+Ogw3YBj6uJDqhuOufIaWXvuUyFb9S
         z4pg==
X-Forwarded-Encrypted: i=1; AKwUvBwEaTLcxBmOLDsB4l6aLUDJfT0XoK/nefGp5kR0UtEoEMBXwkLFU1qWvB8DMG7CjmtoDxr4ApRugGLOlw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ6AqgZXcU5BZNHAqO4/QEUtB63Ov3xSfAPAmW+CQ+EOMWS6CEM
	VRbDohgoW6w+2aw2GAk47TaYfAwuVRFB9YrFvkrWplHpMu5XS8nozMG69b/fl9HodCE=
X-Gm-Gg: AYBFou1E3Ws5h793bC3c0mK33RcKxaSvFbUOXHhb6wPAgeQI7S5RgzWCi4OGE5PuB9s
	wkLSr0qoL9dEd+ZNWiJREVLoO4p3P9Gd6zGIBT4SUSZ6c8COQEZCq9Wa+7igw3BncC1eK3jVn2l
	7S2hsS7k8YWHFuRgaR+KKWBc2gQ8bm7IhHPFbp+d4r3hl3VhOGcNM8WEmKVU0mW/bR3k5VFVD5d
	RVQeCJtNkrIcSgTMhqgUULJ+ZBOO1BB59BCN9fHt1Mr9h5aZ+px4JsB2qNgHx+msao1N9SQucSP
	oOUV9zqfl2xsUw/nimUFBe011CCadwpL6SDkqKBUlPG+ms82ED1/QQDhU3IXzcnZxP4ydGUQP/a
	4NP4NvJK0jOA0wmFwZtPyNw4+qHE2FI9m6dHRUSZBTM26ImuLrnSWcwVPWJ1YQSlYutuVYBx7SB
	vGs6vrzl/jccA0SbiKVwPRnsalwbocxQuiJsSArQQV//ul3vWPLO4BMZYpfxUJE9aq1qyqIcJc8
	E8N2czD7P37PDHr1xwUUu40Ee6orrMBLPaWHmFWG6AjT3JqyVaWPlaNtExobrsAUfzD/5I8
X-Received: by 2002:a05:6214:8611:b0:91c:772d:fd7d with SMTP id 6a1803df08f44-91c7cf8f9b1mr5253166d6.26.1793135388396;
        Tue, 27 Oct 2026 14:09:48 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c8c2b3sm113364796d6.31.2026.10.27.14.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:47 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:28 +0000
Subject: [PATCH 02/10] ext4: set SB_I_OVL_USE_SYNC_FS if there is a journal
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-2-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=855;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=aO8AZhSXBs2aP15NSjU103SL3h8/eCNuFcd5jsKb2vQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QLYucfR36lRP85t2sKZ2ZLaJ9rWkQsjCap0MbdXMa/mnYx1Aa41Uw40CeY2ykt+WukwlWz8EyZD
 bupKVdGj8SQg=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

With a journal every change of metadata is part of a transaction, and
ext4_sync_fs() commits the running one.  ext4_write_inode() has nothing to
add to that, it only forces a commit as well.

Without a journal the flag stays clear.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ace06b4f9e3..037e274dca8a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5542,6 +5542,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		err = ext4_load_and_init_journal(sb, es, ctx);
 		if (err)
 			goto failed_mount3a;
+		sb->s_iflags |= SB_I_OVL_USE_SYNC_FS;
 		if (bdev_read_only(sb->s_bdev))
 		    needs_recovery = 0;
 	} else if (test_opt(sb, NOLOAD) && !sb_rdonly(sb) &&

-- 
2.55.0

