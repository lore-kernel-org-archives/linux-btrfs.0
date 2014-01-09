Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41390 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbaAIRJt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 12:09:49 -0500
Date: Thu, 9 Jan 2014 17:09:45 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: George Eleftheriou <eleftg@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: How does btrfs handle bad blocks in raid1?
Message-ID: <20140109170945.GK15634@carfax.org.uk>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>
 <20140109104247.GH15634@carfax.org.uk>
 <pan$ab233$2067aff9$a13049e6$e769dc55@cox.net>
 <52CE9B9C.2040006@gmail.com>
 <pan$5a8b0$23680cbf$a1bd97e9$1743c66f@cox.net>
 <CAPpBBdNNHB3igMK67j5FpZxg7f6tmxGZk8x1OSwKd8GhTqsj=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0qVF/w3MHQqLSynd"
In-Reply-To: <CAPpBBdNNHB3igMK67j5FpZxg7f6tmxGZk8x1OSwKd8GhTqsj=w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0qVF/w3MHQqLSynd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 09, 2014 at 05:49:48PM +0100, George Eleftheriou wrote:
> Duncan,
> 
> As a silent reader of this list (for almost a year)...
> As an anonymous supporter of the BAARF (Battle Against Any RAID
> Four/Five/Six/ Z etc...) initiative...
> 
> I can only break my silence and applaud your frequent interventions
> referring to N-Way mirroring (searching the list for the string
> "n-way" brings up almost exclusively your posts, at least in recent
> times).
> 
> Because that's what I' m also eager to see implemented in BTRFS and
> somehow felt disappointed that it wasn't given priority over the
> parity solutions...
> 
> I currently use ZFS on Linux in a 4-disk RAID10 (performing pretty
> good by the way) being stuck with the 3.11 kernel because of DKMS
> issues and not being able to share by SMB or NFS because of some bugs.
> 
> I'm really looking forward to the day that typing:
> 
> mkfs.btrfs -d raid10 -m raid10  /dev/sd[abcd]
> 
> will do exactly what is expected to do. A true RAID10 resilient in 2
> disks' failure. Simple and beautiful.

   RAID-10 isn't guaranteed to be robust against two devices failing.
Not just the btrfs implementation -- any RAID-10 will die if the wrong
two devices fail. In the simplest case:

A }
B } Mirrored    }
                }
C }             }
D } Mirrored    } Striped
                }
E }             }
F } Mirrored    }

   If A and B both die, then you're stuffed. (For the four-disk case,
just remove E and F from the diagram).

   If you want to talk odds, then that's OK, I'll admit that btrfs
doesn't necessarily do as well there(*) as the scheme above. But
claiming that RAID-10 (with 2-way mirroring) is guaranteed to survive
an arbitrary 2-device failure is incorrect.

   Hugo.

(*) Actually, I suspect that with even numbers of equal-sized disks,
it'll do just as well, but I'm not willing to guarantee that behaviour
without hacking up the allocator a bit to add the capability.

> We're almost there...
> 
> Best regards to all BTRFS developers/contributors

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- But people have always eaten people,  / what else is there to ---  
         eat?  / If the Juju had meant us not to eat people / he         
                     wouldn't have made us of meat.                      

--0qVF/w3MHQqLSynd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUs7X2VheFHXiqx3kAQKTBA/+OsDz1KbmXBRwFnWexKw2LOwxX+klocwV
NZ6lov84gmrVcDqvJAbf9x8l+jNxTFq51cpDHrkOgdEnPMcIfJi9Te7aR8e7AOOX
NZyo7D2AngE4nkwy+wNqj/Bu6WcFtUEZEAkw3PxSgFUyTzu4M8x+pr3DsTw7O5gw
BCsVGECSdeZgLMsVvYS4gtLqblTkq/DkYt5uwtJo6bM657pjuJo1cWFyq+pW2VgV
49av7ETnQqVupz4BaKct26YifpTd0axmg5J9RE0A/g5lQ8BEnmbJk2z8vR8HH1ns
QsvnkxShBBABC5v1ptBX2LX7bVgtrRk6m25tfbIk9xb/krP8p6UxSb3MiGwTKmuw
5MnJishJGH+i94BwJYQmpS9DtMLAmAHeHC7l+m1pMwASMFJ4CfJDRQU6jE0/dFrv
zAScH3sZzKAuFwwTVEWuucQzZRJmbd7u3XINT9Ua/5pJW91j2yUdsovNXugzK68C
52Hc2Im6vyhNCtbwuea06jbOc8aWT/S+CqPLi4nvmQ+I/vZICEFVvlrhb+4sMuQl
TduyQGEo8OkYOF6Sh0LUaa87wLwi8Kn5oQifa8ODW7BhQJPQ+OgOnskDTTIsVh5C
mnVi7V0Eg0909CPrwPxVt3ILupC5bSJtAs+LlYQP4skC672ZXBHKNCE7mPOZO7ow
KfhSeP6TvkQ=
=+QQy
-----END PGP SIGNATURE-----

--0qVF/w3MHQqLSynd--
