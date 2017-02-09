Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59172 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752305AbdBIBns (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 20:43:48 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id D55A8207E0
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Feb 2017 20:42:18 -0500 (EST)
Message-Id: <1486604538.3944846.875079560.7B23E81D@webmail.messagingengine.com>
From: Ian Kelling <ian@iankelling.org>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: csum failed, checksum error, questions
Date: Wed, 08 Feb 2017 17:42:18 -0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a file read fail repeatably, in syslog, lines like this

kernel: BTRFS warning (device dm-5): csum failed ino 2241616 off
51580928 csum 4redacted expected csum 2redacted

I rmed the file.

Another error more recently, 5 instances which look like this:
kernel: BTRFS warning (device dm-5): checksum error at logical
16147043602432 on dev /dev/mapper/dev-name-redacted, sector 1177577896,
root 4679, inode 2241616, offset 51597312, length 4096, links 1 (path:
file/path/redacted)
kernel: BTRFS error (device dm-5): bdev /dev/mapper/dev-name-redacted
errs: wr 0, rd 0, flush 0, corrupt 5, gen 0
kernel: BTRFS error (device dm-5): unable to fixup (regular) error at
logical 16147043602432 on dev /dev/mapper/dev-name-redacted

In this case, I think the file got rmed as well.

I'm assuming this is a problem with the drive, not btrfs. Any opinions
on how likely catastrophic failure of the drive is?

Is rming the problematic file sufficient? How about if the subvolume
containing this bad file was previously snapshotted?

Is there anything else besides "kernel: BTRFS (error|warning)" that I
should grep for my syslog to watch for filesystem/drive problems?
For example, is there anything in addition to error/warning like 
"fatal" or "critical"?

For at least the second error, I was running
Linux 4.9.0-1-amd64 #1 SMP Debian 4.9.2-2 (2017-01-12) x86_64 GNU/Linux
btrfs-progs 4.7.3-1

Thanks,
Ian Kelling
