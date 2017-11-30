Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:36265 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750742AbdK3F2i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 00:28:38 -0500
Received: by mail-ua0-f169.google.com with SMTP id w47so4991654uah.3
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 21:28:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQGzrXbsVy6GJHwO0MSL7xxix9fVL6UKAsqd+7hHcrx4Q@mail.gmail.com>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
 <CAFTHvW-WJgzC6theZ3Hrrc5Xf4eXFNQ8c=5Y+KmciAvK7bSexA@mail.gmail.com> <CAJCQCtQGzrXbsVy6GJHwO0MSL7xxix9fVL6UKAsqd+7hHcrx4Q@mail.gmail.com>
From: Klaus Agnoletti <klaus@agnoletti.dk>
Date: Thu, 30 Nov 2017 06:28:17 +0100
Message-ID: <CAFTHvW_UHvPtKYvrWRqHqW3O8R4pEZeQBd5nTv=5+KqRK0RfPg@mail.gmail.com>
Subject: Re: A partially failing disk in raid0 needs replacement
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

>
> I assume when you get that, either when deleting the device or
> scrubbing, that you also see the device unrecoverable read error in
> dmesg, as originally reported. If the drive must have the information
> on that lost sector, and you can't increase SCT ERC time (as well as
> the kernel SCSI command timer), or increasing it doesn't help, then
> that data is lost. It's plausible btrfs check repair is smart enough
> to be able to reconstruct this missing data, but I suspect it isn't
> yet that capable.

That's the 'fun' part: I don't get any kernel messages after changing
the disk, hence my assumption that it's a relatively small, logical
error somewhere on the fs.

>
> So my recommendation is to prepare to lose the file system. Which
> means backing up whatever you can while it's still working, such as it
> is.

Yeah, luckily I can temporarily borrow a couple of 3TB disks to host
the data while I rebuild the fs. So that will probably be what I do.

It there any way I can remove just files with bad data from the disk
error so I just get those out of the way?

Thanks

/klaus
