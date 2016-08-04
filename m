Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:35619 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbcHDUvI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Aug 2016 16:51:08 -0400
Received: by mail-qk0-f174.google.com with SMTP id x185so52372776qkc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Aug 2016 13:51:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQAPXn714YL2R1V7q2fhn7QCsYHHceTimyFQ1TsMf-BQg@mail.gmail.com>
References: <CAGQ70Ye3Ly0N5cZHe3_D0RX8yW6ZzcN7fVhoLnnXrPXjOKPa1Q@mail.gmail.com>
 <274e0a56-086f-23c4-7ae9-2b6cb68ec6c8@gmail.com> <CAJCQCtQAPXn714YL2R1V7q2fhn7QCsYHHceTimyFQ1TsMf-BQg@mail.gmail.com>
From: Martin <rc6encrypted@gmail.com>
Date: Thu, 4 Aug 2016 22:51:06 +0200
Message-ID: <CAGQ70Yf3R4mfPJRZWvyBXivN9qy_9WOsrZhdpx--a_27Wy3sYQ@mail.gmail.com>
Subject: Re: How to stress test raid6 on 122 disk array
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the benchmark tools and tips on where the issues might be.

Is Fedora 24 rawhide preferred over ArchLinux?

If I want to compile a mainline kernel. Are there anything I need to tune?

When I do the tests, how do I log the info you would like to see, if I
find a bug?



On 4 August 2016 at 22:01, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Aug 4, 2016 at 1:05 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>>Fedora should be fine (they're good about staying up to
>> date), but if possible you should probably use Rawhide instead of a regular
>> release, as that will give you quite possibly one of the closest
>> distribution kernels to a mainline Linux kernel available, and will make
>> sure everything is as up to date as possible.
>
> Yes. It's possible to run on a release version (currently Fedora 23
> and Fedora 24) and run a Rawhide kernel. This is what I often do.
>
>
>> As far as testing, I don't know that there are any scripts for this type of
>> thing, you may want to look into dbench, fio, iozone, and similar tools
>> though, as well as xfstests (which is more about regression testing, but is
>> still worth looking at).
>>
>> Most of the big known issues with RAID6 in BTRFS at the moment involve
>> device failures and array recovery, but most of them aren't well
>> characterized and nobody's really sure why they're happening, so if you want
>> to look for something specific, figuring out those issues would be a great
>> place to start (even if they aren't rare bugs).
>
> Yeah it seems pretty reliable to do normal things with raid56 arrays.
> The problem is when they're degraded, weird stuff seems to happen some
> of the time. So it might be valid to have several raid56's that are
> intentionally running in degraded mode with some tests that will
> tolerate that and see when it breaks and why.
>
> There is also in the archives the bug where parity is being computed
> wrongly when a data strip is wrong (corrupt), and Btrfs sees this,
> reports the mismatch, fixes the mismatch, recomputes parity for some
> reason, and the parity is then wrong. It'd be nice to know when else
> this can happen, if it's possible parity is recomputed (and wrongly)
> on a normal read, or a balance, or if it's really restricted to scrub.
>
> Another test might be raid 1 or raid10 metadata vs raid56 for data.
> That'd probably be more performance related, but there might be some
> unexpected behaviors that crop up.
>
>
>
> --
> Chris Murphy
