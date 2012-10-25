Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:35663 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965574Ab2JYUDE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 16:03:04 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50899151.1070503@inwind.it>
Date: Thu, 25 Oct 2012 14:03:02 -0600
Message-Id: <3BC0780A-C657-4195-BBAB-FFBDDBD989FB@colorremedies.com>
References: <50899151.1070503@inwind.it>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 25, 2012, at 1:21 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> 
> Moreover I still didn't understand how btrfs was using the disks.

This comment has less to do with the RFC, and more about user confusion in a specific case of the existing fi df behavior. But since I have the same misunderstanding of how btrfs is using the disks, I decided to reply to this thread.

While working with Fedora 18's new System Storage Manager [1], I came across this problem. For reference the bug report [2] which seems less of a bug with ssm than a peculiarity with btrfs chunk allocation and how fi df report usage.

80GB VDI, Virtual Box VM, containing Fedora 18: installed and yum updated 2-3 times. That's it, yet for some reason, 76 GB of chunks have been allocated and they're all full? This doesn't make sense when there's just under 4GB  of data on this single device.

[root@f18v ~]# btrfs fi show
Label: 'fedora'  uuid: 780b8553-4097-4136-92a4-c6fd48779b0c
	Total devices 1 FS bytes used 3.93GB
	devid    1 size 76.06GB used 76.06GB path /dev/sda1

[root@f18v ~]# btrfs fi df /
Data: total=72.03GB, used=3.67GB
System, DUP: total=8.00MB, used=16.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=2.00GB, used=257.54MB
Metadata: total=8.00MB, used=0.00

I decided to rebalance, and while things become a lot more sensible, I'm still confused:

[chris@f18v ~]$ sudo btrfs fi show
failed to read /dev/sr0
Label: 'fedora'  uuid: 780b8553-4097-4136-92a4-c6fd48779b0c
	Total devices 1 FS bytes used 3.91GB
	devid    1 size 76.06GB used 9.13GB path /dev/sda1

[chris@f18v ~]$ sudo btrfs fi df /
Data: total=5.00GB, used=3.66GB
System, DUP: total=64.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=2.00GB, used=256.84MB

Points of confusion:

1. Why is FS bytes used = 3.91GB, yet devid 1 used is 9.13 GB?

2. Why before a rebalance does 'fi df' show extra lines, and then after rebalance there are fewer lines? Another case with raid10, 'fi df' shows six lines of data, but then after rebalance is shows three lines?

3. How does Data: total=72GB before rebalance, but is 5GB after rebalance? This was a brand new file system, file system installed, with maybe 2-3 updates, and a dozen or two reboots. That's it. No VM's created on that volume (it's a VDI itself), and the VDI file itself never grew beyond 9GB.


Chris Murphy




[1] https://fedoraproject.org/wiki/Features/SystemStorageManager
[2] https://bugzilla.redhat.com/show_bug.cgi?id=869489