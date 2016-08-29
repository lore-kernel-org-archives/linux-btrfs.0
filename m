Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59436 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750786AbcH2GUZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 02:20:25 -0400
Subject: Re: Multiple bugs found by fuzzing BTRFS
To: Lukas Lueg <lukas.lueg@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CAJF-kYko=dSuCmxpj6uJmKRZtAOhYCzoK=8hoyqBAe5UA8nQUg@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <12b26fc1-4586-0cd1-8359-acf9ac5eb42f@cn.fujitsu.com>
Date: Mon, 29 Aug 2016 14:20:14 +0800
MIME-Version: 1.0
In-Reply-To: <CAJF-kYko=dSuCmxpj6uJmKRZtAOhYCzoK=8hoyqBAe5UA8nQUg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your fuzzing images.

Quite helpful.

At 08/29/2016 02:06 PM, Lukas Lueg wrote:
> Hi,
>
> I've now spent around 160 hours of fuzzing BTRFS, here are the crashes
> I found so far. Every type of crash is reported only once although
> there are usually multiple locations where they show up (especially
> heap-use-after-free and calls to abort()).
>
> The following bug reports have attached to them images of ±18kb which
> expand to 16mb and reproduce a crash when running btrfsck; they all
> have been revirginized so CRC- and FSID-checks pass by a vanilla
> btrfsck.
>
>
> Use-after-free, shows up all over the place:
> https://bugzilla.kernel.org/show_bug.cgi?id=153641
>
> Segfault in memcpy, yeah: https://bugzilla.kernel.org/show_bug.cgi?id=154021
>
> Run-off-the-mill buffer-overflow:
> https://bugzilla.kernel.org/show_bug.cgi?id=154961
>
> Endless loop in btrfsck: https://bugzilla.kernel.org/show_bug.cgi?id=155151
>
> Calls to abort() by lack of error paths:
> https://bugzilla.kernel.org/show_bug.cgi?id=155181
>
> Division by zero, the old problem of computing stripe_size:
> https://bugzilla.kernel.org/show_bug.cgi?id=155201

Digging, while it's a little different from the original one.

BTW, for btrfsck bugs, would you please also try the new low memory mode?
For example, the above image won't trigger bug in low memory mode.

Thanks,
Qu
>
>
> There are many more crashes like the above; how do you guys want them
> to be reported?
>
>
> Best regards
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


