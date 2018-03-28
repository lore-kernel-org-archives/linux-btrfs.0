Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:38099 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753629AbeC1PVa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 11:21:30 -0400
Received: by mail-qt0-f180.google.com with SMTP id z23so2242837qti.5
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Mar 2018 08:21:30 -0700 (PDT)
Received: from ?IPv6:2604:2000:12c0:17:f80f:6227:7f5a:7b3a? ([2604:2000:12c0:17:f80f:6227:7f5a:7b3a])
        by smtp.gmail.com with ESMTPSA id v57sm2980715qtv.48.2018.03.28.08.21.27
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Mar 2018 08:21:28 -0700 (PDT)
From: =?utf-8?Q?Sidney_San_Mart=C3=ADn?= <sidney@s4y.us>
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Panic and corruption after update and IO trouble
Message-Id: <A37C563B-AB85-4DE6-92B9-3039E598D19A@s4y.us>
Date: Wed, 28 Mar 2018 11:21:27 -0400
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi btrfs devs,

I recently updated Linux (4.15.x) and rebooted on a machine with a 12x4TB-disk btrfs volume, and it hung on boot. I did some initial troubleshooting and eventually saw in `btrfs dev stats` that one disk had a ton of errors. I settled on a theory that either the disk or the SAS backplane got wedged in a state where operations on that disk failed, because since power cycling the system the disk has behaved perfectly and smartctl doesn’t see any evidence of trouble.

When I tried to boot again, there were a flurry of messages like “csum mismatch on free space cache” and “parent transit verify failed on 64508387606528 wanted 1555425 found 1548963”, culminating in a panic and hang whose middle looks like this (unfortunately I couldn’t scroll up in the console due to the hang, so I only have the end of it — and only as a picture):

     bvec_alloc+0x86/0xe0
     bio_alloc_bioset+0x132/0x1e0
     btrfs_bio_alloc+0x23/0x90 [btrfs]
     submit_extend_page+0x191/0x250 [btrfs]
     ? btrfs_create_repair_bio+0xf0/0xf0 [btrfs]
    ...

I ran a scrub, which finished successfully like this:

    scrub started at Wed Mar 21 18:33:14 2018 and finished after 05:07:53
    total bytes scrubbed: 27.05TiB with 1463058 errors
    error details: verify=12491 csum=1450567
    corrected errors: 1463058, uncorrectable errors: 0, unverified errors: 0

…which looks super promising. However, the machine still panicked on boot, or if I tried to mount the filesystem from a lived and perform more than a few operations on it.

I did some research and ended up going through roughly this set of recovery attempts:

1. Attempt to clear the space_cache.
2. btrfs-zero-log (maybe — I actually can’t remember if I did this, and I now see https://btrfs.wiki.kernel.org/index.php/Btrfs-zero-log saying to *please not* if the FS mounts).
3. `btrfs check --init-extent-tree`

I realize that, in reality, the right set of steps more likely involved "btrfs-image” and “send an email to this mailing list”. Unfortunately I exist in a state of mild impatience and high optimism and, as a result, I didn’t. My loss :/. The current state of things is that `btrfs check --init-extent-tree` has been running for 119 hours and has generated about 50MB of log output that looks like this:

    ref mismatch on [51614823280640 4096] extent item 0, found 1
    data backref 51614823280640 parent 57412861165568 owner 0 offset 0 num_refs 0 not found in extent tree
    incorrect local backref count on 51614823280640 parent 57412861165568 owner 0 offset 0 found 1 wanted 0 back 0x5652a69bde00
    backpointer mismatch on [51614823280640 4096]
    adding new data backref on 51614823280640 parent 57412861165568 owner 0 offset 0 found 1
    Repaired extent references for 51614823280640

…which seems scary. I made the KVM recordings and screenshots I have, and the full `btrfs check --init-extent-tree` output (since only near the end did I spend time getting the system set up with a proper livecd and network access) available here in case anyone wants to look over my shoulder:

https://ipfs.io/ipfs/QmXTgYgA4fQs4BSM8GFXrRdufF39ZVxMTV77z8ANjmZvzk

At this point, I’m genuinely not sure whether `init-extent-tree` is moving in a useful direction (i.e. will ever finish), whether stopping and trying something else would be better, or whether it’s time to salvage some `btrfs-image`s if they’re useful and then start restoring from offsite backups.

I’d appreciate any guidance, but realize that my own troubleshooting so far was *far* from ideal and would accept “It’s time to restore from backups, but please do X next time instead of all that”. Happy to answer any other questions, too.

Sidney