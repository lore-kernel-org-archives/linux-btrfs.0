Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BA5C001DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Jul 2023 18:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbjG1Sw3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Jul 2023 14:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbjG1Sw1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2023 14:52:27 -0400
Received: from ste-pvt-msa1.bahnhof.se (ste-pvt-msa1.bahnhof.se [213.80.101.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7FF2723
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2023 11:52:24 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTP id EA2403F9CA;
        Fri, 28 Jul 2023 20:52:21 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from ste-pvt-msa1.bahnhof.se ([127.0.0.1])
        by localhost (ste-pvt-msa1.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id N4MDG92cYg07; Fri, 28 Jul 2023 20:52:20 +0200 (CEST)
Received: by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTPA id 600FC3F9C1;
        Fri, 28 Jul 2023 20:52:20 +0200 (CEST)
Received: from [192.168.0.132] (port=45232)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.96)
        (envelope-from <forza@tnonline.net>)
        id 1qPSZX-000B7I-1s;
        Fri, 28 Jul 2023 20:52:20 +0200
Date:   Fri, 28 Jul 2023 20:52:18 +0200 (GMT+02:00)
From:   Forza <forza@tnonline.net>
To:     Andrei Borzenkov <arvidjaar@gmail.com>,
        Stefan Malte Schumacher <s.schumacher@netcologne.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <ed04c54.104d2cbb.1899dd83132@tnonline.net>
In-Reply-To: <333b028f-a916-ccf9-8339-408b8963fd8e@gmail.com>
References: <CAA3ktqkR_hk++GpHM1oLUVto139oUOMLH92GPepQMA4M7-wdYQ@mail.gmail.com> <ec55663e-7655-a201-fc2c-6d64193e9fc7@gmail.com> <CAA3ktqmUXi3phYodmV7q8HQ4XvDvWo8q59z0UbR5TkQWcf5a=w@mail.gmail.com> <333b028f-a916-ccf9-8339-408b8963fd8e@gmail.com>
Subject: Re: Drives failures in irregular RAID1-Pool
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Mailer: R2Mail2
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



---- From: Andrei Borzenkov <arvidjaar@gmail.com> -- Sent: 2023-07-28 - 19:00 ----

> On 28.07.2023 18:26, Stefan Malte Schumacher wrote:
>> Thanks for the quick reply. Is there any way for me to validate if the
>> filesystem has redundant copies of all my files on different drives?
> 
> I can only think of "btrfs scrub".
> 
>> I read that it was suggested to do a full rebalance when adding a
>> drive to a RAID5 array. Should I do the same when adding a new disk to
>> my array?
>> 
> 
> I do not know where you read it and I cannot comment on something I have 
> not seen. But for RAID1 I do not see any reason to do it.

It may be needed if the layout becomes too unbalanced, else you may end up with no free space ENOSPC errors. 

There is also the size restrictions to think of when mixing different sizes. Use the btrfs size calculator to see if you end up with some unusable space with the sizes you have. 

https://carfax.org.uk/btrfs-usage/?c=2&slo=1&shi=1&p=0&dg=1&d=910&d=1273&d=1273&d=910&d=1637&d=910


> 
>> Yours sincerely
>> Stefan
>> 
>> Am Fr., 28. Juli 2023 um 17:22 Uhr schrieb Andrei Borzenkov
>> <arvidjaar@gmail.com>:
>>>
>>> On 28.07.2023 16:59, Stefan Malte Schumacher wrote:
>>>> Hello,
>>>>
>>>> I recently read something about raidz and truenas, which led to me
>>>> realizing that despite using it for years as my main file storage I
>>>> couldn't answer the same question regarding btrfs. Here it comes:
>>>>
>>>> I have a pool of harddisks of different sizes using RAID1 for Data and
>>>> Metadata. Can the largest drive fail without causing any data loss? I
>>>> always assumed that the data would be distributed in a way that would
>>>> prevent data loss regardless of the drive size, but now I realize I
>>>> have never experienced this before and should prepare for this
>>>> scenario.
>>>>
>>>
>>> RAID1 should store each data copy on a different drive, which means all
>>> data on a failed disk must have another copy on some other disk.
>>>
>>>> Total devices 6 FS bytes used 27.72TiB
>>>> devid    7 size 9.10TiB used 6.89TiB path /dev/sdb
>>>> devid    8 size 16.37TiB used 14.15TiB path /dev/sdf
>>>> devid    9 size 9.10TiB used 6.90TiB path /dev/sda
>>>> devid   10 size 12.73TiB used 10.53TiB path /dev/sdd
>>>> devid   11 size 12.73TiB used 10.54TiB path /dev/sde
>>>> devid   12 size 9.10TiB used 6.90TiB path /dev/sdc
>>>>
>>>> Yours sincerely
>>>> Stefan Schumacher
>>>
> 


