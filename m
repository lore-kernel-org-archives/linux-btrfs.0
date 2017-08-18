Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:50064 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750709AbdHRIPO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 04:15:14 -0400
Subject: Re: BTRFS error (device sda4): failed to read chunk tree: -5
To: Zirconium Hacker <jared.e.vb@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CALsQ4_wnfHtJ+Drn3DJsQxdkX9=ZYDqH_H=hi3BxdSrnDZpqmw@mail.gmail.com>
 <CALsQ4_x13pBuZ0wDmO=28m6xAEXFjOkORJsxDeFASOeA5oDeLg@mail.gmail.com>
 <CAJCQCtRTiZy2YNZNLLx_KWuLMuNxPK26u1Orz91MqtDRFNRVNg@mail.gmail.com>
 <CALsQ4_xkiyWuwJ4mVOV7QhWx6RFD80Y23fDNdPam2UFpRi1Gxw@mail.gmail.com>
 <CAJCQCtTx_i_PrqgRbA-P9+zKX926KKeT1nwAJT=dkr-qcOpCCg@mail.gmail.com>
 <CALsQ4_wZLvdqHdKa9DyjRXTmf1CV47+11-O_SqLRQJoQDT+gqQ@mail.gmail.com>
 <CAJCQCtRYxb4QdN__WcUX_Jhs=GyguwJV79pKUp4PYhC9h_H-xA@mail.gmail.com>
 <CALsQ4_xWte-vOJD-ppOPkvfHpLtu_-24KZPj2H9Tp99S7jDGcw@mail.gmail.com>
 <CAJCQCtR-+o_GA7fCfSe8Lfwp8h6FzfiSR=qz8ekc4=dy98mtiQ@mail.gmail.com>
 <CALsQ4_zTdxgfN25pkbhtXfj5EMVUbZ2=FrUHUocNxjynHhYhuA@mail.gmail.com>
 <CAJCQCtTuxjKcZqLOqQvVYZANXyke1_ZeKXF_fr8UG-5mUb=hhw@mail.gmail.com>
 <38bbcea5-882b-1637-1970-e147cb141d39@gmx.com>
 <CAJCQCtTGy1yw+b2ZWNdBA_OZwywzsA0efO2tCrrr02922oKoAg@mail.gmail.com>
 <CALsQ4_y=36OQPqq-o5mB4LQeui4h4qoc5QZnj0cCTBULbRX-dA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5193c358-f64b-6b1f-bc55-c9e423a1ac8c@gmx.com>
Date: Fri, 18 Aug 2017 16:15:03 +0800
MIME-Version: 1.0
In-Reply-To: <CALsQ4_y=36OQPqq-o5mB4LQeui4h4qoc5QZnj0cCTBULbRX-dA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月18日 15:17, Zirconium Hacker wrote:
> I checked my fstab, and my mount options for that partition are:
> nodev,nosuid (so no discard).
> As far as I remember, I had some issues converting from ext4 with
> existing tools (I think that was on Debian so the tools were likely
> older) so I did a manual conversion backup, wipe, copy files back).
> 
> $ sudo btrfs-find-root -o 3 /dev/sda4
> Couldn't read tree root
> Superblock thinks the generation is 311252
> Superblock thinks the level is 0
> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
> Found tree root at 131072 gen 311252 level 0

So chunk root (and since it's level 0, the whole chunk tree) seems good.

Could you please try the following command?
# btrfs-debug-tree -b 131072 /dev/sda4

I assume it may fail due to the fact that root tree is corrupted.
But maybe we are lucky?


And further investigating your super dump and the code, it's shows some 
clue, mostly related to your multi-device setup.

Your find-root output shows that, the only chunk leaf in /dev/sda4 seems 
good.
And in btrfs_read_chunk_tree(), which returned -EIO and caused the error 
message, will first search chunk root.

Since your chunk leaf is good, such search itself should not cause too 
much problem.

Then btrfs_read_chunk_tree() will try to read out each device, by 
calling read_one_dev().
Which can return -EIO if any device is missing and you're not using 
degraded mount option.

Is your 2nd device missing? If so, would you please try to mount with 
"degraded,ro" mount option?

BTW, if you didn't manually convert chunk profiles, did you first create 
btrfs on single device, and then added a new device to the btrfs?

Thanks,
Qu

> 
> On Fri, Aug 18, 2017 at 12:10 AM, Chris Murphy <lists@colorremedies.com> wrote:
>> On Thu, Aug 17, 2017 at 4:42 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>> BTW are you using discard mount option? Sometimes it can cause problem.
>>
>> OP did not say if it was using discard mount option; but did say some
>> time before this (I'm not sure how recent) he had used fstrim. The
>> firmware for this SSD model is current.
>>
>>
>> --
>> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
