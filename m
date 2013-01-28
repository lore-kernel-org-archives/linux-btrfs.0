Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:64846 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab3A1RBv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 12:01:51 -0500
Received: by mail-we0-f177.google.com with SMTP id d7so1629524wer.36
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 09:01:49 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 28 Jan 2013 19:01:48 +0200
Message-ID: <CAOcd+r0TW6oaHcASw7tujExyfpQbr-D-ahe01ff0+oo8m1qwjA@mail.gmail.com>
Subject: [PATCH 0/2] send: Avoid sending disknr==0 and PREALLOC extents when
 possible V3
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Cc: Chen Yang <chenyang.fnst@cn.fujitsu.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        Alexander Block <ablock84@googlemail.com>,
        Arne Jansen <sensille@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These two patches address the issue of sending unneeded zero data for
disknr==0 and PREALLOC extents.
There is room for additional improvement for PREALLOC extents, but it
requires adding a new send command, so for now this is not addressed.

Changes in V2: no functional change; previous patchset was malformed,
so cleanup done with checkpatch.pl.
Changes in V3: rebased against btrfs-next

Alex Lyakas (2):
  Avoid sending disknr==0 extents when possible.
  On a diff-send, avoid sending PREALLOC extents, if the     parent
    root has only PREALLOC extents on an appropriate     file range.

 fs/btrfs/send.c |  184 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 178 insertions(+), 6 deletions(-)

--
1.7.9.5
