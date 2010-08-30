From: Bryan Whitehead <driver@megahappy.net>
Subject: Re: remote mirroring in the works?
Date: Mon, 30 Aug 2010 10:21:18 -0700
Message-ID: <AANLkTi=ap5veJhyBsuWFJ3ppb2a_mSLiTu2YocAsQRBk@mail.gmail.com>
References: <AANLkTinmSdHwXXq3s64sM39GjacafgwgTjPadZGHuway@mail.gmail.com>
	<AANLkTimBVG3eGHvNUHFGYri+JyOXrOW91GKWeM_GVOYM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Fred van Zwieten <fvzwieten@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimBVG3eGHvNUHFGYri+JyOXrOW91GKWeM_GVOYM@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

LVM Snapshot.

lvm -s -n SnapShotName /dev/VolumeGroup/SourceLogicalVolumeName

you may need to pass -l or -L to give an initial size for the COW.

(as for rebuilding on another machine, that would require shared
storage or additional LVM tricks to export/import - or good old
fashioned dd)

that said, a more appropriate list to question is linux-lvm@redhat.com

On Mon, Aug 30, 2010 at 10:07 AM, Fred van Zwieten <fvzwieten@gmail.com=
> wrote:
> Hi there,
>
> I would like to know if there is something functionally equivalent to
> NetApp's SnapMirror in the works or planning? It would require block
> level access to a snap and the ability to rebuild (subvolumes
> including it's) snap's on another machine.
>
> If not, what would be the best way to build something more or less
> equivalent using existing tools? rsync-ing a snap seems the same, but
> it isn't. First of all it 's file based, not very nice for DB's, and
> you don't get the snap's on "the other side" the same.
>
> Fred
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
