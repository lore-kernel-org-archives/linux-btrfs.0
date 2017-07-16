Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33809 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbdGPGWh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Jul 2017 02:22:37 -0400
Received: by mail-lf0-f47.google.com with SMTP id t72so71298702lff.1
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Jul 2017 23:22:36 -0700 (PDT)
Subject: Re: Destination's Received UUID and source's UUID are not the same
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>, linux-btrfs@vger.kernel.org
References: <CAN4oSBc3WX6jDcMXYB_MEOT+t9NZaWWzU__vQHmpcTLV22P_Uw@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <aac42650-6e35-b2b1-4243-0ebaa57ec37c@gmail.com>
Date: Sun, 16 Jul 2017 09:22:32 +0300
MIME-Version: 1.0
In-Reply-To: <CAN4oSBc3WX6jDcMXYB_MEOT+t9NZaWWzU__vQHmpcTLV22P_Uw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

16.07.2017 02:03, Cerem Cem ASLAN пишет:
> A few days ago I tried to copy my backups to another machine by using
> my external hard drive. `btrfs send my-backup | btrfs receive
> /path/to/backup/dir` didn't go right since destination snapshot's
> "Received UUID" does not match with source's "UUID". Here are relevant
> stackoverflow question:
> 
> https://unix.stackexchange.com/questions/377914/how-to-test-if-two-btrfs-snapshots-are-identical
> 
> Is it a bug?

Well, "btrfs send" will use received UUID instead of subvolume UUID if
one exists. I presume intention is to be able to replicate received
subvolume. So A -> B -> C has the same effect as A -> C, making C yet
another copy of A.
