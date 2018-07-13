Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35012 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729670AbeGMPkv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 11:40:51 -0400
Date: Fri, 13 Jul 2018 17:25:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Introduce compile time structure size check
Message-ID: <20180713152538.GA3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180712061907.24783-1-wqu@suse.com>
 <20180713143418.GW3126@twin.jikos.cz>
 <5f2369c6-c882-7ae6-04f5-6de98bf10f58@suse.de>
 <20180713144638.GY3126@twin.jikos.cz>
 <c98db100-b124-8d1a-ccd8-34e1a9bfe50c@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <c98db100-b124-8d1a-ccd8-34e1a9bfe50c@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 13, 2018 at 10:57:07PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年07月13日 22:46, David Sterba wrote:
> > On Fri, Jul 13, 2018 at 10:36:42PM +0800, Qu Wenruo wrote:
> >>
> >>
> >> On 2018年07月13日 22:34, David Sterba wrote:
> >>> On Thu, Jul 12, 2018 at 02:19:07PM +0800, Qu Wenruo wrote:
> >>>> Introduce a new macro based compile time check for ioctl structures.
> >>>>
> >>>> The new macro is BTRFS_ASSERT_SIZE(), which is mostly copied from
> >>>> VMMDEV_ASSERT_SIZE().
> >>>
> >>> The macro should be generic, there's nothing specific to btrfs. There's
> >>> a similar one in the progs.
> >>>
> >>>> Such check is only added to structure pended to power of 2.
> >>>
> >>> There's no constraint about power of 2 sizes, it works for any size.
> >>
> >> While some structure doesn't do padding at all, and it looks like they
> >> may get expanded later.
> >> Do we really need to limit the size right now?
> > 
> > The size of an ioctl structure is part of kernel<->userspace API and
> > must not change once public. The ioctl number is calculated using the
> > structure size.
> > 
> >>>> And exposed one structure, btrfs_ioctl_get_dev_stats() is not aligned
> >>>> well.
> >>>> The misalign is introduced by commit b27f7c0c150f ("btrfs: join DEV_STATS
> >>>> ioctls to one").
> >>>
> >>> Yeah, that was an oversight, so the correct value to check against is
> >>> 1024 + 8 =032, see ioctl.h in progs.
> >>
> >> Can't we just revert to 1024?
> > 
> > Answered by the above, we absolutely cannot change the numbers now.
> > 
> >> That plus 8 doesn't really look well, and shrink the size shouldn't
> >> bring any problem AFAIK.
> > 
> > See
> > 
> > https://elixir.bootlin.com/linux/latest/source/include/uapi/asm-generic/ioctl.h#L88
> > 
> > for _IOWR definition,
> > 
> > btrfs-progs:ioctl.h
> > 
> > 817 #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
> > 818                                       struct btrfs_ioctl_get_dev_stats)
> > 
> > kernel:fs/btrfs/ioctl.c
> > 
> > 5914         case BTRFS_IOC_GET_DEV_STATS:
> > 5915                 return btrfs_ioctl_get_dev_stats(fs_info, argp);
> > 
> > The values must match, otherwise dev stats will randomly break on
> > old/new kernel and progs combinations.
> 
> Ok, for old kernel and new progs, if that 1024 bytes from progs is
> allocated from stack we indeed could screw up user space stack memory.

The main concern is the ioctl number, but the structure size must match
too of course as it's copied back from kernel.

But the ioctl number is the interface, so the userspace calls
ioctl(NUMBER, ...) that krenel answers by looing up the right handler
for the NUMBER.

If there are two numbers, then patched userspace will get only ENOTTY
which translates to 'no such ioctl'.

> While for old progs and new kernel it won't cause any problem though.
> 
> I'll keep the ugly unaligned number in next version.
> 
> But really, we should have such alignment check way before we find the
> mismatch.

This unfortunatelly escaped during the review, now we have to live with
that but besides that it's not a power of two (which would be arbitrary
as well), I don't se any problem.

We have a worse problem with the send ioctl structure when there's a
pointer that's of different size on 32bit and 64bit so there needs to be
stub ioctls and structures so all the combinations work. Interfaces are
hard.
