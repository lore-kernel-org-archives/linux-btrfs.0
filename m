Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:40132 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbaE2PdH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 11:33:07 -0400
Received: by mail-yh0-f49.google.com with SMTP id c41so417207yho.36
        for <linux-btrfs@vger.kernel.org>; Thu, 29 May 2014 08:33:06 -0700 (PDT)
MIME-Version: 1.0
From: Rasmus Eskola <fruitiex@gmail.com>
Date: Thu, 29 May 2014 18:32:45 +0300
Message-ID: <CADiq+R44LEu+x-UXWtKOm9Gp0-05bPhXKY=j19pFZ_YPr+_p+g@mail.gmail.com>
Subject: btrfs-receive rename error
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm trying to send an incremental backup of a btrfs subvolume to
another host using the command:

sudo btrfs send -v /home/backup/2014-05-29_02:26:38 | ssh "root@s"
"btrfs receive -v /btrfs/backup_bulky/home"

Eventually it stops with the following error:
ERROR: rename o941570-199282-0 ->  failed. Not a directory

Seems like a bug to me, I tried searching for inodes '941570' or
'199282' but came up with no results on either. btrfsck reports no
problems.

Any ideas on how to solve this or debug it further? The subvolume is
around 400 gb large, and it's a few days since I made the previous
incremental backup, so I unfortunately haven't been able to find any
root cause or a way to reproduce the bug outside of this subvolume.

At the time of writing I'm running the 3.15.0-rc1 kernel with
btrfs-progs v3.14 on both machines.

Best regards,
Rasmus Eskola
