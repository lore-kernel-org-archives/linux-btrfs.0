Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:52054 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbaH0FFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 01:05:02 -0400
Received: by mail-oi0-f51.google.com with SMTP id v63so4493397oia.24
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Aug 2014 22:05:01 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Aug 2014 22:05:01 -0700
Message-ID: <CADw2B2PYPJdcLWvkufY71kvAdCdgXhsdO2Gizf8hXAruppxXPA@mail.gmail.com>
Subject: fallocate fail on btrfs
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I try to run fallocate with "--keep-size" on my btrfs partitions,
it's failing, and I'm at a loss as to why. This was working in prior
versions.

Any suggestions on how to attack this problem? I'm betting I'm missing
something simple here, and have just gone down the rabbit hole...

BTW, I've confirmed that the line that fails is fallocate.c:368 [2],
with "open" always returning -1.

[1]
2014-08-26 21:58:28
root@eanna i /var/lib/libvirt/images # fallocate -n -l 10 test.test
fallocate: cannot open test.test: No such file or directory
zsh: exit 1     fallocate -n -l 10 test.test
2014-08-26 21:58:41
root@eanna i /var/lib/libvirt/images # fallocate -l 10 test.test
2014-08-26 21:58:52
root@eanna i /var/lib/libvirt/images # ls -alh
total 4.0K
drwxr-xr-x 1 root root  18 Aug 26 21:58 .
drwxr-xr-x 1 root root 100 Aug 26 17:39 ..
-rw-r--r-- 1 root root  10 Aug 26 21:58 test.test
2014-08-26 21:58:54
root@eanna i /var/lib/libvirt/images # umask
022
2014-08-26 21:59:03
root@eanna i /var/lib/libvirt/images # umask 000
2014-08-26 21:59:08
root@eanna i /var/lib/libvirt/images # rm test.test
removed ‘test.test’
2014-08-26 21:59:15
root@eanna i /var/lib/libvirt/images # fallocate -n -l 10 test.test
fallocate: cannot open test.test: No such file or directory
zsh: exit 1     fallocate -n -l 10 test.test
2014-08-26 21:59:19
root@eanna i /var/lib/libvirt/images # ls -alh
total 0
drwxr-xr-x 1 root root   0 Aug 26 21:59 .
drwxr-xr-x 1 root root 100 Aug 26 17:39 ..
2014-08-26 21:59:23
root@eanna i /var/lib/libvirt/images #

[2] fd = open(filename, O_RDWR | (!dig && !mode ? O_CREAT : 0), 0644);
