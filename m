Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135388;
	b=mgLKOadzyaEW527dekDLTNDZ0xh4704+lKDM9bP+Xb3EZUMviGQ/lkjtD7a2KZYewMZ4
	 ZekPi4RdyLtSTP0vWQPYyzysAGGX1bg4nh/J/IXUOrQxn/fgYz7kINPmnusT4vp8QI6SY
	 excSCVQPP7B0h6o3GmcE4MDIWFQ+treL2VCZAUAPoTXMc+UziwXCM5eQr1xWk4fB34lQq
	 uv4S36CaKVJ7aFBgw9d+eg0ZDPpcEi1IC5uzvbWRT2TauajsOVjcZwbqQzRCDkgoT7AAx
	 i1qeK2xnuAgmpNwgzGeEHWLTouninzUXsWk2htJqn1sMX3fXCiHZXq1a+l06iB76ExQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135388;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=VCEcm4cS+10pCnJSMFad8ba5TMU2TuUeL3FkRRgF6q8=;
	b=J05r4NubujcG6OkdEGLiD4k3LaFANmha2HvJfrx64NL4EsvMIoQ+zi5qilWMEjbip9mm
	 i5ESXATpa1B83QaFxmwVYETYTUL0i6rDfDmD/AdrpgOvErczoqoeboPnOgpx0rC+nMmd4
	 mzFY+PmHtV8SBZcz1xIj9r5XG9Tjk+lNY9uNkfT50ZuMXeuxaWjlbZQ9q/skHiHjySUCT
	 +Ur0ksDM57tFQ0XpEztA/VWyF8WTClySptKZJNozYMec/6eM5AW1Dc1QUKOVY/BVZo6UP
	 wT5mhkGe/5I7rqTtsjNYBi6incwprfjUabLK+Kxlf4meZXSQIT2Q63YvIKLY1u8krIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=FQHSQ1Xj;
	arc=none smtp.remote-ip=209.85.219.46
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B3E606A320
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81B3E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=FQHSQ1Xj
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91c76540d0bso3999976d6.0
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135386; x=1793740186; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VCEcm4cS+10pCnJSMFad8ba5TMU2TuUeL3FkRRgF6q8=;
        b=FQHSQ1Xjob3WHhUaX3x82quOmbvHijcNo87LcLe3hU66UzYG7bmQwI85uzpWaWJupm
         KykqsDzMCN6X2n23+/flDGS6Gspdiaa5tT+DP+M0411w7Eendt5bGh5d1Z3u8wgc0VW4
         NnO1tcD7gy9x94obfitEPTCsxXkZWuxozR1KbYqMaiO++B8nwmaqeBZkDthLx5WJmtAe
         5F49sYgLIG9zMONMcysfC6D9lMML1dymiQwjT7EVKAjPgB+nHNpESM8ljHUNbr2h3Cp5
         +w5xWRdb0LP5CXtBDP5U2nb+mIXEzN5tPXWQhnELmIZ2JM11s+TUoSzPlfWzOtvusXjo
         fcWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135386; x=1793740186;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VCEcm4cS+10pCnJSMFad8ba5TMU2TuUeL3FkRRgF6q8=;
        b=KtFBjZZDlhe4+rpeiyV5JWN0qlO+sKGNkKNWbIWA66JwqB+6YSlE9hysKQWoltKyRU
         ffgn461n6ml9K8qj7wOUzt2SsdTufee/e2PnNM7+D8luvoZCVAlmRUL/Dz4ytT2pyF5S
         9ls96VYIKrtKDJo4K9mH+ToZxBzucyK4OHP/4ew6F2b+Jhc6m43hykaPnN+DE9vCRXVn
         zUUjb01rQ2QB9KODTMOajWSTidalRbHRTc8tmJnVDvTKTCLVVWoHjqMe0Iqjl6yiqJPn
         G+eAHJDPh33MqC0y+j8Oxs4l60YI4ln3K3X/w0C7PGFQXU9C/so/+shmplKKy0GrfAYl
         yVog==
