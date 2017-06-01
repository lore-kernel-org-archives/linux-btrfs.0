Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:44262 "EHLO
        smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751097AbdFAT13 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Jun 2017 15:27:29 -0400
Received: from smtp10.relay.ord1c.emailsrvr.com (localhost [127.0.0.1])
        by smtp10.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id E01FC4021B
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Jun 2017 15:27:28 -0400 (EDT)
Received: by smtp10.relay.ord1c.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id 4C1BE402F0
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Jun 2017 15:27:28 -0400 (EDT)
Date: Thu, 01 Jun 2017 22:26:17 +0300
In-Reply-To: <CAGqmi755-pWkzROVcK1Qh2qa3-MQ6CbAFzAL85Lv0WVbjpBxFw@mail.gmail.com>
References: <CADtmLM88w-KH_SfoECB-N=PXwgvcswP6cyaBtypRHEEdPKZ1VA@mail.gmail.com> <CAGqmi755-pWkzROVcK1Qh2qa3-MQ6CbAFzAL85Lv0WVbjpBxFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: understanding differences in recoverability of raid1 vs raid10 and performance implications of unusual numbers of devices
To: linux-btrfs@vger.kernel.org
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <BEFDC957-ECEA-4EEF-9470-D2EA40C47F60@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>raid 1 write data on all disks synchronously all time, no tricks.
>btrfs raid1 read data by PID%2
>0 - first copy
>1 - second copy

Meaning, a single-process database will only ever read one copy? At least, meaning of first/second relative to physical devices depends on extent, right, right?
-- 

With Best Regards,
Marat Khalili
