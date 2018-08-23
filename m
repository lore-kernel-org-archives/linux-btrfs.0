Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:32963 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbeHWVqQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 17:46:16 -0400
Received: by mail-it0-f67.google.com with SMTP id j198-v6so2631827ita.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 11:15:22 -0700 (PDT)
Date: Thu, 23 Aug 2018 14:15:18 -0400
From: Nicholas D Steeves <nsteeves@gmail.com>
To: dsterba@suse.cz, jkexcel <jkexcel@comcast.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs-convert missing in btrfs-tools v4.15.1
Message-ID: <20180823181516.4oq4yu7xzzueligq@navis>
References: <1438689914.6655.1532811050018@connect.xfinity.com>
 <20180728213448.GA16016@DigitalMercury.dynalias.net>
 <20180809115046.GX3218@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o2vgc72v7i2vjxie"
In-Reply-To: <20180809115046.GX3218@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--o2vgc72v7i2vjxie
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi everyone,

Sorry for the delay replying, I've been busy with other work.  Reply
follows inline.  P.S. sorry about the table in this email that is 99
columns wide.

On Thu, Aug 09, 2018 at 01:50:46PM +0200, David Sterba wrote:
> On Sat, Jul 28, 2018 at 05:34:49PM -0400, Nicholas D Steeves wrote:
> > On 28 July 2018 at 16:50, jkexcel <jkexcel@comcast.net> wrote:
> > > I'm an end user trying to use btrfs-convert but when I installed
> > > btrfs-tools and its dependency btrfs-progs on kubuntu 18.04, the
> > > installation was successful, and it shows that v4.15.1-1build1 was
> > > installed.
> > >
> > > However, when using the command  # brtfs-convert  /dev/sda4 (with the
> > > drive unmounted) the resulting error appears "command not found"
> > > I also tried command "btrfs convert" in case this was folded into the
> > > main tool, but this also failed.
> > >
> > > 1. Is btrfs-convert still available?
> > >
> > > 2. Where can I find it?
> > >
> > > 3. Has btrfs-convert been replaced? what is it's new name?
> > >
> > > 4. Is it safe to use a downgraded version of btrfs-tools ie: 4.14 or
> > > older?
> >=20
> > You can blame me for that.  In Debian several users had reported
> > release-critical issues in btrfs-convert, so I submitted a patch to
> > disable it for the forseable future, eg:
> >=20
> >   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D864798
> >   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D854489
>=20
> The reports are against version 4.7.3 released one year before the time
> of the bug reports. The fix for the reported bug happened in 4.10, that
> was half a year before the bug.

Debian stable will always have an old version, which will be in use
for two to four years.  Btrfs-progs 4.7.3 will be in use in Debian 9
until at least 2021, possibly longer.  Btw, I strongly believe Debian 9
should have shipped with btrfs-progs 4.9.1, but alas the primary
maintainer didn't upload it on time.

For "buster" (Debian 10), which will probably be released in mid 2019,
the newest possible btrfs-progs version that could be included is
whatever is current at the end of January 2019.  Exceptions are
sometimes granted for an unblock of a newer version.  For example, if
an LTS kernel won't be released until March, and the release,
technical committee, and kernel team decide that's the version we
want, then a preapproved exception will be granted.  At that time an
argument can be made for preapproval of a newer btrfs-progs as well.

That said, I try to keep a backported newer version of btrfs-progs for
the stable Debian release reasonably up-to-date (backports are
available to users on a per-package opt-in basis).  That's the channel
for feature enablement.  Also, my apologies, at the moment this
backport is very much out of date--it stalled while investigating
which packages would be broken by the library reorganisation;
although, from what I can tell that would only be snapper.

> > Also, please consider the official status "As of 4.0 kernels this featu=
re
> > is not often used or well tested anymore, and there have been some repo=
rts
> > that the conversion doesn't work reliably. Feel free to try it out, but
> > make sure you have backups" (
> > https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3 ).
>=20
> Sorry that this you take it as official status. The wiki is open to
> edits and such claims appear there from time to time. I've removed it,
> it's been there since 2015 when it possibly was accurate but it's not
> anymore.

Is there a more authoritative and up-to-date location for various
statuses?  It would be nice to have something in btrfs-progs as a
table like this, or exportable in some kind of human-friendly format:

+-------+-----------------------------------------+------------+-----------=
-------+---------------+
|Feature|1st mainline version where feature       |LTS kernel 1|LTS kernel =
2      |LTS kernel 3   |
|       |appeared                                 |eg: 4.4     |eg: 4.9    =
       |eg: 4.14       |
+-------+-----------------------------------------+------------+-----------=
-------+---------------+
|convert|Assume -progs and kernel                 |exp?        |mostly?    =
       |stable?        |
|from   |vessions are strongly                    |            |  amend    =
       |               |
|ext3/4 |associated, for simplicity.              |            |  status wi=
th:    |               |
|       |                                         |            |4.9.z:testi=
ng     |               |
+-------+-----------------------------------------+------------+-----------=
-------+---------------+
|foo    |3.16:danger||exp||mostly||testing||stable|exp         |mostly     =
       |testing        |
+-------+-----------------------------------------+------------+-----------=
-------+---------------+

