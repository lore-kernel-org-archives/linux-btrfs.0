From: Sage Weil <sage@newdream.net>
Subject: snapshot creation
Date: Tue, 12 Jan 2010 11:24:39 -0800 (PST)
Message-ID: <Pine.LNX.4.64.1001121116250.2394@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

What is the motivation behind the two phases of snapshot creation 
(create_pending_snapshot, finish_pending_snapshot)?  Is it just to avoid 
putting a reference to the snap subvol inside the snapped version of the 
subvol (forming a loop)?

If that's the case, I think the problem can be solved in other ways (by 
not following the subvol link if it loops to self, or by also delaying the 
root creation to avoid leaking an unreferenced root).  And the rest of the 
time (when the link is outside the linked-to subvol) committing the root 
and it's reference in one commit.

Unless I'm missing something else?

Thanks-
sage
