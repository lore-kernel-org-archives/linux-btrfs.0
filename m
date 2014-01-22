Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4114 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbaAVUqQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 15:46:16 -0500
From: Chris Mason <clm@fb.com>
To: "1i5t5.duncan@cox.net" <1i5t5.duncan@cox.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Scrubbing with BTRFS Raid 5
Date: Wed, 22 Jan 2014 20:45:38 +0000
Message-ID: <1390423628.1198.49.camel@ret.masoncoding.com>
References: <95DB9BB3-D706-4023-940A-D100D93D560A@gmail.com>
	 <pan$226f4$e1329373$53c2dcca$438e95e@cox.net>
In-Reply-To: <pan$226f4$e1329373$53c2dcca$438e95e@cox.net>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2014-01-21 at 17:08 +-0000, Duncan wrote:
+AD4- Graham Fleming posted on Tue, 21 Jan 2014 01:06:37 -0800 as excerpted:
+AD4- 
+AD4- +AD4- Thanks for all the info guys.
+AD4- +AD4- 
+AD4- +AD4- I ran some tests on the latest 3.12.8 kernel. I set up 3 1GB files and
+AD4- +AD4- attached them to /dev/loop+AHs-1..3+AH0- and created a BTRFS RAID 5 volume with
+AD4- +AD4- them.
+AD4- +AD4- 
+AD4- +AD4- I copied some data (from dev/urandom) into two test files and got their
+AD4- +AD4- MD5 sums and saved them to a text file.
+AD4- +AD4- 
+AD4- +AD4- I then unmounted the volume, trashed Disk3 and created a new Disk4 file,
+AD4- +AD4- attached to /dev/loop4.
+AD4- +AD4- 
+AD4- +AD4- I mounted the BTRFS RAID 5 volume degraded and the md5 sums were fine. I
+AD4- +AD4- added /dev/loop4 to the volume and then deleted the missing device and
+AD4- +AD4- it rebalanced. I had data spread out on all three devices now. MD5 sums
+AD4- +AD4- unchanged on test files.
+AD4- +AD4- 
+AD4- +AD4- This, to me, implies BTRFS RAID 5 is working quite well and I can in
+AD4- +AD4- fact,
+AD4- +AD4- replace a dead drive.
+AD4- +AD4- 
+AD4- +AD4- Am I missing something?
+AD4- 
+AD4- What you're missing is that device death and replacement rarely happens 
+AD4- as neatly as your test (clean unmounts and all, no middle-of-process 
+AD4- power-loss, etc).  You tested best-case, not real-life or worst-case.
+AD4- 
+AD4- Try that again, setting up the raid5, setting up a big write to it, 
+AD4- disconnect one device in the middle of that write (I'm not sure if just 
+AD4- dropping the loop works or if the kernel gracefully shuts down the loop 
+AD4- device), then unplugging the system without unmounting... and /then/ see 
+AD4- what sense btrfs can make of the resulting mess.  In theory, with an 
+AD4- atomic write btree filesystem such as btrfs, even that should work fine, 
+AD4- minus perhaps the last few seconds of file-write activity, but the 
+AD4- filesystem should remain consistent on degraded remount and device add, 
+AD4- device remove, and rebalance, even if another power-pull happens in the 
+AD4- middle of /that/.
+AD4- 
+AD4- But given btrfs' raid5 incompleteness, I don't expect that will work.
+AD4- 

raid5/6 deals with IO errors from one or two drives, and it is able to
reconstruct the parity from the remaining drives and give you good data.

If we hit a crc error, the raid5/6 code will try a parity reconstruction
to make good data, and if we find good data from the other copy, it'll
return that up to userland.

In other words, for those cases it works just like raid1/10.  What it
won't do (yet) is write that good data back to the storage.  It'll stay
bad until you remove the device or run balance to rewrite everything.

Balance will reconstruct parity to get good data as it balances.  This
isn't as useful as scrub, but that work is coming.

-chris



