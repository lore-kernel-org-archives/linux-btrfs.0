Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49544 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034Ab2IEB7z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2012 21:59:55 -0400
Received: by ieje11 with SMTP id e11so6626538iej.19
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2012 18:59:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5046452C.7090804@libero.it>
References: <CAGDaZ_oFzakgBC+NzK4X3J9yL0Q5YfZVKk671QKN0xHAMgPN7g@mail.gmail.com>
 <CAGDaZ_p2dXLr6rOZewXUEWYKV4b=dW9OZj4yXG4qPoUax2a8CA@mail.gmail.com>
 <CAGJTRciVqG=CqP4gR4gpz2bmFYORS6ExAT_nDbau2NuCJyipeg@mail.gmail.com>
 <CAGDaZ_qm+Z7ptRdp-kJx_AJgcJ+bjWX7OZ5O1ang7sbJ_Y_f-w@mail.gmail.com>
 <CAE5mzvgp1LAaYrMyjbAKZVRyKcaoWAZwQVBfGQQUZh+6+w9Rvw@mail.gmail.com>
 <CAGDaZ_pZvOTCtMkq8+w6wJKpSuBzpntbjTLKBHqGuzpycUndjw@mail.gmail.com>
 <CAGJTRcgXRRRoxycOwFurWjK2N6DXfC0v1ZhrMkSx+zi1NACM5w@mail.gmail.com>
 <CAGDaZ_qD-RHvZk31GYZRTAjUNJ4dTm1wXk1kQELE2p+=xG3yzA@mail.gmail.com> <5046452C.7090804@libero.it>
From: Shentino <shentino@gmail.com>
Date: Tue, 4 Sep 2012 18:59:13 -0700
Message-ID: <CAGDaZ_pCsS=kC-yn5UvtZO7U1V9RzFUcch5=N6XnRxXu2cQoZQ@mail.gmail.com>
Subject: Re: rfc: fuzz testing by direct writes to device
To: kreijack@inwind.it
Cc: Michael <mike@draftx.net>, cwillu <cwillu@cwillu.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 4, 2012 at 11:15 AM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> Hi,
>
>
> On 09/02/2012 03:03 AM, Shentino wrote:
>>
>> This whole subject was also about using sed to corrupt-o-magic a
>> file's data on disk.
>>
>> Is this an acceptable method for testing?
>
> I am not sure that doing "sed </dev/sdX >/dev/sdX ..." is the right thing to
> do, because it rewrites the full disk. This means that:
> - it takes a lot of time
> - you don't have any control about which part of the disk you change: what
> happens if sed write a block which is update in parallel by BTRFS ?

Which is one reason I used a sha1 hash of a random read as the search key :P

> Anyway I suggest to give a look to the following video [1], which explains
> the automatic repair. Moreover it shows [2] how corrupt a block with the
> "btrfs-corrupt-block" command.

That does sound more convenient.

> Hoping that this helps you.
>
> BR
> G.Baroncelli
>
> [1] http://www.youtube.com/watch?v=hxWuaozpe2I
> [2] See minute 17:52 of the video above
>
>>
>> On Sat, Sep 1, 2012 at 4:49 PM, Michael<mike@draftx.net>  wrote:
>>>
>>> It should not. It is always preferred that you dd your drive onto
>>> another disk just in case though.
>>>
>>> On Sat, Sep 1, 2012 at 5:31 PM, Shentino<shentino@gmail.com>  wrote:
>>>>
>>>> On Sat, Sep 1, 2012 at 1:59 PM, cwillu<cwillu@cwillu.com>  wrote:
>>>>>
>>>>> You still haven't said which kernel you were running; the thing to do
>>>>> is try the very latest rc (if not btrfs-next).
>>>>
>>>>
>>>> Sorry about that!
>>>>
>>>> I thought I included it.
>>>>
>>>> 3.3.8
>>>>
>>>> Hmm...seems it's been EOL'ed.  I need to yell at my distro.
>>>>
>>>> In the meantime, will mounting a btrfs filesystem with a new kernel
>>>> render it unmountable by older kernels?
>>
>> --
>>
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> .
>>
>
