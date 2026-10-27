Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135403;
	b=emyu8UHdSKJlcTsGgwcondHq1HjGpClrkuFFUtwgcsCC2wqrVH8pb9uWbvCWlef+nmeW
	 ph5SI1TVwm9Fg2gvW5ldZITVbDtba+qsPWDSfvCOrCb2/NKD7rlJ5WganNis5NRuMWebf
	 Cb7nNn4ajlGzIiQyXOLPiVFcp/pjbxsyW/TdO5W6DV7tyx4HN4rWC0i6ZVcgmVWzECsH6
	 ZSfd1BVO/Ichd+cwiGBqt1Uw26FyTLxz7lb4a+3X87nCBEnbxI2uq6OlrLJMkqMWbICeE
	 v1uekX/TkjVxrqy4bxJ16xUUZ+GpR72G6/JsJzaKcol3PTXcxru498T5elB6WVIqcKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135403;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=k4HHmOZ6mNUHOL8ZbOmgmPLSMmblgWC/9NXQl1ZSrSc=;
	b=USy2jYiKATs7g65lBUKxEXbYy33pm5enFrtEM5+XqC0c9BYNLsL70ayrRiwIsRHiPsrz
	 iqClrI8ObjJqdrMUKsAPFy0/CTfxbRUnswa/C53bVAMqEd2xsvv5fLgSMSBUCvtcjfrNR
	 zexFWCe8Mu11EsCCf5av5Q/4KF4nPAvHDuGDztvpqc5RAM76a139PKXiTvoFwfbnh7Yjx
	 XfbzuSIEy+GpDVPAt9MYGxSTyRzRBE4CayixahO7+1np0KhGvnMjhssWe8LiGfzN/GebC
	 9ne/hbxPwR+hyHUuVexw+rjrp/5a2P3St7J2m9rGQsGTA4GHMX1Cbmfuj4x8xcW75Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=oQteWviM;
	arc=none smtp.remote-ip=209.85.222.179
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6071460A262A
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 21:10:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6071460A262A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=oQteWviM
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93f3c89594cso15035885a.2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 14:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135401; x=1793740201; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k4HHmOZ6mNUHOL8ZbOmgmPLSMmblgWC/9NXQl1ZSrSc=;
        b=oQteWviMGtV0KhdbB9TFVFlDBQVv9It7ZHakoCb+sBNz9tYjUY+RB///aEQCM6ZCN4
         dEypVWGl1FrU4k2TgVCz9QhyMP1osFxD+7LXrAYOhMiZVMyvww3gg3J0ZUAhP6hNR8E5
         v1XNYSLPVNkzCB+apvOhv+vy63ozDJj6IjDasPg4Y1n25rYqmU6M2ObYrsvYWqV4Lq28
         74HTt+yjTHhG2tkLJEjJATE7m+wpCNcqWedXG/7yjC2irZHJMzE020Lb5UtMnbgdTcfg
         C2MpUOUECjdcGLWik340InwKukltaPPeTyXbC1cFz0ay/LeYBg3fbONqKzmEixVHgi3A
         4haw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135401; x=1793740201;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k4HHmOZ6mNUHOL8ZbOmgmPLSMmblgWC/9NXQl1ZSrSc=;
        b=xMZ1atdN5REW696h8hRMx/LITHKCJlgSslmpHX0JwBQd3pGGIuztWDN2iv8dGDXSUg
         5csNMDJORqipdpLf6e3/H19AHfhNUmsqr6sfUrnSYpy7rezWqcIecB2nR1YI7I/4lTLr
         ofGw1RndhyS1Sk3Ye7RHzdvjJ+JZblfAIWp6Jz4Kt0ueDU9j89Pil2Yu/Uoy6nzNJwQy
         Y+9z3YUAXDjuDkWdWASRZZKPTL1biA7KlOB2HDVHuKLC0KK8+Vs1/4yYl14SfdzAA1MN
         /hgGylCYc/nePjm1Xxq1f9JS855UKDdLu10D5sZndupBU8MZpjzLk7B6imtbwVukTjib
         R5VA==
X-Forwarded-Encrypted: i=1; AKwUvBwLNI7ftC3pEtRbjr0xjEfeEhDMtHOEXBBsp4dxU5sAmQo3n053b5tCS+XKYZ6ZMwa0X1OML/7uUppEnQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJsgmFmrwmSCByF22AwASLGwiro05dX0gl1ylxSpJQ/wELKE18j
	nodu7WSdQaNgfHnj1hC4jPQG/YB1w5JRWl6iZ2JqWqcjcUDqrio2LX9nB6oLTTbFDkc=
