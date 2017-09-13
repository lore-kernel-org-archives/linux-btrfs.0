Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:46325 "EHLO
        smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751458AbdIMOUy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 10:20:54 -0400
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
 <CAJCQCtTEJXvTS=YzUrwYvg7KCisgwLVYqu_Jb9-95sYswAspXg@mail.gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <d64202f0-c598-f98a-fcb4-a42b112c9024@rqc.ru>
Date: Wed, 13 Sep 2017 17:15:09 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTEJXvTS=YzUrwYvg7KCisgwLVYqu_Jb9-95sYswAspXg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13/09/17 16:23, Chris Murphy wrote:
> Right, known problem. To use o_direct implies also using nodatacow (or
> at least nodatasum), e.g. xattr +C is set, done by qemu-img -o
> nocow=on
> https://www.spinics.net/lists/linux-btrfs/msg68244.html
Can you please elaborate? I don't have exactly the same problem as 
described by the link, but I'm still worried that particularly qemu can 
be less resilient to partial raid1 failures even on newer kernels, due 
to missing checksums for instance. (BTW I didn't find any xattrs on my 
VM images, nor do I plan to set any.)

--

With Best Regards,
Marat Khalili
