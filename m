Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:34084 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbbI2Oxq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 10:53:46 -0400
Received: by labzv5 with SMTP id zv5so11918509lab.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 07:53:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5wTC97f27WeQvznUXj75iKafRKXccw6VioVdrxWYTXEA@mail.gmail.com>
References: <CAGqmi76J4XWv+ureSG66Da_E-xq3MqGahbhsaTR6Sf2rSHd4Ug@mail.gmail.com>
 <CAGqmi769jyGg0+y_Du45d5cvCNOtZ+46oi5hDu9Y244b-q-UOA@mail.gmail.com> <CAL3q7H5wTC97f27WeQvznUXj75iKafRKXccw6VioVdrxWYTXEA@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 29 Sep 2015 17:53:05 +0300
Message-ID: <CAGqmi77=7-_4D6kNi3NZtfb_=Y5AC2KszGR8tsibr+7r4q=D5Q@mail.gmail.com>
Subject: Re: Btrfs duperemove corrupt data while dedup
To: fdmanana@gmail.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thx Filipe,
this is full fix my issue

2015-09-29 15:49 GMT+03:00 Filipe Manana <fdmanana@gmail.com>:
> On Tue, Sep 29, 2015 at 1:38 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
>> FYI:
>> Looks like patch:
>> Btrfs: fix read corruption of compressed and shared extents
>
> Try the second part (patch on top of that one) that fixes an
> additional corner case that I missed earlier:
>
> https://patchwork.kernel.org/patch/7275851/
>
> thanks
>
>>
>> Partial fixed my issue
>>
>> 2015-08-26 22:33 GMT+03:00 Timofey Titovets <nefelim4ag@gmail.com>:
>>> Hello guys,
>>> i like btrfs, and i want put it in production soon,
>>> one of the feature that i want use, is a deduplication.
>>>
>>> i frequently testing duperemove on btrfs and already see this problem before.
>>> i know what btrfs before, change mtime while deduping, but after dedup
>>> fixes from Mark (https://github.com/markfasheh), i've try to get
>>> checksums.
>>>
>>> As i know duperemove use kernel ioctl for deduping, i.e. it's not a
>>> duperemove issue, kernel must keep data consistent.
>>>
>>> File system is fresh and btrfs check not show any metadata corruption.
>>>
>>> Github issue:
>>> https://github.com/markfasheh/duperemove/issues/91
>>>
>>> System info:
>>> $ uname -a
>>> Linux titovetst-beplan 4.2.0-rc8-next-20150825-0959-ARCH #1 SMP Wed
>>> Aug 26 10:27:18 MSK 2015 x86_64 GNU/Linux
>>>
>>> Mount options:
>>> rw,relatime,compress=lzo,space_cache,subvolid=257,subvol=/@home
>>>
>>> Okay, how i find it:
>>>
>>> md5sum_recursive(){
>>>         find $@ -type f -exec md5sum {} \;
>>> }
>>>
>>> cp -av --reflink=always ~/<src> ~/<dest>
>>> md5sum_recursive ~/<dest> > ~/dedup.before
>>> duperemove -vhrdb 8k ~/<dest>
>>> md5sum_recursive ~/<dest> > ~/dedup.after
>>> diff -up ~/dedup.before ~/dedup.after
>>>
>>> what i've got (full diff in attach):
>>> --- /home/nefelim4ag/dedup.after        2015-08-26 21:36:55.773452558 +0300
>>> +++ /home/nefelim4ag/dedup.before       2015-08-26 21:21:01.203600761 +0300
>>> @@ -25139,9 +25139,9 @@ caf9d41036e46b85d90a9541e8bc9ce1  /home/
>>> ....
>>> -0ccbc9c81a51f59dcf2ac0d102de37cb
>>> /home/nefelim4ag/L4D2/left4dead2/pak01_003.vpk
>>> +e665b502ee977dc1c619ecbd415c91b8
>>> /home/nefelim4ag/L4D2/left4dead2/pak01_000.vpk
>>> ....
>>>
>>> Files sizes not changed and it's > 1MB.
>>>
>>> Every time i've get a random data corruption.
>>> Only dependencies what i've find it is what smallest block -> more
>>> corruptions and vise versa, i.e. more data deduped -> more corrupted.
>>>
>>> Smart of the disk, it's not looks, like damaged. (attach)
>>>
>>> What i can provide to help fix this issue?
>>> If it's needed, i can recompile kernel with some parameters if it can
>>> help, of course.
>>>
>>> Thanks.
>>>
>>> --
>>> Have a nice day,
>>> Timofey.
>>
>> --
>> Have a nice day,
>> Timofey.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."



-- 
Have a nice day,
Timofey.
