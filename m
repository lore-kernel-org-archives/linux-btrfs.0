Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53634 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbaACTxc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jan 2014 14:53:32 -0500
Date: Fri, 3 Jan 2014 09:25:06 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Message-ID: <20140103172506.GA10021@merlins.org>
References: <52C2AE7C.5020601@gmx.at>
 <pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First, a big thank you for taking the time to post this very informative
message.

On Wed, Jan 01, 2014 at 12:37:42PM +0000, Duncan wrote:
> Apparently the way some distribution installation scripts work results in 
> even a brand new installation being highly fragmented. =:^(  If in 
> addition they don't add autodefrag to the mount options used when 
> mounting the filesystem for the original installation, the problem is 
> made even worse, since the autodefrag mount option is designed to help 
> catch some of this sort of issue, and schedule the affected files for 
> auto-defrag by a separate thread.
 
Assuming you can stomach a bit of occasional performance loss due to
autodefrag, is there a reason not to always have this on btrfs
filesystems in newer kernels? (let's say 3.12+)?

Is there even a reason for this not to become a default mount option in
newer kernels?

> The NOCOW file attribute.
> 
> Simple command form:
> 
> chattr +C /path/to/file/or/directory
 
Thank you for that tip, I had been unaware of it 'till now.
This will make my virtualbox image directory much happier :)

> Meanwhile, if there's a point at which the file exists in its more or 
> less permanent form and won't be written into any longer (a torrented 
> file is fully downloaded, or a VM image is backed up), sequentially 
> copying it elsewhere (possibly using cp --reflink=never if on the same 
> filesystem, to avoid a reflink copy pointing at the same fragmented 
> extents!), then deleting the original fragmented version, should 
> effectively defragment the file too.  And since it's not being written 
> into any more at that point, it should stay defragmented.
> 
> Or just btrfs filesystem defrag the individual file..

I know I can do the cp --reflink=never, but that will generate 100GB of
new files and force me to drop all my hourly/daily/weekly snapshots, so 
file defrag is definitely a better option.

> Finally, there's some more work going into autodefrag now, to hopefully 
> increase its performance, and make it work more efficiently on a bit 
> larger files as well.  The goal is to eliminate the problems with 
> systemd's journal, among other things, now that it's known to be a common 
> problem, given systemd's widespread use and the fact that both systemd 
> and btrfs aim to be the accepted general Linux default within a few years.
 
Is there a good guideline on which kinds of btrfs filesystems autodefrag
is likely not a good idea, even if the current code does not have
optimal performance?
I suppose fragmented files that are deleted soon after being written are
a loss, but otherwise it's mostly a win. Am I missing something?
 
Unfortunately, on a 83GB vdi (virtualbox) file, with 3.12.5, it did a
lot of writing and chewed up my 4 CPUs.
Then, it started to be hard to move my mouse cursor and my procmeter
graph was barely updating seconds.
Next, nothing updated on my X server anymore, not even seconds in time
widgets.
But, I could still sometimes move my mouse cursor, and I could sometimes
see the HD light fliker a bit before going dead again. In other words,
the system wasn't fully deadlocked, but btrfs sure got into a state
where it was unable to to finish the job, and took the kernel down with
it (64bit, 8GB of RAM).
I waited 2H and it never came out of it, I had to power down the system
in the end.
Note that this was on a top of the line 500MB/s write Samsung Evo 840 SSD,
not a slow HD.

I think I had enough free space:
Label: 'btrfs_pool1'  uuid: 4850ee22-bf32-4131-a841-02abdb4a5ba6
	Total devices 1 FS bytes used 732.14GB
	devid    1 size 865.01GB used 865.01GB path /dev/dm-0

Is it possible expected behaviour of defrag to lock up on big files?
Should I have had more spare free space for it to work?
Other?

On the plus side, the file I was trying to defragment and hung my system, 
was not corrupted by the process.

Any idea what I should try from here?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
