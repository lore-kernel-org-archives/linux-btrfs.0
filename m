Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:37242 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbdIALrK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 07:47:10 -0400
Received: by mail-io0-f169.google.com with SMTP id d78so14600531ioe.4
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 04:47:10 -0700 (PDT)
Subject: Re: number of subvolumes
To: ein <ein.net@gmail.com>, linux-btrfs@vger.kernel.org
References: <20170822214531.44538589@natsu>
 <20170822165725.GL14804@rus.uni-stuttgart.de>
 <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
 <20170822180155.GM14804@rus.uni-stuttgart.de>
 <22940.31139.194399.982315@tree.ty.sabi.co.uk>
 <20170822204811.GO14804@rus.uni-stuttgart.de>
 <20170823071821.GA28319@rus.uni-stuttgart.de>
 <f75e66d.7ade2c40.15e0e3ced5c@gmail.com> <onkbkk$qs1$1@blaine.gmane.org>
 <22943.4266.793339.528061@tree.ty.sabi.co.uk>
 <20170831064916.GA5783@rus.uni-stuttgart.de>
 <0b8ff573-ae13-121a-dd14-29d0de72ef58@gmail.com>
 <59A81F56.70708@sarach.com.pl> <pan$30aee$f76230b$532de4a7$4d3a9985@cox.net>
 <59A9349E.1000302@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f0708aac-ac36-20f5-7ea7-d6f515813aed@gmail.com>
Date: Fri, 1 Sep 2017 07:47:05 -0400
MIME-Version: 1.0
In-Reply-To: <59A9349E.1000302@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-01 06:21, ein wrote:
> Very comprehensive, thank you. I was asking because I'd like to learn
> how really random writes by VM affects BTRFS (vs XFS,Ext4) performance
> and try to develop some workaround to reduce/prevent it while having
> csums, cow (snapshots) and compression.

I've actually done some significant testing of VM's using BTRFS as 
backing storage, and would suggest the following:

1. Use raw images in sparse files, and expose them to the VM like SSD's 
(so that DISCARD support works).  Assuming your guests actually support 
DISCARD commands, this will save you just as much space as using 
allocate-on-demand formats like qcow2 or VDI, while providing access 
patterns that BTRFS is a bit better at dealing with.  There are a couple 
of specific caveats to doing this however, namely that you can't use the 
regular VirtIO block device when using QEMU, and have to use VirtIO SCSI 
instead, and you'll need smarter tools to copy images around (ddrescue 
is what I would personally suggest, it can handle sparse files 
correctly, and gives you a nice progress indicator).

2. Provide separate disks to the VM for any data you need to store in 
them.  By keeping this separate from the root filesystem's disk, you 
reduce what gets fragmented, and also aren't tied to a particular guest 
OS to the same degree.  As a more concrete example, if you're running a 
database server in a VM, give it a separate disk image for storing the 
database from the one the root filesystem is on.

3. Run with autodefrag on the host system.  Unless you're hitting the 
disks hard from inside the VM, this will actually do a reasonably good 
job of handling fragmentation.

4. Make sure the filesystem you're storing the disk images on has extra 
space.  Ideally, I would set things up so that it has enough room to 
store a second copy of the largest disk image you expect to use.  By 
keeping lots of extra space, you give the allocator in BTRFS more 
opportunity to arrange things intelligently.

5. Defragmet your disk images regularly (even when using autodefrag), 
both inside and outside the VM's.  Ideally, run a full defrag inside the 
VM, then shut it down and defragment the disk image outside the VM. 
Defragmenting inside the VM first will compact free space, which in turn 
means that defragmenting outside the VM will do a better job, and that 
future fragmentation will be less likely.  In general, I'd suggest doing 
this at least monthly (possibly a lot more frequently if you're running 
databases or similar random access workloads in the VM).

6. Avoid using a CoW filesystem inside the VM's.  This sounds odd at 
first, but is actually one of the biggest things you can do to reduce 
fragmentation.  In particular, try to avoid using BTRFS or ZFS on a VM 
disk that is stored on BTRFS, both of them will make usual fragmentation 
problems look nonexistent in comparison.
