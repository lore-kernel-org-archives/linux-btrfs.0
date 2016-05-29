Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:33119 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbcE2QeK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 12:34:10 -0400
Received: by mail-vk0-f52.google.com with SMTP id r140so198264815vkf.0
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 09:34:09 -0700 (PDT)
MIME-Version: 1.0
From: Chris Johnson <hittingsmoke@gmail.com>
Date: Sun, 29 May 2016 09:33:49 -0700
Message-ID: <CAMbyGONFW7kRJvNRu3X5p9B0RqTNRzSBYE+XCu=KcaL8KK3n0w@mail.gmail.com>
Subject: Functional difference between "replace" vs "add" then "delete
 missing" with a missing disk in a RAID56 array
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Situation: A six disk RAID5/6 array with a completely failed disk. The
failed disk is removed and an identical replacement drive is plugged
in.

Here I have two options for replacing the disk, assuming the old drive
is device 6 in the superblock and the replacement disk is /dev/sda.

'btrfs replace start 6 /dev/sda /mnt'
This will start a rebuild of the array using the new drive, copying
data that would have been on device 6 to the new drive from the parity
data.

btrfs add /dev/sda /mnt && btrfs device delete missing /mnt
This adds a new device (the replacement disk) to the array and dev
delete missing appears to trigger a rebalance before deleting the
missing disk from the array. The end result appears to be identical to
option 1.

A few weeks back I recovered an array with a failed drive using
'delete missing' because 'replace' caused a kernel panic. I later
discovered that this was not (just) a failed drive but some other
failed hardware that I've yet to start diagnosing. Either motherboard
or HBA. The drives are in a new server now and I am currently
rebuilding the array with 'replace', which is believe is the "more
correct" way to replace a bad drive in an array.

Both work, but 'replace' seems to be slower so I'm curious what the
functional differences are between the two. I thought the replace
would be faster as I assumed it would need to read fewer blocks since
instead of a complete rebalance it's just rebuilding a drive from
parity data.

What are the differences between the two under the hood? The only
obvious difference I could see is that when I ran `replace` the space
on the replacement drive was instantly allocated under 'filesystem
show' while when I used 'device delete' the drive usage slowly crept
up through the course of the rebalance.
