Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-wd.italiaonline.it ([212.48.13.167]:36518 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751090AbdIMRwo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 13:52:44 -0400
Reply-To: kreijack@inwind.it
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Marat Khalili <mkh@rqc.ru>
Cc: Chris Murphy <lists@colorremedies.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
 <CAJCQCtTEJXvTS=YzUrwYvg7KCisgwLVYqu_Jb9-95sYswAspXg@mail.gmail.com>
 <d64202f0-c598-f98a-fcb4-a42b112c9024@rqc.ru>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <da267f70-4b7f-89b9-380b-d49e9a839099@libero.it>
Date: Wed, 13 Sep 2017 19:52:40 +0200
MIME-Version: 1.0
In-Reply-To: <d64202f0-c598-f98a-fcb4-a42b112c9024@rqc.ru>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/13/2017 04:15 PM, Marat Khalili wrote:
> On 13/09/17 16:23, Chris Murphy wrote:
>> Right, known problem. To use o_direct implies also using nodatacow (or
>> at least nodatasum), e.g. xattr +C is set, done by qemu-img -o
>> nocow=on
>> https://www.spinics.net/lists/linux-btrfs/msg68244.html
> Can you please elaborate? I don't have exactly the same problem as described by the link, but I'm still worried that particularly qemu can be less resilient to partial raid1 failures even on newer kernels, due to missing checksums for instance. (BTW I didn't find any xattrs on my VM images, nor do I plan to set any.)

>From what Josef Bacik wrote, I understood that it is not only related to RAID1. I tried to ask further clarifications without success :(

It seems that simply using O_DIRECT could allow checksums mismatch. My understand is that to avoid to copy the data between buffer, the checksum computation is subject to data race: i.e. it is possible that the kernel computes the checksum *and* the user space program change the data. 
This lead to an io error during a subsequent read.

To avoid that BTRFS should copy in a temporary buffer the data, and then compute the checksum. But this is what the common sense suggest that O_DIRECT should avoid.

If I understood correctly (which is a BIG if), i think that O_DIRECT should be unsupported (i.e. return -EINVAL) if the file is "not marked" as "nodatacsum"

I looked to what ZFSOL does: it seems that it doesn't support O_DIRECT [1] for the same reason (see the comments ' ryao commented on Jul 23, 2015' for further details).

Anyway I suggest to read what the open(2) man page says about O_DIRECT: it seems that O_DIRECT has to be used carefully when doing fork; the man page concludes:
[...]
In  summary,  O_DIRECT  is  a  potentially powerful tool that should be used with caution.  It is recommended that applications treat use of O_DIRECT as a performance option which is disabled by default.
[...]

[1] https://github.com/zfsonlinux/zfs/issues/224


> 
> -- 
> 
> With Best Regards,
> Marat Khalili
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
