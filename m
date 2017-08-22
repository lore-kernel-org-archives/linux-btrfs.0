Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34222 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932329AbdHVPDr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 11:03:47 -0400
Received: by mail-io0-f176.google.com with SMTP id g135so24291281iog.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 08:03:47 -0700 (PDT)
Subject: Re: finding root filesystem of a subvolume?
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <22940.17147.756378.347580@tree.ty.sabi.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <62494c0c-0c27-5b36-3727-b8755eb2cb58@gmail.com>
Date: Tue, 22 Aug 2017 11:03:44 -0400
MIME-Version: 1.0
In-Reply-To: <22940.17147.756378.347580@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-22 10:43, Peter Grandi wrote:
>> How do I find the root filesystem of a subvolume?
>> Example:
>> root@fex:~# df -T
>> Filesystem     Type  1K-blocks      Used Available Use% Mounted on
>> -              -    1073740800 104244552 967773976  10% /local/.backup/home
> [ ... ]
>> I know, the root filesystem is /local,
> 
> That question is somewhat misunderstood and uses the wrong
> concepts and terms. In UNIX filesystems a filesystem "root" is a
> directory inode with a number that is local to itself, and can
> be "mounted" anywhere, or left unmounted, and that is a property
> of the running system, not of the filesystem "root". Usually
> UNIX filesystems have a single "root" directory inode.
> 
> In the case of Btrfs the main volume and its subvolumes all have
> filesystem "root" directory inodes, which may or may not be
> "mounted", anywhere the administrators of the running system
> pleases, as a property of the running system. There is no fixed
> relationship between the root directory inode of a subvolume and
> the root directory inode of any other subvolume or the main
> volume.
Actually, there is, because it's inherently rooted in the hierarchy of 
the volume itself.  That root inode for the subvolume is anchored 
somewhere under the next higher subvolume.  It's the same concept as 
nested data-sets in ZFS, BTRFS just inherently exposes them at the 
appropriate location in the hierarchy and allows intermediary directories.
> 
> Note: in Btrfs terminology "volume" seems to mean both the main
> volume and the collection of devices where it and subvolumes are
> hosted.
Standard terminology from what I've seen uses 'volume' in the same way 
it's used for ext4, XFS, LVM, MD, and similar things, namely a BTRFS 
'volume' is the collection of devices as well as the sum total of all 
subvolumes on those devices.  This ends up meaning that it implicitly 
refers to the top-level subvolume when there are no other subvolumes, 
and as a result it's come to sometimes mean the top-level subvolume 
(though I rarely see that usage, and would actively discourage it).
> 
>> but who can I show it by command?
> 
> The system does not keep an explicit record of which Btrfs
> "root" directory inode is related to which other Btrfs "root"
> directory inode in the same volume, whether mounted or
> unmounted.
Again, it does, it's just not inherently exposed to userspace unless you 
mount the top-level subvolume (subvolid=5 and/or subvol=/ in mount 
options).  Mount the top level subvolume (once you know what volume the 
subvolume is on), and call `btrfs subvolume list` on it.  The `top level 
N` part of the output from that tells you what the next subvolume up the 
hierarchy is for each subvolume, and the `path` part at the end tells 
you the location within that next higher subvolume where this one is 
rooted.  The output may not make sense though if you don't have the root 
subvolume mounted (because it may be non trivial to trace things up the 
tree).
> 
> That relationship has to be discovered by using volume UUIDs,
> which are the same for the main subvolume and the other
> subvolumes, whether mounted or not, so one has to do:
> 
>    * For the indicated mounted subvolume "root" read its UUID.
>    * For every mounted filesystem "root", check whether its type
>      is 'btrfs' and if it is obtain its UUID.
>    * If the UUID is the same, and the subvolume id is '5', that's
>      the main subvolume, and terminate.
>    * For every block device which is not mounted, check whether it
>      has a Btrfs superblock.
>    * If the type is 'btrfs' and the volume UUIS is the same as
>      that of the subvolume, list the block device.
> 
> In the latter case since the main volume is not mounted the only
> way to identify it is to list the block devices that host it.
Or alternatively, repeatedly call `btrfs filesystem show` on the path, 
removing one component from the end each time until you get a zero 
return code.  The path you called it on that got a zero return code is 
where the mount is (and thus what filesystem that subvolume is part of), 
and the output just gave you a list of devices it's on.
