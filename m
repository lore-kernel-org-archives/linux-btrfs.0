Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16B6C43612
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FEF52063F
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732730AbfAHTpR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:45:17 -0500
Received: from gfuc.org ([88.99.83.187]:40426 "EHLO gfuc.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732414AbfAHTpP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 14:45:15 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2019 14:45:15 EST
Received: from [192.168.178.72] (dslb-092-075-200-024.092.075.pools.vodafone-ip.de [92.75.200.24])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by gfuc.org (Postfix) with ESMTPSA id 843E71E0351
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Jan 2019 19:38:32 +0000 (UTC)
From:   Florian Stecker <m19@florianstecker.de>
Subject: applications hang on a btrfs spanning two partitions
To:     linux-btrfs@vger.kernel.org
Message-ID: <418d4647-8c67-2481-68f1-1e722460c3de@florianstecker.de>
Date:   Tue, 8 Jan 2019 20:38:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi everyone,

I extended the btrfs volume on my laptop by adding a second partition to 
it which lies on the same SSD (using btrfs device add). Since I did 
this, all kinds of applications regularly hang for up to 30 seconds. It 
seems they are stuck in the fdatasync syscall. For example:

$ strace -tt -T gajim 2>&1 | grep fdatasync
[...]
11:36:31.112200 fdatasync(25)           = 0 <0.006958>
11:36:32.147525 fdatasync(25)           = 0 <0.008138>
11:36:32.156882 fdatasync(25)           = 0 <0.006866>
11:36:32.165979 fdatasync(25)           = 0 <0.011797>
11:36:32.178867 fdatasync(25)           = 0 <23.636614>
11:36:55.827726 fdatasync(25)           = 0 <0.009595>
11:36:55.838702 fdatasync(25)           = 0 <0.007261>
11:36:55.850440 fdatasync(25)           = 0 <0.006807>
11:36:55.858168 fdatasync(25)           = 0 <0.006767>
[...]

File descriptor 25 here points to a file which is just ~90KB, so it 
really shouldn't take that long.

Removing the second partition again resolves the problem. Does anyone 
know this issue? Is it related to btrfs? Or am I just doing something wrong?

Best,
Florian

Some more info:

$ btrfs device usage /
/dev/sda2, ID: 2
    Device size:            52.16GiB
    Device slack:              0.00B
    Data,single:             1.00GiB
    Unallocated:            51.16GiB

/dev/sda8, ID: 1
    Device size:           174.92GiB
    Device slack:              0.00B
    Data,single:           168.91GiB
    Metadata,single:         3.01GiB
    System,single:           4.00MiB
    Unallocated:             3.00GiB

$ fdisk -l /dev/sda
Disk /dev/sda: 238.5 GiB, 256060514304 bytes, 500118192 sectors
Disk model: SAMSUNG SSD PM87
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: A48B5A25-AA84-4D3F-90DD-E8A4991BDF03

Device         Start       End   Sectors   Size Type
/dev/sda1       2048   1026047   1024000   500M EFI System
/dev/sda2    1026048 110422015 109395968  52.2G Linux filesystem
/dev/sda8  110422016 477263871 366841856 174.9G Linux filesystem
/dev/sda9  477263872 481458175   4194304     2G Linux swap

$ uname -a
Linux dell 4.20.0-arch1-1-ARCH #1 SMP PREEMPT Mon Dec 24 03:00:40 UTC 
2018 x86_64 GNU/Linux

