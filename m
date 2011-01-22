From: Rodney Beede <mailinglist@rodneybeede.com>
Subject: Re: Shrinking virtual disk with btrfs on it
Date: Sat, 22 Jan 2011 11:27:52 -0700
Message-ID: <AANLkTimaufA8PoHhaHgJDD-O+oxxrO4tzZngkSqS=0Jw@mail.gmail.com>
References: <AANLkTimVGfP0UFgkTEtrqrc8RoPPoqgwu=x--KHa3Y9j@mail.gmail.com>
	<20110121173419.GA5268@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110121173419.GA5268@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 21, 2011 at 10:34 AM, Hugo Mills <hugo-lkml@carfax.org.uk> =
wrote:
> On Fri, Jan 21, 2011 at 10:20:34AM -0700, Rodney Beede wrote:
>> Any tools to go about zeroing about the free space on a btrfs file
>> system so I can shrink the VMware vmdk virtual disk?
>>
>> I ran the VMware command, but the dynamic disk is still really big. =
=C2=A0I
>> presume it is due to free space that isn't zeroed out.
>
> =C2=A0 One solution I've used before is to write a single very large =
file
> full of zeroes, filling the filesystem, then delete it.
>
> $ dd if=3D/dev/zero of=3D/mountpoint/foo.dat && rm /mountpoint/foo.da=
t
>
> =C2=A0 Hugo.
>
> --
> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.=
org.uk =3D=3D=3D
> =C2=A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.=
org.uk
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0--- ... =C2=A0one ping(1) to rule t=
hem all, and in the ---
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 darkness bind(2) them.
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iD8DBQFNOcObIKyzvlFcI40RAodJAJ0VyXnvxNH2MxTZ08uT8WaywsA=ED=88=80=E9=BD=
=82=E4=95=BA
> 7MRCSpCsPWGiXeS73ItqnWA=3D
> =3Dngld
> -----END PGP SIGNATURE-----
>
>


I tried your method, and it made things worst.  The disk just expanded
to the maximum.  I deleted the zero filled file and made sure btrfs
compress was off.  I ran the VMware disk manage tool and told it to
defragment and shrink but it didn't get any smaller.  I think btrfs
just doesn't work that way.

I also tried btrfs filesystem defragment with no luck.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
