Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mokrynskyi.com ([46.4.12.50]:38608 "EHLO mx.mokrynskyi.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751072AbdKSDp6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 22:45:58 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.mokrynskyi.com (Postfix) with ESMTP id A71691382
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Nov 2017 03:45:56 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
        by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id w9YPdwQ0rWAV for <linux-btrfs@vger.kernel.org>;
        Sun, 19 Nov 2017 03:45:56 +0000 (UTC)
Subject: Re: Unrecoverable scrub errors
To: Chris Murphy <lists@colorremedies.com>
Cc: Adam Borowski <kilobyte@angband.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <0d0062da-6310-7662-a7ec-edc6591b4542@mokrynskyi.com>
 <CAJCQCtSBxDP7ZyCnQuZZLQXXURrKLT+1Ja61pD_uR0oGH0piDA@mail.gmail.com>
 <20171118033335.2ha45mvia5edu6p6@angband.pl>
 <277c8155-8651-f593-0f3f-e36add09d943@mokrynskyi.com>
 <CAJCQCtTAvVKUmMdTaD=S-34anDghHWmQcjn76i+Q3wYc58+gTA@mail.gmail.com>
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Message-ID: <f73a2482-e82d-e658-02aa-a2e2988a0012@mokrynskyi.com>
Date: Sun, 19 Nov 2017 05:45:55 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTAvVKUmMdTaD=S-34anDghHWmQcjn76i+Q3wYc58+gTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

19.11.17 05:19, Chris Murphy пише:
> On Sat, Nov 18, 2017 at 1:15 AM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
>> I can assure you that drive (it is HDD) is perfectly functional with 0 SMART errors or warnings and doesn't have any problems. dmesg is clean in that regard too, HDD itself can be excluded from potential causes.
>>
>> There were however some memory-related issues on my machine a few months ago, so there is a chance that data might have being written incorrectly to the drive back then (I didn't run scrub on backup drive for a long time).
>>
>> How can I identify to which files these metadata belong to replace or just remove them (files)?
> You might look through the archives about bad ram and btrfs check
> --repair and include Hugo Mills in the search, I'm pretty sure there
> is code in repair that can fix certain kinds of memory induced
> corruption in metadata. But I have no idea if this is that type or if
> repair can make things worse in this case. So I'd say you get
> everything off this file system that you want, and then go ahead and
> try --repair and see what happens.

In this case I'm not sure if data were written incorrectly or checksum or both. So I'd like to first identify the files affected, check them manually and then decide what to do with it. Especially there not many errors yet.

> One alternative is to just leave it alone. If you're not hitting these
> leaves in day to day operation, they won't hurt anything.
It was working for some time, but I have suspicion that occasionally it causes spikes of disk activity because of this errors (which is why I run scrub initially).
> Another alternative is to umount, and use btrfs-debug-tree -b  on one
> of the leaf/node addresses and see what you get (probably an error),
> but it might still also show the node content so we have some idea
> what's affected by the error. If it flat out refuses to show the node,
> might be a feature request to get a flag that forces display of the
> node such as it is...

Here is what I've got:

> nazar-pc@nazar-pc ~> sudo btrfs-debug-tree -b 470069460992 /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> btrfs-progs v4.13.3
> checksum verify failed on 470069460992 found FD171FBB wanted 54C49539
> checksum verify failed on 470069460992 found FD171FBB wanted 54C49539
> checksum verify failed on 470069460992 found FD171FBB wanted 54C49539
> checksum verify failed on 470069460992 found FD171FBB wanted 54C49539
> Csum didn't match
> ERROR: failed to read 470069460992
Looks like I indeed need a --force here.

