From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Mis-Design of Btrfs?
Date: Thu, 14 Jul 2011 22:32:22 -0400
Message-ID: <1310696606-sup-710@shiny>
References: <20110623105337.GD3753@ethz.ch> <20110627164637.377314e2@notabene.brown> <4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown> <4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown> <4E1E9372.3030208@redhat.com>
Content-Type: text/plain; charset=UTF-8
Cc: NeilBrown <neilb@suse.de>,
	Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4E1E9372.3030208@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Ric Wheeler's message of 2011-07-14 02:57:54 -0400:
> On 07/14/2011 07:38 AM, NeilBrown wrote:
> > On Thu, 14 Jul 2011 07:02:22 +0100 Ric Wheeler<rwheeler@redhat.com>  wrote:
> >
> >>> I'm certainly open to suggestions and collaboration.  Do you have in mind any
> >>> particular way to make the interface richer??
> >>>
> >>> NeilBrown
> >> Hi Neil,
> >>
> >> I know that Chris has a very specific set of use cases for btrfs and think that
> >> Alasdair and others have started to look at what is doable.
> >>
> >> The obvious use case is the following:
> >>
> >> If a file system uses checksumming or other data corruption detection bits, it
> >> can detect that it got bad data on a write. If that data was protected by RAID,
> >> it would like to ask the block layer to try to read from another mirror (for
> >> raid1) or try to validate/rebuild from parity.
> >>
> >> Today, I think that a retry will basically just give us back a random chance of
> >> getting data from a different mirror or the same one that we got data from on
> >> the first go.
> >>
> >> Chris, Alasdair, was that a good summary of one concern?
> >>
> >> Thanks!
> >>
> >> Ric
> > I imagine a new field in 'struct bio' which was normally zero but could be
> > some small integer.  It is only meaningful for read.
> > When 0 it means "get this data way you like".
> > When non-zero it means "get this data using method N", where the different
> > methods are up to the device.
> >
> > For a mirrored RAID, method N means read from device N-1.
> > For stripe/parity RAID, method 1 means "use other data blocks and parity
> > blocks to reconstruct data.
> >
> > The default for non RAID devices is to return EINVAL for any N>  0.
> > A remapping device (dm-linear, dm-stripe etc) would just pass the number
> > down.  I'm not sure how RAID1 over RAID5 would handle it... that might need
> > some thought.
> >
> > So if btrfs reads a block and the checksum looks wrong, it reads again with
> > a larger N.  It continues incrementing N and retrying until it gets a block
> > that it likes or it gets EINVAL.  There should probably be an error code
> > (EAGAIN?) which means "I cannot work with that number, but try the next one".
> >
> > It would be trivial for me to implement this for RAID1 and RAID10, and
> > relatively easy for RAID5.
> > I'd need to give a bit of thought to RAID6 as there are possibly multiple
> > ways to reconstruct from different combinations of parity and data.  I'm not
> > sure if there would be much point in doing that though.
> >
> > It might make sense for a device to be able to report what the maximum
> > 'N' supported is... that might make stacked raid easier to manage...
> >
> > NeilBrown
> >
> 
> I think that the above makes sense. Not sure what your "0" definition is, but I 
> would assume that for non-raided devices (i.e., a single s-ata disk), "0" would 
> be an indication that there is nothing more that can be tried. The data you got 
> is all you are ever going to get :)
> 
> For multiple mirrors, you might want to have a scheme where you would be able to 
> cycle through the mirrors. You could retry, cycling through the various mirrors 
> until you have tried and returned them all at which point you would get a "no 
> more" error back or some such thing.

Hi everyone,

The mirror number idea is basically what btrfs does today, and I think
it fits in with Neil's idea to have different policies for different
blocks.

Basically what btrfs does:

read_block(block_num, mirror = 0)
if (no io error and not csum error)
	horray()

num_mirrors = get_num_copies(block number)
for (i = 1; i < num_mirrors; i++) {
	read_block(block_num, mirror = i);
}

In a stacked configuration, the get_num_copies function can be smarter,
basically adding up all the copies of the lower levels and finding a way
to combine them.  We could just send down a fake bio that is responsible
for adding up the storage combinations into a bitmask or whatever works.

We could also just keep retrying until the lower layers reported no more
mirror were available.

In btrfs at least, we don't set the data blocks up to date until the crc
has passed, so replacing bogus blocks is easy.  Metadata is a little
more complex, but that's not really related to this topic.

mirror number 0 just means "no mirror preference/pick the fastest
mirror" to the btrfs block mapping code.

Btrfs has the concept of different raid levels for different logical
block numbers, so you get_num_copies might return one answer for block A
and a different answer for block B.

Either way, we could easily make use of a bio field here if it were
exported out.

-chris
