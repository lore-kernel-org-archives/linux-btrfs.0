Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:34024 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752920AbcKSU1u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 Nov 2016 15:27:50 -0500
Received: by mail-yb0-f193.google.com with SMTP id h184so10437606ybb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Nov 2016 12:27:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5be14cba-943b-a622-b9af-394b76f2e650@gmail.com>
References: <18970348.FUMEOFOSb3@merkaba> <1672818.LEbdb7TNyD@merkaba>
 <5a0c51bd-4245-92e2-566b-cc3dbcc26a84@gmail.com> <2758726.eYgiA1VjUp@merkaba>
 <CAJCQCtQnSYRMUWb3V3Qn+chb2o18F5dgoy2mxPw8vqnohrErjQ@mail.gmail.com> <5be14cba-943b-a622-b9af-394b76f2e650@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 19 Nov 2016 12:27:49 -0800
Message-ID: <CAJCQCtTWmOGt5izW5rBJ7u7C7Rgx3c=wgc3D+1ypqVWYj07fNw@mail.gmail.com>
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to
 find block group for 0
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Martin Steigerwald <martin.steigerwald@teamix.de>,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 17, 2016 at 12:20 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-11-17 15:05, Chris Murphy wrote:
>>
>> I think the wiki should be updated to reflect that raid1 and raid10
>> are mostly OK. I think it's grossly misleading to consider either as
>> green/OK when a single degraded read write mount creates single chunks
>> that will then prevent a subsequent degraded read write mount. And
>> also the lack of various notifications of device faultiness I think
>> make it less than OK also. It's not in the "do not use" category but
>> it should be in the middle ground status so users can make informed
>> decisions.
>>
> It's worth pointing out also regarding this:
> * This is handled sanely in recent kernels (the check got changed from
> per-fs to per-chunk, so you still have a usable FS if all the single chunks
> are only on devices you still have).

The status page should reflect the version with sane behavior,
relative to the versions with not sane behavior. Otherwise people hit
it unexpectedly despite the status page.

But still, the multiple device stuff really is not "OK" until there's
some kind of faulty device concept and also notification for state
changes from normal to faulty, faulty to normal, or even failed if
that's reliably distinguishable from faulty.


> As far as the failed device handling issues, those are a problem with BTRFS
> in general, not just raid1 and raid10, so I wouldn't count those against
> raid1 and raid10.

Sure but raid56 are already flagged as not ready for prime time.



-- 
Chris Murphy
