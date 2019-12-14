Return-Path: <SRS0=jDr+=2E=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACD6C00454
	for <linux-btrfs@archiver.kernel.org>; Sat, 14 Dec 2019 00:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D13E214AF
	for <linux-btrfs@archiver.kernel.org>; Sat, 14 Dec 2019 00:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576282971;
	bh=u6wjg+iIQYfwTzEtSVZ3TwHM3tKsFXTCXLsbrZsy/ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
	 References:List-ID:From;
	b=u378Ekw2oJo7WQQJLF+upOYndcKqn3YbDEahn3SSrn/WY7vmQjDdjWUApYZ4kJ+UL
	 +5vOspA6THwz09qcRpI085hVoNVCmKxWT8Ik738CkLHvsoerbH/qDe+SAI6D0V9T4n
	 7Djp+TRGziczdgDF56WLVT79AQHCQVmPvnWVvQlw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfLNAWu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 19:22:50 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36532 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfLNAWs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Dec 2019 19:22:48 -0500
Received: by mail-pg1-f195.google.com with SMTP id k3so286751pgc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2019 16:22:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=c7+AfibCFkJTA8FU/dbhfdDn0rrPQRSToZcX4Y5fRqA=;
        b=Bbb1mflGmipsbzeb5YYCNWEzjuSZz8tpWbcyRLgTLmunlMpQKxzqHZ6ge0SlkjbVmR
         3+lryg5+Iw1zbBsZnizXxIfnYezPC7Q7y4BLGWUwhvlyysSw3Sq/Td5g3tx3f+3uVvfq
         FODbwVh5M9IkGIfO9CHFUm38tyn/rObO9ZeLyb+jz3mhfzcFHE51X7uhCDV8vgHhnAML
         ioYahRL8T7aeIycuyroUE51WyuIqAutqMzdJ9w14DN9ZP+vt09xHicRCclf5onVdyBfJ
         ampvqSJneA4Adn86/Y89V16S59McakQq2DPUJajlJcw70DMRXCEu4zS7eRRD+E2PyY1S
         STKg==
X-Gm-Message-State: APjAAAVq8OGE0K7HtUwgpUKyxsgAMqE5YY4d5CXmww4V0ykib2gHgx/Q
        6RMoGSv6fyyInicZ0vS5j4o+t4eutgfMzg==
X-Google-Smtp-Source: APXvYqy6o2ZQfovSjXN06gs3dE2KZVXRox6aaZJDeC23NhqWwYpVPZ9lnwANU8yOpndFsyRgyg7nWA==
X-Received: by 2002:a65:66c8:: with SMTP id c8mr2666795pgw.161.1576282968122;
        Fri, 13 Dec 2019 16:22:48 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.64.138])
        by smtp.gmail.com with ESMTPSA id m12sm11911430pgr.87.2019.12.13.16.22.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 13 Dec 2019 16:22:47 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 08/22] btrfs: add removal calls for sysfs debug/
Date:   Fri, 13 Dec 2019 16:22:17 -0800
Message-Id: <1323085ba861d894c3b1259b669f84a0fc1e2d33.1576195673.git.dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <cover.1576195673.git.dennis@kernel.org>
References: <cover.1576195673.git.dennis@kernel.org>
In-Reply-To: <cover.1576195673.git.dennis@kernel.org>
References: <cover.1576195673.git.dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We probably should call sysfs_remove_group() on debug/.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 16379f491ca1..4c022757ffa4 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -771,6 +771,10 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 		kobject_del(fs_info->space_info_kobj);
 		kobject_put(fs_info->space_info_kobj);
 	}
+#ifdef CONFIG_BTRFS_DEBUG
+	sysfs_remove_group(&fs_info->fs_devices->fsid_kobj,
+			   &btrfs_debug_feature_attr_group);
+#endif
 	addrm_unknown_feature_attrs(fs_info, false);
 	sysfs_remove_group(&fs_info->fs_devices->fsid_kobj, &btrfs_feature_attr_group);
 	sysfs_remove_files(&fs_info->fs_devices->fsid_kobj, btrfs_attrs);
@@ -1205,6 +1209,9 @@ void __cold btrfs_exit_sysfs(void)
 	sysfs_unmerge_group(&btrfs_kset->kobj,
 			    &btrfs_static_feature_attr_group);
 	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
+#ifdef CONFIG_BTRFS_DEBUG
+	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_debug_feature_attr_group);
+#endif
 	kset_unregister(btrfs_kset);
 }
 
-- 
2.17.1

