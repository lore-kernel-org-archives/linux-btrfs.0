Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61202 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbaBFVUs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 16:20:48 -0500
Message-ID: <52F3FC72.3020603@fb.com>
Date: Thu, 6 Feb 2014 16:19:46 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Johannes Hirte <johannes.hirte@datenkhaos.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: throttle delayed refs better
References: <1390500472-15144-1-git-send-email-jbacik@fb.com>	<20140203192811.72866921@datenkhaos.de>	<52F00538.3010505@fb.com>	<20140203235334.791312d1@datenkhaos.de>	<52F0F566.1090206@fb.com>	<20140205091428.076fa15c@datenkhaos.de>	<52F25D7B.90807@fb.com>	<20140205183406.47023d24@datenkhaos.de>	<52F28A69.8050804@fb.com>	<20140205203023.535d6f96@datenkhaos.de>	<52F292C7.7030701@fb.com>	<20140205224250.7876dd16@datenkhaos.de>	<52F2B151.70307@fb.com> <20140205235732.04263a51@datenkhaos.de>
In-Reply-To: <20140205235732.04263a51@datenkhaos.de>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/05/2014 05:57 PM, Johannes Hirte wrote:
> On Wed, 5 Feb 2014 16:46:57 -0500
> Josef Bacik <jbacik@fb.com> wrote:
> 
>>
>> On 02/05/2014 04:42 PM, Johannes Hirte wrote:
>>> On Wed, 5 Feb 2014 14:36:39 -0500
>>> Josef Bacik <jbacik@fb.com> wrote:
>>>
>>>> On 02/05/2014 02:30 PM, Johannes Hirte wrote:
>>>>> On Wed, 5 Feb 2014 14:00:57 -0500
>>>>> Josef Bacik <jbacik@fb.com> wrote:
>>>>>
>>>>>> On 02/05/2014 12:34 PM, Johannes Hirte wrote:
>>>>>>> On Wed, 5 Feb 2014 10:49:15 -0500
>>>>>>> Josef Bacik <jbacik@fb.com> wrote:
>>>>>>>
>>>>>>>> Ok none of those make sense which makes me think it may be the
>>>>>>>> ktime bits, instead of un-applying the whole patch could you
>>>>>>>> just comment out the parts
>>>>>>>>
>>>>>>>>              ktime_t start = ktime_get();
>>>>>>>>
>>>>>>>> and
>>>>>>>>
>>>>>>>>              if (actual_count > 0) {
>>>>>>>>                      u64 runtime =
>>>>>>>> ktime_to_ns(ktime_sub(ktime_get(), start)); u64 avg;
>>>>>>>>
>>>>>>>>                      /*
>>>>>>>>                       * We weigh the current average higher than
>>>>>>>> our current runtime
>>>>>>>>                       * to avoid large swings in the average.
>>>>>>>>                       */
>>>>>>>>                      spin_lock(&delayed_refs->lock);
>>>>>>>>                      avg = fs_info->avg_delayed_ref_runtime * 3
>>>>>>>> + runtime; avg = div64_u64(avg, 4);
>>>>>>>>                      fs_info->avg_delayed_ref_runtime = avg;
>>>>>>>>                      spin_unlock(&delayed_refs->lock);
>>>>>>>>              }
>>>>>>>>
>>>>>>>> in __btrfs_run_delayed_refs and see if that makes the problem
>>>>>>>> stop? If it does will you try chris's for-linus branch to see
>>>>>>>> if it still reproduces there?  Maybe some patch changed
>>>>>>>> ktime_get() in -rc1 that is causing issues and we're just now
>>>>>>>> exposing it. Thanks,
>>>>>>> With the ktime bits disabled, I wasn't able to reproduce the
>>>>>>> problem anymore. With Chris' for-linus branch it took longer but
>>>>>>> still appeared.
>>>>>>>
>>>>>> Ok can you send your .config, maybe there's some weird time bug
>>>>>> being exposed.  What kind of CPU do you have?  Thanks,
>>>>>>
>>>>>> Josef
>>>>> It's a Core i5-540M, dualcore + hyperthreading
>>>> Ok while I'm doing this can you change
>>>> btrfs_should_throttle_delayed_refs to _always_ return 1, still with
>>>> all the ktime stuff commented out, and see if that causes the
>>>> problem to happen?  Thanks,
>>> Yes it does. Same behavior as without ktime stuff commented out.
>>>
>> Ok perfect, can you send me a btrfs fi df of that volume, and do you
>> have any snapshots or anything?  Thanks,
> 
> btrfs fi df /
> Data, single: total=220.01GiB, used=210.85GiB
> System, DUP: total=8.00MiB, used=32.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=4.00GiB, used=2.93GiB
> Metadata, single: total=8.00MiB, used=0.00
> 
> No snapshots but several subvolumes. / itself is a seperate subvolume
> and subvol 0 only contains the other subvolumes (5 at moment). qgroups
> aren't enabled.
> 
> mount options are noatime,inode_cache, if this matters
> 

