From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Mis-Design of Btrfs?
Date: Fri, 15 Jul 2011 15:54:36 +0100
Message-ID: <20110715145436.GB29265@carfax.org.uk>
References: <1310696606-sup-710@shiny>
 <alpine.DEB.2.02.1107142149420.3558@asgard.lang.hm>
 <20110715163354.74fa2083@notabene.brown>
 <1310728784-sup-9024@shiny>
 <4E20395C.1000301@redhat.com>
 <1310735821-sup-2589@shiny>
 <4E204139.5060702@redhat.com>
 <1310738205-sup-715@shiny>
 <20110715140724.GA29265@carfax.org.uk>
 <1310739313-sup-2118@shiny>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Cc: Ric Wheeler <rwheeler@redhat.com>, NeilBrown <neilb@suse.de>,
	david <david@lang.hm>,
	Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1310739313-sup-2118@shiny>
List-ID: <linux-btrfs.vger.kernel.org>


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 15, 2011 at 10:24:25AM -0400, Chris Mason wrote:
> Excerpts from Hugo Mills's message of 2011-07-15 10:07:24 -0400:
> > On Fri, Jul 15, 2011 at 10:00:35AM -0400, Chris Mason wrote:
> > > Excerpts from Ric Wheeler's message of 2011-07-15 09:31:37 -0400:
> > > > On 07/15/2011 02:20 PM, Chris Mason wrote:
> > > > > Excerpts from Ric Wheeler's message of 2011-07-15 08:58:04 -0400:
> > > > >> On 07/15/2011 12:34 PM, Chris Mason wrote:
> > > > > [ triggering IO retries on failed crc or other checks ]
> > > > >
> > > > >>> But, maybe the whole btrfs model is backwards for a generic layer.
> > > > >>> Instead of sending down ios and testing when they come back, we could
> > > > >>> just set a verification function (or stack of them?).
> > > > >>>
> > > > >>> For metadata, btrfs compares the crc and a few other fields of the
> > > > >>> metadata block, so we can easily add a compare function pointer and a
> > > > >>> void * to pass in.
> > > > >>>
> > > > >>> The problem is the crc can take a lot of CPU, so btrfs kicks it off to
> > > > >>> threading pools so saturate all the cpus on the box.  But there's no
> > > > >>> reason we can't make that available lower down.
> > > > >>>
> > > > >>> If we pushed the verification down, the retries could bubble up the
> > > > >>> stack instead of the other way around.
> > > > >>>
> > > > >>> -chris
> > > > >> I do like the idea of having the ability to do the verification and retries down
> > > > >> the stack where you actually have the most context to figure out what is possible...
> > > > >>
> > > > >> Why would you need to bubble back up anything other than an error when all
> > > > >> retries have failed?
> > > > > By bubble up I mean that if you have multiple layers capable of doing
> > > > > retries, the lowest levels would retry first.  Basically by the time we
> > > > > get an -EIO_ALREADY_RETRIED we know there's nothing that lower level can
> > > > > do to help.
> > > > >
> > > > > -chris
> > > > 
> > > > Absolutely sounds like the most sane way to go to me, thanks!
> > > > 
> > > 
> > > It really seemed like a good idea, but I just realized it doesn't work
> > > well when parts of the stack transform the data.
> > > 
> > > Picture dm-crypt on top of raid1.  If raid1 is responsible for the
> > > crc retries, there's no way to crc the data because it needs to be
> > > decrypted first.
> > > 
> > > I think the raided dm-crypt config is much more common (and interesting)
> > > than multiple layers that can retry for other reasons (raid1 on top of
> > > raid10?)
> > 
> >    Isn't this a case where the transformative mid-layer would replace
> > the validation function before passing it down the stack? So btrfs
> > hands dm-crypt a checksum function; dm-crypt then stores that function
> > for its own purposes and hands off a new function to the DM layer
> > below that which decrypts the data and calls the btrfs checksum
> > function it stored earlier.
> 
> Then we're requiring each transformation layer to have their own crcs,
> and if the higher layers have a stronger crc (or other checks), there's
> no path to ask the lower layers for other copies.
> 
> Here's a concrete example.  In each metadata block, btrfs stores the
> fsid and the transid of the transaction that created it.  In the case of
> a missed write, we'll read a perfect block from the lower layers.  Any
> crcs will be correct and it'll pass through dm-crypt with flying colors.
> 
> But, it won't be the right block.  Btrfs will notice this and EIO.  In
> the current ask-for-another-mirror config we'll go down and grab the
> other copy.
> 
> In the stacked validation function model, dm-crypt replaces our
> verification functions with something that operates on the encrypted
> data, and it won't be able to detect the error or kick down to the
> underlying raid1 for another copy.

   What I'm suggesting is easiest to describe with a functional
language, or mathematical notation, but I'll try without those
anyway...

   A generic validation function is a two-parameter function, taking a
block of data and some layer-dependent state, and returning a boolean.

So, at the btrfs layer, we have something like:

struct btrfs_validate_state {
	u32 cs;
};

bool btrfs_validate(void *state, char *data) {
	return crc32(data) == (btrfs_validate_state*)state->cs;
}

   When reading a specific block, we look up the checksum for that
block, put it in state->cs and pass both our state and the
btrfs_validate function to the lower layer.

   The crypto layer beneath will look something like:

struct crypto_validate_state {
	void *old_state;
	bool (*old_validator)(void *state, char* data);
};

bool crypto_validate(void *state, char *data) {
	char plaintext[4096];
	decrypt(plaintext, data);
	
	return state->old_validator(state->old_state, plaintext);
}

   Then, when a request is received from the upper layer, we can put
the (state, validator) pair into a crypto_validate_state structure,
call that our new state, and pass on the new (state, crypto_validate)
to the layer underneath.

   So, where a transformative layer exists in the stack, it replaces
the validation function with a helper function that does the necessary
transformation, and performs the check.

   The code I've described above would clearly need to be hooked into
the existing data-transformation paths so that we don't replicate the
effort of decrypting or uncompressing good data once we've decided
that it _is_ good.

   Oh, and if there's a layer with its own validation, we can put in a
"firebreak" implementation of the above code, which basically drops
the validator it's passed, and replaces it completely with its own.
(This would look exactly like the btrfs version at the top of my reply
here).

   The standard case for most block-layer implementations will simply
be to pass the (state, validator) pair unchanged to the lower layer,
because the block being checked won't be any different. It's only
where we have layers that change things, or definitely know better
than the top layer that we need to play tricks.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- Sometimes, when I'm alone, I Google myself. ---           

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOIFSsIKyzvlFcI40RAmDbAKCYpvLnPaHv2yf/MZ0L1SZDSY8nRACfR1JI
wH4nXu/G2u9NjBR6Wgj2F4g=
=+EYq
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
