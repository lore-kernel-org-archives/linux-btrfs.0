Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:36275 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3CEOxs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Mar 2013 09:53:48 -0500
Message-ID: <513606FC.10302@giantdisaster.de>
Date: Tue, 05 Mar 2013 15:53:48 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: dsterba@suse.cz, Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] during balance operation, WARNING: at fs/btrfs/relocation.c:1624
 replace_file_extents+0x74b/0x7e0 [btrfs]()
References: <5134D8D7.9000501@giantdisaster.de> <20130305143633.GB21081@twin.jikos.cz>
In-Reply-To: <20130305143633.GB21081@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 5 Mar 2013 15:36:33 +0100, David Sterba wrote:
> On Mon, Mar 04, 2013 at 06:24:39PM +0100, Stefan Behrens wrote:
>> Just ran the following command sequence and got lots of WARNINGs.
>> The issue is reproducible.
>> The box was running the cmason/for-linus that made it into Linux 3.9 RC1.
>>
>> #!/bin/sh
>> mkfs.btrfs -f /dev/sdl /dev/sdk -m raid1 -d raid1 -l 16384
>> mount /dev/sdl /mnt
>> dd if=/dev/urandom of=/mnt/urandom.1GB bs=10M count=100 &
>> dd if=/dev/zero of=/mnt/zero.4GB bs=10M count=400 &
>> (cd ~/kernel-src; tar cf - fs) | (cd /mnt && tar xf -)
>> wait
>>
>> ((cd ~/kernel-src; tar cf - drivers) | (cd /mnt && tar xf -)) &
>> sleep 5
>> btrfs fi balance start /mnt
> 
> Does the balance finish, report progress or is cancellable?
> 
> What I see here is 0% after many minutes. I've filled the fs with a few
> 4GB files as above, otherwise there are kernel sources compiled (ie.
> files < 256M) and balance used to run fine there.

It is not cancellable and did not make any progress.

In the good case (without that commit), it looks like this:
btrfs: relocating block group 6471811072 flags 17
btrfs: found 2 extents
btrfs: found 2 extents
btrfs: relocating block group 5398069248 flags 17
btrfs: found 1024 extents
btrfs: found 1024 extents
btrfs: relocating block group 4324327424 flags 17
btrfs: found 115 extents
btrfs: found 115 extents
btrfs: relocating block group 3250585600 flags 17
btrfs: found 829 extents
btrfs: found 829 extents
btrfs: relocating block group 2176843776 flags 17
btrfs: found 186 extents
btrfs: found 186 extents
btrfs: relocating block group 1103101952 flags 17
btrfs: found 880 extents
btrfs: found 880 extents
btrfs: relocating block group 29360128 flags 20
btrfs: found 1389 extents
btrfs: relocating block group 20971520 flags 18
btrfs: found 1 extents
btrfs: relocating block group 12582912 flags 1
btrfs: relocating block group 4194304 flags 4

With the commit included, it looks like this:
btrfs: relocating block group 6471811072 flags 17
btrfs: found 2 extents
WARNING: at fs/btrfs/relocation.c:1624 replace_file_extents+0x753/0x7f0 [btrfs]()
WARNING: at fs/btrfs/relocation.c:1624 replace_file_extents+0x753/0x7f0 [btrfs]()
btrfs: found 2 extents
WARNING: at fs/btrfs/relocation.c:1624 replace_file_extents+0x753/0x7f0 [btrfs]()
WARNING: at fs/btrfs/relocation.c:1624 replace_file_extents+0x753/0x7f0 [btrfs]()
btrfs: found 2 extents
WARNING: at fs/btrfs/relocation.c:1624 replace_file_extents+0x753/0x7f0 [btrfs]()
WARNING: at fs/btrfs/relocation.c:1624 replace_file_extents+0x753/0x7f0 [btrfs]()
btrfs: found 2 extents...
do {"btrfs: found 2 extents", "WARNING", "WARNING"} until the log overflows and someone reboots the box.


