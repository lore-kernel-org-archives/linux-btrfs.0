Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35633 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750747AbcIMMyQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 08:54:16 -0400
Received: by mail-qk0-f176.google.com with SMTP id t7so70644699qkh.2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 05:54:15 -0700 (PDT)
Message-ID: <1473771244.3639.2.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: Tue, 13 Sep 2016 09:54:04 -0300
In-Reply-To: <57D76FB0.4060908@cn.fujitsu.com>
References: <1471023419.16857.9.camel@gmail.com>
         <57D76FB0.4060908@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Em Ter, 2016-09-13 às 11:17 +0800, Wang Xiaoguang escreveu:
> It maybe a irrelevant question, but do you have compression enabled?
> 
> Regards,
> Xiaoguang Wang

No, I do not have compression enabled. I'm using openSUSE's default
configuration.

By the way, I was wrongly mounting the filesystem with `enospc_debug`.
It turns out that I modified the fstab in a backup directory, sorry :)
Now, I did it correctly so, hopefully, we will have much more
information about the problem the next time I see it!

Best regards,
Ronan Arraes
