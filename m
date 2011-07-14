From: NeilBrown <neilb@suse.de>
Subject: Re: Mis-Design of Btrfs?
Date: Thu, 14 Jul 2011 16:38:36 +1000
Message-ID: <20110714163836.35a729c1@notabene.brown>
References: <20110623105337.GD3753@ethz.ch>
	<20110627164637.377314e2@notabene.brown>
	<4E0AF091.9030301@redhat.com>
	<20110714155620.6e9ac2cc@notabene.brown>
	<4E1E866E.2050405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E1E866E.2050405@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 14 Jul 2011 07:02:22 +0100 Ric Wheeler <rwheeler@redhat.com> wrote:

> > I'm certainly open to suggestions and collaboration.  Do you have in mind any
> > particular way to make the interface richer??
> >
> > NeilBrown
> 
> Hi Neil,
> 
> I know that Chris has a very specific set of use cases for btrfs and think that 
> Alasdair and others have started to look at what is doable.
> 
> The obvious use case is the following:
> 
> If a file system uses checksumming or other data corruption detection bits, it 
> can detect that it got bad data on a write. If that data was protected by RAID, 
> it would like to ask the block layer to try to read from another mirror (for 
> raid1) or try to validate/rebuild from parity.
> 
> Today, I think that a retry will basically just give us back a random chance of 
> getting data from a different mirror or the same one that we got data from on 
> the first go.
> 
> Chris, Alasdair, was that a good summary of one concern?
> 
> Thanks!
> 
> Ric

I imagine a new field in 'struct bio' which was normally zero but could be
some small integer.  It is only meaningful for read.
When 0 it means "get this data way you like".
When non-zero it means "get this data using method N", where the different
methods are up to the device.

For a mirrored RAID, method N means read from device N-1.
For stripe/parity RAID, method 1 means "use other data blocks and parity
blocks to reconstruct data.

The default for non RAID devices is to return EINVAL for any N > 0.
A remapping device (dm-linear, dm-stripe etc) would just pass the number
down.  I'm not sure how RAID1 over RAID5 would handle it... that might need
some thought.

So if btrfs reads a block and the checksum looks wrong, it reads again with
a larger N.  It continues incrementing N and retrying until it gets a block
that it likes or it gets EINVAL.  There should probably be an error code
(EAGAIN?) which means "I cannot work with that number, but try the next one".

It would be trivial for me to implement this for RAID1 and RAID10, and
relatively easy for RAID5.
I'd need to give a bit of thought to RAID6 as there are possibly multiple
ways to reconstruct from different combinations of parity and data.  I'm not
sure if there would be much point in doing that though.

It might make sense for a device to be able to report what the maximum
'N' supported is... that might make stacked raid easier to manage...

NeilBrown
