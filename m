Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:35720 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdATEjC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 23:39:02 -0500
Received: by mail-yb0-f178.google.com with SMTP id l23so42794204ybj.2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jan 2017 20:38:27 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <chris@colorremedies.com>
Date: Thu, 19 Jan 2017 21:38:26 -0700
Message-ID: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
Subject: btrfs check lowmem vs original
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All of my Btrfs file systems, including new ones, have errors
according to lowmem mode, and no errors reported at all for original
mode. So which is correct? If lowmem mode is correct, then there are
obviously kernel bugs that are causing problems right away, even on
minutes old file systems.

I can't tell from the output whether these are serious errors or minor
errors either, because the output from check is totally
incomprehensible. Further the usage summary at the end, extent bytes,
and fs bytes, etc. are different, sometimes by an order of magnitude,
between lowmem and original.

Errors like this:

ERROR: block group[46200258560 1073741824] used 1073741824 but extent
items used 1144422400
ERROR: block group[85928706048 1073741824] used 1073741824 but extent
items used 0
ERROR: block group[178270502912 1073741824] used 1073741824 but extent
items used 1083211776
ERROR: block group[360806612992 1073741824] used 1073479680 but extent
items used 1074769920
ERROR: extent[366498091008, 134217728] referencer count mismatch
(root: 818, owner: 73782, offset: 134217728) wanted: 4, have: 26

One file system has over 100 lines (exactly the same thing, no difference)

ERROR: data extent[16913485824 7577600] backref lost

Another file system, 15 minutes old with two mounts in its whole
lifetime, and only written with kernel 4.10-rc3 has over 30 lines of
varying numbers:

ERROR: root 257 EXTENT DATA[150134 11317248] prealloc shouln't have datasum

That file system should have no preallocated extents (It's a clean
installation of Fedora Rawhide, using only rsync)

Again, zero errors with original mode; but all file systems of all
ages have errors with lowmem. This is kindof annoying to say the
least, it's like we're adding dice to the check and repair situation
on Btrfs which is already incredibly more complicated and unhelpful
than any other file system.

btrfs-progs 4.9.
kernels vary from 4.4 to 4.10-rc4, but one fs is only a month old
having used 4.7 and 4.8 kernels; and another one just 4.10-rc3 as I
said.


-- 
Chris Murphy
