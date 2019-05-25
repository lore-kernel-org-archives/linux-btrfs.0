Return-Path: <SRS0=xj9M=TZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A18AC282CE
	for <linux-btrfs@archiver.kernel.org>; Sat, 25 May 2019 13:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D75120863
	for <linux-btrfs@archiver.kernel.org>; Sat, 25 May 2019 13:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfEYNVv convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 25 May 2019 09:21:51 -0400
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:44945 "EHLO
        smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfEYNVv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 May 2019 09:21:51 -0400
Received: from [94.217.151.102] (helo=[192.168.177.20])
        by smtprelay03.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <hendrik@friedels.name>)
        id 1hUWcO-0007Gv-LN
        for linux-btrfs@vger.kernel.org; Sat, 25 May 2019 15:21:48 +0200
From:   "Hendrik Friedel" <hendrik@friedels.name>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Migration to BTRFS
Date:   Sat, 25 May 2019 13:21:43 +0000
Message-Id: <emde57e735-136a-4634-a2b5-95ce756b1f7b@ryzen>
In-Reply-To: <emb78b630a-c045-4f12-8945-66a237852402@ryzen>
References: <emb78b630a-c045-4f12-8945-66a237852402@ryzen>
Reply-To: "Hendrik Friedel" <hendrik@friedels.name>
User-Agent: eM_Client/7.2.34062.0
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Df-Sender: aGVuZHJpa0BmcmllZGVscy5uYW1l
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello

now after the filesystem worked fine as a single drive for a while, I'd 
like to add the second device.

Status:
btrfs fi show .
Label: 'DataPool1' uuid: c4a6a2c9-5cf0-49b8-812a-0784953f9ba3
         Total devices 1 FS bytes used 6.61TiB
         devid 1 size 7.28TiB used 6.89TiB path /dev/sdh1


>I intend to move to BTRFS and of course I have some data already.
>I currently have several single 4TB drives and I would like to move the Data onto new drives (2*8TB). I need no raid, as I prefer a backup. Nevertheless, having raid nice for availability. So why not in the end. I currently use ~6TB, so it may work, but I would be able to remove the redundancy later.
>
>So, if I understand correctly, today I want
>-m raid1 -d raid1
>
>whereas later, I want
>-m raid1 -d single
>
>What is very important to me is, that with one failing drive, I have no risk of losing the whole filesystem, but only losing the affected drive. Is that possible with both of these variants?

So, now I'd like to go this step:
-m raid1 -d raid1

Is it correct to:
btrfs device add /dev/sdd /srv/DataPool
btrfs balance start -dconvert=raid1 -mconvert=raid1

Or is there anything else, that I need to take care off?

There is not so much space left. Is it sufficient for the balance?

Regards,
Hendrik

