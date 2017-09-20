Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27811 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdITTXK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 15:23:10 -0400
Date: Wed, 20 Sep 2017 12:19:16 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, Paul Jones <paul@pauljones.id.au>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1989
Message-ID: <20170920191916.GA10216@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <MEXPR01MB2168C2FE0ABD1B78F120044E9E630@MEXPR01MB2168.ausprd01.prod.outlook.com>
 <20170918170930.GC6357@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <MEXPR01MB2168CB4F1A1E9F616997FBD89E600@MEXPR01MB2168.ausprd01.prod.outlook.com>
 <20170919150725.GF29043@twin.jikos.cz>
 <20170919161239.GA18597@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <20170920125356.GI29043@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170920125356.GI29043@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 20, 2017 at 02:53:57PM +0200, David Sterba wrote:
> On Tue, Sep 19, 2017 at 10:12:39AM -0600, Liu Bo wrote:
> > On Tue, Sep 19, 2017 at 05:07:25PM +0200, David Sterba wrote:
> > > On Tue, Sep 19, 2017 at 11:32:46AM +0000, Paul Jones wrote:
> > > > > This 'mirror 0' looks fishy, (as mirror comes from btrfs_io_bio->mirror_num,
> > > > > which should be at least 1 if raid1 setup is in use.)
> > > > > 
> > > > > Not sure if 4.13.2-gentoo made any changes on btrfs, but can you please
> > > > > verify with the upstream kernel, say, v4.13?
> > > > 
> > > > It's basically a vanilla kernel with a handful of unrelated patches.
> > > > The filesystem fell apart overnight, there were a few thousand
> > > > checksum errors and eventually it went read-only. I tried to remount
> > > > it, but got open_ctree failed. Btrfs check segfaulted, lowmem mode
> > > > completed with so many errors I gave up and will restore from the
> > > > backup.
> > > > 
> > > > I think I know the problem now - the lvm cache was in writeback mode
> > > > (by accident) so during a defrag there would be gigabytes of unwritten
> > > > data in memory only, which was all lost when the system crashed
> > > > (motherboard failure). No wonder the filesystem didn't quite survive.
> > > 
> > > Yeah, the caching layer was my first suspicion, and lack of propagating
> > > of the barriers. Good that you were able to confirm that as the root cause.
> > > 
> > > > I must say though, I'm seriously impressed at the data integrity of
> > > > BTRFS - there were near 10,000 checksum errors, 4 which were
> > > > uncorrectable, and from what I could tell nearly all of the data was
> > > > still intact according to rsync checksums.
> > > 
> > > Yay!
> > 
> > But still don't get why mirror_num is 0, do you have an idea on how
> > does writeback cache make that?
> 
> My first idea was that the cached blocks were zeroed, so we'd see the ino
> and mirror as 0. But this is not correct as the blocks would not pass
> the checksum tests, so the blocks must be from some previous generation.
> Ie. the transid verify failure. And all the error reports appear after
> that so I'm slightly suspicious about the way it's actually reported.
> 
> btrfs_print_data_csum_error takes mirror from either io_bio or
> compressed_bio structures, so there might be a case when the structures
> are initialized. If the transid check is ok, then the structures are
> updated. If the check fails we'd see the initial mirror number. All of
> that is just a hypothesis, I haven't checked with the code.
>

Thanks a lot for the input, you're right, mirror_num 0 should come
from compressed read where it doesn't record the bbio->mirror_num but
the mirror passing from the upper layer, and it's not metadata as we
don't yet compress metadata, so this all makes sense.

I think it also disables the ability of read-repair from raid1 for
compressed data, and that's what caused the bug where it hits
BUG_ON(mirror_num == 0) in cleanup_io_failure().

The good news is that I can reproduce it, will send a patch and a
testcase.

> I don't have a theoretical explanation for the ino 0. The inode pointer
> that goes to btrfs_print_data_csum_error should be from a properly
> initialized inode and we print the number using btrfs_ino. That will use
> the vfs i_ino value and we should never get 0 out of that.

ino 0 comes from metadata read-repair, some cleanup may be needed to
make it less confusing.

thanks,
-liubo
