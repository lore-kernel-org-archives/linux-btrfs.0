Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6867 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811AbaE3Un0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 16:43:26 -0400
Received: from pps.filterd (m0044008 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s4UKenW3016096
	for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 13:43:25 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1m6csqkc5a-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 13:43:25 -0700
Message-ID: <5388ED6B.8000706@fb.com>
Date: Fri, 30 May 2014 16:43:23 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: What to do about snapshot-aware defrag
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

TL;DR: I want to only do snapshot-aware defrag on inodes in snapshots 
that haven't changed since the snapshot was taken.  Yay or nay (with a 
reason why for nay)

=== How snapshot aware defrag currently works ===

First the defrag stuff will go through and read in and mark dirty a big 
area where it finds a bunch of tiny extents.  We go to write this stuff 
out and when the write completes we notice this operation was for 
defrag.  We go through the entire range of existing extents for this 
inode if there was a snapshot after the inode was created and record all 
of the extents in this range.

Then we look up all of the references for each of the extents we found. 
  So say we have 100 snapshots and we defragged 100 extents, we'll end 
up with 100 * 100 of these data structures to know what we have to 
stitch back together.

Then we go through each of these things and do btrfs_drop_extents for 
the range and either add the new extent for this range, or merge it with 
the previous one if we've already done that.  So it looks like this

[----- New extent -----]
[old1][old2][old3][old4]

We will drop old1 and create new1 for the range of old1, so we have this

[new1][old2][old3][old4]

and then the next one we will drop old2 and merge it with new1 so we 
have this

[-- new1 --][old3][old4]

and so on and so forth.  We do this because some random extent within 
this range could have changed and we don't want to overwrite that bit.

=== Problems that need to be fixed ===

1) The memory usage for this is astronomical.  Every extent for every 
snapshot we are replacing is recorded in memory while we do this, which 
is why this feature was disabled as people were constantly OOM'ing.

2) Currently this stitching operation is done in 
btrfs_finish_ordered_io, which means if anybody is waiting for the 
ordered extent or any ordered extent to be completed they are going to 
block longer waiting for the operation to complete, which could be very 
time consuming.

=== Solutions ===

1) Move the snapshot aware stitching part off into a different thread. 
We can make this block unmount until it completes if we want to make 
sure we always finish our job, or we can make it exit and then we lose 
some of the snapshot awareness.  Either way is fine with me, I figure 
we'd go with blocking first and change it if somebody complains too loudly.

2) Fix how we do the stitching.  This is where I need input.  What I 
want to do is just lookup the first extent, which will give me all of 
the roots that share the extent range that we are defragging.  Then I 
want to just lookup those inodes, do btrfs_drop_extents and add in the 
new extent, the same way btrfs_finish_ordered_io works.  This will make 
the stitching operation much simpler and less error prone, and much much 
faster.  The drawback is that we need extra checks to make sure the 
inode on the snapshots hasn't changed since we took the snapshot.  So if 
any of that file has been modified, even if none of the data has, we 
won't do anything because we won't be able to verify that it is the same.

This isn't the only way we can do it.  I can fix the stitching part to 
just do one extent at a time across all roots.  This way we're only 
allocating N number of snapshots worth of entries at a time so it keeps 
our allocation low.  The other option is to just do one root at a time 
and process each extent.  Either of these will be fine and reduce our 
memory usage but will be pretty disk io intensive.

=== Summary and what I need ===

Option 1: Only relink inodes that haven't changed since the snapshot was 
taken.

Pros:
-Faster
-Simpler
-Less duplicated code, uses existing functions for tricky operations so 
less likely to introduce weird bugs.

Cons:
-Could possibly lost some of the snapshot-awareness of the defrag.  If 
you just touch a file we would not do the relinking and you'd end up 
with twice the space usage.

Option 2: Process each root one extent at a time in whatever way results 
in less memory usage.

Pros:
-Maximizes the space reduction of the snapshot-aware defrag.  Every 
extent that is the same as the original will be replaced with the new 
extent and all will be well with the world.

Cons:
-Way slower.  We'll have to walk and check every extent to make sure we 
can actually replace it.  This is how it used to work so we'd be 
consistent with the 2 or 3 releases where we had snapshot-aware defrag 
enabled.

-More complicated.  We have to do a lot of extra checking and such, new 
code, possibility for bugs to show up.

So tell me which one you want and I'll do that one.  If you want Option 
2 please explain your use case so I can keep it in mind when deciding on 
how to go about making the memory usage suck less.  Thanks,

Josef
