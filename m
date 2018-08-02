Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f169.google.com ([209.85.208.169]:38023 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbeHBMFt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2018 08:05:49 -0400
Received: by mail-lj1-f169.google.com with SMTP id p6-v6so1435413ljc.5
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2018 03:15:19 -0700 (PDT)
Subject: Re: BTRFS and databases
To: Martin Steigerwald <martin@lichtvoll.de>, Hugo Mills <hugo@carfax.org.uk>
Cc: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
 <20180801085602.GC7524@carfax.org.uk> <2861903.YXSMuvecdq@merkaba>
From: ein <ein.net@gmail.com>
Message-ID: <097d723a-5bc3-1256-d7ac-a493c55e974b@gmail.com>
Date: Thu, 2 Aug 2018 12:15:16 +0200
MIME-Version: 1.0
In-Reply-To: <2861903.YXSMuvecdq@merkaba>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/02/2018 11:16 AM, Martin Steigerwald wrote:
> However I wonder: Is this it? Is there nothing that can be improved in 
> BTRFS to handle database and VM files in a better way, without altering 
> any default settings?

Poor performance is not the biggest BTRFS problem, it's known for silent data corruption for
instance when using KVM with cache=none,aio=native, error counters are worthless too and do not
increment in case of csum mismatches. Performance penalty is huge, iowait for 4x SSD on RAID10 with
BTRFS is the same like when using RAID1 on 2xSAS with Ext4 for firebird database ~ 20GB which can
fit as a whole in RAM for better read performance.
