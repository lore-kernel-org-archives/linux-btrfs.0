Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34596 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbcF1CPA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 22:15:00 -0400
Received: by mail-oi0-f44.google.com with SMTP id s66so4057858oif.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 19:14:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160628024940.3b323b26@system>
References: <20160627233612.662d2a9a@system> <CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
 <20160628002602.022258bf@system> <CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
 <CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
 <20160628010618.58e235fa@system> <CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
 <20160628024940.3b323b26@system>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 20:14:58 -0600
Message-ID: <CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
Subject: Re: Kernel bug during RAID1 replace
To: Saint Germain <saintger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 6:49 PM, Saint Germain <saintger@gmail.com> wrote:

>
> I've tried both option and launched a replace, but I got the same error
> (replace is cancelled, jernel bug).
> I will let these options on and attempt a ddrescue on /dev/sda
> to /dev/sdd.
> Then I will disconnect /dev/sda and reboot and see if it works better.

Sounds reasonable. Just make sure the file system is already unmounted
when you use ddrescue because otherwise you're block copying it while
it could be modified while rw mounted (generation number tends to get
incremented while rw mounted).


>> Last, I have no idea if the massive Btrfs write errors on sda are from
>> an earlier problem where the drive data or power cable got jiggled or
>> was otherwise absent temporarily? So depending on how the block
>> timeout change affects your data recovery, you might end up needing to
>> do a reboot to get back to a more stable state for all of this? It
>> really should be able to fix things *if* at least one copy can be read
>> and then written to the other drive.
>>
>
> I have also no idea why is sda behaving like this. I haven't done
> anything particular on these drives.

Yeah pretty weird. At some point once things are stable, if this file
system survives, you might want to use btrfs dev stat -z to wipe out
those stats.


-- 
Chris Murphy
