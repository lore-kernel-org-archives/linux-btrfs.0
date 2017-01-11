Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:36235 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760118AbdAKXNX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 18:13:23 -0500
Received: by mail-yb0-f194.google.com with SMTP id l23so97355ybj.3
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jan 2017 15:13:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT73Zh2F13tg3v4UZC3+rdTMhgC==Ag3LZQ-RZMTpisOg@mail.gmail.com>
References: <CAJCQCtRhgxqtrpnsibOPqkMA75Cf=ryRAeTb0Gf-ygy=gjD_Yg@mail.gmail.com>
 <CAJCQCtT73Zh2F13tg3v4UZC3+rdTMhgC==Ag3LZQ-RZMTpisOg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 11 Jan 2017 16:13:22 -0700
Message-ID: <CAJCQCtSZyfHdmsaVdEM7iQiKfK-s4Qqs4ORZrE1MCpWCgeCWbw@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like there's some sort of xattr and Btrfs interaction happening
here; but as it only happens with some subvolumes/snapshots not all
(but 100% consistent) maybe the kernel version at the time the
snapshot was taken is a factor? Anyway git bisect says

# first bad commit: [6c6ef9f26e598fb977f60935e109cd5b266c941a] xattr:
Stop calling {get,set,remove}xattr inode operations

btrfs-image produces a 159M file.

I've updated the bug report
https://bugzilla.kernel.org/show_bug.cgi?id=191761 and also adding
patch author to cc.


Chris Murphy
