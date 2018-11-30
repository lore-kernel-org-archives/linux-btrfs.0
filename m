Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64588C04EB8
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 14:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 031C520863
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 14:01:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 031C520863
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=duckstad.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbeLABKp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 20:10:45 -0500
Received: from smtp-out2.caiw.net ([62.45.45.126]:56974 "EHLO
        smtp-out2.caiw.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbeLABKp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 20:10:45 -0500
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2018 20:10:43 EST
Received: from barracuda-out-1.caiw.net (barracuda-out-1.caiw.net [62.45.59.17])
        by smtp-out2.caiw.net (Postfix) with ESMTP id 09AEE624CD
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 14:53:17 +0100 (CET)
X-ASG-Debug-ID: 1543585996-08d68a765b58050001-6jHSXT
Received: from smtp-out1.caiw.net (smtp-out1.caiw.net [62.45.45.125]) by barracuda-out-1.caiw.net with ESMTP id gfjx6WI5DncyM1wP for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 14:53:16 +0100 (CET)
X-Barracuda-Envelope-From: bolderbast@duckstad.net
X-Barracuda-RBL-Trusted-Forwarder: 62.45.45.125
Received: from katrien.duckstad.net (200-228-045-062.dynamic.caiway.nl [62.45.228.200])
        by smtp-out1.caiw.net (Postfix) with ESMTP id 309DBE0086
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 14:53:16 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by katrien.duckstad.net (Postfix) with ESMTP id 1F30A3802F
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 14:53:16 +0100 (CET)
X-Barracuda-RBL-IP: 62.45.228.200
X-Barracuda-Effective-Source-IP: 200-228-045-062.dynamic.caiway.nl[62.45.228.200]
X-Barracuda-Apparent-Source-IP: 62.45.228.200
Received: from katrien.duckstad.net ([127.0.0.1])
        by localhost (katrien.duckstad.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id bVzBHr1fCOyJ for <linux-btrfs@vger.kernel.org>;
        Fri, 30 Nov 2018 14:53:14 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by katrien.duckstad.net (Postfix) with ESMTP id 6517338030
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 14:53:14 +0100 (CET)
X-Virus-Scanned: amavisd-new at katrien.duckstad.net
Received: from katrien.duckstad.net ([127.0.0.1])
        by localhost (katrien.duckstad.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id B4atZz6cI-N8 for <linux-btrfs@vger.kernel.org>;
        Fri, 30 Nov 2018 14:53:14 +0100 (CET)
Received: from bolderbast (unknown [10.4.2.1])
        by katrien.duckstad.net (Postfix) with ESMTPSA id 364EC3802F
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 14:53:14 +0100 (CET)
Message-ID: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
Subject: Need help with potential ~45TB dataloss
From:   Patrick Dijkgraaf <bolderbast@duckstad.net>
X-ASG-Orig-Subj: Need help with potential ~45TB dataloss
To:     linux-btrfs@vger.kernel.org
Date:   Fri, 30 Nov 2018 14:53:13 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: smtp-out1.caiw.net[62.45.45.125]
X-Barracuda-Start-Time: 1543585996
X-Barracuda-URL: https://62.45.59.17:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at caiw.net
X-Barracuda-Scan-Msg-Size: 5449
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4941 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=7.0 KILL_LEVEL=1000.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.62759
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

I have been a happy BTRFS user for quite some time. But now I'm facing
a potential ~45TB dataloss... :-(
I hope someone can help!

I have Server A and Server B. Both having a 20-devices BTRFS RAID6
filesystem. Because of known RAID5/6 risks, Server B was a backup of
Server A.
After applying updates to server B and reboot, the FS would not mount
anymore. Because it was "just" a backup. I decided to recreate the FS
and perform a new backup. Later, I discovered that the FS was not
broken, but I faced this issue: 
https://patchwork.kernel.org/patch/10694997/

Anyway, the FS was already recreated, so I needed to do a new backup.
During the backup (using rsync -vah), Server A (the source) encountered
an I/O error and my rsync failed. In an attempt to "quick fix" the
issue, I rebooted Server A after which the FS would not mount anymore.

I documented what I have tried, below. I have not yet tried anything
except what is shown, because I am afraid of causing more harm to
the FS. I hope somebody here can give me advice on how to (hopefully)
retrieve my data...

Thanks in advance!

==========================================

[root@cornelis ~]# btrfs fi show
Label: 'cornelis-btrfs'  uuid: ac643516-670e-40f3-aa4c-f329fc3795fd
	Total devices 1 FS bytes used 463.92GiB
	devid    1 size 800.00GiB used 493.02GiB path
/dev/mapper/cornelis-cornelis--btrfs

Label: 'data'  uuid: 4c66fa8b-8fc6-4bba-9d83-02a2a1d69ad5
	Total devices 20 FS bytes used 44.85TiB
	devid    1 size 3.64TiB used 3.64TiB path /dev/sdn2
	devid    2 size 3.64TiB used 3.64TiB path /dev/sdp2
	devid    3 size 3.64TiB used 3.64TiB path /dev/sdu2
	devid    4 size 3.64TiB used 3.64TiB path /dev/sdx2
	devid    5 size 3.64TiB used 3.64TiB path /dev/sdh2
	devid    6 size 3.64TiB used 3.64TiB path /dev/sdg2
	devid    7 size 3.64TiB used 3.64TiB path /dev/sdm2
	devid    8 size 3.64TiB used 3.64TiB path /dev/sdw2
	devid    9 size 3.64TiB used 3.64TiB path /dev/sdj2
	devid   10 size 3.64TiB used 3.64TiB path /dev/sdt2
	devid   11 size 3.64TiB used 3.64TiB path /dev/sdk2
	devid   12 size 3.64TiB used 3.64TiB path /dev/sdq2
	devid   13 size 3.64TiB used 3.64TiB path /dev/sds2
	devid   14 size 3.64TiB used 3.64TiB path /dev/sdf2
	devid   15 size 7.28TiB used 588.80GiB path /dev/sdr2
	devid   16 size 7.28TiB used 588.80GiB path /dev/sdo2
	devid   17 size 7.28TiB used 588.80GiB path /dev/sdv2
	devid   18 size 7.28TiB used 588.80GiB path /dev/sdi2
	devid   19 size 7.28TiB used 588.80GiB path /dev/sdl2
	devid   20 size 7.28TiB used 588.80GiB path /dev/sde2

[root@cornelis ~]# mount /dev/sdn2 /mnt/data
mount: /mnt/data: wrong fs type, bad option, bad superblock on
/dev/sdn2, missing codepage or helper program, or other error.

[root@cornelis ~]# btrfs check /dev/sdn2
Opening filesystem to check...
parent transid verify failed on 46451963543552 wanted 114401 found
114173
parent transid verify failed on 46451963543552 wanted 114401 found
114173
checksum verify failed on 46451963543552 found A8F2A769 wanted 4C111ADF
checksum verify failed on 46451963543552 found 32153BE8 wanted 8B07ABE4
checksum verify failed on 46451963543552 found 32153BE8 wanted 8B07ABE4
bad tree block 46451963543552, bytenr mismatch, want=46451963543552,
have=75208089814272
Couldn't read tree root
ERROR: cannot open file system

[root@cornelis ~]# btrfs restore /dev/sdn2 /mnt/data/
parent transid verify failed on 46451963543552 wanted 114401 found
114173
parent transid verify failed on 46451963543552 wanted 114401 found
114173
checksum verify failed on 46451963543552 found A8F2A769 wanted 4C111ADF
checksum verify failed on 46451963543552 found 32153BE8 wanted 8B07ABE4
checksum verify failed on 46451963543552 found 32153BE8 wanted 8B07ABE4
bad tree block 46451963543552, bytenr mismatch, want=46451963543552,
have=75208089814272
Couldn't read tree root
Could not open root, trying backup super
warning, device 14 is missing
warning, device 13 is missing
warning, device 12 is missing
warning, device 11 is missing
warning, device 10 is missing
warning, device 9 is missing
warning, device 8 is missing
warning, device 7 is missing
warning, device 6 is missing
warning, device 5 is missing
warning, device 4 is missing
warning, device 3 is missing
warning, device 2 is missing
checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
bad tree block 22085632, bytenr mismatch, want=22085632,
have=1147797504
ERROR: cannot read chunk root
Could not open root, trying backup super
warning, device 14 is missing
warning, device 13 is missing
warning, device 12 is missing
warning, device 11 is missing
warning, device 10 is missing
warning, device 9 is missing
warning, device 8 is missing
warning, device 7 is missing
warning, device 6 is missing
warning, device 5 is missing
warning, device 4 is missing
warning, device 3 is missing
warning, device 2 is missing
checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
bad tree block 22085632, bytenr mismatch, want=22085632,
have=1147797504
ERROR: cannot read chunk root
Could not open root, trying backup super

[root@cornelis ~]# uname -r
4.18.16-arch1-1-ARCH

[root@cornelis ~]# btrfs --version
btrfs-progs v4.19

-- 
Cheers,
Patrick



