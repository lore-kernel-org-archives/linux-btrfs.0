Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:34102 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbdDCOIo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Apr 2017 10:08:44 -0400
Subject: Re: Need some help: "BTRFS critical (device sda): corrupt leaf, slot
 offset bad: block"
To: Robert Krig <robert.krig@render-wahnsinn.de>, linux-btrfs@vger.kernel.org
References: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <c304c651-88fc-4699-3518-c4e83095d9c0@mendix.com>
Date: Mon, 3 Apr 2017 16:08:41 +0200
MIME-Version: 1.0
In-Reply-To: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/03/2017 12:11 PM, Robert Krig wrote:
> Hi guys, I seem to have run into a spot of trouble with my btrfs partition.
> 
> I've got 4 x 8TB in a RAID1 BTRFS configuration.
> 
> I'm running Debian Jessie 64 Bit, 4.9.0-0.bpo.2-amd64 kernel. Btrfs
> progs version v4.7.3
> 
> Server has 8GB of Ram.
> 
> 
> I was running duperemove using a hashfile, which seemed to have run out
> space and aborted. Then I tried a balance operation, with -dusage
> progressively set to 0 1 5 15 30 50, which then aborted, I presume that
> this caused the fs to mount readonly. I only noticed it somewhat later.

The balance probably did not cause the issue, but it ran across the
invalid metadata page, while digging around in the filesyste and then
choked on it.

> I've since rebooted, and I can mount the filesystem OK, but after some
> time (I presume caused by reads or writes) it once again switches to
> readonly.
> 
> I tried unmounting/remounting again and running a scrub, but the scrub
> aborts after some time.
> 
> 
> Here is the output from the kernel when the partition crashes:
> 
> Apr 03 11:32:57 atlas kernel: BTRFS info (device sda): The free space
> cache file (37732863967232) is invalid. skip it
> Apr 03 11:33:46 atlas kernel: BTRFS critical (device sda): corrupt leaf,
> slot offset bad: block=38666170826752, root=1, slot=157
> [...]

Note: The root=1 is a lie? Looking at the output of btrfs-debug-tree
below, this is definitely a tree block of tree 2, not 1. I have seen
this more often, but not looked at the code yet. Maybe some bug in
assembling the error message?

> I tried running a btrfs-debug-tree -b 38666170826752 /dev/sda
> 
> btrfs-progs
> v4.7.3                                                                                                                                        
> 
> leaf 38666170826752 items 199 free space 1506 generation 1248226 owner
> 2                                                                                  
> 
> fs uuid
> 8c4f8e26-3442-463f-ad8a-668dfef02593                                                                                                              
> 
> chunk uuid
> 1f04f64e-0ec8-4b39-83d9-a2df75179d3e                                                                                                           
> 
>         item 0 key (23416295448576 EXTENT_ITEM 36864) itemoff 16230
> itemsize
> 53                                                                           
> 
>                 extent refs 1 gen 671397 flags
> DATA                                                                                                       
> 
>                 extent data backref root 5 objectid 4959957 offset 0
> count
> 1                                                                              
> 
> [...]

The corruption is at item 157. Can you attach all of the output, or
pastebin it?

> this goes on and on.  I can provide the entire output if thats helpful.

Yes. The corruption is in item 157, and then from the point of the
itemoff value. This is the offset of the item data in the metadata page.
See https://btrfs.wiki.kernel.org/index.php/On-disk_Format#Leaf_Node

> Any ideas on what I could do to fix the partition? Is it fixable, or is
> it a lost cause?

Memory corruption, not on disk corruption.

So, either a bitflip, or garbage which ended up on this memory location
for whatever reason or a bug in whatever part of the kernel, a pointer
in another module gone wonky, etc, which we might learn more about after
seeing more of the output.


-- 
Hans van Kranenburg
