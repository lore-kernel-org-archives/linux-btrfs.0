Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:34659 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab3A1PtW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 10:49:22 -0500
Received: by mail-la0-f43.google.com with SMTP id ek20so903884lab.30
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 07:49:21 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 28 Jan 2013 10:49:20 -0500
Message-ID: <CAAdM644AsDFfyj_9PEFthNBbcnNc_jy4dxMZmbrb9dBHeK5xkw@mail.gmail.com>
Subject: bug: per file cow flag is lost when renaming
From: Marios Titas <redneb8888@gmail.com>
To: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Try this:

    touch test
    chattr +C test
    lsattr test
    mv test test2
    lsattr test2

The original file (test) will have the C flag but when renamed the
flag disappears. If the volume is unmounted and then mounted again the
flag reappears. However, if the file is modified in any way after the
renaming but before the umount/mount then even weirder things happen,
eg:

    touch test
    chattr +C test
    head -c1048576 /dev/zero >> test
    lsattr test
    # the C flag exists and the file does not COW when modified as expected
    mv test test2
    lsattr test2
    # now the C flag disappeared
    # if you modify the file it will COW and the flag will not
reappear after umount/mount

even worse, if you try to use BTRFS_IOC_CLONE to clone test2 to a
non-COW file with eg

    cp --reflink test2 test3

it will fail with EINVAL as if the file test2 had the COW flag.
