Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135393;
	b=M/mOfDz/3DGNgImwHZWUyNVvZcHnXmwz/B4qYoeOxqR9VWtPAAqhuVHHfaTDsfwLFYMQ
	 7nNHXZbcvpMbPcVStLBYu9KVMM4MQ4rqzF21QFbIs9LVGdrhMhBiUmNLDiFW5zYjxO2X7
	 N4ojas4rxZ52KWclGgXG9tgihVcXPkoKgbiC2cds+blGmAUaMZKSvLgefYSkY7+csWFue
	 wLniGqqbO4VZePeycrRBwMZFELFo90lOmPNTqOEJNBUvGg/uJ0VasBgjuokhxrQDJwfIn
	 HU9ZFhxCDKK3ie9A5nBMadEmMQtdO2eWfW07NmQ/e+D5+e5dswWIQOnaYb5zzD4iV3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=HAhPDfSNI1m9jMsgOVCEGKYJnC7ZRumB7Co5M2j8QiA=;
	b=q5PCXgzmvSKi75eesfh+D/tXhndr50mW9rqQhfZK28O7z/KbJ7O1SmU092DyFiggg2Qg
	 SoZjBsiLf1SxiOPj7I/OqdH85I9F/FUlc80I7TMsHthmzZ/+WRXiu8LeZfXpKb6qIgL3J
	 zKY8CP83ImaQFQ7A2tgUHdn7KWyVDe++Pi1DKDKJU6iZ1e9bWd9RJaQXbBtvjhEnkmDxZ
	 7DHqn0hPCZ/N6kp8RFWlPFwyNJWGQMFRv5vK48IIqOhMgObVHgTCoiJyUfTxpVrdNU3RA
	 B8AWV8fTF5b3A0vQ75iByZvkbZfLbCs98P9WmUqeirsR1Ii3qjUKes4UUbtYj+mEwfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=hOU79HFU;
	arc=none smtp.remote-ip=209.85.160.169
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82F860A262D
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B82F860A262D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=hOU79HFU
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-53bb57f1310so4194081cf.2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135392; x=1793740192; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HAhPDfSNI1m9jMsgOVCEGKYJnC7ZRumB7Co5M2j8QiA=;
        b=hOU79HFUF5XVQIP1i0LutIU/umJRpfeIAGlIU85PQ+VvN8AhJ2xV/+Ckj7hUn0FiXT
         Vo7Bqt5A2O7gVi2FXZ7LR1GJBkC3682be/KrfbJUx3Oze79iZ02cF+nWdL8HAMH+TkA/
         RqJRdc529Hs/8A6MizbL1tlCPDHiaNo4rAfVeS4PCd+pYvNB8GiE3hhXUKHhQVK+xtN8
         JXcziCJ3xyZB8L1d8uSyg8o8tM/93MhtFnhO+nATDdlG/gpAAJwbl8XdWTjLI3geZAFt
         Fqe9NEA86+d0c+71frtm+HrDiotx5CzEsaAF6tQp+yTnBApEwLxl6fqpDPD3/OU7RekT
         j33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135392; x=1793740192;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HAhPDfSNI1m9jMsgOVCEGKYJnC7ZRumB7Co5M2j8QiA=;
        b=Oed4OtVzk+pN1EWJYv5ZQOQA+DoHKqB4VXu8+NKSHdHL8qhGycnqu5GhWCFZVx7ev0
         BRDgBbnHb1LMUyW2QlGrcA27Nvt06sAuYbSKMj22VcDyqv8AS/UGeOeHduqowTPzI1tp
         A09OrFy7pdmwfz4HwgHSdB6FFLXNVC34KhYKQhrG2SZRiOzeRkJo44eIYUl7yFultt3+
         zqDs9YXzr+Fjm+1n8YAxjEpXYKrfqlD2Q2Oim7DohJBik2PQgCax+nZEVNXMTepsaNUu
         bR8ouVdOSVBleq+6FRqumSrcMfMRJMW3iCdDO6+iffzyEQodEiMBneu9VRgRdF3JFgan
         9xLA==
X-Forwarded-Encrypted: i=1; AKwUvBwMWdqXLC5Sj+mTk3903AkF2llug3PY3VD8maQnxQsIbZiVBLgFoTHo/lh2n/pTVG2hLB+V7a2C6dO3+Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYKmvaeL8UIhrjAYcuQ38s7or+l5d4jHND7ZHCYl5/KTuCRbcgWx
	fGmm2fQmNIVphqbbJtSYwjawiYpvudCD8kl93+6ikj8OTOScI94m7baQ9IUM2hkwufY=
X-Gm-Gg: AYBFou1Ls6MgUgqLCvrmDHzP1UfYJu7r/uRnVgJr7JNTjGf1h706CioiXZrUPgFH9T4
	rAHL6JpiZbKDRgOZOIKgWI2ifPYBHb/PmnHOb+U8EJPsbGvzpVJJW1eWCN64O0aFBx6dGzPtoqz
	PoRR75QznptTblAcCDXOHS6PuyTujUGKygs5ASfeKfQbIKZ6P6Gn/xcn3FLEr1Ikakx7IRMtyl+
	90VQR49f8nIP11CUyc0wFfcHAmoDss38ScefNonHnUw4/m9ehJOblvF5qNqeUxZ/ver+gpPfz24
	827phjEOVdmm7dIfdWXHyf4cmhq2yLhRpAjmsmhReFo01M+Ly/LxFXq+rPHqTvYjej7EbAyIXcs
	F560x2/PPm6ym0lsEh1Rd6PMgl60NXuwA6StC1dAEVK1i7a69EgA/njeHn9qXEalk92FpFB2EhP
	goGk89SSERp9Zc3gbBAmLefhgkQFDbR1WmeW5BecVjFb5Lfo19B4OItqnUeRB0DMiVWDmCYzJvN
	MhGi0+02oZow0wF6DOGNFsAtoXddYRUvSOaFhwH6F15QcLDGG4m1lPOSxDjzp8j7Nr5mSz+hmUi
	LtTtUGUaJGREqm4X/A==
X-Received: by 2002:a05:622a:8887:b0:535:92a6:22f2 with SMTP id d75a77b69052e-53fcb20dfd5mr9618051cf.15.1793135391683;
        Tue, 27 Oct 2026 14:09:51 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-538394c565esm88811961cf.6.2026.10.27.14.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:51 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:30 +0000
Subject: [PATCH 04/10] btrfs: set SB_I_OVL_USE_SYNC_FS
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-4-802e512379a6@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=741;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=KS+Jdp4IcUSZ6tCav8kl7acTQpMUNvtXOKDv7b4wQHs=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJlIHMWE4mD9Fg4D+/nCw/fqbncWcTX25kEPMy8XebnWW9mJFVsO6uNMHNrIavR2Gh6YLS/9QxQ
 cP8BX8zQgBQ0=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

Metadata is changed in a transaction, and btrfs_sync_fs() waits for the
ordered extents and commits it.  There is no ->write_inode().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7fabb775d4e3..cdecf90bdae0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -981,7 +981,7 @@ static int btrfs_fill_super(struct super_block *sb,
 #endif
 	sb->s_xattr = btrfs_xattr_handlers;
 	sb->s_time_gran = 1;
-	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM;
+	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM | SB_I_OVL_USE_SYNC_FS;
 
 	ret = super_setup_bdi(sb);
 	if (ret) {

-- 
2.55.0

