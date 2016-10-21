Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:35440 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934311AbcJUPSk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 11:18:40 -0400
Received: by mail-yw0-f182.google.com with SMTP id t193so99380417ywc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Oct 2016 08:18:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMXnza2VriNZqRnRFttPbWHcDups95G6NV8E0LuUZ9PoaT4y7Q@mail.gmail.com>
References: <CAMXnza15-UMtSugAzX_dYtLx1Rgi+OvASngQnqqTzW86tgDW8A@mail.gmail.com>
 <CAJCQCtSLZibHtOA8e8qVYwmgoh-m7eUgR5BBft4dDrc6rT=Tjw@mail.gmail.com> <CAMXnza2VriNZqRnRFttPbWHcDups95G6NV8E0LuUZ9PoaT4y7Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 21 Oct 2016 09:18:38 -0600
Message-ID: <CAJCQCtRY2kwBLArz1so8EusGE8OKdWcexT-oC++rHLxPj2-YNA@mail.gmail.com>
Subject: Re: Help repairing a partition
To: Suvayu Ali <fatkasuvayu+linux@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 21, 2016 at 12:36 AM, Suvayu Ali
<fatkasuvayu+linux@gmail.com> wrote:

> I had upgraded to 4.7.3 to test this issue:
>
>   https://bugzilla.redhat.com/show_bug.cgi?id=1372910
>
> It hadn't helped, but I didn't have time to debug it any further.
> Since the Fedora 23 repos have 4.4.1, I guess downgrading is easier
> for me.

Better is to go to http://koji.fedoraproject.org/ and type in
btrfs-progs for the package, and find the most recent x.y-1.z version
- right now that's 4.7.3, although 4.8.1 is probably OK also - it has
no new features, mainly just a pile of bug fixes, which might be
useful. So that'd be either:
btrfs-progs-4.8.1-2.fc26
or
btrfs-progs-4.7.3-1.fc26

And rpmbuild --rebuild them for F23 and then install. I would not
downgrade to 4.4.1 - it's not that it's bad, it's just a waste of time
if it can't help fix the problem which is very likely the older progs
you have.


>
> Thanks for the pointer to the changelog; under 4.7.2 it mentions not
> to repair with 4.7.1, so I'll try `btrfs check --repair` after the
> downgrade.

No. The older the progs the less safe the repair is. And this
particular problem you have probably needs a newer progs to fix it
anyway. So you need to go newer not older. That's pretty much always
the case with Btrfs.


>
>>> followed by this summary:
>>>
>>> checking csums
>>> checking root refs
>>> checking quota groups
>>> Counts for qgroup id: 0/257 are different
>>> our:            referenced 7746465792 referenced compressed 7746465792
>>> disk:           referenced 7746461696 referenced compressed 7746461696
>>> diff:           referenced 4096 referenced compressed 4096
>>> our:            exclusive 7746465792 exclusive compressed 7746465792
>>> disk:           exclusive 7746461696 exclusive compressed 7746461696
>>> diff:           exclusive 4096 exclusive compressed 4096
>>> Counts for qgroup id: 0/259 are different
>>> our:            referenced 135641784320 referenced compressed 135641784320
>>> disk:           referenced 135633862656 referenced compressed 135633862656
>>> diff:           referenced 7921664 referenced compressed 7921664
>>> our:            exclusive 135641784320 exclusive compressed 135641784320
>>> disk:           exclusive 135633862656 exclusive compressed 135633862656
>>> diff:           exclusive 7921664 exclusive compressed 7921664
>>> found 167864082432 bytes used err is 0
>>> total csum bytes: 161187492
>>> total tree bytes: 2021015552
>>> total fs tree bytes: 1725759488
>>> total extent tree bytes: 86228992
>>> btree space waste bytes: 386160897
>>> file data blocks allocated: 1269363683328
>>>  referenced 164438126592
>>>
>>> How do I repair this?
>>
>> Yeah good question. I can't tell from the message whether different
>> counts is a bad thing, or if it's just a notification, or what. Yet
>> again btrfs-progs does not help the user make informed decisions, it's
>> really frustrating. I think that part can be ignored though for now,
>> and see if btrfs check --repair can fix the problem now that you have
>> a backup.
>
> Indeed, I have never been this confused about a file system before.
>
> I tried repairing after the downgrade to 4.4.1, it says "Couldn't open
> file system"!  Mounting now works without errors, I can also r/w files
> as normal; go figure!

Oh shit. That's hilarious. I'm not even going to edit what I wrote above.

Anyway, it looks like you have quotas enabled. There are a number of
quota related bug fixes in progs newer than 4.4, so you really ought
to use something newer, and if it breaks then it's a bug and needs a
good bug report write up so it can get fixed.

In the meantime I would be wary with this file system if it's the only
backup copy. (Actually I feel that way no matter the file system.) I'd
make sure btrfs check with progs 4.7.3 or 4.8.1 come up clean (i.e.
err is 0 is generally a good sign), and that a scrub also comes up
clean with no errors: either 'btrfs scrub start <mp>' and then later
check with 'btrfs scrub status' or use -BR flag to not background and
show stats after completion.



-- 
Chris Murphy
