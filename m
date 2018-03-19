Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37069 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936089AbeCSTer (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 15:34:47 -0400
Date: Mon, 19 Mar 2018 20:32:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anand Jain <anand.jain@oracle.com>, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 024/110] btrfs: use proper endianness accessors for
 super_copy
Message-ID: <20180319193221.GP6955@suse.cz>
Reply-To: dsterba@suse.cz
References: <20180307191039.748351103@linuxfoundation.org>
 <20180307191042.810088712@linuxfoundation.org>
 <1521139304@msgid.manchmal.in-ulm.de>
 <20180316123049.GC25079@kroah.com>
 <1521305582@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521305582@msgid.manchmal.in-ulm.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 17, 2018 at 06:27:15PM +0100, Christoph Biedl wrote:
> Greg Kroah-Hartman wrote...
> 
> > On Thu, Mar 15, 2018 at 07:55:42PM +0100, Christoph Biedl wrote:
> 
> > > > commit 3c181c12c431fe33b669410d663beb9cceefcd1b upstream.
> 
> > > On big-endian systems, this change intruduces severe corruption,
> > > resulting in complete loss of the data on the used block device.
> 
> > That sucks.  Can you test Linus's tree to verify the problem is there?
> > I'll gladly revert this if Linus's tree also gets the revert, I don't
> > want you to hit this when you upgrade to a newer kernel.
> 
> Confirmed: The problem is, err ... was in Linus' tree as well. The
> rather recent commit 8f5fd927c3a7 reverted the change, after that
> everything is as expected again.

Thanks for checking.

> Looking at the original commit, I don't have a clue why things go wrong
> so horribly

It's a half endianness conversion. The plain in-memory structures are in
LE and has to be accessed via the helpers, super block copy and the
root item.  The commit adds only one half of the conversion, that
naturally does not exhibit on LE, because the macros are no-op.

Originally, the items were stored from the on-disk type to on-disk type,
regardless of the CPU:

  super->chunk_root = root_item->bytenr;

The patch should have added conversion of both values, like

  btrfs_set_super_chunk_root(super, btrfs_root_bytenr(root_item));

and not

  btrfs_set_super_chunk_root(super, root_item->bytenr);

It's not very obvious from the context though, typically there's one
structure that needs the accessors and is set from a value that's in CPU
byteorder. I think that the exception to this pattern confused all
involved developers.

The root_item members are annotated as __le64 that should be caught by
sparse/smatch checker in the buggy case, but we don't run the checkers
every the time.

> - otherwise don't be afraid of my data. I took this as a
> chance to verify my data recovery procedure, with success.

Should that not be the case, the damaged items in superblock can be
byteswapped back. That's 6 x u64 at most, I have a tool for that now.

Thanks again for the report and sorry for the trouble.
