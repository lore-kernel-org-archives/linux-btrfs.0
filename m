Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EC6C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 13:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6BF520842
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 13:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dMt/k1ez"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfBYNDO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 08:03:14 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:35955 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbfBYNDO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 08:03:14 -0500
Received: by mail-it1-f194.google.com with SMTP id v83so1977875itf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 05:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HSq27D2tHHp7L8kBW2XdSSh13xvQg5oKyJrWFVMMIeA=;
        b=dMt/k1ezwcZf/OOqIkqnjkggXH77yFPP7oMufYLpjeJtx2RYQyGMn2ZxyAr9GsAGgo
         BB+O97ACQ2NFWIf+rz4cETHM+STidOX0IcFbWsLOj92RkGFY7mxaHpaIjvRS5BoIbMT/
         av8J6bPu1eSFKs+3vLwv+Et0s4WF5K2JOrv0/q5qPl7BK0YM8FU8RFhj44nxl57Tp3ay
         knsJ5BKBAWXeOdfrhXTrPVsV4hn4sEGXY2Ed16RTQ8zRHY65YchoJrRqAiwKCBZY6ZGW
         WaGNSp5I01TnJi0fX+JRUXipdGDsNCbfOTFRA4N+ihLh7K5CJyUrvlEh6hjJDTg9pozZ
         tQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HSq27D2tHHp7L8kBW2XdSSh13xvQg5oKyJrWFVMMIeA=;
        b=R+ZlH+w/8/IiL+P4chhcmA8N8Lp6YbKSVuleXjWywmzBzLwa1LfuUlA0E+lXEaj/4Q
         5cmBomnaUXke4azammyJLCbYozkKfBig04LPubLvIhlpA/bTHEaCyqRtSgaNBaPQ4Wdb
         1zkMyQ0+pLDuYEcxsFryWGbH1ZSfFgVDP0SwrqcBMm8oM076NU2A6GodGyfYsBnM6irC
         QlYL6+iMjRL3LqvgSsa6E3KXPz52MoMrx5xIu0z9wx5O4e4UGSdBzYKyObgDzE9sAUSC
         ywlcbLejRtvSRnK9jBg8KXJKh7lRIdhv8EhsiBvl+ZPaafdxSBHELuu+OJDB5If+ZJPl
         r5NA==
X-Gm-Message-State: AHQUAuZO7mEOc1OcQrx1Yz+ESV2qsY6ndKM1n4uuPN6CnKxdY5qRSh3C
        xPM8lJtPU4bHsrqBrewzqLJ9xv6WpCk=
X-Google-Smtp-Source: AHgI3IahrlDMgWFoQspmU4/DDxirLGvu8d2MQ8CMul1zS7X6gKWpPw1qYkDNKYe+wWvSYvqxZjH3/g==
X-Received: by 2002:a24:6983:: with SMTP id e125mr8873202itc.26.1551099792541;
        Mon, 25 Feb 2019 05:03:12 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id l19sm3506643iok.20.2019.02.25.05.03.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 05:03:11 -0800 (PST)
Subject: Re: RAID1 device deletion feedback
To:     Nemo <me@captnemo.in>, linux-btrfs@vger.kernel.org
References: <d1eac64c-056b-a95b-7890-875d313a7ab4@captnemo.in>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ad1585cf-20ca-b921-1d27-ffc50f0061e0@gmail.com>
Date:   Mon, 25 Feb 2019 08:03:09 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <d1eac64c-056b-a95b-7890-875d313a7ab4@captnemo.in>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-02-24 12:32, Nemo wrote:
> Hi,
> 
> I had a RAID1 disk failure recently, and a limitation in number of SATA
> connectors meant I could not do a live replace. I'm still in the
> progress of resolving the issue, but posting some feedback here on the
> issues I faced and what could have helped.
> 
> **What all I did**
> 
> - remove the dying disk and mount in degraded mode. This didn't work,
> but _didn't provide me a failure reason_
If you don't see a message on the console, check dmesg.

> - swap the dead disk post boot with the new one. Tried a btrfs device
> add, but it failed as well because of too many failing reads from the
> dead disk (which wasn't even attached).
You can take this approach, but you need to use the replace command not 
the add command.  You can't really add devices to a partial array, for 
exactly the reason you saw it fail here.  In the case of replacing a 
device that is missing, you want to do the following (though it only 
works if you have only one missing device):

     btrfs replace start -r missing /path/to/new/dev /path/to/fs

> - Started a btrfs device delete, which finally pointed me to the root
> cause:
> 
> `ERROR: error removing device '/dev/sdb1': No space left on device`

> 
> In short:
> 
> 1. My 2.7TBx3 setup was storing 2.9TB of data
> 2. Removing any one the disks was not possible without losing some data
> 
> However, getting to this error message took me hours of effort, despite
> having read the btrfs wiki.
> 
> **Feedback**
> 
> 1. The `btrfs device delete` command should have failed immediately
> instead of making me wait for ages.
I won't pretend that your statement isn't correct, but I can at least 
explain _why_ it didn't.

Put simply, the device delete command is a special case of a balance 
operation, and balancing doesn't do any check prior to running to make 
sure that the requested state is valid.  Part of this is that it's 
actually useful in some cases to just run the balance until it fails 
(because getting part of the work done is usually better than none), and 
part of it is because it is very much non-trivial in a number of the 
cases that balance needs to handle how the disk will look after running 
the balance if it's successful.

> 2. A delete command should stop writes to a disk, unless avoidable. This
> would have left some data on the disk, and a subsequent delete could
> have cleaned it up much faster. It failed in the worst manner possible,
> because all deletion progress reversed once it failed: it balanced back
> to complete usage, causing more strain on a dying disk.
It essentially operates currently in a manner similar to the LVM2 pvmove 
command WRT writes, just not as smart.  AFAIUI:

* Any writes that go to a chunk that is on the device to be removed 
still go through.
* Any writes that go to a chunk that is not on the device to be removed 
don't touch it.
* Any writes that go to the chunk currently being moved off of the 
device being removed go to the new location for that chunk.

> 3. A degraded mount failure should provide some error message.
Again, if you see a mount failure, check dmesg.  This is the case for 
pretty much any filesystem (hell, mount actually tells you to do this in 
a lot of cases).
> 
> *Status*: I cleared up some disk space, and ran another delete which is
> still ongoing. I don't have physical access to the system for a few more
> days, so adding the new disk will take me some time.
> 
> ---
> 
> ## Debug Details
> 
> 
> ```
> uname -a
> Linux tatooine.captnemo.in 4.20.10-arch1-1-ARCH #1 SMP PREEMPT Fri Feb
> 15 17:49:06 UTC 2019 x86_64 GNU/Linux
> 
> btrfs --version
> btrfs-progs v4.20.1
> ```
> 
> A few more details are on a reddit post[0] I made to help debug the
> issue and a gist[1] has disk usage and filesystem details.
> 
> [0]:
> https://www.reddit.com/r/archlinux/comments/asrlam/btrfscleaner_at_100_cpu_usage_on_raid1_setup/egwc047/
> [1]: https://paste.ubuntu.com/p/GDNKNBqqFy/
> 

