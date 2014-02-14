Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52719 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaBNSeY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 13:34:24 -0500
Date: Fri, 14 Feb 2014 18:34:00 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: kreijack@inwind.it
Cc: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/8] Add command btrfs filesystem disk-usage
Message-ID: <20140214183400.GA3351@carfax.org.uk>
References: <1392318441-9224-1-git-send-email-kreijack@libero.it>
 <52FD1AD6.50500@libero.it>
 <20140214012810.26297146@natsu>
 <52FD21B4.4050502@libero.it>
 <20140214030045.415e21da@natsu>
 <52FE58EF.1060901@libero.it>
 <20140215001110.76d8226f@natsu>
 <52FE602D.7060109@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
In-Reply-To: <52FE602D.7060109@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 07:27:57PM +0100, Goffredo Baroncelli wrote:
> On 02/14/2014 07:11 PM, Roman Mamedov wrote:
> > On Fri, 14 Feb 2014 18:57:03 +0100
> > Goffredo Baroncelli <kreijack@libero.it> wrote:
> > 
> >> On 02/13/2014 10:00 PM, Roman Mamedov wrote:
> >>> On Thu, 13 Feb 2014 20:49:08 +0100
> >>> Goffredo Baroncelli <kreijack@libero.it> wrote:
> >>>
> >>>> Thanks for the comments, however I don't like du not usage; but you are right 
> >>>> when you don't like "disk-usage". What about "btrfs filesystem chunk-usage" ?
> >>>
> >>> Personally I don't see the point of being super-pedantic here, i.e. "look this
> >>> is not just filesystem usage, this is filesystem CHUNK usage"... Consistency
> >>> of having a matching "dev usage" and "fi usage" would have been nicer.
> >>
> >>
> >> What about "btrfs filesystem chunk-usage" ? 
> > 
> > Uhm? Had to reread this several times, but it looks like you're repeating
> > exactly the same question that I was already answering in the quoted part.
> > 
> > To clarify even more, personally I'd like if there would have been "btrfs dev
> > usage" and "btrfs fi usage". Do not see the need to specifically make the 2nd
> > one "chunk-usage" instead of simply "usage".
> 
> I don't like "usage" because it to me seems to be too much generic.
> Because both "btrfs filesystem disk-usage" and "btrfs device disk-usage"
> report about chunk (and/or block group) infos, I am investigating 
> about 
> - btrfs filesystem chunk-usage
> - btrfs device chunk-usage

   Most people aren't going to know (or care) what a chunk is. I'm
much happier with Roman's suggestion of btrfs {fi,dev} usage.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- Nostalgia isn't what it used to be. ---               

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUv5hmFheFHXiqx3kAQKdjg/7Brl4xD0fZTvlVy/ycwmts7eEfrEC4E/T
ELUUe0xmpOCkr/7FL+mvdQeW/PqTUiupJ0yP46BKr5Z2q+kaUzqNgxKvLxgh5Slh
T6vZk0KPzC4FZ9Gm5MDkeBGCIZtlCOdiWjQdeLdfrezirMlRqy1Zchmfe1V99+k1
0kQe6jDxBb+YIZiuiudQPyyO4yHBrruEQ0ls+ZOUZ3XyTv9n1Y9vTFelUfhKg0uI
AjQkRzZg49ILukDwTeQNNwdN1Q8GXiczw4sescXQh6L5xOaWnlMfZSfzNQd/T1sW
nkyMIs7Klnis53qJp7QhlXsSi7PFM0r3Ik+BTUvfLTeX96nZeGHmNzvnM5EHqOMO
g/0FIdWgK81syvwSQSXBihhEdW8fYWDXtFWo1uaw8RwmwvjXoqeVkCbjAJiEB77L
1kI661yC+JC5IgEzUB1vVzOKgt/oWNusjoMVU21Mz5OGamIE4bquIaLchFn41QFW
IUW17a4h888DwEIFhovfVhX0ODff+NBfZUZpXrJ8hitgmbPiDHoXwjhdetu+rg4t
ObiKbETNG4py9/EbVPCC4biClfwYYOiTwcj8JyEkgT6WjO9qgiNFRDhxsINqM8Q6
9lsLorMdp6gMb5oAmZ7WDajKpobucv1Jg9oPYUjt0iG8OE+T/H3mw9lEjDVxnCtB
yX38E8T0Xts=
=pr8o
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
