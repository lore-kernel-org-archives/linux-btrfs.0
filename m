From: Sander <sander@humilis.net>
Subject: Re: Tuning of btrfs for throughput?
Date: Tue, 31 Jan 2012 08:08:03 +0100
Message-ID: <20120131070803.GA24017@attic.humilis.net>
References: <CACyXjPxb3Ped7yvv5je_g76T+uDKKYkhC7t7MY_-GQK3WuTQ-Q@mail.gmail.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Richard Sharpe <realrichardsharpe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACyXjPxb3Ped7yvv5je_g76T+uDKKYkhC7t7MY_-GQK3WuTQ-Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Richard Sharpe wrote (ao):
> I am running on 3.2.1 and have set up btrfs across 11 7200RPM 1TB 3.5"
> drives. I told btrfs to mirror metadata and stripe data.

> However, what I would like to know is are there any tuning parameters
> I can tweak to push the numbers up a bit?
> 
> I see lots of idle time (80+%) on my 16 cores (probably two by four by two).

Do you have a partition on the disks? On a partitionless disk you don't
have to deal with aligning.

You could try mkfs.btrfs -l 32k -n 32k as per
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg14585.html

Depending on the nature of your data, you could try with zlib, lzo or
snappy compression.

I'd say dd is a lousy benchmarktool btw.

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
