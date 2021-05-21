Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AA8C04FF3
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 May 2021 22:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED357613DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 May 2021 22:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhEUWE2 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 May 2021 18:04:28 -0400
Received: from pio-pvt-msa2.bahnhof.se ([79.136.2.41]:42526 "EHLO
        pio-pvt-msa2.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhEUWE0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 May 2021 18:04:26 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 May 2021 18:04:26 EDT
Received: from localhost (localhost [127.0.0.1])
        by pio-pvt-msa2.bahnhof.se (Postfix) with ESMTP id C128E3F8E7;
        Fri, 21 May 2021 23:53:43 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from pio-pvt-msa2.bahnhof.se ([127.0.0.1])
        by localhost (pio-pvt-msa2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wbbIP2hs_qy6; Fri, 21 May 2021 23:53:42 +0200 (CEST)
Received: by pio-pvt-msa2.bahnhof.se (Postfix) with ESMTPA id 8AA853F887;
        Fri, 21 May 2021 23:53:42 +0200 (CEST)
Received: from [192.168.0.126] (port=41226)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <forza@tnonline.net>)
        id 1lkD5R-0004Xj-IY; Fri, 21 May 2021 23:53:41 +0200
Date:   Fri, 21 May 2021 23:53:42 +0200 (GMT+02:00)
From:   Forza <forza@tnonline.net>
To:     Leszek Dubiel <leszek@dubiel.pl>, linux-btrfs@vger.kernel.org
Message-ID: <67da918.7deb9c64.17990eb7cf1@tnonline.net>
In-Reply-To: <efa44798-ff3e-0dc6-06fb-b5cbf6569d40@dubiel.pl>
References: <63123a58-18a4-24ff-3b30-9a0668c167c4@dubiel.pl> <89853f6.7deb9c63.179908e0b59@tnonline.net> <efa44798-ff3e-0dc6-06fb-b5cbf6569d40@dubiel.pl>
Subject: Re: Btrfs not using all devices in raid1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Mailer: R2Mail2
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



---- From: Leszek Dubiel <leszek@dubiel.pl> -- Sent: 2021-05-21 - 23:10 ----

> 
> 
>> Raid1 means two copies on different devices. This is fulfilled with the previous 3 drives so the  'soft' keyword is not going to help here. 
> 
> That's right.
> 
> 
> 
>> You can do a full data balance (-dusage=100) to move some data across to the new disk. There is no need to do a metadata balance in this case, unless you want to convert to raid1c3 to have three copies of metadata. 
> 
> 
> This is production server, and I don't want to do full balance, because it will hit performance for users.
> I hoped that when data gets written to filesysystem BTRFS will choose drive that has most free space, that is /dev/sdc2.
> 
> Is there any way to tell BTRFS to use /dev/sdc2?
> 
> 
> 
> 
>>  If you do nothing, the filesystem will eventually balance itself as you add abs delete data. 
> 
> 
> If I do nothing then /dev/sd{a,b,d}2 would get almost full, and only 
> after /dev/sdc2 would be used?
> 
> 

Btrfs will fill the disk with most unallocated space first.  So eventually they will end up almost equal. 

> 
> 
> Not using /dev/sdc2 is bad because:
> 
> -- maybe this drive is already failed, but nothing is written to it so I 
> have no reports of errors
> 
> -- other drives get all the data, so if one of them fails, then I will 
> have to take longer time to replace it
> 
> I would prefer to have all drives EQUAL in Raid1.
> 
> 
> 

You can run balance with filters to do a little at a time and only use blocks on the other disks. Look at devid and limit https://btrfs.wiki.kernel.org/index.php/Balance_filters




