Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135398;
	b=IgLNKkJmrlyfH0V2czVecuCvT42HuxAKJU+/Q3P9caAY3n4aTyHURIVRumowgdjCaITO
	 zzrHHMXrKk76V3pjAnXxDFx2fWY7GDd32AzEP4Gr8tWMHq6+ngbokwINt7fNq3rJiqXyR
	 RwF6Byhehjlyu94qavLSLXzKUe1nD9rlYQlGMZ0ma05WMjnegMZpgcysuTXt3AvEhs2hq
	 h1Vj1aaEs3JvcwpoC/InPMjO9oUmcfG89AagHZCBTjv3USAH4DhqohHQ7wvSyxHRaYNIL
	 wnw1tTGvm3jVCGfCfZglBUu8Wh6ZYtg3YgGfXl0BfbpPWVpNxKO8ybBbdF1b4wVkMsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135398;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=Ck/ful92N6NXzDNP60KvQsR2JiXRucsXYdV/7/B7+xM=;
	b=FtAAX1dbiFmUpgivqmv2neGwQbe1QlvovIYEMSCu9Fj4x+cOmuDuumWtTwhEM4EI+AE4
	 H26JZMnJovMJG74phQ6QHsaSLW8mJoljBn00hXBfxUeCg91sCvg+PWvU0FSBxy4wyLWJo
	 5xn6hH7KWR4AJG8mkyjmgSSXukPLf5ckFU+n7GNvTqHnkTWGu0PHDhBrZ0EDOrXPRe6DT
	 NQqg9Hycp9jziTz5kdAZFM7dw+pp8aet4SuK8gv/urmKJrkB6I0p9jDXfVcHZlnPvkdt+
	 4wxojJ0OgsTiduYMj3tZ0vpS3DFJVhtGY0ekUIENb3sGchYwjXVh0MNfzkxK4c9irdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=cZlRNmIR;
	arc=none smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B568260A381A
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B568260A381A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=cZlRNmIR
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5364c951da4so3823601cf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135397; x=1793740197; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ck/ful92N6NXzDNP60KvQsR2JiXRucsXYdV/7/B7+xM=;
        b=cZlRNmIR6NxiLuSTk5H7t58NmoHxtt8buwWzXHDQYgXzaYZBtGWYF8BILLNiN/vitj
         /Ay8gEMGGZF6pPT2aogmsL7+z4PKstycGKkTnuGcrE0QimQ0AMJpggcLcKxYCnYxnuw+
         BxBGaleMVQgyAYjeUtXZ5m4kAzoGneBFExCLdLMNph842KUix7YhAfqG1ct7aeU1DwMh
         CwFY9FOoeTpRD9iYQqX7c+upezqtLqr0Ui5ht8qe3sGeB1ob4izFucUduE2QF2DaDp94
         2qZQqDUamnv0uaY/sqsTcm9CxRP6HeQWIkO4FZTI8TEsbgPmIMpVQR6cMXb4unK0U+OI
         Hi8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135397; x=1793740197;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ck/ful92N6NXzDNP60KvQsR2JiXRucsXYdV/7/B7+xM=;
        b=VAAKfQAm1/qttb5dJQhRloRnDIEaVq9LNiyX1WLlbvKh6P779ZoFltGlZh1F4R0Y0s
         VGMmP3ofCvGCBAu+7P6U5+Nh26kEm7aAUxNO+3hIbkxzVa5cJpxN+llcbuebAXD+pJDd
         /lUiu5aMw4C2bGmnmE2ViNcGmO+ensWUojYSeCjsNweVxMxFV80J50bRbSWhyUO6kHJR
         wH8CssVsRVuHd9oDTj5ytNt+n6iEgsu5ZsBnmBp6U3gpFNykXxqPoPpT+RQrhx5zACZg
         vuTrp7U1LDbP2ZD8zoh1/kQ1u86Agb0TUKFWPrXjlAM6SdjasYCTFeLwXPFD7/StDVSi
         UpbA==
X-Forwarded-Encrypted: i=1; AKwUvBwz+ivax7E/kvEg7vCeyLFUWMTkAOl5fTN9XEau94Caz4EMAvdjXWOOESXeWcIOQ/dmqsqcTqGDeA9HcA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJy6pahLholVzSbehJ8G1ZiIbSypKmHV0WtiEcyOVRaj3rOHWru
	4PZznN6eFGRC0h9AqdU2YSS89QOHky3M6rvN8fdlJ7yOzUNvhiyz8NI5DCaDesEERC0=
