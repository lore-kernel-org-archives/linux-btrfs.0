Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36506 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756089AbcH2APM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 20:15:12 -0400
Received: by mail-oi0-f41.google.com with SMTP id f189so176579879oig.3
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 17:15:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSUVeXwuKn8rR_Rw24anzHNSLgVo_wYkot1mZYXiGkJ1w@mail.gmail.com>
References: <CA+WRLO8KuP8LS77NUbZLAs3e120oFudES_R3tYQjjYiCXH4BOA@mail.gmail.com>
 <CAJCQCtSUVeXwuKn8rR_Rw24anzHNSLgVo_wYkot1mZYXiGkJ1w@mail.gmail.com>
From: Gareth Pye <gareth@cerberos.id.au>
Date: Mon, 29 Aug 2016 10:15:10 +1000
Message-ID: <CA+WRLO_6q2cZqPPkmtqjjkq7tfdh5DDyE_oHFswFoQVz8FguKw@mail.gmail.com>
Subject: Re: Recommendation on raid5 drive error resolution
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current status:

Knowing things were bad I did set the scterc values sanely, but the
box was getting less stable so I thought a reboot was a good idea.
That reboot failed to mount the partition at all and eveything
triggered my 'is this a psu issue' sense so I've left the box off till
I've got time to check if a psu replacement makes anything happier.
That might happen tonight or tomorrow.

I'll update the thread when I do that.
