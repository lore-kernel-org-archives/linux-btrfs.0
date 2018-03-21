Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59496 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751641AbeCUQCl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 12:02:41 -0400
Date: Wed, 21 Mar 2018 17:00:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: inspect-dump-tree: add '-f|--follow'
 options to print all children tree blocks for '-b'
Message-ID: <20180321160014.GU6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180314010538.29292-1-wqu@suse.com>
 <20180319184418.GO6955@twin.jikos.cz>
 <d37c8bd2-995c-8a19-c2ba-be32e9313bd8@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <d37c8bd2-995c-8a19-c2ba-be32e9313bd8@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 20, 2018 at 01:19:21PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年03月20日 02:44, David Sterba wrote:
> > On Wed, Mar 14, 2018 at 09:05:38AM +0800, Qu Wenruo wrote:
> >> When debuging with "btrfs inspect dump-tree", it's not that handy if we
> >> want to iterate all child tree blocks starting from a specified block.
> >>
> >> -b can only print a single block, while without -b "btrfs inspect dump-tree"
> >> will need extra tree roots fulfilled to continue, which is not possible
> >> for some damaged filesystem.
> >>
> >> Add a new option '-f|--follow' to iterate a sub-tree starting from block
> >> specified by '-b|--block', so we would have less limitation.
> >>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> > 
> > I've dropped the shot option for now and updated the changelog. While
> > '-f' is probably a good choice, I'd postpone adding that if we want to
> > use it for other purposes.
> 
> I'm fine with this.
> 
> Just curious if this means we should also double check the short option
> usage or this is just for "-f"?

You don't need to add a short option from the beginning, this can be
added later when we can decide by the usage if it's worth.
