From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfsck: doesn't correct errors
Date: Thu, 27 May 2010 14:15:53 -0400
Message-ID: <20100527181553.GF25333@dhcp231-156.rdu.redhat.com>
References: <201005271846.16832@fortytwo.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Adrian von Bidder <avbidder@fortytwo.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201005271846.16832@fortytwo.ch>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 27, 2010 at 06:46:04PM +0200, Adrian von Bidder wrote:
> Heyho!
> 
> (This is using btrfs from Debian's 2.6.32	2.6.32-3-kirkwood kernel (-9 
> package; btrfs tools is v0.19-16-g075587c)
> 
> A few observations about btrfsck:
> 
> a btrfsck run on a 2T volume (4 disks) on a QNAP appliance (512M ram) got 
> killed by Mr. OOM Killer.  Initially, I was quite surprised.  I'm only 
> moderately surprised now since it might well be that I forgot to enable 
> swap.
> 

Yes, btrfsck keeps the entire extent tree in memory, so the bigger the fs, the
more RAM it's going to use.

> A btrfsck run (on a remote machine this time, with nbd) showed quite a few 
> errors like:
> root 268 inode 34001 errors 2000
> root 268 inode 34002 errors 2000
> root 268 inode 34074 errors 2000
> root 268 inode 34102 errors 2000
> root 268 inode 34103 errors 2000
> root 268 inode 34104 errors 2000
> root 268 inode 34132 errors 2000
> root 268 inode 34133 errors 2000
> 
> 2nd observation: am I supposed to know what this means?
> 

No not really, atm it's just for us developers.

> And 3rd observation: btrfsck apparently doesn't correct this kind of error.  
> Running btrfsck again still shows the error.
> 

Yeah btrfsck doesn't fix problems yet.  Thats being worked on.  Thanks,

Josef
