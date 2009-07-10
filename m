From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] btrfs: Fix partial discard on RAID1
Date: Fri, 10 Jul 2009 07:14:36 +0200
Message-ID: <20090710051436.GW23611@kernel.dk>
References: <2c3b11250812290723t74c1f505jb0ffc8c66ebe1ead@mail.gmail.com> <3d0408630901010457p5440f053tbf4fe86b2697c9cc@mail.gmail.com> <2c3b11250901030733y9cf8994w984a4c110f42f4d0@mail.gmail.com> <1247180277.7423.1.camel@macbook.infradead.org> <1247180532.7423.5.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liu Hui <onlyflyer@gmail.com>, Yan Zheng <yanzheng@21cn.com>,
	linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247180532.7423.5.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 10 2009, David Woodhouse wrote:
> In btrfs_discard_extent() we were only discarding half of a RAID1 or
> RAID10 extent.
> 
> We should be telling btrfs_map_block() that we want to write, so it
> tells us about _all_ mirrors. If we tell it we're going to read, it'll
> only tell us about a single mirror at a time.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
> Untested. Does anyone have any real devices that do TRIM yet, or do I
> need to hack up an FTL to do it again?

Get one of the OCZ vertex drives, they do trim. They use their own
opcode for it, but it's there.

-- 
Jens Axboe

