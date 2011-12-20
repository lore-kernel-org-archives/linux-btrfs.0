From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: COW a file from snapshot
Date: Tue, 20 Dec 2011 12:53:36 -0500
Message-ID: <CALJXSJpTv2jJN6=J4tQygjAufuMt_FY=2Zg1=Xcwyb9qOUejJw@mail.gmail.com>
References: <20111220150717.GA24891@hendrix.borisch.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Dave <dave@thekilempire.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111220150717.GA24891@hendrix.borisch.local>
List-ID: <linux-btrfs.vger.kernel.org>

You would need to apply this patch to your kernel:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg09096.html

Is there any chance this patch gets in linux-next ?
I use this feature all the time and it never broke on me.

On Tue, Dec 20, 2011 at 10:07 AM, Dave <dave@thekilempire.com> wrote:
>
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
>
> So I've got a daily snapshot of my /home subvolume. =C2=A0Due to a fa=
t finger, I've
> damaged a rather large file so I'd like to pull if from one of these =
snapshot
> backups. =C2=A0I don't want to simply copy the file since it's many g=
igs and cp
> - --reflink=3Dalways doesn't work (produces the error Invalid cross-d=
evice link).
> Is there a way to recover that file and benefit from COW?
> - --
> - -=3D[dave]=3D-
>
> Entropy isn't what it used to be.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
>
> iF4EAREIAAYFAk7wpKUACgkQXM0u5ajNnCgMUQD/Uf0/HygZ9D8StT9Oc6E3+wM/
> MBokh6h1iPN2OslJTxgA/RUzFMM2n0+3ORHwvOraJMBJl1P4JfabT31iuemn/BL2
> =3D2cds
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
