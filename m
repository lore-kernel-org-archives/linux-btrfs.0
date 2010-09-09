From: Marcel Lohmann <marcel.lohmann@googlemail.com>
Subject: Re: btrfs on LVM: Out of space
Date: Thu, 9 Sep 2010 11:23:22 +0200
Message-ID: <AANLkTikujoMMHiwhgBns7W462pPYSsTywY6uHCw2vUCD@mail.gmail.com>
References: <AANLkTinyfVH7DkOTNW-iSJjKExh5eS9Ea-HX0TY+XJ7b@mail.gmail.com>
	<AANLkTimLFf-GezTk07NCQjNKkB5RyVge81kzhs27=jAb@mail.gmail.com>
	<AANLkTini5k0cOwCW5WrZuw3M0ynDy8v9MbSyzPGMRmZy@mail.gmail.com>
	<AANLkTim2y=nV7eeKBGKJ1ynz1OTwo-q6BtF+BuEvX0c=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim2y=nV7eeKBGKJ1ynz1OTwo-q6BtF+BuEvX0c=@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/9/9 Zhu Yanhai <zhu.yanhai@gmail.com>:
> 2010/9/9 Marcel Lohmann <marcel.lohmann@googlemail.com>:
>> 2010/9/8 Zhu Yanhai <zhu.yanhai@gmail.com>:
>> But if it is neccessary to "drop" that duplicate metadata, how can I
>> arrange this afterwards. And if it is done, then I would have reduced
>> the Metadata size, but will there really be more space for Data? Where
>> is the remaining space from 77 GB to 130 GB?
>
> 53 * 2 + 24 = 130. The size of Metadata reported by "btrfs filesystem df"
> is 53GB, however it occupies 53 * 2 = 106GB on 'disk' physically.
> So yes, there will be more space for Data.
>

Perfect, great. This sounds strange on the first sight because it does
not show anywhere that one has to double the metadata. Or better: that
it is currently doubled.
So I know what I have to do now. I will drop the partition and create it again.
There is then still the problem that I have twice the size of metadata
than real data. But I guess that is due to the high number of very
small files (current estimate is 1440*50000 files with around 200Bytes
to 2000Bytes). On the other hand there is only twice the size reserved
and actually used a bit more that the real data.

Many thanks for make that clear to me.

Marcel
