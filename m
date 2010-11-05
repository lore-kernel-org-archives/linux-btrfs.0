From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: RFC: exporting info via sysfs [was Re: [patch 0/2] Control
 filesystem balances (kernel side)]
Date: Fri, 5 Nov 2010 12:41:44 +0000
Message-ID: <20101105124144.GA8002@vlad.carfax.org.uk>
References: <20101030000726.286517546@carfax.org.uk>
 <201010301944.35962.kreijack@libero.it>
 <201011042355.25214.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo-lkml@carfax.org.uk>
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201011042355.25214.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Goffredo,

On Thu, Nov 04, 2010 at 11:55:24PM +0100, Goffredo Baroncelli wrote:
> I make a prototype for exporting info from btrfs via sysfs.

   Good stuff. I was going to take a look at doing that this
weekend. :)

> Under /sys/btrfs were created two directories, named "fs" and "devices".
>
> /sys/btrfs/fs/<fs-uuid>/

   I'm pretty sure that /sys/btrfs won't get through any discussion on
LKML. I'd suggest /sys/fs/btrfs as the base, since that's where the
other filesystems seem to put their sysfs information.

>                          label		-> filesystem label
>                          num_devices    -> total number of devices
>                          open_devices   -> number of opened devices
>                          [...]
> /sys/btrfs/devices/<dev-uuid>/
>                          devid          -> btrfs device number
>                          fsid           -> filesystem uuid (fs-uuid)
>                          major, minor   -> major minor

   I think the major, minor should instead be be a symlink to the
relevant entry in /sys/devices/...  (as done in /sys/block/*) or
/sys/block (as done in /sys/block/md*/slaves). Call it "device".

>                          name           -> device name

   Unnecessary -- and also, I think, unlikely to get through LKML
review. Putting a device name here implies that the kernel knows
better than userspace what the name of the device is (i.e. which
device node you should be using). Having the link to /sys/block/* or
/sys/devices/... as above is, I think, all that's needed here.
Userspace should be able to convert the major/minor pair kept in
/sys/fs/btrfs/devices/<uuid>/device/dev appropriately.

>                          writeable      -> is the device writeable

> where <fs-uuid> is the filesystem uuid, and <dev-uuid> is the device uuid. The 
> link between devices and filesystem is the <fsid> parameter of a device.

   Could that be made a symlink instead? That seems to be the usual
approach in sysfs.

> I create these structure because we should handle the case were the devices 
> are present (like after a "btrfs device scan") but the filesystem aren't 
> mounted.

   ... ah, I see it can't. (Re: my previous comment)

> In this case the devices/ subdirectory is populated. Instead the fs/ 
> subdirectory is empty.
> 
> I don't attach a patch because the code is very ugly.
> Comments ? Thoughts ?

   Is it ugly because there are significant difficulties in making
btrfs or sysfs do this, or just because you hacked something together
as quickly as possible for a demo?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "There's a Martian war machine outside -- they want to talk ---   
                to you about a cure for the common cold."                

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM0/uIIKyzvlFcI40RAkH/AJ9E4tS4FWnhRG7oSlTQjQ7MX7IewQCgiQyb
o6nXHG2hIL+Ga8WymMjRwe8=
=JiEJ
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
