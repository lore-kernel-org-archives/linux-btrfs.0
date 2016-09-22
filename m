Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:36614 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752510AbcIVMSh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 08:18:37 -0400
Received: by mail-qk0-f181.google.com with SMTP id z190so73720718qkc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 05:18:36 -0700 (PDT)
MIME-Version: 1.0
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
Date: Thu, 22 Sep 2016 07:18:35 -0500
Message-ID: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
Subject: unable to handle kernel paging request - btrfs
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have been getting panics consistently after doing a btrfs replace
operation on a raid1 and rebooting.  I linked a photo of the panic; I
haven't been able to get a text capture of it.

https://ibin.co/2vx0HhDeViu3.jpg

I'm getting this error on the latest 4.4, 4.1, and even on an old
3.18.26 kernel I had lying around.

I tried the remove root_log_ctx from ctx list before btrfs_sync_log
returns patch on 4.1 and that did not solve my problem either.

I'm able to boot into single-user mode and if I don't start any
processes the system seems fairly stable.  I am also able to start a
btrfs balance and run that for several hours without issue.  If I
start launching services the system will tend to panic, though how
many processes I can launch will vary.  I don't think that it is a
particular file being accessed that is triggering the issue since the
point where it fails varies.  I suspect it may be load-related.

Mounting with compress=no doesn't seem to help either.  Granted, I see
lzo_decompress in the backtrace and that is probably a read operation.

Any suggestions?  Google hasn't been helpful on this one...

Rich
