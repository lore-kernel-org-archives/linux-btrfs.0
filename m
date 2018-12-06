Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C7AC04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 11:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24DC3214C1
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 11:31:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24DC3214C1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mohrkeg.co.at
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbeLFLbX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 06:31:23 -0500
Received: from vie01a-dmta-at03-3.mx.upcmail.net ([62.179.121.153]:59430 "EHLO
        vie01a-dmta-at03-3.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727832AbeLFLbW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 06:31:22 -0500
Received: from [172.31.216.41] (helo=vie01a-pemc-psmtp-at50)
        by vie01a-dmta-at03.mx.upcmail.net with esmtp (Exim 4.88)
        (envelope-from <thomas.mohr@mohrkeg.co.at>)
        id 1gUrsF-00021y-RQ
        for linux-btrfs@vger.kernel.org; Thu, 06 Dec 2018 12:31:19 +0100
Received: from laptopmohr.mohrkeg.co.at ([149.148.24.127])
        by vie01a-pemc-psmtp-at50 with SMTP @ mailcloud.upcmail.net
        id 8bXF1z01D2kXqND0BbXFMA; Thu, 06 Dec 2018 12:31:15 +0100
X-SourceIP: 149.148.24.127
X-Authenticated-Sender: thomas.mohr@inode.at
X-CNFS-Analysis: v=2.2 cv=O6RJhF1W c=1 sm=2 tr=0
 a=i6skkVUHdkzJmkYAsm6Ufg==:117 a=i6skkVUHdkzJmkYAsm6Ufg==:17
 a=IkcTkHD0fZMA:10 a=pWgc1MIBAAAA:8 a=3OkbPOLaaKe4AvF-Ga8A:9 a=QEXdDO2ut3YA:10
 a=HawKmyPu_zQA:10 a=oAKYyZnKYoYUG6yso8hm:22
From:   Thomas Mohr <thomas.mohr@mohrkeg.co.at>
Subject: HELP unmountable partition after btrfs balance to RAID0
To:     linux-btrfs@vger.kernel.org
Message-ID: <44bba061-a784-e79e-a379-373895d653c0@mohrkeg.co.at>
Date:   Thu, 6 Dec 2018 12:31:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Dear developers of BTRFS,

we have a problem. We wanted to convert a file system to a RAID0 with 
two partitions. Unfortunately we had to reboot the server during the 
balance operation before it could complete.

Now following happens:

A mount attempt of the array fails with following error code:

btrfs recover yields roughly 1.6 out of 4 TB.

to recover the rest we have tried:

mount:

[18192.357444] BTRFS info (device sdb1): disk space caching is enabled
[18192.357447] BTRFS info (device sdb1): has skinny extents
[18192.370664] BTRFS error (device sdb1): parent transid verify failed 
on 30523392 wanted 7432 found 7445
[18192.370810] BTRFS error (device sdb1): parent transid verify failed 
on 30523392 wanted 7432 found 7445
[18192.394745] BTRFS error (device sdb1): open_ctree failed

mounting with options ro, degraded, cache_clear etc yields the same errors.


btrfs rescue zero-log. This operation works, however, the error persists 
and the array remains unmountable

parent transid verify failed on 59768832 wanted 7422 found 7187
parent transid verify failed on 59768832 wanted 7422 found 7187
parent transid verify failed on 59768832 wanted 7422 found 7187
parent transid verify failed on 59768832 wanted 7422 found 7187
Ignoring transid failure
parent transid verify failed on 30408704 wanted 7430 found 7443
parent transid verify failed on 30408704 wanted 7430 found 7443
parent transid verify failed on 30408704 wanted 7430 found 7443
parent transid verify failed on 30408704 wanted 7430 found 7443
Ignoring transid failure
Clearing log on /dev/sdb1, previous log_root 0, level 0

btrfs rescue chunk-recover fails with following error message:

btrfs check results in:

Opening filesystem to check...
parent transid verify failed on 59768832 wanted 7422 found 7187
parent transid verify failed on 59768832 wanted 7422 found 7187
parent transid verify failed on 59768832 wanted 7422 found 7187
parent transid verify failed on 59768832 wanted 7422 found 7187
Ignoring transid failure
parent transid verify failed on 30408704 wanted 7430 found 7443
parent transid verify failed on 30408704 wanted 7430 found 7443
parent transid verify failed on 30408704 wanted 7430 found 7443
parent transid verify failed on 30408704 wanted 7430 found 7443
Ignoring transid failure
Checking filesystem on /dev/sdb1
UUID: 6c9ed4e1-d63f-46f0-b1e9-608b8fa43bb8
[1/7] checking root items
parent transid verify failed on 30523392 wanted 7432 found 7443
parent transid verify failed on 30523392 wanted 7432 found 7443
parent transid verify failed on 30523392 wanted 7432 found 7443
parent transid verify failed on 30523392 wanted 7432 found 7443
Ignoring transid failure
leaf parent key incorrect 30523392ERROR: failed to repair root items: 
Operation not permitted

Any ideas what is going on or how to recover the file system ? I would 
greatly appreciate your help !!!

best,

Thomas


uname -a:

Linux server2 4.19.5-1-default #1 SMP PREEMPT Tue Nov 27 19:56:09 UTC 
2018 (6210279) x86_64 x86_64 x86_64 GNU/Linux

btrfs-progs version 4.19


-- 
ScienceConsult - DI Thomas Mohr KG
DI Thomas Mohr
Enzianweg 10a
2353 Guntramsdorf
Austria
+43 2236 56793
+43 660 461 1966
http://www.mohrkeg.co.at

