Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:63956 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3JLCWE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 22:22:04 -0400
Received: by mail-ee0-f53.google.com with SMTP id b15so2252879eek.40
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2013 19:22:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131008071232.GA1402@localhost.localdomain>
References: <CAOMFOmWzXL5G22Z7srkvXe+p+F9U7atOoiV5jRHc9i0k4kUfnA@mail.gmail.com>
	<CAOMFOmX95ebV=myVO1yDf5yPs7DfmvHDKDFwNNfT0CajDQ=W4Q@mail.gmail.com>
	<20131008071232.GA1402@localhost.localdomain>
Date: Fri, 11 Oct 2013 19:22:02 -0700
Message-ID: <CAOMFOmWOwdkwpuiEQbWYRoUDXEKGy_JqM0BtN2AhSF7JHDq69Q@mail.gmail.com>
Subject: Re: Linux Arch: kernel BUG at fs/btrfs/inode.c:873!
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org, Zach Brown <zab@zabbo.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Kernel 3.12-rc built from HEAD has the same issue as 3.10 and 3.11

Ok, I was able to "fix" my problem by booting from an old kernel
(3.8.7) and it allowed me to mount the fs. Then I removed
/var/log/journal directory. After that I was able to boot with 3.11.
So I believe 3.9/3.10 has a regression in how it handles COW files. As
I described above, some time ago I defraged journald files and set +C
attribute to /var/log/journal (both to the folders and existing
files).

So 3.11 boots fine and the only boot warning I see is

Oct 11 19:06:55 brest kernel: BTRFS error (device sdd3): block group
1141416919040 has wrong amount of free space
Oct 11 19:06:55 brest kernel: BTRFS error (device sdd3): failed to
load free space cache for block group 1141416919040


I tried 'btrfsck -repair' but it crashes so I cannot even check or
repair my btrfs mount.
