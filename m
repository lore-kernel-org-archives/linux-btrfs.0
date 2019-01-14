Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8EEC43444
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 05:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB07020870
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 05:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfANFwU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 00:52:20 -0500
Received: from [195.159.176.226] ([195.159.176.226]:47909 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfANFwU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 00:52:20 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1giv8Q-0003Xk-8j
        for linux-btrfs@vger.kernel.org; Mon, 14 Jan 2019 06:50:06 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: applications hang on a btrfs spanning two partitions
Date:   Mon, 14 Jan 2019 05:49:58 +0000 (UTC)
Message-ID: <pan$4ced2$4d8a896d$78f71764$55651a6d@cox.net>
References: <418d4647-8c67-2481-68f1-1e722460c3de@florianstecker.de>
        <51f6646b-ca38-9b34-7061-8ab5227f00ae@suse.com>
        <2d2ac67d-3cf5-d147-f57b-785dc633821d@florianstecker.de>
        <936b36f0-bd50-3ce1-5045-69a3604d4bfd@suse.com>
        <7b4fa64b-e981-52c5-4597-40b5ea2df5b3@florianstecker.de>
        <CAJCQCtQF0DU+yAH33iSXu2NBk7TCWCUZ4STC2TExW3+dJpK-Hw@mail.gmail.com>
        <aeaf4b99-a9d5-6335-67f3-e7f851e50b32@florianstecker.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; edad96df2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Florian Stecker posted on Sat, 12 Jan 2019 11:19:14 +0100 as excerpted:

> $ mount | grep btrfs
> /dev/sda8 on / type btrfs
> (rw,relatime,ssd,space_cache,subvolid=5,subvol=/)

Unlikely to be apropos to the problem at hand, but FYI...

Unless you have a known reason not to[1], running noatime with btrfs 
instead of the kernel-default relatime is strongly recommended, 
especially if you use btrfs snapshotting on the filesystem.

The reasoning is that even tho relatime reduces the default access-time 
updates to once a day, it still likely-unnecessarily turns otherwise read-
only operations into read-write operations, and atimes are metadata, 
which btrfs always COWs (copy-on-writes), meaning atime updates can 
trigger cascading metadata block-writes and much larger than 
anticipated[2] write-amplification, potentially hurting performance, yes, 
even for relatime, depending on your usage.

In addition, if you're using snapshotting and not using noatime, it can 
easily happen that a large portion of the change between one snapshot and 
the next is simply atime updates, thus making the space referenced 
exclusively by individual affected snapshots far larger than it would 
otherwise be.

---
[1] mutt is AFAIK the only widely used application that still depends on 
atime updates, and it only does so in certain modes, not with mbox-format 
mailboxes, for instance.  So unless you're using it, or your backup 
solution happens to use atime, chances are quite high that noatime won't 
disrupt your usage at all.

[2] Larger than anticipated write-amplification:  Especially when you 
/thought/ you were only reading the files and hadn't considered the atime 
update that read could trigger, thus effectively generating infinity 
write amplification because the read access did an atime update and 
turned what otherwise wouldn't be a write operation at all into one!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

