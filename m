Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:41362 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3FZVF1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 17:05:27 -0400
Received: by mail-ob0-f180.google.com with SMTP id eh20so14113777obb.11
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 14:05:26 -0700 (PDT)
MIME-Version: 1.0
From: Roger Pack <rogerpack2005@gmail.com>
Date: Wed, 26 Jun 2013 15:04:56 -0600
Message-ID: <CADCGFBV-5OMDCD-EVtsUsKnSBOifF2+sjYHHmgR0WKOoLLsQXw@mail.gmail.com>
Subject: some feedbacks seen on btrfs
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First off, thanks for an awesome file system, it is working well for
my purposes of compressing a  filesystem on a small VPS.  Woot!

I thought I'd call out a few things (in the hopes of spurring
improvements) I'd seen about btrfs (in case they weren't common
knowledge...):

http://linux.slashdot.org/story/13/04/26/1231213/btrfs-is-getting-there-but-not-quite-ready-for-production
links to
http://www.anchor.com.au/blog/2013/04/the-btrfs-backup-experiment/
which mentions problems when they start to "fill up" a btrfs filesystem.

Also, in the slashdot comments, saw this:
"...nice features, speed ok, but i happened to unplug by mistake the
power supply, without a battery. bad crash... I tried using btrfsck,
and other debug tools, even in the "dangerdon'teveruse" git branch,
they just segfaulted. at the end my filesystem was unrecoverable, I
used btrfs-restore, only to find out that 90% of my files had been
truncated to 0... even files i didn't use for months....now, maybe it
was the compress=lzo option, or maybe I played a little too much with
the repair tools (possible)...
btrfs is supposed to save a consistent state every 30 seconds, so I
don't understand how I messed up that bad.... maybe the superblock was
gone and the btrfsck --repair borked everything, I don't know....
luckily for me: backups :)"

FWIW.
Thanks again!
-roger-
