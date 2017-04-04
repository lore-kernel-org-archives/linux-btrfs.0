Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f170.google.com ([209.85.213.170]:36521 "EHLO
        mail-yb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752895AbdDDQwz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Apr 2017 12:52:55 -0400
Received: by mail-yb0-f170.google.com with SMTP id i124so55778370ybc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Apr 2017 09:52:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <36448783-672c-5e88-cdda-9a8679c4b4ad@render-wahnsinn.de>
References: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
 <c304c651-88fc-4699-3518-c4e83095d9c0@mendix.com> <98a478cf-20f9-981f-6da5-4186a10be303@render-wahnsinn.de>
 <7f94b6b9-f18d-14dd-4a20-1793ce08df8a@render-wahnsinn.de> <36448783-672c-5e88-cdda-9a8679c4b4ad@render-wahnsinn.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 4 Apr 2017 10:52:54 -0600
Message-ID: <CAJCQCtRHgQrpijWgNigYZJsM-UxSpVfs0DWk2rbwmdPCeB+Qug@mail.gmail.com>
Subject: Re: Need some help: "BTRFS critical (device sda): corrupt leaf, slot
 offset bad: block"
To: Robert Krig <robert.krig@render-wahnsinn.de>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 3, 2017 at 10:02 PM, Robert Krig
<robert.krig@render-wahnsinn.de> wrote:
>
>
> On 03.04.2017 16:25, Robert Krig wrote:
>>
>> I'm gonna run a extensive memory check once I get home, since you
>> mentioned corrupt memory might be an issue here.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> I ran a memtest over a couple of hours with no errors. Ram seems to be
> fine so far.

Inconclusive. A memtest can take days to expose a problem, and even
that's not conclusive. The list archive has some examples of where
memory testers gave RAM a pass, but doing things like compiling the
kernel would fail.


>
> I've looked at the link you provided. Frankly it looks very scary. (At
> least to me it does)
> But I've just thought of something else.
>
> My storage array is BTRFS Raid1 with 4x8TB Drives.
> Wouldn't it be possible to simply disconnect two of those drives, mount
> with -o degraded and still have access (even if read-only) to all my data?

man mkfs.btrfs

Btrfs raid1 supports only one device missing, no matter how many drives.

Mounting -o ro,degraded is probably permitted by the file system, but
chunks of the file system and certainly your data, will be missing. So
it's just a matter of time before copying data off will fail.

I suggest trying -o ro with all drives, not a degraded mount, and
copying data off. Any failures should be logged. Metadata errors are
logged without paths, whereas data corruption included path to the
affected file. This is easier than scraping the file system with btrfs
restore.

If you can't mount ro with all drives, or ro,degraded with just one
device missing, you'll need to use btrfs restore which is more
tolerant of missing metadata.


-- 
Chris Murphy
