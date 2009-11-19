From: John Dong <jdong@ubuntu.com>
Subject: btrfsctl -d race with df -h causes hang?
Date: Thu, 19 Nov 2009 18:05:32 -0500
Message-ID: <549778BA-0D47-458D-8CE1-022885B2A2BB@ubuntu.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While attempting to do a full filesystem defrag and checking output of df -h, I've been able to fairly consistently generate a hang:


i.e. find / -type f -print0 | xargs -0i btrfsctl -d '{}'

and in another terminal, did "watch df -h"

Before long, everything hangs, iowait is near 100%, and no IO happens. I'm unable to get anything out of the kernel logs postmortem, dmesg also hangs.


FWIW, I was mounted -o compress.