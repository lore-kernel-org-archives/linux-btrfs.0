From: =?UTF-8?B?VGFtw6FzIEd1bMOhY3Np?= <gt-dev@gthomas.homelinux.org>
Subject: Re: btrfs on LVM: Out of space
Date: Thu, 9 Sep 2010 11:37:08 +0200
Message-ID: <AANLkTimjz0Bo_Vz7aapSfZXFJCsz7Ynm0uhykHhMrBdw@mail.gmail.com>
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

You can try "-l" option of mkfs.btrfs to have all the small files
packed in the metadata, not extents.

GThomas

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
> and actually used a bit more that the real data.
>
> Many thanks for make that clear to me.
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
