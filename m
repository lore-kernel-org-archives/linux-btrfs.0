Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:47314 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752887AbdKNPoC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 10:44:02 -0500
Received: by mail-vk0-f45.google.com with SMTP id 22so8821063vkq.4
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 07:44:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171114194426.07ac4e85@natsu>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
 <20171114174856.12ae346f@natsu> <CAFTHvW9=ojuQW0GWRLdy2g4j7DSzT13-=ODrjhjWAq3YMEiszg@mail.gmail.com>
 <20171114194426.07ac4e85@natsu>
From: Klaus Agnoletti <klaus@agnoletti.dk>
Date: Tue, 14 Nov 2017 17:43:41 +0200
Message-ID: <CAFTHvW_qb=BvLz+qV-3RLnVGoghfNfv99Urd2pauRm-Kh1YObw@mail.gmail.com>
Subject: Re: A partially failing disk in raid0 needs replacement
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Roman,

If you look at the 'show' command, the failing disk is sorta out of
the fs, so maybe removing the 6TB disk again will divide the data
already on the 6TB disk (which isn't more than 300something gigs) to
the 2 well-functioning disks.

Still, as putting the dd-image of the 2TB disk on the temporary disk
is only temporary, I do need one more 2TB+ disk attached to create a
more permanent btrfs with the 6TB disk (which is what I eventually
want). And for that I need some more harddisk power cables/splitters.
And another disk. But that still seems to be the best option, so I
will do that once I have those things sorted out.

Thanks for your creative suggestion :)

/klaus


On Tue, Nov 14, 2017 at 4:44 PM, Roman Mamedov <rm@romanrm.net> wrote:
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
