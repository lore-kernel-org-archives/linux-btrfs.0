Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34433 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbbLaUym (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 15:54:42 -0500
Received: by mail-io0-f172.google.com with SMTP id 1so54409662ion.1
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 12:54:42 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 31 Dec 2015 13:54:42 -0700
Message-ID: <CAJCQCtR03dZ7ErDsYox4kaxFsNapxxNLxFiN9R0qSMSdp0-_hg@mail.gmail.com>
Subject: btrfs send clone use case
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I haven't previously heard of this use case for -c option. It seems to
work (no errors or fs weirdness afterward).

The gist: send a snapshot from drive 1 to drive 2; rw snapshot of the
drive 2 copy, and then make changes to it, then make an ro snapshot;
now send it back to drive 1 *as an incremental* send.

[dated subvolumes are ro, undated ones are rw]


# btrfs send /brick1/chrishome-20151128 | btrfs receive /brick2
# btrfs sub snap /brick2/chrishome-20151128 /brick2/chrishome
## make some modifications to chrishome contents
# btrfs sub snap -r /brick2/chrishome /brick2/chrishome-20151230
# btrfs send -p /brick2/chrishome-20151128 chrishome-20151230 | btrfs
receive /brick1
ERROR: check if we support uuid tree fails - Operation not permitted
At subvol chrishome:20151230/

However,

# btrfs send -p /brick2/chrishome-20151128 -c
/brick2/chrishome-20151128 chrishome-20151230 | btrfs receive /brick1

works. And it's fast (it's ~100G so I'd know if it weren't sending an
increment).

chrishome-20151128 is obviously identical on both sides in this case;
but I guess -c just acts to explicitly confirm this is true? The
brick2/chrishome-20151128 has a Received UUID that
matches the UUID of brick1/chrishome-20151128, so it seems their
identical states should be known?

Slightly confusing though: brick1/chrishome:20151230 (the one
resulting from the successful -p -c command) has the same Parent UUID
and Received UUID, which is the UUID for brick1/chrishome:20151128.
That's not really its parent, since it's a received subvolume I'd
expect this to be -, like it is for any other received subvolume
(which doesn't really have a parent).

Anyway it seems to be working.

-- 
Chris Murphy
