Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB087C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 23:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88BC320859
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 23:28:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="isIfIfc1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfAQX2g (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 18:28:36 -0500
Received: from mail.virtall.com ([46.4.129.203]:51850 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbfAQX2g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 18:28:36 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 6C31B4FA95D
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 23:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1547767714;
        bh=pfDHZBT1/V2thcJHjUUQ89U12COLhHepKfFY52WsMv8=;
        h=Date:From:To:Subject;
        b=isIfIfc13hNIYNBDtVJoKijCsjUJTKC8LD1QyO6gddv/6/OFqWQSKuXPrho/FM7U2
         THqLNF18hboZxd9/zZsVclt63yLHdhdYdnu2t1yFkBGcQWCqBkCCBJnbR3M1sgty/O
         N5pu0OEJo3eyNrebGmEp0/ESGev1wyPG/PtpcmHp4h4CP6+IprYUq/ABqEFIFIeUlF
         t26eCkzggHtO29CyXp2g6g9E6kySpFlJ/AHiXivX653i9GUe5CFygufLPHNpjQPd2Z
         3zClFk0Qu9gbozMKsRXUPpkGqYAF8DekBJRgVXpUa621nh9szH5zXhOma+tflFSb+g
         BwBavctlR2XbA==
X-Fuglu-Suspect: 7349c2a113124cf3a0ae3697bb5bee34
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 23:28:33 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 18 Jan 2019 08:28:30 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     linux-btrfs@vger.kernel.org
Subject: Re: question about creating a raid10
Message-ID: <80ef8767a6a5fc0477559732cf18ecb8@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> It is actually more like RAID-1E which is supported by some hardware
> RAID HBA. The difference is that RAID-1E is usually using strict
> sequential block placement algorithm and assumes disks of equal size,
> while btrfs raid10 is more flexible in selecting where next mirror pair
> is allocated.

s/flexible/random/

In sense, with btrfs, you can't really choose where the blocks are 
allocated, that's not really the definition of "flexible"?
