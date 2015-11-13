Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38217 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbbKMTzW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 14:55:22 -0500
Date: Fri, 13 Nov 2015 19:55:20 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Vedran Vucic <vedran.vucic@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: illegal snapshot, cannot be deleted
Message-ID: <20151113195520.GG24333@carfax.org.uk>
References: <CAHTEL3=r8kUJOU=xUAg2iG52HuWmqQ16QxUjY6d+zqbziW5+gw@mail.gmail.com>
 <564486F3.5020804@gmail.com>
 <CAHTEL3mEGmc5BhbGMEAbyPNU90nFQGZprLkWrh1WaEh5sSiH8w@mail.gmail.com>
 <56461034.3070209@gmail.com>
 <CAHTEL3m0uGWZGWUH_SLmg8TqMe4DcXU77p+S=4Aebukr1BZ-Bg@mail.gmail.com>
 <56462784.2060601@gmail.com>
 <20151113184227.GF24333@carfax.org.uk>
 <56463CBC.70808@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="reI/iBAAp9kzkmX4"
In-Reply-To: <56463CBC.70808@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--reI/iBAAp9kzkmX4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 13, 2015 at 02:40:44PM -0500, Austin S Hemmelgarn wrote:
> On 2015-11-13 13:42, Hugo Mills wrote:
> >On Fri, Nov 13, 2015 at 01:10:12PM -0500, Austin S Hemmelgarn wrote:
> >>On 2015-11-13 12:30, Vedran Vucic wrote:
> >>>Hello,
> >>>
> >>>Here are outputs of commands as you requested:
> >>>  btrfs fi df /
> >>>Data, single: total=8.00GiB, used=7.71GiB
> >>>System, DUP: total=32.00MiB, used=16.00KiB
> >>>Metadata, DUP: total=1.12GiB, used=377.25MiB
> >>>GlobalReserve, single: total=128.00MiB, used=0.00B
> >>>
> >>>btrfs fi show
> >>>Label: none  uuid: d6934db3-3ac9-49d0-83db-287be7b995a5
> >>>         Total devices 1 FS bytes used 8.08GiB
> >>>         devid    1 size 18.71GiB used 10.31GiB path /dev/sda6
> >>>
> >>>btrfs-progs v4.0+20150429
> >>>
> >>Hmm, that's odd, based on these numbers, you should be having no
> >>issue at all trying to run a balance. You might be hitting some
> >>other bug in the kernel, however, but I don't remember if there were
> >>any known bugs related to ENOSPC or balance in the version you're
> >>running.
> >
> >    There's one specific bug that shows up with ENOSPC exactly like
> >this. It's in all versions of the kernel, there's no known solution,
> >and no guaranteed mitigation strategy, I'm afraid. Various things like
> >balancing, or adding, balancing, and removing a device again have been
> >tried. Sometimes they seem to help; sometimes they just make the
> >problem worse.
> >
> >    We average maybe one report a week or so with this particular
> >set of symptoms.
> We should get this listed on the Wiki on the Gotcha's page ASAP,
> especially considering that it's a pretty significant bug (not quite
> as bad as data corruption, but pretty darn close).

   It's certainly mentioned in the FAQ, in the main entry on
unexpected ENOSPC. The text takes you through identifying when there's
the "usual" problem, then goes on to say that if you've hit ENOSPC
with free space still to be unallocated, you've got this issue.

> Vedran, could you try running the balance with just '-dusage=40' and
> then again with just '-musage=40'?  If just one of those fails, it
> could help narrow things down significantly.
> 
> Hugo, is there anything else known about this issue (I don't recall
> seeing it mentioned before, and a quick web search didn't turn up
> much)?

   I grumble about it regularly on IRC, where we get many more reports
of it than on the mailing list. There have been a couple on here that
I can recall, but not many.

>  In particular:
> 1. Is there any known way to reliably reproduce it (I would assume
> not, as that would likely lead to a mitigation strategy.  If someone
> does find a reliable reproducer, please let me know, I've got some
> significant spare processor time and storage space I could dedicate
> to getting traces and filesystem images for debugging, and already
> have most of the required infrastructure set up for something like
> this)?

   None that I know of. I can start asking people for btrfs-image
dumps again, if you want to investigate. I did do that for a while, to
pass them to josef, but he said he didn't need any more of them after
a while. (He was always planning on investigating it, but kept getting
diverted by data corruption bugs, which have higher priority).

> 2. Is it contagious (that is, if I send a snapshot from a filesystem
> that is affected by it, does the filesystem that receives the
> snapshot become affected; if we could find a way to reproduce it, I
> could easily answer this question within a couple of minutes of
> reproducing it)?

   No, as far as I know, it doesn't transfer via send/receive.
send/receive is largely equivalent to copying the data by other means
-- receive is implemented almost exclusively in userspace, with only a
couple of ioctls for mucking around with the UUIDs at the end.

> 3. Do we have any kind of statistics beyond the rate of reports (for
> example, does it happen more often on bigger filesystems, or
> possibly more frequently with certain chunk profiles)?

   Not that I've noticed, no. We've had it on small and large,
single-device and many devices, HDD and SSD, converted and not
converted. At one point, a couple of years ago, I did think it was
down to converted filesystems, because we had a run of them, but that
seems not to be the case.

   Hugo.

-- 
Hugo Mills             | The glass is neither half-full nor half-empty; it is
hugo@... carfax.org.uk | twice as large as it needs to be.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                      Dr Jon Whitehead

--reI/iBAAp9kzkmX4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWRkAoAAoJEFheFHXiqx3kbbQP/j6SYbb1MT0tAwyvbMDqeETi
SXs1EbCzB53RAca1lAAGE1QViLrpHmg2i1tgiPxRZI0juAUkt/PdTjjnWomRIQ7r
2UBmrUmV+2xthOZgIZIqv0AoYl9kjgLVD3avQvHmB6IMnLv8QbKcgLQ6AhnfBImU
Kl6ProkfO6VJ4E9g3r8ugXbo/hWacn/MYamyRURS+lYI21/5Ke/yTrvwpgZA1Gau
2gLAcciDTm0X8eDlYYTs9grZQx/0S8i1jmc4mgyYMWLdcStLOOBxlX7kr9rcEOI+
WZ2zw4bgPNxty6tNathSQ5rxm1+NBn3+CSSl56p5Mo/Rp6erV4EOPMdJNyl99sIw
Na+r0rTcOarEjYGYKvq3r23lmX3QGq/5KPxsRtOM24bUh6CcxzvoeLny/Sny3072
vqkCYyYiz4Ct53SVV7c700ZXL30aXFA4ky3vYs8CvJHlwXcH68Jn3m0/sdYKeY8w
4wO6//brauxqJRuFRSQKLjVaspnOF1vusM8/HcOxBWpvVmGczQ5etKKg9xykNirG
K/9sC4tsevBlCFbFCZd0avodRZAli7LH++cAiesbgpAV+gbZNEo3BHoAJBYe7cbP
yNYOlj/lckbUg+kpD3UBxeEfK5hVxmq2kdCji8H2/2Y+alLYTvAoxhzLgxWSGRi1
GXhVnQEE1jwHLCBxQGWM
=ud+A
-----END PGP SIGNATURE-----

--reI/iBAAp9kzkmX4--
