From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs: open_ctree failed
Date: Mon, 26 Mar 2012 23:47:30 +0100
Message-ID: <20120326224729.GB2597@carfax.org.uk>
References: <CANDob0+rwkLGeJg4kP+TpPpN8VOdrOV684F5YiLC6+BkzYehHA@mail.gmail.com>
 <CANDob0+cBXnNH1dZ5socF7vaNoAB8wHACA4cN-w_1Z4T=VKUbA@mail.gmail.com>
 <20120326215740.GA2597@carfax.org.uk>
 <CANDob0JDQKObq8L2s8E7D9x_=k=MgsaMu=g0DBaZqGqCO_O70Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Cc: linux-btrfs@vger.kernel.org
To: Not Zippy <notzippy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANDob0JDQKObq8L2s8E7D9x_=k=MgsaMu=g0DBaZqGqCO_O70Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2012 at 03:36:13PM -0700, Not Zippy wrote:
> Hugo
> I did try the dangerdonteveruse branch and thats the error btrfsck
> --repair gave me.

   Oooh, a brave one, I see. ;)

> Looks like the btrfs-restore command may work (thanks!). And yes I
> do have backups for the important data - I had some other data on
> there which would need to be d/l again..

   Excellent. We don't need to set the hounds onto you, then.

> I don't dabble that much with the kernel - this is a straight ubuntu
> which I regularly do their updates - Can I advance the kernel beyond ?

   Yes, there's a PPA[1] for it (documented in the "Getting Started"
page on the btrfs wiki at [2]).

[1] http://kernel.ubuntu.com/~kernel-ppa/mainline/
[2] http://btrfs.ipv5.de/index.php?title=Getting_started#Ubuntu_Linux

> If your recommending this I will definitely look into it (since I dont
> want a repeat of this to occur) Does this article describe the update
> well enough ? http://www.upubuntu.com/2012/03/how-to-install-linux-33-kernel-in.html

   I'm not 100% sure -- I don't run Ubuntu on very many machines. You
will probably need to add the PPA to your /etc/apt/sources.list file.
I'm not sure exactly which URL you need, though. I'd guess that
Googling for "Ubuntu Kernel PPA" will get you the relevant
instructions. (Or just download the .deb manually from the URL above
and intall with dpkg -i).

   I'd definitely recommend running as recent a kernel as you can --
either the last released (3.3 in this case), or the latest -rc (still
also 3.3 right now, but going up to 3.4-rc1 in a few days' time). Both
should be available in the kernel PPA.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- There is no dark side to the Moon, really. As a matter of ---    
                          fact,  it's all dark.                          

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPcPIBIKyzvlFcI40RAlmmAJ9pLVnIFGTL59krKmTVbSaQRpYOxACfd+mr
EvfL6XnOzdEKOliO1z7VXiE=
=CltA
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
