Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62358 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaKIWRH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Nov 2014 17:17:07 -0500
Received: by mail-wg0-f51.google.com with SMTP id l18so7315794wgh.24
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Nov 2014 14:17:06 -0800 (PST)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 0/2] add progress indicator to btrfs-convert
Date: Sun,  9 Nov 2014 23:16:54 +0100
Message-Id: <cover.1415549388.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi btrfs-ml,

I have tried a ext4->btrfs conversation of a 1TB (90%full) and have seen that
btrfs has no progressbar or something like that. Furthermore I have found [1] a
project idea for this.

I have tried a generic tasklet-based solution to print the status of the
convert-process. Maybe it looks good to you than please add this to your repo.
I have implemented this with the linux specific timerfd facility. To enable
this you haver to use the '-p' option.

I have noticed that a conversation doesn't show all inodes as converted at the
end. How can I improve this? A complete convert-process is showd here:

	sfr@devhost ./btrfs-progs % ./btrfs-convert -p /dev/sde4
	creating btrfs metadata.
	copy inodes [o] [        96/       106]
	creating ext2fs image file.
	cleaning up system chunk.
	conversion complete.

[1] https://btrfs.wiki.kernel.org/index.php/Project_ideas#btrfs-convert

Bye and thanks,
Silvio


Silvio Fricke (2):
  btrfs-progs: add task-utils
  btrfs-progs: convert: use task for progress indication of metadata
    creation

 Documentation/btrfs-convert.txt |   2 +
 Makefile                        |   6 +--
 btrfs-convert.c                 |  60 ++++++++++++++++++++++--
 task-util.c                     | 101 ++++++++++++++++++++++++++++++++++++++++
 task-util.h                     |  32 +++++++++++++
 5 files changed, 193 insertions(+), 8 deletions(-)
 create mode 100644 task-util.c
 create mode 100644 task-util.h

-- 
2.1.2

