Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33671 "EHLO
        mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbcH0A47 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Aug 2016 20:56:59 -0400
Received: by mail-pa0-f41.google.com with SMTP id cy9so10926031pac.0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Aug 2016 17:56:58 -0700 (PDT)
Date: Fri, 26 Aug 2016 17:56:56 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Anatoly Pugachev <matorola@gmail.com>
Cc: Chris Mason <clm@fb.com>, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on
 big-endian systems
Message-ID: <20160827005656.GA8439@vader.DHCP.thefacebook.com>
References: <cover.1468538030.git.osandov@fb.com>
 <399ec92c-9905-0ede-d5b0-ea3b0bf922e4@fb.com>
 <20160718223104.GA6681@vader.DHCP.thefacebook.com>
 <2544227.upOtQjWuiQ@localhost.localdomain>
 <83e50f77-ae10-4c8d-4a03-3c9af298d9c7@fb.com>
 <20160818203327.GA7696@vader.DHCP.thefacebook.com>
 <CADxRZqwHPVTdiKQa89Y0gbBWS-UMWwYzqLSnBNRhx9U33iSdKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADxRZqwHPVTdiKQa89Y0gbBWS-UMWwYzqLSnBNRhx9U33iSdKw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 26, 2016 at 02:06:29PM +0300, Anatoly Pugachev wrote:
> On Thu, Aug 18, 2016 at 11:33 PM, Omar Sandoval <osandov@osandov.com> wrote:
> > On Tue, Jul 19, 2016 at 03:25:16PM -0400, Chris Mason wrote:
> >> On 07/19/2016 12:06 PM, Chandan Rajendra wrote:
> >>
> >> Omar, looks like we need to make the patched kernel refuse to mount free
> >> space trees without a new incompat bit set.  That way there won't be any
> >> surprises for the people that have managed to get a free space tree saved.
> >> Can it please printk a message about clearing the tree and mounting again?
> >>
> > Sorry it took me a month to get around to this, I tried to implement
> > this a couple of ways but I really don't like it. Basically, when we see
> > that we're missing the compat bit, we have to assume that the free space
> > tree was created with the same endianness that we're running on now.
> > That could lead to a false positive if, say, we created the filesystem
> > on a little-endian machine with an old kernel but are using it on a
> > big-endian system, or a false negative if it was created on a big-endian
> > machine with an old kernel but we're using it on a little-endian
> > machine.
> >
> > There's also the question of making it a compat bit vs an incompat bit.
> > An incompat bit makes sure that we don't break the filesystem by
> > mounting it on an old big-endian kernel, but needlessly breaks
> > backwards-compatibility for little-endian.
> >
> > I'd be much happier if we could just pretend this never happened. Here's
> > the patch, anyways, for the sake of completeness. Chris, what do you
> > think?
> 
> Omar,
> 
> I can't load btrfs module with this patch applied to 4.8.0-rc3+ (git
> v4.8-rc3-39-g61c0457)
> on "modprobe btrfs" i'm getting the following in the logs and module
> does not load:
> 
> Btrfs loaded, crc32c=crc32c-generic, debug=on, assert=on
> BTRFS: selftest: sectorsize: 8192  nodesize: 8192
> BTRFS: selftest: Running btrfs free space cache tests
> BTRFS: selftest: Running extent only tests
> BTRFS: selftest: Running bitmap only tests
> BTRFS: selftest: Running bitmap and extent tests
> BTRFS: selftest: Running space stealing from bitmap to extent
> BTRFS: selftest: Free space cache tests finished
> BTRFS: selftest: Running extent buffer operation tests
> BTRFS: selftest: Running btrfs_split_item tests
> BTRFS: selftest: Running extent I/O tests
> BTRFS: selftest: Running find delalloc tests
> BTRFS: selftest: Running extent buffer bitmap tests
> BTRFS: selftest: Setting straddling pages failed
> BTRFS: selftest: Extent I/O tests finished

Is this with the whole patchset + this patch? You still need the patch
set for this to actually work, the extra patch is just some extra
checks.

-- 
Omar
