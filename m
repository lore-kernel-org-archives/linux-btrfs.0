Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:48318 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755093AbdCaUnm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 16:43:42 -0400
Date: Fri, 31 Mar 2017 22:43:37 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: drop the nossd flag when remounting with -o ssd
Message-ID: <20170331204337.comndlwr5j7o5bqp@angband.pl>
References: <20170331171016.GN4781@twin.jikos.cz>
 <20170331200850.7067-1-kilobyte@angband.pl>
 <ec137980-08d0-77d8-258b-29610a49a13f@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <ec137980-08d0-77d8-258b-29610a49a13f@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 31, 2017 at 10:24:57PM +0200, Hans van Kranenburg wrote:
> >>> How did you test this?
> >>>
> >>> This was also my first thought, but here's a weird thing:
> >>>
> >>> -# mount -o nossd /dev/sdx /mnt/btrfs/
> >>>
> >>> BTRFS info (device sdx): not using ssd allocation scheme
> >>>
> >>> -# mount -o remount,ssd /mnt/btrfs/
> >>>
> >>> BTRFS info (device sdx): use ssd allocation scheme
> >>>
> >>> -# mount -o remount,nossd /mnt/btrfs/
> >>>
> >>> BTRFS info (device sdx): use ssd allocation scheme
> >>>
> >>> That means that the case Opt_nossd: is never reached when doing this?
> > 
> > Seems to work for me:
> > 
> > [/tmp]# mount -onoatime foo /mnt/vol1 
> > [  619.436745] BTRFS: device fsid 954fd6c3-b3ce-4355-b79a-60ece7a6a4e0 devid 1 transid 5 /dev/loop0
> > [  619.438625] BTRFS info (device loop0): disk space caching is enabled
> > [  619.438627] BTRFS info (device loop0): has skinny extents
> > [  619.438629] BTRFS info (device loop0): flagging fs with big metadata feature
> > [  619.441989] BTRFS info (device loop0): creating UUID tree
> > [/tmp]# mount -oremount,ssd /mnt/vol1
> > [  629.755584] BTRFS info (device loop0): use ssd allocation scheme
> > [  629.755589] BTRFS info (device loop0): disk space caching is enabled
> > [/tmp]# mount -oremount,nossd /mnt/vol1
> > [  633.675867] BTRFS info (device loop0): not using ssd allocation scheme
> > [  633.675872] BTRFS info (device loop0): disk space caching is enabled
> 
> Yes, but we're not doing the same thing here.
> 
> You have a file via a loop mount. If I do that, I get the same output as
> you show, the right messages when I remount ssd and nossd.
> 
> My test was lvm based on an ssd. When I mount that, I get the "detected
> SSD devices, enabling SSD mode", and everytime I remount, being it ssd
> or nossd, it *always* says "use ssd allocation scheme".
> 
> So, this needs some more research I guess. It doesn't feel right.

I can't reproduce:

[~]# cat /proc/swaps
Filename				Type		Size	Used	Priority
/dev/sda2                               partition	8822780	0	-1
[~]# swapoff /dev/sda2
[~]# mkfs.btrfs -f /dev/sda2
...
[ 2459.856819] BTRFS info (device sda2): detected SSD devices, enabling SSD mode
[ 2459.857699] BTRFS info (device sda2): creating UUID tree
[ 2477.234868] BTRFS info (device sda2): not using ssd allocation scheme
[ 2477.234873] BTRFS info (device sda2): disk space caching is enabled
[ 2482.306649] BTRFS info (device sda2): use ssd allocation scheme
[ 2482.306654] BTRFS info (device sda2): disk space caching is enabled
[ 2483.618578] BTRFS info (device sda2): not using ssd allocation scheme
[ 2483.618583] BTRFS info (device sda2): disk space caching is enabled

Same partition on lvm:
[ 2813.259749] BTRFS info (device dm-0): detected SSD devices, enabling SSD mode
[ 2813.260586] BTRFS info (device dm-0): creating UUID tree
[ 2827.131076] BTRFS info (device dm-0): not using ssd allocation scheme
[ 2827.131081] BTRFS info (device dm-0): disk space caching is enabled
[ 2828.618841] BTRFS info (device dm-0): use ssd allocation scheme
[ 2828.618845] BTRFS info (device dm-0): disk space caching is enabled
[ 2829.546796] BTRFS info (device dm-0): not using ssd allocation scheme
[ 2829.546801] BTRFS info (device dm-0): disk space caching is enabled
[ 2833.770787] BTRFS info (device dm-0): use ssd allocation scheme
[ 2833.770792] BTRFS info (device dm-0): disk space caching is enabled

Seems to flip back and forth correctly for me.

Are you sure you have this patch applied?

> >> Adding the 'nossd_spread' would be good to have, even if it might be
> >> just a marginal usecase.
> 
> Please no, don't make it more complex if not needed.
> 
> > Not sure if there's much point.  In any case, that's a separate patch.
> > Should I add one while we're here?
> 
> Since the whole ssd thing is a bit of a joke actually, I'd rather see it
> replaces with an option to choose an extent allocator algorithm.
> 
> The amount of if statements using this SSD things in btrfs in the kernel
> can be counted on one hand, and what they actually do is quite
> questionable (food for another mail thread).

Ok, let's fix only existing options for now then.

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
