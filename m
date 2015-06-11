Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39962 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbbFKRdO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 13:33:14 -0400
Date: Thu, 11 Jun 2015 17:33:59 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use received_uuid of parent during send
Message-ID: <20150611173359.GL18226@carfax.org.uk>
References: <1433452645-7904-1-git-send-email-jbacik@fb.com>
 <20150611170942.GK18226@carfax.org.uk>
 <5579C26A.4040203@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QWRRbczYj8mXuejp"
In-Reply-To: <5579C26A.4040203@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--QWRRbczYj8mXuejp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 11, 2015 at 01:16:26PM -0400, Josef Bacik wrote:
> On 06/11/2015 01:09 PM, Hugo Mills wrote:
> >On Thu, Jun 04, 2015 at 05:17:25PM -0400, Josef Bacik wrote:
> >>Neil Horman pointed out a problem where if he did something like this
> >>
> >>receive A
> >>snap A B
> >>change B
> >>send -p A B
> >>
> >>and then on another box do
> >>
> >>recieve A
> >>receive B
> >>
> >>the receive B would fail because we use the UUID of A for the clone sources for
> >>B.  This makes sense most of the time because normally you are sending from the
> >>original sources, not a received source.  However when you use a recieved subvol
> >>its UUID is going to be something completely different, so if you then try to
> >>receive the diff on a different volume it won't find the UUID because the new A
> >>will be something else.  The only constant is the received uuid.  So instead
> >>check to see if we have received_uuid set on the root, and if so use that as the
> >>clone source, as btrfs receive looks for matches either in received_uuid or
> >>uuid.  Thanks,
> >
> >    While this deals with Neil's problem, there's a few other use-cases
> >that people have been asking for that (I think) it won't deal with.
> >
> >    I think ultimately we should be sending all three of the parent
> >UUID, the parent's Received UUID (if it exists), and the parent's
> >Parent UUID. That would have to go in the FARv2 update, though.
> >
> >    However, since this patch doesn't rule out the above happening at
> >some future date, and I think it'll do the job as described above,
> >
> 
> Yeah I'd like to send more information so we can better find the
> UUID we're looking for, but I think at least trying to keep a
> consistent UUID we carry around would be good.  Received UUID mostly
> accomplishes this, I'd like to know what other use cases aren't
> working so we can think about what we need to do for them.  Thanks,

   I did a write-up of this a while ago, in some detail (which is why
I weighed in here):

http://www.spinics.net/lists/linux-btrfs/msg44089.html

   I'm afraid it's rather long, but the tl;dr is the second indented
section in "What to do about it", with the notation described in
detail in the first few paragraphs.

   Hugo.

-- 
Hugo Mills             | ... one ping(1) to rule them all, and in the
hugo@... carfax.org.uk | darkness bind(2) them.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                Illiad

--QWRRbczYj8mXuejp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVecaHAAoJEFheFHXiqx3k91cP/io2giU+BSCYgGY5x87Tq1Zi
SbcltatD+PaLFShe2gphmFcbeLfxjKRs06V8bAGvUQ0YyONjuD5LmsDONQhZqapp
O2n3y1pEnRXlhyU3qSoZ3T3psLLSuRDvYLpqAm3fZ8qHeZg9gP+1alJB0jzvXYvH
SJE1SGIOfUpETEun+be4fKNRXt9CMqLA4lZDfDlJAUAiUgan17sxsIWZbbCfeEUL
lGeYlcP3OpJXDwzs2eh+oIeIA9flk1UWg+HoYtz/zKHhRKL66ZMy+U52YZcn4W7x
X5QOUtdEriPCu94HQ761Mty2vJVENX1Luk9mzhbUsVfOz/JuFPXEFtKyNN/g4LrH
wDSX983AprQYHinjoL9uZ74J8/NYwIGQQDTHD9+amrFQzScRncduw5QqHo/ShUbs
hPok0F/UFdi1xXIUltnaZmmR9bVUtCReDoKjP6cfnSF3IYX63lkT3vr+4seS/KfX
5ZPLK0xNnr4J55qXkfRuPIWuAGXgz1GfK2h5H97z8teQ2MBXrdLVSF4+un/IRwV9
4z9RDTp79PNhvU/K+5YLuTEALQoNaQ6kKgI67+UG3Jy6UVpAGClPdeFaXFH0P44f
SrnLHqhMcDho8bjUkBGTjOvGl7gjsesNd812lsHN86vjgQxEnIS8WdVCpAfbuy3k
vJl+zEpyNpZDyJ7Uyi8C
=K9aA
-----END PGP SIGNATURE-----

--QWRRbczYj8mXuejp--
