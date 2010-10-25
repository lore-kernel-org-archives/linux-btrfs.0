From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: Determine if a given fs is a btrfs fs
Date: Mon, 25 Oct 2010 21:27:30 +0200
Message-ID: <20101025192730.GA2839@scooter>
References: <20101024202410.GA2830@scooter>
 <AANLkTikB06jNR-QmkXjWWFE6fO=cTZvEDFbY5V98Pu6g@mail.gmail.com>
 <AANLkTina9g610_FLHHsOG3KSn5pgeiHCgaNtE7NnvH7g@mail.gmail.com>
 <AANLkTimdQPmn_VPzs6H_HT_+m9uM2PCno1W_D0mib8Yx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimdQPmn_VPzs6H_HT_+m9uM2PCno1W_D0mib8Yx@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

that was a good hint, thanks a lot!

The best at that solution is that it works for all filesystems: Just te=
st if the
output of $type (type=3D`blkid -s TYPE -o value $loopdev`) is empty (''=
), then it is no
filesystem and the loopaes password was wrong or the device/fs is broke=
n.



=46elix


On 25. October 2010 - 08:29, C Anthony Risinger wrote:
> Date:	Mon, 25 Oct 2010 08:29:58 -0500
> From: C Anthony Risinger <anthony@extof.me>
> To: J=E9r=F4me Poulin <jeromepoulin@gmail.com>
> Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
> Subject: Re: Determine if a given fs is a btrfs fs
>=20
> On Mon, Oct 25, 2010 at 6:31 AM, J=E9r=F4me Poulin <jeromepoulin@gmai=
l.com> wrote:
> > On Sun, Oct 24, 2010 at 5:32 PM, J=E9r=F4me Poulin <jeromepoulin@gm=
ail.com> wrote:
> > ...
> >> p4 jerome # btrfs device scan /dev/dm-22
> >> Scanning for Btrfs filesystems in '/dev/dm-22'
> >> p4 jerome # echo $?
> >> 0
> > This is OK.
> >
> >> p4 jerome # btrfs device scan /dev/sda
> >> Scanning for Btrfs filesystems in '/dev/sda'
> >> ERROR: unable to scan the device '/dev/sda'
> >> p4 jerome # echo $?
> >> 11
> > ...
> > But isn't that error misleading, btrfs scan was succesfully able to
> > scan /dev/sda, but, it doesn't contain btrfs, right?
>=20
> imo, the best way is:
>=20
> # root must be btrfs else silent return
> [ "$(blkid -s TYPE -o value ${root})" =3D btrfs ] || return 0
>=20
> at least that the way i do it in my initramfs hook; seems to be relia=
ble.
>=20
> C Anthony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
