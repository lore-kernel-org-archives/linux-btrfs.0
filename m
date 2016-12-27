Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:33255 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbcL0J2d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Dec 2016 04:28:33 -0500
Received: by mail-wj0-f194.google.com with SMTP id kp2so50818692wjc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Dec 2016 01:28:32 -0800 (PST)
Received: from [10.2.2.44] (host74-184-static.96-5-b.business.telecomitalia.it. [5.96.184.74])
        by smtp.googlemail.com with ESMTPSA id i132sm54974838wmf.14.2016.12.27.01.28.30
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Dec 2016 01:28:31 -0800 (PST)
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file
 system during the snapshot receive
From: Giuseppe Della Bianca <g.dellabianca@gestiware.it>
To: linux-btrfs@vger.kernel.org
In-Reply-To: <CAJCQCtSZf+Z12HzhNHX8XMXZH4peNVQ=a_kbFJS3gUUKq=_T0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Dec 2016 10:29:06 +0100
Message-ID: <1482830946.3502.6.camel@localhost>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

Only for information.

I tried ' check_int ' mount option, but with a few tens of GB used, the
kernel freezes completely (no ops, no messages, no panic, none).


Thanks for all.

Gdb

P.S. Thanks and happy work to all.

>>On Wed, Dec 21, 2016 at 2:09 PM, Chris Murphy <li...@colorremedies.com> wrote:
>> What about CONFIG_BTRFS_FS_CHECK_INTEGRITY? And then using check_int
>> mount option?
>This slows things down, and in that case it might avoid the problem if
>it's the result of a race condition.

>-- 
>Chris Murphy
>--



