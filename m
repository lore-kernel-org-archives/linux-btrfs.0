Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34331 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424744AbdEYRz5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 13:55:57 -0400
Received: by mail-qt0-f195.google.com with SMTP id l39so31126051qtb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 25 May 2017 10:55:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1950765.ANvucQrkZu@localhost.localdomain>
References: <20170520184039.31362-1-nefelim4ag@gmail.com> <20170520184039.31362-3-nefelim4ag@gmail.com>
 <1950765.ANvucQrkZu@localhost.localdomain>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 25 May 2017 20:55:14 +0300
Message-ID: <CAGqmi740CEC4EzTaPGdYACR8RQmQFaqyRCahx1oEWuYa_9YtAQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Btrfs: compression must free at least PAGE_SIZE
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Roman Mamedov <rm@romanrm.net>,
        Duncan <1i5t5.duncan@cox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-05-25 15:51 GMT+03:00 Chandan Rajendra <chandan@linux.vnet.ibm.com>:
...
> Apologies for the delayed response.
>
> I am not really sure if compression code must save atleast one sectorsize
> worth of space. But if other developers agree to it, then the above
> 'if' condition can be replaced with,
>
> u32 sectorsize = btrfs_inode_sectorsize(mapping->host);
> ...
> ...
>
> if (tot_out + sectorsize > tot_in) {
> --
> chandan
>

Thanks a lot!
This approach much simplier then i imagined, i will update patch set and resend.

Thank you!
-- 
Have a nice day,
Timofey.
