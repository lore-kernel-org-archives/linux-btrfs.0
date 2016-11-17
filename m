Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35835 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752125AbcKQUVA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 15:21:00 -0500
Received: by mail-it0-f67.google.com with SMTP id b123so17650847itb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Nov 2016 12:21:00 -0800 (PST)
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to
 find block group for 0
To: Chris Murphy <lists@colorremedies.com>,
        Martin Steigerwald <martin@lichtvoll.de>
References: <18970348.FUMEOFOSb3@merkaba> <1672818.LEbdb7TNyD@merkaba>
 <5a0c51bd-4245-92e2-566b-cc3dbcc26a84@gmail.com> <2758726.eYgiA1VjUp@merkaba>
 <CAJCQCtQnSYRMUWb3V3Qn+chb2o18F5dgoy2mxPw8vqnohrErjQ@mail.gmail.com>
Cc: Martin Steigerwald <martin.steigerwald@teamix.de>,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5be14cba-943b-a622-b9af-394b76f2e650@gmail.com>
Date: Thu, 17 Nov 2016 15:20:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQnSYRMUWb3V3Qn+chb2o18F5dgoy2mxPw8vqnohrErjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-17 15:05, Chris Murphy wrote:
> I think the wiki should be updated to reflect that raid1 and raid10
> are mostly OK. I think it's grossly misleading to consider either as
> green/OK when a single degraded read write mount creates single chunks
> that will then prevent a subsequent degraded read write mount. And
> also the lack of various notifications of device faultiness I think
> make it less than OK also. It's not in the "do not use" category but
> it should be in the middle ground status so users can make informed
> decisions.
>
It's worth pointing out also regarding this:
* This is handled sanely in recent kernels (the check got changed from 
per-fs to per-chunk, so you still have a usable FS if all the single 
chunks are only on devices you still have).
* This is only an issue with filesystems with exactly two disks.  If a 
3+ disk raid1 FS goes degraded, you still generate raid1 chunks.
* There are a couple of other cases where raid1 mode falls flat on it's 
face (lots of I/O errors in a short span of time with compression 
enabled can cause a kernel panic for example).
* raid10 has some other issues of it's own (you lose two devices, your 
filesystem is dead, which shouldn't be the case 100% of the time (if you 
lose different parts of each mirror, BTRFS _should_ be able to recover, 
it just doesn't do so right now)).

As far as the failed device handling issues, those are a problem with 
BTRFS in general, not just raid1 and raid10, so I wouldn't count those 
against raid1 and raid10.

