Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53687 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbbIBLaY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Sep 2015 07:30:24 -0400
Date: Wed, 2 Sep 2015 11:30:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christian Rohmann <crohmann@netcologne.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to properly and efficiently balance RAID6 after more drives
 are added?
Message-ID: <20150902113021.GD11358@carfax.org.uk>
References: <55E6CF72.5070005@netcologne.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
In-Reply-To: <55E6CF72.5070005@netcologne.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 02, 2015 at 12:29:06PM +0200, Christian Rohmann wrote:
> Hello btrfs-enthusiasts,
> 
> I have a rather big btrfs RAID6 with currently 12 devices. It used to be
> only 8 drives 4TB each, but I successfully added 4 more drives with 1TB
> each at some point. What I am trying to find out, and that's my main
> reason for posting this, is how to balance the data on the drives now.
> 
> I am wondering what I should read from this "btrfs filesystem show" output:
> 
> --- cut ---
>         Total devices 12 FS bytes used 19.23TiB
>         devid    1 size 3.64TiB used 3.64TiB path /dev/sdc
>         devid    2 size 3.64TiB used 3.64TiB path /dev/sdd
>         devid    3 size 3.64TiB used 3.64TiB path /dev/sde
>         devid    4 size 3.64TiB used 3.64TiB path /dev/sdf
>         devid    5 size 3.64TiB used 3.64TiB path /dev/sdh
>         devid    6 size 3.64TiB used 3.64TiB path /dev/sdi
>         devid    7 size 3.64TiB used 3.64TiB path /dev/sdj
>         devid    8 size 3.64TiB used 3.64TiB path /dev/sdb
>         devid    9 size 931.00GiB used 535.48GiB path /dev/sdg
>         devid   10 size 931.00GiB used 535.48GiB path /dev/sdk
>         devid   11 size 931.00GiB used 535.48GiB path /dev/sdl
>         devid   12 size 931.00GiB used 535.48GiB path /dev/sdm

   You had some data on the first 8 drives with 6 data+2 parity, then
added four more. From that point on, you were adding block groups with
10 data+2 parity. At some point, the first 8 drives became full, and
then new block groups have been added only to the new drives, using 2
data+2 parity.

> btrfs-progs v4.1.2
> --- cut ---
> 
> 
> First of all I wonder why the first 8 disks are shown as "full" as "used
> = size", but there is 5.3TB of free space for the fs shown by "df":
> 
> --- cut ---
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdc         33T   20T  5.3T  79% /somemountpointsomewhere
> --- cut ---

   This is inaccurate because the calculations that correct for the
