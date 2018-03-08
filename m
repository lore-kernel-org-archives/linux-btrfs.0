Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:39854 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754735AbeCHKQX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 05:16:23 -0500
Received: by mail-it0-f47.google.com with SMTP id l187so7258187ith.4
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Mar 2018 02:16:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJVZm6dQacWC0hVWoBxy2H3cSm78pCSqyJkD9Ch4AWLdUrwh9w@mail.gmail.com>
References: <CAJVZm6etk=bL0LY3FZXkm5Wun64F4w6HMxdLhKRD-v+mEGm08w@mail.gmail.com>
 <CAJVZm6e0+urcBNrVkXSwvuckTt1A2R8uj536ZzHcB9eG9FoqpQ@mail.gmail.com>
 <20180302151805.GB5942@twin.jikos.cz> <CAJVZm6dQacWC0hVWoBxy2H3cSm78pCSqyJkD9Ch4AWLdUrwh9w@mail.gmail.com>
From: Menion <menion@gmail.com>
Date: Thu, 8 Mar 2018 11:16:02 +0100
Message-ID: <CAJVZm6fb+PZ+0tn+JsWK54Nq4W50TwCO7nAaasLoyOm2M13okQ@mail.gmail.com>
Subject: Re: dmesg flooded with "Very big device. Trying to use READ
 CAPACITY(16)" with 8TB HDDs
To: dsterba@suse.cz, Menion <menion@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again
I had a discussion in linux-scsi about this topic
My understanding is that it is true that the read_capacity is opaque
to the filesystem but it is also true that the scsi layer export two
specific read_capacity ops, the read10 and read16 and the upper layers
shall select the proper one, based on the response of the other.
In the log, I see that this read_capacity_10 is called every 5
minutes, and it fallback to read_capacity_16, since who is doing it
endup in calling sd_read_capacity in scsi layer, rather then pickup
read10 or read16 directly
I am not telling that BTRFS is doing it for sure, but I have ruled out
smartd, so based on the periodicity of 5 minutes, can you think about
anything in the BTRFS internals that can be responsible of this?

2018-03-02 17:19 GMT+01:00 Menion <menion@gmail.com>:
> Thanks
> My point was to understand if this action was taken by BTRFS or
> automously by scsi.
> From your word it seems clear to me that this should go in
> KERNEL_DEBUG level, instead of KERNEL_NOTICE
> Bye
>
> 2018-03-02 16:18 GMT+01:00 David Sterba <dsterba@suse.cz>:
>> On Fri, Mar 02, 2018 at 12:37:49PM +0100, Menion wrote:
>>> Is it really a no problem? I mean, for some reason BTRFS is
>>> continuously read the HDD capacity in an array, that does not seem to
>>> be really correct
>>
>> The message comes from SCSI:
>> https://elixir.bootlin.com/linux/latest/source/drivers/scsi/sd.c#L2508
>>
>> Reading drive capacity could be totally opaque for the filesystem, eg.
>> when the scsi layer compares the requested block address with the device
>> size.
>>
>> The sizes of blockdevices is obtained from the i_size member of the
>> inode representing the block device, so there's no direct read by btrfs.
>> You'd have better luck reporting that to scsi or block layer
>> mailinglists.
