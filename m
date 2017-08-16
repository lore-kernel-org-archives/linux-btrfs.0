Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:53309 "EHLO
        smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750904AbdHPGxX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 02:53:23 -0400
Subject: Re: slow btrfs with a single kworker process using 100% CPU
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <eab2f725-ab6e-d2ac-30e1-d9c964ce8be8@profihost.ag>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <4772c3f2-0074-d86f-24c4-02ff0730fce7@rqc.ru>
Date: Wed, 16 Aug 2017 09:53:20 +0300
MIME-Version: 1.0
In-Reply-To: <eab2f725-ab6e-d2ac-30e1-d9c964ce8be8@profihost.ag>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I've one system where a single kworker process is using 100% CPU
> sometimes a second process comes up with 100% CPU [btrfs-transacti]. Is
> there anything i can do to get the old speed again or find the culprit?

1. Do you use quotas (qgroups)?

2. Do you have a lot of snapshots? Have you deleted some recently?

More info about your system would help too.

--

With Best Regards,
Marat Khalili

