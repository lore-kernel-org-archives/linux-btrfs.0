From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: compression ratio
Date: Mon, 20 Jun 2011 10:51:50 -0500
Message-ID: <BANLkTikBnbS2W3E=UOrBtbvxOQzkuHNo0w@mail.gmail.com>
References: <BoFzq7Oi1uB@helmut.hullen.de>
	<4DFF6482.5080003@corp.mail.ru>
	<20110620152237.GA27340@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110620152237.GA27340@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 20, 2011 at 10:22 AM, Hugo Mills <hugo@carfax.org.uk> wrote=
:
> On Mon, Jun 20, 2011 at 07:17:22PM +0400, Proskurin Kirill wrote:
>> On 06/20/2011 06:34 PM, Helmut Hullen wrote:
>> >Du meintest am 20.06.11:
>> >>What we have:
>> >>SL6 - kernel 2.6.32-131.2.1.el6.x86_64
>> >>mdadm RAID5 with 8 HDD - 27T partition.
>> >
>> >You should take a newer kernel. On my system I needed 2.6.38.5 and =
newer
>> >for btrfs; older kernels lead to unreadable partitions.
>>
>> What kernel version is most recommended at this time?
>
> =A0 It's always "the latest version you can manage to run". So,
> currently, 2.6.39 or the 3.0-rc series.
>
> =A0 Hugo.
> have to audit the code yourself
> --
> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.=
org.uk =3D=3D=3D
> =A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org=
=2Euk
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 --- O tempura! O moresushi! -=
--
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iD8DBQFN/2W9IKyzvlFcI40RAgmuAKCEbTdS/ZjWzNMX3D5t8zNKbULJQACgyl6X
> e2SIUGnkDu1BFagOL2e5ymM=3D
> =3DSO2f
> -----END PGP SIGNATURE-----
>
>

Actually, the btrfs in the newest RHEL 2.6.32 kernels (and by
extension, SL kernels) has been heavily backported, so it is fairly
current, although probably not up to 2.6.39 level yet.  It isn't the
most current, but it is more current than most people realize, and
should be fairly stable.

I think you'll want the RHEL 6.1 (or SL 6.1) 2.6.32 kernel to get the
most recent Btrfs backporting.

I haven't seen any detailed information posted on the extent of the
backporting.  So, for right now, you're kind-of on your own to
ascertain if the btrfs in your RHEL kernel is suitable for your needs.

I believe the original poster is getting confused by results of the
'df' command.  Running 'df' will include a large amount of reserved
space for metadata.  The Btrfs Wiki has some insights on how to
evaluate the space consumed by a Btrfs volume.

But, in general, running 'df' will not give you a complete picture of
disk utilization with Btrfs.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
