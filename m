From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: disk space caching generation missmatch
Date: Wed, 1 Dec 2010 17:46:14 +0100
Message-ID: <201012011746.14458.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After enabling disk space caching I've observed several log entries like this:

btrfs: free space inode generation (0) did not match free space cache generation (169594) for block group 15464398848

I'm not sure, but it seems this happens on every reboot. Is this something to
worry about?

regards,
  Johannes
