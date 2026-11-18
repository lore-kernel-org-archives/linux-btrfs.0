Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036111;
	b=huudWTbRsEb/y/fBVUuri7RoP6LUy/v+TD6pV5+jSJNdf2axvk9lt+gmuwObr/l0sIH4
	 t/DV8vDb45mTHVXRRZ4Jk41IQfUuG+0I9NsEH/vh3qrvSalrndxlWzpRk0iOANN0K39J/
	 Z7HU7+y/VyTxfJVqj4Bmt+dXt5bYGRdAhgBCcgk/JZC5V79WO6lqGpLpGCr95HBATUAOj
	 tY7Y4cOWa5BJh0UhXZSbxc+uRmEfIxONGI6lv8qw/+LJmzy5ikph1qRtIGRggPFZZ64Um
	 p4YwjSkVB0peWIpp/ahggUoLX1Wt606Q85IXxGHJcInMofU5m0kQaacQIJxJrMkPurg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036111;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=IxRf8gngda2ZNleJl46HJ+XD969otm+sHIQD8z3zBWY=;
	b=JYKUPdLCAHgFYLRrm1Gg9SsXsYJJjueQyI4KbOHWsnOc8q4YDopt/lnrxDhyXtUlb/nT
	 AFW99liXlbe0+08p+cBikVJOGcee3KSQx4EcGDFLV57vDvFUVe+5tVtS3sYuSMsrZOizF
	 GjndP8mwHjJs6pMMxcP2MHjtedTAi23PsnKdlQTxRfY9YzutuqpERPOmGvCJOrYo0TEOv
	 qq3SIsVN2sT5qoQHu7rzDgaPru/dbcgttkypFmh375JldjZx0rFdIKpyyt2ed2zRBZqL6
	 GsjNUkUzZ++b+eA4/m0E5fZSXKeZECaarwUi58njZaWBjd4y2Gg6fmeKgZJp9z6AWUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=U1zL6Qfh;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=U1zL6Qfh;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06373606A334
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 21:08:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06373606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=U1zL6Qfh;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=U1zL6Qfh
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4C7371FC86;
	Wed, 18 Nov 2026 21:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795036108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IxRf8gngda2ZNleJl46HJ+XD969otm+sHIQD8z3zBWY=;
	b=U1zL6Qfh8RZVf9tA4jtEGr0GPOwyvE2IEVITejlW141YI+b+kp8iwK+Te1DCwNFVPP5g59
	REoyBKTQvRKj/yIOd3jhngorwpSuD5Vf3sCwTdmn4/p+nLgjKYOehyq3AyG7qLunJ+nViz
	BzU3tqF4g5H9cVVH6NZi8UCl8lxS+nM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795036108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IxRf8gngda2ZNleJl46HJ+XD969otm+sHIQD8z3zBWY=;
	b=U1zL6Qfh8RZVf9tA4jtEGr0GPOwyvE2IEVITejlW141YI+b+kp8iwK+Te1DCwNFVPP5g59
	REoyBKTQvRKj/yIOd3jhngorwpSuD5Vf3sCwTdmn4/p+nLgjKYOehyq3AyG7qLunJ+nViz
	BzU3tqF4g5H9cVVH6NZi8UCl8lxS+nM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D59641334C;
	Wed, 18 Nov 2026 21:08:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I+tDDMoT/mrfXgAAD6G6ig
	(envelope-from <wqu@suse.com>); Wed, 18 Nov 2026 21:08:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Zheng Zheng <fengaojigui88@gmail.com>
Subject: [PATCH] btrfs: handle kobject_init_and_add() failure correctly
Date: Thu, 19 Nov 2026 07:38:08 +1030
Message-ID: <a33cb143fe0af0cb689c69b949d954fa151f47cd.1795036063.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -11.80

There is a bug report that if error is injected into
kobject_init_and_add(), later error handling at
btrfs_sysfs_del_qgroups() will trigger a warning during
kobject_del(fs_info->qgroups_kobj).

The call trace looks like this:

  btrfs_sysfs_add_qgroups()
  |-kobject_init_and_add()
  | \-kobject_add_varg()
  |   \-kobject_add_internal()
  |     \-create_dir()
  |       \-sysfs_create_dir_ns()
  |         Fails with -ENOMEM with error injection
  |         kobj->sd stays NULL
  |
  \-out: btrfs_sysfs_del_qgroups()
    \-kobject_del()
      \-__kobject_del()
        \-sysfs_remove_groups()
          \-sysfs_remove_group()
	    |-kn = parent
	    | Which is kobj->sd, and it's still NULL
	    |
            \-remove_files(kn, ..)
              \-kernfs_remove_by_name_ns(parent, ...)
	        Trigger the warning as @parent is NULL.

Fix it by handle the kobject_init_add_add() error manually by kobject_put(),
without relying on btrfs_sysfs_del_qgroups().

Reported-by: Zheng Zheng <fengaojigui88@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAO-4RZ1DiPS2+=3WPxRGSEajO=dnsfYi4zDyjcVp3LBy2670AQ@mail.gmail.com/
Fixes: ed2e35d85d61 ("btrfs: sysfs: introduce global qgroup attribute group")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/sysfs.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 89b0a4ef4063..f87f828aff99 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -2487,8 +2487,16 @@ int btrfs_sysfs_add_qgroups(struct btrfs_fs_info *fs_info)
 
 	ret = kobject_init_and_add(fs_info->qgroups_kobj, &qgroups_ktype,
 				   fsid_kobj, "qgroups");
-	if (ret < 0)
-		goto out;
+	if (ret < 0) {
+		/*
+		 * The kobject is not added into sysfs, so we can only free it
+		 * manually. kobject_del() from btrfs_del_qgroups() will
+		 * trigger a warning.
+		 */
+		kobject_put(fs_info->qgroups_kobj);
+		fs_info->qgroups_kobj = NULL;
+		return ret;
+	}
 
 	rbtree_postorder_for_each_entry_safe(qgroup, next,
 					     &fs_info->qgroup_tree, node) {
-- 
2.56.0

