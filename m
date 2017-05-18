Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35224 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754073AbdERCJk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 22:09:40 -0400
Received: by mail-qk0-f194.google.com with SMTP id k74so4221829qke.2
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 19:09:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170517101523.ylmw4qo2wjsnibfh@angband.pl>
References: <CA+M=Xp3+YQkeVNLkSZw77zMdia2LwSiaEaR=6Ejs0z2TvW2xwg@mail.gmail.com>
 <pan$3156f$ad60295$88e5604$e6cc7e68@cox.net> <20170517101523.ylmw4qo2wjsnibfh@angband.pl>
From: =?UTF-8?Q?=C5=81ukasz_Wr=C3=B3blewski?= <lw@nri.pl>
Date: Thu, 18 May 2017 04:09:38 +0200
Message-ID: <CA+M=Xp0o6uz6uBv41ygpFBiWyw1x6ucg38BtG3V-XdOJ9azvxA@mail.gmail.com>
Subject: Re: RAID 6 corrupted
To: Adam Borowski <kilobyte@angband.pl>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks guys.

I will try when stable 4.12 comes out.
Unfortunately I do not have a backup.
Fortunately, these data are not so critical.
Some private photos and videos of youth.
However, I would be very happy if I could get it back.

Theoretically, if the devid 4 drive returned to
50127310-d15c-49ca-8cdd-8798ea0fda2e. In the absence of a single disk
recovery should be easy.

Can I change the uuid of the group to which the disk belongs, to not
format the data of course?




2017-05-17 12:15 GMT+02:00 Adam Borowski <kilobyte@angband.pl>:
> On Wed, May 17, 2017 at 09:52:28AM +0000, Duncan wrote:
>> Łukasz Wróblewski posted on Wed, 17 May 2017 10:27:53 +0200 as excerpted:
>> > About two years ago I created RAID 6 consisting of 5 disks with BTRFS.
>> > One of the disks has crashed.
>> > I started to exchange it for another, but I did something wrong.
>> > Or at the time, RAID56 support was experimental in BTRFS.
>
>> > Linux localhost 4.10.12-coreos
>>
>> For anything raid56 related, you'll need at /least/ 4.11, as it has some
>> major raid56 stability patch updates.
>
> Uhm, am I missing something?
>     git shortlog v4.10..v4.11 -- fs/btrfs/
> shows nothing related to RAID5/6 (save for a single commit that removes an
> unused variable).
>
>> There's still some issues with raid56, the biggest being that unlike most
>> of btrfs, the parity isn't COW, meaning the traditional parity-raid write
>> hole remains as an issue, a BIG issue for btrfs due to its design, but
>> that's not really fixable without a full raid56 rewrite, so it'll remain
>> the case with the existing raid56 mode likely forever, and a new
>> implementation that COWs parity as well may eventually happen.
>
> Ideas like plug extents (real or virtual) would fix this without a format
> change.  In fact, I don't see how a format change would help: there's no way
> around having every stripe belong to exactly 0 or 1 transactions, as
> otherwise it's RMW rather than COW.  That'd require some auto reclaim, but
> reclaim in general sounds like a thing we want, with recent research knorrie
> did about SSD.
>
> Well, there's RAIDz, but that's no RAID5 but a hybrid between that and
> RAID1, and it doesn't play well with btrfs' concept of block groups.
>
>> But the patches that went into 4.11 fix the known existing issues other
>> than the usual write hole, and they're effectively mandatory for any
>> attempt at repair or recovery of existing raid56 once there are issues of
>> any sort.  They're not a guarantee of a fix, but before that, any attempt
>> at a fix has a rather good chance of making the problem worse instead of
>> better, so you really do want 4.11 if you're doing btrfs raid56 at all.
>
> If you mean 4.12-rc1, then yeah, these patches are a big step forward.
>
>
> Meow!
> --
> Don't be racist.  White, amber or black, all beers should be judged based
> solely on their merits.  Heck, even if occasionally a cider applies for a
> beer's job, why not?
> On the other hand, corpo lager is not a race.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
