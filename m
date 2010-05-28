From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: linux 2.6.34 raid1 btrfs weird mounting issue
Date: Fri, 28 May 2010 20:52:30 +0200
Message-ID: <AANLkTilrELiD1_aFbCGJNOc6kbshcY-ZfUHOV1dw1trA@mail.gmail.com>
References: <alpine.DEB.1.10.1005271527320.19767@mtl.rackplans.net>
	<m3hblti0my.fsf@pullcord.laptop.org>
	<alpine.DEB.1.10.1005281439280.26232@mtl.rackplans.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: gmack@innerfire.net, linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1005281439280.26232@mtl.rackplans.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 28 May 2010 20:45,  <gmack@innerfire.net> wrote:
> I had my raid set to mount by uuid but that randomly doesn't work so =
I
> changed to mounting by the first partition in the raid.. that worked =
but
> on the next reboot it failed. =C2=A0Changing the mount to the second =
partition
> worked until the next reboot when I needed it to change it back to th=
e
> first. =C2=A0Each change seems to last for one reboot.
>
>
> # mount /dev/sdb1 =C2=A0/home
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
> =C2=A0 =C2=A0 =C2=A0 missing codepage or helper program, or other err=
or
> =C2=A0 =C2=A0 =C2=A0 In some cases useful info is found in syslog - t=
ry
> =C2=A0 =C2=A0 =C2=A0 dmesg | tail =C2=A0or so
>
> # mount /dev/sdb1 =C2=A0/home
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
> =C2=A0 =C2=A0 =C2=A0 missing codepage or helper program, or other err=
or
> =C2=A0 =C2=A0 =C2=A0 In some cases useful info is found in syslog - t=
ry
> =C2=A0 =C2=A0 =C2=A0 dmesg | tail =C2=A0or so
>
> mount /dev/sdc1 =C2=A0/home
> (worked)
> # btrfs-show
> failed to read /dev/sr0
> Label: none =C2=A0uuid: a2aa44b8-3168-480a-a155-d510e05853e7
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Total devices 1 FS bytes used 5.46GB
> =C2=A0 =C2=A0 =C2=A0 =C2=A0devid =C2=A0 =C2=A01 size 29.33GB used 13.=
29GB path /dev/sda2
>
> Label: fhome =C2=A0uuid: 128ddab5-224d-4f45-abc0-6a07d0f63d47
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Total devices 2 FS bytes used 8.24GB
> =C2=A0 =C2=A0 =C2=A0 =C2=A0devid =C2=A0 =C2=A01 size 931.51GB used 21=
=2E03GB path /dev/sdb1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0devid =C2=A0 =C2=A02 size 931.51GB used 21=
=2E01GB path /dev/sdc1
>
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Gerhard
>
>
> --
> Gerhard Mack
>
> gmack@innerfire.net
>
> <>< As a computer I find your faith in technology amusing.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Did you check output from dmesg?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
