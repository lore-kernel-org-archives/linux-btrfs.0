From: Jeff Putney <jeffrey.putney@gmail.com>
Subject: Re: New btrfsck status
Date: Tue, 7 Jun 2011 11:52:21 -0500
Message-ID: <BANLkTimzVU6_dqYOWVJ1sdio2akOKT3ghQ@mail.gmail.com>
References: <20110606164109.7b032c17@io.vpn.lugor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Christian Hesse <list@eworm.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110606164109.7b032c17@io.vpn.lugor.de>
List-ID: <linux-btrfs.vger.kernel.org>

Me too.  I've got a 9TB filesystem that I can't mount since rebooting
during a rebalance.  I want to get the fs as repaired as possible, but
I am not in a hurry, and I have enough space at present to make a
duplicate and play with test versions of the repair.

--jeff

On Mon, Jun 6, 2011 at 9:41 AM, Christian Hesse <list@eworm.de> wrote:
> Chris Mason on 10 Feb 13:17:
>> Excerpts from Ben Gamari's message of 2011-02-09 21:52:20 -0500:
>> > Over the last several months there have been many claims regarding
>> > the release of the rewritten btrfsck. Unfortunately, despite
>> > numerous claims that it will be released Real Soon Now(c), I have
>> > yet to see even a repository with preliminary code. Did I miss an
>> > announcement? There is something to be said for "release early,
>> > release often." Is there a timeline for getting btrfsck into some
>> > sort of usable form?
>>
>> Yes, but its still real soon now. =A0I've been at about 90% done sin=
ce
>> Christmas. =A0It would have been out last week but I've been chasing=
 a
>> debugging a very difficult corruption under load.
>>
>> I finally found a race in btrfs causing the corruption and now I'm
>> back on fsck full time again.
>
> This mail was about four month ago...
> Any news on this topic?
>
> I really would like to test btrfs on my desktop systems, but I still
> hesitate because of the missing fsck.
> --
> Schoene Gruesse
> Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
