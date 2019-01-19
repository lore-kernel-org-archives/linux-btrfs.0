Return-Path: <SRS0=mgXs=P3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35832C61CE4
	for <linux-btrfs@archiver.kernel.org>; Sat, 19 Jan 2019 17:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06DBB2084F
	for <linux-btrfs@archiver.kernel.org>; Sat, 19 Jan 2019 17:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbfASRCL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 19 Jan 2019 12:02:11 -0500
Received: from mx23lb.world4you.com ([81.19.149.133]:33394 "EHLO
        mx23lb.world4you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfASRCK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 Jan 2019 12:02:10 -0500
X-Greylist: delayed 3307 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jan 2019 12:02:10 EST
Received: from [213.147.188.16] (helo=robbe)
        by mx23lb.world4you.com with esmtpa (Exim 4.91)
        (envelope-from <hans@hanswkraus.com>)
        id 1gkt9B-0004X1-ME
        for linux-btrfs@vger.kernel.org; Sat, 19 Jan 2019 17:07:02 +0100
Received: from [192.168.4.139] (unknown [192.168.4.139])
        by robbe (Postfix) with ESMTPS id 02BAF3424FD
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Jan 2019 17:07:01 +0100 (CET)
To:     Linux Btrfs <linux-btrfs@vger.kernel.org>
From:   Hans Kraus <hans@hanswkraus.com>
Subject: RAID 6 stable?
Message-ID: <c41a1da0-9986-413d-6b22-4183188fd8aa@hanswkraus.com>
Date:   Sat, 19 Jan 2019 17:07:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-Antivirus: Avast (VPS 190119-2, 19.01.2019), Outbound message
X-Antivirus-Status: Clean
X-AV-Do-Run: Yes
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

after a posting in the linux-btrfs mailing list I stumbled across
<https://btrfs.wiki.kernel.org/index.php/Project_ideas#Raid5.2F6>.

Does that mean that BTRFS RAID6 is free of known errors and ready for
deployment on data servers?

If not: is there an estimation (time-wise) when RAID6 is ready?

The background of my question: I have to rebuild my samba server which
ran out of storage. I'm using currently efs4 on top of mdadm RAID6.
I would prefer to rebuild it with BTRFS. I can postpone that rebuild
for some months.

A second question: the ZFS docu recommends very strongly to use ECC
memory on machines with ZFS RAID-Zn. Holds these arguments true for
BTRFS as well?

Kind regards,
Hans

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

