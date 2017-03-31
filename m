Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:41316 "EHLO
        smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750777AbdCaHFZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 03:05:25 -0400
Received: from smtp1.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp1.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 4935A5C16
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 03:05:23 -0400 (EDT)
Received: by smtp1.relay.iad3a.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id E51645B9A
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 03:05:22 -0400 (EDT)
To: linux-btrfs@vger.kernel.org
From: Marat Khalili <mkh@rqc.ru>
Subject: Do different btrfs volumes compete for CPU?
Message-ID: <43a14754-1047-552e-78a9-6503dfc0d121@rqc.ru>
Date: Fri, 31 Mar 2017 10:05:20 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Approximately 16 hours ago I've run a script that deleted >~100 
snapshots and started quota rescan on a large USB-connected btrfs volume 
(5.4 of 22 TB occupied now). Quota rescan only completed just now, with 
100% load from [btrfs-transacti] throughout this period, which is 
probably ~ok depending on your view on things.

What worries me is innocent process using _another_, SATA-connected 
btrfs volume that hung right after I started my script and took >30 
minutes to be sigkilled. There's nothing interesting in the kernel log, 
and attempts to attach strace to the process output nothing, but I of 
course suspect that it freezed on disk operation.

I wonder:
1) Can there be a contention for CPU or some mutexes between kernel 
btrfs threads belonging to different volumes?
2) If yes, can anything be done about it other than mounting volumes 
from (different) VMs?


> $ uname -a; btrfs --version
> Linux host 4.4.0-66-generic #87-Ubuntu SMP Fri Mar 3 15:29:05 UTC 2017 
> x86_64 x86_64 x86_64 GNU/Linux
> btrfs-progs v4.4

--

With Best Regards,
Marat Khalili

