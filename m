Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65379 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab2JHRlI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 13:41:08 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so3793257obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2012 10:41:07 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 12:41:07 -0500
Message-ID: <CAKcLGm8-FYv7CSZ+W9DKtL95fA3nt0Uv9xK77AvqqPeeefySsw@mail.gmail.com>
Subject: Two Issues with Btrfs Delayed Cleaner Process (linux-next)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've run across two issues with the delayed cleaner process running a
kernel based on the 3.6.0 btrfs-next branch in Josef's git repository.

(1)  I'm getting an error when trying to list my subvolumes whenever
the cleaner thread is running:

# btrfs su li /mnt/benchmark/
ERROR: Failed to lookup path for root 0 - No such file or directory

As long as the cleaner thread is idle, I can run this command without error.

(2)  I ran into an issue on a slower x86 machine (AMD Athlon XP 2600+)
where the cleaner thread literally required an hour to finish deleting
a subvolume that contained the sources for a kernel I had previously
built.

The machine was responsive the whole time, and the cleaner thread
never required much more than 5-10% of the CPU, leaving ample idle
time.

Interestingly, every attempt to replicate this behaviour resulted in
the cleaner thread finishing in a few seconds.

My first issue replicates every time the cleaner thread is running.

I'll need to work on the second issue for a while to see if I can get
it to replicate.
