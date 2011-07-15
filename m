From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Mis-Design of Btrfs?
Date: Fri, 15 Jul 2011 10:24:25 -0400
Message-ID: <1310739313-sup-2118@shiny>
References: <20110714163836.35a729c1@notabene.brown> <4E1E9372.3030208@redhat.com> <1310696606-sup-710@shiny> <alpine.DEB.2.02.1107142149420.3558@asgard.lang.hm> <20110715163354.74fa2083@notabene.brown> <1310728784-sup-9024@shiny> <4E20395C.1000301@redhat.com> <1310735821-sup-2589@shiny> <4E204139.5060702@redhat.com> <1310738205-sup-715@shiny> <20110715140724.GA29265@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Cc: Ric Wheeler <rwheeler@redhat.com>, NeilBrown <neilb@suse.de>,
	david <david@lang.hm>,
	Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20110715140724.GA29265@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Hugo Mills's message of 2011-07-15 10:07:24 -0400:
> On Fri, Jul 15, 2011 at 10:00:35AM -0400, Chris Mason wrote:
> > Excerpts from Ric Wheeler's message of 2011-07-15 09:31:37 -0400:
> > > On 07/15/2011 02:20 PM, Chris Mason wrote:
> > > > Excerpts from Ric Wheeler's message of 2011-07-15 08:58:04 -0400:
> > > >> On 07/15/2011 12:34 PM, Chris Mason wrote:
> > > > [ triggering IO retries on failed crc or other checks ]
> > > >
> > > >>> But, maybe the whole btrfs model is backwards for a generic layer.
> > > >>> Instead of sending down ios and testing when they come back, we could
> > > >>> just set a verification function (or stack of them?).
> > > >>>
> > > >>> For metadata, btrfs compares the crc and a few other fields of the
> > > >>> metadata block, so we can easily add a compare function pointer and a
> > > >>> void * to pass in.
> > > >>>
> > > >>> The problem is the crc can take a lot of CPU, so btrfs kicks it off to
> > > >>> threading pools so saturate all the cpus on the box.  But there's no
> > > >>> reason we can't make that available lower down.
> > > >>>
> > > >>> If we pushed the verification down, the retries could bubble up the
> > > >>> stack instead of the other way around.
> > > >>>
> > > >>> -chris
> > > >> I do like the idea of having the ability to do the verification and retries down
> > > >> the stack where you actually have the most context to figure out what is possible...
> > > >>
> > > >> Why would you need to bubble back up anything other than an error when all
> > > >> retries have failed?
> > > > By bubble up I mean that if you have multiple layers capable of doing
> > > > retries, the lowest levels would retry first.  Basically by the time we
> > > > get an -EIO_ALREADY_RETRIED we know there's nothing that lower level can
> > > > do to help.
> > > >
> > > > -chris
> > > 
> > > Absolutely sounds like the most sane way to go to me, thanks!
> > > 
> > 
> > It really seemed like a good idea, but I just realized it doesn't work
> > well when parts of the stack transform the data.
> > 
> > Picture dm-crypt on top of raid1.  If raid1 is responsible for the
> > crc retries, there's no way to crc the data because it needs to be
> > decrypted first.
> > 
> > I think the raided dm-crypt config is much more common (and interesting)
> > than multiple layers that can retry for other reasons (raid1 on top of
> > raid10?)
> 
>    Isn't this a case where the transformative mid-layer would replace
> the validation function before passing it down the stack? So btrfs
> hands dm-crypt a checksum function; dm-crypt then stores that function
> for its own purposes and hands off a new function to the DM layer
> below that which decrypts the data and calls the btrfs checksum
> function it stored earlier.

Then we're requiring each transformation layer to have their own crcs,
and if the higher layers have a stronger crc (or other checks), there's
no path to ask the lower layers for other copies.

Here's a concrete example.  In each metadata block, btrfs stores the
fsid and the transid of the transaction that created it.  In the case of
a missed write, we'll read a perfect block from the lower layers.  Any
crcs will be correct and it'll pass through dm-crypt with flying colors.

But, it won't be the right block.  Btrfs will notice this and EIO.  In
the current ask-for-another-mirror config we'll go down and grab the
other copy.

In the stacked validation function model, dm-crypt replaces our
verification functions with something that operates on the encrypted
data, and it won't be able to detect the error or kick down to the
underlying raid1 for another copy.

-chris
