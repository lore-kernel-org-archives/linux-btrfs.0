Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:50273 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaLKMuF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 07:50:05 -0500
Received: from [192.168.10.21] ([83.64.176.131]) by mrelayeu.kundenserver.de
 (mreue001) with ESMTPSA (Nemesis) id 0Lf3PM-1Xajul2ibY-00ol2y for
 <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 13:50:03 +0100
Message-ID: <548992FB.9060404@floga.de>
Date: Thu, 11 Dec 2014 13:50:03 +0100
From: =?UTF-8?B?RmxvcmlhbiBHYW1iw7Zjaw==?= <ml@floga.de>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Promote Snapshot to Subvolume? (again)
References: <54494AA6.60804@pobox.com>
In-Reply-To: <54494AA6.60804@pobox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry to come up with an old thread, but I'm really interested if 
something is going on with that idea. It would help in many situations 
if you could "promote" snapshots to "regular" subvolumes.

Let's for example take btrfs-restore: It does not restore snapshots by 
default, which is rather smart, because a snapshot should merely be a 
somewhat older version of an existing subvolume. But let's assume in 
some point in the past, you really messed up your /home and you used a 
snapshot to recreate it, like deleting the dirty /home subvolume and 
snapshotting the latest backup to a writeable /home again. Then, 
whatever the reason be, you see yourself confronted with using the 
btrfs-restore tool. Now per default you cannot restore /home, since it 
is officially a snapshot, but on the other hand, you do not want to 
restore all other snapshots together with /home (without fiddling with 
some regular expression path filter, that is).

To truly achieve the desired outcome, instead of snapshotting a backup 
to /home, you would have had to create a new subvolume /home and to 
reflink-cp all the contents from the snapshot to the new /home. I find 
this somehow irritating, given that snapshotting is almost instantly 
while cp takes quite some time on a big enough /home.

So I hereby want to push this snapshot-promoting request and would be 
interested in the developers' opinions!

-- 
Flo
