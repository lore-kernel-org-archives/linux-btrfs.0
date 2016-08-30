Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:36671 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757333AbcH3MuL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 08:50:11 -0400
Received: by mail-qk0-f181.google.com with SMTP id l2so16760231qkf.3
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2016 05:50:11 -0700 (PDT)
Message-ID: <1472561404.3179.3.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: Tue, 30 Aug 2016 09:50:04 -0300
In-Reply-To: <57C4EB85.7030000@cn.fujitsu.com>
References: <1471023419.16857.9.camel@gmail.com>
         <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
         <57C4EB85.7030000@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Em Ter, 2016-08-30 às 10:12 +0800, Wang Xiaoguang escreveu:
> For metadata, "bytes_may_use" is about 80GB, it's very big,
> I think this value is very abnormal.
> 
> So this explains why you have huge unallocated space, you still
> get ENOSPC error. In kernel btrfs, there is a function
> should_alloc_chunk()
> to determine whether to allocate new chunks(new device space)
>   num_bytes = total_bytes - bytes_readonly; it's 2147483648
>   num_allocated = bytes_used + bytes_reserved; it's 977354752
> 
> if num_allocated < num_bytes * 0.8, it will not allocate new device 
> space :) even you
> have huge unallocated space.
> 
> I think the root reason is that bytes_may_use has some computation
> error and
> is not be converted to bytes_used or bytes_reserved.
> 
> I just explain why you get ENOSPC error even with huge unallocated
> space 
> from
> codes :)
> 

Thanks! At least we known why ENOSPC is happening.

> Can you work out a reproducer for this ENOSPC error, then I can
> dig into codes to figure out the true reason.

Unfortunately I failed in every attempt to trigger the problem. It
happens randomly and I could not figure out yet what was triggering it.
First, I though it was related to a build process inside a chroot jail,
but then I see the problem happening after the computer being idle for
a long time (+- 1h). So, no clues yet :(

Is there any workaround I can do?

Best regards,
Ronan Arraes


