Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60711 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753884AbcLUWOs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Dec 2016 17:14:48 -0500
MIME-Version: 1.0
Message-ID: <trinity-6a0e983c-9cfd-479a-8f3a-593c8c30b7b0-1482358484582@3capp-mailcom-bs03>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: "Chris Murphy" <lists@colorremedies.com>
Cc: "Giuseppe Della Bianca" <bepi@adria.it>,
        "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
 during the snapshot receive
Content-Type: text/plain; charset=UTF-8
Date: Wed, 21 Dec 2016 23:14:44 +0100
In-Reply-To: <CAJCQCtSZf+Z12HzhNHX8XMXZH4peNVQ=a_kbFJS3gUUKq=_T0g@mail.gmail.com>
References: <1479730155.5832e3eb3fde8@webmail.adria.it>
 <9712851.I7FUyRd5GC@exnet.gdb.it>
 <trinity-46cbb3e7-b072-4e9a-a504-e67b58cc9c9c-1482096970056@3capp-mailcom-bs08>
 <1843121.XhPNI7cFmJ@exnet.gdb.it>
 <trinity-f5b0b96e-286c-4485-a02e-1f96bca7a906-1482255789582@3capp-mailcom-bs06>
 <1482323222.585a7516d6aa4@webmail.adria.it>
 <CAJCQCtR0k9gr5XQ=5jUXYTFrntui3t6-tdf6uvAJpAV_ue6B0w@mail.gmail.com>,
 <CAJCQCtSZf+Z12HzhNHX8XMXZH4peNVQ=a_kbFJS3gUUKq=_T0g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Racing condition can happen, if running multiple transfers to the same destination.
Would you like to tell how many transfers are the scripts running at a time to a specific hdd?

Thanks,
Xin
 

Sent: Wednesday, December 21, 2016 at 1:11 PM
From: "Chris Murphy" <lists@colorremedies.com>
To: No recipient address
Cc: "Giuseppe Della Bianca" <bepi@adria.it>, "Xin Zhou" <xin.zhou@gmx.com>, "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
On Wed, Dec 21, 2016 at 2:09 PM, Chris Murphy <lists@colorremedies.com> wrote:
> What about CONFIG_BTRFS_FS_CHECK_INTEGRITY? And then using check_int
> mount option?

This slows things down, and in that case it might avoid the problem if
it's the result of a race condition.

--
Chris Murphy
