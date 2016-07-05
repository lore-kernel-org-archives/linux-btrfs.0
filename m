Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35221 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbcGEPNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jul 2016 11:13:55 -0400
Received: by mail-oi0-f50.google.com with SMTP id r2so233354665oih.2
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jul 2016 08:13:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <577B2E1D.5070808@gmail.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com> <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com> <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <577B2E1D.5070808@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 5 Jul 2016 09:13:53 -0600
Message-ID: <CAJCQCtSW+3eA-amrGgQAds1F8sYPDPgTB9x49RjWnaq=vSePgw@mail.gmail.com>
Subject: Re: Unable to mount degraded RAID5
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 4, 2016 at 9:48 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 04.07.2016 23:43, Chris Murphy пишет:
>>
>> Have you done a scrub on this file system and do you know if anything
>> was fixed or if it always found no problem?
>>
>
> scrub on degraded RAID5 cannot fix anything by definition,

Right. In this case, he can't mount, so he can't do a scrub. My
concise question could be confusing in another situation as suggesting
he should do a scrub now, but I was asking if he had ever done a
scrub. I was wondering if maybe he's run into this scrub problem where
a data strip is wrong but gets fixed from good parity and is then
promptly overwritten with wrongly computed parity. That leads to this
same kind of checksum errors when degraded because the wrong parity
results in wrong reconstruction of data.

But that's not the case here it seems. So, how is it this healthy,
functioning raid5 totally implodes like this with checksum errors just
because of a single device degraded? There are no device read errors
or link resets in the kernel messages. It seems to be a weakness of
the chunk tree again, which at least Qu has mentioned before.

>because even
> if scrub finds discrepancies, it does not have enough data to
> reconstruct them. I would actually avoid it - the worst that can happen
> if it attempts to replace remaining data with something faked.

At the moment I would like all of the debugging tools to have a flag
to force ignoring checksum checks. Right now they fail on checksum
mismatch. Instead I'd rather see the output ignoring checksum
mismatches, but somehow indicate suspicious information because of a
checksum mismatch.



-- 
Chris Murphy
