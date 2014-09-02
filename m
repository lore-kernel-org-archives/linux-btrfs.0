Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53809 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaIBT4U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 15:56:20 -0400
Received: by mail-lb0-f173.google.com with SMTP id c11so8221608lbj.4
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 12:56:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$1b676$93919c37$3c0fae08$71129a93@cox.net>
References: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com>
	<540498AF.6030109@fb.com>
	<CANg_oxwNkjZf1gVfOJE72fUyqJvMpF+hQdN-V0_cPAJ9nxPsjQ@mail.gmail.com>
	<pan$efe46$daffbd12$cb4477b6$9a3e7f57@cox.net>
	<CANg_oxz9NGNVnY3rjeYPXqqi0PtcxZkMVyD5marfmXfvCp7VPw@mail.gmail.com>
	<pan$1b676$93919c37$3c0fae08$71129a93@cox.net>
Date: Tue, 2 Sep 2014 21:56:19 +0200
Message-ID: <CANg_oxxiAJbchugA2puD7PE3qgd_iQ+Lwpzs416YPBUBCKVOag@mail.gmail.com>
Subject: Re: kernel 3.17-rc3: task rsync:2524 blocked for more than 120 seconds
From: john terragon <jterragon@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nice...now I get the hung task even with 3.14.17.... And I tried with
4K for node and leaf size...same result. And to top it all off, today
I've been bitten by the bug also on my main root fs (which is on two
fast ssd), although with 3.16.1.

Is it at least safe for the data? I mean, as long as the hung process
terminates and no other error shows up, can I at least be sure that
the data written is correct?

Thanks
John


On Tue, Sep 2, 2014 at 8:40 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> john terragon posted on Tue, 02 Sep 2014 08:12:36 +0200 as excerpted:
>
>> I will definitely try the latest 3.14.x (never had any problem of this
>> kind with it). And I'll look into the other possibilities you pointed
>> out. However what I can tell you right now is this:
>>
>> -the filesystem was "new". I've been bitten by this bug with 3.15 and
>> 3.16 and I kept
>>  trying to do the same thing (create the fs, rsync or cp the same
>> stuff) to see if it
>>  got better.
>
> OK.  I had read your post as implying that the filesystem had been around
> since before 3.14, in which case the firmware shuffling could well have
> been a factor.  If it was a brand new filesystem, then likely not, as
> mkfs.btrfs tries to do a trim of the whole filesystem range before it
> sets up.
>
> But that does remind me of one other possibility I had thought to mention
> and then forgot... that's even more likely now that it's known to be a
> new filesystem...
>
> I don't recall the btrfs-progs version, but somewhere along the line one
> other thing of potential interest changed:
>
> Mkfs.btrfs used to default to 4 KiB node/leaf sizes; now days it defaults
> to 16 KiB as that's far better for most usage.  I wonder if USB sticks
> are an exception...
>
> Since this is set at mkfs time, trying a 3.14 series kernel with current
> mkfs.btrfs defaults shouldn't change things; if the 16 KiB nodesize is
> why it's slow, it should still be slow with the 3.14 series kernel.
>
> Conversely, if this is the problem, specifically creating the filesystem
> with --nodeside 4k should fix it, and it should stay fixed regardless of
> what kernel you use with it, 3.14, 3.16, 3.17-rcX, shouldn't matter.
>
> And that'd be a very useful thing to put on the wiki as well, should it
> be found to be the case.  So please test and post if it helps (and feel
> free to put it on the wiki too if it works)!  =:^)
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
