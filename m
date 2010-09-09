From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: Re: btrfs on LVM: Out of space
Date: Thu, 9 Sep 2010 10:15:56 +0800
Message-ID: <AANLkTim2y=nV7eeKBGKJ1ynz1OTwo-q6BtF+BuEvX0c=@mail.gmail.com>
References: <AANLkTinyfVH7DkOTNW-iSJjKExh5eS9Ea-HX0TY+XJ7b@mail.gmail.com>
 <AANLkTimLFf-GezTk07NCQjNKkB5RyVge81kzhs27=jAb@mail.gmail.com> <AANLkTini5k0cOwCW5WrZuw3M0ynDy8v9MbSyzPGMRmZy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Marcel Lohmann <marcel.lohmann@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTini5k0cOwCW5WrZuw3M0ynDy8v9MbSyzPGMRmZy@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/9/9 Marcel Lohmann <marcel.lohmann@googlemail.com>:
> 2010/9/8 Zhu Yanhai <zhu.yanhai@gmail.com>:
>> Hi,
>> Have you ever tried with 'mkfs.btrfs -m single /dev/xxxx'?
>> As you had a RAID1 based on LVM, you don't have to keep
>> the default duplicated metadata profile in Btrfs.
>>
>> -zyh
>>
>> 2010/9/8 Marcel Lohmann <marcel.lohmann@googlemail.com>:
>>> In that complete logical volume I created a btrfs partition. And
>>> btrfs-show displays 130GB space. Fine.
>
>>> to give me the actual numbers. And that tells me:
>>> Data: total=3D23.97GB, used=3D23.97GB
>>> Metadata: total=3D53.01GB, used=3D33.98GB
>>> System: total=3D12.00MB, used=3D16.00KB
>
> No, I did not try this. I just created it with the defaults
> "mkfs.btrfs /dev/mapper/somelogicalvolume". Isn't "-m single" the
> default?

No, it's not by default. Btrfs will write two copies of the Metadata in=
to
disk by default, with only one copy of Data -- something similar with
RAID1, but not the same.
Anyway, you don't need this, since you already have a standard RAID1
array setup by LVM.
'-m single' makes Btrfs write exactly one copy of Metadata, instead of
two by default.

> So is it right that btrfs "knows" that it is running on a RAID and
> changes it's behavior? Why? Normally a FS does not care about the
> underlaying (hidden) disk array.

No, it doesn't know.

> But if it is neccessary to "drop" that duplicate metadata, how can I
> arrange this afterwards. And if it is done, then I would have reduced
> the Metadata size, but will there really be more space for Data? Wher=
e
> is the remaining space from 77 GB to 130 GB?

53 * 2 + 24 =3D 130. The size of Metadata reported by "btrfs filesystem=
 df"
is 53GB, however it occupies 53 * 2 =3D 106GB on 'disk' physically.
So yes, there will be more space for Data.

>
> Maybe I was pointing it the wrong way, sorry. I created a mdadm
> software RAID1 and on that is a LVM. I did not use btrfs to span over
> two disks. The md RAID with LVS was there before and I couldn't chang=
e
> this.
> This is why I have no btrfs-RAID but a md-RAID.
>
> Marcel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
