From: Josef Bacik <josef@redhat.com>
Subject: Re: [mount] commit intervall for metadata and btrfs - is it
	planned ?
Date: Wed, 10 Feb 2010 13:55:37 -0500
Message-ID: <20100210185537.GA20133@localhost.localdomain>
References: <loom.20100210T190536-373@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Mat <jackdachef@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20100210T190536-373@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 10, 2010 at 06:15:26PM +0000, Mat wrote:
> Hi guys,
> 
> First off: you guys are doing amazing work !
> 
> btrfs "Better-FS" gets more and more stable, fast and space-efficient than
> all/most of the other filesystems :)
> 
> 
> It being able to survive compiling of openoffice, chromium webbrowser and other
> stressful stuff is a testament to its ever growing maturity 
> 
> 
> Now on to my question:
> 
> Since I'm using btrfs on more and more test-partitions on my system and also am
> into energy saving:
> 
> is the following mount-option which exists for reiserfs, ext2-4 and reiser4
> (tmgr.atom_max_age) also planned to be implemented for btrfs ?
> 
>        commit=nrsec
>               Sync all data and metadata  every  nrsec  seconds.  The  default
>               value is 5 seconds. Zero means default.
> 
> (in this case ext3)
> 
> if yes, when will it be added ?
> 
> 

It would be simple enough to do, but keep in mind that btrfs doesnt act like
ext2/3 does, so the commit doesn't necessarily mean _all_ data will go down to
disk, just data thats been allocated and writeout has been started on, which is
mostly controlled by the vm's dirty writeback stuff or if the apps you use have
been using fsync().  Any metadata thats been dirtied will be sync'ed every 30
seconds.  Doing much more than that is just widening the window for you to lose
new files and stuff (again, if they've not been fsync()'ed).  Personally 30
seconds is a good balance between being safe and saving battery life, but I'm
sure at some point we'll expose the commit interval via a mount option.  Thanks,

Josef
