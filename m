Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55444 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751186AbaAERJm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 12:09:42 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:52068 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VzrCl-003gnN-71
	for linux-btrfs@vger.kernel.org; Sun, 05 Jan 2014 10:09:39 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs-transaction blocked for more than 120 seconds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140105063957.GF11749@merlins.org>
Date: Sun, 5 Jan 2014 10:09:38 -0700
Message-Id: <8EE40903-FE21-4516-B2D8-4EB8DCE79376@colorremedies.com>
References: <52C2AE7C.5020601@gmx.at> <pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net> <20140103172506.GA10021@merlins.org> <pan$6ce5a$53830c0$382c1e0e$7169217c@cox.net> <20140105063957.GF11749@merlins.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 4, 2014, at 11:39 PM, Marc MERLIN <marc@merlins.org> wrote:

> 
> Nope, I never posted anything until now. Hopefully you agree that it's
> not ok for btrfs/kernel to just kill my system for over 2H until I power
> it off before of defragging one file. I did hit a severe performance but
> if it's not a never ending loop.
> 
> gandalfthegreat:/var/local/nobck/VirtualBox VMs/Win7# filefrag Win7.vdi 
> Win7.vdi: 156222 extents found
> 
> Considering how virtualbox works, that's hardly surprising.

I haven't read anything so far indicating defrag applies to the VM container use case, rather nodatacow via xattr +C is the way to go. At least for now.

> 
> But doesn't it make sense to see why the kernel is near deadlocking on a
> single file defrag first?

It's better than a panic or corrupt data. So far the best combination I've found, open to other suggestions though, is +C xattr on /var/lib/libvirt/images, creating non-preallocated qcow2 files, and snapshotting the qcow2 file with qemu-img. Granted when sysroot is snapshot, I'm making btrfs snapshots of these qcow2 files. Another option is to make /var/lib/libvirt/images a subvolume, and then when sysroot is snapshot, then /var/lib/libvirt/images is immune to being snapshot automatically with the parent subvolume. I'd have to explicitly snapshot it. This may be a better way to go to avoid accumulation of btrfs snapshots of qcow2 snapshot files.

This may already be a known problem but it's worth sysrq+w, and then dmesg and posting those results if you haven't already.


Chris Murphy

