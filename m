Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:34436 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdHREKy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 00:10:54 -0400
Received: by mail-vk0-f42.google.com with SMTP id n125so28807576vke.1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 21:10:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <38bbcea5-882b-1637-1970-e147cb141d39@gmx.com>
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
 <CAJCQCtTuxjKcZqLOqQvVYZANXyke1_ZeKXF_fr8UG-5mUb=hhw@mail.gmail.com> <38bbcea5-882b-1637-1970-e147cb141d39@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 17 Aug 2017 22:10:53 -0600
Message-ID: <CAJCQCtTGy1yw+b2ZWNdBA_OZwywzsA0efO2tCrrr02922oKoAg@mail.gmail.com>
Subject: Re: BTRFS error (device sda4): failed to read chunk tree: -5
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Zirconium Hacker <jared.e.vb@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 17, 2017 at 4:42 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> BTW are you using discard mount option? Sometimes it can cause problem.

OP did not say if it was using discard mount option; but did say some
time before this (I'm not sure how recent) he had used fstrim. The
firmware for this SSD model is current.


-- 
Chris Murphy
