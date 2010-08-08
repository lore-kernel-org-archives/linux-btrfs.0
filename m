From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Poor read performance on high-end server
Date: Sun, 08 Aug 2010 09:18:36 +0200
Message-ID: <87r5i98tdf.fsf@basil.nowhere.org>
References: <4C5AC52D.9030906@sara.nl> <20100805145138.GJ29846@think>
	<4C5BF829.3020200@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Freek Dijkstra <Freek.Dijkstra@sara.nl>,
	linux-btrfs@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C5BF829.3020200@kernel.dk> (Jens Axboe's message of "Fri, 06
	Aug 2010 13:55:21 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Jens Axboe <axboe@kernel.dk> writes:
>
> Also, I didn't see Chris mention this, but if you have a newer intel box
> you can use hw accellerated crc32c instead. For some reason my test box
> always loads crc32c and not crc32c-intel, so I need to do that manually.

I have a patch for that, will post it later: autoloading of modules
based on x86 cpuinfo.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
