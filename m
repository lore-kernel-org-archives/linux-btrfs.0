Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:48173 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156Ab2L2Dmj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Dec 2012 22:42:39 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: corrupt filesystem after snapshots on 3.2
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <201212291414.37552.russell@coker.com.au>
Date: Fri, 28 Dec 2012 20:42:36 -0700
Message-Id: <83E979E5-EC4A-46E8-A4E8-F5937779C239@colorremedies.com>
References: <201212291031.44745.russell+btrfs@coker.com.au> <E14A2E56-6517-4634-ACDD-099C4D2AE315@colorremedies.com> <201212291414.37552.russell@coker.com.au>
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 28, 2012, at 8:14 PM, Russell Coker <russell@coker.com.au> wrote:

> On Sat, 29 Dec 2012, Chris Murphy <lists@colorremedies.com> wrote:
>> Add another disk, or disk partition, to the Btrfs volume. That'll give it
>> more space and hopefully you can back out at that point.
> 
> # df -h /mnt/tmp
> Filesystem              Size  Used Avail Use% Mounted on
> /dev/mapper/rjca-crypt   12G   12G  637M  95% /mnt/tmp
> 
> I didn't expect that to work because the filesystem already reported free 
> space.  I removed the snapshots and had problems during/after the removal so 
> it seemed that there was space.
> 
> # btrfs filesystem show --all-devices
> Label: none  uuid: 0f0b48e9-d2f7-4280-b417-4d1f5a933975
>        Total devices 3 FS bytes used 5.63GB
>        devid    1 size 6.00GB used 6.00GB path /dev/dm-16
>        devid    2 size 6.00GB used 6.00GB path /dev/dm-17
>        devid    3 size 6.00GB used 19.00MB path /dev/dm-18
> 
> However I've added another device and now "du -h" completes without any kernel 
> panic (a major improvement).  Now I'm seeing the above, apparently 19MB used 
> on the new dm-18 device seems to be making all the difference.
> 
> # btrfs subvol list /mnt/tmp
> ERROR: Failed to lookup path for root 0 - No such file or directory
> 
> Strangely I was getting the above error while the btrfs scrub was in progress, 
> but it went away when the scrub finished.  That seems like a bug to me.
> 
> Now the filesystem is now OK and I've copied all the data off it.  The data 
> appears to be all intact (much of it could be verified against another system).


Do you have a 'btrfs fi df /mnt' from before adding another device? And also after. I'm not sure what the pattern is but it seems Btrfs still can get wedged into a space corner with what seems like some space left in (conventional) df, but in fact it's insufficient somehow. For now I think it needs to be given a wide berth, except if you're intentionally trying to poke it with a stick to see what happens. (I like poking things. People too.)


Chris Murphy