Return-Path: <SRS0=swP/=RU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E386C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Mar 2019 20:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43FDE20857
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Mar 2019 20:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfCQUwX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 17 Mar 2019 16:52:23 -0400
Received: from europa.tomatom.cz ([87.236.196.214]:54720 "EHLO mail.tomatom.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbfCQUwV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Mar 2019 16:52:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.tomatom.cz (Postfix) with ESMTP id 478A412902C
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Mar 2019 20:54:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.tomatom.cz
Received: from mail.tomatom.cz ([127.0.0.1])
        by localhost (mail.tomatom.cz [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KxNyE9ewZDaF for <linux-btrfs@vger.kernel.org>;
        Sun, 17 Mar 2019 20:54:23 +0000 (UTC)
Received: from authenticated-user (mail.tomatom.cz [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: jakub@husak.pro)
        by mail.tomatom.cz (Postfix) with ESMTPSA id DE6FA129025
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Mar 2019 20:54:22 +0000 (UTC)
Authentication-Results: mail.tomatom.cz; dmarc=none header.from=husak.pro
Authentication-Results: mail.tomatom.cz; dkim=none reason="no signature";
        dkim-adsp=none (unprotected policy); dkim-atps=neutral
Subject: Re: Balancing raid5 after adding another disk does not move/use any
 data on it
To:     linux-btrfs@vger.kernel.org
References: <7a713010-5db6-2627-2593-8e13092868b1@husak.pro>
 <20190315180123.GJ9995@hungrycats.org>
 <3dce71e1-6caa-59ad-1765-6a29c7dd774f@knorrie.org>
 <aa4fc47e-2eee-de11-c73f-00d947f96dbf@gmail.com>
 <fa3b54fb-7473-810a-6ea6-8e5709d4e8e4@knorrie.org>
 <655523fa-1f32-3df2-bd10-29364447e3c9@knorrie.org>
From:   =?UTF-8?Q?Jakub_Hus=c3=a1k?= <jakub@husak.pro>
Message-ID: <f3082d89-ee37-b421-0bb3-ff2e28cc31af@husak.pro>
Date:   Sun, 17 Mar 2019 21:52:14 +0100
MIME-Version: 1.0
In-Reply-To: <655523fa-1f32-3df2-bd10-29364447e3c9@knorrie.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a great tool Hans!  This kind of overview should be a part of 
btrfs-progs.

Mine looks currently like this, I have a few more days to go with 
rebalancing :)

flags            num_stripes     physical      virtual
-----            -----------     --------      -------
DATA|RAID5                 3      5.29TiB      3.53TiB
DATA|RAID5                 4    980.00GiB    735.00GiB
SYSTEM|RAID1               2    128.00MiB     64.00MiB
METADATA|RAID1             2    314.00GiB    157.00GiB

Btw, I checked the other utils in your python-btrfs and it seems that 
they are, sadly, not installed with simple pip install, which would be 
great. Maybe it needs a few lines in setup.py (i'm not too familiar with 
python packaging)?


On 16. 03. 19 20:51, Hans van Kranenburg wrote:
> On 3/16/19 5:34 PM, Hans van Kranenburg wrote:
>> On 3/16/19 7:07 AM, Andrei Borzenkov wrote:
>>> [...]
>>> This thread actually made me wonder - is there any guarantee (or even
>>> tentative promise) about RAID stripe width from btrfs at all? Is it
>>> possible that RAID5 degrades to mirror by itself due to unfortunate
>>> space distribution?
>> For RAID5, minimum is two disks. So yes, if you add two disks and don't
>> forcibly rewrite all your data, it will happily start adding two-disk
>> RAID5 block groups if the other disks are full.
> Attached an example that shows a list of used physical and virtual space
> ordered by chunk type (== block group flags) and also num_stripes (how
> many disks (or, dev extents)) are used. The btrfs-usage-report does not
> add this level of detail. (But maybe it would be interesting to add, but
> then I would add it into the btrfs.fs_usage code...)
>
> For the RAID56 with a big mess of different block groups with different
> "horizontal size" this will be more interesting than what it shows here
> as test:
>
> -# ./chunks_stripes_report.py /
> flags            num_stripes     physical      virtual
> -----            -----------     --------      -------
> DATA                       1    759.00GiB    759.00GiB
> SYSTEM|DUP                 2     64.00MiB     32.00MiB
> METADATA|DUP               2      7.00GiB      3.50GiB
>
>
> Hans
