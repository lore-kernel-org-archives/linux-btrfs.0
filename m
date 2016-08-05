Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36571 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946874AbcHEUE2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Aug 2016 16:04:28 -0400
Received: by mail-wm0-f68.google.com with SMTP id x83so5138177wma.3
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Aug 2016 13:04:27 -0700 (PDT)
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: Lutz Vieweg <lvml@5t9.de>, "cheater00 ." <cheater00@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, russell@coker.com.au
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
 <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk>
 <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk>
 <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
 <5693A8B3.2090508@gmail.com>
 <CA+9GZUjj8a=drg7--p-f02+QXLo7aWMyZd3O8TA9gTyGWb3MLA@mail.gmail.com>
 <CA+9GZUg-6WrQTgCw_AmVb2qqr4aL4xeWH6mSq1zQ14qbxextzA@mail.gmail.com>
 <CA+9GZUgb=h9_t5fXH-qP_-MwKkoN4xLhhYNnCthccA114+KaeQ@mail.gmail.com>
 <57A372F3.5090400@5t9.de>
From: Gabriel C <nix.or.die@gmail.com>
Message-ID: <5ee26e48-d949-502e-5884-6369c9e6b278@gmail.com>
Date: Fri, 5 Aug 2016 22:03:43 +0200
MIME-Version: 1.0
In-Reply-To: <57A372F3.5090400@5t9.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 04.08.2016 18:53, Lutz Vieweg wrote:
> 
> I was today hit by what I think is probably the same bug:
> A btrfs on a close-to-4TB sized block device, only half filled
> to almost exactly 2 TB, suddenly says "no space left on device"
> upon any attempt to write to it. The filesystem was NOT automatically
> switched to read-only by the kernel, I should mention.
> 
> Re-mounting (which is a pain as this filesystem is used for
> $HOMEs of a multitude of active users who I have to kick from
> the server for doing things like re-mounting) removed the symptom
> for now, but from what I can read in linux-btrfs mailing list
> archives, it pretty likely the symptom will re-appear.
> 
> Here are some more details:
> 
> Software versions:
>> linux-4.6.1 (vanilla from kernel.org)
...
> 
> dmesg output from the time the "no space left on device"-symptom
> appeared:
> 
>> [5171203.601620] WARNING: CPU: 4 PID: 23208 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x263/0x2a0 [btrfs]

....
> ...
>> [5171230.306037] WARNING: CPU: 18 PID: 12656 at fs/btrfs/extent-tree.c:4233 btrfs_free_reserved_data_space_noquota+0xf3/0x100 [btrfs]


Sounds like the bug I hit too also ..

To fix this you'll need :


crazy@zwerg:~/Work/linux-git$ git show 8b8b08cbf
commit 8b8b08cbfb9021af4b54b4175fc4c51d655aac8c
Author: Chris Mason <clm@fb.com>
Date:   Tue Jul 19 05:52:36 2016 -0700

    Btrfs: fix delalloc accounting after copy_from_user faults

    Commit 56244ef151c3cd11 was almost but not quite enough to fix the
    reservation math after btrfs_copy_from_user returned partial copies.

    Some users are still seeing warnings in btrfs_destroy_inode, and with a
    long enough test run I'm able to trigger them as well.

    This patch fixes the accounting math again, bringing it much closer to
    the way it was before the sectorsize conversion Chandan did.  The
    problem is accounting for the offset into the page/sector when we do a
    partial copy.  This one just uses the dirty_sectors variable which
    should already be updated properly.

    Signed-off-by: Chris Mason <clm@fb.com>
    cc: stable@vger.kernel.org # v4.6+

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f3f61d1..bcfb4a2 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1629,13 +1629,11 @@ again:
                 * managed to copy.
                 */
                if (num_sectors > dirty_sectors) {
-                       /*
-                        * we round down because we don't want to count
-                        * any partial blocks actually sent through the
-                        * IO machines
-                        */
-                       release_bytes = round_down(release_bytes - copied,
-                                     root->sectorsize);
+
+                       /* release everything except the sectors we dirtied */
+                       release_bytes -= dirty_sectors <<
+                               root->fs_info->sb->s_blocksize_bits;
+
                        if (copied > 0) {
                                spin_lock(&BTRFS_I(inode)->lock);
                                BTRFS_I(inode)->outstanding_extents++;
