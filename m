Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56035 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751257AbdBYLzi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Feb 2017 06:55:38 -0500
Received: from [10.0.0.4] ([95.171.32.30]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MKIEQ-1cjFdh2UuE-001gqh for
 <linux-btrfs@vger.kernel.org>; Sat, 25 Feb 2017 12:55:35 +0100
From: Lukas Tribus <lukyt@gmx.net>
Subject: linux 4.8 kernel OOM
To: linux-btrfs@vger.kernel.org
Message-ID: <5d68d16c-8dd8-ca69-a345-a64350d5f65f@gmx.net>
Date: Sat, 25 Feb 2017 12:55:34 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey guys,

I believe I have seen a OOM situations reported on the ML and IRC 
recently, both of
which are believed to be unrelated to btrfs, which this case is probably 
as well; I just
want to provide my dmesg here anyway in case it turns out to be related 
to btrfs
nonetheless.

The following is a OOM situation with a headless Ubuntu 16.04.02 LTS 
server running
linux 4.8, while copying a lot of files from a broken btrfs FS (thread 
"BTRFS
critical: corrupt leaf, slot offset bad; then read-only") to a external 
USB3.0 with
btrfs as well.

The box has 16GB of RAM, but this (XEN dom0) is limited to 10 of the 
16GB of physical
RAM.

We can see that the OOM killer is pretty desperate and basically kills a 
lot of
innocent userspace processes, including systemd, sshd, bash, and some 
others.

Not saying this has to be investigated, just keep this dmesg in mind in 
case you see
similar reports.

Box is still running for the next 24 hours in case anyone has 
troubleshooting
suggesting, but the OOM condition pretty much cleared:

~$ free -m
               total        used        free      shared buff/cache 
available
Mem:           9956          87        8625           3 1243        9664
Swap:         10239          23       10216
~$ uname -a
Linux srv1-dom0 4.8.0-39-generic #42~16.04.1-Ubuntu SMP Mon Feb 20 
15:06:07 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
~$ btrfs version
btrfs-progs v4.4
~$


dmesg pastebin:
http://pastebin.com/raw/yTPh19m4


Omitted inline dmesg as it doesn't fi in 100KB.



cheers,
lukas

