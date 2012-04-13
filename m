From: Alexander Block <ablock84@googlemail.com>
Subject: Questions about file extents and alignment
Date: Fri, 13 Apr 2012 10:42:50 +0200
Message-ID: <CAB9VWqA2bF26CnaeYCT4zfeLjDkNeG+DCQBnQb-uDTPnBh_8qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Using find-new, I've seen that all regular extents seem to be 4k
aligned. Inline extents were not aligned.
Is it guaranteed that all regular extents are 4k aligned in
disk_bytenr, disk_num_bytes, offset and num_bytes? Even if COW or what
ever may happen happens?

Thanks,
Alex.
