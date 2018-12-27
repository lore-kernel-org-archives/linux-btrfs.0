Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C180C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 147BE21741
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbeL0HO4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 02:14:56 -0500
Received: from [195.159.176.226] ([195.159.176.226]:43757 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1729454AbeL0HO4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 02:14:56 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gcPqU-0003V4-7f
        for linux-btrfs@vger.kernel.org; Thu, 27 Dec 2018 08:12:42 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fi usage -T shows unallocated column as total in drive, not
 total available to btrfs
Date:   Thu, 27 Dec 2018 07:12:35 +0000 (UTC)
Message-ID: <pan$ac19$67da17d$80a83557$ce46be42@cox.net>
References: <96d61222666591a99b9b9f0c42bf4d5f@mailmag.net>
        <CAJCQCtS7XJaD4Mhrg152K4zfj-w2P0JkpUvZ0R-M6x8QmCc1tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; e65ba1502)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Chris Murphy posted on Wed, 26 Dec 2018 17:36:19 -0700 as excerpted:


> I'm not really following this. An fs resize is implied by any device
> add, remove or replace command. In the case of replace, it will
> efficiently copy the device being replaced to the designated drive, and
> then once that succeeds resize the file system to reflect the size of
> the replacement device. I'm also confused why devid 4 seems to be
> present before and after your device replace, so I have to wonder if
> your copy paste really worked out as intended? And also, what version of
> kernel and btrfs-progs are you using?

I thought... yes...

Just checked the btrfs-replace manpage (v4.19.1) and it says:

Note
the filesystem has to be resized to fully take advantage of a larger 
target device; this can be achieved with btrfs filesystem
resize <devid>:max /path

So it does *not* auto-resize after the replace.


Also, I'm not positive on this, and I don't see it mentioned in the 
manpage, but I /think/ replace (unlike add/remove) keeps the same devid 
for the new device.

(And IIRC one of the devs commented that there's a devid 0 during the 
replace itself, but I'm unsure whether that's the source or the 
destination, that is, whether the old ID is switched to the new device at 
the beginning of the replace so the old one temporarily gets the 0 during 
the replace until it's deleted at the end, or end so the new one 
temporarily gets it until the id is transferred at the end.  That was in 
the context of a draft patch that didn't yet account for the possibility 
of devid 0 during replace, and the comment was pointing out the 
possibility.)

If that's correct then the devid 4 could indeed be the old device at 
first (when it refers to sda and has 164.5 GiB unallocated), but the new 
device later (when it refers to sdu and has 6.53 TiB unallocated), even 
before the resize, that being the point of confusion (6.53 TB unallocated 
even tho it can't actually use it as it hasn't been resized yet) that 
triggered the original post in the first place.

To address that point, I suppose ideally there'd be another line when the 
filesystem's smaller than the available device size, device-space outside 
filesystem, or some such.


Tho you are correct that fi show and fi df's output don't correspond 
exactly to fi usage, without some sort of decoder ring to translate 
between them, and even with the decoder ring, the numbers come out but 
slightly different things are reported.


Meanwhile, while I normally want the filesystem usage info and thus use 
that command, for something like this I'd be specifically interested in 
the specific device's usage, and thus would use btrfs device usage, in 
place of or in addition to btrfs filesystem usage.

It'd be interesting to see what device usage (as opposed to filesystem 
usage) did with the unreachable space in terms of reporting -- maybe it 
has that separate line tho I doubt it, but if not does it count it or 
not?.  But that wasn't posted and presumably the query wasn't run while 
in the still-unresized state, and I guess it's a bit late now to get it...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

