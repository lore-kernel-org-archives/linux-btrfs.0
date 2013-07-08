Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47407 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3GHNUm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jul 2013 09:20:42 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A8BB39A0681
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jul 2013 07:20:41 -0600 (MDT)
Date: Mon, 8 Jul 2013 09:20:38 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Thomas Kuther <tom@kuther.net>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Qemu disk images on BTRFS suffer checksum errors
Message-ID: <20130708132038.GG2260@localhost.localdomain>
References: <c48018584d78271b5958df996a72207f@kuther.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <c48018584d78271b5958df996a72207f@kuther.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 08, 2013 at 10:08:46AM +0200, Thomas Kuther wrote:
> Hello,
> 
> I'm about to migrate from VirtualBox to Qemu+VGA-Passthrough. All my virtual
> disk images are stored in a BTRFS subvolume on-top of a MDRAID 1.
> The host runs kernel 3.10, and Qemu 1.5.1. The Testing-VM is a Windows 7
> 64bit, using a RAW virtio disk with cache=none, same happens for qcow2,
> though.
> 
> Using VirtualBox and in the past Vmware workstation I never had issues with
> corrupted diskimages, but now with Qemu all tries ended up with lots of
> errors like:
> 
> [ 4871.863009] BTRFS info (device md10): csum failed ino 687 off 46213922816
> csum 3817758510 private 402306600
> [ 4872.481013] BTRFS info (device md10): csum failed ino 687 off 46213922816
> csum 3817758510 private 402306600
> [ 4904.055514] BTRFS info (device md10): csum failed ino 687 off 46213922816
> csum 4060166193 private 402306600
> [ 4904.748130] BTRFS info (device md10): csum failed ino 687 off 46213922816
> csum 4060166193 private 402306600
> [ 4904.987540] BTRFS info (device md10): csum failed ino 687 off 46213922816
> csum 3817758510 private 402306600
> [ 4905.024700] BTRFS info (device md10): csum failed ino 687 off 46213922816
> csum 3817758510 private 402306600
> [ 4932.497793] BTRFS info (device md10): csum failed ino 687 off 46213922816
> csum 4060166193 private 402306600
> [ 4932.533634] BTRFS info (device md10): csum failed ino 687 off 46213922816
> csum 4060166193 private 402306600
> 
> Trying to copy the disk image elsewhere causes I/O errors at some point.
> 
> I found a thread about the issue
> (http://comments.gmane.org/gmane.comp.file-systems.btrfs/20538) and also a
> bug report against Qemu from Josef Bacik describing the exact same problem:
> https://bugzilla.redhat.com/show_bug.cgi?id=693530 - Josef states it should
> be fixed since quite a while.
> 
> Is this a regression in BTRFS, a problem with my setup (md raid1 layer below
> btrfs), or (still) a bug in Qemu?
> Would cache=writethrough or writeback be an option with BTRFS?
> 

So there were two aspects to that bug, one is the thing I describe where we get
the same buffer for two parts of an iovec on reads.  That part has been fixed.
The second part is where the application will modify the page while it's in
flight, and that hasn't been fixed.  We have a few options here

1) Always double buffer direct io.  Kind of defeats the purpose of direct io.

2) Check the buffer after we've written it to see if it matches the csum we put
down, if not double buffer it and send it down again.  This makes you checksum
the page twice and punishes O_DIRECT users that behave.

I opted for #3 and let this sort of thing happen.  So you can get around it by
doing nodatacow for that particular image which will disable checksumming for
just that file, or you can use cache=writethrough/writeback and that will use
buffered io.  FYI this doesn't happen on _all_ qemu, just on guest OS'es that
don't provide stable pages, so Windows or like old RHEL versions that are on
ext3.  Thanks,

Josef
