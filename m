Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47434 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbaCQBRx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 21:17:53 -0400
Date: Sun, 16 Mar 2014 18:17:52 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to handle a RAID5 arrawy with a failing drive?
Message-ID: <20140317011752.GV6143@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <99A46301-9C0E-43F0-8415-E23B86FDB5E2@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20140316222026.GU16946@merlins.org>
 <F8E88232-C43A-4BFD-B2A6-411576299531@colorremedies.com>
 <C66D07BC-E0E7-4F3D-8ACD-C3E9E575C629@colorremedies.com>
 <20140316231729.GA29149@merlins.org>
 <85AE52FE-5191-49AF-98A9-380F224A5DA1@colorremedies.com>
 <20140317005145.GZ16946@merlins.org>
 <99A46301-9C0E-43F0-8415-E23B86FDB5E2@colorremedies.com>

On Sun, Mar 16, 2014 at 07:06:23PM -0600, Chris Murphy wrote:
> 
> On Mar 16, 2014, at 6:51 PM, Marc MERLIN <marc@merlins.org> wrote:
> > 
> > 
> > polgara:/mnt/btrfs_backupcopy# btrfs device delete /dev/mapper/crypt_sde1 `pwd`
> > ERROR: error removing the device '/dev/mapper/crypt_sde1' - Invalid argument
> 
> You didn't specify a mount point, is the reason for that error. But also, since you're already effectively degraded with 1 disk you can't remove a 2nd without causing array collapse. You have to add a new device first *and* you have to "rebuild" with balance. Then presumably we can remove the device. But I'm stuck adding so I can't test anything else.

You missed the `pwd` :)
I'm trying to remove the drive that is causing issues, that doesn't make
things worse, does it?
Does btrtfs not know that device is the bad one even thouth it's spamming my
logs continuously about it?

If I add a device, isn't it going to grow my raid to make it bigger instead
of trying to replace the bad device?
In swraid5, if I add a device, it will grow the raid, unless the array is
running in degraded mode.
However, I can't see if btrfs tools know it's in degraded mode or not.

If you are sure adding a device won't grow my raid, I'll give it a shot.

> > (again, the data is irrelevant, I have a btrfs receive on it that has
> > been running for hours and that I'd have to restart, but that's it).
> 
> Well at this point I'd leave it alone because at least for me, device add hangs that command and all other subsequent btrfs user space commands. So for all I know (untested) the whole volume will block on this device add and is effectively useless.

Right. I was hoping that my kernel slightly newer than yours and maybe real
devices would help, but of course I don't know that.

I'll add the new device first after you confirm that there is no chance
it'll try to grow the filesystem :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
