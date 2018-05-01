Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755155AbeEANAv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 May 2018 09:00:51 -0400
Date: Tue, 1 May 2018 14:58:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: trace: Remove unnecessary fs_info parameter for
 btrfs__reserve_extent event class
Message-ID: <20180501125814.GP21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180426062425.8574-1-wqu@suse.com>
 <20180428164206.GI21272@twin.jikos.cz>
 <20180428174511.GL21272@twin.jikos.cz>
 <fd2d7c13-2999-bb7a-99fc-d8b6839f8558@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <fd2d7c13-2999-bb7a-99fc-d8b6839f8558@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 29, 2018 at 08:33:49AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年04月29日 01:45, David Sterba wrote:
> > On Sat, Apr 28, 2018 at 06:42:06PM +0200, David Sterba wrote:
> >> On Thu, Apr 26, 2018 at 02:24:25PM +0800, Qu Wenruo wrote:
> >>> fs_info can be extracted from btrfs_block_group_cache, and all
> >>> btrfs_block_group_cache is created by btrfs_create_block_group_cache()
> >>> with fs_info initialized, no need to worry about NULL pointer
> >>> dereference.
> >>
> >> Famous last words.
> > 
> > And it's a false alert, it's caused by another patch yet to be
> > identified.
> 
> Yep, I also spent serval minutes to find this out.
> As in that test there is nothing related to btrfs_reserve_extent() trace
> event.

Ok, found it "btrfs: simplify counting number of eb pages", will be
removed from misc-next.
