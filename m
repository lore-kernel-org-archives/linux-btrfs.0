Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36248 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbcD1Cvw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 22:51:52 -0400
Received: by mail-ob0-f176.google.com with SMTP id j9so32486276obd.3
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 19:51:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHaPQf1sJpO6bDWUQFp=XEEwuV8P8-qY7bT0UgZEdbazUUWNTg@mail.gmail.com>
References: <CAHaPQf1sJpO6bDWUQFp=XEEwuV8P8-qY7bT0UgZEdbazUUWNTg@mail.gmail.com>
Date: Wed, 27 Apr 2016 20:51:50 -0600
Message-ID: <CAJCQCtT3tQ=1SopXjbrAp7650z7H9-SpurgpUooCG6A5Kxk-hw@mail.gmail.com>
Subject: Re: ...in the matter of partition size
From: Chris Murphy <lists@colorremedies.com>
To: Juan Alberto Cirez <jacirez@rdcsafety.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 27, 2016 at 2:18 PM, Juan Alberto Cirez
<jacirez@rdcsafety.com> wrote:
> Quick question: Supposed I have n-number of storage pods (physical
> servers with n-number of physical hhds). The end deployment will be
> btrfs at the brick/block level with a distributed file system on top.
> Keeping in mind that my overriding goal is to have high availability
> and the mechanism whereby the lost of a drive or multiple drives in a
> single pod will not jeopardize data.
>>>>>>Question<<<<<
> Does partitioning the physical drives and creating btrfs filesystem on
> each partition, then configuring each partition as individual
> bricks/blocks offer ANY added benefits over grouping the entire pod
> into a drive pool and using that pool as a single block/brick to
> expose to the distributed filesystem?

No.

Distros typically have libblkid, so 'blkid' command will show you
Btrfs is on the drive regardless of partitioning. If the drive might
ever see Windows or OS X, then a partition will tell those OS's the
drive isn't empty, as they will not recognize Btrfs, but will see the
GPT.

Since you mention HA, you need to use something other than Btrfs only.
The device failure notification right now is slim to none with Btrfs,
it's limited really to just kernel messages. So you should looking at
hardware raid, or mdadm, or LVM raid, plus XFS. While XFS does not
offer data checksumming or snapshotting it does offer metadata
checksums in the most recent V5 metadata format.

And then there's this (admittedly rather conservative) disclaimer:
"Btrfs is under heavy development, and is not suitable for any uses
other than benchmarking and review."
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/Documentation/filesystems/btrfs.txt?id=refs/tags/v4.5.2

I include that just to point out you probably shouldn't put all eggs
in one basket.

For Btrfs, mdadm, or lvm raid, you need to make sure that the SCSI
command timer (a kernel setting per block device) is longer than the
drive's SCT ERC setting.

cat /sys/block/<dev>/device/timeout
smartctl -l scterc <dev>

If the command timer is shorter, bad sectors will not get reported as
read errors for proper fixup, instead there will be a link reset and
it's just inevitable there will be worse problems.


-- 
Chris Murphy
