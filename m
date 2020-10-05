Return-Path: <SRS0=Lsqx=DM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5325C4363A
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Oct 2020 17:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BA9520796
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Oct 2020 17:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgJERJk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 13:09:40 -0400
Received: from cryptearth.de ([91.121.4.115]:48240 "EHLO cryptearth.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbgJERJk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Oct 2020 13:09:40 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2020 13:09:39 EDT
MIME-Version: 1.0
X-UserIsAuth: true
Received: from 2a0c:d242:3803:9400:ec14:863c:b9cb:c16f (EHLO [IPv6:2a0c:d242:3803:9400:ec14:863c:b9cb:c16f]) ([2a0c:d242:3803:9400:ec14:863c:b9cb:c16f])
          by cryptearth.de (JAMES SMTP Server ) with ESMTPA ID 1764098952
          for <linux-btrfs@vger.kernel.org>;
          Mon, 05 Oct 2020 18:59:27 +0200 (CEST)
To:     linux-btrfs@vger.kernel.org
From:   cryptearth <cryptearth@cryptearth.de>
Subject: using raid56 on a private machine
Message-ID: <dbf47c42-932c-9cf0-0e50-75f1d779d024@cryptearth.de>
Date:   Mon, 5 Oct 2020 18:59:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello there,

as I plan to use a 8 drive RAID6 with BtrFS I'd like to ask about the 
current status of BtrFS RAID5/6 support or if I should go with a more 
traditional mdadm array.

The general status page on the btrfs wiki shows "unstable" for RAID5/6, 
and it's specific pages mentions some issue marked as "not production 
ready". It also says to not use it for the metadata but only for the 
actual data.

I plan to use it for my own personal system at home - and I do 
understand that RAID is no replacement for a backup, but I'd rather like 
to ask upfront if it's ready to use before I encounter issues when I use it.
I already had the plan about using a more "traditional" mdadm setup and 
just format the resulting volume with ext4, but as I asked about that 
many actually suggested to me to rather use modern filesystems like 
BtrFS or ZFS instead of "old school RAID".

Do you have any help for me about using BtrFS with RAID6 vs mdadm or ZFS?

I also don't really understand why and what's the difference between 
metadata, data, and system. When I set up a volume only define RAID6 for 
the data it sets metadata and systemdata default to RAID1, but doesn't 
this mean that those important metadata are only stored on two drives 
instead of spread accross all drives like in a regular RAID6? This would 
somewhat negate the benefit of RAID6 to withstand a double failure like 
a 2nd drive fail while rebuilding the first failed one.

Any information appreciated.


Greetings from Germany,

Matt
