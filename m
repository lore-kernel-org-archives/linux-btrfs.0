Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36315 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbcHYS1Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 14:27:25 -0400
Received: by mail-wm0-f50.google.com with SMTP id q128so250182291wma.1
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 11:26:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <efe09b37f04cbc7754f6c6d84c9070f0@durkon.lan>
References: <efe09b37f04cbc7754f6c6d84c9070f0@durkon.lan>
From: Justin Kilpatrick <jkilpatr@redhat.com>
Date: Thu, 25 Aug 2016 14:26:22 -0400
Message-ID: <CANhjow-uihWAQ-MREsT9oAHWoFSHgqi=bXJwV8FJOStyMpC6sw@mail.gmail.com>
Subject: Re: Switch raid mode without rebalance?
To: Gert Menke <gert@menke.ac>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't think its possible to change raid levels without using a balance.

I'm not sure why you want to avoid a balance, its a background process that
will auto resume if interrupted. You don't have to leave your machine on for
weeks at a time and it shouldn't slow down an active application using the disks
very much if at all.

btrfs balance start -dconvert=single -mconvert=raid1 /mnt

Will keep your metadata on two disks so if one disk fails you at least know
what was lost. That's only an extra couple of gigs of space.

Once you start this command all the new data should follow the new rules.


On Thu, Aug 25, 2016 at 2:16 PM, Gert Menke <gert@menke.ac> wrote:
> Hi,
>
> I recently created a new btrfs on two disks - one 6TB, one 2TB - for
> temporary backup purposes.
> It apparently defaulted to raid0 for data, and I didn't realize at the time
> that this would become a problem.
> Now the 2TB is almost full, and df tells me I only have about 200GB of free
> space. Which makes sense, because raid0 spreads the data evenly on all
> disks.
> However, I know that btrfs can have different raid modes on the same
> filesystem at the same time. So I was hoping I could just tell it to "switch
> to single mode for all new data", but I don't have a clue how to do that. I
> *could* rebalance, of course, but is that really necessary? How does btrfs
> find out which raid mode to use when writing new data?
>
> Gert
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
