Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f178.google.com ([209.85.208.178]:43100 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbeIQBiX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 21:38:23 -0400
Received: by mail-lj1-f178.google.com with SMTP id m84-v6so11397714lje.10
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Sep 2018 13:14:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
 <CAJCQCtRx7gL+EYKGa1GaM6Q8B=c_gcEixMrRYRb5FdbVDnxBJg@mail.gmail.com>
 <CAMrg+aQw-sjXpaff=cS6X2-CWDRfOy1f8orQsEsy48xrsuPe3g@mail.gmail.com> <CAJCQCtQPniv4eJSsbT24bma9Gv6_T44zoq9owSYmPNmKO7hXaA@mail.gmail.com>
In-Reply-To: <CAJCQCtQPniv4eJSsbT24bma9Gv6_T44zoq9owSYmPNmKO7hXaA@mail.gmail.com>
From: Adrian Bastholm <adrian@javaguru.org>
Date: Sun, 16 Sep 2018 22:13:38 +0200
Message-ID: <CAMrg+aQbotvSip_EXbBM8nB3zBULP_yJEXNNH_K6_1mt6SXnGA@mail.gmail.com>
Subject: Fwd: btrfs problems
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

...

And also raid56 is still considered experimental, and has various
problems if the hardware lies (like if some writes happen out of order
or faster on some devices than others,and it's much harder to repair
because the repair tools aren't raid56 feature complete).

https://btrfs.wiki.kernel.org/index.php/Status

I think it's less scary than "dangerous" or "unstable" but anyway,
there are known problems unique to raid56 that will need future
features to make it as reliable as single, raid1, raid10. And like any
parity raid it sucks performance wise for random writes, especially
when using hard drives.



On Sun, Sep 16, 2018 at 1:40 PM, Adrian Bastholm <adrian@javaguru.org> wrote:
> Hi Chris
>> There's almost no useful information provided for someone to even try
>> to reproduce your results, isolate cause and figure out the bugs.
> I realize that. That's why I wasn't really asking for help, I was
> merely giving some feedback.
>
>> No kernel version. No btrfs-progs version. No description of the
>> hardware and how it's laid out, and what mkfs and mount options are
>> being used. No one really has the time to speculate.
>
> I understand, and I apologize. I could have added more detail.
>
>>
>> >BTRFS check --repair is not recommended
>>
>> Right. So why did you run it anyway?
>
> Because "repair" implies it does something to help you. That's how
> most people's brains work. My fs is broken. I'll try "REPAIR"
>
>
>> man btrfs check:
>>
>> Warning
>>            Do not use --repair unless you are advised to do so by a
>> developer or an experienced user
>>
>>
>> It is always a legitimate complaint, despite this warning, if btrfs
>> check --repair makes things worse, because --repair shouldn't ever
>> make things worse.
>
> I don't think It made things worse. It's more like it didn't do
> anything. That's when I started trying to copy a new file to the file
> with the question mark attributes (lame, I know) to see what happens.
> The "corrupted" file suddenly had attributes, and so on.
> check --repair removed the extra files and left me at square one, so not worse.
>
>>But Btrfs repairs are complicated, and that's why
>> the warning is there. I suppose the devs could have made the flag
>> --riskyrepair but I doubt this would really slow users down that much.
>
> calling it --destructive or --deconstruct, or something even more
> scary would slow people down
>
>> A big part of --repair fixes weren't known to make things worse at the
>> time, and edge cases where it made things worse kept popping up, so
>> only in hindsight does it make sense --repair maybe could have been
>> called something different to catch the user's attention.
>
> Exactly. It's not too late to rename it. And maybe make it dump a
> filesystem report with everything a developer would need (within
> reason) to trace the error
>
>> But anyway, I see this same sort of thing on the linux-raid list all
>> the time. People run into trouble, and they press full forward making
>> all kinds of changes, each change increases the chance of data loss.
>> And then they come on the list with WTF messages. And it's always a
>> lesson in patience for the list regulars and developers... if only
>> you'd come to us with questions sooner.
>
> True. I found the list a bit late. I tried the IRC channel but I
> couldn' t post messages.
>
>> > Please have a look at the console logs.
>>
>> These aren't logs. It's a record of shell commands. Logs would include
>> kernel messages, ideally all of them. Why is device 3 missing?
>
> It was a RAID5 array of three drives. When doing btrfs check on two of
> the drives I got the drive x is missing. I figured that maybe it had
> to do something with which one was the "first" drive or something. The
> same way, btrfs-check crashed when I was running it against the drives
> where I got the "drive x missing" message
>
>
>> We have no idea. Most of Btrfs code is in the kernel, problems are reported by
>> the kernel. So we need kernel messages, user space messages aren't
>> enough.
>
>> Anyway, good luck with openzfs, cool project.
> Cool project, not so cool pitfalls. I might head back to BTRFS after
> all .. see the response to Qu.
>
> Thanks for answering, and sorry for the shortcomings of my feedback
> /A
>
>>
>> --
>> Chris Murphy
>
>
>
> --
> Vänliga hälsningar / Kind regards,
> Adrian Bastholm
>
> ``I would change the world, but they won't give me the sourcecode``



--
Chris Murphy


-- 
Vänliga hälsningar / Kind regards,
Adrian Bastholm

``I would change the world, but they won't give me the sourcecode``
