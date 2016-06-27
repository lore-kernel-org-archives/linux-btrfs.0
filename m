Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35092 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbcF0QtG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 12:49:06 -0400
Received: by mail-oi0-f49.google.com with SMTP id r2so208462025oih.2
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 09:49:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467009019.1982.14.camel@sapo.pt>
References: <loom.20160623T205347-371@post.gmane.org> <CAJCQCtRO+FYrsfHF_ARSnPfoS7uzvLR4hB1V-TJ_YN4NcA6srw@mail.gmail.com>
 <5356822.A3RRKHDHNy@linux-omuo> <CAJCQCtQ-xYrERT5R4gSC1C7OkoeP2LeS9W9UL5VY5SmDBXk71w@mail.gmail.com>
 <20160625010610.Horde.tUycS31CmgVWfy3CPu7qJCD@mail.sapo.pt>
 <CAJCQCtSGZO8JVXqVOwifT84KTLCkciux+Y6A_na4AA-PxPjjbw@mail.gmail.com>
 <20160625211024.Horde.pL6RMZNJL6tnjtpglBZjDaB@mail.sapo.pt>
 <CAJCQCtQ+q90r=Q38mtVKoBeAmXmPJPP2cp=dfLj3kBiEv66bzA@mail.gmail.com>
 <1466946315.4049.19.camel@sapo.pt> <CAJCQCtSaMTA4a8+jGO8TXEQCQi7Yi2pS-S2qPNKt8q1eZSkULA@mail.gmail.com>
 <1467009019.1982.14.camel@sapo.pt>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 10:49:05 -0600
Message-ID: <CAJCQCtR1cYvO5hC=k-RiZnQ2BSAzeTk8NM-kZZE=Qng-1rxLuQ@mail.gmail.com>
Subject: Re: Bad hard drive - checksum verify failure forces readonly mount
To: Vasco Almeida <vascomalmeida@sapo.pt>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 12:30 AM, Vasco Almeida <vascomalmeida@sapo.pt> wrote:

> File system image available at (choose one link)
> https://mega.nz/#!AkAEgKyB!RUa7G5xHIygWm0ALx5ZxQjjXNdFYa7lDRHJ_sW0bWLs
> https://www.sendspace.com/file/i70cft




> Should I file a bug report with that image dump linked above or btrfs-
> debug-tree output or both?

If it were me, I'd include both. Maybe the image is incomplete or vice
versa. The debug tree output is also human readable. I'd also put them
up in a cloud location where you can kinda forget about them for a
while, I've had images not looked at for 6+ months by a dev.


> I think I will use the subject of this thread as summary to file the
> bug. Can you think of something more suitable or is that fine?

I would try to summarize something like:
file system created with btrfs-progs version -----, and mostly used
with kernel version -----, and inexplicably the file system became
unusable at boot time always mounting only readonly. Newer kernel
versions still could not mount it, nor was btrfs check using
btrfs-progs version ----- able to repair. See thread URL for more
details.

btrfs-image URL
btrfs-debug-tree URL


> I think I will reinstall the OS since, even if I manage to recover the
> file system from this issue, that OS will be something I can not trust
> fully.

Yeah pretty much that's right. There is an rpm command where you can
have it check the signatures of all installed binaries, but I forget
what it is offhand. That'd be an alternative to reinstalling if the
init options were to work.


-- 
Chris Murphy
