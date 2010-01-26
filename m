From: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Subject: Re: What's the benefit of COW without checksum?
Date: Wed, 27 Jan 2010 00:44:29 +0100
Message-ID: <20100127004429.01516fbd@simplux>
References: <977a2be21001252315w36afcb39v4ba130f6d8e53707@mail.gmail.com>
	<20100126190705.GB2770@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Zhu Yanhai <zhu.yanhai@gmail.com>, linux-btrfs@vger.kernel.org,
	Yan Zheng <zheng.yan@oracle.com>, austin.zhang@intel.com,
	yong.y.wang@intel.com, bing.wei.liu@intel.com,
	Zhu Yanhai <yanhai.zhu@linux.intel.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100126190705.GB2770@think>
List-ID: <linux-btrfs.vger.kernel.org>

I'm using btrfs for a distribution specialized to be used with USB pen drives.

btrfs ist the first file system (besides nilfs) that is fast enough to be used
with media (flash memory) that has a severe restriction on the number of writes
per second (to be more precise: the number of page deletes per second).

Until now I had to use a layered approached using some kind of union file
system and a ramdisk as the top level layer.

I first testet btrfs last June when it entered the official kernel. At
that time is was much to slow to be used in the described scenario. But the
speedups during the last months made its use possible! :-)

So lots of thanks to Chris Mason and all others who brought us such a
groundbreaking file system. They have done a great piece of work. Yet there's
still a lot to be done, but I'm optimistic that we will end up with a very well
designed file system useable for lots of different application scenarios.

Greetings, Michael
