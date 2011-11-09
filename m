From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: btrfs: could not do orphan cleanup -116
Date: Wed, 09 Nov 2011 16:18:11 +0000
Message-ID: <1320855491.2051.5.camel@picard>
References: <1320671824.2445.8.camel@picard>
	 <20111107152940.GA2151@localhost.localdomain>
	 <1320691304.2445.11.camel@picard>
	 <20111107190152.GB2151@localhost.localdomain>
	 <1320853417.2051.1.camel@picard>
	 <20111109161440.GD1810@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111109161440.GD1810@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2011-11-09 at 11:14 -0500, Josef Bacik wrote:
> On Wed, Nov 09, 2011 at 03:43:37PM +0000, Maciej Marcin Piechotka
> wrote:
> > On Mon, 2011-11-07 at 14:01 -0500, Josef Bacik wrote:
> > > On Mon, Nov 07, 2011 at 06:41:44PM +0000, Maciej Marcin Piechotka
> wrote:
> > > > On Mon, 2011-11-07 at 10:29 -0500, Josef Bacik wrote:
> > > > > On Mon, Nov 07, 2011 at 01:17:04PM +0000, Maciej Marcin
> Piechotka wrote:
> > > > > > Hello,
> > > > > > 
> > > > > > When I booted my machine (after clean powerdown) the
> following message
> > > > > > appeared:
> > > > > > [   32.757913] device fsid
> XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX devid 1
> > > > > > transid 40864 /dev/mapper/XXXXX-XXXXX
> > > > > > [   32.758466] btrfs: use lzo compression
> > > > > > [   32.758475] btrfs: enabling disk space caching
> > > > > > [   32.758483] btrfs: enabling inode map caching
> > > > > > [   32.758490] btrfs: enabling auto defrag
> > > > > > [   32.758497] btrfs: thread pool 2
> > > > > > [   34.024359] btrfs: could not do orphan cleanup -116
> > > > > > [   63.173382] btrfs: open_ctree failed
> > > > > > 
> > > > > > btrfsck has shown no errors.
> > > > > > 
> > > > > > Afterwards when I tried to mount filesystem it have shown:
> > > > > > 
> > > > > > [  116.012528] btrfs: enabling inode map caching
> > > > > > [  116.012534] btrfs: enabling auto defrag
> > > > > > [  116.012542] btrfs: thread pool 2
> > > > > > 
> > > > > > It looked like everything is working but to be sure I've run
> scrub:
> > > > > > 
> > > > > > scrub status for fsid XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
> > > > > >         scrub started at Mon Nov  7 13:05:50 2011 and
> finished after 606
> > > > > > seconds
> > > > > >         total bytes scrubbed: 32.37GB with 0 errors
> > > > > > 
> > > > > > PS. 
> > > > > > # find include | xargs grep 116
> > > > > > (...)
> > > > > > include/asm-generic/errno.h:#define     ESTALE
> 116     /* Stale
> > > > > > NFS file handle */
> > > > > > (...)
> > > > > > 
> > > > > > I don't use NFS - I use LVM on LUKS. In any case - it have
> been done
> > > > > > concurrently with mounting of other fs which had no such
> problems.
> > > > > 
> > > > > Yeah that's a bug with an earlier kernel, if you upgrade to
> 3.1 it should go
> > > > > away.  Thanks,
> > > > > 
> > > > > Josef
> > > > 
> > > > 
> > > > I'm using 'newer' kernel then 3.1 - I'm following Linus' tree
> (this
> > > > kernel is few days old).
> > > > 
> > > 
> > > Do you have the commit
> > > 
> > > a8c9e5769718d47e87cce40c9b84cab421804797
> > > Btrfs: fix orphan cleanup regression
> > > 
> > > If not then the kernel isn't new enough.  Thanks,
> > > 
> > > Josef
> > 
> > It have been merged in master for 3.2-rc1 (shortly before tag).
> > 
> > Regards
> > 
> 
> Does that mean you have that patch and are still hitting the problem?
> If so try
> this debug patch so I can see where it's coming from.  Thanks,
> 
> Josef 

No. I was just informing that it entered tree a bit later then 3.1 was
released - in fact shortly before 3.2-rc1 (I presume btrfs devs not
necessary remember when Linus merges changes into tree although I have
no experience with kernel development). I hit it only once before
updating the kernel.

Best regards

