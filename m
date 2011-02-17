From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: Re: Space used by snapshot
Date: Thu, 17 Feb 2011 13:38:58 +0100
Message-ID: <AANLkTinubrLWVau2PqD-3BJVceuQa3oR1N4RKBL8RvoL@mail.gmail.com>
References: <AANLkTi=LE2poDR5sNyPJF6rQ_TpLv5pjgHRQXG0Wpt-i@mail.gmail.com> <201102171254.37670.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201102171254.37670.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 17, 2011 at 12:54, Hubert Kario <hka@qbs.com.pl> wrote:
> On Thursday, February 17, 2011 12:13:53 Roman Kapusta wrote:
>> Hello all,
>>
>> Is there any way how to obtain information how much space is
>> physically allocated by given subvolume?
>> I cannot find any. I'm interested in two values:
>>
>> - physical space allocated by SUBVOLUME INCLUDING all space shared b=
y
>> other subvolumes
>
> That's the space reported by `du -hs /mnt/btrfs/subvolume`

it should be `du -hsx /mnt/btrfs/subvolume`
but what if there are reflinked/CoW files inside this subvolume?

>
>>
>> - physical space allocated by SUBVOLUME EXCLUDING all space shared b=
y
>> other subvolumes
>
> That's not implemented right now
>
>> Currently I can use only du, which is not reporting what I want to k=
now.
>>
>> Regards
>>
>> Roman Kapusta
>
> --
> Hubert Kario
> QBS - Quality Business Software
> 02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
> tel. +48 (22) 646-61-51, 646-74-24
> www.qbs.com.pl
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
