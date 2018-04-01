Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f177.google.com ([74.125.82.177]:45367 "EHLO
        mail-ot0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752325AbeDAXaL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Apr 2018 19:30:11 -0400
Received: by mail-ot0-f177.google.com with SMTP id h26-v6so14098635otj.12
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Apr 2018 16:30:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3247ca88-4ea6-f5a7-d21c-0b3105e9a7f3@gmx.com>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com> <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
 <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com> <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>
 <d8973b92-b320-5088-aae6-2b3835f1b2ca@gmx.com> <CAJCQCtSjBWMauccwremxQ+eCTTBXsz=VEXFy=ckABpKtC-9NTw@mail.gmail.com>
 <af39cb86-693c-2f3b-7831-60968d3b5c3d@gmx.com> <CAJCQCtS6tXcKRuwZiAfB8eUkENz6secVcvxYS=syCFp_VH_+Vw@mail.gmail.com>
 <56401bb3-39fb-66d9-f77b-30e164bd8973@gmx.com> <CAJCQCtQiTt78svzzdcV_Pm2iPK6RgYLXsvMda7H6aQeMf2w07g@mail.gmail.com>
 <4b7a0fae-ca96-7583-90d0-37cabc78849b@gmx.com> <CAJCQCtSezvyBGBQJRwQ+aeJH+8_8QsihkFD-iZaEVFeoL-00+Q@mail.gmail.com>
 <a95813ad-d87e-bd5a-a258-c3d241fa5181@gmx.com> <CAJCQCtSAfYxZigvrgAq=vw3anMKiPK=ZWnOvC+mbR__XUW8ugA@mail.gmail.com>
 <3247ca88-4ea6-f5a7-d21c-0b3105e9a7f3@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 1 Apr 2018 17:30:09 -0600
Message-ID: <CAJCQCtT_W+VJuAr7eXwomrq4R=r+qZV_QmS0jxBvA4pXGktVzQ@mail.gmail.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[chris@f27h linux]$ git apply -v
~/RESEND-1-2-btrfs-Enhance-btrfs_trim_fs-function-to-handle-error-better.patch
Checking patch fs/btrfs/extent-tree.c...
Hunk #1 succeeded at 10942 (offset -6 lines).
Hunk #2 succeeded at 10962 (offset -6 lines).
Hunk #3 succeeded at 10974 (offset -6 lines).
Hunk #4 succeeded at 10988 (offset -6 lines).
Hunk #5 succeeded at 11025 (offset -6 lines).
Applied patch fs/btrfs/extent-tree.c cleanly.
[chris@f27h linux]$ git apply -v
~/v2.2-2-2-btrfs-Ensure-btrfs_trim_fs-can-trim-the-whole-fs.patch
Checking patch fs/btrfs/extent-tree.c...
Hunk #1 succeeded at 10961 (offset -6 lines).
Checking patch fs/btrfs/ioctl.c...
Hunk #1 succeeded at 364 (offset -1 lines).
Hunk #2 succeeded at 387 (offset -1 lines).
Applied patch fs/btrfs/extent-tree.c cleanly.
Applied patch fs/btrfs/ioctl.c cleanly.

compiles fine, and test appears to trim more than before, and the file
system still works and scrubs with no errors (did scrub with
4.15.14.fc28).

[chris@f27h ~]$ uname -r
4.16.0-rc7 (mainline, unpatched)
[chris@f27h ~]$ sudo btrfs fi us /
Overall:
    Device size:          70.00GiB
    Device allocated:          46.06GiB
    Device unallocated:          23.94GiB
    Device missing:             0.00B
    Used:              43.90GiB
    Free (estimated):          25.86GiB    (min: 13.89GiB)
    Data ratio:                  1.00
    Metadata ratio:              1.00
    Global reserve:         109.94MiB    (used: 0.00B)

Data,single: Size:44.00GiB, Used:42.08GiB
   /dev/nvme0n1p9      44.00GiB

Metadata,single: Size:2.00GiB, Used:1.82GiB
   /dev/nvme0n1p9       2.00GiB

System,DUP: Size:32.00MiB, Used:16.00KiB
   /dev/nvme0n1p9      64.00MiB

Unallocated:
   /dev/nvme0n1p9      23.94GiB
[chris@f27h ~]$ sudo fstrim -v /
[sudo] password for chris:
/: 24 GiB (25701646336 bytes) trimmed
[chris@f27h ~]$

==============

[chris@f27h ~]$ uname -r
4.16.0-rc7+ (mainline, plus patch)
[chris@f27h ~]$ sudo btrfs fi us /
Overall:
    Device size:          70.00GiB
    Device allocated:          46.06GiB
    Device unallocated:          23.94GiB
    Device missing:             0.00B
    Used:              43.90GiB
    Free (estimated):          25.86GiB    (min: 13.89GiB)
    Data ratio:                  1.00
    Metadata ratio:              1.00
    Global reserve:         110.06MiB    (used: 0.00B)

Data,single: Size:44.00GiB, Used:42.08GiB
   /dev/nvme0n1p9      44.00GiB

Metadata,single: Size:2.00GiB, Used:1.82GiB
   /dev/nvme0n1p9       2.00GiB

System,DUP: Size:32.00MiB, Used:16.00KiB
   /dev/nvme0n1p9      64.00MiB

Unallocated:
   /dev/nvme0n1p9      23.94GiB
[chris@f27h ~]$ sudo fstrim -v /
[sudo] password for chris:
/: 26.5 GiB (28394635264 bytes) trimmed
[chris@f27h ~]$


---
Chris Murphy
