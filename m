From: Alex <alex@bpmit.com>
Subject: Re: "not enough space" with "data raid0"
Date: Sat, 17 Mar 2012 13:36:04 +0000 (UTC)
Message-ID: <loom.20120317T141129-14@post.gmane.org>
References: <C52pxfli1uB@helmut.hullen.de> <loom.20120317T131420-684@post.gmane.org> <20120317122522.GD3172@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


> 
>    No, a balance isn't going to help here. RAID-0 requires a minimum
> of 2 chunks in a block group. With two disks, you're only going to be
> able to fill the smallest one before you run out of space.
> 
> > Isn't this going to be a problem for anyone restoring from a backup? Lots of
> > data heading to btrfs without a pause.
> 
>    Again, not the issue here.
> 
>    Hugo.
> 

Thank you HH for the explanation.

What's the 'solution' though to Hugo's situation?
By 'solution' I mean the highest-utility way of dealing with unequal devices
problem in a two or more -up setting.

(I understand that we're violating the expectations of RAID0 and have read the
http://btrfs.ipv5.de/index.php?title=FAQ#How_much_space_do_I_get_with_unequal_devices_in_RAID-1_mode.3F
about RAID1.)

Disks are (were) getting cheaper per MB faster than I could run out of space! So
I have increasing size array of drives - apparently the similar situation as
Hugo (I have three btrfs-ready drives).

I'm struggling how to mkfs.btrfs with this new knowledge whilst resolving it
with the btrfs storage pool concept.

I stress there is a difficulty with my understanding not btrfs.

Kind regards.

Al.

