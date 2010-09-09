From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: Re: btrfs on LVM: Out of space
Date: Thu, 9 Sep 2010 17:52:23 +0800
Message-ID: <AANLkTi=EyKFr_QCAoWtM=wZ8EnijcDuDfjgiyaE+dnuc@mail.gmail.com>
References: <AANLkTinyfVH7DkOTNW-iSJjKExh5eS9Ea-HX0TY+XJ7b@mail.gmail.com>
 <AANLkTimLFf-GezTk07NCQjNKkB5RyVge81kzhs27=jAb@mail.gmail.com>
 <AANLkTini5k0cOwCW5WrZuw3M0ynDy8v9MbSyzPGMRmZy@mail.gmail.com>
 <AANLkTim2y=nV7eeKBGKJ1ynz1OTwo-q6BtF+BuEvX0c=@mail.gmail.com> <AANLkTikujoMMHiwhgBns7W462pPYSsTywY6uHCw2vUCD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Marcel Lohmann <marcel.lohmann@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikujoMMHiwhgBns7W462pPYSsTywY6uHCw2vUCD@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/9/9 Marcel Lohmann <marcel.lohmann@googlemail.com>:
> 2010/9/9 Zhu Yanhai <zhu.yanhai@gmail.com>:
>> 2010/9/9 Marcel Lohmann <marcel.lohmann@googlemail.com>:
>>> 2010/9/8 Zhu Yanhai <zhu.yanhai@gmail.com>:
>>> But if it is neccessary to "drop" that duplicate metadata, how can =
I
>>> arrange this afterwards. And if it is done, then I would have reduc=
ed
>>> the Metadata size, but will there really be more space for Data? Wh=
ere
>>> is the remaining space from 77 GB to 130 GB?
>>
>> 53 * 2 + 24 =3D 130. The size of Metadata reported by "btrfs filesys=
tem df"
>> is 53GB, however it occupies 53 * 2 =3D 106GB on 'disk' physically.
>> So yes, there will be more space for Data.
>>
>
> Perfect, great. This sounds strange on the first sight because it doe=
s
> not show anywhere that one has to double the metadata. Or better: tha=
t
> it is currently doubled.
> So I know what I have to do now. I will drop the partition and create=
 it again.
> There is then still the problem that I have twice the size of metadat=
a
> than real data. But I guess that is due to the high number of very
> small files (current estimate is 1440*50000 files with around 200Byte=
s
> to 2000Bytes). On the other hand there is only twice the size reserve=
d

200B ~ 2000B is really too small to the modern hard disks (some of them
already have 4KB-sectors instead of 512B).
Besides, currectly Btrfs doesn't play quite well with such small files,=
 you may
need to read this thread:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg05263.html
=46ortunately Chris found this is caused by a plain old bug in Btrfs,
and he already
had a patch for it, IIRC. Here it is:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg05292.html
I don't know whether it has been in the kernel you are using.

> and actually used a bit more that the real data.
>
> Many thanks for make that clear to me.

You're welcome!

>
> Marcel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

-zyh
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
