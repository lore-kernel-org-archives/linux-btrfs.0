Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:35490 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751912AbdFKW66 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Jun 2017 18:58:58 -0400
Received: by mail-wr0-f173.google.com with SMTP id q97so78931836wrb.2
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Jun 2017 15:58:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6BE7B702-122D-406B-B8D5-9DFAB78BA587@dominion.thruhere.net>
References: <oherub$g5a$1@blaine.gmane.org> <20170609195718.GC30723@carfax.org.uk>
 <CAJCQCtRdinWhYvNB8dVXGREhnaspYaSu8vbbNRsN4DjyTJw6GA@mail.gmail.com> <6BE7B702-122D-406B-B8D5-9DFAB78BA587@dominion.thruhere.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 11 Jun 2017 16:58:56 -0600
Message-ID: <CAJCQCtS=S1jkcLtAyC18iNMQehsXMMFytvPz05YwMcs+JHLEag@mail.gmail.com>
Subject: Re: Filesystem won't mount (open_ctree failed) or repair (BUG_ON)
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 11, 2017 at 4:05 AM, Koen Kooi <koen@dominion.thruhere.net> wrote:
>
>> Op 11 jun. 2017, om 06:20 heeft Chris Murphy <lists@colorremedies.com> het volgende geschreven:
>>
>> On Fri, Jun 9, 2017 at 1:57 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>> On Fri, Jun 09, 2017 at 09:12:16PM +0200, Koen Kooi wrote:
>>>> Hi,
>>>>
>>>> Today the kernel got wedged during shutdown (4.11.x tends to do that, haven't
>>>> debugged) and I pressed the reset button. The next boot btrfs won't mount:
>>>>
>>>> [Fri Jun  9 20:46:07 2017] BTRFS error (device md0): parent transid verify failed on 5840011722752 wanted 170755 found 170832
>>>> [Fri Jun  9 20:46:07 2017] BTRFS error (device md0): parent transid verify failed on 5840011722752 wanted 170755 found 170832
>>>> [Fri Jun  9 20:46:07 2017] BTRFS error (device md0): failed to read block groups: -5
>>>> [Fri Jun  9 20:46:08 2017] BTRFS error (device md0): open_ctree failed


Superblock shows gen 170816 and the backups have nothing newer. So why
is it finding generation 170832? It's confused.


>
> 1) kernel 4.10.x -> 4.11.x
> 2) A journal was added to /dev/md0
> 3) Force blk-mq mode

Could be blk-mq + md bug, *shrug* not sure. It's not 4.11 on its own,
I've been running all of those version since rc1 and haven't had any
problems, although I also haven't had any forced shutdowns either.



>> # btrfs rescue super /dev/
>
> All supers are valid, no need to recover

So it's not like the supers were in the middle of being updated at the
time of the failure.


>
>
>> # btrfs-find-root /dev/
>
> parent transid verify failed on 5840011722752 wanted 170755 found 170832
> parent transid verify failed on 5840011722752 wanted 170755 found 170832
> parent transid verify failed on 5840011722752 wanted 170755 found 170832
> parent transid verify failed on 5840011722752 wanted 170755 found 170832
> Ignoring transid failure
> leaf parent key incorrect 5840011722752
> Superblock thinks the generation is 170816
> Superblock thinks the level is 1
> Found tree root at 4355118137344 gen 170816 level 1
> Well block 4354996797440(gen: 170815 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
> Well block 4354823323648(gen: 170814 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
> Well block 4354691088384(gen: 170813 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1

Try mounting with -o ro,usebackuproot and report back on dmesg. At
least that's faster to make a backup than scraping with btrfs restore.
Although I think what you have should be possible to scrape with btrfs
restore if ro,usebackuproot doesn't work.

Also worth trying btrfs check --mode=lowmem. This doesn't repair but
is a whole new implementation so it might find the source of the
problem better than the current fsck. There are patches that can be
applied to fix some of the found problems but of course it could make
things worse.



-- 
Chris Murphy
