Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:34196 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753230AbdHQTK3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 15:10:29 -0400
Received: by mail-vk0-f42.google.com with SMTP id n125so25647323vke.1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 12:10:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$b0a14$8f1e0555$f8f395d6$3ede559@cox.net>
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
 <CAJCQCtQPMNnC4wHfubV1aHstdUnZXQoRMuss85=_ZAv51qFpSw@mail.gmail.com> <pan$b0a14$8f1e0555$f8f395d6$3ede559@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 17 Aug 2017 13:10:27 -0600
Message-ID: <CAJCQCtQjh07f6EYGVUPpWL7aXChVSXdok1DOg-+ZwOSqNMq_7Q@mail.gmail.com>
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 17, 2017 at 2:04 AM, Duncan <1i5t5.duncan@cox.net> wrote:

> The point being, as I said, unless Samsung's changed policy recently,
> there's no point in filing Linux related bug reports with them.  All
> you're likely to get is them putting their fingers in their ears while
> singing loudly about not supporting Linux.

OK good to know.


> Unfortunately, I found all this out /after/ having bought a pair of 1 TB
> Samsung evo 850s myself (after seeing them recommended here...), while
> googling, as suggested above, samsung ssd queued trim (tho I actually put
> in evo 850 since that's what I had), in ordered to see if I could safely
> mount with discard and not have it hurt performance due to lack of queued-
> trim support.  Obviously not, so I'm running without discard, and letting
> the systemd fstrim timer do its thing every week, instead.

I have one of these:

SAMSUNG MZVLV256HCHP-000H1

It came in the HP Spectre laptop I'm using, and I've intentionally
been using discard mount option to see if things go bad eventually.
It's been 10 months. Zero problems.



> But I'd have been rather unlikely to buy samsung if I knew they /refused/
> to support Linux users because "anyone" can modify the code, that's for
> sure!

That's silly. Someone's just a bad manager (or a series of them).
Samsung is a multi-tentacled beast. They clearly have another tentacle
that supports Linux.
https://en.wikipedia.org/wiki/F2FS


-- 
Chris Murphy
