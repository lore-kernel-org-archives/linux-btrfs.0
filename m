Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52853 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751071AbeEAPmV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 May 2018 11:42:21 -0400
Date: Tue, 1 May 2018 17:39:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/4] [RESEND] Btrfs: reduce size of struct btrfs_inode
Message-ID: <20180501153945.GW21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180424233717.31283-1-nefelim4ag@gmail.com>
 <20180424233717.31283-5-nefelim4ag@gmail.com>
 <20180426134206.GV21272@twin.jikos.cz>
 <CAGqmi75LLs9T9HEJQEx53HMKCvHPjM7jDKPBELpdv6hmaVhvWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi75LLs9T9HEJQEx53HMKCvHPjM7jDKPBELpdv6hmaVhvWw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 28, 2018 at 10:01:57AM +0000, Timofey Titovets wrote:
> May be i misunderstood something, but i was think that slab combine
> several pages in continuous range, so object in slab can cross page
> boundary.  So, all calculation will be very depends on scale of slab
> size.
> 
> i.e. on my machine that looks quite different:
> name                    <active_objs>  <num_objs>  <objsize>  <objperslab>   <pagesperslab>
> btrfs_inode             142475         146272      1136       28             8
> 
> So,
> PAGE_SIZE * pagesperslab / objperslab
> 4096 * 8 / 28 = 1170.28
> 
> 4096*8 - 1136*28 = 960
> 
> That's looks like object can cross page boundary in slab.
> So, if size reduced to 1128,
> 4096 * 8 / 29 = 1129.93
> 4096*8 - 1128*29 = 56
> 
> Did i miss something?

Then this depends on the allocator, SLAB does 4k pages and SLUB 32k, so
there's a value in reducing the inode size.
