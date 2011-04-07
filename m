From: Josef Bacik <josef@redhat.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Thu, 7 Apr 2011 09:17:12 -0400
Message-ID: <20110407131712.GF484@dhcp231-156.rdu.redhat.com>
References: <201104051938.14319.johannes.hirte@fem.tu-ilmenau.de> <201104060000.11403.johannes.hirte@fem.tu-ilmenau.de> <20110405215752.GE484@dhcp231-156.rdu.redhat.com> <201104061310.38951.johannes.hirte@fem.tu-ilmenau.de> <20110406171541.GA5574@localhost.localdomain> <BANLkTi=hZ2i-kj70yq+=E74oSZZu9G7wtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Jordan Patterson <jordanp@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=hZ2i-kj70yq+=E74oSZZu9G7wtw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 06, 2011 at 02:47:28PM -0600, Jordan Patterson wrote:
> Hi Josef:
> 
> I tried your latest patch, since I had the same issue from the first
> email.  With the patch applied, I am now hitting the
> BUG_ON(block_group->total_bitmaps >= max_bitmaps); in add_new_bitmap
> in
> fs/btrfs/free-space-cache.c:1246 as soon as I mount the filesystem,
> with or without -o clear_cache.
> 
> It works fine in 2.6.38.  I get the same error after mounting with
> clear_cache under 2.6.38 and rebooting into the current kernel with
> your patch.
> 

Do you have a backtrace so I can see how we're getting here?  This is a seperate
issue from the one this patch tries to solve, but now that it seems that's fixed
I will work on this now :).  Thanks,

Josef
