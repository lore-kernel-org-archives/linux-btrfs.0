Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:54583 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161183Ab3DGBqm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2013 21:46:42 -0400
Received: by mail-oa0-f41.google.com with SMTP id f4so5122692oah.28
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Apr 2013 18:46:41 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 7 Apr 2013 07:16:41 +0530
Message-ID: <CANu+oN1szXCzLDqeT8UMCz660dO47dDTa8PTL1KFUoG6z-u_rQ@mail.gmail.com>
Subject: [BUG] btrfs.fsck failing to fix corrupted block
From: Shripad Ratnaparkhi <shripad.ratnaparkhi@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,
I am newbie and recently started using btrfs. Now facing a weird problem.

FWIW, I am on archlinux, kenel v3.8.0, having Btrfs v0.20-rc1.
After an abnormal reboot, getting these errors while boot:

systemd.fsck[289]: checking extents
systemd.fsck[289]: checking fs roots
systemd.fsck[289]: checking root refs
systemd.fsck[289]: found 23728128 bytes used err is 0
systemd.fsck[289]: total csum bytes: 23092
systemd.fsck[289]: total tree bytes: 81920
systemd.fsck[289]: total fs tree bytes: 24576
systemd.fsck[289]: btree space waste bytes: 38038
systemd.fsck[289]: file data blocks allocated: 23646208
systemd.fsck[289]: referenced 23646208
systemd.fsck[289]: Btrfs v0.20-rc1
[   OK   ]  Started File System Check on /dev/sda1.
               Mounting /boot...
systemd.fsck[289]: checking extents
[   OK   ] Mounted /boot.
[   OK   ] Reached target Sound Card.
systemd.fsck[289]: checking fs roots
systemd.fsck[289]: checking root refs
systemd.fsck[289]: extent buffer leak: start 206893056 len 4096
systemd.fsck[289]: *** Error in `fsck.btrfs`: corrupted double-linked
list: 0x0000000002081d80 ***

and its not proceeding and stuck here.
I have the rescue disk handy, but not sure how can I fix this issue.
Any help please.

thanks,

--
~shripadr
