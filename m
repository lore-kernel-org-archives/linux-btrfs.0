From: Bart Noordervliet <bart@noordervliet.net>
Subject: Re: Interpreting Output of "btrfs fi show"
Date: Thu, 26 Apr 2012 10:34:06 +0200
Message-ID: <CAGy7UtgsWOmvG16oFTRutFTu5bwq4kT+CQTicqPuYa45YhqUSA@mail.gmail.com>
References: <4F98B447.30102@ennit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Thomas Rohwer <trohwer@ennit.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F98B447.30102@ennit.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Thomas,

there's a known regression in 3.3.0 that causes btrfs to report
out-of-space too early. If you upgrade to 3.3.3 or the latest 3.4 rc
the problem should be gone.

As for the two filesystems shown in btrfs fi show... I have no clue
what that is about. Did you maybe make a mistake to create a btrfs
filesystem on the whole disk at first? The current situation looks a
bit dangerous, because writing to a filesystem on /dev/sda could
overwrite data from a filesystem on /dev/sda1...

Regards,

Bart

On Thu, Apr 26, 2012 at 04:34, Thomas Rohwer <trohwer@ennit.de> wrote:
> Hello,
>
> I am using btrfs as my root file system on partition sda1. Now I am g=
etting
> errors
> because of a full device, although df shows a use of only 64%. I read=
 the
> FAQ and
> understand that this number may not be accurate. But according to the=
 FAQ
> "btrfs fi show" should show a full device.
> I am getting:
>
> humbur:~# btrfs fi show
> failed to read /dev/sr0
> Label: none =C2=A0uuid: 484f8251-678f-4625-a05e-9dc8483f20a9
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Total devices 1 FS bytes used 64.31GB
> =C2=A0 =C2=A0 =C2=A0 =C2=A0devid =C2=A0 =C2=A01 size 111.79GB used 89=
=2E07GB path /dev/sda1
>
> Label: none =C2=A0uuid: be144c3c-3c34-45d1-aff2-415e72b0ec6e
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Total devices 1 FS bytes used 34.15GB
> =C2=A0 =C2=A0 =C2=A0 =C2=A0devid =C2=A0 =C2=A01 size 111.79GB used 37=
=2E29GB path /dev/sda
>
> Btrfs Btrfs v0.19
>
> And this does not make sense to me at all. First, the device listed f=
or
> /dev/sda1
> does not seem to be fully used. Second, I have no idea what the entry=
 for
> /dev/sda
> is supposed to mean. There should be only one btrfs filesystem, and
> certainly not
> a second one on the device /dev/sda.
>
> Some additional information:
>
> humbur:~# btrfs fi df /
> Data: total=3D76.00GB, used=3D60.27GB
> System, DUP: total=3D32.00MB, used=3D20.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, DUP: total=3D6.50GB, used=3D4.04GB
>
> humbur:~# df
> Filesystem =C2=A0 =C2=A0 1K-blocks =C2=A0 =C2=A0 Used Available Use% =
Mounted on
> rootfs =C2=A0 =C2=A0 =C2=A0 =C2=A0 117219800 71666680 =C2=A040316032 =
=C2=A064% /
> /dev/root =C2=A0 =C2=A0 =C2=A0117219800 71666680 =C2=A040316032 =C2=A0=
64% /
> tmpfs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 397608 =C2=A0 =C2=A0 =
=C2=A0200 =C2=A0 =C2=A0397408 =C2=A0 1% /run
> tmpfs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 5120 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A05120 =C2=A0 0% /run/lock
> tmpfs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 795212 =C2=A0 =C2=A0 =
=C2=A0 =C2=A08 =C2=A0 =C2=A0795204 =C2=A0 1% /tmp
> tmpfs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A010240 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 10240 =C2=A0 0% /dev
> tmpfs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 795212 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00 =C2=A0 =C2=A0795212 =C2=A0 0% /run/shm
>
> humbur:~# cat /proc/mounts
> rootfs / rootfs rw 0 0
> /dev/root / btrfs rw,noatime,ssd,noacl,nospace_cache 0 0
> tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=3D397608k,mode=3D755 =
0 0
> tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=3D5120k 0 =
0
> tmpfs /tmp tmpfs rw,nosuid,nodev,relatime,size=3D795212k 0 0
> proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
> sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
> tmpfs /dev tmpfs rw,relatime,size=3D10240k,mode=3D755 0 0
> tmpfs /run/shm tmpfs rw,nosuid,nodev,relatime,size=3D795212k 0 0
> devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=3D5,mode=3D620 0=
 0
>
> humbur:~# ls -l /dev/sd*
> brw-rw---T 1 root disk 8, 0 Apr 26 01:27 /dev/sda
> brw-rw---T 1 root disk 8, 1 Apr 26 01:18 /dev/sda1
>
> humbur:~# cat /proc/version
> Linux version 3.3.0 (tr@humbur) (gcc version 4.6.3 (GCC) ) #3 SMP Thu=
 Apr 5
> 00:14:18 CEST 2012
>
>
>
>
> Some help would be appreciated.
>
> Sincerely,
>
> Thomas Rohwer
>
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