RAID usage probably aren't all that precise for parity RAID,
particularly when there's variable stripe sizes like you have in your
FS. In fact, they're not even all that good for things like RAID-1
(I've seen inaccuracies on my own RAID-1 system).

> Also "btrfs filesystem df" doesn't give me any clues on the matter:
> 
> --- cut ---
> btrfs filesystem df /srv/mirror/
> Data, single: total=8.00MiB, used=0.00B
> Data, RAID6: total=22.85TiB, used=19.19TiB
> System, single: total=4.00MiB, used=0.00B
> System, RAID6: total=12.00MiB, used=1.34MiB
> Metadata, single: total=8.00MiB, used=0.00B
> Metadata, RAID6: total=42.09GiB, used=38.42GiB
> GlobalReserve, single: total=512.00MiB, used=1.58MiB
> --- cut ---

   This is showing you how the "used" space from the btrfs fi show
output is divided up. It won't tell you anything about the proportion
of the data that's 6+2, the amount that's 10+2, and the amount that's
2+2 (or any other values).

> What I am very certain about is that the "load" of I/O requests is not
> equal yet, as iostat clearly shows:
> 
> --- cut ---
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdc              21.40     4.41   42.22   12.71  3626.12   940.79
> 166.29     3.82   69.38   42.83  157.60   5.98  32.82
> sdb              22.35     4.45   41.29   12.71  3624.20   941.27
> 169.09     4.22   77.88   46.75  178.97   6.10  32.96
> sdd              22.03     4.44   41.60   12.73  3623.76   943.22
> 168.13     3.79   69.45   42.53  157.48   6.05  32.85
> sde              21.21     4.43   42.30   12.74  3621.39   943.36
> 165.88     3.82   69.28   42.99  156.62   5.98  32.90
> sdf              22.19     4.42   41.42   12.75  3623.65   940.63
> 168.51     3.77   69.36   42.64  156.13   6.05  32.79
> sdh              21.35     4.46   42.25   12.68  3623.12   940.28
> 166.14     3.95   71.72   43.61  165.40   6.02  33.06
> sdi              21.92     4.38   41.67   12.79  3622.03   942.91
> 167.63     3.49   63.83   40.23  140.74   6.02  32.77
> sdj              21.31     4.41   42.26   12.72  3625.32   941.50
> 166.12     3.99   72.25   44.50  164.44   6.00  33.01
> sdg               8.90     4.97   12.53   21.16  1284.47  1630.08
> 173.02     0.83   24.61   27.31   23.02   1.77   5.95
> sdk               9.14     4.94   12.30   21.19  1284.61  1630.02
> 174.07     0.79   23.41   26.59   21.57   1.76   5.91
> sdl               8.88     4.95   12.58   21.19  1284.46  1630.06
> 172.62     0.80   23.80   25.68   22.68   1.78   6.00
> sdm               9.07     4.85   12.35   21.29  1284.43  1630.01
> 173.26     0.79   23.57   26.57   21.83   1.77   5.94
> 
> --- cut ---
> 
> 
> 
> Should I run btrfs balance on the filesystem? If so, what FILTERS would
> I then use in order for the data and therefore requests to be better
> distributed?

   Yes, you should run a balance. You probably need to free up some
space on the first 8 drives first, to give the allocator a chance to
use all 12 devices in a single stripe. This can also be done with a
balance. Sadly, with the striped RAID levels (0, 10, 5, 6), it's
generally harder to ensure that all of the data is striped as evenly
as is possible(*). I don't think there are any filters that you should
to use -- just balance everything. The first time probably won't do
the job fully. A second balance probably will. These are going to take
a very long time to run (in your case, I'd guess at least a week for
each balance). I would recommend starting the balance in a tmux or
screen session, and also creating a second shell in the same session
to run monitoring processes. I typically use something like:

watch -n60 sudo btrfs fi show\; echo\; btrfs fi df /mountpoint\; echo\; btrfs bal stat /mountpoint

   Hugo.

(*) Hmmm... idea for a new filter: min/max stripe width? Then you
could balance only the block groups that aren't at full width, which
is probably what's needed here.

-- 
Hugo Mills             | Comic Sans goes into a bar, and the barman says, "We
hugo@... carfax.org.uk | don't serve your type here."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV5t3MAAoJEFheFHXiqx3kPmUP/3OKdwALdoMd3BpWyiZM8qBC
YSyEP1jhk0OrCPWg25GiM+3h47V+L+STv/ac0ASYNEImywJ8CefNuf7PeWxKxfyA
xIcL5dhlTCYnfXKpmaNGfVF/hgQj8vhm8OV5OJbqpXJTk602nVNxIJhieMEeCstI
U6KLhZEAcZOfqswKDhIz1kyFWodxH/00wJ5tyU+8qZO+4wStyj3gQTntXXgXmjJo
qoa+6j42AYVX7jiHVnH9288cZUttAKLZ92Euv48aGIw3l/uCWGlcq41DyPVYfWUx
cRFVMJVD0V4sFU+h/PKV/1sTyRSevCMkEeVs3oImny1IBr1hT8CyA51GVEeIsC9D
ldHFdHsE+2zvXP2Fh/G2vrEDdwJXL053tC+bsPUg050zdS0WMwswBdBM9IdbtP9W
g9leFtj5r8R8MLB3tQ6pGucB6D/Wt5e/YO5CjFo5iUCaGBUMxmbWnPOModP36F7A
Ef8b8JV1bKHJAzsa5NZQaahDktJGvxssWjwPx2hHUAh2DZAy08dBiDz++Ko2mmB0
wBz25f1A4HtlUqPEvBVEmog4FiwtxDKNWUvGBNedIcjjAFLt8fY1DywU0migGByt
AhiBsxLKpXTDGqqBfL1d1fSV0a34tW+Fi27Fv94ZDwYzMNFMjbP5k3DNN+PolWMA
MxhDZCCHwho1Qglt7gMf
=Ea2l
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--