Ok so I thought I reproduced the problem but I just reproduced a different
problem.  Please undo any changes you've made and apply this patch and reproduce
and then provide me with any debug output that gets spit out.  I'm sending this
via thunderbird with 6 different extensions to make sure it comes out right so
if it doesn't work let me know and I'll just paste it somewhere.  Thanks,

Josef

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index f3bff89..b025a04 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -204,8 +204,12 @@ find_ref_head(struct rb_root *root, u64 bytenr,
 	struct rb_node *n;
 	struct btrfs_delayed_ref_head *entry;
 	int cmp = 0;
+	unsigned long loops = 0;
 
 again:
+	loops++;
+	if (loops > 2)
+		printk(KERN_ERR "we have fucked up\n");
 	n = root->rb_node;
 	entry = NULL;
 	while (n) {
@@ -232,6 +236,7 @@ again:
 			n = rb_next(&entry->href_node);
 			if (!n)
 				n = rb_first(root);
+			BUG_ON(!n);
 			entry = rb_entry(n, struct btrfs_delayed_ref_head,
 					 href_node);
 			bytenr = entry->node.bytenr;
@@ -410,10 +415,14 @@ btrfs_select_ref_head(struct btrfs_trans_handle *trans)
 	struct btrfs_delayed_ref_head *head;
 	u64 start;
 	bool loop = false;
+	unsigned long loops = 0;
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
 again:
+	loops++;
+	if (loops > 5)
+		printk(KERN_ERR "houston we have a problem\n");
 	start = delayed_refs->run_delayed_start;
 	head = find_ref_head(&delayed_refs->href_root, start, NULL, 1);
 	if (!head && !loop) {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9c9ecc9..91dacf4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2327,9 +2327,16 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	unsigned long count = 0;
 	unsigned long actual_count = 0;
 	int must_insert_reserved = 0;
+	unsigned long loops = 0;
+	unsigned long no_selected_ref = 0;
 
 	delayed_refs = &trans->transaction->delayed_refs;
 	while (1) {
+		loops++;
+		if (loops > 100000) {
+			printk(KERN_ERR "looped a lot, count %lu, nr %lu, no_selected_ref %lu\n", count, nr, no_selected_ref);
+			loops = 0;
+		}
 		if (!locked_ref) {
 			if (count >= nr)
 				break;
@@ -2385,6 +2392,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			spin_unlock(&delayed_refs->lock);
 			locked_ref = NULL;
 			cond_resched();
+			no_selected_ref++;
 			continue;
 		}
 
@@ -2660,6 +2668,8 @@ int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
 		atomic_read(&trans->transaction->delayed_refs.num_entries);
 	u64 avg_runtime;
 
+	return 1;
+
 	smp_mb();
 	avg_runtime = fs_info->avg_delayed_ref_runtime;
 	if (num_entries * avg_runtime >= NSEC_PER_SEC)
@@ -2687,6 +2697,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	int ret;
 	int run_all = count == (unsigned long)-1;
 	int run_most = 0;
+	unsigned long loops = 0;
 
 	/* We'll clean this up in btrfs_cleanup_transaction */
 	if (trans->aborted)
@@ -2704,6 +2715,11 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	}
 
 again:
+	loops++;
+	if (loops > 10000) {
+		printk(KERN_ERR "It's the larger loop, count %lu\n", count);
+		loops = 0;
+	}
 #ifdef SCRAMBLE_DELAYED_REFS
 	delayed_refs->run_delayed_start = find_middle(&delayed_refs->root);
 #endif

