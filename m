From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: subvolumes missing from "btrfs subvolume list" output
Date: Wed, 29 Jun 2011 17:47:41 +0100
Message-ID: <20110629164741.GA11170@carfax.org.uk>
References: <chaz20110629143747.GA28702@seebyte.com>
 <chaz20110629150041.GB28702@seebyte.com>
 <4E0B4FC6.4030006@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Cc: Stephane Chazelas <stephane.chazelas@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0B4FC6.4030006@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 29, 2011 at 12:16:06PM -0400, Josef Bacik wrote:
> On 06/29/2011 11:00 AM, Stephane Chazelas wrote:
> > 2011-06-29 15:37:47 +0100, Stephane Chazelas:
> > [...]
> >> I found
> >> http://thread.gmane.org/gmane.comp.file-systems.btrfs/8123/focus=8208
> >>
> >> which looks like the same issue, with Li Zefan saying he had a
> >> fix, but I couldn't find any mention that it was actually fixed.
> >>
> >> Has anybody got any update on that?
> > [...]
> > 
> > I've found
> > http://thread.gmane.org/gmane.comp.file-systems.btrfs/8232
> > 
> > but no corresponding fix or ioctl.c
> > http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=history;f=fs/btrfs/ioctl.c
> > 
> > I'm under the impression that the issue has been forgotten
> > about.
> > 
> > From what I managed to gather though, it seems that what's on
> > disk is correct, it's just the ioctl and/or "btrfs sub list"
> > that's wrong. Am I right?
> 
> Yeah, did you apply the patch from that thread and verify that it fixes
> your problem?  Thanks,

   Note that changing this API will probably break btrfs-gui's listing
of subvolumes...

   The issue with that patch is that there are two distinct behaviours
that people want or expect with the tree-search ioctl:

(A) Return all items with keys which collate linearly between
    (min_objectid, min_type, min_offset) and 
    (max_objectid, max_type, max_offset)

    i.e. treating keys as indivisible objects and sorting lexically,
    as the trees do.

(B) Return all items with keys (i, t, o) which fulfil the criteria
    (min_objectid <= i <= max_objectid,
     min_type <= t <= max_type,
     min_offset <= o <= max_offset)

    i.e. treating keys as 3-tuples, and selecting from a rectilinear
    subsset of the tuple space, which is natural for some
    applications.

   Clearly, we can't do both with the same call (except for some
limited cases (*)). However, different users expect different
behaviours. The current behaviour is (A), which is the "natural"
behaviour for tree searches within the btrfs code, and is (IMO) the
right thing to be doing for an API like this.

   It sounds to me like the user of the API needs to be fixed, not the
ioctl itself -- possibly the author of the subvol scanning code
assumed (B) when they were getting (A). Note that there is at least
one other user of the ioctl outside btrfs-progs: btrfs-gui, which uses
the ioctl for several things, one of which is enumerating subvolumes
as btrfs-progs does.

   It should be possible to write an additional ioctl for behaviour
(B) which contains both min and max limits on each element of the key
3-tuple, *and* the current search state. That would reduce developer
confusion (given appropriate comments or documentation to explain what
the difference between the two is). However, I'm not sufficiently
convinced that it's actually necessary right now. I may change my tune
after I've started doing some of the more complex bits I'd thought of
doing with btrfs-gui, but for now, it's perfectly possible to use the
existing API without too much hassle.

   Hugo.

(*) The limited cases where both behaviours return the same set of
keys are:

(i_0, 0, 0) to (i_1, -1UL, -1UL)
(i, t_0, 0) to (i, t_1, -1UL)
(i, t, o_0) to (i, t, o_1)

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- I get nervous when I see words like 'mayhaps' in a novel, ---    
                because I fear that just round the corner                
                          is lurking 'forsooth'                          

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOC1ctIKyzvlFcI40RAnU0AKCUYWxbBV748PP/zB9im30gVLeuUACghVO4
2g8r28zLB3CaZowHT+fJ0y0=
=xkGm
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
