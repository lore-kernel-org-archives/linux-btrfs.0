Return-Path: <SRS0=i+/l=3O=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3741CC2D0DB
	for <linux-btrfs@archiver.kernel.org>; Sat, 25 Jan 2020 16:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A525E2070A
	for <linux-btrfs@archiver.kernel.org>; Sat, 25 Jan 2020 16:03:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=urbackup.org header.i=@urbackup.org header.b="U5zSW/AK";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="fKRtfMFJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgAYQBw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 11:01:52 -0500
Received: from a4-15.smtp-out.eu-west-1.amazonses.com ([54.240.4.15]:39092
        "EHLO a4-15.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbgAYQBv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Jan 2020 11:01:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ob2ngmaigrjtzxgmrxn2h6b3gszyqty3; d=urbackup.org; t=1579968109;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=bsrYsUD0BEJorfYM4DsvtbgmL7urTm7UhDrPEbThpeI=;
        b=U5zSW/AKdPB3Jwm2MwL+RPnwCNeCP4b4uZ5dYII7Ko/waZK+AkchqiOwl6n1KKXS
        CiDdR+8KZfFn7mdJUb45vCj6xwQxvFqSNU2fybnZvf3U0eQZM1O4nvUSatqG0mbRPtT
        8z5ebqDamwUfjUG2IYUFps8hLbIlWRJGIPo+vERc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ihchhvubuqgjsxyuhssfvqohv7z3u4hn; d=amazonses.com; t=1579968109;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=bsrYsUD0BEJorfYM4DsvtbgmL7urTm7UhDrPEbThpeI=;
        b=fKRtfMFJSeTmsj9O2tIRz18j1QNQ8/gPdxI7MQ4z9sQigqaCBiQon09RlY2oY6uW
        Q8rJW10d2Y56yX8R/3gd/DzcQDtMslrMHmwi6z29eddJW94WPJN4cTnzt0yYFsei5pd
        Dpw1H/JytC+nHpRhr5b/BN7kbTzG+PnXh4L88AZM=
Subject: Re: tree first key mismatch detected (reproducible error)
To:     Thorsten Hirsch <t.hirsch@web.de>, linux-btrfs@vger.kernel.org
References: <CAH+WbHxsOEt9Z7t=ubtCmoCb2f4nDpMCCSXnT+-k5oR2pQFpOQ@mail.gmail.com>
 <688e0961-c80e-4db0-bf87-dabbfc72adf1@gmail.com>
 <71251506-88e5-c481-abdf-56dcd625b139@gmx.com>
 <CAH+WbHyYpP0ACzc+USAvwQU5SSaTbMLXbQRsc=mUWdCk23LQQg@mail.gmail.com>
From:   Martin Raiber <martin@urbackup.org>
Message-ID: <0102016fdd701abe-0f9b4c13-9f43-4b31-af0e-fa115edb3d69-000000@eu-west-1.amazonses.com>
Date:   Sat, 25 Jan 2020 16:01:49 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CAH+WbHyYpP0ACzc+USAvwQU5SSaTbMLXbQRsc=mUWdCk23LQQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-SES-Outgoing: 2020.01.25-54.240.4.15
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 25.01.2020 16:44 Thorsten Hirsch wrote:
> Thanks, guys.
>
> However, checking the RAM with memtest86 hasn't revealed any errors.
> Currently I let it run another pass, but so far everything's good.
> Here's the output of btrfs check...

just from my experience with non-ECC RAM:
When I had RAM corruption it only occurred after a few days of uptime
and only when I ran memtester on Linux. memtest86/memtest86+ didn't show
any problems even when running for a week (and in multi cpu mode).

> [1/7] checking root items
> [2/7] checking extents
> leaf parent key incorrect 109690880
> bad block 109690880
> ERROR: errors found in extent allocation tree or chunk allocation
> [3/7] checking free space cache
> [4/7] checking fs roots
> root 5 inode 3583162 errors 1040, bad file extent, some csum missing
> root 5 inode 3767022 errors 1040, bad file extent, some csum missing
> root 5 inode 3819591 errors 1040, bad file extent, some csum missing
> root 5 inode 4108194 errors 1040, bad file extent, some csum missing
> ERROR: errors found in fs roots
> Opening filesystem to check...
> Checking filesystem on /dev/nvme0n1p3
> UUID: 26717c9f-df62-4c57-a482-b9e4880b31e6
> found 6132469760 bytes used, error(s) found
> total csum bytes: 0
> total tree bytes: 4161536
> total fs tree bytes: 0
> total extent tree bytes: 3850240
> btree space waste bytes: 1115823
> file data blocks allocated: 108003328
>  referenced 108003328
>

