Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from neo-zeon.de ([173.228.7.145]:32909 "EHLO neo-zeon.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbbCFBdg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Mar 2015 20:33:36 -0500
Received: from [192.168.75.170] ([97.64.124.16])
	(authenticated bits=0)
	by neo-zeon.de (8.14.9/8.14.9) with ESMTP id t261IS2W052268
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Mar 2015 17:18:29 -0800 (PST)
	(envelope-from cam@neo-zeon.de)
Message-ID: <54F9005D.5070107@neo-zeon.de>
Date: Thu, 05 Mar 2015 17:18:21 -0800
From: Cameron Berkenpas <cam@neo-zeon.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: System crash while scrubbing on 3.18.x
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Sorry for the long email...

I've found my system locks up when scrubbing with 3.18.x, but not with 
3.17.8 across 2 systems.

I have the following BTRFS partitions on system 1:
/  (128GiB, 49GiB used on SSD)
/home (4.2TiB, 624GB used on HDD RAID volume)

I have the following BTRFS partitions on system 2:
/ (196GiB, 17GiB used on HDD RAID volume)
/home (7.1TiB, 2.9TiB used on HDD RAID volume)

My OS is Netrunner 15 (which 98% Kubuntu) on system 1, and up-to-date 
debian testing on system 2.

I've never encountered a lock up while scrubbing /. Just with /home.

The systems never lock up immediately, but takes some time. VERY rarely 
I'll see the lockup when the scrub is at <100GiB completed. Typically it 
happens somewhere between 200-350GiB. A few times it's gone beyond 
500GiB. This is probably why I've never encountered the issue with /, 
it's just not big enough on either system.

Both systems were otherwise idle while performing the scrubs that 
crashed the systems.

/home is on a partition on a RAID10 volume on a 3ware 9740-4i controller 
with 4x 3TB disks on system 1. On system 2, it's the same controller but 
with 4x 4TB disks (and / on system 2 is a partition on the same RAID 
volume rather than a separate disk). Both systems have 32GiB memory, and 
the otherwise the hardware is pretty different between the systems (AMD 
Vs. Intel, etc).

I suspect that the RAID controller probably isn't relevant. Both arrays 
and their drives are healthy.

I've also encountered the issue on a freshly formatted filesystem with 
my data copied from a backup on system 1.

I've tried tried scrubbing with btrfs-progs 3.17 (installed from the 
distribution repos on both systems), and btrfs-progs from git (using tag 
v3.18.x). Neither version made a difference.

In case this is helpful to anyone, here's how I've discovered the issue:
I decided to test btrfs with bcache on system 1 to see if the stability 
had improved since I'd tried bcache+btrfs about a year ago. I backed up 
/home on system 1 and then freshly formatted it and set it to use 
bcache. I was running Linux 3.18.8 and encountered the problem that I've 
described above. I assumed the bcache+btrfs combination was still broken 
so I formatted the system again (this time still using btrfs, but 
without bcache) and copied all my files back. I encountered the same 
issue without bcache. Realizing the issue wasn't bcache related, I did 
ANOTHER format, this time back to bcache+btrfs.

 From here in my testing, I found that system 2 (which has no bcache) 
also crashed when scrubbing with Linux 3.18.8. I decided to try 3.17.8 
on system 1 (since 3.18.8 seemed to be the common denominator between 
the 2 systems), found that fixed the issue, and then downgraded system 2 
to use 3.17.8 as well, which also fixed the issue there.

(Note: At one point I also tried Linux 3.18.7 and 3.18.5, however, those 
kernels are affected by the scrub/crash issue as well.)

I found something else interesting when I tested against Linux 3.19.0. 
With 3.19.0, the bcache system always crashes fairly early in the scrub 
(<100GiB), but the non-bcache system has no issues. This suggests my 
problem with 3.19.0 is a bcache+btrfs issue (or simply an issue with 
bcache).

I'm not sure if bcache is relevant to the BTRFS devs at this point, but 
I thought I'd put that there for anyone who might find that information 
useful.

To summarize:
I've tested with 2 systems, and scrubbing caused crashes occurred on 
both with Linux 3.18.8, but not with 3.17.8 for both systems
I've tested 1 system with and without bcache, and bcache made no 
difference between Linux 3.17.8 and 3.18.8.
I've tested with 3.19.0, and I crash when scrubbing on the bcache 
system, but not the non-bcache system.

Thanks!

-Cameron


