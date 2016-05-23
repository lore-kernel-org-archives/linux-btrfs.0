Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58667 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbcEWTTw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 May 2016 15:19:52 -0400
Date: Mon, 23 May 2016 19:19:45 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Zoiled <zoiled@online.no>
Cc: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs filesystem usage - Wrong Unallocated indications - RAID10
Message-ID: <20160523191945.GE16712@carfax.org.uk>
References: <574306CC.3070906@prismatelecomtesting.com>
 <574350A0.80101@online.no>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jKBxcB1XkHIR0Eqt"
In-Reply-To: <574350A0.80101@online.no>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jKBxcB1XkHIR0Eqt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 23, 2016 at 08:49:04PM +0200, Zoiled wrote:
[snip]
> For what it's worth...  I have a 8 disk (7x 300GB + 1x 500GB) data
> raid10, metadata raid1 setup and I get the following output of
> btrfs...
> 
> Label: 'xxyyzz'  uuid: 12345678-9abc-def1-2345-6789abcdef01
>         Total devices 8 FS bytes used 1.05TiB
>         devid    1 size 268.05GiB used 265.94GiB path /dev/sda1
>         devid    2 size 279.40GiB used 277.22GiB path /dev/sdb
>         devid    3 size 279.40GiB used 277.32GiB path /dev/sdc
>         devid    4 size 279.40GiB used 278.73GiB path /dev/sdd
>         devid    5 size 279.40GiB used 277.72GiB path /dev/sde
>         devid    6 size 279.40GiB used 278.61GiB path /dev/sdf
>         devid    7 size 279.40GiB used 278.82GiB path /dev/sdg
>         devid    8 size 465.76GiB used 230.99GiB path /dev/sdh
> 
> # btrfs filesystem usage -T /
> Overall:
>     Device size:                   2.35TiB
>     Device allocated:              2.11TiB
>     Device unallocated:          244.83GiB
>     Device missing:                  0.00B
>     Used:                          2.11TiB
>     Free (estimated):            122.57GiB      (min: 122.57GiB)
>     Data ratio:                       2.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
>              Data       Data      Metadata System
> Id Path      RAID1      RAID10    RAID1    RAID1 Unallocated
> -- --------- ---------- --------- -------- --------- -----------
>  1 /dev/sda1          - 132.97GiB        -         - 135.08GiB
>  2 /dev/sdb           - 138.61GiB        -         - 140.79GiB
>  3 /dev/sdc           - 138.66GiB        -         - 140.74GiB
>  4 /dev/sdd           - 138.87GiB  1.00GiB         - 139.53GiB
>  5 /dev/sde     1.00GiB 137.86GiB  1.00GiB         - 139.53GiB
>  6 /dev/sdf           - 138.81GiB  1.00GiB         - 139.59GiB
>  7 /dev/sdg     1.00GiB 138.38GiB  1.00GiB  64.00MiB 138.96GiB
>  8 /dev/sdh           - 113.46GiB  4.00GiB  64.00MiB 348.24GiB
> -- --------- ---------- --------- -------- --------- -----------
>    Total        1.00GiB   1.05TiB  4.00GiB  64.00MiB 1.29TiB
> Used      1007.30MiB   1.05TiB  1.66GiB 400.00KiB
> 
> What I don't get is... how can I have 244.8 GB unallocated when the
> table below clearly shows that there is as much as 1.29TiB
> unallocated.... does not appear to make sense to me at least...

   This is exactly the issue. The Unallocated value(s) from btrfs fi
usage on at least RAID-10 are simply wrong, any way you look at it.

   Hugo.

-- 
Hugo Mills             | Great films about cricket: The Third Man
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--jKBxcB1XkHIR0Eqt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXQ1fRAAoJEFheFHXiqx3kYgIP/Rru4SDATkMIUIIB9vHHE2g0
hW/R5v5zS7N17IVIdFhGRBIUEVuwY2494mZKwszxfhcHmeI0/i4OdmgEZh1AGuWu
Gf0rmdnHtrQcr2Jh/cYBR9kppEo/vNr86wkY4vxRJrUFhh0xQDE1p14wCfitbrTG
D+GiYRZLI/5Fs5ZYmRqJwuMtKBxxhyV4AARuLNmTNiWjqs3XPX3dSfc/tJuHbZuX
qEex/4U03kEGw8Vw19XBZWdl1/TiBogcRamMJMeYC2cSqG+TIszid/V/oLa12col
8luA928y+K6kfQyRHk1qSmzdHgSsPSlFgGhB1C6lUnpzcyiD9KCvS571IeEx1rOE
W0fzxe2yfx+YIkHHeUmIRuoiJxESa8E8dtBhEIiSBuwV+MWD0aDlv84M/j0sR17E
o4/kYuwFQ5RqfX1jlMXEek8qZR67vJlmcFdfdje608fRgCpkFkZRefkjGM644qPV
Gn4Zt1ANg2ekMxAxbG84S10GphLvSzjorSgL2Z+2lz29pClq/++ySr15ivsQfQ7O
eP6UlNLz74YuSf4eenOkhkWhisgHmsHLAZrl3l/Ds+MWGQYyFH1fJAgNCoilwDW1
hjL5cAxhQP2cSr0jB3jhzqwitGPWMB3v++D59zmf7ZydbDGPPQ0nbTgfVmU6BeU8
Yok3jjewIh4wJczo0Kkq
=xwax
-----END PGP SIGNATURE-----

--jKBxcB1XkHIR0Eqt--
