From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: Find RAID level, Change RAID level.
Date: Sun, 30 Oct 2011 16:42:57 +0200
Message-ID: <20111030144257.GA31831@zambezi.lan>
References: <CACCfv7oD=u3dyz38Q32+ehi0gG_-TZes-E6WMD3YVETDexbpNA@mail.gmail.com>
 <Bwm7ykHD1uB@helmut.hullen.de>
 <CACCfv7onURQQGGtY63kcirrxFtW4w-K8x0uqb_TPExoJc96row@mail.gmail.com>
 <20111030140617.GA7012@zambezi.lan>
 <CACCfv7rE+1v5bAo4aDDq1i-_4BG8VRCTowDQt1uWDaZ=czgCyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Jordan Windsor <jordanw2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACCfv7rE+1v5bAo4aDDq1i-_4BG8VRCTowDQt1uWDaZ=czgCyQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2011 at 12:56:51AM +1030, Jordan Windsor wrote:
> On Mon, Oct 31, 2011 at 12:36 AM, Ilya Dryomov <idryomov@gmail.com> w=
rote:
> > On Mon, Oct 31, 2011 at 12:10:34AM +1030, Jordan Windsor wrote:
> >> Thanks, It currently shows this:
> >>
> >> Data: total=3D195.01GB, used=3D193.93GB
> >> System, DUP: total=3D8.00MB, used=3D28.00KB
> >> System: total=3D4.00MB, used=3D0.00
> >> Metadata, DUP: total=3D1.75GB, used=3D385.41MB
> >> Metadata: total=3D8.00MB, used=3D0.00
> >>
> >> I didn't specify any RAID levels during creation. I'd like to have=
 a
> >> RAID0 installation across two hard drives.
> >
> > How many devices do you have in your FS right now ? =C2=A0If it's o=
nly 1 then
> > add another one (btrfs device add <dev> <path to FS>) and run balan=
ce
> > (btrfs fi balance <path to FS>). =C2=A0That should give you raid0 f=
or data
> > across two drives w/o applying any patches.
> >
> > Thanks,
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Ilya
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-bt=
rfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
> >
>=20
> Thanks, I was wondering if I added a device that was already part of
> another btrfs volume, then would I have the files merged as one volum=
e
> or overwritten in the newly added one?

A device can only be part of another btrfs FS, not sure what you mean b=
y
volume.  If you add a device which is part of another btrfs FS you'll
break that FS and the data on that device will be overwritten.

Thanks,

		Ilya
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
