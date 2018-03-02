Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:38272 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935711AbeCBQT4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Mar 2018 11:19:56 -0500
Received: by mail-it0-f46.google.com with SMTP id j7so2427205ita.3
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Mar 2018 08:19:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180302151805.GB5942@twin.jikos.cz>
References: <CAJVZm6etk=bL0LY3FZXkm5Wun64F4w6HMxdLhKRD-v+mEGm08w@mail.gmail.com>
 <CAJVZm6e0+urcBNrVkXSwvuckTt1A2R8uj536ZzHcB9eG9FoqpQ@mail.gmail.com> <20180302151805.GB5942@twin.jikos.cz>
From: Menion <menion@gmail.com>
Date: Fri, 2 Mar 2018 17:19:34 +0100
Message-ID: <CAJVZm6dQacWC0hVWoBxy2H3cSm78pCSqyJkD9Ch4AWLdUrwh9w@mail.gmail.com>
Subject: Re: dmesg flooded with "Very big device. Trying to use READ
 CAPACITY(16)" with 8TB HDDs
To: dsterba@suse.cz, Menion <menion@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks
My point was to understand if this action was taken by BTRFS or
automously by scsi.
>From your word it seems clear to me that this should go in
KERNEL_DEBUG level, instead of KERNEL_NOTICE
Bye

2018-03-02 16:18 GMT+01:00 David Sterba <dsterba@suse.cz>:
> On Fri, Mar 02, 2018 at 12:37:49PM +0100, Menion wrote:
>> Is it really a no problem? I mean, for some reason BTRFS is
>> continuously read the HDD capacity in an array, that does not seem to
>> be really correct
>
> The message comes from SCSI:
> https://elixir.bootlin.com/linux/latest/source/drivers/scsi/sd.c#L2508
>
> Reading drive capacity could be totally opaque for the filesystem, eg.
> when the scsi layer compares the requested block address with the device
> size.
>
> The sizes of blockdevices is obtained from the i_size member of the
> inode representing the block device, so there's no direct read by btrfs.
> You'd have better luck reporting that to scsi or block layer
> mailinglists.
