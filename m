Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:40602 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752805AbeCPQoF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 12:44:05 -0400
Received: by mail-oi0-f51.google.com with SMTP id c12so9122919oic.7
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Mar 2018 09:44:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4d543ebaf4404f1b8111e48ff221e51d@MOXDE7.na.bayer.cnb>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net> <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CAJCQCtTUsH5ynMCjRRcnGZHAccOcUL4os3GriBb+mwwtR8SC2w@mail.gmail.com>
 <6b4f2b33edb44f1ea8cef47ae68960af@MOXDE7.na.bayer.cnb> <CAJCQCtS+PsWLmSq_UWTaBd8gikumtQaO16dX6HCz_RdGp-grJg@mail.gmail.com>
 <4d543ebaf4404f1b8111e48ff221e51d@MOXDE7.na.bayer.cnb>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 16 Mar 2018 10:44:04 -0600
Message-ID: <CAJCQCtSW4RxSAPjVC5yZLAjb5WUMDV+8=6Bdt4aUWDhXBuZa5Q@mail.gmail.com>
Subject: Re: Crashes running btrfs scrub
To: Mike Stevens <michael.stevens@bayer.com>
Cc: Chris Murphy <lists@colorremedies.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 16, 2018 at 10:17 AM, Mike Stevens
<michael.stevens@bayer.com> wrote:
>> Also, in the meantime, maybe the problem can be prevented by
>> preventing the balance from resuming when mounting. First umount then
>> mount with -o skip_balance.
>
> Thanks for the suggestion Chris.  I already had mounted it with skip_balance and then cancelled
> the balance.  It will mount, but any significant i/o to the volume cause it to drop r/o.

It's getting confused and doesn't want to corrupt the file system,
that's a good thing.

Basically it wants to create a block group, but this fails. In the
code, before it gets to the particular failure noted in the call
trace, there are multiple different attempts to allocate a block group
but those are also failing.

But here's the thing - the scrub is still being started or resumed. I
didn't think that scrubs are resumed automatically, but you've got

>Mar 15 14:03:06 auswscs9903 kernel: scrub_enumerate_chunks+0x1ad/0x680 [btrfs]
>Mar 15 14:03:06 auswscs9903 kernel: btrfs_scrub_dev+0x21d/0x540 [btrfs]

and

>Mar 15 14:03:06 auswscs9903 kernel: BTRFS warning (device sdag): failed setting block group ro: -30


These are only found in scrub.c

Is there something starting the scrub right away at mount time? Is
there enough time to cancel scrub before it goes read only?

I definitely think there's a bug here somewhere, but it's taking more
than one thing at once to trigger it, so it's a kind of corner case or
it would have been caught sooner.

See if you can prevent scrub from being started, or if it's resuming
on its own for some reason then try to cancel it soon after mount,
hopefully before it goes ro.

Another thing you could try is mounting with nospace_cache. This is a
coin toss if it will matter, but the fact it's not able to create
pending bg's makes me wonder if possibly something is awry with the on
disk free space cache, and this would eliminate that possibility
without having to clear the cache. There's a performance penalty with
nospace_cache but that's the least of the issues right now.





-- 
Chris Murphy
