Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33127 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755028AbcJRMlI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 08:41:08 -0400
Received: by mail-io0-f176.google.com with SMTP id q192so220439475iod.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 05:41:08 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id g76sm15491001iod.20.2016.10.18.05.41.06
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Oct 2016 05:41:06 -0700 (PDT)
Subject: Re: Monitoring Btrfs
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
 <CAJCQCtR97w1PDsMRSg_RkfjCL1J+ZTA4xAhMVZz1T-1JWwGiwA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e651a6d5-9d99-61f5-202b-95e37fae2ec8@gmail.com>
Date: Tue, 18 Oct 2016 08:41:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR97w1PDsMRSg_RkfjCL1J+ZTA4xAhMVZz1T-1JWwGiwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-10-17 16:40, Chris Murphy wrote:
> May be better to use /sys/fs/btrfs/<uuid>/devices to find the device
> to monitor, and then monitor them with blktrace - maybe there's some
> courser granularity available there, I'm not sure. The thing is, as
> far as Btrfs alone is concerned, a drive can be "bad" and you're
> effectively degraded, while the drive is not missing. Unless it's
> physical removed or somehow dead, it'll still be seen but can produce
> all kinds of mayhem.
This is exactly why you should be monitoring the disks themselves, not 
just BTRFS.  I would not advise using blktrace for monitoring in 
production though, it technically risks an information leak, and it's 
not exactly low impact.

