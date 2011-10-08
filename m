From: Tomas Carnecky <tom@dbservice.com>
Subject: fixing slow sync(2)
Date: Sat, 08 Oct 2011 17:24:15 +0200
Message-ID: <4E906B1F.6010609@dbservice.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The issue with sync(2) being slow has been known for a while now (I can 
find discussions as early as July 2010). But nobody seems to be willing 
to fix it or even figure out out what the actual problem is. I use btrfs 
on two hosts, and the sync(2) syscall is consistently slow. By slow I 
mean 20 seconds on one and 45(!) seconds on the other. Every single 
time, no exceptions.

Is there anything I can do to help track down the cause? I can test 
patches, trace the kernel or use whatever tool is most helpful.

tom
