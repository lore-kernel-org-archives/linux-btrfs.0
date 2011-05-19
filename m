From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: ssd option for USB flash drive?
Date: Thu, 19 May 2011 23:12:33 +0100
Message-ID: <20110519221233.GB4209@yahoo.fr>
References: <20110517220252.GA12323@yahoo.fr>
 <201105192104.58726.hka@qbs.com.pl>
 <20110519214721.GA4209@yahoo.fr>
 <BANLkTinxt3N2_=STRiiJsOAYWEd2-yx_FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hubert Kario <hka@qbs.com.pl>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTinxt3N2_=STRiiJsOAYWEd2-yx_FA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-05-19 15:54:23 -0600, cwillu:
[...]
> Try with the "ssd_spread" mount option.
[...]

Thanks. I'll try that.

> > I wonder now what credit to give to recommendations like in
> > http://www.patriotmemory.com/forums/showthread.php?3696-HOWTO-Increase-write-speed-by-aligning-FAT32
> > http://linux-howto-guide.blogspot.com/2009/10/increase-usb-flash-drive-write-speed.html
> >
> > Doing a apt-get upgrade on that stick takes hours when the same
> > takes a few minutes on an internal drive.
> 
> Also, there's a package "libeatmydata" which will provide an
> "eatmydata" command, which you can prefix your apt-get commands with.
> This will disable the excessive sync calls that dpkg makes, and should
> dramatically decrease the time for those sorts of things to finish.
> Flash as found in thumb drives doesn't have much in the way of crash
> guarantees anyway, so you're not really giving up much safety.

Thanks. That's very useful indeed.

Note that if you use that on aptitude/apg-get that means that
the daemons started/restarted in the process will be affected,
but it could be all the better in my case.

Now, with that eatmydata, I'm thinking of trying qemu-nbd -c
/dev/nbd0 /dev/mapper/original-device with that and have the
rootfs mounted on that /dev/nbd0.

That eatmydata could be a work around to the problem I was
mentionning at
https://lists.ubuntu.com/archives/ubuntu-server-bugs/2010-June/037846.html

-- 
Stephane
