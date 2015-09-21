Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39983 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159AbbIUPFv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Sep 2015 11:05:51 -0400
Date: Mon, 21 Sep 2015 15:05:49 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org,
        Incorporeal Waffle <0isavalidnumber@gmail.com>
Subject: Re: Btrfs partition gets remounted as read only
Message-ID: <20150921150549.GD5918@carfax.org.uk>
References: <CAOTVeoEVxAMHJ8Rw-YfAUmuvNUs3pAcEGgA7bXgOC1fToW9HYQ@mail.gmail.com>
 <pan$28fb6$e21baff8$67f806d3$ecee1b58@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BRE3mIcgqKzpedwo"
In-Reply-To: <pan$28fb6$e21baff8$67f806d3$ecee1b58@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--BRE3mIcgqKzpedwo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

(Adding OP back to cc list -- I know from IRC they're not subscribed
to the list)

On Mon, Sep 21, 2015 at 03:02:23PM +0000, Duncan wrote:
> Incorporeal Waffle posted on Mon, 21 Sep 2015 14:30:21 +0000 as excerpted:
> 
> > I tried converting my root partition (originally ext4) to btrfs.
> 
> There's some known bugs with btrfs-convert currently, with current or 
> very recent discussion on-list about how to fix it, if you check the 
> archives.
> 
> In the more general case, while the present bugs will no doubt be fixed, 
> I (a user, not a dev) don't recommend using convert, as in the best case, 
> it's a compromise, with better results if you treat the existing ext* as 
> a backup and start with a brand new btrfs using mkfs.btrfs.
> 
> The admin's rule of backups states that if you care about the data, it's 
> backed up, and if it's not backed up, in practice, you're defining the 
> data as not worth the time and resources to back up, any claims to the 
> contrary not withstanding.  (Meanwhile, a would-be backup that hasn't 
> been tested restorable isn't considered a backup, because the backup 
> isn't defined as complete until it is tested.)
> 
> From that perspective, there's little reason to do a filesystem 
> conversion, since if you care about the data, it's backed up and can be 
> restored to a brand new filesystem, with a better layout than a 
> filesystem that started as something else is likely to ever achieve, and 
> if you don't care about the data, then there's no reason not to start out 
> with a clean filesystem in the first place.
> 
> So while having a convert tool is "nice", even when it's working 
> correctly, the best choice is to avoid using it, starting with brand new 
> clean filesystem and copying existing data, if any, into it from backups 
> so it is laid out ideally for the new filesystem, instead of the 
> compromise of trying to work around the location of existing data and 
> metadata, in a layout that should work, granted (and it's definitely a 
> bug that it's not doing so today), but is unlikely to be ideal for a 
> different filesystem than the one it started out as.
> 

-- 
Hugo Mills             | vi vi vi: the Editor of the Beast.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--BRE3mIcgqKzpedwo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWABzNAAoJEFheFHXiqx3kF88P/i9bpRH4yFKnAT5XXOotMPbl
FXrdiaCyuQGT0Mf8O7+fkcS9hVcGXfRSWOGim25tSpWNQpvcLL/orS2CoskYFB7v
HevXzOouDYJJB6kRfXs4VHCmwuDsRsQyc2ewcx8+XU9HMicLYAp8Kx3kvqqLHVEY
krftB1tzmOaYou06sQeV7cckkAgIY85gqTEtdrCdu2XXfSdGXV1JqeA9PkH1eN2l
EINcxaXawkY64B/h+RReIGMc3IUSDuxvIiuijJf6Eud7ZYk1Xa5y4YgWyo/Lx+vb
fg+hwnHCNcafogUQK17z4ENWDSCan3wqhLGXoWYVTODKMUZrKj7Y4YmC2spB9c76
vaHXANQ8h2pHC5R+fhxQOeefFVVj/4cyL46Q/xuc0E2pe8rs7rQexNP0y8hx7sQ5
BBequvwscRq/Ob6WF1COicEXtQAKQu3rm//+ccltZQOSDToI9YjE8dE9yJw5bGIJ
h+Cut5ioBPciKL0TZQJT5Ed6/gdzkozSQ0crLLreZvz0se9uznJoY24etC5aFsYx
Btbh/XsS006BOl9v3vlJuMmrxGmWzsBcrUkyQSRTN4foV52bda9kxcuqC+aS2b49
02O2fqeHu9bvzpDWC+dcrnQHr5dJifV1EwOFDLQscYXDxFzO+sGZdGZkN6EBhrb4
Sl/4CwsssWJk4/F4wZOC
=FOvO
-----END PGP SIGNATURE-----

--BRE3mIcgqKzpedwo--
