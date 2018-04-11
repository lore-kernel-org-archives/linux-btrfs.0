Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:37737 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751633AbeDKXZV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 19:25:21 -0400
Subject: Re: btrfs fails to mount after power outage
To: Tom Vincent <tom@tlvince.com>, linux-btrfs@vger.kernel.org
References: <CAG4vCreOmBdsPT84ajozGb4XV83+Fc-joyUqXgizutPah0VrrA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <db34f571-2a31-5a0a-9f8d-e55a9b579753@gmx.com>
Date: Thu, 12 Apr 2018 07:25:15 +0800
MIME-Version: 1.0
In-Reply-To: <CAG4vCreOmBdsPT84ajozGb4XV83+Fc-joyUqXgizutPah0VrrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月11日 23:33, Tom Vincent wrote:
> My btrfs laptop had a power outage and failed to boot with "parent
> transid verify failed..." errors. (I have backups).

Metadata corruption, again.

I'm curious about what's the underlying disk?
Is it plain physical device? Or have other layers like bcache/lvm?

And what's the physical device? SSD or HDD? Vendor info is also helpful
here.
(Intel 600P used to have problem with XFS, not sure if it will affect btrfs)

> 
> I couldn't rw mount on a live disk, but could ro mount. I tried btrfs
> scrub and then btrfs check --repair to no avail. However, btrfs rescue
> zero-log _did_ work; the drive can be rw mounted and the machine boots
> fine again.
> 
> Although there doesn't appear to be an immediate data loss, there's
> still a transid error during boot. "BTRFS error (device dm-0): parent
> transid verify failed on 115490816 wanted 339949 found 340182".
> 
> If I umount and re-run btrfs check, I'm given further transid errors
> and pages of "inode [n] errors 2001, no inode item, link count wrong".

Full output please.

> 
> What steps should I take now?

For transid error, btrfs check --repair can fix it, but only do it when
that's the only problem.

Thanks,
Qu

> 
> btrfs progs 4.15
> kernel 4.15.15
> NVMe drive
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
