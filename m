From: cwillu <cwillu@cwillu.com>
Subject: Re: ssd option for USB flash drive?
Date: Thu, 19 May 2011 15:54:23 -0600
Message-ID: <BANLkTinxt3N2_=STRiiJsOAYWEd2-yx_FA@mail.gmail.com>
References: <20110517220252.GA12323@yahoo.fr>
	<201105192104.58726.hka@qbs.com.pl>
	<20110519214721.GA4209@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Hubert Kario <hka@qbs.com.pl>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110519214721.GA4209@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

> [...]
>> aligning logical blocks to erase blocks can give some performance but the only
>> way to make it really fast is not to use USB
> [...]
>
> For something that fits in your pocket and is almost
> universally bootable, there are not so many other options.

An ssd drive in a USB enclosure is about the size of a cell phone,
just a thought.

> I tried changing the alignment on FAT32 and it didn't make
> any difference. Playing with /proc/sys/vm/block_dump, I could see
> chunks of 3, 4, 5 data sectors being written at once regardless
> of the cluster size being used anyway. Interestingly when a user
> process writes to /dev/sdx, block_dump shows 4k writes to
> /dev/sdx only regardless of the size of the user writes while if
> it goes via the filesystem I can see writes of up to 120k. Also,
> I've very little knowledge of what happens at layers below the
> block device (scsi interface, usb-storage, and the device
> controller itself, for instance, I see
> /sys/block/sdi/queue/rotational is 1 for that usb stick, why,
> what does that mean in terms of performance and scheduling of
> read-writes?)

Try with the "ssd_spread" mount option.

> I wonder now what credit to give to recommendations like in
> http://www.patriotmemory.com/forums/showthread.php?3696-HOWTO-Increase-write-speed-by-aligning-FAT32
> http://linux-howto-guide.blogspot.com/2009/10/increase-usb-flash-drive-write-speed.html
>
> Doing a apt-get upgrade on that stick takes hours when the same
> takes a few minutes on an internal drive.

Also, there's a package "libeatmydata" which will provide an
"eatmydata" command, which you can prefix your apt-get commands with.
This will disable the excessive sync calls that dpkg makes, and should
dramatically decrease the time for those sorts of things to finish.
Flash as found in thumb drives doesn't have much in the way of crash
guarantees anyway, so you're not really giving up much safety.
