From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Can you please define "snapshot" and "subvolume"?
Date: Thu, 7 Oct 2010 20:08:23 +0200
Message-ID: <201010072008.23715.kreijack@libero.it>
References: <AANLkTimBsVGS=eJvpdf2Sq_Dg76zQRgy=E+3089zQ9D4@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimBsVGS=eJvpdf2Sq_Dg76zQRgy=E+3089zQ9D4@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, 07 October, 2010, Francis Galiegue wrote:
> I have difficulties grabbing these two concepts.
>=20
> As far as I can tell, a snapshot is an instant, synchronized,
> photography of the filesystem at a given point in time; a subvolume i=
s
> a "subroot" to a btrfs filesystem.
>=20
> While I fully understand (and use) the purpose of snapshots, I don't
> quite fathom the use case for subvolumes, apart from btrfs-convert...
> Why has btrfs grown such a feature in the first place? Can someone
> give me a use case for them?

By design in btrfs a snapshot is "a instant, synchronized, photography =
of" a=20
subvolume.
In fact you can snapshot only a subvolume [*].=20

Moreover the subvolumes have the following properties:

1) it is possible to mount a subvolume of a filesystem: if you execute =
the=20
following commands:

# mount -o subvol=3Dname-of-subvol /dev/sdxx /mn/test

the kernel will use the subvolume "name-of-subvol" of the btrfs filesys=
tem of=20
the partition /dev/sdxx. Pay attention: this work *only* if the subvolu=
me=20
"name-of-subvol" is under the root of the filesystem.

2) a subvolume may be deleted asynchronously by the command "btrfs subv=
ol=20
delete <path>". Pay attention that the deletion is performed not instan=
taneous=20
but in background. In fact even though the subvolume disappear instanta=
neous=20
the space is freed during the background removing.

3) If you have a subvolume into another one, and you snapshot the latte=
r, in=20
the snapshot you cannot see the nested subvolume.=20
=46or example you have the root ('/') under a subvolume and the /home u=
nder=20
another subvolume. If you snapshot the root, this snapshot will not con=
tain=20
the subvolume /home. This may be useful if you want restore an old snap=
shot of=20
the root filesystem without affecting the users homes directories.

In the future some attributes (raid mode, compression) may be set per-
subvolume basis.

Regards
G.Baroncelli


[*] The btrfsctl utility doesn't return an error when you snapshot a=20
directory. But instead of snapshotting the directory you get a snapshot=
 of the=20
subvolume which contain the directory.
>=20
> --=20
> Francis Galiegue, fgaliegue@gmail.com
> "It seems obvious [...] that at least some 'business intelligence'
> tools invest so much intelligence on the business side that they have
> nothing left for generating SQL queries" (St=C3=A9phane Faroult, in "=
The
> Art of SQL", ISBN 0-596-00894-5)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
gpg key@ keyserver.linux.it:Goffredo Baroncelli (ghigo) <kreijackATinwi=
nd.it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
