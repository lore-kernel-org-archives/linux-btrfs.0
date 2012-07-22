Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44398 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab2GVWls (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jul 2012 18:41:48 -0400
Date: Sun, 22 Jul 2012 15:41:45 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        mbroz@redhat.com, Calvin Walton <calvin.walton@kepstin.ca>,
        jeff@deserettechnology.com
Subject: Re: brtfs on top of dmcrypt with SSD -> file access 5x slower than
 spinning disk
Message-ID: <20120722224145.GC12951@merlins.org>
References: <20120202124241.GW16796@shiny>
 <20120718220446.GB3888@merlins.org>
 <20120722185848.GA10089@merlins.org>
 <201207222135.11159.Martin@lichtvoll.de>
 <20120202124241.GW16796@shiny>
 <20120718220446.GB3888@merlins.org>
 <20120722185848.GA10089@merlins.org>
 <201207222135.11159.Martin@lichtvoll.de>
 <20120722204428.GC3925@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120722204428.GC3925@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 22, 2012 at 01:44:28PM -0700, Marc MERLIN wrote:
> On Sun, Jul 22, 2012 at 09:35:10PM +0200, Martin Steigerwald wrote:
> > Or use atop to have a complete system overview during the hdparm run. You 
> > may want to use its default 10 seconds delay.
>  
> atop looked totally fine and showed that a long dd took 6% CPU of one core.
> 
> > Anyway, hdparm is only a very rough measurement. (Test time 2 / 3 seconds 
> > is really short.)
> > 
> > Did you repeat tests three or five times and looked at the deviation?
> 
> Yes. I also ran dd with 1GB, and got the exact same number.

Oh my, the plot thickens.
I'm bringing this back on this list because
1) I've confirmed that I can get 500MB/s unencrypted reads (2GB file)
   with btfrs on the SSD
2) Despite getting a measly 23MB/s reading from /dev/mapper/ssdcrypt,
   once I mount it as a btrfs drive and I a read a file from it, I now
   get 267MB/s
3) Stating a bunch of files on the ssd is very slow (5-6x slower than
   stating the same files from disk). Using noatime did not help.

On an _unencrypted_ partition on the SSD, running du -sh on a directory
with 15K files, takes 23 seconds on unencrypted SSD and 4 secs on
encrypted spinning drive, both with a similar btrfs filesystem, and 
the same kernel (3.4.4).

Since I'm getting some kind of "seek problem" on the ssd (yes, there are
no real seeks on SSD), it seems that I do have a problem with btrfs
that is at least not related to encryption.

Unencrypted btrfs on SSD:
gandalfthegreat:/mnt/mnt2# mount -o compress=lzo,discard,nossd,space_cache,noatime /dev/sda2 /mnt/mnt2
gandalfthegreat:/mnt/mnt2# echo 3 > /proc/sys/vm/drop_caches; time du -sh src
514M	src
real	0m22.667s

Encrypted btrfs on spinning drive:
gandalfthegreat:/var/local# echo 3 > /proc/sys/vm/drop_caches; time du -sh src
514M	src
real	0m3.881s

I've run this many times and get the same numbers.
I've tried deadline and noop on /dev/sda (the SSD) and du is just as slow.  

I also tried with:
- space_cache and nospace_cache
- ssd and nossd
- noatime didn't seem to help even though I was hopeful on this one.

In all cases, I get:
gandalfthegreat:/mnt/mnt2# echo 3 > /proc/sys/vm/drop_caches; time du -sh src
514M	src
real	0m22.537s

22 seconds for 15K files on an SSD while being 5 times slower than a
spinning disk with the same data.
What's going on?




More details below for anyone interested:
----------------------------------------------------------------------------
The test below shows that I can access the encrypted SSD 10x faster by talking
to it through a btrfs filesystem than doing a dd read from the device node.

So I suppose I could just ignore the dd device node thing, however not really.
Let's take a directory with some source files inside:

Let's start with the hard drive in my laptop (dmcrypt with btrtfs)
gandalfthegreat:/var/local# find src | wc -l
15261
gandalfthegreat:/var/local# echo 3 > /proc/sys/vm/drop_caches; time du -sh src
514M	src
real	0m4.068s
So on an encrypted spinning disk, it takes 4 seconds.

On my SSD in the same machine with the same encryption and the same btrfs filesystem,
I get 5-6 times slower:
gandalfthegreat:/mnt/btrfs_pool1/var/local# time du -sh src
514M	src
real	0m24.937s

Incidently 5x is also the speed difference between my encrypted HD and encrypted SSD
with dd.
Now, why du is 5x slower and dd of a file from the filesystem is 2.5x
faster, I have no idea :-/


See below:

1) drop caches
gandalfthegreat:/mnt/btrfs_pool1/var/local/VirtualBox VMs/w2k_virtual# echo 3 > /proc/sys/vm/drop_caches

gandalfthegreat:/mnt/btrfs_pool1/var/local/VirtualBox VMs/w2k_virtual# dd if=w2k-s001.vmdk of=/dev/null
2146631680 bytes (2.1 GB) copied, 8.03898 s, 267 MB/s
-> 267MB/s reading from the file through the encrypted filesystem. That's good.

For comparison
gandalfthegreat:/mnt/mnt2# dd if=w2k-s001.vmdk of=/dev/null 
2146631680 bytes (2.1 GB) copied, 4.33393 s, 495 MB/s
-> almost 500MB/s reading through another unencrypted filesystem on the same SSD

gandalfthegreat:/mnt/btrfs_pool1/var/local/VirtualBox VMs/w2k_virtual# dd if=/dev/mapper/ssdcrypt of=/dev/null bs=1M count=1000
1048576000 bytes (1.0 GB) copied, 45.1234 s, 23.2 MB/s

-> 23MB/s reading from the block device that my FS is mounted from. WTF?

gandalfthegreat:/mnt/btrfs_pool1/var/local/VirtualBox VMs/w2k_virtual# echo 3 > /proc/sys/vm/drop_caches; dd if=w2k-s001.vmdk of=test
2146631680 bytes (2.1 GB) copied, 17.9129 s, 120 MB/s

-> 120MB/s copying a file from the SSD to itself. That's not bad.

gandalfthegreat:/mnt/btrfs_pool1/var/local/VirtualBox VMs/w2k_virtual# echo 3 > /proc/sys/vm/drop_caches; dd if=test of=/dev/null
2146631680 bytes (2.1 GB) copied, 8.4907 s, 253 MB/s

-> reading the new copied file still shows 253MB/s, good.

gandalfthegreat:/mnt/btrfs_pool1/var/local/VirtualBox VMs/w2k_virtual# dd if=test of=/dev/null
2146631680 bytes (2.1 GB) copied, 2.11001 s, 1.0 GB/s

-> reading without dropping the cache shows 1GB/s 

I'm very lost now, any idea what's going on?
- big file copies from encrypted SSD are fast as expected
- raw device access is unexplainably slow (10x slower than btrfs on the
  raw device)
- stating 15K files on the encrypted ssd with btrfs is super slow

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
