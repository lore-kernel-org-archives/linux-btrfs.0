From: Mark Rada <marada@uwaterloo.ca>
Subject: Re: Balance taking a lot longer than before
Date: Thu, 18 Mar 2010 23:28:52 -0400
Message-ID: <E9D4D14F-3CAA-487B-8651-97C43CF418B6@mailservices.uwaterloo.ca>
References: <77201DCC-CC67-4B00-8FFE-AAB17A5D18DA@mailservices.uwaterloo.ca> <3d0408631003182019i1509d363j98f94661679ea30b@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=windows-1252
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408631003182019i1509d363j98f94661679ea30b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hmm, there seems to be a very very long list of "btrfs: found 1 extents=
" messages and nothing else in between them.

Why would deleting large files help? I don't want to delete files on my=
 server unless I have no other option.

=97
Mark Rada
marada@uwaterloo.ca


On 2010-03-18, at 11:19 PM, Yan, Zheng wrote:

> On Fri, Mar 19, 2010 at 9:44 AM, Mark Rada <marada@uwaterloo.ca> wrot=
e:
>> Hi devs,
>>=20
>> I've been using btrfs on my file server since 2.6.32 and after upgra=
ding to .33 I noticed that rebalancing took way longer than before.
>>=20
>> I have a 5 disk array used for a btrfs md setup, different hard driv=
e sizes, brands, and interfaces.
>>=20
>> The last time I rebalanced I was using about 800GB of space on the 4=
=2E6TB array, and I started before I went to sleep and it was done when=
 I woke up.
>>=20
>> I'm in the middle of a rebalance right now, currently using 950GB, a=
nd it has been a full day and the rebalancing is not done yet. Is this =
an expected change? Is there any way to tell how much longer it will ta=
ke? Do you need to know more info about the setup?
>>=20
>=20
> I guess it enters infinite loops. you can check it by checking if
> there are a lots of
> repeats messages in the kernel log.  If it is true, you can try
> deleting some large
> files in that FS.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
