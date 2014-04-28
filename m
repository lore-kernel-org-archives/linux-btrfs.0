Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37554 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaD1IHy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Apr 2014 04:07:54 -0400
Date: Mon, 28 Apr 2014 09:07:50 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "kernel BUG at /home/apw/COD/linux/fs/btrfs/extent_io.c:2116!"
 when deleting device or balancing filesystem.
Message-ID: <20140428080750.GA10151@carfax.org.uk>
References: <C25AA8A9-30B0-4D00-80B5-B681D93D67A3@pieroen.nl>
 <pan$2abc$efe882ea$fdd493d$5779ebd8@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
In-Reply-To: <pan$2abc$efe882ea$fdd493d$5779ebd8@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 28, 2014 at 03:26:45AM +0000, Duncan wrote:
> Jaap Pieroen posted on Sun, 27 Apr 2014 18:30:19 +0200 as excerpted:
> 
> > Hello,
> > 
> > When I try to delete a device from my btrfs filesystem I always get the
> > following kernel bug error:
> 
> > kernel BUG at /home/apw/COD/linux/fs/btrfs/extent_io.c:2116!
> > invalid opcode: 0000 [#3] SMP
> > See attached log file for more details.
> 
> That's a reasonably common, generic error, simply indicating the kernel 
> got an invalid/zero opcode instead of what it was supposed to get, but 
> not really saying why, tho the log does give some more info.

   More than that -- the invalid opcode is simply the way that the
BUG() and BUG_ON() macros are implemented.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- People are too unreliable to be replaced by machines. ---      

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU14MVlheFHXiqx3kAQJZ8w//Xhtu9/OpoyQ1O0IgCrRryc6zUCs7fwo3
G8S71XBdDmWCd8hDuY4gsVxRHA/t0H5gseTcnZ91G0thHxcmNo7hLG4YOxjEhkFT
Ekfwhx3wt3XRp0/BairQx2OqvprtDiJHDm/lMWA9kk1vkFIrP28CIt/62J+jp4C1
c20yd7sWZMUxqOZWqC8qJP1h7Jgm9/0FF1VHeyqf2kUY6uPzGi75AXdlMBaYj1qL
zT7NRF5dp8IM/qB+mJDaKOhdLV4pga19t7efHD8l+WwKNOQBrfJdm2znWcXQXZj7
2gH/3Sv4HOdRu+XBACHmGj8eK+P7pQdhYtJICZGd8/MXeUWdgdFlh1TqBkO4WuCp
pkkNKKFHYH1CjxnUCo3gFjH2PkSbEdnabceTq2Vs/Leytt8QHH2ZbeeQXPLxiwyd
kf6ISrHXAaFnAHZ7yHdkzPuH9igo81KQ+rFv2qFsfWElNu7lskNvcUlLUyyi4i/X
syYHtw/teJY9qMycv8r+3gm1+IFWCSDUmR/hmlBFc26p703ySj5GjQMmvaddY+kP
q3iU7eNhZ3KUFKEm08+hJmxwuNJSLeCJYSaGK0mrhpksl6e4v1eelX3S/Uus9oTP
hfVYt2V8XzuRVskPlKw1x54fRUhNj3kBJ2JDTX9ul3szfJiFMFPL0v2EwB0p8ki1
nCkTElpZpSg=
=fFSm
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
