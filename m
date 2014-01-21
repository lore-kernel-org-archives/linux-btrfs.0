Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52364 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbaAUOmb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 09:42:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W5cX8-0001b6-GY
	for linux-btrfs@vger.kernel.org; Tue, 21 Jan 2014 15:42:30 +0100
Received: from router1.itwm.fhg.de ([131.246.191.250])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 15:42:30 +0100
Received: from bernd.schubert by router1.itwm.fhg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 15:42:30 +0100
To: linux-btrfs@vger.kernel.org
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: statfs f_bfree vs. f_bavail
Date: Tue, 21 Jan 2014 15:42:20 +0100
Message-ID: <lbm0vv$k7t$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I just noticed a mismatch between statfs.f_bfree and statfs.f_bavail, i.e.

(squeeze)fslab2:~# ./statfs /data/fhgfs/storage1/

/data/fhgfs/storage1/: avail: 3162112 free: 801586610176

(with 
        uint64_t avail = statbuf.f_bavail * statbuf.f_bsize;
        uint64_t free  = statbuf.f_bfree * statbuf.f_bsize;
)

Given the fact that I write much data to this file system anymore, 
f_bavail seems to be give the number I'm interested in.


According to 'man 2 statfs'

>                fsblkcnt_t   f_bfree;   /* free blocks in fs */
>                fsblkcnt_t   f_bavail;  /* free blocks available to
>                                           unprivileged user */

f_bfree and f_bavail shouldn't differ too much. 
But btrfs uses two entirely different calculations for that
(btrfs_statfs).


f_bavail = disk_with_block_groups_total_ - disk_used - block_group_space + free_data_space
f_bfree = all_disk_blocks - total_used

Now for any raid level (I'm using raid6) using the sum of all
data disk blocks without substracting redundancy blocks doesn't seem
to be something the user is interested in. 
In our particular case we are using f_bavail if fhgfs-storage was started
as root and f_bfree when it started from non-root (extN root user space
reservation). Now with btrfs this entirely fails and even confuses our
low target pool detection. I could add a workaround for btrfs for that
into our code based on f_type, but I wonder if it wouldn't be better to 
improve btrfs_statfs. 
What is the actual intention for the current f_bfree value?


Thanks,
Bernd


