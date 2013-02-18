Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35821 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3BRLUR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 06:20:17 -0500
Date: Mon, 18 Feb 2013 11:20:11 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hemanth Kumar <hemanthkumar51@gmail.com>
Cc: linux-btrfs@vger.kernel.org, skjmca51@gmail.com, ganeshkumar14@gmail.com,
        kirantpatil@gmail.com, praneethu.u@gmail.com, chethan.casey@gmail.com,
        sensille@gmx.net, bo.li.liu@oracle.com, sandeen@redhat.com
Subject: Re: [btrfs-progs] testing btrfs hierarchical quotas
Message-ID: <20130218112011.GM28997@carfax.org.uk>
References: <1360933541-2894-1-git-send-email-hemanthkumar51@gmail.com>
 <20130215205906.GI28997@carfax.org.uk>
 <CAG_LFoCRWaKHe2_AYspN3qUUFw4iWgdB56fWeSGP5C0iKAaX8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dp9QYJgVRVEW2bsm"
In-Reply-To: <CAG_LFoCRWaKHe2_AYspN3qUUFw4iWgdB56fWeSGP5C0iKAaX8w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dp9QYJgVRVEW2bsm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 18, 2013 at 10:44:06AM +0530, Hemanth Kumar wrote:
> On Sat, Feb 16, 2013 at 2:29 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >    Here's a question -- what are you testing? (Not just here, but in
> > general, with your test infrastructure)
> >
> >    There are (at least) three classes of tests you could be doing:
> >
> > 1) Unit tests, which test individual functions within the code and
> >    ensure they do what they're meant to do.
> >
> > 2) Integration tests, which test the full end-to-end system.
> >
> > 3) Partial integration tests, which exercise the kernel
> >    filesystem code.
> >
> > 4) Partial integration tests, which exercise the userspace tools code.
> >
> >
> >    Now, clearly you're not doing (1) here. It's going to be hard to
> > separate (2) from (3) and (4), but it's possible to write your tests
> > to do more of one or of the other. (*)
> >
> 
> I am tying to write a script to test quota subsystem (qgroups) and
> hierarchical quota as suggested by Arne Jansen.
> Since i am trying to write a script to test a particular feature i guess it
> falls under unit testing category

   No, unit testing would typically be testing one individual function
in the code, independently of the rest of the code-base. e.g. a
battery of very small simple tests which verify that the device_size()
function in utils.c returns the correct value in all cases.

   When you say "test a particular feature", you haven't distinguished
between testing the *kernel* feature (i.e. "does the kernel behave
correctly?") and the *userspace* feature (i.e. "does the userspace
tool make all of the checks that it should do, tell the kernel to do
the right thing, and return useful information when something fails?").

   It's hard to separate these two fully without effectively
reimplementing some part of the other side, but the decision either
way will make a difference as to the set of tests you end up
implementing.

> >    xfstests clearly is much more geared to (3), and stresses the
> > kernel filesystem implementation rather than the userspace tools. If
> > you want to test the implementation of qgroups, it belongs in
> > xfstests. If you want to test the userspace code, you need to make
> > sure that (over all your tests) you cover every command-line option,
> > and every different way of using the tool, and ensure that it does the
> > right things.
> >
> >    What you've written in this patch seems to be more about testing
> > the kernel behaviour than the userspace tools, but it'd be good if you
> > can put your work into the context I've just talked about above.
> >
> >    More comments below...
> >
> > On Fri, Feb 15, 2013 at 06:35:41PM +0530, Hemanth Kumar wrote:
> > >
> > > Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
> > > ---
> > >  hq.sh | 33 +++++++++++++++++++++++++++++++++
> > >  1 file changed, 33 insertions(+)
> > >  create mode 100644 hq.sh
> > >
> > > diff --git a/hq.sh b/hq.sh
> > > new file mode 100644
> > > index 0000000..6a0a820
> > > --- /dev/null
> > > +++ b/hq.sh
> >
> >    Rather cryptic filename here.
> >
> >    If this is to be applied to btrfs-progs, I'd recommend putting all
> > your test scripts in a test subdir, and a "test" target in the
> > Makefile that invokes the tests.
> >
> 
> Can you elaborate on this part a bit more.

   Ignore my comment. As Dave Chinner pointed out, this is best
integrated into xfstests.

[snip]
> >
> >    You may want to take a look at my earlier work on this, at:
> > http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg13153.html
> > That should at least give you a basic infrastructure to work in.
[snip] 
> Thank you, I will take a look at your script and continue my work.

   Again, don't bother -- Dave was right, and my assumptions about
what xfstests was actually doing were wrong. Use xfstests instead.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- We believe in free will because we have no choice. ---        

--dp9QYJgVRVEW2bsm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUSIOa79z9OVl50rAAQLNcg/9FWR+m23iPXSu/QdiCIuZDGe/LEQNRJkc
0YKIUpsEfizI5nz4jZbra6uWHsS4jtjGzTBTS3f/ZthzbJyCc0U6aKa7tHw2f0Kb
UiLpJ8EDkvr0yXCFota2hkSDz1ItTMa3UC0Dm7eyEK/xy9bDCTvQrh8STwujdqwk
5EyL0z0NHaOmYiJE4yFwLLnBqeGHUfS91BeBXBG70RJu4w6OaE/vZ4WTGcQQPrXa
BxTvN3RI/yV/QagoPIPIQfGsc8pUQZfwDy500486wZ/zqk/EDACK2AVoc5FIQJA8
RWrVKhNigfrLB502Yi+/JWIMYpmfqFaM6GdMZoEEikBuc4d/J5l9HPl7n2HF4Kkw
YUuN9CG29vVqP7jgT0c8sgRnpoYr5B8I5x1CSO7aFaNsf7lso9OuK1e8mcDZ8KKU
hP9bIUSqZVHk/LMntfP6372NOz8vCTztrjYwlEovf1gkKzbVvUz4Q5VQme8+t0i4
0HV2t0D0mxq+bWSe/P5scgTsAq5dvG5Xt6904KHSQZe4w+0HlMtqhbslnWvAfpwu
rQnndTMU4fHI0oIpgYQWBHgSQiFktzZS5l66t74fik/+jf1iIs1forfUT9n/kDnv
NmqSrNz/ycAEz7qpu8TPgsAy8itC8EIVxwNh3srSL9n/PSnA2p3OwxiNsIat+E+M
QmohFiqh3TQ=
=7F1Q
-----END PGP SIGNATURE-----

--dp9QYJgVRVEW2bsm--
