Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:39189 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306AbaELCRx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 22:17:53 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Josef Bacik <jbacik@fb.com>
Subject: Re: Balance performance problem with 3.14.1
Date: Mon, 12 May 2014 12:17:48 +1000
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <201405081950.23922.russell@coker.com.au> <536BAC5F.60803@fb.com>
In-Reply-To: <536BAC5F.60803@fb.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201405121217.48965.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 9 May 2014, Josef Bacik <jbacik@fb.com> wrote:
> On 05/08/2014 05:50 AM, Russell Coker wrote:
> > I've got a server/workstation (KDE desktop and file server) running
> > kernel 3.14.1 from the Debian package 3.14-trunk-amd64.
> > 
> > It was running well until I decided to do a full balance of the BTRFS
> > RAID-1 array of 3TB SATA disks (which hadn't been balanced before due to
> > previous kernels performing badly with scrub or balance).  I canceled
> > the balance after about 5 days when it had been claiming to be about 65%
> > done for a day while doing a lot of disk IO.

Firstly after writing my previous message but before receiving your message 
the cron job finished and I umounted the filesystem and mounted it again.  
That freed 2G of RAM from cache (according to the "free" command) and the 
filesystem performed a lot better for most tasks (EG running a basic ls 
command didn't give a noticable delay).

Number of files: 2010493
Number of files transferred: 19609
Total file size: 216240165510 bytes
Total transferred file size: 2632884253 bytes
Literal data: 2632483826 bytes
Matched data: 400442 bytes
File list size: 98728269
File list generation time: 0.001 seconds
File list transfer time: 0.000 seconds
Total bytes sent: 452779
Total bytes received: 1743689596

sent 452779 bytes  received 1743689596 bytes  150818.66 bytes/sec
total size is 216240165510  speedup is 123.98

This morning the cron job is running again, above is the rsync output to show 
the nature of the data I'm dealing with.  2M files in 3.2 hours gives 174 
files per second.

> Can I see dmesg/messages for the time that this was running for so long?

It's running now, cp has run for 21 minutes and copied 806/14938 directories, 
5% done so it'll probably take 5 hours.  There is nothing in the kernel 
message log since before the cron job started - that was when I turned off the 
monitor that is USB attached.

Now cp has been running for 2 hours 25 minutes and copied 7180 directories.

> > The cp -rl usually takes something less than 30 minutes (not long enough
> > for me to even notice) but today cp has been running for 5.5 hours and
> > seems to be about 3/5 done (9000/15000 subdirectories linked).
> 
> Sysrq+w while it's running, just one and then wait a while and then
> another.  Thanks,

http://www.coker.com.au/bug/btrfs-slow-cp.gz

I've done a few of those, the log is at the above URL.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
