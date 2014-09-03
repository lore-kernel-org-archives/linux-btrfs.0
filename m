Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:64882 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbaICGDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 02:03:53 -0400
Received: by mail-lb0-f182.google.com with SMTP id u10so8699180lbd.41
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 23:03:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <C5F63696-2ADD-4CB6-A049-71B71A9D083E@colorremedies.com>
References: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com>
	<540498AF.6030109@fb.com>
	<CANg_oxwNkjZf1gVfOJE72fUyqJvMpF+hQdN-V0_cPAJ9nxPsjQ@mail.gmail.com>
	<pan$efe46$daffbd12$cb4477b6$9a3e7f57@cox.net>
	<CANg_oxz9NGNVnY3rjeYPXqqi0PtcxZkMVyD5marfmXfvCp7VPw@mail.gmail.com>
	<pan$1b676$93919c37$3c0fae08$71129a93@cox.net>
	<C5F63696-2ADD-4CB6-A049-71B71A9D083E@colorremedies.com>
Date: Wed, 3 Sep 2014 08:03:51 +0200
Message-ID: <CANg_oxxdeY-oMrs4xdamTejLwkGMkyJJsZw6D_UyfvkD0u+Tfg@mail.gmail.com>
Subject: Re: kernel 3.17-rc3: task rsync:2524 blocked for more than 120 seconds
From: john terragon <jterragon@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I tried the same routine on 32GB usb sticks. Same exact problems. 32GB
seems a bit much for a --mixed btrfs.
I haven't tried ssd_spread, maybe it's beneficial. However, as I wrote
above, disabling autodefrag gets rid completely of the "INFO: hung
task" messages but even though the kernel doesn't complain about
blocked kworkers, the rsync process still  blocks for several minutes
throughout the whole copy.


On Wed, Sep 3, 2014 at 4:44 AM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Sep 2, 2014, at 12:40 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>> Mkfs.btrfs used to default to 4 KiB node/leaf sizes; now days it defaults
>> to 16 KiB as that's far better for most usage.  I wonder if USB sticks
>> are an exception...
>
> USB sticks > 1 GB get 16KB nodesize also. At <= 1 GB, mixed-bg is default as is 4KB nodesize. Probably because queue/rotational is 1 for USB sticks, they mount without ssd or ssd_spread which may be unfortunate (I haven't benchmarked it but I suspect ssd_spread would work well for USB sticks).
>
> It was suggested a while ago that maybe mixed-bg should apply to larger volumes, maybe up to 8GB or 16GB?
>
>
> Chris Murphy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
