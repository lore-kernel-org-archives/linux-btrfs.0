Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44890 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933501AbeFRMTy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 08:19:54 -0400
Date: Mon, 18 Jun 2018 11:44:08 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: About more loose parameter sequence requirement
Message-ID: <20180618114408.GB28972@carfax.org.uk>
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
In-Reply-To: <20180618113432.GJ24375@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2018 at 01:34:32PM +0200, David Sterba wrote:
> On Thu, Jun 14, 2018 at 03:17:45PM +0800, Qu Wenruo wrote:
> > I understand that btrfs-progs introduced restrict parameter/option order
> > to distinguish global and sub-command parameter/option.
> > 
> > However it's really annoying if one just want to append some new options
> > to previous command:
> > 
> > E.g.
> > # btrfs check /dev/data/btrfs
> > # !! --check-data-csum
> > 
> > The last command will fail as current btrfs-progs doesn't allow any
> > option after parameter.
> > 
> > 
> > Despite the requirement to distinguish global and subcommand
> > option/parameter, is there any other requirement for such restrict
> > option-first-parameter-last policy?
> 
> I'd say that it's a common and recommended pattern. Getopt is able to
> reorder the parameters so mixed options and non-options are accepted,
> unless POSIXLY_CORRECT (see man getopt(3)) is not set. With the more
> strict requirement, 'btrfs' option parser works the same regardless of
> that.

   I got bitten by this the other day. I put an option flag at the end
of the line, after the mountpoint, and it refused to work.

   I would definitely prefer it if it parsed options in any
position. (Or at least, any position after the group/command
parameters).

   Hugo.

> > If I could implement a enhanced getopt to allow more loose order inside
> > subcomand while still can distinguish global option, will it be accepted
> > (if it's quality is acceptable) ?
> 
> I think it's not worth updating the parser just to support an IMHO
> narrow usecase.

-- 
Hugo Mills             | Turning, pages turning in the widening bath,
hugo@... carfax.org.uk | The spine cannot bear the humidity.
http://carfax.org.uk/  | Books fall apart; the binding cannot hold.
PGP: E2AB1DE4          | Page 129 is loosed upon the world.               Zarf

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJbJ5sIAAoJEFheFHXiqx3k5LQP/jBpNHEkzBpr5x/fIxaD6V5Z
uh26Bch4LYedJAWkXKmEw6+ZKThl0+5vlNA7VlIzN3Yw6gJ5kcbZabbeNVEHP4dS
w1PLMWZ+pKzVZRzXgMvzHsxspQaU6WDYBujJG9BMUWSJ5L8BzZB2VuWtpzYay/fG
PLypnSUU3U6ROLtwJt9Eg62WI+BEG/V+I6Gf3F986prwjVMHoGpYQNZP888ovfjn
XvAnxTOZn6NLJpw9OXg7mMgKABBxVGWT1rJKTLi3/CzrVXODd8XidfmcZLZbvh8C
L5ShwbdKqvq3bkACT5lJHoYJKugO5l3mdDrbTJggNZQ07o/7KWzq4GaJgW8aKFOF
DbXDbdyBlTlPUuDFd6nl2XBGemWHW6MRzsifxlqjEG3Q/CxWl5LpGuz0uqyHiQMo
SeH70LGjf/l/dtZgSIUY8MsBxpmvY8KjNshnZsC6n6LpgHSjmK5jTlVNZ/BhEjyc
F5+JCrRRUwCIELCROk34DlmeeQe+3800Xvo6RWxtXF4akgJ6LgCC846nVGGJJntT
OZL8jW8nTJt550GLyIWbH7n3ngLq/zoc50WXGzixRro022hA4Sv5zrI4yq8/VDJj
SQ5LTY/NIcpSytNhr41yzSlqhl2hrun2qIN6x4EGPjFg7MH/LXxi65sJKTn8Riqp
wuHiSSjDMH8+8TNQShYe
=jKap
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
