From: "Marco L. Crociani" <marco.crociani@gmail.com>
Subject: Re: Can't resize second device in RAID1
Date: Sat, 14 Jan 2012 00:32:00 +0100
Message-ID: <CADy=jfU88LRMw4Jmk4O_n+URRQxN2EUpiZCZe7GVK_LHPShmZA@mail.gmail.com>
References: <CADy=jfVZjRAE049OiD6VkoKkpzZh9e_=V62AvuVwxyHZyfuU1w@mail.gmail.com>
 <CADy=jfWbzq81CrhCFy+RVd8e7265XZgkqomwOOxYaKehSpzasQ@mail.gmail.com> <20120113231717.GB21769@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>,
	"Marco L. Crociani" <marco.crociani@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120113231717.GB21769@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 14, 2012 at 12:17 AM, Hugo Mills <hugo@carfax.org.uk> wrote=
:
> On Sat, Jan 14, 2012 at 12:12:06AM +0100, Marco L. Crociani wrote:
>> Hi,
>> the situation:
>> Label: 'RootFS'=C2=A0 uuid: c87975a0-a575-405e-9890-d3f7f25bbd96
>> =C2=A0=C2=A0=C2=A0 Total devices 2 FS bytes used 284.98GB
>> =C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 2 size 311.82GB used 286.=
51GB path /dev/sdb3
>> =C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 size 897.76GB used 286.=
51GB path /dev/sda3
>>
>> RootFS created when sda3 was 897.76GB and sdb3 311.82GB.
>> I have now freed other space on sdb. So I deleted sdb3 and recreated
>> it occupying all available space.
>>
>> Disk /dev/sdb: 2000 GB, 2000396321280 bytes
>> 255 heads, 63 sectors/track, 243201 cylinders
>> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>> /dev/sdb3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 54=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 117249=C2=A0=C2=A0 =
941368837=C2=A0=C2=A0 83=C2=A0 Linux
>>
>> same as
>> /dev/sda3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 54=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 117249=C2=A0=C2=A0 =
941368837=C2=A0=C2=A0 83=C2=A0 Linux
>>
>> # ./btrfs filesystem resize max /mnt/RootFS
>> Resize '/mnt/RootFS' of 'max'
>>
>> on dmesg I get only:
>> [=C2=A0 657.438464] btrfs: new size for /dev/sda3 is 963962208256
>>
>> # ./btrfs fi sh
>> Label: 'RootFS'=C2=A0 uuid: c87975a0-a575-405e-9890-d3f7f25bbd96
>> =C2=A0=C2=A0=C2=A0 Total devices 2 FS bytes used 284.98GB
>> =C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 2 size 311.82GB used 286.=
51GB path /dev/sdb3
>> =C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 size 897.76GB used 286.=
51GB path /dev/sda3
>>
>> /dev/sdb3 is the same.
>>
>> How can I resize /dev/sdb3?
>
> =C2=A0 I think the syntax you need is btrfs fi resize max /mnt/RootFS=
:2
>

It's wrong :(

=2E/btrfs fi resize max /mnt/RootFS:2
ERROR: can't access to '/mnt/RootFS:2'

> =C2=A0 But I could be wrong. If it works, can you add it to the UseCa=
ses
> page on the wiki, please?

Sure.

>
> =C2=A0 Hugo.
>
> --
> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.=
org.uk =3D=3D=3D
> =C2=A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.=
org.uk
> =C2=A0 =C2=A0 =C2=A0 --- Someone's been throwing dead sheep down my F=
un Well ---



--=20
Marco Lorenzo Crociani,
marco.crociani@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
