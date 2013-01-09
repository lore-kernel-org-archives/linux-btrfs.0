Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f179.google.com ([209.85.210.179]:38474 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3AIRhx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 12:37:53 -0500
Received: by mail-ia0-f179.google.com with SMTP id o25so1709113iad.24
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Jan 2013 09:37:52 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 9 Jan 2013 19:37:52 +0200
Message-ID: <CAOcd+r1VfBCRmDptpp47CLDAbH-o+NpAQxx42ou5JVG-hfM0PA@mail.gmail.com>
Subject: [PATCH 0/2] send: Avoid sending disknr==0 and PREALLOC extents when possible
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Alexander Block <ablock84@googlemail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Arne Jansen <sensille@gmx.net>, Chen Yang <chenyang.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These two patches address the issue of sending unneeded zero data for
disknr==0 and PREALLOC extents.
There is room for additional improvement for PREALLOC extents, but it
requires adding a new command, so for
now this is not addressed.

Please review and comment.

Thanks,
Alex.

Alex Lyakas (2):
  Avoid sending disknr==0 extents in the following cases:     1) full
    send 2) new inode in a diff-send 3) when disknr==0 extents are
    added to the end of an inode
  On a diff-send, avoid sending PREALLOC extents, if the parent root
    has only     PREALLOC extents on an appropriate file range.

 fs/btrfs/send.c |  178 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 172 insertions(+), 6 deletions(-)

--
1.7.9.5