X-Forwarded-Encrypted: i=1; AKwUvByMAgYLpM9djv4foPz4ePmwh+XSgonvmFTy2WGaStdlOVbmKVmLWpfXZeaJVlWZ674asagLvWuabNPKMA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIib+qAm2CNbYXgwGPdVrFqk1xWrpr8XX/rfpn2ZF1EMnuSvXSG
	9PgqfhgmZFVrKxW/id3voFAJ2u7QRWzepSsxixt0uyZFqcHIQZhVEni7Gb6gj98ALzs=
X-Gm-Gg: AYBFou17zwDkeytFcq+IJVPkV9tMInPCC54eE1EwNKrM5l1lnvLzQUBoE9HNALGrnim
	gzV5FkuKYiiG9yEh6ssaKO51TrXTYWawPgXLBMSwYPapP0G6xnNFlChv6oLIQhmEJXeixkJ+D4u
	cBMo7jK3NaPXVw6vUSqJ8wr7XFP4vs7N0mXQkcxtc2Nc8jw10TYBnrpyEvSKkKtcLv3rmcobQHP
	9azqka6kO6HQQLpg99PHuG5fE8U0Qf4gq9kUvDmiZTkumgjcYr+HO5IJmgrJZfcldupUhIGER7e
	XHnX0UDbto07uX0DiExCROGZe/LjG+1lezq9wBWYO8PL0Ddilfqa0xyOFrmN1OZWFUHCboI3k1F
	UnWsCvY5vpWlWuIrnxKdC6TkV6u3Zbm5Y2Acn2P2Jcgd0jfHPMLB7S7PWUMI33005fmmVfSbfLe
	j5sd/iOkJ5fdlY/8zDX7fJ3u3V2luKfIPnO7Px+5hI2JcipxXP1h/n9GmiGYy8gpBC1dQMwAPdC
	bo+i8LEtUO48Pf7niLmHa9HnbS8ulWlLNse1Q1T35tXgj4BzZzhQW7VXZ9prTSrTOjyKnj6FOiQ
	qOTxJxuVqdvNOzEHqQ==
X-Received: by 2002:a05:620a:2807:b0:939:7683:33d5 with SMTP id af79cd13be357-94408a695a5mr30368085a.19.1793135386512;
        Tue, 27 Oct 2026 14:09:46 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.247])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f067e97csm1085505285a.21.2026.10.27.14.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:45 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:27 +0000
Subject: [PATCH 01/10] fs: add SB_I_OVL_USE_SYNC_FS
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=1928;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=BvxK3YOpk7h16bCpQ/+zltv4OfgiS86cLIhuZg2ctrA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QKlMexL787FCcvVxNerffS9t+F2LVb25W0OH2+5Jl6mnH6Q2yBl3k0xGc5yZMJyQWizXzvDekUq
 dgRiGoxsUwgQ=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

sync_filesystem() writes every dirty inode of a filesystem and then calls
->sync_fs().  The data needs that.  Whether the metadata does depends on
the filesystem.  ext2 copies an inode to its buffer in ->write_inode() and
nowhere else.  A filesystem which logs its metadata has recorded the
change when it was made, and ->sync_fs() commits the log.

overlayfs wants to sync what was changed through one overlay instead of
the whole upper filesystem.  It knows which inodes it wrote data to.  It
has a much harder time with all the inodes which the upper filesystem
dirtied on its behalf, many of which it has no inode of its own for:
whiteouts, index entries, work directories, the parents of all of them.
With a filesystem which logs its metadata it doesn't have to know.

Add SB_I_OVL_USE_SYNC_FS, by which a filesystem says that ->sync_fs() with
wait set makes every change of metadata durable which was made before the
call, whether ->write_inode() was called for the inode or not.  Timestamps
which lazytime holds back are not covered by that.  As an upper filesystem
of overlayfs it then gets ->sync_fs() instead of sync_filesystem().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 include/linux/fs/super_types.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index 72f4288e16c5..370b0d27815b 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -359,5 +359,6 @@ struct super_block {
 #define SB_I_NOIDMAP	0x00002000	/* No idmapped mounts on this superblock */
 #define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this superblock */
 #define SB_I_NO_DATA_INTEGRITY	0x00008000 /* fs cannot guarantee data persistence on sync */
+#define SB_I_OVL_USE_SYNC_FS	0x00010000 /* overlayfs: ->sync_fs() commits all metadata */
 
 #endif /* _LINUX_FS_SUPER_TYPES_H */

-- 
2.55.0

