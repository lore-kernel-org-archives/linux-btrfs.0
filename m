Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46529 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751751AbdF3OyF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 10:54:05 -0400
Date: Fri, 30 Jun 2017 16:52:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: convert: do not clear header rev
Message-ID: <20170630145253.GV2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170626235502.26267-1-bo.li.liu@oracle.com>
 <20170627190712.GC1886@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170627190712.GC1886@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 27, 2017 at 12:07:13PM -0700, Liu Bo wrote:
> On Mon, Jun 26, 2017 at 05:55:02PM -0600, Liu Bo wrote:
> > So btrfs_set_header_flags() vs btrfs_set_header_flag, the difference is sort of
> > similar to "=" vs "|=", when creating and initialising a new extent buffer,
> > convert uses the former one which clears header_rev by accident.
> >
> 
> Here is the regression test script,
> 
> mkfs.ext4 -F /disk
> btrfs-convert -d /disk
> mount /disk /mnt
> xfs_io -f -c "pwrite 0 4K" /mnt/foobar
> umount /disk
> 
> ---------------
> It'd end up with 'unable to find ref blabla" shown in dmesg log.

I can't reproduce it, is there something else needed? Tested kernel is
4.11.6. Check does not complain either.
