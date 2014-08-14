Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63793 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754424AbaHNWD2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 18:03:28 -0400
Message-ID: <53ED321D.1040702@fb.com>
Date: Thu, 14 Aug 2014 18:03:09 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, Austin S Hemmelgarn <ahferroin7@gmail.com>
CC: <linux-btrfs@vger.kernel.org>, <jbacik@fb.com>,
        <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: btrfs-zero-log fails, can't mount FS
References: <20140814160902.GA25370@merlins.org> <53ECE953.70009@gmail.com> <20140814172743.GC27531@merlins.org>
In-Reply-To: <20140814172743.GC27531@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/14/2014 01:27 PM, Marc MERLIN wrote:
> On Thu, Aug 14, 2014 at 12:52:35PM -0400, Austin S Hemmelgarn wrote:
>> I don't think it is likely that the Samsung SSD is to blame, in my
>> experience Samsung's SSD's are better than almost every other brand
>> except Intel, and I know that they honor write-barriers correctly.
>> The likely issue is that the system hung during the process of a commit,
>> which is one of the few things that I know of that consistently corrupts
>> the filesystem.  There isn't really anything I know of to prevent it,
>> except for making your system as stable as possible.
>> Interestingly, this type of thing is the only issue I've ever had with
>> BTRFS that wasn't traceable to hardware problems.
> 
> That was my understanding too, thanks for confirming.
> 
> Until this bug gets fixed, I'm perplexed as to why btrfs-zero-log isn't
> fixing this.
> Can't I unroll the last commits until I get to a stable one?
> 
> As luck would have it (again), I'm boarding a plane to Chicago tomorrow to
> go speak at linuxcon about btrfs.
> I would very much like not to have to spend 12H to restore my SSD from
> backup :)

At least I'll get to buy you a beer this time.

Lets just see if the log root is the only problem.  This will get you
through btrfs-zero-log

diff --git a/disk-io.c b/disk-io.c
index 8db0335..d9a8e19 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -911,13 +911,13 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 			return -EIO;
 	}
 	fs_info->csum_root->track_dirty = 1;
-
+#if 0
 	ret = find_and_setup_log_root(root, fs_info, sb);
 	if (ret) {
 		printk("Couldn't setup log root tree\n");
 		return -EIO;
 	}
-
+#endif
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 	if (extent_buffer_uptodate(fs_info->extent_root->node) &&
