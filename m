Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41F4C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 697C520878
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:10:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 697C520878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=duckstad.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbeLDKKC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 05:10:02 -0500
Received: from smtp-out2.caiw.net ([62.45.45.126]:45685 "EHLO
        smtp-out2.caiw.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbeLDKKB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2018 05:10:01 -0500
Received: from barracuda-out-1.caiw.net (barracuda-out.caiw.net [62.45.59.17])
        by smtp-out2.caiw.net (Postfix) with ESMTP id 50B3161CFE
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 11:09:58 +0100 (CET)
X-ASG-Debug-ID: 1543918197-08d68a6e1e1280a0001-6jHSXT
Received: from smtp-out2.caiw.net (smtp-out2.caiw.net [62.45.45.126]) by barracuda-out-1.caiw.net with ESMTP id vSWrjLyRCfA95xcd; Tue, 04 Dec 2018 11:09:57 +0100 (CET)
X-Barracuda-Envelope-From: bolderbast@duckstad.net
X-Barracuda-RBL-Trusted-Forwarder: 62.45.45.126
Received: from katrien.duckstad.net (200-228-045-062.dynamic.caiway.nl [62.45.228.200])
        by smtp-out2.caiw.net (Postfix) with ESMTP id 8C2F8C0022;
        Tue,  4 Dec 2018 11:09:57 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by katrien.duckstad.net (Postfix) with ESMTP id 7072C3802F;
        Tue,  4 Dec 2018 11:09:57 +0100 (CET)
X-Barracuda-RBL-IP: 62.45.228.200
X-Barracuda-Effective-Source-IP: 200-228-045-062.dynamic.caiway.nl[62.45.228.200]
X-Barracuda-Apparent-Source-IP: 62.45.228.200
Received: from katrien.duckstad.net ([127.0.0.1])
        by localhost (katrien.duckstad.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 8O_7KLyRj2dI; Tue,  4 Dec 2018 11:09:56 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by katrien.duckstad.net (Postfix) with ESMTP id F08B938030;
        Tue,  4 Dec 2018 11:09:55 +0100 (CET)
X-Virus-Scanned: amavisd-new at katrien.duckstad.net
Received: from katrien.duckstad.net ([127.0.0.1])
        by localhost (katrien.duckstad.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id SzKcl8eDTOAC; Tue,  4 Dec 2018 11:09:55 +0100 (CET)
Received: from bolderbast (unknown [10.4.2.1])
        by katrien.duckstad.net (Postfix) with ESMTPSA id 6E0243802F;
        Tue,  4 Dec 2018 11:09:55 +0100 (CET)
Message-ID: <8e5729f3c15997a13bdce73800146e91222ed89c.camel@duckstad.net>
Subject: Re: Need help with potential ~45TB dataloss
From:   Patrick Dijkgraaf <bolderbast@duckstad.net>
X-ASG-Orig-Subj: Re: Need help with potential ~45TB dataloss
To:     Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Andrei Borzenkov <arvidjaar@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date:   Tue, 04 Dec 2018 11:09:55 +0100
In-Reply-To: <CAJCQCtRgzw=UPfHxeaiDzqKGzrbSKz-B3xfUpBjYM4GGe=W4YA@mail.gmail.com>
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
         <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com>
         <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
         <c24627dec9738552e1635617aace7720f395ba39.camel@duckstad.net>
         <2b235519-5c8d-9e86-b4f3-28cd7f778c4f@gmail.com>
         <7dac5577-2231-dcba-39fd-c229e4ed5e02@gmx.com>
         <CAJCQCtRgzw=UPfHxeaiDzqKGzrbSKz-B3xfUpBjYM4GGe=W4YA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: smtp-out2.caiw.net[62.45.45.126]
X-Barracuda-Start-Time: 1543918197
X-Barracuda-URL: https://62.45.59.17:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at caiw.net
X-Barracuda-Scan-Msg-Size: 7380
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0264 1.0000 -1.8498
X-Barracuda-Spam-Score: -1.85
X-Barracuda-Spam-Status: No, SCORE=-1.85 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=7.0 KILL_LEVEL=1000.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.63027
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Chris,

See the output below. Any suggestions based on it?
Thanks!

-- 
Groet / Cheers,
Patrick Dijkgraaf



On Mon, 2018-12-03 at 20:16 -0700, Chris Murphy wrote:
> Also useful information for autopsy, perhaps not for fixing, is to
> know whether the SCT ERC value for every drive is less than the
> kernel's SCSI driver block device command timeout value. It's super
> important that the drive reports an explicit read failure before the
> read command is considered failed by the kernel. If the drive is
> still
> trying to do a read, and the kernel command timer times out, it'll
> just do a reset of the whole link and we lose the outcome for the
> hanging command. Upon explicit read error only, can Btrfs, or md
> RAID,
> know what device and physical sector has a problem, and therefore how
> to reconstruct the block, and fix the bad sector with a write of
> known
> good data.
> 
> smartctl -l scterc /device/

Seems to not work:

[root@cornelis ~]# for disk in /dev/sd{e..x}; do echo ${disk}; smartctl
-l scterc ${disk}; done
/dev/sde
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdf
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdg
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdh
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdi
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdj
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdk
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

Smartctl open device: /dev/sdk failed: No such device
/dev/sdl
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdm
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdn
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SCT Error Recovery Control command not supported

/dev/sdo
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdp
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdq
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdr
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sds
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdt
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SCT Error Recovery Control command not supported

/dev/sdu
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdv
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdw
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

/dev/sdx
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.16-arch1-1-ARCH]
(local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, 
www.smartmontools.org

SCT Error Recovery Control command not supported

> and
> cat /sys/block/sda/device/timeout

[root@cornelis ~]# cat /sys/block/sd{e..x}/device/timeout
30
30
30
30
30
30
cat: /sys/block/sdk/device/timeout: No such file or directory
30
30
30
30
30
30
30
30
30
30
30
30
30

> Only if SCT ERC is enabled with a value below 30, or if the kernel
> command timer is change to be well above 30 (like 180, which is
> absolutely crazy but a separate conversation) can we be sure that
> there haven't just been resets going on for a while, preventing bad
> sectors from being fixed up all along, and can contribute to the
> problem. This comes up on the linux-raid (mainly md driver) list all
> the time, and it contributes to lost RAID all the time. And arguably
> it leads to unnecessary data loss in even the single device
> desktop/laptop use case as well.
> 
> 
> Chris Murphy

