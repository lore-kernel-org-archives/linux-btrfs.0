Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:44035 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIXPyi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Sep 2014 11:54:38 -0400
From: Russell Coker <russell@coker.com.au>
To: Chris Murphy <lists@colorremedies.com>
Reply-To: russell@coker.com.au
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: deleting a dead device
Date: Wed, 24 Sep 2014 13:20:20 +1000
Message-ID: <2293701.Ca0RKo9hr7@russell.coker.com.au>
In-Reply-To: <32D903D8-EF64-4456-BD66-3425D7F7B6DE@colorremedies.com>
References: <201409211139.17295.russell@coker.com.au> <32D903D8-EF64-4456-BD66-3425D7F7B6DE@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 21 Sep 2014 11:05:46 Chris Murphy wrote:
> On Sep 20, 2014, at 7:39 PM, Russell Coker <russell@coker.com.au> wrote:
> > Anyway the new drive turned out to have some errors, writes failed and
> > I've
> > got a heap of errors such as the above.
> 
> I'm curious if smartctl -t conveyance reveals any problems, it's not a full
> surface test but is designed to be a test for (typical?) problems drives
> have due to shipment damage, and doesn't take very long.

Unfortunately I got to your message after sending the defective drive to e-
waste.  But I expect that any test that involves real reads/writes would 
report a failure (if the USB-SATA device supported passing them through) as 
the drive seemed to fail for everything.

> > # btrfs device delete /dev/sdc3 /
> > ERROR: error removing the device '/dev/sdc3' - Invalid argument
> > 
> > It seems that I can't remove the device because removing requires writing.
> 
> What kernel message do you get associated with this? Try using the devid
> instead of /dev/.

I'll keep that in mine.

device delete <dev> [<dev>...] <path>
              Remove device(s) from a filesystem identified by <path>.

The man page has the above text which makes no mention of devid, so I think we 
need a documentation patch for this.

> For future reference, btrfs replace start is better to use than add+delete.
> It's an optimization but it also makes it possible to ignore the device
> being replaced for reads; and you can also get a status on the progress
> with "btrfs replace status". And it looks like it does some additional
> error checking.

Oh yes, I've done this and it works well.  However it doesn't work if the 
replacement is smaller than the device being replaced.

> > Also as an aside, while the stats about write errors are useful, in this
> > case it would be really good if there was a count of successful writes,
> > it would be useful to know if the successful write count was close to 0.
> 
> I think this is for other tools. Btrfs is a file system its responsible for
> the integrity of the data it writes, I don't think it's responsible for
> prequalifying drives.

I agree that it doesn't have to prequalify drives.  But it should expose all 
data it has which can be of use to the sysadmin.  After it was too late I 
realised that I could have used iostat to get stats for the block device.  But 
it would still be nice to have stats from btrfs.

Also btrfs has to deal with the fact that drives may fail at any time.  
Admittedly I was using a drive I knew to be slightly sub-standard (I got it 
free because it gave an error in a client's RAID-Z array).  But sometimes 
drives like that last for years, it's difficult to predict.

> Even a simple dd if=/dev/zero of=/dev/sdc bs=64k count=1600 will write out
> 100MB, and dmesg will show if there are any controller or drive problems on
> writes. You may have to do more than 100MB for problems to show up but you
> get the idea.

True.  But a drive can fail after 101MB.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

