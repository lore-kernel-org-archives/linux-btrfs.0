Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:46444 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdK3GDF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 01:03:05 -0500
Received: by mail-ot0-f182.google.com with SMTP id j2so5193911ota.13
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 22:03:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFTHvW_UHvPtKYvrWRqHqW3O8R4pEZeQBd5nTv=5+KqRK0RfPg@mail.gmail.com>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
 <CAFTHvW-WJgzC6theZ3Hrrc5Xf4eXFNQ8c=5Y+KmciAvK7bSexA@mail.gmail.com>
 <CAJCQCtQGzrXbsVy6GJHwO0MSL7xxix9fVL6UKAsqd+7hHcrx4Q@mail.gmail.com> <CAFTHvW_UHvPtKYvrWRqHqW3O8R4pEZeQBd5nTv=5+KqRK0RfPg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 29 Nov 2017 23:03:04 -0700
Message-ID: <CAJCQCtQm8yMh=__pyZWarvzD7RnPh6HPQS3xsSCmiNjYVZdg8Q@mail.gmail.com>
Subject: Re: A partially failing disk in raid0 needs replacement
To: Klaus Agnoletti <klaus@agnoletti.dk>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 10:28 PM, Klaus Agnoletti <klaus@agnoletti.dk> wrote:
> Hi Chris,
>
>>
>> I assume when you get that, either when deleting the device or
>> scrubbing, that you also see the device unrecoverable read error in
>> dmesg, as originally reported. If the drive must have the information
>> on that lost sector, and you can't increase SCT ERC time (as well as
>> the kernel SCSI command timer), or increasing it doesn't help, then
>> that data is lost. It's plausible btrfs check repair is smart enough
>> to be able to reconstruct this missing data, but I suspect it isn't
>> yet that capable.
>
> That's the 'fun' part: I don't get any kernel messages after changing
> the disk, hence my assumption that it's a relatively small, logical
> error somewhere on the fs.

I don't see how you get an IO error in user space without the kernel
reporting the source of that IO error, whatever it is.


>
>>
>> So my recommendation is to prepare to lose the file system. Which
>> means backing up whatever you can while it's still working, such as it
>> is.
>
> Yeah, luckily I can temporarily borrow a couple of 3TB disks to host
> the data while I rebuild the fs. So that will probably be what I do.
>
> It there any way I can remove just files with bad data from the disk
> error so I just get those out of the way?

If Btrfs detects corruption of data extents, it will tell you the
exact path to file names affected, as kernel messages. If you aren't
getting that, then it's some other problem.



-- 
Chris Murphy
