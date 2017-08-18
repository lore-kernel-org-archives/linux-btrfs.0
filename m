Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38930 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752315AbdHROX3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 10:23:29 -0400
Date: Fri, 18 Aug 2017 16:22:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: fdmanana@gmail.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs: Simplify btrfs_alloc_dev_extent
Message-ID: <20170818142205.GX2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1501176997-24059-1-git-send-email-nborisov@suse.com>
 <1501176997-24059-2-git-send-email-nborisov@suse.com>
 <CAL3q7H7Em8aqkCqvvJP3zkOCFjJy1=19qdz+v79tnJ3qHt+6fw@mail.gmail.com>
 <0817db46-3069-ad0c-778c-78f8253771d8@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0817db46-3069-ad0c-778c-78f8253771d8@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 28, 2017 at 08:59:12AM +0300, Nikolay Borisov wrote:
> 
> 
> On 27.07.2017 20:57, Filipe Manana wrote:
> > On Thu, Jul 27, 2017 at 6:36 PM, Nikolay Borisov <nborisov@suse.com> wrote:
> >> Currently btrfs_alloc_dev_extent essentially open codes btrfs_insert_item. So
> >> let's remove the superfluous code, leaving only the important bits, namely
> >> initialising the device extent and just calling btrfs_insert_item. So first add
> >> definition for the stack-based set/get function. And then use them.
> >> Additionally, remove the code which sets the uuid of the block header, since
> >> this is something which is already handled by the core btree code.
> > 
> > Quite honestly, I don't see the value of this change at all.
> > It doesn't make things simpler nor more readable nor nothing.
> > We have many, really many places using btrfs_insert_empty_item()
> > instead of calling btrfs_insert_item(), are you planning on sending a
> > patch to do the replacement for each of them? What's the point?
> 
> I beg you to differ. Some of the code in btrfs is a mess, it's working
> but it's messy. There is constant violation of abstractions (as is the
> case in this function, heck the uuid setting of the block header
> function doesn't even belong here). All of this hampers reading
> comprehension of the code for newcomers. You are experienced in the code
> and likely this doesn't apply to you but since I'm someone relatively
> new to the code this has been my experience. And I believe any effort to
> actually simplify the code, make it more coherent and succinct is a win
> long-term.
> 
> I will wait for other feedback, if people feel patches like that are
> just bikeshedding then I will refrain from such cleanups in the future.

What I don't like about this patch, also pointed out by Filipe, is the
additional memory allocation. Just for the sake of code beauty, this is
not the direction the cleanups should go. The function is IMHO readable
and below my current threshold of cleanup need.
