Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135399;
	b=WMd9jVyvCLzpr6kUzBayH1Fqnyhwx5YufU+LJRbkAV0O2tKSRGKa3PiXRuIsCJ1N2mBx
	 NMj0kgQGbFib+/qbYvIG8lNhen0fGo2I61DfNrHpFNHguVeA+N8Ffs8S+koQkIuyKqcO1
	 RU1hFJpx/mh3uXI+O5B2DuLRROk07rlCKMDj1rLBQ73oRaahpURUHliNDuIKrfrGaWNFp
	 HN+BtS4/jvLJi0hkFUlpPy7JI1cbrNhFZKzxEGCauQTh6N/nCnV0sbbjPGuXJgeuokJW4
	 tG5jeGmJrCydBFXvGT6O/NHdYpVLa0nQvbiwUyYMYHGcAmEnYv/04pO2Z5u4EJOORlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135399;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=ruUe/GT1VwTWup+0kZscWxZsaccg4YfsFi7B4zNopuY=;
	b=34tuzS/jY7Nx/ddG+RjNfHuLhIMGzuGIl4YvUfOEfjLYARs3f5PNibN81vVfre5wh0Qp
	 GHKu5X5BN7Aw807kOoujNxMupiE349rtQEjH5ne0bcbqx6Ndc13So5F6cfB0mN1mguF3q
	 0D0St72VNXDYa2ToA+GIJsInr1Gg0pWfraQGv9GsLt+XUOFA7HhzU6G6Jh0J4VqUJAcwV
	 Y/xZ3yh4iWuaFAQfdCAf6gneqgaDkQuAMxXdXc1rzKYBesqN9bhS6vRzUpcYPm0Lf+naI
	 Dsv43qP6owQg5eMZqfSUTruT+KiqQxSgtW5BDLlGD+xtBnesvN9zL0e04CdOATcI52w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=IoxGeVeq;
	arc=none smtp.remote-ip=209.85.222.180
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD99606A336
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CD99606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=IoxGeVeq
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93e7ad9f78dso25062285a.1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135393; x=1793740193; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ruUe/GT1VwTWup+0kZscWxZsaccg4YfsFi7B4zNopuY=;
        b=IoxGeVeqBEBSmQts5lMdLN8woJchkwrQhTP1FM2zkR5Bh4JuIjr+yhs2YhSDU+Yxte
         leNiRxv+InvWr5gIKFwVPV1oTR363VDuyxDNizD41Nmhr3xq7m0BtCMR17XzU0e+4UHP
         PMCXZ0jLEO6qZL2Qnhn/1Fl+r68uonRO98yVtZwC+9+Mg9bIXKyFezWADFHIXdlzYnt6
         Blo8+32PA3mGKclSfmd4hOL/mSq0X00aox9zpZ2kvzMTyo8T+j1X0+L0eVYSKqCCCxir
         z4G8AhSR4MbQ6tNODIg6xahVCXkyFVfAgsEZU3+WD6ZDWdWRvIiMMSY9Bb565Mnke5hG
         MaxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135393; x=1793740193;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ruUe/GT1VwTWup+0kZscWxZsaccg4YfsFi7B4zNopuY=;
        b=gTSU2OgE5OLflAN6DEbJr1AskI0xRRX/HwraG4MRmFWW+B+crU4oyG8bYwDwl3fP6M
         XYRPlesuBam1iScUPsPnTDTG4D2MSa3rSJ+I8hNci7mydD29E35clHkn/jraTweZlYom
         ksTvjOULn2tbWPZnMbb4B28mi0yb0rgWRvjo2z6MxHfKhMYO5gcgr4hWMu39sNRnHCXr
         sPWwzGWLzhLXi8z9Clf0UasC9qeQ+kzo1Az/E1YTty8sFKxR0Nl2CrtMNYhE9kgigRhO
         2JEb0CEhA+ftQZtiwuE+KwtO8Y+jiLo1jIRrTTskjdkef5FUGtvwGj1xcjouGiJADHgo
         5gJQ==
X-Forwarded-Encrypted: i=1; AKwUvBzXhOfbsCR6qwWSdNv+rMFXDiQ/E63ZpNPty2O/pMIJcc7GYkrRwllgovsJRlwvrzGtwQhfk24UvaweIw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJfsWQpKelCcKWxw7yftK81RIZp8hdvHZcGct6lmdgVrutBQiiY
	l3NrcYxQIkr2kIpfTJ/8ViweEjKGn3aZH31/KZVcA2DRf6+jnXUiTsTzK0hNnS1WTOg=
