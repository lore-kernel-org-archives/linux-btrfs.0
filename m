Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:48756 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbaEVP2u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 11:28:50 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id EAF3D36A57D
	for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 17:28:47 +0200 (CEST)
Received: from s9 (7.Red-88-15-60.dynamicIP.rima-tde.net [88.15.60.7])
	by mail.virtall.com (Postfix) with ESMTPSA id 8C4B036A52C
	for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 17:28:47 +0200 (CEST)
Date: Thu, 22 May 2014 16:28:44 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: ditto blocks on ZFS
Message-ID: <20140522162844.268cbed6@s9>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I thought an important idea behind btrfs was that we avoid by design
> in the first place the very long and vulnerable RAID rebuild scenarios
> suffered for block-level RAID...

This may be true for SSD disks - for ordinary disks it's not entirely
the case.

For most RAID rebuilds, it still seems way faster with software RAID-1
where one drive is being read at its (almost) full speed, and the other
is being written to at its (almost) full speed (assuming no other IO
load).

With btrfs RAID-1, the way balance is made after disk replace, it takes
lots of disk head movements resulting in overall small speed to rebuild
the RAID, especially with lots of snapshots and related fragmentation.

And the balance is still not smart and is causing reads from one device,
and writes to *both* devices (extra unnecessary write to the
healthy device - while it should read from the healthy device and write
to the replaced device only).


Of course, other factors such as the amount of data or disk IO usage
during rebuild apply.


-- 
Tomasz Chmielewski
http://wpkg.org
