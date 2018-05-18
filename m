Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:42335 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751450AbeERRio (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 13:38:44 -0400
Received: by mail-pg0-f68.google.com with SMTP id p9-v6so3604980pgc.9
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 10:38:44 -0700 (PDT)
Date: Fri, 18 May 2018 10:38:40 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v4 00/12] Btrfs: orphan and truncate fixes
Message-ID: <20180518173840.GA1125@vader>
References: <cover.1526069051.git.osandov@fb.com>
 <20180518151435.GP6649@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180518151435.GP6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 18, 2018 at 05:14:35PM +0200, David Sterba wrote:
> On Fri, May 11, 2018 at 01:13:28PM -0700, Omar Sandoval wrote:
> > This is the fourth (and hopefully final) version of the orphan item
> > early ENOSPC and related fixes.
> > 
> > Changes since v3:
> > 
> > - Changed another stale comment in patch 1
> > - Moved BTRFS_INODE_ORPHAN_META_RESERVED flag removal to patch 10
> >   instead of patch 9
> > - Moved inode runtime flag renumbering to a separate patch (patch 11)
> > - Added some more reviewed-bys
> 
> Patchset added to misc-next, thanks. Besides fstests, I've hammered it
> with some stress testing, all fine.

Thanks, Dave!

> > Changes since v2:
> > 
> > - Add patch 5 to get rid of BTRFS_INODE_HAS_ORPHAN_ITEM
> > - Move patch 10 to patch 6
> > - Got rid of patch 5; the bug goes away in the process of removing code
> >   for patches 9 and 10
> > - Rename patch 10 batch to what it was called in v1
> > 
> > Changes since v1:
> > 
> > - Added two extra cleanups, patches 10 and 11
> > - Added a forgotten clear of the orphan bit in patch 8
> > - Reworded titles of patches 6 and 9
> > - Added people's reviewed-bys
> > 
> > Cover letter from v1:
> > 
> > At Facebook we hit an early ENOSPC issue which we tracked down to the
> > reservations for orphan items of deleted-but-still-open files. The
> > primary function of this series is to fix that bug, but I ended up
> > uncovering a pile of other issues in the process, most notably that the
> > orphan items we create for truncate are useless.
> > 
> > I've also posted an xfstest that reproduces this bug.
> > 
> > Thanks!
> > 
> > *** BLURB HERE ***
> 
> Blurb!

Oops ;)