X-Gm-Gg: AYBFou0OWw+zFhIkQaq9Jgui71fDdg8e41EF2B9CsSDDwp1VakIuZKuDEEDSq85g7Sd
	y5tdu4yw24XiPgPlojzmqrXGlosbbUNSGxhgx9TmovyLLMmBFYieFj4uYe0ex8msop8M0GojgiM
	bf7pL3lveEo4BCoHk4I1W/I8VWRzVg8qPzQsLfiqlVDOhgMCMyeesPh+hZsRIm5+EruuZ1mE6F5
	xbjwU/Rsy2LVv34DRs4yTQn9MgYeCEK4a/oquENguEU4SdfE6VNvH9BL0k634yaBa6uphBo8LTb
	JxNcg23SpJc8WZFpPWDSEHJy//8l9DnTCZ3hzSSEFYnK4a4a9naJopGGTQ6IJyom2Kqxzxk56PC
	rdkiUIeCoEktO573HDSlsRDP9ws/tujAffWbAU4WTbN5pxoRnRwktso5BzHlUi+Cq3pHxPbFhV9
	88KqV/6T71rdgZRkn842X+SAYThJ3oe0qZRZ0xExqZpPg1KlLHDwxSmiBhqQRCWtKTbNuNY1ESZ
	HJBIGlVK3NqfTc/+sz7/P0AwWPtBJpXUCCWdSvS+npjAgeOg9vmfyKBMXe1pNgaJ6QiPOnt
X-Received: by 2002:a05:620a:4493:b0:93f:22f1:97bc with SMTP id af79cd13be357-94408de75c8mr18726285a.67.1793135393395;
        Tue, 27 Oct 2026 14:09:53 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f067f330sm1084514685a.24.2026.10.27.14.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:52 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:31 +0000
Subject: [PATCH 05/10] ovl: setup overlayfs' private bdi
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-5-802e512379a6@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=2034;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=lziNTGyBXCfixzwcVc9Cou0+3eIhaEcTmEq8NjswuHo=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QHLL2F6/3sZZIvVsxBFVSkIADBBqshg/4ymc2ZgQRMYc3B/GsdwvVOAx96LCUD50tTTuAHAhKGq
 EuZawjuR9KQs=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <charliecgxu@tencent.com>

Setup overlayfs' private bdi so that we can collect overlayfs' own dirty
inodes.

Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
[josef: only for an overlay which is going to have dirty inodes, rebased]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/overlayfs.h | 13 +++++++++++++
 fs/overlayfs/super.c     |  7 +++++++
 2 files changed, 20 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 92da556598da..218f646b82b9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -663,6 +663,19 @@ static inline bool ovl_should_sync(struct ovl_fs *ofs)
 	return ofs->config.fsync_mode != OVL_FSYNC_VOLATILE;
 }
 
+/*
+ * Does this overlay keep track of the upper inodes which are changed through
+ * it, to sync only those?  It knows where it wrote data.  It does not know of
+ * every inode which the upper filesystem dirtied on its behalf, so that has to
+ * be a filesystem where ->sync_fs() takes care of all metadata.  With any other
+ * one syncfs() and unmount sync the whole upper filesystem.
+ */
+static inline bool ovl_tracks_dirty(struct ovl_fs *ofs)
+{
+	return ovl_upper_mnt(ofs) && ovl_should_sync(ofs) &&
+	       (ovl_upper_mnt(ofs)->mnt_sb->s_iflags & SB_I_OVL_USE_SYNC_FS);
+}
+
 static inline bool ovl_should_sync_metadata(struct ovl_fs *ofs)
 {
 	return ofs->config.fsync_mode == OVL_FSYNC_STRICT;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 19b6d54c4500..d21e7cbb70c2 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1455,6 +1455,13 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 		if (err)
 			return err;
 
+		/* Dirty overlay inodes need a writeback list to be on */
+		if (ovl_tracks_dirty(ofs)) {
+			err = super_setup_bdi(sb);
+			if (err)
+				return err;
+		}
+
 		upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
 		if (!ovl_should_sync(ofs)) {
 			ofs->errseq = errseq_sample(&upper_sb->s_wb_err);

-- 
2.55.0

