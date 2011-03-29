From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: New btrfsck status
Date: Tue, 29 Mar 2011 15:13:00 +0300
Message-ID: <4D91CCCC.10305@mandriva.org>
References: <AANLkTinu_29idVYvudG=E6VaxwqQoN2YEi57-RPk3dkF@mail.gmail.com> <1297340143-sup-3602@think>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297340143-sup-3602@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason skrev 10.2.2011 14:17:
> Excerpts from Ben Gamari's message of 2011-02-09 21:52:20 -0500:
>> Hey all,
>>
>> Over the last several months there have been many claims regarding the
>> release of the rewritten btrfsck. Unfortunately, despite numerous
>> claims that it will be released Real Soon Now(c), I have yet to see
>> even a repository with preliminary code. Did I miss an announcement?
>> There is something to be said for "release early, release often." Is
>> there a timeline for getting btrfsck into some sort of usable form?
>
> Yes, but its still real soon now.  I've been at about 90% done since
> Christmas.  It would have been out last week but I've been chasing a
> debugging a very difficult corruption under load.
>
> I finally found a race in btrfs causing the corruption and now I'm back
> on fsck full time again.
>

Any status updates on this ?

Checking:
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git;a=shortlog;h=refs/heads/next

I see last commit is 3+ months ago

--
Thomas
