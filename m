Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36388 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752849AbdGNDSH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 23:18:07 -0400
Received: by mail-wm0-f50.google.com with SMTP id 62so8967194wmw.1
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 20:18:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <04d2fb90-1e6d-22f5-4943-2f16298e9cc4@gmx.com>
References: <CAJCQCtQiCcWZXhXo1nDt0qeGHr=WQH1cs8Syrbc9cXwez8ENjg@mail.gmail.com>
 <20170713223205.GB6181@lim.localdomain> <CAJCQCtSpJkVzH=jL7+1J2jHncCBxwFS_eDNs_q+q6uUdTG8DAQ@mail.gmail.com>
 <9a73851d-e4c7-f395-285e-5cf3e835c2b7@gmx.com> <CAMp4zn8YUdVShFibUKCXtwZTZpicCbmm7zSYMn7+K5CNt-cxGA@mail.gmail.com>
 <04d2fb90-1e6d-22f5-4943-2f16298e9cc4@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 13 Jul 2017 21:18:05 -0600
Message-ID: <CAJCQCtRyQBDWxxfC=cg51SP5Sp4=vcv21_pTbyj9Xh+FbtFF+w@mail.gmail.com>
Subject: Re: Containers, Btrfs vs Btrfs + overlayfs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Sargun Dhillon <sargun@sargun.me>, Chris Murphy <lists@colorremedies.com>,
        bo.li.liu@oracle.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 8:52 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

>
> Thanks for mentioning the underlying storage.
> SSD makes FUA overhead smaller, so with SSD the metadata CoW is less
> obvious.

Typically there are 2 or 3 superblocks. SSD mount option causes
rotation of superblock updates. I wonder the effect this rotation
would have on HDD performance rather than FUA causing all supers being
updated.



> Latency wise, the AUFS/Overlayfs seems to be the proble
>
> BTW, why not just ZFS-on-Linux? As ZFS also supports snapshot, maybe it will
> has similar latency compared to btrfs.

Maybe. But the volume management it's not as flexible as Btrfs. No
shrink, no device removal, no migration to mixed block device sizes so
consolidation of backing devices in cloud is a bigger hassle if you
want to stay online during migrate. Not a big deal but they're useful
features.



-- 
Chris Murphy
