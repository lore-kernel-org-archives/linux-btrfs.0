Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33410 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752273AbdIEUm2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 16:42:28 -0400
Received: by mail-oi0-f41.google.com with SMTP id r20so2644848oie.0
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Sep 2017 13:42:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1841512.lHhB7WV3Ld@russell.coker.com.au>
References: <1841512.lHhB7WV3Ld@russell.coker.com.au>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 5 Sep 2017 14:42:26 -0600
Message-ID: <CAJCQCtTLtKzPW1JONLQ51oykX6wbEShCHDUWSDm-UG4v8bCJZg@mail.gmail.com>
Subject: Re: read-only for no good reason on 4.9.30
To: russell+btrfs@coker.com.au
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 3, 2017 at 11:19 PM, Russell Coker
<russell+btrfs@coker.com.au> wrote:
> I have a system with less than 50% disk space used.  It just started rejecting
> writes due to lack of disk space.

What's the error? Is it ENOSPC? Kinda needs kernel messages, and also
if it's ENOSPC to have mounted with enospc_debug option. Also
everytime this has come up before, devs have asked for

$ grep -R . /sys/fs/btrfs/fsuuid/allocation/

I have no idea how to parse that myself, but there is probably a way
to anticipate enoscp from that information if you can learn how to
parse it.



>  I ran "btrfs balance" and then it started
> working correctly again.  It seems that a btrfs filesystem if left alone will
> eventually get fragmented enough that it rejects writes (I've had similar
> issues with other systems running BTRFS with other kernel versions).
>
> Is this a known issue?

Sounds like old thread "BTRFS constantly reports "No space left on
device" even with a huge unallocated space" but that's a long time
ago, and kernel ~4.7.3 fixed it. Whatever that was should be in
4.9.30.

Another possibility is there's a small bug in some cases where things
go around the new ticketed enospc infrastructure, and that was fixed
in 4.9.42 and 4.12.6. So you should try one of those and see if it
fixes the problem.





-- 
Chris Murphy
