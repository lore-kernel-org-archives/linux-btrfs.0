Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965247AbeAORXG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 12:23:06 -0500
Date: Mon, 15 Jan 2018 18:20:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Eryu Guan <eguan@redhat.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: common/rc: fix device still mounted error with
 SCRATCH_DEV_POOL
Message-ID: <20180115172056.GD13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180113010459.24321-1-bo.li.liu@oracle.com>
 <20180115062228.GA3102@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180115062228.GA3102@eguan.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 15, 2018 at 02:22:28PM +0800, Eryu Guan wrote:
> On Fri, Jan 12, 2018 at 06:04:59PM -0700, Liu Bo wrote:
> > One of btrfs tests, btrfs/011, uses SCRATCH_DEV_POOL and puts a non-SCRATCH_DEV
> > device as the first one when doing mkfs, and this makes
> > _require_scratch{_nocheck} fail to umount $SCRATCH_MNT since it checks mount
> > point with SCRATCH_DEV only, and for sure it finds nothing to umount and the
> > following tests complain about 'device still mounted' alike errors.
> > 
> > Introduce a helper to address this special case where both btrfs and scratch
> > dev pool are in use.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Hmm, I didn't see this problem, I ran btrfs/011 then another tests that
> uses $SCRATCH_DEV, and the second test ran fine too. Can you please
> provide more details?
> 
> Anyway, I think we should fix btrfs/011 to either not use $SCRATCH_DEV
> in replace operations (AFAIK, other btrfs replace tests do this) or
> umount all devices before exit. And I noticed btrfs/011 does umount
> $SCRATCH_MNT at the end of workout(), so usually all should be fine
> (perhaps it would leave a device mounted if interrupted in the middle of
> test run, because _cleanup() doesn't do umount).

In my case I saw lots of test failures (btrfs/ 012 068 071 074 116 136
138 152 154 155 ...), some of them repeatedly but not reliably. This
could have been triggered by a patch in my testing branch, but I can't
tell for sure due to the inaccurate fstest checks. The common problem
was that the scratch device appeared as mounted.

We discussed that with Bo, I was suspecting some of our changes that
could theoretically leave some data in flight after umount. Bo found the
potential problems in fstests so I'll redo all the testing again with
updated fstests.
