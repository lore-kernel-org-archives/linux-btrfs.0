Return-Path: <SRS0=cHbd=PD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B6EC43444
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 05:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79EE221720
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 05:38:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="F2wY5QHC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbeLZFiQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Dec 2018 00:38:16 -0500
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:41324 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbeLZFiP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Dec 2018 00:38:15 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 67453B47
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Dec 2018 05:38:13 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YY4LshAhjKlh for <linux-btrfs@vger.kernel.org>;
        Tue, 25 Dec 2018 23:38:13 -0600 (CST)
Received: from mail-it1-f199.google.com (mail-it1-f199.google.com [209.85.166.199])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 3707BB04
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Dec 2018 23:38:13 -0600 (CST)
Received: by mail-it1-f199.google.com with SMTP id p21so17759466itb.8
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Dec 2018 21:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=o+ZaauZY/rSwkfY3UC6i1AxUZHMBSL5wYx1f/vwR7b0=;
        b=F2wY5QHCN4ULFbEj1ZZ/Pl+gL3+Z+pc0TtLmsXwjzvyToeyEREGgN2i1J9ce/UEc1G
         449MVrRLcIMVBuaLkz7XkJOb5E/TRg9x6DOEPdF9DcM4sXfuubjxOy1Sa9JvtJaB6CC1
         o558ugW1xa7Kgwh7yyR6wMzX85YTwaKfbid2J7/67RxJ1lnkToGqsb6OasMsiTUiNXPP
         GQkXgnLRa/zlGYOnvKYRUnR6NNtWD5e5Io/IdNCraI324RfpMb04WpkIGyLwbe8pLeVL
         VODxB+2jEpfm8sVCF1GpzPX3utcl7eWlVXonNsSksII4CvLq61gVTEgH/X0EwErjTeNa
         ExCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=o+ZaauZY/rSwkfY3UC6i1AxUZHMBSL5wYx1f/vwR7b0=;
        b=BeebOBndcVOfl5z68GucqkE7uOo3LsWrw5TzeoWxyCfzwlNhGYnQL7PAo8teDDm6ex
         W0I9WySCykXDJdmMTkuSxealyss0gkCae1doFVZmU1NSUgxJOUwDpiWwW9pUMG44KsgE
         xmGemmwxg7INFwtBBdwAJDAJgs5GzvTQPV6pYuniTeDoVUQaZ1D3PxS5e+8TkbfSZg7t
         ko3tteliRKbsuOju35mPHKi21wRKLdLS8G7ED7ZkrBGt/lbd0NB677XMz9E5bpV4o1Q/
         OnpZ/hT66HSuPhBKRV/oqxmdHdHvv8SoZTJHon0Gp60KM7GsuTFqyd3VN2jLKUHQHv6B
         Ws2A==
X-Gm-Message-State: AA+aEWZIxHW0CwP4g86yQs/BeJ8QpvSvCcLcWM/SpxAxW/WT2y+muuRx
        7iGfoV0gsvOz2NLX5ZfB+WDlHKWDx8bjOJWzE8me2JOPXeOZdZw4EFK8StdN4ZJNO5hSbZrkKWl
        boAVE6HvT8R4PsEG7onrpJ5KIpE4=
X-Received: by 2002:a24:248:: with SMTP id 69mr11780438itu.91.1545802692362;
        Tue, 25 Dec 2018 21:38:12 -0800 (PST)
X-Google-Smtp-Source: AFSGD/WJTajMAXjiO3aG93CSqJjXBREYjR6yT4KMpN/BczApQT7kk+AEodbd4Aaq2vk647dmPv2dWw==
X-Received: by 2002:a24:248:: with SMTP id 69mr11780428itu.91.1545802692124;
        Tue, 25 Dec 2018 21:38:12 -0800 (PST)
Received: from localhost.localdomain (host-173-230-104-22.mnmigsc.mn.minneapolis.us.clients.pavlovmedia.net. [173.230.104.22])
        by smtp.gmail.com with ESMTPSA id c194sm13767233itc.3.2018.12.25.21.38.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 25 Dec 2018 21:38:11 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] btrfs: add a check for sysfs_create_group
Date:   Tue, 25 Dec 2018 23:37:44 -0600
Message-Id: <20181226053744.74740-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In case sysfs_create_group fails, let's check its return value and
issues an error message.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 fs/btrfs/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3717c864ba23..24ef416e700b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -889,6 +889,8 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
 	 */
 	sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
 	ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
+	if (ret)
+		btrfs_err(fs_info, "failed to create btrfs_feature_attr_group.\n");
 }
 
 static int btrfs_init_debugfs(void)
-- 
2.17.2 (Apple Git-113)

