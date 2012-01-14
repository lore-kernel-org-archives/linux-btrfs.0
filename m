From: "Marco L. Crociani" <marco.crociani@gmail.com>
Subject: Re: Can't resize second device in RAID1
Date: Sat, 14 Jan 2012 19:18:34 +0100
Message-ID: <CADy=jfV+-sT_9opMeUXxOF4zWxt7PTQOg_+bPL7o5vq66omcsA@mail.gmail.com>
References: <CADy=jfVZjRAE049OiD6VkoKkpzZh9e_=V62AvuVwxyHZyfuU1w@mail.gmail.com>
 <CADy=jfWbzq81CrhCFy+RVd8e7265XZgkqomwOOxYaKehSpzasQ@mail.gmail.com>
 <20120113231717.GB21769@carfax.org.uk> <CADy=jfU88LRMw4Jmk4O_n+URRQxN2EUpiZCZe7GVK_LHPShmZA@mail.gmail.com>
 <20120114144236.GA22603@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: sander@humilis.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120114144236.GA22603@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 14, 2012 at 3:42 PM, Sander <sander@humilis.net> wrote:
> Marco L. Crociani wrote (ao):
>> On Sat, Jan 14, 2012 at 12:17 AM, Hugo Mills <hugo@carfax.org.uk> wr=
ote:
>> > On Sat, Jan 14, 2012 at 12:12:06AM +0100, Marco L. Crociani wrote:
>> >> # ./btrfs fi sh
>> >> Label: 'RootFS'?? uuid: c87975a0-a575-405e-9890-d3f7f25bbd96
>> >> ?????? Total devices 2 FS bytes used 284.98GB
>> >> ?????? devid?????? 2 size 311.82GB used 286.51GB path /dev/sdb3
>> >> ?????? devid?????? 1 size 897.76GB used 286.51GB path /dev/sda3
>> >>
>> >> /dev/sdb3 is the same.
>> >>
>> >> How can I resize /dev/sdb3?
>> >
>> > ?? I think the syntax you need is btrfs fi resize max /mnt/RootFS:=
2
>
>> ./btrfs fi resize max /mnt/RootFS:2
>> ERROR: can't access to '/mnt/RootFS:2'
>
> btrfs filesystem resize 2:max /mnt/RootFS
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Sander
>
> --
> Humilis IT Services and Solutions
> http://www.humilis.net

Perfect, Thank you!
I've written a section on:
http://btrfs.ipv5.de/index.php?title=3DUseCases

--=20
Marco Lorenzo Crociani,
marco.crociani@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
