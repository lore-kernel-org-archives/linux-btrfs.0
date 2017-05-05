Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f169.google.com ([209.85.213.169]:36017 "EHLO
        mail-yb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751454AbdEEV0u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 May 2017 17:26:50 -0400
Received: by mail-yb0-f169.google.com with SMTP id s22so870889ybe.3
        for <linux-btrfs@vger.kernel.org>; Fri, 05 May 2017 14:26:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPktuGtTVMFcrh1QRgnXXiS9HvrKDEYK9kAumUGToY+ycaMoCA@mail.gmail.com>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <CAJCQCtRXCWuCbchRxOBZA7Dfzt4vhED77d1boErTdOGAzAi4vw@mail.gmail.com>
 <CAPktuGtqt-tVNvbxkdaEB7PshWVpDHsxfHYMujOkAvOP9aiJ6w@mail.gmail.com>
 <CAJCQCtRNEYcJ5duGNYoTFKX-nBbK15FV_2jZ0UrZrhiDo5rkDw@mail.gmail.com> <CAPktuGtTVMFcrh1QRgnXXiS9HvrKDEYK9kAumUGToY+ycaMoCA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 5 May 2017 15:26:49 -0600
Message-ID: <CAJCQCtQSzG3FvBksHGqAnF49yz1aYgy_gNr=NCSzuXeSLv+Lkw@mail.gmail.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Alexandru Guzu <alexguzu@gmail.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please reply to all. You keep dropping Qu and the Btrfs list off your responses.

On Fri, May 5, 2017 at 2:22 PM, Alexandru Guzu <alexguzu@gmail.com> wrote:
> I booted a Live CD with btrfs-progs 4.10.2 and ran a check on the
> partition, the regular btrfs check did not find any errors, but the
> lowmem one did find errors:
>
> btrfs check --mode lowmem /dev/sda1
> Checking filesystem on /dev/sda1
> UUID: bc8af368-8565-48d8-a16b-e2d25061f6ac
> checking extents
> checking free space cache
> checking fs roots
> ERROR: root 5 EXTENT_DATA[627 12288] csum missing, have: 0, expected: 4096
> ERROR: root 5 EXTENT_DATA[627 20480] csum missing, have: 0, expected: 45056
> ERROR: root 5 EXTENT_DATA[627 73728] csum missing, have: 0, expected: 4096
> ERROR: root 5 INODE[627] nbytes(2928640) not equal to extent_size(2981888)
> ERROR: root 5 EXTENT_DATA[5759 4096] csum missing, have: 0, expected: 4096
> ERROR: root 5 INODE[5759] nbytes(12288) not equal to extent_size(16384)
> ERROR: root 5 EXTENT_DATA[5760 4096] csum missing, have: 0, expected: 12288
> ERROR: root 5 INODE[5760] nbytes(53248) not equal to extent_size(65536)
> ERROR: root 5 EXTENT_DATA[284832 4096] csum missing, have: 0, expected: 24576
> ERROR: root 5 INODE[284832] nbytes(8192) not equal to extent_size(32768)
> ERROR: root 5 EXTENT_DATA[284834 36864] csum missing, have: 0, expected: 253952
> ERROR: root 5 INODE[284834] nbytes(40960) not equal to extent_size(294912)
> ERROR: root 5 EXTENT_DATA[839436 8192] interrupt
> ERROR: errors found in fs roots
> found 4971778048 bytes used, error(s) found
> total csum bytes: 4042156
> total tree bytes: 831029248
> total fs tree bytes: 815988736
> total extent tree bytes: 10010624
> btree space waste bytes: 221535838
> file data blocks allocated: 4330766336
>  referenced 5587816448
>
> I suppose I should attempt a repair?

No, the lowmem mode doesn't support repair yet. I'd expect normal mode
won't repair anything if it doesn't find problems.

>I have no important data on this drive.
> I haven't deleted the Firefox cache yet.
> btrfs scrub did not find any errors

I think you've found a bug in kernel handling, we'll just have to see
what Qu says.

I would go with the deleting of the Firefox cache first, and then if
necessary reinstall just Firefox. Are there other things that trigger
it?


-- 
Chris Murphy
