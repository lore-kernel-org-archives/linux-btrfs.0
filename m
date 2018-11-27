Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3695C43610
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B690208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B690208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jp.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbeK0Q2W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 11:28:22 -0500
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:47094 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbeK0Q2W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 11:28:22 -0500
Received: from yt-mxoi1.gw.nic.fujitsu.com (unknown [192.168.229.67]) by mgwym04.jp.fujitsu.com with smtp
         id 54a9_ddea_195c8337_7766_430d_946b_9c5613616c8f;
        Tue, 27 Nov 2018 14:20:25 +0900
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 658D1AC0115
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 14:20:24 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 8A582584295;
        Tue, 27 Nov 2018 14:20:23 +0900 (JST)
Received: from luna3.soft.fujitsu.com (10.124.196.199) by
 g01jpexchyt37.g01.fujitsu.local (10.128.193.67) with Microsoft SMTP Server id
 14.3.352.0; Tue, 27 Nov 2018 14:20:23 +0900
From:   Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     David Sterba <dsterba@suse.com>
Subject: [PATCH 5/8] btrfs-progs: utils: Fallback to open without O_NOATIME flag in find_mount_root():
Date:   Tue, 27 Nov 2018 14:24:46 +0900
Message-ID: <97ed64c94563e960eb3443bcbc164ce167662e2e.1543294426.git.misono.tomohiro@jp.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: disable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

O_NOATIME flag requires effective UID of process matches file's owner
or has CAP_FOWNER capabilities. Fallback to open without O_NOATIME flag
so that non-privileged user can also call find_mount_root().

This is a preparation work to allow non-privileged user to call
"subvolume show".

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/utils.c b/utils.c
index 3a4bc92a..8ce8417d 100644
--- a/utils.c
+++ b/utils.c
@@ -2054,6 +2054,9 @@ int find_mount_root(const char *path, char **mount_root)
 	char *longest_match = NULL;
 
 	fd = open(path, O_RDONLY | O_NOATIME);
+	if (fd < 0 && errno == EPERM)
+		fd = open(path, O_RDONLY);
+
 	if (fd < 0)
 		return -errno;
 	close(fd);
-- 
2.19.1


