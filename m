From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs seed with luks encrypted devices
Date: Thu, 05 May 2011 19:42:37 -0400
Message-ID: <1304638900-sup-2004@think>
References: <4DC0AC9E.1030607@gmail.com> <BANLkTim013vB+PicvYCziBoyMctX2_jreQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Geoff Ritter <geoff.ritter@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BANLkTim013vB+PicvYCziBoyMctX2_jreQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from cwillu's message of 2011-05-03 21:50:53 -0400:
> On Tue, May 3, 2011 at 7:32 PM, Geoff Ritter <geoff.ritter@gmail.com>=
 wrote:
> > Not sure where to report bugs or even find a coherent list of them.=
 =C2=A0Sorry
> > if this is already well known.
> >
> > When attempting to use an unlocked encrypted device as either a see=
d device
> > or the writeable device, a kernel bug will be displayed at
> > fs/btrfs/volumes.c:2402 after attempting to add the writeable devic=
e to the
> > mounted read-only seed.
> >
> > STR:
> > 1. =C2=A0cryptsetup luksFormat /dev/sdx1
> > 2. =C2=A0cryptsetup luksOpen /dev/sdx1 luksSeed
> > 3. =C2=A0mkfs.btrfs /dev/mapper/luksSeed
> > 4. =C2=A0mount and add files if you want, then unmount
> > 5. =C2=A0btrfstune -S 1 /dev/mapper/luksSeed
> > 6. =C2=A0mount /dev/mapper/luksSeed /mnt/luksSeed
> > 7. =C2=A0btrfs device add /dev/sdx2 /mnt/luksSeed
> > 8. =C2=A0Observe kernel BUG.
> >
> > I would hope to expect to see an error message if this is never int=
ended to
> > be possible. =C2=A0But normal btrfs file systems appear to function=
 normally
> > under both encrypted and lvm partitions.
> >
> > This attached kernel message was from two LVM logical volumes on a =
luks
> > encrypted partition. =C2=A0However, I also tested this with two reg=
ular
> > partitions between endrypted-seed/unencrypted-rw,
> > =C2=A0endrypted-rw/unencrypted-seed, and both encrypted.

Ok, looks like I busted the seed support when I fixed up some of the
chunk allocations.  I'll reproduce this and work out a fix.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
