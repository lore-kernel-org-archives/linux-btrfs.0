From: Arne Jansen <sensille@gmx.net>
Subject: Re: Odd rebalancing behavior
Date: Tue, 05 Apr 2011 09:20:46 +0200
Message-ID: <4D9AC2CE.2050500@gmx.net>
References: <4D999A09.3030008@fedoraproject.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, kernel@lists.fedoraproject.org,
	test@lists.fedoraproject.org
To: Michel Alexandre Salim <salimma@fedoraproject.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D999A09.3030008@fedoraproject.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 04.04.2011 12:14, Michel Alexandre Salim wrote:
> I have an external 4-disk enclosure, connected through USB 2.0 (my
> laptop does not have a USB 3.0 connector, and the eSATA connector
> somehow does not work); it initially had a 2-disk btrfs soft-RAID1 file
> system (both data and metadata are RAID1).
> 
> I recently added two more disks and did a rebalance. To my surprise it
> went past the point where all four disks have the same amount of disk
> usage, and went all the way to the original disks being empty, and the
> new disks having all the data!
> 
> Label: 'media.store'  uuid: 4cfd3551-aa85-4399-b872-9238ddb14c97
> 	Total devices 4 FS bytes used 1.22TB
> 	devid    3 size 1.82TB used 1.24TB path /dev/sdb
> 	devid    4 size 1.82TB used 1.24TB path /dev/sdc
> 	devid    2 size 1.82TB used 8.00MB path /dev/sde
> 	devid    1 size 1.82TB used 12.00MB path /dev/sdd
> 
> Is this to be expected? Would another rebalance fix it, or should I
> force-stop it by shutting down when the disk usage is roughly balanced?

Currently this is expected behavior, as the current allocator doesn't
distribute the chunks evenly. As soon as the round-robin allocator patch
is merged, rebalance will lead to a balanced distribution. It has been
posted to the list with the subject 'quasi-round-robin for chunk
allocation'.
If you test it, some feedback would be nice.

-Arne

> 
> This is on Fedora 15 pre-release, x86_64, fully updated, kernel
> 2.6.38.2-9 and btrfs-progs 0.19-13
> 
> Thanks,
> 

