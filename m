Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49950 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbdHASPu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 14:15:50 -0400
Date: Tue, 1 Aug 2017 18:15:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
Message-ID: <20170801181547.GZ7140@carfax.org.uk>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <20170801172857.GY7140@carfax.org.uk>
 <20170801165639.GB26357@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+hGRuEBnBrDfOHI9"
In-Reply-To: <20170801165639.GB26357@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+hGRuEBnBrDfOHI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 01, 2017 at 10:56:39AM -0600, Liu Bo wrote:
> On Tue, Aug 01, 2017 at 05:28:57PM +0000, Hugo Mills wrote:
> >    Hi,
> > 
> >    Great to see something addressing the write hole at last.
> > 
> > On Tue, Aug 01, 2017 at 10:14:23AM -0600, Liu Bo wrote:
> > > This aims to fix write hole issue on btrfs raid5/6 setup by adding a
> > > separate disk as a journal (aka raid5/6 log), so that after unclean
> > > shutdown we can make sure data and parity are consistent on the raid
> > > array by replaying the journal.
> > 
> >    What's the behaviour of the FS if the log device dies during use?
> >
> 
> Error handling on IOs is still under construction (belongs to known
> limitations).
> 
> If the log device dies suddenly, I think we could skip the writeback
> to backend raid arrays and follow the rule in btrfs, filp FS to
> readonly as it may expose data loss.  What do you think?

   I think the key thing for me is that the overall behaviour of the
redundancy in the FS is not compromised by the logging solution. That
is, the same guarantees still hold: For RAID-5, you can lose up to one
device of the FS (*including* any log devices), and the FS will
continue to operate normally, but degraded. For RAID-6, you can lose
up to two devices without losing any capabilities of the FS. Dropping
to read-only if the (single) log device fails would break those
guarantees.

   I quite like the idea of embedding the log chunks into the
allocated structure of the FS -- although as pointed out, this is
probably going to need a new chunk type, and (to retain the guarantees
of the RAID-6 behaviour above) the ability to do 3-way RAID-1 on those
chunks. You'd also have to be able to balance the log structures while
in flight. It sounds like a lot more work for you, though.

   Hmm... if 3-way RAID-1 (3c) is available, then you could also have
RAID-1*3 on metadata, RAID-6 on data, and have 2-device redundancy
throughout. That's also a very attractive configuration in many
respects. (Analagous to RAID-1 metadata and RAID-5 data).

   Hugo.

-- 
Hugo Mills             | That's not rain, that's a lake with slots in it.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--+hGRuEBnBrDfOHI9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZgMVTAAoJEFheFHXiqx3kogkQAKmFHf6n3tBWChxP5q6YbUTL
3RgSSLStTUvR9uhvixUYWcX656sGc5VMndeFv0rrmifGHdIIJ9h7DJBGWj2/Qi2s
puAkX8KKK3aVT66DJohqllacbvMWBuNL4qF/n7YvlMd7a3m/XXxlYi7l1Dx2RecH
mQPhgZ1WDgKRbhr/aHm/VwqpKh3VZFq3k3szxZs1VDslVlF8mtXRRgsISMAAlW//
U34eTu4RkOvKL4OGi53aYirbm+/r2vlAVtuLUPtY7B4JYqNRuCkD9E62EsiZLNlS
QjJdbGj9Es5zMeGMILxJqQJ+32TkNsRt5qg2/6+qNVz4N+e8zlrHFZe5umsEg53P
I8Kv6JndECY9yB8fGX+spE1KE/398VNSjX3P5A7Tv+OtSKUo/WCHlGkequwa7Hvu
B++CePvpy3enNMsulCbW092Xg4eygQ3F2nrTEKswjwK/THp6+0CdsFQfCK2iHayo
p3qEDn2VTZcrV4C1F+PO0R+4xIgMd6EqjhE5FEDzpXyWYLZA7V8WgUS9LZb/ScfJ
eCoG/w3g69qO/fdrBWV8OYYx1E/KDZcjzPptduU9fPKioTuCxireEtuwRVWq4xRO
fsJszmVZ6L1t/QMudKm8xLLcxJXRc6YnxY8tzgn0iklOKmOVZapYKOUY833am0AM
7xiVLjM1aIR9wVgkl5KR
=2HZN
-----END PGP SIGNATURE-----

--+hGRuEBnBrDfOHI9--
