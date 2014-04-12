Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:42701 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaDLNoV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Apr 2014 09:44:21 -0400
Received: by mail-ig0-f172.google.com with SMTP id hn18so1855373igb.5
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Apr 2014 06:44:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5348ea4572e7_5d4d7ac86c27677@209.249.196.67.mail>
References: <5348ea4572e7_5d4d7ac86c27677@209.249.196.67.mail>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 12 Apr 2014 07:44:00 -0600
Message-ID: <CAErSpo6krGvMZk+80cTZm=72v9RzXyh5uYnOxzXzqLXHNh4hgg@mail.gmail.com>
Subject: Fwd: New Defects reported by Coverity Scan for Linux
To: Harald Hoyer <harald@redhat.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FYI, this warning was introduced by 0723a0473fb4 ("btrfs: allow
mounting btrfs subvolumes with different ro/rw options").

It looks like "newargs" is eventually used in mount_fs(), so I think
this one is real.

---------- Forwarded message ----------
From:  <scan-admin@coverity.com>
Date: Sat, Apr 12, 2014 at 1:24 AM
Subject: New Defects reported by Coverity Scan for Linux

...

** CID 1201425:  Use after free  (USE_AFTER_FREE)
/fs/btrfs/super.c: 1193 in mount_subvol()
/fs/btrfs/super.c: 1197 in mount_subvol()

...
________________________________________________________________________________________________________
*** CID 1201425:  Use after free  (USE_AFTER_FREE)
/fs/btrfs/super.c: 1193 in mount_subvol()
1187            mnt = vfs_kern_mount(&btrfs_fs_type, flags, device_name,
1188                                 newargs);
1189            kfree(newargs);
1190
1191            if (PTR_RET(mnt) == -EBUSY) {
1192                    if (flags & MS_RDONLY) {
>>>     CID 1201425:  Use after free  (USE_AFTER_FREE)
>>>     Passing freed pointer "newargs" as an argument to "vfs_kern_mount".
1193                            mnt = vfs_kern_mount(&btrfs_fs_type,
flags & ~MS_RDONLY, device_name,
1194                                                 newargs);
1195                    } else {
1196                            int r;
1197                            mnt = vfs_kern_mount(&btrfs_fs_type,
flags | MS_RDONLY, device_name,
1198                                                 newargs);
/fs/btrfs/super.c: 1197 in mount_subvol()
1191            if (PTR_RET(mnt) == -EBUSY) {
1192                    if (flags & MS_RDONLY) {
1193                            mnt = vfs_kern_mount(&btrfs_fs_type,
flags & ~MS_RDONLY, device_name,
1194                                                 newargs);
1195                    } else {
1196                            int r;
>>>     CID 1201425:  Use after free  (USE_AFTER_FREE)
>>>     Passing freed pointer "newargs" as an argument to "vfs_kern_mount".
1197                            mnt = vfs_kern_mount(&btrfs_fs_type,
flags | MS_RDONLY, device_name,
1198                                                 newargs);
1199                            if (IS_ERR(mnt))
1200                                    return ERR_CAST(mnt);
1201
1202                            r = btrfs_remount(mnt->mnt_sb, &flags, NULL);


________________________________________________________________________________________________________
To view the defects in Coverity Scan visit,
http://scan.coverity.com/projects/128?tab=Overview

To unsubscribe from the email notification for new defects,
http://scan5.coverity.com/cgi-bin/unsubscribe.py
