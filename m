Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E52C65BAE
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 09:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5520B214C1
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 09:33:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netcologne.de header.i=@netcologne.de header.b="SFsLdGwr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5520B214C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=netcologne.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbeLCJdd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 04:33:33 -0500
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:43344 "EHLO
        cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbeLCJbr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 04:31:47 -0500
Received: from cc-smtpin3.netcologne.de (cc-smtpin3.netcologne.de [89.1.8.203])
        by cc-smtpout2.netcologne.de (Postfix) with ESMTP id 703EA126F8
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Dec 2018 10:31:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=netcologne.de;
        s=nc1116a; t=1543829490;
        bh=9xx4wxLDSIGqLAYhOj7r5Yq1XUZ/6P1tLoaOdmVaD2M=;
        h=From:Date:Message-ID:Subject:To:From;
        b=SFsLdGwrA59hL6Ywwgr68I/PFdW4miGvuUmRrOpgKhZRyX7syPrNwnx04UPStRg1e
         4ScQaAh4qkHEThTtSuAY/aiOCcH6xc0vZ2C0QdhMck4lMdSYJaxZeZWCrVHhtoJnfD
         9bVd7MATt7W8gGITYMSgy5uZnDVvuArzcTle3MQ8aKq9V04CzXVEb7FUAyztedAb0h
         eGuJ6fW5+84x5Qep6W/hep+wsus8/IuWgYhuAXy8QYm/CZqLYwa+UOCfILs6iIJ+q4
         /o0Ww341+syUXEm4AWi8PqgOQZWBtva1iDDSD8gNBQ853JGBwa3UUfw/IKGLPfkgu3
         1TzKg074tVXMw==
Received: from localhost (localhost [127.0.0.1])
        by cc-smtpin3.netcologne.de (Postfix) with ESMTP id 6AFD111ECA
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Dec 2018 10:31:30 +0100 (CET)
Received: from [209.85.221.175] (helo=cc-smtpin3.netcologne.de)
        by localhost with ESMTP (eXpurgate 4.6.0)
        (envelope-from <s.schumacher@netcologne.de>)
        id 5c04f7f2-0bea-7f0000012729-7f000001e144-1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 10:31:30 +0100
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by cc-smtpin3.netcologne.de (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Dec 2018 10:31:30 +0100 (CET)
Received: by mail-vk1-f175.google.com with SMTP id b18so2728814vke.2
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 01:31:30 -0800 (PST)
X-Gm-Message-State: AA+aEWYHK7d64Yloo92JCM2Ilf5xVH9NRhwOfCS781R7XpiDvNxmD6+g
        9JfoicNhxHDXl2rhUPLOw5mAo91GpsilYYV4aDo=
X-Google-Smtp-Source: AFSGD/VfoFIrHRL7d3vtEicuKgHLJlDfQdrsL5Ay9w+Ma82DPjUor4R2ygCpCFqHysAgzHCL77Jnu05Gvl5q+v8eW9g=
X-Received: by 2002:a1f:bfc6:: with SMTP id p189mr6557898vkf.83.1543829489151;
 Mon, 03 Dec 2018 01:31:29 -0800 (PST)
MIME-Version: 1.0
From:   Stefan Malte Schumacher <s.schumacher@netcologne.de>
Date:   Mon, 3 Dec 2018 10:31:15 +0100
X-Gmail-Original-Message-ID: <CAA3ktqmXjF0AFjtL55798c7DyXmWewjXBtM_FNoktH1aAtRoNQ@mail.gmail.com>
Message-ID: <CAA3ktqmXjF0AFjtL55798c7DyXmWewjXBtM_FNoktH1aAtRoNQ@mail.gmail.com>
Subject: Filesystem Corruption
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I have noticed an unusual amount of crc-errors in downloaded rars,
beginning about a week ago. But lets start with the preliminaries. I
am using Debian Stretch.
Kernel: Linux mars 4.9.0-8-amd64 #1 SMP Debian 4.9.110-3+deb9u4
(2018-08-21) x86_64 GNU/Linux
BTRFS-Tools btrfs-progs  4.7.3-1
Smartctl shows no errors for any of the drives in the filesystem.

Btrfs /dev/stats shows zero errors, but dmesg gives me a lot of
filesystem related error messages.

[5390748.884929] Buffer I/O error on dev dm-0, logical block
976701312, async page read
This errors is shown a lot of time in the log.

This seems to affect just newly written files. This is the output of
btrfs scrub status:
scrub status for 1609e4e1-4037-4d31-bf12-f84a691db5d8
        scrub started at Tue Nov 27 06:02:04 2018 and finished after 07:34:16
        total bytes scrubbed: 17.29TiB with 0 errors

What is the probable cause of these errors? How can I fix this?

Thanks in advance for your advice
Stefan
