Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:42078 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751467AbeA0VMC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 16:12:02 -0500
Received: by mail-oi0-f53.google.com with SMTP id c8so2528777oiy.9
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Jan 2018 13:12:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180127132641.mhmdhpokqrahgd4n@angband.pl>
References: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com>
 <5d342036-0de0-9bf7-3e9e-4885b62d8100@gmail.com> <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
 <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com> <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com> <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me> <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl> <20180127132641.mhmdhpokqrahgd4n@angband.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 27 Jan 2018 14:12:01 -0700
Message-ID: <CAJCQCtT+jgHxuYvTjAKWPhnX2H6yTwB6Z7Hqk+56GVfUtKB7Xw@mail.gmail.com>
Subject: Re: degraded permanent mount option
To: Adam Borowski <kilobyte@angband.pl>
Cc: Tomasz Pala <gotar@polanet.pl>,
        "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 27, 2018 at 6:26 AM, Adam Borowski <kilobyte@angband.pl> wrote:

> You're assuming that btrfs somehow knows this itself.  Unlike the bogus
> assumption systemd does that by counting devices you can know whether a
> degraded or non-degraded mount is possible, it is in general not possible to
> know whether a mount attempt will succeed without actually trying.

That's right, although a small clarification is in order: systemd
doesn't count devices itself. The Btrfs systemd udev rule defers to
Btrfs kernel code by using BTRFS_IOC_DEVICES_READY. And it's totally
binary. Either they are all ready, in which case it exits 0, and if
they aren't all ready it exits 1.

But yes, mounting whether degraded or not is sufficiently complicated
that you just have to try it. I don't get the point of wanting to know
whether it's possible without trying. Why would this information be
useful if you were NOT going to mount it?


> Ie, the thing systemd can safely do, is to stop trying to rule everything,
> and refrain from telling the user whether he can mount something or not.

Right. Open question is whether the timer and timeout can be
implemented in the systemd world and I don't see why not, I certainly
see it put various services on timers, some of which are indefinite,
some are 1m30s and others are 3m. Pretty much every unit gets a
descrete boot line with a green dot or red cylon eye as it waits. I
don't see why at the very least we don't have that for Btrfs rootfs
mounts because *that* alone would at least clue in a user why their
startup is totally hung indefinitely.



-- 
Chris Murphy
