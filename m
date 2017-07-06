Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33663 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbdGFPAr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jul 2017 11:00:47 -0400
Date: Thu, 6 Jul 2017 08:00:46 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Cc: pwnall@chromium.org
Subject: Leveldb in google-chrome incompatible with btrfs?
Message-ID: <20170706150046.GB12959@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't know who else uses google-chrome here, but for me, for as long as
I've used btrfs (3+ years now), I've had no end of troubles recovering from
a linux crash, and google-chrome has had problems recovering my tabs and
usually cmoplains about plenty of problems, some are corruption looking.

The way I recover, every time, is to simply rsync over the previous
snapshot's data for ~/.config/google-chrome-dir back over the current
corrupted one, and move on.

I had a bit more look at this with a chrome engineer, and there seems to be
at least a clear problem with leveldb where its file containing the index
name, does not match the files on disk.
Details are in https://bugs.chromium.org/p/chromium/issues/detail?id=738961
but I'll summarize here.


All the files are in a non corrupted state, but I end up with this:
saruman:~/.config/google-chrome-dir/google-chrome-beta/Default/IndexedDB/https_docs.google.com_0.indexeddb.leveldb$ l
(...)
-rw------- 1 merlin merlin      16 Oct  4  2016 CURRENT
-rw------- 1 merlin merlin       0 Apr  9  2016 LOCK
-rw------- 1 merlin merlin       0 Jul  5 22:31 LOG
-rw------- 1 merlin merlin       0 Jul  5 22:31 LOG.old
-rw------- 1 merlin merlin      23 Jul  3 08:31 MANIFEST-000001
-rw------- 1 merlin merlin    8639 May 12 17:36 MANIFEST-022745
saruman:~/.config/google-chrome-dir/google-chrome-beta/Default/IndexedDB/https_docs.google.com_0.indexeddb.leveldb$ cat CURRENT 
MANIFEST-010814

In other words, I think things go like this:
- MANIFEST-010814 is replaced by MANIFEST-022745, 
- MANIFEST-022745 is written into the file CURRENT
- ideally both MANIFEST-010814 and MANIFEST-022745 should be present on disk
  and MANIFEST-010814 deleted only after CURRENT has been written to with
  the new pointer, but I'm not sure if or how that is done.
- my laptop crashes
- after reboot, btrfs has not been able to commit the update to CURRENT to disk
  in a consistent state, therefore discards the COW data to CURRENT and
  leaves it in its prior state, which now holds the old data
- somehow MANIFEST-010814 has however been deleted, so now CURRENT points to
  a non existent file.

I don't know how leveldb works or where its (f)sync statements are. but I'm
guessing it works reliably on ext4 since it's used by many users and I'm the
first one reporting this problem with leveldb.

Does anyone know if it's leveldb relying on non POSIX semantics that just
happen to work out on ext4, or if btrfs COW and atomicity doesn't quite
handle multi file updates in a way that is expected by a spec, or by
application developers?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
