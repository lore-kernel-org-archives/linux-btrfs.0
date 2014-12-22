Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:41468 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbaLVQFl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 11:05:41 -0500
Received: by mail-yh0-f42.google.com with SMTP id v1so2414290yhn.1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 08:05:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANcfdL1f6evRNutMKpt_1qjBjvHTsx-i6Dgb5uEEjX2+hR0B-A@mail.gmail.com>
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
	<CAJCQCtQYhaDEic5bwd+PEcEfwOqLwAe8cT8VPZ9je+JLRP1GPw@mail.gmail.com>
	<CANcfdL1f6evRNutMKpt_1qjBjvHTsx-i6Dgb5uEEjX2+hR0B-A@mail.gmail.com>
Date: Mon, 22 Dec 2014 09:05:39 -0700
Message-ID: <CAJCQCtSC2i4-SZuxRaQR6rTCngxudyOLUEM_Au9yNtk1Lw9U5Q@mail.gmail.com>
Subject: Re: Uncorrectable errors on RAID-1?
From: Chris Murphy <lists@colorremedies.com>
To: constantine <costas.magnuse@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 22, 2014 at 7:28 AM, constantine <costas.magnuse@gmail.com> wrote:
> On Mon, Dec 22, 2014 at 12:24 AM, Chris Murphy <lists@colorremedies.com> wrote:
>> smartctl -l scterc /dev/sdX
>
> That's really good to know. My drives are desktop and this feature is
> not supported; hence, I get "SCT Error Recovery Control command not
> supported".
>
> I'll definitely go for enterprise/raid class drives that support this
> command in the future; they somehow seem more transparent (if I may
> say) in maintaining them.

Not knowing anything else, I'd say the kernel command timer should be
set to 121 in your case, for each drive. If you find evidence it can
be shorter, go with that. Bad sectors will fast fast, which is what
you want since you have mirrored data. Marginal sectors might take a
while for the firmware to either recover, or fail.

It's possible to mitigate long recoveries with a periodic balance, say
once every six months. This rewrites all data, and all sectors ought
to have a decently strong signal. Any sector with a persistent write
problem is removed from use automatically by drive firmware, but this
tends to require a write operation to trigger.

-- 
Chris Murphy