X-Gm-Gg: AYBFou2hG5E1Vgy29AtF+gJrmZ8BcWlQgKPTpMzIXwmnlqn/FhKGmk1UqBF7S0FMgnZ
	Uru1Gh11qfbw1gyAOlcP2uMY5XdLkp80QJQKOWza/PVhYnZgR9ueWSpjycPvP99L9MEqbAgTwGA
	8fTG4S6b/nwMucm+3v5rlP664Pl0ppExi6cuwZCZiaFFE8lWnpe7EtGJjHjKayPIYB3PsdfbCeE
	ZGYV7PeNAV6waas2yTfLFoTXD+42toFZmeUub9liWBeE2PVgjuUivxRtChgX0Ad+TnZOZn0nIsv
	IXpghxfGWrcPi3k/GC8t2oJC714Sr2iS3uFxoFinnp8b0YEDib8gyqUDOBsO2WqLrm5dWlZcKSi
	b1JZVvYo6quXW+Cj3OgRncY+4Oftw4LkgzplXO4aaWaCEXZDgdMW1UWXm4j6PM8snHTUDMfjwgK
	Xae3H8BKRDEyJcTjb7vQzQb5lJOpkNd8cOdH5wIS4xgYpViiiVkSqpQANMLccTC1GzTd0GALCSu
	aPeoeos4yEhQ/l/balgsVTmbLFQa2DRmw6alp0HBTk5Bkc5mNwFY38uWQHBAOycAmfyhzeh
X-Received: by 2002:a05:622a:5917:b0:536:3950:5d7d with SMTP id d75a77b69052e-53fcb20d4a0mr9425991cf.16.1793135396673;
        Tue, 27 Oct 2026 14:09:56 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.254])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c0ffd4sm113733436d6.16.2026.10.27.14.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:56 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:33 +0000
Subject: [PATCH 07/10] ovl: implement overlayfs' own ->write_inode
 operation
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-7-802e512379a6@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=3603;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=TzW1SCvICZ369myzzdV8AX2bLJ7uerYZSh8+JshacQA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QB+NR25IEkE2f0VZhWtwP5u6sLCjWEHN7x6AAsproO/3gSZZmPXZynAwUIROur1wPkzEoIAqopA
 LpfqCsruvyQg=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <charliecgxu@tencent.com>

Sync dirty data and meta of upper inode in overlayfs' ->write_inode().

The overlay inode stays dirty for as long as there may be more to do:
while the upper inode is open for writing, because stores through a shared
mapping go unnoticed and the mapping holds the file open, and while the
upper inode has pages which are dirty or under writeback, because a pass
which doesn't wait has only started them.  So by the time the overlay
inode is clean, the data which was written through it is on disk, and a
syncfs() which only looks at the dirty ones misses nothing.

Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
[josef: redirty only while the upper inode is unfinished instead of always,
 no check for volatile, nothing is marked dirty there]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/super.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d21e7cbb70c2..0aec7059e9da 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -15,6 +15,8 @@
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/exportfs.h>
+#include <linux/pagemap.h>
+#include <linux/writeback.h>
 #include <linux/file.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
@@ -313,12 +315,62 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return err;
 }
 
+/*
+ * Could there be anything left to write or to wait for on @upper?
+ *
+ * Whoever has it open for writing may have it mapped, and stores through a
+ * mapping go unnoticed.  The mapping holds the file open.
+ *
+ * Writeback which was only started, by us or by the flusher of the upper
+ * filesystem, shows in the page cache tags until it is done.  The dirty flags
+ * of the inode do not, they are cleared at the start.
+ *
+ * Metadata is not looked at.  The upper filesystem logs it, see
+ * ovl_tracks_dirty(), and ovl_sync_fs() has the log committed.
+ *
+ * Nothing orders these reads.  The one order which matters is to not see
+ * i_writecount at zero and miss the tag of a page which was dirtied through
+ * the mapping.  The tag is set when the mapping goes away at the latest, the
+ * count drops when the file is released after that, with the locks of
+ * unmapping and of the final fput in between.
+ */
+static bool ovl_upper_unfinished(struct inode *upper)
+{
+	struct address_space *mapping = upper->i_mapping;
+
+	return inode_is_open_for_write(upper) ||
+	       mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) ||
+	       mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
+	       (inode_state_read_once(upper) & I_SYNC);
+}
+
+static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	struct inode *upper = ovl_inode_upper(inode);
+	int ret;
+
+	if (!upper)
+		return 0;
+
+	/*
+	 * Go through writeback_single_inode(), I_SYNC is what serializes us
+	 * with the writeback of the upper filesystem.
+	 */
+	ret = write_inode_now(upper, wbc->sync_mode == WB_SYNC_ALL);
+
+	if (ovl_upper_unfinished(upper))
+		ovl_mark_inode_dirty(inode);
+
+	return ret;
+}
+
 static const struct super_operations ovl_super_operations = {
 	.alloc_inode	= ovl_alloc_inode,
 	.free_inode	= ovl_free_inode,
 	.destroy_inode	= ovl_destroy_inode,
 	.drop_inode	= inode_just_drop,
 	.put_super	= ovl_put_super,
+	.write_inode	= ovl_write_inode,
 	.sync_fs	= ovl_sync_fs,
 	.statfs		= ovl_statfs,
 	.show_options	= ovl_show_options,

-- 
2.55.0

