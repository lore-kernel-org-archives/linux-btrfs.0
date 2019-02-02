Return-Path: <SRS0=C6pa=QJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB591C282D7
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Feb 2019 10:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C044B2084C
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Feb 2019 10:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfBBKFh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 2 Feb 2019 05:05:37 -0500
Received: from allchangeplease.de ([85.214.128.191]:37608 "EHLO
        mail.allchangeplease.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfBBKFh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2019 05:05:37 -0500
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Feb 2019 05:05:36 EST
Received: from [192.168.178.50] (dslb-088-065-025-078.088.065.pools.vodafone-ip.de [88.65.25.78])
        by mail.allchangeplease.de (Postfix) with ESMTPSA id 9FB5A5B050F
        for <linux-btrfs@vger.kernel.org>; Sat,  2 Feb 2019 10:59:38 +0100 (CET)
Subject: Re: RAID1 filesystem not mounting
To:     linux-btrfs@vger.kernel.org
References: <4ef8b545-efa8-43b0-8576-78c71bfb0e2c@www.fastmail.com>
From:   Bernhard K <hupf.vger@allchangeplease.de>
Message-ID: <35484d71-03c2-7102-abf3-9c13465baf0a@allchangeplease.de>
Date:   Sat, 2 Feb 2019 10:59:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <4ef8b545-efa8-43b0-8576-78c71bfb0e2c@www.fastmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 02.02.2019 05:28 Alan Hardman wrote:
> Also, "btrfs restore -Dv /dev/sdb /tmp" outputs some of the files on the filesystem but not all of them. I'm not sure if this is limited to the files on that physical disk, or if there's a bigger issue with the filesystem. I'm not sure what the best approach from here is, so any advice would be great.

You could check if some of the older tree roots yield a better result,
as described in
https://btrfs.wiki.kernel.org/index.php/Restore#Advanced_usage. In my
case I had to go back 2 generations to get a suitable file list.

I am not an expert though and am only recommending this as to my
understanding, btrfs restore and btrfs-find-root are non-destructive to
the original file system.


