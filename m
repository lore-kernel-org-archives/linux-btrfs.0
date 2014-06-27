Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:44726 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaF0Bh3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 21:37:29 -0400
Received: by mail-vc0-f179.google.com with SMTP id id10so4366532vcb.24
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 18:37:28 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 26 Jun 2014 21:37:27 -0400
Message-ID: <CAGfcS_kSiDOYCQ7XRE46W36Kygdpe=58xcax4FZPS9EHLRt9DA@mail.gmail.com>
Subject: Blocked tasks on 3.15.1
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been getting blocked tasks on 3.15.1 generally at times when the
filesystem is somewhat busy (such as doing a backup via scp/clonezilla
writing to the disk).

A week ago I had enabled snapper for a day which resulted in a daily
cleanup of about 8 snapshots at once, which might have contributed,
but I've been limping along since.

Here is a pastebin of my dmesg from the hung tasks and a subsequent Alt-SysRq-W:

http://pastebin.com/yYdcxFTE

When this happens the system remains somewhat stable, but no writes to
the disk succeed, and I start getting load averages in the dozens as
tasks start blocking.

On reboot the system generally works fine, though it can hang a day or
two later.

I'm happy to try patches, or try to capture any other output that is
helpful the next time this happens - the system is fairly stable as
long as I capture things someplace other than my btrfs file systems.
I didn't see anything quite like this on the list.  I updated my
kernel around the time this behavior started, and was on 3.15.0
previously (though I haven't tried reverting yet).

Rich
