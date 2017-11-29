Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:45842 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752034AbdK2V6W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 16:58:22 -0500
Received: by mail-ot0-f175.google.com with SMTP id j64so4398487otj.12
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 13:58:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFTHvW-WJgzC6theZ3Hrrc5Xf4eXFNQ8c=5Y+KmciAvK7bSexA@mail.gmail.com>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
 <CAFTHvW-WJgzC6theZ3Hrrc5Xf4eXFNQ8c=5Y+KmciAvK7bSexA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 29 Nov 2017 14:58:20 -0700
Message-ID: <CAJCQCtQGzrXbsVy6GJHwO0MSL7xxix9fVL6UKAsqd+7hHcrx4Q@mail.gmail.com>
Subject: Re: A partially failing disk in raid0 needs replacement
To: Klaus Agnoletti <klaus@agnoletti.dk>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 6:33 AM, Klaus Agnoletti <klaus@agnoletti.dk> wrote:
> Hi list
>
> Can anyone give me any hints here? If not, my plan right now is to
> start updating the server to latest debian stable (it's currently
> running Jessie), to get access to a newer btrfs driver and tools,
> hoping that decreases the risk of something screwing up, and then run
> btrfs check --repair on the unmounted fs and wish for the best.
>

New kernel and tools won't fix this:

ERROR: error removing the device '/dev/sdd' - Input/output error

I assume when you get that, either when deleting the device or
scrubbing, that you also see the device unrecoverable read error in
dmesg, as originally reported. If the drive must have the information
on that lost sector, and you can't increase SCT ERC time (as well as
the kernel SCSI command timer), or increasing it doesn't help, then
that data is lost. It's plausible btrfs check repair is smart enough
to be able to reconstruct this missing data, but I suspect it isn't
yet that capable.

So my recommendation is to prepare to lose the file system. Which
means backing up whatever you can while it's still working, such as it
is.



-- 
Chris Murphy
