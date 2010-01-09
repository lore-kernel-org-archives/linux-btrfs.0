From: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Subject: Re: How to mount a subvolume?
Date: Sat, 9 Jan 2010 16:09:50 +0100
Message-ID: <20100109160950.07b12bd8@simplux>
References: <20100109150757.1051fd79@simplux>
	<201001091430.39569.dirk.heinrichs@online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: "Dirk Heinrichs" <dirk.heinrichs@online.de>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001091430.39569.dirk.heinrichs@online.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Dirk!

> Does /dev/sda3 actually exist?

/dev/sda3 does exist; it is an btrfs formatted partition containing my root
file system:

> mount
...
/dev/sda3 on / type btrfs (rw,relatime,noacl)
...

Greetings, Michael

@Johannes: I will recreate the /dev/brtfs-control device node in the startup
scripts using the information from /sys/class/misc/btrfs-control/dev - thanks!
