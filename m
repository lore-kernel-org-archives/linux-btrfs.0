Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50733 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbcKQUqa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 15:46:30 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Martin Steigerwald <martin.steigerwald@teamix.de>,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to find block group for 0
Date: Thu, 17 Nov 2016 21:46:26 +0100
Message-ID: <1557871.YY7DD0Ge7g@merkaba>
In-Reply-To: <CAJCQCtQnSYRMUWb3V3Qn+chb2o18F5dgoy2mxPw8vqnohrErjQ@mail.gmail.com>
References: <18970348.FUMEOFOSb3@merkaba> <2758726.eYgiA1VjUp@merkaba> <CAJCQCtQnSYRMUWb3V3Qn+chb2o18F5dgoy2mxPw8vqnohrErjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 17. November 2016, 12:05:31 CET schrieb Chris Murphy:
> I think the wiki should be updated to reflect that raid1 and raid10
> are mostly OK. I think it's grossly misleading to consider either as
> green/OK when a single degraded read write mount creates single chunks
> that will then prevent a subsequent degraded read write mount. And
> also the lack of various notifications of device faultiness I think
> make it less than OK also. It's not in the "do not use" category but
> it should be in the middle ground status so users can make informed
> decisions.

I agree – as error reporting I think is indead misleading. Feel free to edit 
it.

Ciao,
-- 
Martin
