Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35408 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964844AbeALVEo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 16:04:44 -0500
Date: Fri, 12 Jan 2018 22:04:40 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Subject: invalid files names, btrfs check can't repair it
Message-ID: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

so I had bad memory and before I realized it and removed it btrfs took some
damage. Now I have this:

|ls -lh crap/
|ls: cannot access 'crap/2f3f379b2a3d7499471edb74869efe-1948311.d': No such file or directory
|ls: cannot access 'crap/454bf066ddfbf42e0f3b77ea71c82f-878732.o': No such file or directory
|total 0
|-????????? ? ? ? ?            ? 2f3f379b2a3d7499471edb74869efe-1948311.d
|-????????? ? ? ? ?            ? 454bf066ddfbf42e0f3b77ea71c82f-878732.o

and in dmesg I see:

| BTRFS critical (device sda4): invalid dir item type: 33
| BTRFS critical (device sda4): invalid dir item name len: 8231

`btrfs check' (from v4.14.1) finds them and prints them but has no idea
what to do with it. Would it be possible to let the check tool rename
the offended filename to something (like its inode number) put it in
lost+found if it has any data attached to it and otherwise simply remove
it? Right now I can't remove that folder.

Sebastian
