Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37907 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbKAN6T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Nov 2015 08:58:19 -0500
Received: by wicll6 with SMTP id ll6so35418919wic.1
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2015 05:58:18 -0800 (PST)
Received: from [10.0.2.15] (p50887086.dip0.t-ipconnect.de. [80.136.112.134])
        by smtp.googlemail.com with ESMTPSA id v9sm17103042wjv.45.2015.11.01.05.58.17
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Nov 2015 05:58:17 -0800 (PST)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Subject: Re: Crash during mount -o degraded, kernel BUG at
 fs/btrfs/extent_io.c:2044
To: linux-btrfs@vger.kernel.org
References: <n0bqib$2om$1@ger.gmane.org> <5635140F.7040206@googlemail.com>
 <5635508A.4080401@googlemail.com>
 <pan$a7ff8$b9ccf1a9$e2bf7f07$68b37eec@cox.net>
Message-ID: <56361A79.7000301@googlemail.com>
Date: Sun, 1 Nov 2015 14:58:17 +0100
MIME-Version: 1.0
In-Reply-To: <pan$a7ff8$b9ccf1a9$e2bf7f07$68b37eec@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 11/01/2015 04:22 AM, Duncan wrote:
> So what btrfs is logging to dmesg on mount here, are the historical error
> counts, in this case expected as they were deliberate during your test,
> nearly 200K of them, not one or more new errors.
>
> To have btrfs report these at the CLI, use btrfs device stats.  To zero

Thanks for clarifying. I forgot to check btrfs dev stats. That explains it.

The 2-drive failure scenario still caused data corruption with 4.3-rc7 
though.


Philip
