From: "Marco L. Crociani" <marco.crociani@gmail.com>
Subject: Can't resize second device in RAID1
Date: Sat, 14 Jan 2012 00:12:06 +0100
Message-ID: <CADy=jfWbzq81CrhCFy+RVd8e7265XZgkqomwOOxYaKehSpzasQ@mail.gmail.com>
References: <CADy=jfVZjRAE049OiD6VkoKkpzZh9e_=V62AvuVwxyHZyfuU1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADy=jfVZjRAE049OiD6VkoKkpzZh9e_=V62AvuVwxyHZyfuU1w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
the situation:
Label: 'RootFS'=C2=A0 uuid: c87975a0-a575-405e-9890-d3f7f25bbd96
=C2=A0=C2=A0=C2=A0 Total devices 2 FS bytes used 284.98GB
=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 2 size 311.82GB used 286.51G=
B path /dev/sdb3
=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 size 897.76GB used 286.51G=
B path /dev/sda3

RootFS created when sda3 was 897.76GB and sdb3 311.82GB.
I have now freed other space on sdb. So I deleted sdb3 and recreated
it occupying all available space.

Disk /dev/sdb: 2000 GB, 2000396321280 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
/dev/sdb3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 54=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 117249=C2=A0=C2=A0 941=
368837=C2=A0=C2=A0 83=C2=A0 Linux

same as
/dev/sda3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 54=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 117249=C2=A0=C2=A0 941=
368837=C2=A0=C2=A0 83=C2=A0 Linux

# ./btrfs filesystem resize max /mnt/RootFS
Resize '/mnt/RootFS' of 'max'

on dmesg I get only:
[=C2=A0 657.438464] btrfs: new size for /dev/sda3 is 963962208256

# ./btrfs fi sh
Label: 'RootFS'=C2=A0 uuid: c87975a0-a575-405e-9890-d3f7f25bbd96
=C2=A0=C2=A0=C2=A0 Total devices 2 FS bytes used 284.98GB
=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 2 size 311.82GB used 286.51G=
B path /dev/sdb3
=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 size 897.76GB used 286.51G=
B path /dev/sda3

/dev/sdb3 is the same.

How can I resize /dev/sdb3?

Regards,

--
Marco Lorenzo Crociani,
marco.crociani@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
