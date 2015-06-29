Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:35418 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbbF2FCF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 01:02:05 -0400
Received: by lagh6 with SMTP id h6so39507408lag.2
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2015 22:02:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTv+yAQAQsBrbWEFo4_i0_tUUtbxwU1R4xDDhPTzQNGAQ@mail.gmail.com>
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
	<CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
	<CAJCQCtSv15DVDju7vhm=Luc5hqWvce__F7iovh87uxq37bNg0Q@mail.gmail.com>
	<CA+xOVSMjO0e5TPfksr=TmnT9zc5=hJemYPtn_tg+xxsWbFMV=A@mail.gmail.com>
	<CADfjVrhmUhWAs0+6_s-hDcoLyrXdvkY1fZgoKv2VRDt2F8MWhQ@mail.gmail.com>
	<CA+xOVSOxTnRpfxnw=FpizBNGJmdi5y_aEPRZqHos6W5u4=HgbQ@mail.gmail.com>
	<CAJCQCtTv+yAQAQsBrbWEFo4_i0_tUUtbxwU1R4xDDhPTzQNGAQ@mail.gmail.com>
Date: Mon, 29 Jun 2015 08:02:01 +0300
Message-ID: <CA+xOVSMgqwOGxdhAjEZQHOCNhaJs-g2ieDE7qss8skyF4=shkw@mail.gmail.com>
Subject: Re: btrfs replace seems to corrupt the file system
From: Mordechay Kaganer <mkaganer@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

On Sun, Jun 28, 2015 at 10:32 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sun, Jun 28, 2015 at 1:20 PM, Mordechay Kaganer <mkaganer@gmail.com> wrote:
>
>
>> Then (if it's OK, hopefully) we'll see how to redo the replace. Maybe,
>> unmount and do a simple "dd" will be the best option? At least it's
>> not going to corrupt the original data :-).
>
> Use of dd can cause corruption of the original.
>

But doing a block-level copy and taking care that the original volume
is hidden from the kernel while mounting the new one is safe, isn't
it?

Anyway, what is the "strait forward" and recommended way of replacing
the underlying device on a single-device btrfs not using any raid
features? I can see 3 options:

1. btrfs replace - as far as i understand, it's primarily intended for
replacing the member disks under btrfs's raid.

2, Add a new volume, then remove the old one. Maybe this way we'll
need to do a full balance after that?

3. Block-level copy of the partition, then hide the original from the
kernel to avoid confusion because of the same UUID. Of course, this
way the volume is going to be off-line until the copy is finished.
