From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATH]Some fix for batching extent insert.
Date: Tue, 18 Nov 2008 07:17:50 -0500
Message-ID: <1227010670.15917.2.camel@think.oraclecorp.com>
References: <2c3b11250811170748s508ec4ddlfce9ad80bb296d95@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Liu Hui <onlyflyer@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2c3b11250811170748s508ec4ddlfce9ad80bb296d95@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-11-17 at 23:48 +0800, Liu Hui wrote:
> Hi,
> When I review the code about batching extent insert, I found some code
> could result in problems in some corner cases.
> 1)In finish_current_insert(), when it finds nothing to insert and it
> has skipped some locked extents, it should try again to see if the
> locked extent is unlocked. So, it will re-search the extent_ins
> extent_io_tree by reseting 'search' to 0. There is one place forget to
> reset the 'search' pointer to 0 which will lead BTRFS not to finish
> *all* current insert.
> 

Thanks for spending time on this, but I'm afraid this patch leads to
infinite looping in finish_current_insert under stress testing.

-chris


