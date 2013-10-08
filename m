Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39725 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3JHRCH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 13:02:07 -0400
Date: Tue, 8 Oct 2013 18:01:57 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Shilong Wang <wangshilong1991@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 10/12] Btrfs-progs: add '--block-size' option to
 control print result
Message-ID: <20131008170157.GN28147@carfax.org.uk>
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1381130508-8458-11-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <20131008153439.GE4322@twin.jikos.cz>
 <CAP9B-Qm_PmpNiKk_jmvQvti5djvbtk-hbZgT9NjFqaYWGrpGeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CaPKgh3XHpq3rEUV"
In-Reply-To: <CAP9B-Qm_PmpNiKk_jmvQvti5djvbtk-hbZgT9NjFqaYWGrpGeg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CaPKgh3XHpq3rEUV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 09, 2013 at 12:54:03AM +0800, Shilong Wang wrote:
> Hi David,
> 
> 2013/10/8 David Sterba <dsterba@suse.cz>:
> > On Mon, Oct 07, 2013 at 03:21:46PM +0800, Wang Shilong wrote:
> >> You can use it like:
> >>       btrfs qgroup show --block-size=m <mnt>
> >>
> >> Here, block size supports k/K/m/M/g/G/t/T/p/P/e/E.

k = SI prefix, kilo
K = ? (IEEE prefix kibi?)
m = SI prefix, milli
M = SI prefix, mega
g = SI unit, grams
G = SI prefix, giga
t = ?
T = SI prefix, tera
p = SI prefix, pico
P = SI prefix, peta
e = ?
E = SI prefix, exa

   Some confusion here, I think. :)

> > There is no distinction between the 1000 and 1024 based prefixes, also
> > no way to get the raw values in bytes. I don't have a suggestion how to
> > do that, merely letting you know that this could go separately (this and
> > the "-h" patch, the rest shall be integrated).
> 
> I implement this like the command 'du'.
> 
> In default, we print result in bytes. And block size don't give a byte
> unit implicitly.

> Aslo i don't know why we need to distinct 1000 and 1024, i don't
> have any ideas about this.

   Because when you have a terabyte of data, the difference between
the two is 10%. If you're putting in this kind of infrastructure, it's
not much of an addition to report in either SI decimal or IEEE binary
scales.

> > Also, the numbers in the table should be aligned to the right:
> 
> Yes, this should be fixed.
> 
> Thanks,
> Wang
> >
> > $ btrfs qgroup show -h -p /mnt/
> > qgroupid rfer      excl      parent
> > -------- ----      ----      ------
> > 0/5      900.00KiB 900.00KiB ---
> > 0/267    688.00KiB 12.00KiB  1/5
> > 0/268    684.00KiB 8.00KiB   1/5
> > 0/269    6.71GiB   4.00KiB   1/1
> > 0/277    6.71GiB   4.00KiB   1/1
> > 0/278    39.74GiB  39.74GiB  1/2
> > 1/1      6.71GiB   6.71GiB   ---
> > 1/2      39.74GiB  39.74GiB  ---
> > 1/5      696.00KiB 696.00KiB ---

   Note that the SI mandate a space between the value and the unit.
Note also, for future reference, that SI use k for 10^3, whereas IEEE
use Ki for 2^10.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I'll take your bet, but make it ten thousand francs. I'm only ---  
                       a _poor_ corrupt official.                        

--CaPKgh3XHpq3rEUV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUlQ6hVheFHXiqx3kAQI7tQ//fKISc5QpQd7L+DVawjyWWLJ0bZMu40xf
tnv8R7LEXN9zQE6wQxP21yx1IJEoWJseip7vZu1G9qxzbxF4o0sS04ctobn7Vc6b
w0qcyITEZwcbvhxWj6lZ8hxMjRg67r2gmxlQmuVq342LBoYZgV9mQtoIBpLCTAjQ
u9D8+S20+gerPvDtkZSbm1KbAyu4BCHjAUdABWNyf1gTovGKI67vP0pulEBb+0St
MXu5Yc6xNE1zaxJ5We9c/anebiNsKswukUqvmJneBmt3+FPhUwCVCud+PZLM6pr+
18+p234Y6N7IUuy0SGrfjR8AK7dsLU1egkK6kHslM384xc8UbWAmG/jL50f3IsRN
e3+fj+nGOwRf2GAzii5QGIGzIKNQnOkVlHXsvtsmj3Uvo6I4NTAn23FW2CssOjEs
XCNVe/g+fGWqbLQHEGCKOhNxqdWTUP4hyRtTt/qh6xSAzNo/TOnvAqjQf4ncANI2
So+AeLOw8L8CkX/3ff/y7dabtZFpmOPxzIPsHd/SY6k0mk2ZU8CiqAH4MfuAcFeO
G5R7i6lJzZZabz6GSYO/bKO+4y6NLSaJJUUVblRIkb1MuRzo1jn1gnE7KaXUvYf9
BsHv4M6dbIODZPiWvnaFuWiNI/ipKxsGlTNsQGf/MXQJMVn0p5BPF0eNfevvJqAV
0kcRDpH6F10=
=pEAF
-----END PGP SIGNATURE-----

--CaPKgh3XHpq3rEUV--
