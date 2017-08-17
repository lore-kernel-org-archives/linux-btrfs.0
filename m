Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57034 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752632AbdHQWmK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 18:42:10 -0400
Subject: Re: BTRFS error (device sda4): failed to read chunk tree: -5
To: Chris Murphy <lists@colorremedies.com>,
        Zirconium Hacker <jared.e.vb@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CALsQ4_wnfHtJ+Drn3DJsQxdkX9=ZYDqH_H=hi3BxdSrnDZpqmw@mail.gmail.com>
 <CAJCQCtQONfPPumkMaisrSxNZJyXMYTXufsYVY45ypMP+6ve9ZA@mail.gmail.com>
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
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <38bbcea5-882b-1637-1970-e147cb141d39@gmx.com>
Date: Fri, 18 Aug 2017 06:42:03 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTuxjKcZqLOqQvVYZANXyke1_ZeKXF_fr8UG-5mUb=hhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月18日 00:53, Chris Murphy wrote:
> Readding Btrfslist, and adding Qu:
> 
> 
> On Thu, Aug 17, 2017 at 12:48 AM, Zirconium Hacker <jared.e.vb@gmail.com> wrote:
>> Oh, sorry, I guess the output of the command I ran wasn't clear -- it
>> was collecting the output of running the debug command on all 1,084
>> and showing that it was the same.  Here's specifically what you asked
>> for:
>>
>> $ sudo btrfs-debug-tree -b 61809344512 /dev/sda4
>> btrfs-progs v4.12
>> bytenr mismatch, want=61809344512, have=0
>> Couldn't read tree root
>> ERROR: unable to open /dev/sda4
>> $ sudo btrfs-debug-tree -b 1085440000 /dev/sda4
>> btrfs-progs v4.12
>> bytenr mismatch, want=61809344512, have=0

This means either chunk root is corrupted, or system chunk array in 
superblock is corrupted.
Bytenr mismatch is normally impossible for normal operation.

BTW are you using discard mount option? Sometimes it can cause problem.

And please also paste the following output:

# btrfs-show-super -fa /dev/sda4
# btrfs-find-root -o 5 /dev/sda4

The first is to output the full backup roots and current chunk root for 
us to debug.
The second one will try to iterate your whole disk to find a valid but 
old chunk root.
If we could find one (even a little old), it may make it possible to 
mount the fs.

Thanks,
Qu
>> Couldn't read tree root
>> ERROR: unable to open /dev/sda4
>>
>> I'm using GMail, and it's confusing me by trimming off quotes and
>> stuff, so sorry if I miss something.
>>
> 
> OK well now we're in the bad part of Btrfs repair where the error
> messages don't help. > It's one thing for it to complain about
> 1085440000 being invalid, because by now it might have been
> overwritten, but to say it wants some other root that we already know
> it can't read, and then fail reading that root is not helpful
> information.
> Maybe Qu has an idea. But it does sound like something really
> catastrophic happened to blow away all of the backup root trees.
> 
> Going back to your first email, -o ro,usebackuproot failed with a
> chunk tree error. I wonder if 'rescue chunk' might help.
> 
> Try 'btrfs rescue chunk -v' and see what you get.
> 
> 
