From: Spelic <spelic@shiftmail.org>
Subject: Alignment to MD stripes possible?
Date: Tue, 23 Nov 2010 19:09:50 +0100
Message-ID: <4CEC036E.2010202@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs people
btrfs still does not implement raid5,6 so here comes the question: all 
filesystems have mkfs flags for aligning to an underlying RAID.
Is it there also for btrfs? I don't seem able to find it. Is it 
autodetected for MD/LVM2 like in xfs and ext4?
I think that some people in the enterprise will not give up on their 
hardware arrays so easily... so the option should be available imho.
(Is it feasible at all actually? I don't know cow filesystems much.)
COW features are cool to use even if the RAID is elsewhere and the write 
hole remains...
Thank you
