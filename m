Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:34514 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbcAFMaA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 07:30:00 -0500
Received: by mail-yk0-f175.google.com with SMTP id a85so236070387ykb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jan 2016 04:30:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS2ePxA44YCUS=Q7xS1sWszPmzDe13idDVvxwpeqHD05A@mail.gmail.com>
References: <CAHJqNbyXUfzscHteqrQtxJdYKToDNv7_Hw9tVpPuNJYwe=NHxw@mail.gmail.com>
	<CAJCQCtS2ePxA44YCUS=Q7xS1sWszPmzDe13idDVvxwpeqHD05A@mail.gmail.com>
Date: Wed, 6 Jan 2016 13:30:00 +0100
Message-ID: <CAHJqNbyqj1mXHxh2c-g365mdOEVsY9L1bwBJ6Na2R4LD1jjMcw@mail.gmail.com>
Subject: Re: Purposely using btrfs RAID1 in degraded mode ?
From: Alphazo <alphazo@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Chris for the warning. I agree that mounting both drives
separately in degraded r/w will lead to very funky results when trying
to scrub them when put together.

On Mon, Jan 4, 2016 at 6:41 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Mon, Jan 4, 2016 at 10:00 AM, Alphazo <alphazo@gmail.com> wrote:
>
>> I have tested the above use case with a couple of USB flash drive and
>> even used btrfs over dm-crypt partitions and it seemed to work fine
>> but I wanted to get some advices from the community if this is really
>> a bad practice that should not be used on the long run. Is there any
>> limitation/risk to read/write to/from a degraded filesystem knowing it
>> will be re-synced later?
>
> As long as you realize you're testing a sort of edge case, but an
> important one (it should work, that's the point of rw degraded mounts
> being possible), then I think it's fine.
>
> The warning though is, you need to designate a specific drive for the
> rw,degraded mounts. If you were to separately rw,degraded mount the
> two drives, the fs will become irreparably corrupt if they are
> rejoined. And you'll probably lose everything on the volume. The other
> thing is that to "resync" you have to manually initiate a scrub, it's
> not going to resync automatically, and it has to read everything on
> both drives to compare and fix what's missing. There is no equivalent
> to a write intent bitmap on Btrfs like with mdadm (the information
> ostensibly could be inferred from btrfs generation metadata similar to
> how incremental snapshot send/receive works) but that work isn't done.
>
>
>
>
> --
> Chris Murphy
