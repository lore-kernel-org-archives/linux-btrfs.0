Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34776 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753551AbdEMSvh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 May 2017 14:51:37 -0400
Received: by mail-lf0-f41.google.com with SMTP id 99so14844278lfu.1
        for <linux-btrfs@vger.kernel.org>; Sat, 13 May 2017 11:51:37 -0700 (PDT)
Subject: Re: Creating btrfs RAID on LUKS devs makes devices disappear
To: Ochi <ochi@arcor.de>
References: <2f1e52d4-ca30-3623-1ea7-a046bee18bda@gmail.com>
 <161080bd-1a3f-180f-3119-ccf8fde4a498@arcor.de>
Cc: linux-btrfs@vger.kernel.org
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <633cf76e-7456-555b-9e0d-badf1bcb93bb@gmail.com>
Date: Sat, 13 May 2017 21:51:34 +0300
MIME-Version: 1.0
In-Reply-To: <161080bd-1a3f-180f-3119-ccf8fde4a498@arcor.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

13.05.2017 18:28, Ochi пишет:
> Hello,
> 
> okay, I think I now have a repro that is stupidly simple, I'm not even
> sure if I overlook something here. No multi-device btrfs involved, but
> notably it does happen with btrfs, but not with e.g. ext4.
> 

I could not reproduce it with single device but I finally was able to
reliably reproduce your problem with multiple devices. It looks a bit
different, I think difference is due to encrypted root in your case. Anyway

https://github.com/systemd/systemd/issues/5955

