Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:48906 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197Ab3ACVRo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jan 2013 16:17:44 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Option LABEL
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CO8jDbu9CXB@helmut.hullen.de>
Date: Thu, 3 Jan 2013 14:17:39 -0700
Message-Id: <14FFD425-4B7D-4523-AEAF-527A6B72DCB4@colorremedies.com>
References: <CO8jDbu9CXB@helmut.hullen.de>
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 3, 2013, at 12:59 PM, Helmut Hullen <Hullen@t-online.de> wrote:

>> MBR has no mechanism for labeling the disk itself or the partitions.
>> So /dev/sda cannot have a label or a name.
> 
> 
> Sure?

Yes. MBR itself has no place holder to encode a disk name or partition name.
http://en.wikipedia.org/wiki/Master_boot_record

GPT does allow for partition names, offset 56.
http://en.wikipedia.org/wiki/GUID_Partition_Table#Partition_entries


>   btrfs filesystem label /dev/sdb mylabel

That is a file system label. Hence the command "filesystem label".

> On my system (a bundle of /dev/sdb, /dev/sdc, /dev/sdd)
> 
>        btrfs fi label /dev/sdb mylabel
> 
> only sets the label on the (unmounted) device /dev/sdb. "/dev/sdc" and  
> "/dev/sdd" remain without label.

If I create a two device btrfs file system without a label, and then relabel it, all device members are relabeled - but again this is the wrong language. The devices do not have labels, it's the file system that has the label.

> for labelling an ext2/3/4 partition. Works like a charm, especially for  
> USB disks.

Again, even with ext[234] you are not labeling a  partition. You are labeling a file system. In fact if I use LVM to place /dev/sda /dev/sdb /dev/sdc into a VG, then export that whole VG as one LV, then format it ext4 with label "hellokitty" again that file system is labeled "hellokitty" which spans three devices. The devices are not what's named. Same for md and dmraid devices.

Somehow in your mind you're OK abstracting the LV as a kind of "device" but you're unwilling to consider a Btrfs file system a kind of "device" also. In the case of ext4 on LVM, you're totally OK ignoring the fact that /dev/sda, /dev/sdb, /dev/sdc all have the same label in effect. But somehow it gets your goat when Btrfs is doing the same thing.

Because it's the *filesystem* that's labelled.



Chris Murphy