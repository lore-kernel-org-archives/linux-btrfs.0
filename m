Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:55088 "EHLO mout2.freenet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932295AbdHVJjX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 05:39:23 -0400
From: g6094199@freenet.de
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to
 find block group for 0
To: linux-btrfs@vger.kernel.org
Cc: rm@romanrm.net
Message-ID: <2bee7fc8-3724-0ade-ed7f-28cc296c0595@chefmail.de>
Date: Tue, 22 Aug 2017 11:31:23 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

He guys,


picking up this old topic cause i'm running into a similar problem.


Running a Ubuntu 16.04 (HWE K4.8) server with 2 nvme SSD as Raid1 as /.
Since one nvme died i had to replace it, where the trouble began. I
replaced the nvme, bootet degraded, added the new disk to the raid
(btrfs dev add) and removed the missing/dead device (btrfs dev del).
Everything worked well. BUT as i rebooted i ran into the "BTRFS RAID 1
not mountable: open_ctree failed, unable to find block group for 0"
because of a MISSING disk?! I checked the btrfs list and found that
there was a patch that enabled a more strict behavior in handing missing
devices (atm cant find the related patch anymore), which was merged some
kernels before k4.8 but was NOT in k4.4. So i managed to install the
k4.4 ubuntu kernel and the system startet booting and working again. So
my pitty is that i cant update to anything after k4.4 with this
production machine. :-(

So 1st should be investigating why did the disk not get removed
correctly? Btrfs dev del should remove the device corretly, right? Is
there a bug?

2nd Was the restriction on handling missing devices to strikt? Is there
a bug?

3rd i saw https://patchwork.kernel.org/patch/9419189/ from Roman. Did he
receive any comments on his patch? This one could help on this problem,
too. 


Regards

Sash

