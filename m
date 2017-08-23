Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tty0.vserver.softronics.ch ([91.214.169.36]:33092 "EHLO
        fe1.digint.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753915AbdHWNTF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 09:19:05 -0400
Received: from [10.0.1.10] (77-56-149-155.dclient.hispeed.ch [77.56.149.155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by fe1.digint.ch (Postfix) with ESMTPSA id BEC2C30470
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 15:14:25 +0200 (CEST)
Subject: Re: finding root filesystem of a subvolume?
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <22940.17147.756378.347580@tree.ty.sabi.co.uk>
 <62494c0c-0c27-5b36-3727-b8755eb2cb58@gmail.com>
 <22940.27854.159264.779233@tree.ty.sabi.co.uk>
 <3026f8a6-0ea6-0ed2-41c7-7d25c51a32fe@gmail.com>
From: Axel Burri <axel@tty0.ch>
Message-ID: <391cbefd-80e1-fc3c-d743-c15e6a5e20e4@tty0.ch>
Date: Wed, 23 Aug 2017 15:14:04 +0200
MIME-Version: 1.0
In-Reply-To: <3026f8a6-0ea6-0ed2-41c7-7d25c51a32fe@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-23 14:07, Austin S. Hemmelgarn wrote:
> On 2017-08-22 13:41, Peter Grandi wrote:
> [ ... ]
>> This stupid point relies on ignoring that it is not mandatory to
>> mount the main volume, and that therefore "There is no fixed
>> relationship between the root directory inode of a subvolume and
>> the root directory inode of any other subvolume or the main
>> volume", because the "root directory inode" of the "main volume"
>> may not be mounted at all.
>>
>> This stupid point also relies on ignoring that subvolumes can be
>> mounted *also* under another directory, even if the main volume
>> is mounted somewhere else. Suppose that the following applies:
>>
>>    subvol=5    /local
>>    subvol=383    /local/.backup/home
>>    subvol=383    /mnt/home-backup
>>
>> and you are given the mountpoint '/mnt/home-backup', how can you
>> find the main volume mountpoint '/local' from that?Assuming
>> /mnt/home-backup is mounted and visible in /proc/mounts (your 
> explanation requires it was either mounted directly via a subvol option
> or indirectly via a bind mount), then the following generic method works
> (and should always work on a modern kernel):
> 1. Find it in /proc/mounts or the output of `mount` run without any
> arguments.
> 2. If the mount type is 'bind', the device field will point to the
> source directory.  Using any method you like, figure out what the actual
> mount point that is under is, and repeat from step one with that mount
> point.
> 3. If the mount type is 'btrfs', and 'subvolid=5' is present in the
> mount options (this gets added automatically on any recent kernel), you
> just found the top level subvolume.
> 4. If the mount type is 'btrfs', and 'subvolid=5' is not present in the
> mount options, scan /proc/mounts for other entries with the same device
> value (this is going to be consistent).
> 5. If another entry does exist, and has 'subvolid=5' in the mount
> options, that's the top level subvolume.
> 6. If other entries exist, but 'subvolid=5' not in the mount options for
> any of them, or no other entries exist, the top level volume isn't
> mounted, and you can view it by mounting the device with 'subvolid=5'.
> 
> In the event that you need to know where the next higher level subvolume
> is mounted instead of the root subvolume for the volume, you can use the
> same method, but add the following after step two to figure out what
> subvolid to look for:
> 2b. Run `btrfs subvol show` on the mount point (it by definition has to
> be a subvolume because it's mounted and it's not a bind mount in
> userspace).  Find the 'Top level ID' (note that this just points to the
> next higher subvolume, not the root subvolume) value in the output, and
> use that instead of 5 when looking for 'subvolid=' options.

In order to have a complete view of all mounts, this is what btrbk does
here (which basically matches Austins explanation):

1. Buld a complete tree from:

    # btrfs subvolume list -a -u /mnt/home-backup

2. Correlate all subvolume ID's  with mount points (second column) and
"subvolid=" from mount options:

    # cat /proc/self/mounts

Now you have a complete view of all mounts. In order to query a given
subvolume, fetch "Subvolume ID" (or "UUID") from:

    # btrfs subvolume show /local/.backup/home

see: https://github.com/digint/btrbk/blob/v0.25.1/btrbk
(I apologize that Github has broken display of perl source files at the
time being...)
