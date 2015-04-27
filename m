Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37324 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932795AbbD0OmH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 10:42:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YmkET-0002ol-QY
	for linux-btrfs@vger.kernel.org; Mon, 27 Apr 2015 16:42:02 +0200
Received: from 168.159.160.54 ([168.159.160.54])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 16:42:01 +0200
Received: from toyours_sridhar by 168.159.160.54 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 16:42:01 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: Re: btrfs freeze/thaw when using with LVM2
Date: Mon, 27 Apr 2015 14:41:41 +0000 (UTC)
Message-ID: <loom.20150427T163556-13@post.gmane.org>
References: <loom.20150427T140306-446@post.gmane.org> <20150427121521.GB18187@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills <hugo <at> carfax.org.uk> writes:

> 
> On Mon, Apr 27, 2015 at 12:05:28PM +0000, sri wrote:
> > Hi,
> > 
> > I would like to know if btrfs file system is created on LVM2 logical 
> > volumes, does freeze and thaw operations takes place for btrfs to 
make 
> > file system consistent??
> 
>    No, because the filesystem is *always* consistent, because of the
> way that the CoW update mechanism works.
> 
> > If not is there a way (ioctl etc..) to run btrfs freeze/thaw before 
and 
> > after creating LVM2 snapshot of a btrfs file system?
> 
>    As I said above, none is needed.
> 
>    HOWEVER, you shouldn't take LVM snapshots of a btrfs filesystem AT
> ALL, if you have the original FS mounted on that system, or if you
> plan on mounting the FS or its snapshots on that system. It's fine if
> the only things mounting it are independent of the base system, and
> don't see the snapshots (e.g. you're exporting LVs as block devices to
> a VM host, and the snapshot is never seen by the VM; or you're
> exporting LVs via NBD, and the remote system never sees the
> snapshot).
> 
>    If, on the other hand, you're expecting to have /dev/mapper/foo
> mounted, and then take a snapshot of it on the same system, you can
> expect massive filesystem corruption, because the kernel can't
> distinguish between the original block device and the snapshot, and
> may try using the wrong one (or possibly both).
> 
>    Hugo.
> 

:) Thank you for your input. Past couple of hours, i am unable to figure 
it out what is happening with snapshot.

I am experiencing similar what you have explained.
taken a lvm snapshot using lvcreate of /dev/mapper/foo name 
/dev/mapper/foo-snap.

/dev/mapper/foo is mounted on /b1
and I have mounted /dev/mapper/foo-snap on /b2

after running mount command, i have seen there is a change in the mount 
entries. i.e. for both /b1 , /b2 mount point is changed to 
/dev/mapper/foo-snap.

And any write to original or to snap shot are reflecting on both.

This is strange considering that I wanted a consistent snapshot of 
entire btrfs filesystem at volume level.

Is there a way to achive this? or btrfs just cannot provide?

I am looking for a way make entire btrfs (which includes subvolumes in 
it) consistent so that I can take backup of the file system.



