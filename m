Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74030470128
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 10:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787307176; cv=none; b=b4BNZDxsyDnSZuIRX3A8ZJ93od3GQYgF5lZCPsRIderPeTn0hkmlS3L2OGtWruFmZm3ObsCs1XDbu8cnbKQV1vQ7MEv/bOsmxKPFLc6zxCoCQUg7EMvfMX7+TfQS4k71pz6+/z2ljsuctMUo1TmxeP3Gezap6AsegiFmFQFR8Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787307176; c=relaxed/simple;
	bh=cYK+IB2CDinbUDshqWPztdlBLJBSd0dbzkA0WCJqfaM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=kGjy+ktFEmXxbslwArABoRzmz4OOsi0TR2tm+qzFf8GLE/gp9L3NF+C59t5HTk21uhHqj1hB6pbhPZEp4LzeRMJMgogNbpfofQx33lAt34rzgAXUWC0ibfdKiT5nPLeVxlxGO7JEjXCO2FQVjsUFs+ecbgdm3qclz3091MDBjAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HPLc6UDh; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=U5p75gJM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HPLc6UDh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="U5p75gJM"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5D8183F33
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 10:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787307154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0fXH8gsN6BGksftmD8hTFargw0INUHzhCBqAjK18MdM=;
	b=HPLc6UDhp+mqhCFArwXQV06mjjQG9OlQgKrmToKoO1xJqT5w+ZW322J5NfdWIoI7Nuh96+
	i0FqIz/18OS5PI4aFbpAeF5WOnuh0xYGjnHI0VOfljEMZIGjWpxh1ODv+wjMQd5UZQiIKx
	xVa7KJAc49uWOtWRRD6D5xuyjQkCOGo=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=U5p75gJM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787307150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0fXH8gsN6BGksftmD8hTFargw0INUHzhCBqAjK18MdM=;
	b=U5p75gJMobdhyjmz7KwHMGe5pmwGSkLFrbemGQTisqbQI0nEA60svG2pHXCKgwcgvW9iWK
	PEpbpLNkzn6voC5IqjA5VeiPARwu8h3f0UT5O1vUkHo2g6WJl8u3C9CwEChlE8UR0ZYc/7
	cgBqx/SJwlUTh31MPh+vj/aJT/QJfDA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C43826F8
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 10:12:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tkXkOYwkiGq1VAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 10:12:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove runtime tweakable feature sysfs interface
Date: Fri, 21 Aug 2026 19:42:10 +0930
Message-ID: <8a598d76555b5944d34bb08fa8dbeea28fc05db9.1787307129.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 5D8183F33
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

There are 2 features that are marked runtime tweakable inside
/sys/fs/btrfs/features/

- acl
  Which is a mount option, and it will not show up in
  /sys/fs/btrfs/<fsid>/features/ directory anyway.

- extended_iref
  This feature can only be enabled, but not disabled at runtime.
  Furthermore it's already the default behavior since 3.12.

  So it means this feature is always enabled and cannot be disabled for
  modern btrfs.

So there is no need to maintain the ability to modify btrfs' runtime
features through sysfs.

And furthermore, the existing btrfs_feature_attr_store() is race-prone,
it relies on fs_info->transaction_kthread, but our sysfs interfaces are
enabled before transaction_kthread.

Meaning at mount time a sysfs write can trigger NULL pointer dereference
if the transaction_kthread is not yet initialized.
The opposite is also possible during unmount.

Thankfully that race is not possible in the real world, as the only
supported feature is already enabled.

But it also means we do not really need to keep the race-prone
infrastructure, so just remove it completely, and make the per-module
and per-mount features files to be completely read-only.

Even with the sysfs tweakable features removed, we can still enable
extended_iref feature through ioctl.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/sysfs.c | 121 ++---------------------------------------------
 1 file changed, 4 insertions(+), 117 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 39cb01ee441a..1f78bb1cf813 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -83,8 +83,7 @@ struct raid_kobject {
 #define BTRFS_FEAT_ATTR(_name, _feature_set, _feature_prefix, _feature_bit)  \
 static struct btrfs_feature_attr btrfs_attr_features_##_name = {	     \
 	.kobj_attr = __INIT_KOBJ_ATTR(_name, S_IRUGO,			     \
-				      btrfs_feature_attr_show,		     \
-				      btrfs_feature_attr_store),	     \
+				      btrfs_feature_attr_show, NULL),	     \
 	.feature_set	= _feature_set,					     \
 	.feature_bit	= _feature_prefix ##_## _feature_bit,		     \
 }
@@ -130,132 +129,22 @@ static u64 get_features(struct btrfs_fs_info *fs_info,
 		return btrfs_super_incompat_flags(disk_super);
 }
 
