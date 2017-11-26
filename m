Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:39307 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752064AbdKZJFF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Nov 2017 04:05:05 -0500
Received: by mail-ua0-f181.google.com with SMTP id 31so11983771uaj.6
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Nov 2017 01:05:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171114194426.07ac4e85@natsu>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
 <20171114174856.12ae346f@natsu> <CAFTHvW9=ojuQW0GWRLdy2g4j7DSzT13-=ODrjhjWAq3YMEiszg@mail.gmail.com>
 <20171114194426.07ac4e85@natsu>
From: Klaus Agnoletti <klaus@agnoletti.dk>
Date: Sun, 26 Nov 2017 10:04:44 +0100
Message-ID: <CAFTHvW8yVJTKJhurM5XCX9wJvuWpMbXOspOJ5iowkf-nmMsTAg@mail.gmail.com>
Subject: Re: A partially failing disk in raid0 needs replacement
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi List

I tried removing the disk roughly like Roman suggested; I copied data
using ddrescue from /dev/sdd to new disk /dev/sda. That seemed to work
fine. After that I physically removed the old /dev/sdd and put the new
/dev/sda to replace it on the same controller.

After that I tried removing /dev/sdd from the btrfs. And I still get an error:

klaus@box:~$ sudo btrfs device delete /dev/sdd /mnt
[sudo] password for klaus:
ERROR: error removing the device '/dev/sdd' - Input/output error

I tried scrubbing, but that failed, too:

scrub status for 5db5f82c-2571-4e62-a6da-50da0867888a
        scrub started at Sun Nov 26 01:27:58 2017 and finished after
21361 seconds
        total bytes scrubbed: 5.23TiB with 1 errors
        error details: csum=1
        corrected errors: 0, uncorrectable errors: 1, unverified errors: 0

The biggest difference now is that I don't get emails from smartd with
sector errors, so I am guessing this is 'just' a logical error.

I've hesitated doing any repairing on the filesystem in fear of
messing things up.

What do you guys think I should do to fix the I/O error?

Thanks,

/klaus

On Tue, Nov 14, 2017 at 3:44 PM, Roman Mamedov <rm@romanrm.net> wrote:
> On Tue, 14 Nov 2017 15:09:52 +0100
> Klaus Agnoletti <klaus@agnoletti.dk> wrote:
>
>> Hi Roman
>>
>> I almost understand :-) - however, I need a bit more information:
>>
>> How do I copy the image file to the 6TB without screwing the existing
>> btrfs up when the fs is not mounted? Should I remove it from the raid
>> again?
>
> Oh, you already added it to your FS, that's so unfortunate. For my scenario I
> assumed have a spare 6TB (or any 2TB+) disk you can use as temporary space.
>
> You could try removing it, but with one of the existing member drives
> malfunctioning, I wonder if trying any operation on that FS will cause further
> damage. For example if you remove the 6TB one, how do you prevent Btrfs from
> using the bad 2TB drive as destination to relocate data from the 6TB drive. Or
> use it for one of the metadata mirrors, which will fail to write properly,
> leading into transid failures later, etc.
>
> --
> With respect,
> Roman



-- 
Klaus Agnoletti
