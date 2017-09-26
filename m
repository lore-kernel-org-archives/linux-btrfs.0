Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58151 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934463AbdIZLek (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 07:34:40 -0400
Date: Tue, 26 Sep 2017 13:33:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Paul Jones <paul@pauljones.id.au>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>, Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: fix kernel oops while reading compressed data
Message-ID: <20170926113302.GQ31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170920235019.10508-1-bo.li.liu@oracle.com>
 <20170924134539.GT29043@twin.jikos.cz>
 <MEXPR01MB216811A8EB1C53622C0DD0AC9E7B0@MEXPR01MB2168.ausprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <MEXPR01MB216811A8EB1C53622C0DD0AC9E7B0@MEXPR01MB2168.ausprd01.prod.outlook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 26, 2017 at 08:41:27AM +0000, Paul Jones wrote:
> > -----Original Message-----
> > From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> > owner@vger.kernel.org] On Behalf Of David Sterba
> > Sent: Sunday, 24 September 2017 11:46 PM
> > To: Liu Bo <bo.li.liu@oracle.com>
> > Cc: linux-btrfs@vger.kernel.org
> > Subject: Re: [PATCH 1/2] Btrfs: fix kernel oops while reading compressed
> > data
> > 
> > On Wed, Sep 20, 2017 at 05:50:18PM -0600, Liu Bo wrote:
> > > The kernel oops happens at
> > >
> > > kernel BUG at fs/btrfs/extent_io.c:2104!
> > > ...
> > > RIP: clean_io_failure+0x263/0x2a0 [btrfs]
> > >
> > > It's showing that read-repair code is using an improper mirror index.
> > > This is due to the fact that compression read's endio hasn't recorded
> > > the failed mirror index in %cb->orig_bio.
> > >
> > > With this, btrfs's read-repair can work properly on reading compressed
> > > data.
> > >
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > Reported-by: Paul Jones <paul@pauljones.id.au>
> > 
> > Reviewed-by: David Sterba <dsterba@suse.com>
> 
> Tested-by: <paul@pauljones.id.au>
> For both patches.

Thanks for testing.

> I caused the same thing to happen again, this time by unplugging the
> wrong hard drive. Applied the patches and problem (BUG_ON) is gone.
> Should this also go to stable? Seems like a rather glaring problem to me.

Yes it should and will be forwarded there once it's merged to Linus'
tree.