Ideally something that could be trivially exported to the format the
btrfs.wiki.kernel.org wiki uses.  The trick is to make it convenient
to maintain...  Other than CSV, I'm not sure what would work well for
non-emacs users.  When the oldest LTS kernel is considered depreciated
by the btrfs upstream community, "depreciated" is added to the column
header, and when a 4th LTS kernel becomes available the oldest LTS
column is dropped and a new empty column is appended.  Oh, there could
also be a column for current mainline version, but I don't want to
maintain that column, and I suspect no one else would either.

It would also be nice to add various optimisations to the "Feature"
column as they become available.  Ideally it would also be nice to
have an auto-generated bug matrix, but I digress.

If there is not yet a canonical/official table for various btrfs
features' statuses then I'd be happy to start work on one--given that
the official upstream wiki is nonauthoritative...  At the moment 1)
I'd use either a table like the one above, something from org-mode, or
a CSV.  2) I'd fill it in from the wiki, with versions informed by the
bugs I'm aware of  3) I would always err on the side of caution,
because I believe that the most important thing for btrfs right now
are incident-free success stories, and overly optimistic
recommendations will not provide these.  4) I'd submit the patch for
discussion and review.

> > I'm happy to hear it is still disabled in Ubuntu, where many more
> > users would be affected.  IIRC OpenSUSE LEAP and SLED 15 reenabled it
> > (it was previously disabled there), so maybe it needs specific kernel
> > versions or patches to not trigger RC bugs, and/or very specific
> > btrfs-progs versions, and/or very specific e2fslibs, and/or specific
> > combinations?  While I very much look forward to the day when
> > btrfs-convert can be relied on in Debian, I don't think we're there
> > yet.
>=20
> So if there's no way to update package to newer version or nobody who
> backports fixes, then it's better not to ship the tool. There's nothing
> close to the 'specific version of X', besides using more up to date
> versions. Alternatively, there could have been a separate package with
> the convert tool, with a warning about the known issues.

Briefly, in Debian, backported fixes (to the stable version) are only
approved for security and release critical bugs, and never for feature
enablement.  Supposing btrfs-convert had been its own package, this
package would have been dropped from testing if a targeted fix
couldn't be found and uploaded within a week or two.  During the
freeze entry of new upstream versions is blocked, and reentry of
dropped packages is also blocked.

Once Debian has KVM-isolated machines for running continuous
integration, the plan is to enable self-tests in CI.  Generally
regressions will also block migration of new versions, so that's yet
another way Debian ends up with old versions--unless the issues are
fixed...but at least this will occur during the general development
phase of the release cycle, where there is a lot more time to fix
issues :-)

> It's in my interest to ship all tools in distros, but there's also only
> that much what the upstream community can do. If you're going to
> reconsider the status of btrfs-convert in Debian, please let me know.

Yes, I'd be happy to advocate for its reinclusion if the answer to
4/5 of the following questions is "yes".  Does SUSE now recommend the
use of btrfs-convert to its enterprise customers?  The following is a
frustrating criteria, but: Can a random desktop user run btrfs-convert
against their ext4 rootfs and expect the operation to succeed?  Is
btrfs-convert now sufficiently trusted that it can be recommended with
the same degree of confidence as a backup, mkfs.btrfs, then restore to
new filesystem approach?  Does the user of a btrfs volume created with
btrfs-convert have an equal or lesser probability of encountering bugs
compared to a one who used mkfs.btrfs?

Sincerely,
Nicholas

--o2vgc72v7i2vjxie
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE4qYmHjkArtfNxmcIWogwR199EGEFAlt++bEACgkQWogwR199
EGFWWBAAktgorgiYjpf7DqhCYlj9+mGnO5XPQ3xIXbgl4sAN/1pIqjNNqqCvPlV+
l7oQBll2yTLYJ3PzOU8QN4y5RH67+8ZvONlkdPikwa0dFj05WtUqAskqGNazCLIP
okjQLS6PRXMqBUn3iFF3dHPcGdiD1wp09WBaQOfuzD+reLoNfaWAqJMguMieEVdj
xpJC4FyxtgA/P5CiTXZ9Ztyzmv/GejghJVM/SC6HOaVPi04LIwic9NC0SFOmx3/n
OYB5MzNl0gVEdT2DuOH/LNrkw++0vOczRIwHLpgfXuXsAhPJRJEevByFy4p7hbGR
YRUJMZVMFw+RH2NeR5OFMtoL4vmA4Y2+VUwSqLweANsaMlgNOWnQkG5W375FX3sx
RKI4NKeGP5axEDvRwapA+MbfdfFeGLqLarEBDtZM7ElXr9cOFH7EYGs3RyZRlh30
Ph7o5g1hVF4ffmhnPVIkCg+5ouplphz1pRg13q499/ALQHGHeMq7nhtBcY74foyx
NStaP3YhhB2HU4nOByBQ5Hv1J6uBWGJ5HEzWEjpJKR+eEJGDc1fGiwbiiJ7nHmGc
ezRa3HQv/Y4yi51ONzOSDpegj6RlfN6aFjGbe3SDB5jYvVeLdiPFzAXSrQdd9tQQ
J5gqqLKHb9OPv5EKh8aOXrWpaTEZDWl4PEm0xSKgOnDaIMVEnkk=
=TeAC
-----END PGP SIGNATURE-----

--o2vgc72v7i2vjxie--
