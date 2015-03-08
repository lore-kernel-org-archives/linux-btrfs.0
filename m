Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:55616 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbbCHRnu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Mar 2015 13:43:50 -0400
Received: by mail-vc0-f178.google.com with SMTP id id10so8393946vcb.9
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Mar 2015 10:43:49 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 8 Mar 2015 11:43:49 -0600
Message-ID: <CAHu5UDn5rtL0-YwT52fxb8vkM7ikhjjE1hcCrC-V1PD-ua5UhA@mail.gmail.com>
Subject: Clone or Backup Filesystem with compression and dedup
From: dave <db.tone@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings,

I've searched the wiki and the web looking for possible answers to
this question and haven't found information that addresses this use
case specifically.  I would greatly appreciate your help or pointing
me in the right direction.

Thanks in advance!

Dave


Use case:

I have a 5TB single drive btrfs filesystem.  The filesystem is using
compression and deduplication (used bedup with size threshold of
~200kB resulting in 10s of thousands of deduplicated files).  The
space savings is fantastic!

I have 2 blank 5TB drives to be used as a rotating offline backup,
connecting to the computer once every few weeks and syncing the
new/changed data.  The data is mostly static, slowly growing with
ocassional changes.

What is the best way to:

1) make an initial clone of the filesystem, keeping the compression
and deduplication of the source filesystem?

2) make periodic syncronizations of the source filesystem to the
backup filesystem, again maintaining the compression and deduplication
of the filesystem?

I know that I can make a new empty btrfs filesystem then rsync and
bedup, but the file-level copy and bedup processes are very resource
heavy and time consuming.

I've also considered adding a blank drive to the source filesystem as
a raid mirror then breaking the mirror, but this seems like a brutal,
unintended use of btrfs raid/redundancy..

For many years I've used the rsync approach with XFS drives in
rotation, but now that I'm using (and enjoying) the much more
efficient storage of btrfs with compression and dedup I'm hoping there
is a more advanced method for making and maintaining backups.

Thank you!
