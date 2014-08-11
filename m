Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55079 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751387AbaHKXbO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 19:31:14 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:50439 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XGz3a-003Tr0-8T
	for linux-btrfs@vger.kernel.org; Mon, 11 Aug 2014 17:31:14 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Large files, nodatacow and fragmentation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140812011401.568c16e6@natsu>
Date: Mon, 11 Aug 2014 17:31:13 -0600
Message-Id: <AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com> <20140812011401.568c16e6@natsu>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 11, 2014, at 1:14 PM, Roman Mamedov <rm@romanrm.net> wrote:


> 
> Second, why qcow2? It can also have internal fragmentation which is unlikely to
> do anything good for performance.

It really depends on what version of libvirt and qemu-image you've got. I did some testing during Fedora 20 prior to release, and the best results for my configuration (a laptop with an HDD at that time): btrfs host, +C qcow2, btrfs guest, both 16KB leaf size, and the drive pointing to the qcow2 file with cache policy set to unsafe. And even when obliterating the VM while writing data, I never lost the guest Btrfs file system. Not that I recommend it, the cache policy is unsafe after all. I did lose some data but it was limited to commit time. We're not talking huge differences, the metric I was using was installing Fedora 20 based on installer log start/stop time for doing the unattended portion of the install. It also matters somewhat to pre-allocate metadata when creating the qcow2 file.

I also tested XFS on XFS, ext4 on ext4, also in qcow2. And also on raw images. And also on LV's. I'd think the LV would have been faster since it completely eliminates one of the file systems (there is no host fs).

Anyway, what I determined was the only way to know is to actually test your workload, or a good approximation of it, with various configurations.

And another test is LVM thinp LV's once libvirt has support for using them (which may already have happened, I haven't revisted this since Oct 2013 testing), because those snapshots should be as usable as Btrfs snapshots, unlike conventional LVM snapshots which are slow and need explicit preallocation.


Chris Murphy

