Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:41517 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759009Ab3EBRly (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 May 2013 13:41:54 -0400
Received: by mail-oa0-f44.google.com with SMTP id h1so815981oag.31
        for <linux-btrfs@vger.kernel.org>; Thu, 02 May 2013 10:41:54 -0700 (PDT)
MIME-Version: 1.0
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Date: Thu, 2 May 2013 19:41:33 +0200
Message-ID: <CADn-QaPVg6C3sMhkasZc+JsoaQ_YQJB-nnoQRKd+XW7sXc1tew@mail.gmail.com>
Subject: btrfs subv list -> ERROR: Failed to lookup path for root 0 - No such
 file or directory
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

I'm on Ubuntu 13.04 with Ubuntu kernel 3.8.0-19-lowlatency and
Btrfs v0.20-rc1.

Sometimes, I'm unable to list the subvolumes of a filesystem, like so:

root@ask-home:~# btrfs subv list /home
ERROR: Failed to lookup path for root 0 - No such file or directory

This was after I removed a few snapshots of this subvolume.

To be able to list again, I've got to do a "list -a":

root@ask-home:~# btrfs subv list -a /home
ID 256 gen 28692 top level 5 path <FS_TREE>/home
ID 257 gen 28695 top level 256 path a
ID 258 gen 28695 top level 5 path <FS_TREE>/Cloud
ID 276 gen 28695 top level 5 path <FS_TREE>/Media
ID 277 gen 28695 top level 5 path <FS_TREE>/Cloud/Dropbox
ID 283 gen 28695 top level 5 path <FS_TREE>/VirtualBox

Then the normal list works again:

root@ask-home:~# btrfs subv list /home
ID 257 gen 28695 top level 256 path a

Reg. the "<FS_TREE>" - that's (I guess...) because I mounted the
subvolume at /home; see /etc/fstab:

root@ask-home:~# grep /home /etc/fstab
/dev/ssd/Data /home btrfs defaults,noatime,ssd,discard,subvol=home 0 0

Why's that happening? Should I report this as a bug on bugzilla?

Regards,

Alexander
--
=>        Google+ => http://plus.skwar.me         <==
=> Chat (Jabber/Google Talk) => a.skwar@gmail.com <==
