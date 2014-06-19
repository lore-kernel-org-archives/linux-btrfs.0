Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhfb03.myregisteredsite.com ([209.17.115.61]:48789 "EHLO
	atl4mhfb03.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbaFSBAz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:00:55 -0400
Received: from atl4mhob10.myregisteredsite.com (atl4mhob10.myregisteredsite.com [209.17.115.48])
	by atl4mhfb03.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s5J10s3C021249
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 21:00:54 -0400
Received: from mailpod1.hostingplatform.com (atl4obmail02pod1.mgt.hosting.qts.netsol.com [10.30.71.114])
	by atl4mhob10.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s5J10hCS009044
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 21:00:43 -0400
Message-ID: <53A23678.7070806@chinilu.com>
Date: Wed, 18 Jun 2014 18:01:44 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs on whole disk (no partitions)
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
In-Reply-To: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A lot of good comments on this topic already.  I would just add that on 
large (TB) drives, not partitioning can result in some pretty slow mount 
and umount times (even applies to mounting subvolumes).  That is one of 
the frustrating side effects I have noticed with a non-partitioned 4TB 
drive on 32bit dual core pentium system.  Additionally, with one big 
partitionless drive, any serious defect on any part of the drive can 
cost you the whole shebang, while, if partitioned, your loss is limited 
to the affected partition.  I would also re-emphasize something that has 
been mentioned by someone else already, which is that most partitioning 
tools see a non-partitioned drive as being EMPTY, which can pose dangers 
and risk costly mistakes with the push of a button.  So there are 
definitely some trade-offs.

On 06/18/2014 12:29 PM, Daniel Cegiełka wrote:
> Hi,
> I created btrfs directly to disk using such a scheme (no partitions):
>
> dd if=/dev/zero of=/dev/sda bs=4096
> mkfs.btrfs -L dev_sda /dev/sda
> mount /dev/sda /mnt
>
> cd /mnt
> btrfs subvolume create __active
> btrfs subvolume create __active/rootvol
> btrfs subvolume create __active/usr
> btrfs subvolume create __active/home
> btrfs subvolume create __active/var
> btrfs subvolume create __snapshots
>
> cd /
> umount /mnt
> mount -o subvol=__active/rootvol /dev/sda /mnt
> mkdir /mnt/{usr,home,var}
> mount -o subvol=__active/usr /dev/sda /mnt/usr
> mount -o subvol=__active/home /dev/sda /mnt/home
> mount -o subvol=__active/var /dev/sda /mnt/var
>
> # /etc/fstab
> UID=ID    /    btrfs rw,relative,space_cache,subvol=__active/rootvol    0 0
> UUID=ID    /usr    btrfs rw,relative,space_cache,subvol=__active/usr    0 0
> UUID=ID    /home    btrfs rw,relative,space_cache,subvol=__active/home    0 0
> UUID=ID    /var    btrfs rw,relative,space_cache,subvol=__active/var    0 0
>
> Everything works fine. Is such a solution is recommended? In my
> opinion, the creation of the partitions seems to be completely
> unnecessary if you can use btrfs.
>
> I will be grateful for your feedback.
> Best regards,
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

