Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33924 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754409AbcH2Srd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 14:47:33 -0400
Received: by mail-lf0-f52.google.com with SMTP id l89so107367644lfi.1
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 11:47:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160829170220.GY16983@twin.jikos.cz>
References: <CAJF-kYko=dSuCmxpj6uJmKRZtAOhYCzoK=8hoyqBAe5UA8nQUg@mail.gmail.com>
 <20160829170220.GY16983@twin.jikos.cz>
From: Lukas Lueg <lukas.lueg@gmail.com>
Date: Mon, 29 Aug 2016 20:47:10 +0200
Message-ID: <CAJF-kYkQv11XCzcMfP02yw2AnO4LssbVDLuTqzZqB9ddeCCaow@mail.gmail.com>
Subject: Re: Multiple bugs found by fuzzing BTRFS
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'll report new issues to bz as they turn up from the current round
only if they represent a yet unreported kind of problem (e.g. there
are stack-based buffer over- and underruns lurking, I lost them due to
a bug in my setup, though). The next round will be much faster as I've
now vastly improved my automatic bug triage and fuzzing speed.

I lost interest once after bugs went unanswered - there are bugs still
open and unanswered from 2015/04. I hope this won't be a problem this
time.

2016-08-29 19:02 GMT+02:00 David Sterba <dsterba@suse.cz>:
> Hi,
>
> thanks for the testing and reports.
>
> On Mon, Aug 29, 2016 at 08:06:24AM +0200, Lukas Lueg wrote:
>> I've now spent around 160 hours of fuzzing BTRFS, here are the crashes
>> I found so far. Every type of crash is reported only once although
>> there are usually multiple locations where they show up (especially
>> heap-use-after-free and calls to abort()).
>>
>> The following bug reports have attached to them images of ą18kb which
>> expand to 16mb and reproduce a crash when running btrfsck; they all
>> have been revirginized so CRC- and FSID-checks pass by a vanilla
>> btrfsck.
>>
>>
>> Use-after-free, shows up all over the place:
>> https://bugzilla.kernel.org/show_bug.cgi?id=153641
>>
>> Segfault in memcpy, yeah: https://bugzilla.kernel.org/show_bug.cgi?id=154021
>>
>> Run-off-the-mill buffer-overflow:
>> https://bugzilla.kernel.org/show_bug.cgi?id=154961
>>
>> Endless loop in btrfsck: https://bugzilla.kernel.org/show_bug.cgi?id=155151
>>
>> Calls to abort() by lack of error paths:
>> https://bugzilla.kernel.org/show_bug.cgi?id=155181
>>
>> Division by zero, the old problem of computing stripe_size:
>> https://bugzilla.kernel.org/show_bug.cgi?id=155201
>>
>>
>> There are many more crashes like the above; how do you guys want them
>> to be reported?
>
> It's good to have them tracked in bugzilla, I'm CCed on all new
> bugreports so I'll know about them and you don't need to post them to
> the mailinglist. It'd be great to send a summary mail to the mailinglist
> when you do the testing round.
>
> Please give us some time to fix the issues before the next round, to
> avoid reporting potentially fixed issues.
