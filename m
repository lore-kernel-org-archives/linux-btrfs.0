From: jim owens <owens6336@gmail.com>
Subject: [PATCH V3 00/18] Btrfs: Direct I/O read rebased.
Date: Sun, 21 Mar 2010 23:17:26 -0400
Message-ID: <4BA6E146.10709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Here is the complete direct I/O read patch series
rebased onto the current btrfs-unstable and tested
against 2.6.33.

I have not done clean up of the diocb/extcb and did not
simplify the user memory handling yet.

There still is a problem with the wakeup of the submit
thread in btrfs_dio_wait(). With fsx on a 2-core x86-64
it will eventually hang, as in within 2 hours. Either
I am missing the wakeup or miscounting the done state
and going back to sleep with all I/O finished.

jim
