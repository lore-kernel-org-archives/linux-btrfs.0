Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:40521 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752211AbeDKPdX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 11:33:23 -0400
Received: by mail-it0-f48.google.com with SMTP id u62-v6so3138567ita.5
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 08:33:22 -0700 (PDT)
MIME-Version: 1.0
From: Tom Vincent <tom@tlvince.com>
Date: Wed, 11 Apr 2018 16:33:21 +0100
Message-ID: <CAG4vCreOmBdsPT84ajozGb4XV83+Fc-joyUqXgizutPah0VrrA@mail.gmail.com>
Subject: btrfs fails to mount after power outage
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My btrfs laptop had a power outage and failed to boot with "parent
transid verify failed..." errors. (I have backups).

I couldn't rw mount on a live disk, but could ro mount. I tried btrfs
scrub and then btrfs check --repair to no avail. However, btrfs rescue
zero-log _did_ work; the drive can be rw mounted and the machine boots
fine again.

Although there doesn't appear to be an immediate data loss, there's
still a transid error during boot. "BTRFS error (device dm-0): parent
transid verify failed on 115490816 wanted 339949 found 340182".

If I umount and re-run btrfs check, I'm given further transid errors
and pages of "inode [n] errors 2001, no inode item, link count wrong".

What steps should I take now?

btrfs progs 4.15
kernel 4.15.15
NVMe drive
