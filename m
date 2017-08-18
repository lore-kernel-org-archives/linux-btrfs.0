Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33955 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751730AbdHRPAE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 11:00:04 -0400
Received: by mail-vk0-f48.google.com with SMTP id n125so33114395vke.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 08:00:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALsQ4_yw0zbtuCbRQiUXCeft0OaukD9N=2UKM-bk36D8-8iiBQ@mail.gmail.com>
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
 <38bbcea5-882b-1637-1970-e147cb141d39@gmx.com> <CAJCQCtTGy1yw+b2ZWNdBA_OZwywzsA0efO2tCrrr02922oKoAg@mail.gmail.com>
 <CALsQ4_y=36OQPqq-o5mB4LQeui4h4qoc5QZnj0cCTBULbRX-dA@mail.gmail.com>
 <5193c358-f64b-6b1f-bc55-c9e423a1ac8c@gmx.com> <CALsQ4_yw0zbtuCbRQiUXCeft0OaukD9N=2UKM-bk36D8-8iiBQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 18 Aug 2017 09:00:02 -0600
Message-ID: <CAJCQCtT4v0T0Y_w5wkJ1u1zsYYeAV4XwByQdKEGQYGPHr3Q7bQ@mail.gmail.com>
Subject: Re: BTRFS error (device sda4): failed to read chunk tree: -5
To: Zirconium Hacker <jared.e.vb@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 2:47 AM, Zirconium Hacker <jared.e.vb@gmail.com> wrote:

> I vaguely remember following this guide at some point:
> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
> -- specifically the "Balance cannot run because the filesystem is
> full" part.  This may have broken some things?
>

If you don't do 'btrfs device delete /dev/loop0' or if that command
does not complete, then it's possible to get into the situation you're
in.

Have you ever mounted this file system with -o degraded?

I'm going to guess the history is something like:
1. enospc
2. btrfs dev add
3. some kind of filtered balance, which only causes data block groups
to be moved to the 2nd device
4. 2nd device is physically removed without first 'btrfs dev del'

Zirco's superblock very clearly says num_devices  2, so I'd expect
normal mount to always fail unless both devices are present. Is there
some weird edge case where Btrfs might permit non-degraded mount when
only data bg's are on a 2nd device? And then trouble only happens
later when a balance is done and it goes looking for these bg's? And
then, boom!

-- 
Chris Murphy
