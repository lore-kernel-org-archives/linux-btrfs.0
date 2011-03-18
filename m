From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: how to backup
Date: Fri, 18 Mar 2011 09:57:16 +0000 (UTC)
Message-ID: <ilva9s$i0$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Say I have a btrfs-formatted disk with many subvolumes/snapshots.

How do I do backup (over network) ?

If I use just rsync, I will get many copies of the files (one for each 
snapshot).

So I would need to write a tool that would
- get listing of the subvolumes/snapshots
- somehow figure out which is which (snapshot of what is this one)
- somehow recursively create the subvolume, copy data, snapshot it, copy
data etc.?

Thank you for your suggestions

Lubos

