Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36852 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751725AbdFKEUF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Jun 2017 00:20:05 -0400
Received: by mail-wr0-f173.google.com with SMTP id v111so65638915wrc.3
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Jun 2017 21:20:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170609195718.GC30723@carfax.org.uk>
References: <oherub$g5a$1@blaine.gmane.org> <20170609195718.GC30723@carfax.org.uk>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 10 Jun 2017 22:20:03 -0600
Message-ID: <CAJCQCtRdinWhYvNB8dVXGREhnaspYaSu8vbbNRsN4DjyTJw6GA@mail.gmail.com>
Subject: Re: Filesystem won't mount (open_ctree failed) or repair (BUG_ON)
To: Hugo Mills <hugo@carfax.org.uk>, Koen Kooi <koen@dominion.thruhere.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 9, 2017 at 1:57 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Jun 09, 2017 at 09:12:16PM +0200, Koen Kooi wrote:
>> Hi,
>>
>> Today the kernel got wedged during shutdown (4.11.x tends to do that, haven't
>> debugged) and I pressed the reset button. The next boot btrfs won't mount:
>>
>> [Fri Jun  9 20:46:07 2017] BTRFS error (device md0): parent transid verify failed on 5840011722752 wanted 170755 found 170832
>> [Fri Jun  9 20:46:07 2017] BTRFS error (device md0): parent transid verify failed on 5840011722752 wanted 170755 found 170832
>> [Fri Jun  9 20:46:07 2017] BTRFS error (device md0): failed to read block groups: -5
>> [Fri Jun  9 20:46:08 2017] BTRFS error (device md0): open_ctree failed
>
>    With a transid failure on mount, about the only thing that's likely
> to work is mounting with -o usebackuproot. If that doesn't work, then
> a rebuild of the FS is almost certainly needed.

Weird that it wants almost 80 generations back from what's found.
Sounds like betrayal somewhere...

I'd say take a btrfs-image and put it up somewhere and also file a
bug. The fsck should not crash.

What are these showing?
# btrfs insp dump-s -f /dev/
# btrfs rescue super /dev/
# btrfs-find-root /dev/



-- 
Chris Murphy
