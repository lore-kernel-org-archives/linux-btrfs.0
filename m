Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:46857 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932351AbeAaQk2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 11:40:28 -0500
Received: by mail-lf0-f50.google.com with SMTP id q194so21655854lfe.13
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 08:40:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8a2e10b7-7476-f655-f3b8-aeb191049104@gmail.com>
References: <20180130063020.14850-1-anand.jain@oracle.com> <CAEtw4r2rj7YF+c3wXprM+PNXKVJZDFLMTznjc9egqB1bSR+Wxw@mail.gmail.com>
 <80358280-ce31-9049-61a8-c9a4b78f4b2b@oracle.com> <CAEtw4r1PM+zhmQHYXK8SfHczESg=NVsK9O2rd6FZ8-33_7at=A@mail.gmail.com>
 <cd9f0109-8c7c-3c98-53d8-100f06dcd46f@oracle.com> <CAEtw4r1gZCexSZnq_G43d55MwpXN0s-vS2Uyn2M9N2Cvi15QYA@mail.gmail.com>
 <8a2e10b7-7476-f655-f3b8-aeb191049104@gmail.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Wed, 31 Jan 2018 17:40:25 +0100
Message-ID: <CAEtw4r0zHCp4rA9KfdCoz2npo-777ZXU7pMC0Cs8jeMeo8xu9w@mail.gmail.com>
Subject: Re: [PATCH 0/2] Policy to balance read across mirrored devices
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ok, i understood the commitmessage as if the behavior for tests is
more of a bonus

2018-01-30 7:30 GMT+01:00 Anand Jain <anand.jain@oracle.com>:
> This __also__ helps testing

then it's clear to me. would only be good that this behavior is
documented. not that anyone else, like me, tries to use this as
performance tuning. at least the feature with the devid.

Thanks Austin,
Thanks Anand

2018-01-31 17:11 GMT+01:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
> On 2018-01-31 09:52, Peter Becker wrote:
>>
>> This is all clear. My question referes to "use the lower devid disk
>> containing the stripe"
>>
>> 2018-01-31 10:01 GMT+01:00 Anand Jain <anand.jain@oracle.com>:
>>>
>>>   When a stripe is not present on the read optimized disk it will just
>>>   use the lower devid disk containing the stripe (instead of failing back
>>>   to the pid based random disk).
>>
>>
>> Use only one disk (the disk with the lowest devid that containing the
>> stripe) as fallback should be not a good option imho.
>> Instead of it should still be used the pid as fallback to distribute
>> the workload among all available drives.
>>
>> [stripe to use] = [preffer stripes present on read_mirror_policy
>> devids] > [fallback to pid % stripe count]
>>
>> Perhaps I'm not be able to express myself in English or did I
>> misunderstand you?
>
> Unless I'm seriously misunderstanding the commit messages, the primary
> purpose of having this as an option at all is for testing.  The fact that it
> happens to allow semantics similar to MD's write-mostly flag when dealing
> with a 2-device raid1 profile is just a bonus.
