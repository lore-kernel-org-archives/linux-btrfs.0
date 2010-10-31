From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: Horrible btrfs performance due to fragmentation
Date: Mon, 1 Nov 2010 00:36:58 +0200
Message-ID: <AANLkTimgCU1tM9VJv8RJ-dim+bRsT7cbZ9ZidbT5sco-@mail.gmail.com>
References: <AANLkTinWT9OyicLfdeY+AvWs=5vb5z8skZ3t6keYjk9j@mail.gmail.com>
	<AANLkTikNywvthaU-+s5HXvh3RX=HxiFWmADW--Ln_Gga@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Calvin Walton <calvin.walton@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikNywvthaU-+s5HXvh3RX=HxiFWmADW--Ln_Gga@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 1, 2010 at 12:25 AM, cwillu <cwillu@cwillu.com> wrote:
> On Sun, Oct 31, 2010 at 1:58 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> On Mon, Oct 11, 2010 at 6:46 PM, Calvin Walton <calvin.walton@gmail.=
com> wrote:
>>> On Mon, 2010-10-11 at 03:30 +0300, Felipe Contreras wrote:
>>>> I use btrfs on most of my volumes on my laptop, and I've always fe=
lt
>>>> booting was very slow, but definitely sure is slow, is starting up
>>>> Google Chrome:
>>>>
>>>> encrypted ext4: ~20s
>>>> btrfs: ~2:11s
>>>>
>>>> I have tried different things to find out exactly what is the issu=
e,
>>>> but haven't quite found it yet.
>>>
>>> If you've been using this volume for a while, it could just have be=
come
>>> badly fragmented. You could try btrfs's fancy online defragmentatio=
n
>>> abilities to see if that'll give you an improvement:
>>>
>>> # btrfs filesystem defragment /mountpoint/of/volume
>>>
>>> Let us know if that helps, of course :)
>>
>> I finally managed to track down this issue. Indeed the fragmentation
>> is horrible, and 'btrfs filesystem defragment' doesn't help:
>>
>> % cat History-old > History
>> % btrfs filesystem defragment /home
>> % echo 3 > /proc/sys/vm/drop_caches
>>
>> % time dd if=3DHistory of=3D/dev/null && time dd if=3DHistory-old of=
=3D/dev/null
>> 109664+0 records in
>> 109664+0 records out
>> 56147968 bytes (56 MB) copied, 1.90015 s, 29.5 MB/s
>> dd if=3DHistory of=3D/dev/null =C2=A00.08s user 0.29s system 15% cpu=
 2.458 total
>> 109664+0 records in
>> 109664+0 records out
>> 56147968 bytes (56 MB) copied, 97.772 s, 574 kB/s
>> dd if=3DHistory-old of=3D/dev/null =C2=A00.07s user 0.80s system 0% =
cpu 1:37.79 total
>>
>> I think this is a serious issue that *must* be fixed for 1.0. I file=
d
>> a bug for this:
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D21562
>
> btrfs fi defrag isn't recursive. =C2=A0"btrfs filesystem defrag /home=
" will
> defragment the space used to store the folder, without touching the
> space used to store files in that folder.

Yes, that came up on the IRC, but:

1) It doesn't make sense: "btrfs filesystem" doesn't allow a fileystem
as argument? Why would anyone want it to be _non_ recursive?

2) The filesystem should not degrade performance so horribly no matter
how long the it has been used. Even git has automatic garbage
collection.

--=20
=46elipe Contreras
