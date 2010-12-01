From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 19:35:12 +0000
Message-ID: <20101201193512.GB4087@carfax.org.uk>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
 <20101201163800.GA4087@carfax.org.uk>
 <20101201173830.GA7021@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101201173830.GA7021@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 01, 2010 at 12:38:30PM -0500, Josef Bacik wrote:
> On Wed, Dec 01, 2010 at 04:38:00PM +0000, Hugo Mills wrote:
> > On Wed, Dec 01, 2010 at 09:21:36AM -0500, Josef Bacik wrote:
> > > === Quotas ===
> > > 
> > > This is a huge topic in and of itself, but Christoph mentioned wanting to have
> > > an idea of what we wanted to do with it, so I'm putting it here.  There are
> > > really 2 things here
> > > 
> > > 1) Limiting the size of subvolumes.  This is really easy for us, just create a
> > > subvolume and at creation time set a maximum size it can grow to and not let it
> > > go farther than that.  Nice, simple and straightforward.
> > > 
> > > 2) Normal quotas, via the quota tools.  This just comes down to how do we want
> > > to charge users, do we want to do it per subvolume, or per filesystem.  My vote
> > > is per filesystem.  Obviously this will make it tricky with snapshots, but I
> > > think if we're just charging the diff's between the original volume and the
> > > snapshot to the user then that will be the easiest for people to understand,
> > > rather than making a snapshot all of a sudden count the users currently used
> > > quota * 2.
> > 
> >    This is going to be tricky to get the semantics right, I suspect.
> > 
> >    Say you've created a subvolume, A, containing 10G of Useful Stuff
> > (say, a base image for VMs). This counts 10G against your quota. Now,
> > I come along and snapshot that subvolume (as a writable subvolume) --
> > call it B. This is essentially free for me, because I've got a COW
> > copy of your subvolume (and the original counts against your quota).
> > 
> >    If I now modify a file in subvolume B, the full modified section
> > goes onto my quota. This is all well and good. But what happens if you
> > delete your subvolume, A? Suddenly, I get lumbered with 10G of extra
> > files.  Worse, what happens if someone else had made a snapshot of A,
> > too? Who gets the 10G added to their quota, me or them? What if I'd
> > filled up my quota? Would that stop you from deleting your copy,
> > because my copy can't be charged against my quota? Would I just end up
> > unexpectedly 10G over quota?
> > 
> 
> If you delete your subvolume A, like use the btrfs tool to delete it, you will
> only be stuck with what you changed in snapshot B.  So if you only changed 5gig
> worth of information, and you deleted the original subvolume, you would have
> 5gig charged to your quota.

   This doesn't work, though, if the owners of the "original" and
"new" subvolume are different:

Case 1:

 * Porthos creates 10G data.
 * Athos makes a snapshot of Porthos's data.
 * A sysadmin (Richelieu) changes the ownership on Athos's snapshot of
   Porthos's data to Athos.
 * Porthos deletes his copy of the data.

Case 2:

 * Porthos creates 10G of data.
 * Athos makes a snapshot of Porthos's data.
 * Porthos deletes his copy of the data.
 * A sysadmin (Richelieu) changes the ownership on Athos's snapshot of
   Porthos's data to Athos.

Case 3:

 * Porthos creates 10G data.
 * Athos makes a snapshot of Porthos's data.
 * Aramis makes a snapshot of Porthos's data.
 * A sysadmin (Richelieu) changes the ownership on Athos's snapshot of
   Porthos's data to Athos.
 * Porthos deletes his copy of the data.

Case 4:

 * Porthos creates 10G data.
 * Athos makes a snapshot of Porthos's data.
 * Aramis makes a snapshot of Athos's data.
 * Porthos deletes his copy of the data.
   [Consider also Richelieu changing ownerships of Athos's and Aramis's
   data at alternative points in this sequence]

   In each of these, who gets charged (and how much) for their copy of
the data?

>  The idea is you are only charged for what blocks
> you have on the disk.  Thanks,

   My point was that it's perfectly possible to have blocks on the
disk that are effectively owned by two people, and that the person to
charge for those blocks is, to me, far from clear. You either end up
charging twice for a single set of blocks on the disk, or you end up
in a situation where one person's actions can cause another person's
quota to fill up. Neither of these is particularly obvious behaviour.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- I believe that it's closely correlated with ---           
                       the aeroswine coefficient.                        

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM9qNwIKyzvlFcI40RAnL1AJ9u3GvoRAuUMBJnwVWqi8NJVjEyFQCffveR
jfx+Pl+EFi+JZFuVo8AYTKo=
=mxht
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
