From: Sage Weil <sage@newdream.net>
Subject: committing new snapshots
Date: Mon, 7 Dec 2009 14:25:50 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0912071411560.31714@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When you create a new snap or subvol, first a new ROOT_ITEM is created 
while everything commits, and then the referring directory entry is set up 
(with a correspond ROOT_BACKREF).  

First, if you say 'btrfsctl -s foo .' and then 'reboot -f -n' before the 
next regularly scheduled commit, the snap is created, but lost.. there's 
no reference.  Second, the unreferenced ROOT_ITEM is never cleaned up.

Are there any existing plans for this?  It would be nice if the reference 
could be committed as well the first time around.  That probably requires 
a bit of futzing to determine what the root objectid is going to be 
beforehand, then adding the link in the namespace, then flushing things 
out and updating the root item in the right order?

sage
