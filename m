Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:53771 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2LZF2k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Dec 2012 00:28:40 -0500
Received: by mail-ob0-f181.google.com with SMTP id oi10so7647316obb.12
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Dec 2012 21:28:39 -0800 (PST)
MIME-Version: 1.0
From: Slava Barinov <rayslava@gmail.com>
Date: Wed, 26 Dec 2012 09:28:18 +0400
Message-ID: <CADef55oohdCgsAeQGd5LTb94D689fmXPOzPxAV8Ka-dj7EW8sw@mail.gmail.com>
Subject: FS Error
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

  I've just caught an error with btrfs, you can see a fragment of
dmesg on http://paste.org.ru/?kz4x31

  It's a buildserver with jenkins that several times an hour starts a
test script. The only problem I could suppose is using "subvolume
snapshot" feature in script. So, I have about two dozen of snapshots
that refresh periodically.

  The good fact: btrfsck worked fine, I lost no data :)

  Also, I'd like to add small feature request: it'll be good for
mount.btrfs  to show more or less valuable error messages. For
example, if you try to mount btrfs volume with wrong default
subvolume-id, mount.btrfs says:

 > mount: mount(2) failed: No such file or directory

  And there's nothing in dmesg that could help user to understand what
happened. I've lost about ten minutes trying to understand what does
it want from me.

Best regards,
Slava Barinov.
