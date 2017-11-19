Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36379 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbdKSDTR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 22:19:17 -0500
Received: by mail-oi0-f51.google.com with SMTP id n16so4177159oig.3
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Nov 2017 19:19:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <277c8155-8651-f593-0f3f-e36add09d943@mokrynskyi.com>
References: <0d0062da-6310-7662-a7ec-edc6591b4542@mokrynskyi.com>
 <CAJCQCtSBxDP7ZyCnQuZZLQXXURrKLT+1Ja61pD_uR0oGH0piDA@mail.gmail.com>
 <20171118033335.2ha45mvia5edu6p6@angband.pl> <277c8155-8651-f593-0f3f-e36add09d943@mokrynskyi.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 18 Nov 2017 20:19:15 -0700
Message-ID: <CAJCQCtTAvVKUmMdTaD=S-34anDghHWmQcjn76i+Q3wYc58+gTA@mail.gmail.com>
Subject: Re: Unrecoverable scrub errors
To: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Cc: Adam Borowski <kilobyte@angband.pl>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 18, 2017 at 1:15 AM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
> I can assure you that drive (it is HDD) is perfectly functional with 0 SMART errors or warnings and doesn't have any problems. dmesg is clean in that regard too, HDD itself can be excluded from potential causes.
>
> There were however some memory-related issues on my machine a few months ago, so there is a chance that data might have being written incorrectly to the drive back then (I didn't run scrub on backup drive for a long time).
>
> How can I identify to which files these metadata belong to replace or just remove them (files)?

You might look through the archives about bad ram and btrfs check
--repair and include Hugo Mills in the search, I'm pretty sure there
is code in repair that can fix certain kinds of memory induced
corruption in metadata. But I have no idea if this is that type or if
repair can make things worse in this case. So I'd say you get
everything off this file system that you want, and then go ahead and
try --repair and see what happens.

One alternative is to just leave it alone. If you're not hitting these
leaves in day to day operation, they won't hurt anything.

Another alternative is to umount, and use btrfs-debug-tree -b  on one
of the leaf/node addresses and see what you get (probably an error),
but it might still also show the node content so we have some idea
what's affected by the error. If it flat out refuses to show the node,
might be a feature request to get a flag that forces display of the
node such as it is...



-- 
Chris Murphy
