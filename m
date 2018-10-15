Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37794C04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 15:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3A57208D9
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 15:48:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3A57208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbeJOXeF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 19:34:05 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52667 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbeJOXeF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 19:34:05 -0400
Authentication-Results: auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id 15B993CF3DB;
        Mon, 15 Oct 2018 17:48:16 +0200 (CEST)
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     Hugo Mills <hugo@carfax.org.uk>,
        Anton Shepelev <anton.txt@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Interpreting `btrfs filesystem show'
Date:   Mon, 15 Oct 2018 17:48:15 +0200
Message-ID: <20001436.sb0dmY2reh@merkaba>
In-Reply-To: <20181015142641.GD9538@carfax.org.uk>
References: <20181015172408.1b3867debea3951fb7014ee4@gmail.com> <20181015142641.GD9538@carfax.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hugo Mills - 15.10.18, 16:26:
> On Mon, Oct 15, 2018 at 05:24:08PM +0300, Anton Shepelev wrote:
> > Hello, all
> > 
> > While trying to resolve free space problems, and found that
> > 
> > I cannot interpret the output of:
> > > btrfs filesystem show
> > 
> > Label: none  uuid: 8971ce5b-71d9-4e46-ab25-ca37485784c8
> > Total devices 1 FS bytes used 34.06GiB
> > devid    1 size 40.00GiB used 37.82GiB path /dev/sda2
> > 
> > How come the total used value is less than the value listed
> > for the only device?
> 
>    "Used" on the device is the mount of space allocated. "Used" on the
> FS is the total amount of actual data and metadata in that
> allocation.
> 
>    You will also need to look at the output of "btrfs fi df" to see
> the breakdown of the 37.82 GiB into data, metadata and currently
> unused.

I usually use btrfs fi usage -T, cause

1. It has all the information.

2. It differentiates between used and allocated.

% btrfs fi usage -T /
Overall:
    Device size:                 100.00GiB
    Device allocated:             54.06GiB
    Device unallocated:           45.94GiB
    Device missing:                  0.00B
    Used:                         46.24GiB
    Free (estimated):             25.58GiB      (min: 25.58GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:               70.91MiB      (used: 0.00B)

                            Data     Metadata  System              
Id Path                     RAID1    RAID1     RAID1    Unallocated
-- ------------------------ -------- --------- -------- -----------
 2 /dev/mapper/msata-debian 25.00GiB   2.00GiB 32.00MiB    22.97GiB
 1 /dev/mapper/sata-debian  25.00GiB   2.00GiB 32.00MiB    22.97GiB
-- ------------------------ -------- --------- -------- -----------
   Total                    25.00GiB   2.00GiB 32.00MiB    45.94GiB
   Used                     22.38GiB 754.66MiB 16.00KiB  


For RAID it in some place reports the raw size and sometimes the logical 
size. Especially in the "Total" line I find this a bit inconsistent. 
"RAID1" columns show logical size, "Unallocated" shows raw size.

Also "Used:" in the global section shows raw size and "Free 
(estimated):" shows logical size.

Thanks
-- 
Martin


