Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34592 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaLBOJu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 09:09:50 -0500
Date: Tue, 2 Dec 2014 14:09:45 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141202140945.GM32735@carfax.org.uk>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu>
 <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org>
 <20141202125252.GR12140@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eL7EO+gwLE2vJ/xx"
In-Reply-To: <20141202125252.GR12140@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--eL7EO+gwLE2vJ/xx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 02, 2014 at 01:52:52PM +0100, David Sterba wrote:
> On Mon, Dec 01, 2014 at 10:14:03PM -0500, Zygo Blaxell wrote:
> > > export BTRFS_SUBVOLUME_DELETE_CONFIRM=1
> > > 
> > > Ideas?
> > 
> > Never rely on aliasing or environment variables for defaults, and never
> > change default behavior if your releases are old enough that someone
> > has built scripts on top of them.  ;)
> 
> Exactly.
> 
> > If I had to pick the least evil, I'd go for interactive prompting by
> > default (do nothing if the interaction fails, e.g. no TTY) and add a
> > '-f'/'--force' flag to bypass the prompt.
> 
> This sounds acceptable.
> 
> > This is consistent with the
> > way lvm2 and mdadm work when presented with data-losing or otherwise
> > questionable commands and parameters.  It will break scripts, but btrfs
> > users should still be expecting that for a while as undesirable default
> > behaviors are identified.
> 
> How is this going to break scripts?

   Any script which relies on being able to delete subvolumes in
unattended operation will now require modification to use -f.

   Hugo.

-- 
Hugo Mills             | Unix: For controlling fungal diseases in crops
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--eL7EO+gwLE2vJ/xx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUfcgpAAoJEFheFHXiqx3k6IsQAIi0O195Ce+iyl7gIcCDd1Vc
Yh1d6i6OfA3IVOvCOuIVEzBHXwcYl1kllQL1/GbXXc0oL2pbyu/qGUC/E0sjNaGM
2/mpUDaualLCAPKwzSTI3X8qelLHozy1M2WUeZ+aiTq3LpB8jt9bFEg8sRdB3xBQ
t5yHPzo5rjfSkiNHGv9dlrWumQwOogUHcCiOGil8lc5k/ofFgQeUF35XQesEqXTz
6pCiX2Q4I0HNK16bNl+sDV0tcklnPrn81JAOcuiCyI6Fs6Me0aeQiMHRZqvkHkBP
m3vrP35Zk2ieFlhUrtg+arEisXtzVGMcQ/eUlwr2l4zKBwGM+tk3ihfrkeqPazy8
8qPUFD07qooQ//Bv+oNznMX/GH+YRryl+pbdshstGs7bQGj8+czvfJNAXpxbpjE6
tokl6jqjFkkm8iwsm0qkHHTmoxGhzKy9rcfjqd2D8CHv6miN0o8Ru6p+6MGwdry+
FaTzjMlxVLsR+T+ue8YCy1mgLl9L64klgyQzA/HXjqNyJ2hcgUwDpSyYsXDR1riF
B+c9D5vsMzgpwjkj5hbg4yf2Tv6lbkabw/ZD7EEXjdxqp+pV6J0TlzKUXiJqe+zN
4s+r1qDD3Fhhc5vkRZwZJg/I5HmFqcyjQLylCnfScfj20qn1xXe4kQDth6Wo3Aig
7N9laHuZFuMLfyZ3q3d8
=zHUR
-----END PGP SIGNATURE-----

--eL7EO+gwLE2vJ/xx--
