Return-Path: <SRS0=/JOF=4C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FD8C2BA83
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Feb 2020 16:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E7F624692
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Feb 2020 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581699005;
	bh=5vOT5Cbvh9GNxrUOd50DskvivDNUfqGcKhlzkAN2f3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Es0V9ufRr9U/oZwMIPUev3TqKrJfQ2rUp8Nu/3aSpB1BdXJMQ7mVMW9QGSudw+L0v
	 KwTWidMvkcNMEVZDGwwkQOiv+S7OGUtzElknR++pM9dDlXT42/alWtS8P4aB636Xca
	 aMGldq8uEbjhb/qYNqRslK6XOxVnWmoK0TiDUF0E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730079AbgBNQtl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:49:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405214AbgBNQUX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Feb 2020 11:20:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7027224734;
        Fri, 14 Feb 2020 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697223;
        bh=5vOT5Cbvh9GNxrUOd50DskvivDNUfqGcKhlzkAN2f3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UW1E8UYrnS9PjUyuSs9xD35aAKPLM2yFAwbRNj3JIyhrWSSQQGbuGLxXStYmwSf7N
         cJlzqxLdEHWYi9qSGIVwRFZwcfJMdhFVnCyGHHOhPkieYbgsNE3SamILcDicpPTdXl
         6MVqG/GsksY5j+pcJb+KX2KtfumyyksG5c4/+m0A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anand Jain <anand.jain@oracle.com>, philip@philip-seeger.de,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 146/186] btrfs: device stats, log when stats are zeroed
Date:   Fri, 14 Feb 2020 11:16:35 -0500
Message-Id: <20200214161715.18113-146-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit a69976bc69308aa475d0ba3b8b3efd1d013c0460 ]

We had a report indicating that some read errors aren't reported by the
device stats in the userland. It is important to have the errors
reported in the device stat as user land scripts might depend on it to
take the reasonable corrective actions. But to debug these issue we need
to be really sure that request to reset the device stat did not come
from the userland itself. So log an info message when device error reset
happens.

For example:
 BTRFS info (device sdc): device stats zeroed by btrfs(9223)

Reported-by: philip@philip-seeger.de
Link: https://www.spinics.net/lists/linux-btrfs/msg96528.html
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 358e930df4acd..6d34842912e80 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7227,6 +7227,8 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 			else
 				btrfs_dev_stat_reset(dev, i);
 		}
+		btrfs_info(fs_info, "device stats zeroed by %s (%d)",
+			   current->comm, task_pid_nr(current));
 	} else {
 		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++)
 			if (stats->nr_items > i)
-- 
2.20.1

