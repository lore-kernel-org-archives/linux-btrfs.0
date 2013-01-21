Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:39720 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3AUKWh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 05:22:37 -0500
Received: by mail-wg0-f53.google.com with SMTP id fn15so3696923wgb.20
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2013 02:22:33 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Jan 2013 12:22:32 +0200
Message-ID: <CAOcd+r35boyF4QzFUoJ3wU2fQDWGNu-izjk9X3u8hx+8_GPR+g@mail.gmail.com>
Subject: [PATCH 0/2] send: Avoid sending disknr==0 and PREALLOC extents when
 possible V2
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>,
        Alexander Block <ablock84@googlemail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        Chen Yang <chenyang.fnst@cn.fujitsu.com>
Cc: Arne Jansen <sensille@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These two patches address the issue of sending unneeded zero data for
disknr==0 and PREALLOC extents.
There is room for additional improvement for PREALLOC extents, but it
requires adding a new send command, so for now this is not addressed.

Changes in V2: no functional change; previous patchset was malformed,
so cleanup done with checkpatch.pl.

Please review and comment.

Alex Lyakas (2):
  Avoid sending disknr==0 extents when possible.
  On a diff-send, avoid sending PREALLOC extents, if the parent
    root has only PREALLOC extents on an appropriate file range.

 fs/btrfs/send.c |  184 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 178 insertions(+), 6 deletions(-)

--
1.7.9.5
