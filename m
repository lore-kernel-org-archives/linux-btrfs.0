From: Chalet16 <chalet16@gmail.com>
Subject: Re: How can I recover data from little overwritten missing raid0 device?
Date: Sun, 17 Oct 2010 23:09:48 +0700
Message-ID: <AANLkTi=va_Nxu0KvP6C5PCYdUKfP2nb+UjMHcG6pdhJY@mail.gmail.com>
References: <AANLkTinbmFFNySV=_vmWZzQWeLxL3wgBUmsuKch7Mn6j@mail.gmail.com>
	<AANLkTi=SLr_6E=Dwt5SmLp7_b4BGRMka0uXo=8qQp6Kf@mail.gmail.com>
	<201010171804.59034.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010171804.59034.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

It seem that another device doesn't detect as btrfs filesystem anymore.=
(I think
because its header had been overwritten.) That device is not appear whe=
n I run
"btrfs filesystem show".



On Sun, Oct 17, 2010 at 11:04 PM, Goffredo Baroncelli
<kreijack@libero.it> wrote:
> After a reboot you need to do
>
> # btrfs device scan
>
> in order to search all devices which may be involved in a multi devic=
es setup
> (like RAID).
>
> G.Baroncelli
>
>
>
>
> On Sunday, 17 October, 2010, Chalet16 wrote:
>> UPDATE: I'm currently =C2=A0able to see and read/write some file in =
degraded mode
>> but there're many file i can't read with input/output error too.
>>
>>
>> On Sun, Oct 17, 2010 at 9:57 PM, Chalet16 <chalet16@gmail.com> wrote=
:
>> > I had set up btrfs with 2 devices by using command this command se=
quence.
>> > "mkfs.btrfs -m raid1 /dev/sda1
>> > mount /dev/sda1 /mnt/data
>> > btrfs-vol -a /dev/sdb1 /mnt/data
>> > btrfs-vol -b /mnt/data"
>> >
>> > (I was think that it will do raid1 for both data and metadata but =
I
> currently
>> > realised that it will do raid1 for metadata but raid0 for data.)
>> >
>> > But I forgot that I have mount /dev/sdb1 with TrueCrypt. After I r=
estarted
> my
>> > PC and try to mount both devices array again there was a message i=
n dmesg
> said
>> > "chalet16@server:~$ sudo mount /dev/sda1 /mnt/data
>> > [ 2828.921406] device label btr2902 devid 1 transid 8829
> /dev/mapper/truecrypt1
>> > [ 2828.931780] btrfs: failed to read the system array on dm-1
>> > [ 2828.961330] btrfs: open_ctree failed"
>> >
>> > And when I ran btrfs-show it show that
>> > "chalet16@server:~$ sudo btrfs-show
>> > failed to read /dev/sr0
>> > Label: btr2902 =C2=A0uuid: 5673597c-ff57-4a42-8fe3-ff793f476809
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0Total devices 2 FS bytes used 706.75GB
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0devid =C2=A0 =C2=A01 size 930.00GB used=
 717.26GB path /dev/sda1
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0*** Some devices missing
>> > Btrfs Btrfs v0.19"
>> > And when I run btrfsck on missing device
>> > "chalet16@server:~$ sudo btrfsck /dev/sde1
>> > No valid Btrfs found on /dev/sde1"
>> >
>> > So I would like to ask for help to recover data from this btrfs ra=
id
> array. In
>> > my opinion I think that TrueCrypt only overwrite a little location=
 in
> device
>> > because I haven't done anything with TrueCrypt device after that.
>> >
>> > Thanks
>> > Chalet16
>> >
>> >
>> > PS. I have recently known that TrueCrypt is in "Forbidden items" l=
ist in
> Fedora
>> > wiki, but this is not really related to TrueCrypt so please don't =
ban me
> because
>> > I had used TrueCrypt.
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
> --
> gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@in=
wind.it>
> Key fingerprint =3D 4769 7E51 5293 D36C 814E =C2=A0C054 BF04 F161 3DC=
5 0512
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
