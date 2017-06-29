Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45704 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751741AbdF2DCL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 23:02:11 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5T2x56G016886
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Jun 2017 20:02:11 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2bcrwb81dj-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Jun 2017 20:02:11 -0700
Received: from facebook.com (2401:db00:21:6023:face:0:9:0)      by
 mx-out.facebook.com (2401:db00:2050:5102:face:0000:0037:0000) with ESMTP       id
 573dfe825c7711e79f701f53bdcd5fbc-275c26b0 for <linux-btrfs@vger.kernel.org>;
        Wed, 28 Jun 2017 20:02:09 -0700
From: Nick Terrell <terrelln@fb.com>
To: Nick Terrell <terrelln@fb.com>
CC: <kernel-team@fb.com>, Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        <squashfs-devel@lists.sourceforge.net>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Adam Borowski <kilobyte@angband.pl>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: Keep one more workspace around
Date: Wed, 28 Jun 2017 20:01:51 -0700
Message-ID: <20170629030151.1672771-1-terrelln@fb.com>
In-Reply-To: <20170629010210.yfmumrhdcu3ssmwz@angband.pl>
References: <20170629010210.yfmumrhdcu3ssmwz@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Is there a version I should be testing?

Not yet, I'm working on v2 of the patch set, which will be ready soon.

> I got a bunch of those:
> [10170.448783] kworker/u8:6: page allocation stalls for 60720ms, order:0, mode:0x14000c2(GFP_KERNEL|__GFP_HIGHMEM), nodemask=(null)
> [10170.448819] kworker/u8:6 cpuset=/ mems_allowed=0
> [10170.448842] CPU: 3 PID: 13430 Comm: kworker/u8:6 Not tainted 4.12.0-rc7-00034-gdff47ed160bb #1
> [10170.448846] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
> [10170.448872] Workqueue: btrfs-endio btrfs_endio_helper
> [10170.448910] [<c010de1c>] (unwind_backtrace) from [<c010adb8>] (show_stack+0x10/0x14)
> [10170.448925] [<c010adb8>] (show_stack) from [<c0442b00>] (dump_stack+0x78/0x8c)
> [10170.448942] [<c0442b00>] (dump_stack) from [<c01b0178>] (warn_alloc+0xc0/0x170)
> [10170.448952] [<c01b0178>] (warn_alloc) from [<c01b0c3c>] (__alloc_pages_nodemask+0x97c/0xe30)
> [10170.448964] [<c01b0c3c>] (__alloc_pages_nodemask) from [<c01e217c>] (__vmalloc_node_range+0x144/0x27c)
> [10170.448976] [<c01e217c>] (__vmalloc_node_range) from [<c01e2550>] (__vmalloc_node.constprop.10+0x48/0x50)
> [10170.448982] [<c01e2550>] (__vmalloc_node.constprop.10) from [<c01e25ec>] (vmalloc+0x2c/0x34)
> [10170.448990] [<c01e25ec>] (vmalloc) from [<c038f7cc>] (zstd_alloc_workspace+0x6c/0xb8)
> [10170.448997] [<c038f7cc>] (zstd_alloc_workspace) from [<c038fcb8>] (find_workspace+0x120/0x1f4)
> [10170.449002] [<c038fcb8>] (find_workspace) from [<c038ff60>] (end_compressed_bio_read+0x1d4/0x3b0)
> [10170.449016] [<c038ff60>] (end_compressed_bio_read) from [<c0130e14>] (process_one_work+0x1d8/0x3f0)
> [10170.449026] [<c0130e14>] (process_one_work) from [<c0131a18>] (worker_thread+0x38/0x558)
> [10170.449035] [<c0131a18>] (worker_thread) from [<c0136854>] (kthread+0x124/0x154)
> [10170.449042] [<c0136854>] (kthread) from [<c01076f8>] (ret_from_fork+0x14/0x3c)
>
> which never happened with compress=lzo, and a 2GB RAM machine that runs 4
> threads of various builds runs into memory pressure quite often.  On the
> other hand, I used 4.11 for lzo so this needs more testing before I can
> blame the zstd code.

I'm not sure what is causing the symptom of stalls in vmalloc(), but I
think I know what is causing vmalloc() to be called so often. Its probably
showing up for zstd and not lzo because it requires more memory.

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
zlib, and zstd.

> I'm on linus:4.12-rc7 with only a handful of btrfs patches (v3 of Qu's chunk
> check, some misc crap) -- I guess I should use at least btrfs-for-4.13.  Or
> would you prefer full-blown next?

Whatever is convenient for you. The relevant code in BtrFS hasn't changed
for a few months, so it shouldn't matter too much.

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
