Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:43479 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3D0Jtx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Apr 2013 05:49:53 -0400
Received: by mail-qc0-f175.google.com with SMTP id j3so2487680qcs.34
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Apr 2013 02:49:53 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 27 Apr 2013 11:42:07 +0200
Message-ID: <CABNez5RD9qzZ7-hM7u0-mwUx5MFCMOOCsqW-LBxQx-vcmoKcdg@mail.gmail.com>
Subject: 
From: =?UTF-8?B?UGV0ZXIgV8O8cnR6?= <pwuertz@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I recently had some trouble with my root and home btrfs filesystems.
My system (Ubuntu 13.04, Kernel 3.8) started freezing when copying
larger numbers of files around (hard freeze, no logs about what
happened).

At some time booting up wasn't possible anymore due to a kernel bug
while mounting the homefs. Btrfsck built from git wasn't able to
repair the fs and segfaulted. Btrfs-zero-log was able to make home
mountable again and the fs is clean since then according to btrfsck.

The system appeared ok, but then I ran into trouble performing an
apt-get upgrade, which was unable to access some of its files due to a
"stale NFS lock". I found no kernel messages in dmesg concerning that
matter, just this user-space error message. An offline check of the
root file system (booting from USB live system) showed up some errors.
Btrfsck wasn't able to repair them and segfaulted. I reinstalled the
system now.

Btrfsck on the root fs:
https://docs.google.com/file/d/0B7RIDdXgzUrqTUczWHZYejUzMWM/edit?usp=sharing
Btrfs-image of the root fs:
https://docs.google.com/file/d/0B7RIDdXgzUrqV3hEZ1BZX0lhbVk/edit?usp=sharing

Kernel-bug when mounting the home fs:
https://docs.google.com/file/d/0B7RIDdXgzUrqTGFneGdCM0FBYzg/edit?usp=sharing
Btrfsck on the home fs:
https://docs.google.com/file/d/0B7RIDdXgzUrqODVhUUhqa2Q4c0k/edit?usp=sharing
Btrfs-zero-log on home fs:
https://docs.google.com/file/d/0B7RIDdXgzUrqM3ltTnBUVWMzdjg/edit?usp=sharing

I still have an image (dd and btrfs-image) of the broken homefs. If
this is of any use to you feel free to contact me via email.

Best regards,
Peter
