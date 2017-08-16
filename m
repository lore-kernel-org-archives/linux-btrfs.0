Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.arhont.com ([178.248.108.132]:50401 "EHLO mail.arhont.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751068AbdHPJCR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 05:02:17 -0400
Date: Wed, 16 Aug 2017 10:02:17 +0100 (BST)
From: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Marat Khalili <mkh@rqc.ru>, linux-btrfs@vger.kernel.org
Message-ID: <4669553.344.1502874134710.JavaMail.gkos@dynomob>
In-Reply-To: <064eaaed-7748-7064-874e-19d270d0854e@profihost.ag>
References: <eab2f725-ab6e-d2ac-30e1-d9c964ce8be8@profihost.ag> <4772c3f2-0074-d86f-24c4-02ff0730fce7@rqc.ru> <064eaaed-7748-7064-874e-19d270d0854e@profihost.ag>
Subject: Re: slow btrfs with a single kworker process using 100% CPU
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Could be similar issue as what I had recently, with the RAID5 and 256kb chunk size.

please provide more information about your RAID setup.

p.s.
you can also check the tread "Btrfs + compression = slow performance and high cpu usage"

----- Original Message -----
From: "Stefan Priebe - Profihost AG" <s.priebe@profihost.ag>
To: "Marat Khalili" <mkh@rqc.ru>, linux-btrfs@vger.kernel.org
Sent: Wednesday, 16 August, 2017 10:37:43 AM
Subject: Re: slow btrfs with a single kworker process using 100% CPU

Am 16.08.2017 um 08:53 schrieb Marat Khalili:
>> I've one system where a single kworker process is using 100% CPU
>> sometimes a second process comes up with 100% CPU [btrfs-transacti]. Is
>> there anything i can do to get the old speed again or find the culprit?
> 
> 1. Do you use quotas (qgroups)?

No qgroups and no quota.

> 2. Do you have a lot of snapshots? Have you deleted some recently?

1413 Snapshots. I'm deleting 50 of them every night. But btrfs-cleaner
process isn't running / consuming CPU currently.

> More info about your system would help too.
Kernel is OpenSuSE Leap 42.3.

btrfs is mounted with
compress-force=zlib

btrfs is running as a raid0 on top of 4 md raid 5 devices.

Greets,
Stefan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
