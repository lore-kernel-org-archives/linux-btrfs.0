Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:49140 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdANTi6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Jan 2017 14:38:58 -0500
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id B711160017
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Jan 2017 20:38:53 +0100 (CET)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: python-btrfs v5, yay
To: linux-btrfs@vger.kernel.org
Message-ID: <21458b49-50ad-161f-588d-26fb52bcf857@mendix.com>
Date: Sat, 14 Jan 2017 20:38:52 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just tagged v5 of the python btrfs library:

https://github.com/knorrie/python-btrfs

>From CHANGES:

python-btrfs v5, Jan 14 2017
  * Revamp and fix loading of extent backreferences.
  * Explode when detecting a non x86_64 arch.
  * Add a crc32c implementation and example script to create
    a dir_item offset hash.

  The biggest change is done in the loading of backreferences of data
and metadata extents. The way it was done was plain wrong in a number of
cases and ignored/missed a bunch of types of objects. See the commits
since v4 and their messages for much more detailed info.

  And, instead of fixing the library to work correctly for non-amd64
users, it currently explodes preventively, which is at least better than
using wrong IOCTL numbers.

  The third change, the crc32c addition is a bit of a weird duck in the
bite, but I didn't want to leave it out yet:

In the previous weekend, I was able to help out a user on IRC to repair
a metadata page which had about 10 bytes overwritten with crap (in
memory) that really didn't belong there. btrfs-debug-tree even
segfaulted on the result. By loading a 16kiB metadata page, which was
dd-ed from the disk in python-btrfs with some missing datastructures
hacked in, we ended up with a very convenient way to look around in the
data and set the attributes of two metadata item records to the right
values and write back the page to the 16kiB binary file. Because a
dir_item was involved, which needed to get the right filename crc in the
key offset field again, we had to figure out how to create it, and I
learned that crc32c doesn't mean a single thing, because I took me a
while to find out why every crc32c lib I could find gave me the
consistent same result, being different than what btrfs crc32c would show...

And yes, after writing back the metadata page, the filesystem was usable
again! :-)

Have fun,

-- 
Hans van Kranenburg
