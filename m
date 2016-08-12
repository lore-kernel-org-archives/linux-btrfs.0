Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:36092 "EHLO
	mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbcHLPrO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Aug 2016 11:47:14 -0400
Received: by mail-qt0-f182.google.com with SMTP id 52so14271303qtq.3
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Aug 2016 08:47:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$302f2$7d1c6375$718b454d$bb3a6a2@cox.net>
References: <CAGj_d3D2OZt2nY622rp9NzxgAfKZ2iN1kLSQ2Ras-0fM+1+-ig@mail.gmail.com>
 <pan$302f2$7d1c6375$718b454d$bb3a6a2@cox.net>
From: Rakesh Sankeshi <rakesh.sankeshi@gmail.com>
Date: Fri, 12 Aug 2016 08:47:13 -0700
Message-ID: <CAGj_d3BTkO_cUJ2Lihi2dnD+oJUFTfqHeEBm2i2vVhS=1Y9MrQ@mail.gmail.com>
Subject: Re: btrfs quota issues
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your inputs.

Another question I had was, is there any way to check what's the
directory/file sizes prior to compression and how much copression
btrfs did, etc? Basicaly some stats around compression and/or dedupe
from btrfs.


On Thu, Aug 11, 2016 at 12:13 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Rakesh Sankeshi posted on Thu, 11 Aug 2016 10:32:03 -0700 as excerpted:
>
>> I set 200GB limit to one user and 100GB to another user.
>>
>> as soon as I reached 139GB and 53GB each, hitting the quota errors.
>> anyway to workaround quota functionality on btrfs LZO compressed
>> filesystem?
>
> The btrfs quota subsystem remains somewhat buggy and unstable.  A lot of
> work has gone into it to fix the problems, including rewrites of the
> entire subsystem, and it's much better than it used to be, but it's still
> a feature that I would recommend not using on btrfs.
>
> My general position is this.  Either you need quotas for your use-case or
> you don't.  If you truly need them, you're far better off using a more
> mature filesystem with proven quota subsystem reliability.  If you don't
> really need them, simply keep the feature off for now, and for however
> long it takes to stabilize the feature, which could be some time.
>
> Of course if you're specifically testing quotas in ordered to report
> issues and test bugfixes, that's a specific case of needing quota
> functionality, and your work is greatly appreciated as it'll help to
> eventually make that feature stable and workable for all. =:^)
>
>
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