-static void set_features(struct btrfs_fs_info *fs_info,
-			 enum btrfs_feature_set set, u64 features)
-{
-	struct btrfs_super_block *disk_super = fs_info->super_copy;
-	if (set == FEAT_COMPAT)
-		btrfs_set_super_compat_flags(disk_super, features);
-	else if (set == FEAT_COMPAT_RO)
-		btrfs_set_super_compat_ro_flags(disk_super, features);
-	else
-		btrfs_set_super_incompat_flags(disk_super, features);
-}
-
-static int can_modify_feature(struct btrfs_feature_attr *fa)
-{
-	int val = 0;
-	u64 set, clear;
-	switch (fa->feature_set) {
-	case FEAT_COMPAT:
-		set = BTRFS_FEATURE_COMPAT_SAFE_SET;
-		clear = BTRFS_FEATURE_COMPAT_SAFE_CLEAR;
-		break;
-	case FEAT_COMPAT_RO:
-		set = BTRFS_FEATURE_COMPAT_RO_SAFE_SET;
-		clear = BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR;
-		break;
-	case FEAT_INCOMPAT:
-		set = BTRFS_FEATURE_INCOMPAT_SAFE_SET;
-		clear = BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR;
-		break;
-	default:
-		btrfs_warn(NULL, "sysfs: unknown feature set %d", fa->feature_set);
-		return 0;
-	}
-
-	if (set & fa->feature_bit)
-		val |= 1;
-	if (clear & fa->feature_bit)
-		val |= 2;
-
-	return val;
-}
-
 static ssize_t btrfs_feature_attr_show(struct kobject *kobj,
 				       struct kobj_attribute *a, char *buf)
 {
 	int val = 0;
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 	struct btrfs_feature_attr *fa = to_btrfs_feature_attr(a);
+
 	if (fs_info) {
 		u64 features = get_features(fs_info, fa->feature_set);
 		if (features & fa->feature_bit)
 			val = 1;
-	} else
-		val = can_modify_feature(fa);
+	}
 
 	return sysfs_emit(buf, "%d\n", val);
 }
 
-static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
-					struct kobj_attribute *a,
-					const char *buf, size_t count)
-{
-	struct btrfs_fs_info *fs_info;
-	struct btrfs_feature_attr *fa = to_btrfs_feature_attr(a);
-	u64 features, set, clear;
-	unsigned long val;
-	int ret;
-
-	fs_info = to_fs_info(kobj);
-	if (!fs_info)
-		return -EPERM;
-
-	if (sb_rdonly(fs_info->sb))
-		return -EROFS;
-
-	ret = kstrtoul(skip_spaces(buf), 0, &val);
-	if (ret)
-		return ret;
-
-	if (fa->feature_set == FEAT_COMPAT) {
-		set = BTRFS_FEATURE_COMPAT_SAFE_SET;
-		clear = BTRFS_FEATURE_COMPAT_SAFE_CLEAR;
-	} else if (fa->feature_set == FEAT_COMPAT_RO) {
-		set = BTRFS_FEATURE_COMPAT_RO_SAFE_SET;
-		clear = BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR;
-	} else {
-		set = BTRFS_FEATURE_INCOMPAT_SAFE_SET;
-		clear = BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR;
-	}
-
-	features = get_features(fs_info, fa->feature_set);
-
-	/* Nothing to do */
-	if ((val && (features & fa->feature_bit)) ||
-	    (!val && !(features & fa->feature_bit)))
-		return count;
-
-	if ((val && !(set & fa->feature_bit)) ||
-	    (!val && !(clear & fa->feature_bit))) {
-		btrfs_info(fs_info,
-			"%sabling feature %s on mounted fs is not supported.",
-			val ? "En" : "Dis", fa->kobj_attr.attr.name);
-		return -EPERM;
-	}
-
-	btrfs_info(fs_info, "%s %s feature flag",
-		   val ? "Setting" : "Clearing", fa->kobj_attr.attr.name);
-
-	spin_lock(&fs_info->super_lock);
-	features = get_features(fs_info, fa->feature_set);
-	if (val)
-		features |= fa->feature_bit;
-	else
-		features &= ~fa->feature_bit;
-	set_features(fs_info, fa->feature_set, features);
-	spin_unlock(&fs_info->super_lock);
-
-	/*
-	 * We don't want to do full transaction commit from inside sysfs
-	 */
-	set_bit(BTRFS_FS_NEED_TRANS_COMMIT, &fs_info->flags);
-	wake_up_process(fs_info->transaction_kthread);
-
-	return count;
-}
-
 static umode_t btrfs_feature_visible(struct kobject *kobj,
 				     struct attribute *attr, int unused)
 {
@@ -269,9 +158,7 @@ static umode_t btrfs_feature_visible(struct kobject *kobj,
 		fa = attr_to_btrfs_feature_attr(attr);
 		features = get_features(fs_info, fa->feature_set);
 
-		if (can_modify_feature(fa))
-			mode |= S_IWUSR;
-		else if (!(features & fa->feature_bit))
+		if (!(features & fa->feature_bit))
 			mode = 0;
 	}
 
-- 
2.54.0

