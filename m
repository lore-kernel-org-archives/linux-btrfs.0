From: Sander <sander@humilis.net>
Subject: Re: SSD optimizations
Date: Mon, 13 Dec 2010 06:11:57 +0100
Message-ID: <20101213051157.GA19543@attic.humilis.net>
References: <1292174654.11248.10.camel@paddy-desktop>
 <4D05630E.7070809@bobich.net>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jarktasaa@gmail.com, linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D05630E.7070809@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

Gordan Bobic wrote (ao):
> On 12/12/2010 17:24, Paddy Steed wrote:
> >In a few weeks parts for my new computer will be arriving. The storage
> >will be a 128GB SSD. A few weeks after that I will order three large
> >disks for a RAID array. I understand that BTRFS RAID 5 support will be
> >available shortly. What is the best possible way for me to get the
> >highest performance out of this setup. I know of the option to optimize
> >for SSD's
> 
> BTRFS is hardly the best option for SSDs. I typically use ext4
> without a journal on SSDs, or ext2 if that is not available.
> Journalling causes more writes to hit the disk, which wears out
> flash faster. Plus, SSDs typically have much slower writes than
> reads, so avoiding writes is a good thing.

Gordan, this you wrote is so wrong I don't even know where to begin.

You'd better google a bit on the subject (ssd, and btrfs on ssd) as much
is written about it already.

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