X-Gm-Gg: AYBFou3RkMwAkilsefOZkoYgHE/qPgX7sUwE7QoEUo0KjuIx8S78nk+tkzzT9znrIWm
	hujHcXnBBNtErowTvvoFGzYhPgNXSL9Yl2TC8S+uM2omYReD2Q+z8lOaJshrKTNAj8a9XPTTpHJ
	XhH+k4c4fFlP/iTWZ9zdzyU4iJkdHXiy38rEC+fSwFnuFqfwMf4tNKw2qpkFGLtmOVGLf6S585a
	kkqhJW/7ZITD/dIRsgzyxD0twARfBLwBcshVE7CJmAsGGI1Yr2F/nSq3BoJ0c00FWl4yH6tTaGd
	/bW0oEfUofgXa68ITcXNLCXwbWoGC3HxdXL5nhbasfcqYOUAe/Os91/GAwl2HXvXXkxq9ktIXSB
	YkifsfdWc/cdncgzroauITqixI50HoFV2c5NCwyJLhXm0Bgqhr8tfxigIJSBjZNqm1G+LWHtb9g
	fHIVsxQiJKy/eoHIb0ZLlo8Xrp7J1GM9H/+fcLnUTDCb93sdBrz8FjCGJbwmQuig2QXR+Wbas+b
	GGywTVegCYN0/Axdlb6H+A+8qDPM2h5Txq09k88DPc5b91mk36FSg4CFCGKXrFcQJIBkDH4
X-Received: by 2002:a05:620a:448a:b0:93f:57c5:3e38 with SMTP id af79cd13be357-94408ca85d4mr27973985a.65.1793135401459;
        Tue, 27 Oct 2026 14:10:01 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f05b1adbsm1074267285a.4.2026.10.27.14.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:10:00 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:36 +0000
Subject: [PATCH 10/10] ovl: implement containerized syncfs for overlayfs
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-10-802e512379a6@toxicpanda.com>
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
 linux-kernel@vger.kernel.org, Chengguang Xu <charliecgxu@tencent.com>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=3432;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=tPzhN58YiIrLhBjuyTwIEUWLvPBIcRV5B2AthoXKXO0=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QAkzMgrx3qGFlvfLs1kYuCrwYhdEXRCkcL/cclwqAObhjnVDqzxeVhWp/xnHvuj4/UNr14KUhUL
 P1GRlEWu2Og8=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <charliecgxu@tencent.com>

syncfs(2) on an overlay and unmounting one call sync_filesystem() on the
upper filesystem, which writes every dirty inode there is on it, whoever
dirtied it.  When many containers share an upper filesystem, stopping one
of them writes out the dirty data of all the others.  That can take a very
long time, and s_umount of the upper filesystem is held shared all the
while, so one remount or freeze of it which queues up behind that stops
everybody.

Now overlayfs can only sync own dirty inodes during syncfs, so remove
unnecessary sync_filesystem() on upper file system.  What remains is to
have the upper filesystem commit its metadata, with ->sync_fs(), and to
write its block device as sync_filesystem() does.

That is for an upper filesystem with SB_I_OVL_USE_SYNC_FS.  With any other
one nothing changes.

Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
[josef: no wait_sb_inodes() on the upper filesystem, which waits for
 everybody's writeback: an overlay inode stays dirty until its own is done.
 Only with SB_I_OVL_USE_SYNC_FS.  Use sync_blockdev().  Return the error of
 ->sync_fs().  Nothing if the upper filesystem is read-only.  More in the
 commit message]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/super.c | 44 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 631f68a97980..c570bf7103f8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/exportfs.h>
+#include <linux/blkdev.h>
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
 #include <linux/file.h>
@@ -269,18 +270,45 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
 	/*
 	 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
 	 * All the super blocks will be iterated, including upper_sb.
-	 *
-	 * If this is a syncfs(2) call, then we do need to call
-	 * sync_filesystem() on upper_sb, but enough if we do it when being
-	 * called with wait == 1.
 	 */
-	if (!wait)
-		return 0;
-
 	upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
 
+	if (!ovl_tracks_dirty(ofs)) {
+		/*
+		 * If this is a syncfs(2) call, then we do need to call
+		 * sync_filesystem() on upper_sb, but enough if we do it when
+		 * being called with wait == 1.
+		 */
+		if (!wait)
+			return 0;
+
+		down_read(&upper_sb->s_umount);
+		ret = sync_filesystem(upper_sb);
+		up_read(&upper_sb->s_umount);
+
+		return ret;
+	}
+
+	/*
+	 * For syncfs(2) and for unmount, sync_filesystem() has written the
+	 * dirty inodes of this overlay by now, see ovl_write_inode().  What is
+	 * left is for the upper filesystem to commit its metadata.  The dirty
+	 * inodes of everybody else on the upper filesystem are none of our
+	 * business.
+	 */
 	down_read(&upper_sb->s_umount);
-	ret = sync_filesystem(upper_sb);
+	/* As in sync_filesystem(): ->sync_fs() doesn't expect to be called then */
+	ret = 0;
+	if (sb_rdonly(upper_sb))
+		goto out;
+
+	if (upper_sb->s_op->sync_fs)
+		ret = upper_sb->s_op->sync_fs(upper_sb, wait);
+	if (!ret && wait)
+		ret = sync_blockdev(upper_sb->s_bdev);
+	else if (!ret)
+		ret = sync_blockdev_nowait(upper_sb->s_bdev);
+out:
 	up_read(&upper_sb->s_umount);
 
 	return ret;

-- 
2.55.0

