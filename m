Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:37555 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759622AbeD1KCd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 06:02:33 -0400
Received: by mail-ot0-f195.google.com with SMTP id 77-v6so4724642otd.4
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Apr 2018 03:02:33 -0700 (PDT)
MIME-Version: 1.0
References: <20180424233717.31283-1-nefelim4ag@gmail.com> <20180424233717.31283-5-nefelim4ag@gmail.com>
 <20180426134206.GV21272@twin.jikos.cz>
In-Reply-To: <20180426134206.GV21272@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sat, 28 Apr 2018 10:01:57 +0000
Message-ID: <CAGqmi75LLs9T9HEJQEx53HMKCvHPjM7jDKPBELpdv6hmaVhvWw@mail.gmail.com>
Subject: Re: [PATCH 4/4] [RESEND] Btrfs: reduce size of struct btrfs_inode
To: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

чт, 26 апр. 2018 г. в 16:44, David Sterba <dsterba@suse.cz>:

> On Wed, Apr 25, 2018 at 02:37:17AM +0300, Timofey Titovets wrote:
> > Currently btrfs_inode have size equal 1136 bytes. (On x86_64).
> >
> > struct btrfs_inode store several vars releated to compression code,
> > all states use 1 or 2 bits.
> >
> > Lets declare bitfields for compression releated vars, to reduce
> > sizeof btrfs_inode to 1128 bytes.

> Unfortunatelly, this has no big effect. The inodes are allocated from a
> slab page, that's 4k and there are at most 3 inodes there. Snippet from
> /proc/slabinfo:

> # name            <active_objs> <num_objs> <objsize> <objperslab>
<pagesperslab>
> btrfs_inode       256043 278943   1096    3    1

> The size on my box is 1096 as it's 4.14, but this should not matter to
> demonstrate the idea.

> objperslab is 3 here, ie. there are 3 btrfs_inode in the page, and
> there's 4096 - 3 * 1096 = 808 of slack space. In order to pack 4 inodes
> per page, we'd have to squeeze the inode size to 1024 bytes. I've looked
> into that and did not see enough members to remove or substitute. IIRC
> there were like 24-32 bytes possible to shave, but that was it.

> Once we'd get to 1024, adding anything new to btrfs_inode would be quite
> difficult and as it goes, there's always something to add to the inode.

> So I'd take a different approach, to regroup items and decide by
> cacheline access patterns what to put together and what to separate.

> The maximum size of inode before going to 2 objects per page is 1365, so
> there's enough space for cacheline alignments.

May be i misunderstood something, but i was think that slab combine several
pages
in continuous range, so object in slab can cross page boundary.
So, all calculation will be very depends on scale of slab size.

i.e. on my machine that looks quite different:
name                    <active_objs>  <num_objs>  <objsize>  <objperslab>
  <pagesperslab>
btrfs_inode             142475         146272      1136       28
  8

So,
PAGE_SIZE * pagesperslab / objperslab
4096 * 8 / 28 = 1170.28

4096*8 - 1136*28 = 960

That's looks like object can cross page boundary in slab.
So, if size reduced to 1128,
4096 * 8 / 29 = 1129.93
4096*8 - 1128*29 = 56

Did i miss something?

Thanks.
-- 
Have a nice day,
Timofey.
