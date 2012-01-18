From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [RFC][PATCH 1/2] Btrfs: try to allocate new chunks with degenerated
 profile
Date: Wed, 18 Jan 2012 11:12:20 +0100
Message-ID: <4F169B04.3060200@jan-o-sch.net>
References: <4F154738.8000709@cn.fujitsu.com> <20120117205815.GG3658@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120117205815.GG3658@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 17.01.2012 21:58, Chris Mason wrote:
> These two didn't make my first pull request just because I wanted to get
> something out the door.  I'll definitely have them in the next pull.

Please, don't do that! You can't just degenerate to DUP when RAID1 is
out of space, that's entirely different.

It's debatable whether degeneration from RAID0 to single is acceptable,
but that again has different characteristics.

ENOSPC is the best choice for both in my opinon.

-Jan
