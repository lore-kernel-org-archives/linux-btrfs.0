Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40224 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaBYDB4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 22:01:56 -0500
Message-ID: <530C0796.4070205@oracle.com>
Date: Tue, 25 Feb 2014 11:01:42 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to identify if a partition containing a btrfs volume is mounted
 and where
References: <CAMU1PDh6crrOW02oqz6jqvG+rAG6W3mb+V=gHEy37FB1q0UpOg@mail.gmail.com> <20140224135702.GG23877@carfax.org.uk>
In-Reply-To: <20140224135702.GG23877@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Thanks Hugo for the heads-up.

>> I am trying to enhance GParted (http://www.gparted.org/) to better
>> support btrfs, specifically multi-device ones.  GParted displays the
>> busy status (mounted or not) and the mount point of each partition.
>>
>> For a single device file system this is easy.  Entry in /proc/mounts
>> for the partition identifies it's mounted and provides the mount
>> point.
>>
>> In the general case for btrfs I don't know how to get from device name
>> containing a btrfs volume to knowing if it's mounted and where?
::
>> btrfs filesystem show can identify the devices in a btrfs,

  if its not for the final sync-up, I had posted a patch which shows
  mount-point in the btrfs fi show -m output that should help you as
  of now, I have plans of revising it later and make it integration
  ready.

 > # mkfs.btrfs /dev/sdb2 /dev/sdb3 /dev/sdb4
 > # mount /dev/sdb2 /mnt/1
 > # btrfs device delete /dev/sdb2 /mnt/1
 >
 > So /dev/sdb2 is no longer part of the file system, but it's still
 > mounted using it.
 >
 > # grep btrfs /proc/mounts
 > /dev/sdb2 /mnt/1 btrfs rw,seclabel,relatime,ssd,space_cache 0 0


  This bug isn't there is the current btrfs-next. I couldn't
  reproduce.


>     Anand posted some kernel patches for an ioctl a few weeks ago that
> would allow you to get hold of the kernel's UUID<->device mapping.

  yes btrfs-devlist is WIP. As of now I am looking for some help
  as in here:

  http://www.spinics.net/lists/linux-fsdevel/msg72861.html
   OR
  http://www.spinics.net/lists/linux-btrfs/msg31784.html

  Team, Any help ? Thanks.

Anand
