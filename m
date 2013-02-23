Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moltke.seatribe.se ([178.63.100.209]:33718 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab3BWAqN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 19:46:13 -0500
Received: from [2002:54d9:e26d::1] (helo=nerv.dolda2000.com)
	by moltke.seatribe.se with esmtp (Exim 4.72)
	(envelope-from <fredrik@dolda2000.com>)
	id 1U93Fd-00056p-HQ
	for linux-btrfs@vger.kernel.org; Sat, 23 Feb 2013 01:46:10 +0100
Received: from [2002:54d9:e26d:200:ca60:ff:fe16:97ac] ([IPv6:2002:54d9:e26d:200:ca60:ff:fe16:97ac])
	(authenticated bits=0)
	by nerv.dolda2000.com (8.14.3/8.14.3/Debian-9.4) with ESMTP id r1N0k3Ud008604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 23 Feb 2013 01:46:04 +0100
Date: Sat, 23 Feb 2013 01:46:03 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: linux-btrfs@vger.kernel.org
Subject: Changing allocation mode
Message-ID: <alpine.DEB.2.02.1302230138220.8295@shack.dolda2000.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

I'm still in the process of transferring all the data I have to the btrfs 
filesystem I have had your help in debugging in a previous thread, and I 
have a slight question, if you will humour me.

I have the data I want to transfer on an old ReiserFS partition, 
consisting of 2 mdraid mirrors, one of which consists of two 1.5 TB disks, 
and the other of two 3 TB disks. The btrfs I'm copying the data to 
consists of two 3 TB disks only that I have put in RAID-1 mode, and the 
data on the old filesystem is only slightly larger than 3 TB. I am now at 
the point where I have transferred just under 3 TB.

If I were transferring the data to a new filesystem on mdraid, the 
procedure I would use for that last portion of the data would be to remove 
one disk only from either of the old mdraid mirror arrays (putting that 
array in degraded mode), and then create a new mirror in degraded mode 
with only that disk, add that mirror to the new filesystem, expand it, 
copy the last data, and then delete the old mirrors, moving the rest of 
the disks to the new filesystem.

Is there a way to mirror this procedure in btrfs? I'm not yet quite so 
familiar with all btrfs concepts that I know quite what I'm talking about, 
but I'm guessing that what I want to do is to merely temporarily set the 
allocator to allocate new btrfs on a single disk only, and then add a 
single disk to the filesystem. And then copy the rest of the data, abandon 
the old filesystem and add another disk and rebalance those 
singly-allocated extents to RAID-1 mode.

Have I described a conceptionable idea in saying so? And if so, how does 
one actually do that? I don't know if I'm just blind, but I haven't found 
any btrfs command to change the allocation algorithm without having to 
rebalance the existing data, which seems a bit unnecessary in this case.

Thanks for any help you can offer!

--

Fredrik Tolf
