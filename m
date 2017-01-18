Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:33807 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbdARV1P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jan 2017 16:27:15 -0500
Received: by mail-yb0-f195.google.com with SMTP id w194so1064697ybe.1
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jan 2017 13:27:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSZyfHdmsaVdEM7iQiKfK-s4Qqs4ORZrE1MCpWCgeCWbw@mail.gmail.com>
References: <CAJCQCtRhgxqtrpnsibOPqkMA75Cf=ryRAeTb0Gf-ygy=gjD_Yg@mail.gmail.com>
 <CAJCQCtT73Zh2F13tg3v4UZC3+rdTMhgC==Ag3LZQ-RZMTpisOg@mail.gmail.com> <CAJCQCtSZyfHdmsaVdEM7iQiKfK-s4Qqs4ORZrE1MCpWCgeCWbw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 18 Jan 2017 14:27:13 -0700
Message-ID: <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 11, 2017 at 4:13 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Looks like there's some sort of xattr and Btrfs interaction happening
> here; but as it only happens with some subvolumes/snapshots not all
> (but 100% consistent) maybe the kernel version at the time the
> snapshot was taken is a factor?

The kernel version at the time the snapshot is taken is not a factor.
I've taken a snapshot of a working subvolume, and booting the snapshot
fails during startup with the fs forced readonly with kernel 4.9 and
higher; the problem doesn't happen with kernel 4.8.17 and lower.

As a further test I tried:


git checkout tags/v4.9
git revert 6c6ef9f26e598fb977f60935e109cd5b266c941a

But I get a failure during compile:

scripts/Makefile.build:293: recipe for target 'fs/xattr.o' failed
make[1]: *** [fs/xattr.o] Error 1
Makefile:988: recipe for target 'fs' failed
make: *** [fs] Error 2

Anyway, the inability to boot snapshots means bootable rollbacks are
broken. I think this is a serious regression, what's the next step in
figuring out what's going on?


-- 
Chris Murphy
