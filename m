Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56548 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750877AbaKFT5O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Nov 2014 14:57:14 -0500
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:63825 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XmTBB-002k7m-IP
	for linux-btrfs@vger.kernel.org; Thu, 06 Nov 2014 12:57:13 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: are btrfs snapshot helpful for backing up kvm qcow2 vm?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <545B8D7E.6060606@gmail.com>
Date: Thu, 6 Nov 2014 12:57:12 -0700
Message-Id: <521DD19B-BCB6-4A9C-9605-5ABBFA2F232F@colorremedies.com>
References: <545B8D7E.6060606@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 6, 2014, at 8:02 AM, Francesco Morosinotto <jlord87@gmail.com> wrote:

> Hi guys,
> 
> I need to improve the backup strategy of my vms; At the moment I backup the machines once a week by stopping them, making a snapshot, exporting the xml descriptor file and backing up these files.
> 
> I would prefer a daily online backup solution that allows me to take a snapshot with a minimum downtime.

If I understand it correctly you may be after libvirt's savevm monitor command. There's no possible way filesystem snapshots will include machine state; but then also qcow2 snapshots don't save machine state either, its for offline snapshots of the backing (virtual) block device.


> 
> That's why I was planning to switch from etx4 to btrfs;
> my project will be to  pause the vm, dump the memory and the xml descriptor file, make a snapshot of the subvolume storing the qcow2 file and after that resuming the machine.

Pretty sure online snapshots need to save the entire machine state which includes the local (virtual) block device on which all filesystems are located. It's not enough to just externally snapshot the underlying fs that contains the VM's fs.

> 
> does this project makes any sense? What about performance? Am I going to experience bad performance having qcow2 over btrfs?
> I read on some old (two years) posts that btrfs was having bad fragmentation when dealing with qcow2 files, is this still happening?

I've had good results with btrfs on qcow2 on btrfs, even without xattr +C, even with a lot of fragmentation. But that qcow2 only contained an OS, not any data, I wasn't even compiling kernels within it and such which might expose performance problems others have seen; there's some anecdotal evidence of Windows on NTFS on qcow2 on btrfs being pretty problematic performance and fragmentation wise.


Chris Murphy

