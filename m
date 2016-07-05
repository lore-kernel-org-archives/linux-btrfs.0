Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38224 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbcGESkp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jul 2016 14:40:45 -0400
Received: by mail-wm0-f46.google.com with SMTP id r201so164353231wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jul 2016 11:40:44 -0700 (PDT)
Subject: Re: Unable to mount degraded RAID5
To: Chris Murphy <lists@colorremedies.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com>
 <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com>
 <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <577B2E1D.5070808@gmail.com>
 <CAJCQCtSW+3eA-amrGgQAds1F8sYPDPgTB9x49RjWnaq=vSePgw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Message-ID: <b9647ec5-fe9b-4bfe-97d1-329f47dbf7b0@gmail.com>
Date: Tue, 5 Jul 2016 20:40:42 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSW+3eA-amrGgQAds1F8sYPDPgTB9x49RjWnaq=vSePgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't know, if it would be good idea, but my disk, which disconnected
is connected again. Maybe it could help in getting data to the right
state, so other two disk could be mounted alone. But don't know, if it
would stay connected for some work. Or if it would make things even worst.

Thank you
Tomas


------------------------------------------------------------------------

 *From:* Chris Murphy
 *Sent:*  Tuesday, July 05, 2016 5:13PM
 *To:* Andrei Borzenkov
*Cc:* Chris Murphy, Tomáš Hrdina, Btrfs Btrfs
 *Subject:* Re: Unable to mount degraded RAID5

On Mon, Jul 4, 2016 at 9:48 PM, Andrei Borzenkov <arvidjaar@gmail.com>
wrote:
> 04.07.2016 23:43, Chris Murphy пишет:
>> 
>> Have you done a scrub on this file system and do you know if anything
>> was fixed or if it always found no problem?
>> 
>>
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

> because even
> if scrub finds discrepancies, it does not have enough data to
> reconstruct them. I would actually avoid it - the worst that can happen
> if it attempts to replace remaining data with something faked.

At the moment I would like all of the debugging tools to have a flag
to force ignoring checksum checks. Right now they fail on checksum
mismatch. Instead I'd rather see the output ignoring checksum
mismatches, but somehow indicate suspicious information because of a
checksum mismatch.





---
Tato zpráva byla zkontrolována na viry programem Avast Antivirus.
https://www.avast.com/antivirus

