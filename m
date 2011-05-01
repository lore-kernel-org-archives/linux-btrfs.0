From: cwillu <cwillu@cwillu.com>
Subject: Re: Btrfs raid1 "full sized"?
Date: Sun, 1 May 2011 14:02:23 -0600
Message-ID: <BANLkTinBBBsGGOmLS+B72qN_V2ZtEY7Qig@mail.gmail.com>
References: <BANLkTikthjOMgrF6pCGMGNABXitKxdNzmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: =?UTF-8?Q?Claes_Gyllensw=C3=A4rd?= <letharion@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikthjOMgrF6pCGMGNABXitKxdNzmA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 1, 2011 at 12:33 PM, Claes Gyllensw=C3=A4rd <letharion@gmai=
l.com> wrote:
> I've tried setting up a raid1 on two drives like this:
>
> mkfs.btrfs -m raid1 -d raid1 /dev/sdb /dev/sdc
>
> Then I copy my old install onto the new drives, and check the drives'=
 status:
>
> # mount | grep "on / "
> /dev/sdb on / type btrfs (rw,noatime)
> # btrfs fi df /
> Data, RAID1: total=3D259.00GB, used=3D256.64GB
> Data: total=3D8.00MB, used=3D0.00
> System, RAID1: total=3D8.00MB, used=3D44.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, RAID1: total=3D4.50GB, used=3D1.27GB
> Metadata: total=3D8.00MB, used=3D0.00
> # btrfs fi show
> Label: none =C2=A0uuid: c6c89292-ea29-484c-ad29-9003a5fedf90
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Total devices 2 FS bytes used 257.93GB
> =C2=A0 =C2=A0 =C2=A0 =C2=A0devid =C2=A0 =C2=A01 size 931.51GB used 26=
3.53GB path /dev/sdb
> =C2=A0 =C2=A0 =C2=A0 =C2=A0devid =C2=A0 =C2=A02 size 931.51GB used 26=
3.51GB path /dev/sdc
>
> Label: none =C2=A0uuid: 6f2f8317-3012-4e79-a82d-ab2e8eaa6cd6
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Total devices 1 FS bytes used 354.99GB
> =C2=A0 =C2=A0 =C2=A0 =C2=A0devid =C2=A0 =C2=A01 size 465.65GB used 46=
5.65GB path /dev/sda2
>
> My interpretation of the above data is that /dev/sdb and /dev/sdc are
> exact mirrors of each other, and contain my / root partition.
>
> This would make complete sense if it wasn't for the fact that I've
> copied all the data from /dev/sda2 onto /dev/sdb. From the informatio=
n
> above, it looks like the data has been split like in raid-0, instead
> of the what I expect, mirrored like in raid-1.
>
> I tried reading the FAQ about "Why are there so many ways to check th=
e
> amount of free space?" hoping this would make it more clear, but it
> doesn't. Can anyone tell me what's going on?
>
> I found one thread with a similar question that went unanswered, and
> it was also back in 2008 so the answer might differ quite a bit
> anyway.

How did you copy it exactly?  I see 100gb missing, which makes me
wonder if you maybe had subvolumes on sdb, and used the -x option to
rsync or similar:  subvolumes count as different mounts for the
purposes of --one-file-system'like options.

Can you provide the df -h output for both filesystems, as well as the
btrfs fi df for /dev/sda2?
The total reported by du -sh for each would be useful as well as a sani=
ty check.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
