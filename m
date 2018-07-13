Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53368 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729644AbeGMOta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 10:49:30 -0400
Date: Fri, 13 Jul 2018 16:34:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Introduce compile time structure size check
Message-ID: <20180713143431.GX3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180712061907.24783-1-wqu@suse.com>
 <e2042691-363d-875b-61a2-d59e47840c49@suse.com>
 <50163977-ed21-3f97-dced-8bf08dfcfa33@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <50163977-ed21-3f97-dced-8bf08dfcfa33@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 12, 2018 at 02:56:55PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年07月12日 14:27, Nikolay Borisov wrote:
> > 
> > 
> > On 12.07.2018 09:19, Qu Wenruo wrote:
> >> Introduce a new macro based compile time check for ioctl structures.
> >>
> >> The new macro is BTRFS_ASSERT_SIZE(), which is mostly copied from
> >> VMMDEV_ASSERT_SIZE().
> >>
> >> Such check is only added to structure pended to power of 2.
> >> And exposed one structure, btrfs_ioctl_get_dev_stats() is not aligned
> >> well.
> >> The misalign is introduced by commit b27f7c0c150f ("btrfs: join DEV_STATS
> >> ioctls to one").
> > 
> > So what's the negative effect if a structure is not aligned to a power of 2?
> 
> No real negative effect, until one day one may find the comment is not
> correct.

So the comment needs to be fixed.
