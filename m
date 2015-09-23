Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:41877 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbbIWHYZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 03:24:25 -0400
Received: from wheezy.localnet (ns-local [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id A42C6EB58
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 17:24:23 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS as image store for KVM?
Date: Wed, 23 Sep 2015 17:24:21 +1000
References: <55F88ECC.1040604@menke.ac> <CAJCQCtR_3eiWWmpJHC9RT4EJOzUb_AmrQkkm0X4R0OE4FYUHMQ@mail.gmail.com> <55FC1C09.7030006@gmail.com>
In-Reply-To: <55FC1C09.7030006@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201509231724.21728.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 19 Sep 2015 12:13:29 AM Austin S Hemmelgarn wrote:
> The other option (which for some reason I almost never see anyone
> suggest), is to expose 2 disks to the guest (ideally stored on different
> filesystems), and do BTRFS raid1 on top of that.  In general, this is
> what I do (except I use LVM for the storage back-end instead of a
> filesystem) when I have data integrity requirements in the guest.  On
> the other hand of course, most of my VM's are trivial for me to
> recreate, so I don't often need this and just use DM-RAID via LVm.

I used to do that.  But it was very fiddly and snapshotting the virtual machine 
images required making a snapshot of half a RAID-1 array via LVM (or 
snapshotting both when the virtual machine wasn't running).

Now I just have a single big BTRFS RAID-1 filesystem and use regular files for 
the virtual machine images with the Ext3 filesystem.

On Sun, 20 Sep 2015 11:26:26 AM Jim Salter wrote:
> Performance will be fantastic... except when it's completely abysmal.  
> When I tried it, I also ended up with a completely borked (btrfs-raid1) 
> filesystem that would only mount read-only and read at hideously reduced 
> speeds after about a year of usage in a small office environment.  Did 
> not make me happy.

I've found performance to be acceptable, not great (you can't expect great 
performance from such things) but good enough for lightly loaded servers and 
test systems.

I even ran a training session on BTRFS and ZFS filesystems with the images 
stored on a BTRFS RAID-1 (of 15,000rpm SAS disks).  When more than 3 students 
ran a scrub at the same time performance dropped but it was mostly usable and 
there were no complaints.  Admittedly that server hit a BTRFS bug and needed 
"reboot -nf" half way through, but I don't think that was a BTRFS virtual 
machine issue, rather it was a more general BTRFS under load issue.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
