Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:49296 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbcIQADH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 20:03:07 -0400
Date: Fri, 16 Sep 2016 20:03:03 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Post ext3 conversion problems
Message-ID: <20160917000302.GA1156@coach.home>
References: <20160916192459.GA13514@coach.home>
 <CAJCQCtQutt6r2Jovr0jEbTk4W6HUaQpbGiipen97TH1C+k055g@mail.gmail.com>
 <20160916232552.GA18014@coach.home>
 <CAJCQCtSW0zrWdYgWsWmokBDGBY8Lkd0E-cKKmBf7CfoZdR5aFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSW0zrWdYgWsWmokBDGBY8Lkd0E-cKKmBf7CfoZdR5aFA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2016 at 05:45:59PM -0600, Chris Murphy wrote:
> On Fri, Sep 16, 2016 at 5:25 PM, Sean Greenslade
> <sean@seangreenslade.com> wrote:
> 
> > In the mean time, is there any way to make the kernel more verbose about
> > btrfs errors? It would be nice to see, for example, what was in the
> > transaction that failed, or at least what files / metadata it was
> > touching.
> 
> No idea. Maybe one of the compile time options:
> 
> 
> CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
> This also requires mount options, either check_int or check_int_data
> CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> CONFIG_BTRFS_DEBUG=y
> https://patchwork.kernel.org/patch/846462/
> CONFIG_BTRFS_ASSERT=y
> 
> Actually, even before that maybe if you did a 'btrfs-debug-tree /dev/sdX'
> 
> That might explode in the vicinity of the problem. Thing is, btrfs
> check doesn't see anything wrong with the metadata, so chances are
> debug-tree won't either.

Hmm, I'll probably have a go at compiling the latest mainline kernel
with CONFIG_BTRFS_DEBUG enabled. It certainly can't hurt to try.

And as you suspected, btrfs-debug-tree didn't explode / error out on me.
I didn't thoroughly inspect the output (as I have very little
understanding of the btrfs internals), but it all seemed OK.

--Sean

