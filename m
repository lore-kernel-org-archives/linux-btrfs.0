From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BTRFS misdetects NBD (Network Block Devices) as SSD
Date: Mon, 20 Feb 2012 14:03:56 -0500
Message-ID: <20120220190356.GR4078@shiny>
References: <20120221005157.3b9f8db9@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120221005157.3b9f8db9@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 21, 2012 at 12:51:57AM +0600, Roman Mamedov wrote:
> Hello,
> 
> I have noticed I have the following in my dmesg:
> 
> [319769.043163] nbd: registered device at major 43
> [319769.104176]  nbd11: unknown partition table
> [319769.130273] device fsid c2598ff2-1e3e-4edf-ab19-1f7ab41b0160 devid 1 transid 125743 /dev/nbd11
> [319769.130522] btrfs: force lzo compression
> [319769.130528] btrfs: disk space caching is enabled
> [319802.926547] Btrfs detected SSD devices, enabling SSD mode
> 
> The /dev/nbd11 device itself is not an SSD, it's an LVM volume situated on a
> RAID5 array of regular hard drives, exported via NBD from another computer.
> 
> https://en.wikipedia.org/wiki/Network_block_device

Btrfs pulls this information from the rotational flag on the block
device.  A few different devices set this incorrectly, but it's up to
the admin to flag it in /sys/block/xxx if they want something other than
the default.

-chris

