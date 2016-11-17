Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:35942 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbcKQUFd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 15:05:33 -0500
Received: by mail-yb0-f194.google.com with SMTP id d128so8567099ybh.3
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Nov 2016 12:05:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2758726.eYgiA1VjUp@merkaba>
References: <18970348.FUMEOFOSb3@merkaba> <1672818.LEbdb7TNyD@merkaba>
 <5a0c51bd-4245-92e2-566b-cc3dbcc26a84@gmail.com> <2758726.eYgiA1VjUp@merkaba>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 17 Nov 2016 12:05:31 -0800
Message-ID: <CAJCQCtQnSYRMUWb3V3Qn+chb2o18F5dgoy2mxPw8vqnohrErjQ@mail.gmail.com>
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to
 find block group for 0
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Martin Steigerwald <martin.steigerwald@teamix.de>,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think the wiki should be updated to reflect that raid1 and raid10
are mostly OK. I think it's grossly misleading to consider either as
green/OK when a single degraded read write mount creates single chunks
that will then prevent a subsequent degraded read write mount. And
also the lack of various notifications of device faultiness I think
make it less than OK also. It's not in the "do not use" category but
it should be in the middle ground status so users can make informed
decisions.


Chris Murphy
