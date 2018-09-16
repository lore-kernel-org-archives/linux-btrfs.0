Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41187 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbeIQCSh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 22:18:37 -0400
Received: by mail-lj1-f194.google.com with SMTP id y17-v6so11449057ljy.8
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Sep 2018 13:54:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMrg+aS4anZaXHmVZchESbmNAZ0QYzE98LGD0nWc1JV1h8jfng@mail.gmail.com>
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
 <cbb66b3b-1b21-cb3c-c446-c44e861f36bc@gmx.com> <CAMrg+aTNK1cBG7rGVfudpydD6hMJz9UW0-3mdS8Yx4tqAQZE6Q@mail.gmail.com>
 <CAMrg+aS4anZaXHmVZchESbmNAZ0QYzE98LGD0nWc1JV1h8jfng@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 16 Sep 2018 14:54:20 -0600
Message-ID: <CAJCQCtT0CicLZ=y1YpRGOQdbMKc0Zrmc=O8HD1BGHEivLuR94Q@mail.gmail.com>
Subject: Re: btrfs problems
To: Adrian Bastholm <adrian@javaguru.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 16, 2018 at 2:11 PM, Adrian Bastholm <adrian@javaguru.org> wrote:
> Thanks for answering Qu.
>
>> At this timing, your fs is already corrupted.
>> I'm not sure about the reason, it can be a failed CoW combined with
>> powerloss, or corrupted free space cache, or some old kernel bugs.
>>
>> Anyway, the metadata itself is already corrupted, and I believe it
>> happens even before you noticed.
>  I suspected it had to be like that
>>
>> > BTRFS check --repair is not recommended, it
>> > crashes , doesn't fix all problems, and I later found out that my
>> > lost+found dir had about 39G of lost files and dirs.
>>
>> lost+found is completely created by btrfs check --repair.
>>
>> > I spent about two days trying to fix everything, removing a disk,
>> > adding it again, checking , you name it. I ended up removing one disk,
>> > reformatting it, and moving the data there.
>>
>> Well, I would recommend to submit such problem to the mail list *BEFORE*
>> doing any write operation to the fs (including btrfs check --repair).
>> As it would help us to analyse the failure pattern to further enhance btrfs.
>
> IMHO that's a, how should I put it, a design flaw, the wrong way of
> looking at how people think, with all respect to all the very smart
> people that put in countless hours of hard work. Users expect and fs
> check and repair to repair, not to break stuff.
> Reading that --repair is "destructive" is contradictory even to me.

It's contradictory to everyone including the developers. No developer
set out to make --repair dangerous from the outset. It just turns out
that it was a harder problem to solve and the thought was that it
would keep getting better.

Newer versions are "should be safe" now even if they can't fix
everything. The far bigger issue I think the developers are aware of
is that depending on repair at all for any Btrfs of appreciable size,
is simply not scalable. Taking a day or a week to run a repair on a
large file system, is unworkable. And that's why it's better to avoid
inconsistencies in the first place which is what Btrfs is supposed to
do, and if that's not happening it's a bug somewhere in Btrfs and also
sometimes in the hardware.


> This problem emerged in a direcory where motion (the camera software)
> was saving pictures. Either killing the process or a powerloss could
> have left these jpg files (or fs metadata) in a bad state. Maybe
> that's something to go on. I was thinking that there's not much anyone
> can do without root access to my box anyway, and I'm not sure I was
> prepared to give that to anyone.

I can't recommend raid56 for people new to Btrfs. It really takes
qualified hardware to make sure there's no betrayal, as everything
gets a lot more complicated with raid56. The general state of faulty
device handling on Btrfs, makes raid56 very much a hands on approach
you can't turn your back on it. And then when jumping into raid5, I
advise raid1 for metadata. It reduces problems. And that's true for
raid6 also, except that raid1 metadata is less redundancy than raid1
so...it's not helpful if you end up losing 2 devices.

If you need production grade parity raid you should use openzfs,
although I can't speak to how it behaves with respect to faulty
devices on Linux.




>> Any btrfs unexpected behavior, from strange ls output to aborted
>> transaction, please consult with the mail list first.
>> (Of course, with kernel version and btrfs-progs version, which is
>> missing in your console log though)
>
> Linux jenna 4.9.0-8-amd64 #1 SMP Debian 4.9.110-3+deb9u4 (2018-08-21)
> x86_64 GNU/Linux
> btrfs-progs is already the newest version (4.7.3-1).

Well the newest versions are kernel 4.18.8, and btrfs-progs 4.17.1, so
in Btrfs terms those are kinda old.

That is not inherently bad, but there are literally thousands of
additions and deletions since kernel 4.9 so there's almost no way
anyone on this list, except a developer familiar with backport status,
can tell you if the problem you're seeing is a bug that's been fixed
in that particular version. There aren't that many developers that
familiar with that status who also have time to read user reports.
Since this is an upstream list, most developers will want to know if
you're able to reproduce the problem with a mainline kernel, because
if you can it's very probable it's a bug that needs to be fixed
upstream first before it can be backported. That's just the nature of
kernel development generally. And you'll find the same thing on ext4
and XFS lists...

The main reason why people use Debian and its older kernel bases is
they're willing to accept certain bugginess in favor of stability.
Transient bugs are really bad in that world. Consistent bugs they just
find work arounds for (avoidance) until there's a known highly tested
backport, because they want "The Behavior" to be predictable, both
good and bad. That is not a model well suited for a file system that's
in Btrfs really active development state. It's better now than it was
even a couple years ago, where I'd say: just don't use RHEL or Debian
or anything with old kernels except for experimenting; it's not worth
the hassle; you're inevitably gonna have to use a newer kernel because
all the Btrfs devs are busy making metric shittonnes of fixes in the
mainline version. Today, it's not as bad as that. But still 4.9 is old
in Btrfs terms. Should it be stable? For *your* problem for sure
because that's just damn strange and something very goofy is going on.
But is it possible there's a whole series of bugs happening in
sequence that results in this kind of corruption? No idea. Maybe.

And that's the main reason why quite a lot of users on this list use
Fedora, Arch, Gentoo - so they're using the newest stable or even
mainline rc kernels.

And so if you want to run any file system, including Btrfs, in
production with older kernels,  you pick a distro that's doing that
work. And right now it's openSUSE and SUSE that have the most Btrfs
developers supporting 4.9 and 4.14 kernels and Btrfs. Most of those
users are getting distro support, I don't often see SUSE users on
here.

OpenZFS is a different strategy because they're using out of tree
code. So you can run older kernels, and compile the current openzfs
code base against your older kernel. In effect you're using an older
distro kernel, but with new file system code base supported by that
upstream.



-- 
Chris Murphy
