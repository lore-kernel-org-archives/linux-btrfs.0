Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40852 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2J3WTu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 18:19:50 -0400
Date: Tue, 30 Oct 2012 22:19:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: ching <lsching17@gmail.com>, cwillu <cwillu@cwillu.com>,
        Felix Pepinghege <postfach@pepinghege.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Why btrfs inline small file by default?
Message-ID: <20121030221947.GC11422@carfax.org.uk>
References: <508FB45B.9040101@gmail.com>
 <508FC26A.1010206@pepinghege.net>
 <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com>
 <50904949.8010603@gmail.com>
 <20121030221412.GB11422@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mvpLiMfbWzRoNl4x"
In-Reply-To: <20121030221412.GB11422@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mvpLiMfbWzRoNl4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 30, 2012 at 10:14:12PM +0000, Hugo Mills wrote:
> On Wed, Oct 31, 2012 at 05:40:25AM +0800, ching wrote:
> > On 10/30/2012 08:17 PM, cwillu wrote:
> > >>> If there is a lot of small files, then the size of metadata will be
> > >>> undesirable due to deduplication
> > >>
> > >> Yes, that is a fact, but if that really matters depends on the use-case
> > >> (e.g., the small files to large files ratio, ...). But as btrfs is designed
> > >> explicitly as a general purpose file system, you usually want the good
> > >> performance instead of the better disk-usage (especially as disk space isn't
> > >> expensive anymore).
> > > As I understand it, in basically all cases the total storage used by
> > > inlining will be _smaller_, as the allocation doesn't need to be
> > > aligned to the sector size.
> > >
> > 
> > if i have 10G small files in total, then it will consume 20G by default.
> 
>    If those small files are each 128 bytes in size, then you have
> approximately 80 million of them, and they'd take up 80 million pages,
> or 320 GiB of total disk space.

   Sorry, to make that clear -- I meant if they were stored in Data.
If they're inlined in metadata, then they'll take approximately 20 GiB
as you claim, which is a lot less than the 320 GiB they'd be if
they're not.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- I always felt that as a C programmer, I ---             
                         was becoming typecast.                          

--mvpLiMfbWzRoNl4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUJBSg79z9OVl50rAAQLiTBAAgVBt6wDIHwQMgRkWUyGLLW2q+wJmBhx3
Ah08QagzLOYghcEiflJy8tSPi8fwg+fSp42jBnFKDXJbpZBoHPL70/F4dVeWHvcE
EbMQVnCjCkBlQZR/BVWqGjv65OiAIWgTlUjGxYXCOVYAO57fTmCc1yb/EnIl7wmy
/ISeYR37QZzczrXDWSQNXGxifIV5FrrUBky1w0cETBLdkX4vyZmt0A/Lr1UFIpy0
iXKextxujliulUIoSgz6uDTQOxBU1SS67qy+cVd0zQqjj17kIYGpar+zJ0PFK5ug
zNveDky/vQEHA/V7ei1hKBftGSwJdKk6CJK6qLjxpCCmVkIWOXIUfeS2Z/vqCV1E
KVtgwlAzfyVX12lEBlcLNm7pc9B73IfQvutIX76/3QlGDDog9OJzot87RFIgqRBm
q5dtR2KDLsTiUUMU0WFK8VgcdZaYzTOhXs2oI0ZfsYZdrhHTTL2S0p1KmByvogk3
tkeRAljCB6l5zlsftwy+kJXlPxhLxe6e2eKi+NtdygKm9Ur5v2El71awOqF6yw3t
rri4oEBVhbYFBFx36GYiZyW1ASKGZry8G8RKOJXLyvPfqoJWjT8ETUczpMz7H3mt
mo/XSUqOLcdCsGuXsPcScgdfPmcG4dtYQUA1PwirPoFDjqYji1YsldC9PVs/ByIe
RzdWAsDPWBg=
=7V5M
-----END PGP SIGNATURE-----

--mvpLiMfbWzRoNl4x--
