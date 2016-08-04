Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:33990 "EHLO
	mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934729AbcHDXiP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Aug 2016 19:38:15 -0400
Received: by mail-ua0-f178.google.com with SMTP id 35so185991590uap.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Aug 2016 16:38:14 -0700 (PDT)
MIME-Version: 1.0
From: Peter Holm <peter.g.holm@gmail.com>
Date: Fri, 5 Aug 2016 01:32:31 +0200
Message-ID: <CAOZhre2ZytraEyHzVb1zY6FmAJUC4xun0fpWRQS=Z8ZKWff0jg@mail.gmail.com>
Subject: possible bug - wrong path in 'btrfs subvolume show' when snapshot is
 in path below subvolume.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'btrfs subvolumee show' gives no path to btrfs system root (volid=5)
when snapshot is in the folder of subvolume.

Step to reproduce.
1.btrfs subvolume create xyz
2.btrfs subvolume snapshot xyz xyz/xyz
3.btrfs subvolume snapshot <mountpoint-for-btrfs-root>/xyz
4.btrfs subvolumme show xyz
output
.....
Snapshot(s)
                         xyz
                         xyz
.....
picture from my console reproducing this. Whatchout for my personal fs-layout
my mountpoint for volid=5 is - as seen in the findmount command  r at
top of the photo /mnt/btrfs/sdc16-svid-5
https://s31.postimg.org/9f0d7xb7f/is_this_a_bug.png

If that can add anything, same thing happends when rootvolume is
mounted by path. (for the moment it is mounted by volid).
/Peter Holm
