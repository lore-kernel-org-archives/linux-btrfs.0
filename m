Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40403 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbaK3LMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 06:12:02 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xv2Q4-0007kp-Dq
	for linux-btrfs@vger.kernel.org; Sun, 30 Nov 2014 12:12:00 +0100
Received: from 94.250.180.197 ([94.250.180.197])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 12:12:00 +0100
Received: from gour by 94.250.180.197 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 12:12:00 +0100
To: linux-btrfs@vger.kernel.org
From: Gour <gour@atmarama.net>
Subject: pro/cons of raid1 with mdadm/lvm2
Date: Sun, 30 Nov 2014 12:11:47 +0100
Message-ID: <20141130121147.45884217@atmarama>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

recently I was migrating from Debian to openSUSE and wanted to make it
smooth by dismantling my 2x1TB raid-1 array, install SUSE on the 1st
disk, cp /home data, check everything is OK and then add 2nd disk
containing Debian into raid-1 array.

However, in orde to accomplish it I learnt that one cannot simply
degrade mount and use such array like with mdadm, but I had to convert
system with -dconvert=single -mconvert=single which takes some time.

That's why I'm considering to put all my partitions (swap, root with
several subvolumes, home) under LVM2 volumes and then create raid-1
array with mdadm since that would enable to me more easy and quickly
temporarily dismantle raid-1 array, do some data manipulation from one
disk to another (sometimes I use 2nd disk as temporatily storage when
restoring some archived data from tapes etc.) and then resilver raid-1
array.

However, I wonder if there are some 'cons' in having raid-1 partition
under mdadm and not using native mirroring capabilities of btrfs fs?

Let me add that I also want to take advantage of using SUSE's snapshots
features, but I hope that's not the obstacle for the above-mentioned
layout - I'd still use btrfs' snapshot facility.


Sincerely,
Gour

-- 
Whenever and wherever there is a decline in religious practice, 
O descendant of Bharata, and a predominant rise of irreligion — 
at that time I descend Myself.


