Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:39639 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2L0E1c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Dec 2012 23:27:32 -0500
Received: by mail-oa0-f54.google.com with SMTP id n9so8554350oag.27
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Dec 2012 20:27:32 -0800 (PST)
MIME-Version: 1.0
From: Slava Barinov <rayslava@gmail.com>
Date: Thu, 27 Dec 2012 08:27:11 +0400
Message-ID: <CADef55rak5VxVePgXtBz8fVpnqaWh2gRAfnGgZQT2QATJ4AS+Q@mail.gmail.com>
Subject: BUG at fs/btrfs/locking.c:265
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

  Twice for past two days I caught an error with btrfs, you can see a
fragment of dmesg on http://paste.org.ru/?kz4x31 and
http://paste.org.ru/?lwdeu3

  It's a buildserver with jenkins that several times an hour starts a
test script. The only problem I could suppose is using "subvolume
snapshot" feature in script. So, I have about two dozen of snapshots
that refresh periodically.

  Also, I'd like to add small feature request: it'll be good for
mount.btrfs  to show more valuable error messages. For example, if you
try to mount btrfs volume with wrong default subvolume-id, mount.btrfs
says:

 > mount: mount(2) failed: No such file or directory

  And there's nothing in dmesg that could help user to understand what
happened. I've lost about ten minutes trying to understand what does
it want from me.

Best regards,
Slava Barinov.
