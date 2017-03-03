Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:22881 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751394AbdCCKOb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Mar 2017 05:14:31 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v23AE8As021154
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 3 Mar 2017 10:14:08 GMT
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
To: Duncan <1i5t5.duncan@cox.net>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
 <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net>
From: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <84e27d38-a457-52cf-8565-e9a031d61e4a@oracle.com>
Date: Fri, 3 Mar 2017 18:16:28 +0800
MIME-Version: 1.0
In-Reply-To: <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> AFAIK, no, it hasn't been fixed, at least not in mainline, because the
> patches to fix it got stuck in some long-running project patch queue
> (IIRC, the one for on-degraded auto-device-replace), with no timeline
> known to me on mainline merge.
>
> Meanwhile, the problem as I understand it is that at the first raid1
> degraded writable mount, no single-mode chunks exist, but without the
> second device, they are created.


It might be an accidental feature introduced in the patch [1].
RFC [2] (limited tested) tried to correct it. But, if the accidental
feature works better than the traditional RAID1 approach then
workaround fix [3] will help, however for the accidental feature
I am not sure if it is would to support all the failures-recovery/
FS-is-full cases.

[1]
   commit 95669976bd7d30ae265db938ecb46a6b7f8cb893
   Btrfs: don't consider the missing device when allocating new chunks

[2]
   [PATCH 0/2] [RFC] btrfs: create degraded-RAID1 chunks

[3]
   Patches 01/13 to 05/13 of the below patch set (which were needed
   to test rest of the patches in the set).
   [PATCH v6 00/13] Introduce device state 'failed', spare device and 
auto replace.


Hope this sheds some light on the long standing issue.

Thanks, Anand
