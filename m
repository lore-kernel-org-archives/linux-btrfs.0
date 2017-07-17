Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35407 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbdGQLFN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 07:05:13 -0400
Received: by mail-io0-f194.google.com with SMTP id 84so7202503iop.2
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Jul 2017 04:05:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170716160658.r4uxuqlfe24hgi5n@merlins.org>
References: <20170715004828.f4bom5wq34abe4lz@merlins.org> <20170715012216.njq6az3y34qyomtb@merlins.org>
 <20170715231245.GA28281@merlins.org> <3161165.SzVyadSXaH@exnet.gdb.it> <20170716160658.r4uxuqlfe24hgi5n@merlins.org>
From: gius db <giusdbg@gmail.com>
Date: Mon, 17 Jul 2017 13:05:12 +0200
Message-ID: <CAO6aweN16fR9xE955UwCy_nsWUOtYEy_nt=ujHEqwz-i+zrCXQ@mail.gmail.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-07-16 18:06 GMT+02:00 Marc MERLIN <marc@merlins.org>:
> On Sun, Jul 16, 2017 at 04:01:53PM +0200, Giuseppe Della Bianca wrote:
>> > On Fri, Jul 14, 2017 at 06:22:16PM -0700, Marc MERLIN wrote:
>> > > Dear Chris and other developers,
>> ]zac[
>> > Others on this thread with the same error: did anyone recover from this
>> > without wiping the filesystem?
>> >
>> > Is there a chance a balance might work around the bug so that whatever
>> > layout I have, changes, and stops the bug from occuring?
>> ]zac[
>>
>> Any attempt, even just delete files, has worsened the situation.
>> I advise not to waste time in repairs, and directly recreate the filesystem.
>
> I see. So, this is a condition where the filesystem is clear as far as:
> - check
> - check lowmem
> - scrub
> are all concerned (at least in my case), but it's in a state where
> touching something around a sensitive area causes the bug.
> If so, this blows, and I'm not really wanting to recreate a clean 12TB
> filesystem "just because", especially since this could just happen
> again after I've rebuilt it.
>

IMHO, rebuild from scratch, 1-2 times a year, the snapshot receive
filesystem is inevitable.

For this reason, my snapshot receive filesystems have only this
purpose and are not bigger than 1-2 TB.


>>  while read proc; do
>>        if [ $progResult == 0 ]; then
>>                echo -e \nbtrfs tools already running
>>
>>                progResult=222
>>        fi
>>
>>        echo $proc"
>>  done < <(ps -ef | grep -e "btrfs \{1,\}\(subvolume\|send\|receive\|delete\)")
>
> Yeah, I probably hit that. I think you can also add scrub to that list.
>

Yes.

I did not add scrubs because my scrub are always read-only.
And I think that race condition is between snapshot receive and
subvolume delete.

I also suggest:
- Use btrfs subvolume delete with -c
- Try to add a sleep after subvolume delete and receive.

> Marc


Gdb
