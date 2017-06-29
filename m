Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49313 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753140AbdF2R5o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 13:57:44 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.20/8.16.0.20) with SMTP id v5THvduS029635
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Jun 2017 10:57:42 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2bd10vs2hc-12
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Jun 2017 10:57:42 -0700
Received: from facebook.com (2401:db00:21:6023:face:0:9:0)      by
 mx-out.facebook.com (10.103.99.97) with ESMTP  id
 6b6d8ea45cf411e7a4760002c9931860-3bd3f8f0 for <linux-btrfs@vger.kernel.org>;
        Thu, 29 Jun 2017 10:57:30 -0700
From: Nick Terrell <terrelln@fb.com>
To: Nick Terrell <terrelln@fb.com>
CC: <kernel-team@fb.com>, Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        <linux-btrfs@vger.kernel.org>, Adam Borowski <kilobyte@angband.pl>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: Keep one more workspace around
Date: Thu, 29 Jun 2017 10:57:26 -0700
Message-ID: <20170629175726.1246810-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

find_workspace() allocates up to num_online_cpus() + 1 workspaces.
free_workspace() will only keep num_online_cpus() workspaces. When
(de)compressing we will allocate num_online_cpus() + 1 workspaces, then
free one, and repeat. Instead, we can just keep num_online_cpus() + 1
workspaces around, and never have to allocate/free another workspace in the
common case.

I tested on a Ubuntu 14.04 VM with 2 cores and 4 GiB of RAM. I mounted a
BtrFS partition with -o compress-force={lzo,zlib,zstd} and logged whenever
a workspace was allocated of freed. Then I copied vmlinux (527 MB) to the
partition. Before the patch, during the copy it would allocate and free 5-6
workspaces. After, it only allocated the initial 3. This held true for lzo,
zlib, and zstd. The time it took to execute cp vmlinux /mnt/btrfs && sync
dropped from 1.70s to 1.44s with lzo compression, and from 2.04s to 1.80s
for zstd compression.

Signed-off-by: Nick Terrell <terrelln@fb.com>
---
 fs/btrfs/compression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 3beb0d0..1a0ef55 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -874,7 +874,7 @@ static void free_workspace(int type, struct list_head *workspace)
 	int *free_ws			= &btrfs_comp_ws[idx].free_ws;

 	spin_lock(ws_lock);
-	if (*free_ws < num_online_cpus()) {
+	if (*free_ws <= num_online_cpus()) {
 		list_add(workspace, idle_ws);
 		(*free_ws)++;
 		spin_unlock(ws_lock);
--
2.9.3
