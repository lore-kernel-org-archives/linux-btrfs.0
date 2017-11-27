Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:60678 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751690AbdK0JnA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 04:43:00 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id D64E9487F179
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Nov 2017 17:42:52 +0800 (CST)
Date: Mon, 27 Nov 2017 17:41:56 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: How about adding an ioctl to convert a directory to a subvolume?
Message-ID: <20171127094156.GC29491@fnst.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

As we all know, under certain circumstances, it is more appropriate to
create some subvolumes rather than keep everything in the same
subvolume. As the condition of demand change, the user may need to
convert a previous directory to a subvolume. For this reason，how about
adding an ioctl to convert a directory to a subvolume?

Users can convert by the scripts mentioned in this
thread(https://www.spinics.net/lists/linux-btrfs/msg33252.html), but is
it easier to use the off-the-shelf btrfs subcommand?

After an initial consideration, our implementation is broadly divided
into the following steps:
1. Freeze the filesystem or set the subvolume above the source directory
to read-only;
2. Perform a pre-check, for example, check if a cross-device link
creation during the conversion;
3. Perform conversion, such as creating a new subvolume and moving the
contents of the source directory;
4. Thaw the filesystem or restore the subvolume writable property.

In fact, I am not so sure whether this use of freeze is appropriate
because the source directory the user needs to convert may be located
at / or /home and this pre-check and conversion process may take a long
time, which can lead to some shell and graphical application suspended.

Please give your comments if any.

-- 
Thanks,
Lu


