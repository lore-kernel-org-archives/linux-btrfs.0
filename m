Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:51338 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752600AbeC3HVV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 03:21:21 -0400
Received: by mail-it0-f44.google.com with SMTP id b5-v6so129626itj.1
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:21:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180329215011.GC2446@hungrycats.org>
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net> <20180329215011.GC2446@hungrycats.org>
From: Menion <menion@gmail.com>
Date: Fri, 30 Mar 2018 09:21:00 +0200
Message-ID: <CAJVZm6dY9vg15Qxnv8uLAwwPvoiiMZ0gJWARLS_9Ab6LX47ajA@mail.gmail.com>
Subject: Re: Status of RAID5/6
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 Thanks for the detailed explanation. I think that a summary of this
should go in the btrfs raid56 wiki status page, because now it is
completely inconsistent and if a user comes there, ihe may get the
impression that the raid56 is just broken
Still I have the 1 bilion dollar question: from your word I understand
that even in RAID56 the metadata are spread on the devices in a coplex
way, but shall I assume that the array can survice to the sudden death
of one (two for raid6) HDD in the array?
Bye
