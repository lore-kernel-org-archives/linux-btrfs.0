Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64416 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965284AbaFSVpi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 17:45:38 -0400
Message-ID: <53A35B31.4060203@fb.com>
Date: Thu, 19 Jun 2014 17:50:41 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Waiman Long <waiman.long@hp.com>
CC: Marc Dionne <marc.c.dionne@gmail.com>, Josef Bacik <jbacik@fb.com>,
        <linux-btrfs@vger.kernel.org>, <t-itoh@jp.fujitsu.com>
Subject: Re: Lockups with btrfs on 3.16-rc1 - bisected
References: <CAB9dFdsyB40V2BGwdQKzSSz7YUWMh-C2AWdDNK=PMG9h+BO57w@mail.gmail.com>	<53A20FFF.3010807@hp.com>	<53A2125B.3050701@fb.com>	<53A21702.8090109@hp.com>	<53A21C78.1040809@fb.com>	<53A21E84.2050103@hp.com>	<53A22064.7080400@fb.com>	<53A2212E.7090907@hp.com>	<53A2268F.3080807@fb.com>	<CAB9dFds5J8Ti3CgtxHrgqM3j1TiwqYCnhP+A3Nb0q-FNgmQbXA@mail.gmail.com>	<53A22A01.7080505@hp.com>	<CAB9dFdvD9QMZ_rONhhP5ZD2E7+A7qxnsY978Snc3zHEbdPRszw@mail.gmail.com> <CAB9dFdtTFN+uQ8=WXVa0Y5GbBSYM5iVLgTaEeh_FqHt=XFKNvQ@mail.gmail.com> <53A246C6.5050408@fb.com> <53A2573B.1060901@hp.com> <53A31514.8030308@fb.com> <53A32353.5000104@hp.com> <53A343B9.3000900@fb.com>
In-Reply-To: <53A343B9.3000900@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/19/2014 04:10 PM, Chris Mason wrote:
> On 06/19/2014 01:52 PM, Waiman Long wrote:
>> On 06/19/2014 12:51 PM, Chris Mason wrote:
>>> On 06/18/2014 11:21 PM, Waiman Long wrote:
>>>> On 06/18/2014 10:11 PM, Chris Mason wrote:
>>>>> On 06/18/2014 10:03 PM, Marc Dionne wrote:
>>>>>> On Wed, Jun 18, 2014 at 8:41 PM, Marc
>>>>>> Dionne<marc.c.dionne@gmail.com>   wrote:
>>>>>>> On Wed, Jun 18, 2014 at 8:08 PM, Waiman Long<waiman.long@hp.com>
>>>>>>> wrote:
>>>>>>>> On 06/18/2014 08:03 PM, Marc Dionne wrote:
>>>>>> And for an additional data point, just removing those
>>>>>> CONFIG_DEBUG_LOCK_ALLOC ifdefs looks like it's sufficient to prevent
>>>>>> the symptoms when lockdep is not enabled.
>>>>> Ok, somehow we've added a lock inversion here that wasn't here before.
>>>>> Thanks for confirming, I'll nail it down.
>>>>>
>>>>> -chris
>>>>>
>>>> I am pretty sure that the hangup is caused by the following kind of code
>>>> fragment in the locking.c file:
>>>>
>>>>   if (eb->lock_nested) {
>>>>                  read_lock(&eb->lock);
>>>>                  if (eb->lock_nested&&  current->pid ==
>>>> eb->lock_owner) {
>>>>
>>>> Is it possible to do the check without taking the read_lock?
>>> I think you're right, we haven't added any new recursive takers of the
>>> lock.  The path where we are deadlocking has an extent buffer that isn't
>>> in the path yet locked.  I think we're taking the read lock while that
>>> one is write locked.
>>>
>>> Reworking the nesting a big here.
>>>
>>> -chris
>>
>> I would like to take back my comments. I took out the read_lock, but the
>> process still hang while doing file activities on btrfs filesystem. So
>> the problem is trickier than I thought. Below are the stack backtraces
>> of some of the relevant processes.
>>
> 
> You weren't wrong, but it was also the tree trylock code.  Our trylocks
> only back off if the blocking lock is held.  btrfs_next_leaf needs it to
> be a true trylock.  The confusing part is this hasn't really changed,
> but one of the callers must be a spinner where we used to have a blocker.

This is what I have queued up, it's working here.

-chris

commit ea4ebde02e08558b020c4b61bb9a4c0fcf63028e
Author: Chris Mason <clm@fb.com>
Date:   Thu Jun 19 14:16:52 2014 -0700

    Btrfs: fix deadlocks with trylock on tree nodes
    
    The Btrfs tree trylock function is poorly named.  It always takes
    the spinlock and backs off if the blocking lock is held.  This
    can lead to surprising lockups because people expect it to really be a
    trylock.
    
    This commit makes it a pure trylock, both for the spinlock and the
    blocking lock.  It also reworks the nested lock handling slightly to
    avoid taking the read lock while a spinning write lock might be held.
    
    Signed-off-by: Chris Mason <clm@fb.com>

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 01277b8..5665d21 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -33,14 +33,14 @@ static void btrfs_assert_tree_read_locked(struct extent_buffer *eb);
  */
 void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw)
 {
-	if (eb->lock_nested) {
-		read_lock(&eb->lock);
-		if (eb->lock_nested && current->pid == eb->lock_owner) {
-			read_unlock(&eb->lock);
-			return;
-		}
-		read_unlock(&eb->lock);
-	}
+	/*
+	 * no lock is required.  The lock owner may change if
+	 * we have a read lock, but it won't change to or away
+	 * from us.  If we have the write lock, we are the owner
+	 * and it'll never change.
+	 */
+	if (eb->lock_nested && current->pid == eb->lock_owner)
+		return;
 	if (rw == BTRFS_WRITE_LOCK) {
 		if (atomic_read(&eb->blocking_writers) == 0) {
 			WARN_ON(atomic_read(&eb->spinning_writers) != 1);
@@ -65,14 +65,15 @@ void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw)
  */
 void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
 {
-	if (eb->lock_nested) {
-		read_lock(&eb->lock);
-		if (eb->lock_nested && current->pid == eb->lock_owner) {
-			read_unlock(&eb->lock);
-			return;
-		}
-		read_unlock(&eb->lock);
-	}
+	/*
+	 * no lock is required.  The lock owner may change if
+	 * we have a read lock, but it won't change to or away
+	 * from us.  If we have the write lock, we are the owner
+	 * and it'll never change.
+	 */
+	if (eb->lock_nested && current->pid == eb->lock_owner)
+		return;
+
 	if (rw == BTRFS_WRITE_LOCK_BLOCKING) {
 		BUG_ON(atomic_read(&eb->blocking_writers) != 1);
 		write_lock(&eb->lock);
@@ -99,6 +100,9 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
 void btrfs_tree_read_lock(struct extent_buffer *eb)
 {
 again:
+	BUG_ON(!atomic_read(&eb->blocking_writers) &&
+	       current->pid == eb->lock_owner);
+
 	read_lock(&eb->lock);
 	if (atomic_read(&eb->blocking_writers) &&
 	    current->pid == eb->lock_owner) {
@@ -132,7 +136,9 @@ int btrfs_try_tree_read_lock(struct extent_buffer *eb)
 	if (atomic_read(&eb->blocking_writers))
 		return 0;
 
-	read_lock(&eb->lock);
+	if (!read_trylock(&eb->lock))
+		return 0;
+
 	if (atomic_read(&eb->blocking_writers)) {
 		read_unlock(&eb->lock);
 		return 0;
@@ -151,7 +157,10 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
 	if (atomic_read(&eb->blocking_writers) ||
 	    atomic_read(&eb->blocking_readers))
 		return 0;
-	write_lock(&eb->lock);
+
+	if (!write_trylock(&eb->lock))
+		return 0;
+
 	if (atomic_read(&eb->blocking_writers) ||
 	    atomic_read(&eb->blocking_readers)) {
 		write_unlock(&eb->lock);
@@ -168,14 +177,15 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
  */
 void btrfs_tree_read_unlock(struct extent_buffer *eb)
 {
-	if (eb->lock_nested) {
-		read_lock(&eb->lock);
-		if (eb->lock_nested && current->pid == eb->lock_owner) {
-			eb->lock_nested = 0;
-			read_unlock(&eb->lock);
-			return;
-		}
-		read_unlock(&eb->lock);
+	/*
+	 * if we're nested, we have the write lock.  No new locking
+	 * is needed as long as we are the lock owner.
+	 * The write unlock will do a barrier for us, and the lock_nested
+	 * field only matters to the lock owner.
+	 */
+	if (eb->lock_nested && current->pid == eb->lock_owner) {
+		eb->lock_nested = 0;
+		return;
 	}
 	btrfs_assert_tree_read_locked(eb);
 	WARN_ON(atomic_read(&eb->spinning_readers) == 0);
@@ -189,14 +199,15 @@ void btrfs_tree_read_unlock(struct extent_buffer *eb)
  */
 void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
 {
-	if (eb->lock_nested) {
-		read_lock(&eb->lock);
-		if (eb->lock_nested && current->pid == eb->lock_owner) {
-			eb->lock_nested = 0;
-			read_unlock(&eb->lock);
-			return;
-		}
-		read_unlock(&eb->lock);
+	/*
+	 * if we're nested, we have the write lock.  No new locking
+	 * is needed as long as we are the lock owner.
+	 * The write unlock will do a barrier for us, and the lock_nested
+	 * field only matters to the lock owner.
+	 */
+	if (eb->lock_nested && current->pid == eb->lock_owner) {
+		eb->lock_nested = 0;
+		return;
 	}
 	btrfs_assert_tree_read_locked(eb);
 	WARN_ON(atomic_read(&eb->blocking_readers) == 0);
@@ -244,6 +255,7 @@ void btrfs_tree_unlock(struct extent_buffer *eb)
 	BUG_ON(blockers > 1);
 
 	btrfs_assert_tree_locked(eb);
+	eb->lock_owner = 0;
 	atomic_dec(&eb->write_locks);
 
 	if (blockers) {
