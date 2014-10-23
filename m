Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:44238 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754609AbaJWSgZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 14:36:25 -0400
Message-ID: <54494AA6.60804@pobox.com>
Date: Thu, 23 Oct 2014 11:36:22 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Promote Snapshot to Subvolume? (again)
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'll ask again...

Is there any reason it would be Bad™ to allow a snapshot subvolume to be 
"promoted" to a non-snapshot subvolume?

I know that there is precious little difference between the two. But 
there _is_ a difference once you start trying to automate system 
maintenance.

What I want is a "btrfs property set /path snapshot false" that would 
change the subvolume root such that it looked like it had been made with 
"btrfs subvol create" instead of "btrfs subvol snapshot".


LONG BORING JUSTIFICATION:


One of my actual systems:

Gust ~ # btrfs sub list /
ID 256 gen 571944 top level 5 path home
ID 574 gen 571944 top level 5 path var/tmp
ID 962 gen 262649 top level 5 path BACKUP-2014-06-18
ID 963 gen 262648 top level 256 path home_BACKUP-2014-06-18
ID 964 gen 330331 top level 5 path BACKUP-2014-07-15
ID 965 gen 330331 top level 256 path home_BACKUP-2014-07-15
ID 970 gen 443923 top level 5 path BACKUP-2014-09-01
ID 971 gen 443924 top level 256 path home_BACKUP-2014-09-01

Gust ~ # btrfs sub list -s /
ID 962 gen 262649 cgen 262642 top level 5 otime 2014-06-18 02:25:33 path 
BACKUP-2014-06-18
ID 963 gen 262648 cgen 262646 top level 256 otime 2014-06-18 02:27:38 
path home_BACKUP-2014-06-18
ID 964 gen 330331 cgen 330330 top level 5 otime 2014-07-15 18:51:18 path 
BACKUP-2014-07-15
ID 965 gen 330331 cgen 330331 top level 256 otime 2014-07-15 18:51:26 
path home_BACKUP-2014-07-15
ID 970 gen 443923 cgen 443922 top level 5 otime 2014-09-01 04:04:14 path 
BACKUP-2014-09-01
ID 971 gen 443924 cgen 443924 top level 256 otime 2014-09-01 04:04:36 
path home_BACKUP-2014-09-01

With these two listings I can now automatically classify which elements 
of the system are vital and which are redundant. E.g. which are "live" 
and which are part of the backup scheme. (more-so with consideration for 
read-only status but that's an aside.)


So clearly, in this instance, I did a mkfs.btrfs on the device to create 
/, and a "btrfs subvol create" to make /home and /var/tmp

I want to make a an automatic snapshot and roll backup script that uses 
the diff of these two outputs to decide what to snapshot and what to 
age. No big deal. Works fine.

But when I come to the _restore_ operation it all falls apart. If, say, 
I need to recreate /home from /home_BACKUP-2014-09-01 I _can_ delete the 
/home subvol, then make a non-read-only snapshot of 
/home_BACKUP-2014-09-01 into /home and the system is back in 
configuration...

BUT...

 From that moment on the backup script would be broken because the 
"restore-shot" (ha ha) is now going to show up in "btrfs sub list -s /" 
where it would be excluded from being snapshotted and where it would be 
subject to aging and eventual removal unless I rewrote the script.

ASIDE: I can custom write the script for the box, but there are more 
boxes involved in the target roll-out. I could use naming conventions. I 
could do a lot of things, but they'd become far more per-system specific.

ALSO: I know I could btrfs create /home and then copy the contents of 
the relevant snapshot, but that now purturbs the long tail of metadata 
for the more constant data.

So The Questions:

Does the "snapshotness" of a subvolume have any actual _ongoing_ purpose 
once it has been created?

Is there a reason _not_ to be able to de-snapshot a subvolume?

I fully understand that changing the property would be a one-way 
operation since restoring the removed plumbing would be indeterminate.

-- Rob
