From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Updating the wiki pages adding btrfs command [Was Re: reserving an IOCTL number; other details]
Date: Wed, 15 Sep 2010 19:51:04 +0200
Message-ID: <201009151951.04870.kreijack@libero.it>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com> <201009142125.56710.kreijack@libero.it> <AANLkTimB-tHAL8U8-_=9QsKisQgO-QPt4=X89QOsiPaK@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimB-tHAL8U8-_=9QsKisQgO-QPt4=X89QOsiPaK@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

the btrfs command is smart enough to accept short form of the sub-comma=
nd if=20
there is no ambiguity. For example "btrfs fi" is a synonymous of "btrfs=
=20
filesystem".
Because that the acronyms are discouraged. Instead a long form is prefe=
rred.

So instead of CG (which means ? Garbage Collector ? ) I suggest=20

	btrfs filesystem wait-subvolume-deletion

or better
=09
	btrfs subvolume wait-deletion

which is a better self-explain form and may be shortened as

	btrfs s w

Only my 2=C2=A2

regards
G.Baroncelli




On Wednesday, 15 September, 2010, David Nicol wrote:
> Does the manpatch below describe an acceptable API for a hook to a
> facility for waiting for the completion of deleted snapshot cleanup?
>=20
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index 26ef982..290d202 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -19,6 +19,8 @@ btrfs \- control a btrfs filesystem
>  .PP
>  \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
>  .PP
> +\fBbtrfs\fP \fBfilesystem GC\fP\fI <path> [ms] \fP
> +.PP
>  \fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max=20
<filesystem>\fP
>  .PP
>  \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
> @@ -115,6 +117,12 @@ all the block devices.
>  Force a sync for the filesystem identified by \fI<path>\fR.
>  .TP
>=20
> +\fBfilesystem GC\fR\fI <path> [ms] \fR
> +wait for completion of salvage of deleted subvolumes on
> +the filesystem identified by \fI<path>\fR. The optional
> +timeout is in milliseconds.
> +.TP
> +
>  .\"
>  .\" Some wording are extracted by the resize2fs man page
>  .\"
>=20
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
