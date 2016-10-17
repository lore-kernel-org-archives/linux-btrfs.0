Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:36618 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932163AbcJQSws (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 14:52:48 -0400
Received: by mail-it0-f47.google.com with SMTP id 139so52162350itm.1
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 11:52:48 -0700 (PDT)
From: "Jason D. Michaelson" <jasondmichaelson@gmail.com>
To: "'Chris Murphy'" <lists@colorremedies.com>
Cc: "'Btrfs BTRFS'" <linux-btrfs@vger.kernel.org>
References: <5cde01d2230f$fa1e3150$ee5a93f0$@com> <CAJCQCtQ0SCZi36RG32NiHVYJRz8gHCtfhWYEqM93y2twX4C4JA@mail.gmail.com> <5ce201d22364$96702780$c3507680$@com> <CAJCQCtR_zOd=1hVrKAD_kKfE_EKZQ2omfWQV556Rg=OSbvEd0w@mail.gmail.com> <5e8501d223d7$715a9bb0$540fd310$@com> <CAJCQCtQ12AZQ9x2ddSSceGHpWYvB7sSVE0qty+=Ln9oibmiHRw@mail.gmail.com> <5e8601d223da$0cbf6c00$263e4400$@com> <CAJCQCtSBn1+CqqDkeHx+bBR8zSbN8hYQ9R4p9C2EtpBoVBP+Ww@mail.gmail.com> <5e8701d223f1$c7ea0960$57be1c20$@com> <CAJCQCtT4g0kQ3bhEmOGfyEM62r8a1w4B6S_AqW3Q-e+k+QHgag@mail.gmail.com> <602501d224b2$519b3330$f4d19990$@com> <CAJCQCtT8Lmo1k=PV0arYGmZqpo0k3MOABbXrR4MZ73=viQh1+Q@mail.gmail.com> <CAJCQCtQAomLb9ysym5q_rqjFW8uJCpTM0Y-wUSjywte-AQkSMg@mail.gmail.com>
In-Reply-To: <CAJCQCtQAomLb9ysym5q_rqjFW8uJCpTM0Y-wUSjywte-AQkSMg@mail.gmail.com>
Subject: RE: raid6 file system in a bad state
Date: Mon, 17 Oct 2016 13:52:45 -0500
Message-ID: <065201d228a7$a6e683a0$f4b38ae0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been following that thread. It's been my fear.

I'm in the process of doing a restore of what I can get off of it so that i can re-create the file system with raid1 which, if i'm reading that thread correctly doesn't suffer at all from the rmw problems extant in the raid5/6 code at the moment.

Again, thanks for your help.

> -----Original Message-----
> From: chris@colorremedies.com [mailto:chris@colorremedies.com] On
> Behalf Of Chris Murphy
> Sent: Friday, October 14, 2016 4:55 PM
> To: Chris Murphy
> Cc: Jason D. Michaelson; Btrfs BTRFS
> Subject: Re: raid6 file system in a bad state
> 
> This may be relevant and is pretty terrible.
> 
> http://www.spinics.net/lists/linux-btrfs/msg59741.html
> 
> 
> Chris Murphy

