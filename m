Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:33165 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbbGGNO0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 09:14:26 -0400
Received: by laar3 with SMTP id r3so195074254laa.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2015 06:14:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559B7158.6050404@spotprint.com.au>
References: <CA+xOVSO2Cd1aYxAnA_Aq32oBTiMTbuo1YQo2cqEY_5WONQV=qA@mail.gmail.com>
	<20150706223404.GF7507@wotan.suse.de>
	<CA+xOVSNrX4yT=+0Xre8qpRrsA=+Nu0w5+fUa0oAbvXf0CFr35w@mail.gmail.com>
	<20150706230725.GG7507@wotan.suse.de>
	<559B7158.6050404@spotprint.com.au>
Date: Tue, 7 Jul 2015 16:14:24 +0300
Message-ID: <CA+xOVSN1v5v9z3=zP8E6phTV0c54pOCf7Rh10EBR4zkkFNVo4A@mail.gmail.com>
Subject: Re: running duperemove but no free space gain
From: Mordechay Kaganer <mkaganer@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

On Tue, Jul 7, 2015 at 9:27 AM, Ryan Bourne <hub@spotprint.com.au> wrote:
> To clarify, if I did the following:
>
> # btrfs subvolume create a
> # dd bs=1M count=10 if=/dev/urandom of=a/1
> # dd if=a/1 of=a/2
> # btrfs subvolume snapshot a b
>
> then I have four files containing the same data. a/1, b/1 share extents and a/2, b/2 share extents.
>
> If I then deduplicate a/1 and a/2 will all four files be sharing extents, or only three? (Assuming I have the patches for 4.2)
>

OK, i did a test almost exactly as you have suggested. It appears that
dedupe does not affect the "b" snapshot so only 3 of 4 files are
deduped, which explains no free space gain as the duplicate data is
still used.

Here's the log - fe_physical/fe_length can be used to figure out what
is actually deduped:

; Setup:

# btrfs sub create a
# dd bs=128K count=8 if=/dev/urandom of=a/1
# dd if=a/1 of=a/2
# btrfs subvolume snapshot a b

; Before dedupe:

# show-shared-extents a/1 a/2 b/1 b/2

(fiemap) [0] fe_logical: 0, fe_length: 524288, fe_physical:
3632062464, fe_flags: 0x2000 (shared )
(fiemap) [1] fe_logical: 524288, fe_length: 524288, fe_physical:
3632586752, fe_flags: 0x2001 (last shared )
a/1: 1048576 shared bytes

(fiemap) [0] fe_logical: 0, fe_length: 524288, fe_physical:
3633111040, fe_flags: 0x2000 (shared )
(fiemap) [1] fe_logical: 524288, fe_length: 524288, fe_physical:
3633635328, fe_flags: 0x2001 (last shared )
a/2: 1048576 shared bytes

(fiemap) [0] fe_logical: 0, fe_length: 1048576, fe_physical:
3632062464, fe_flags: 0x2001 (last shared )
b/1: 1048576 shared bytes

(fiemap) [0] fe_logical: 0, fe_length: 1048576, fe_physical:
3633111040, fe_flags: 0x2001 (last shared )
b/2: 1048576 shared bytes

; Dedupe:
# duperemove -d a/1 a/2
Using 128K blocks
Using hash: murmur3
Using 4 threads for file hashing phase
csum: a/1       [1/2] (50.00%)
csum: a/2       [2/2] (100.00%)
Hashing completed. Calculating duplicate extents - this may take some time.
[########################################]
Search completed with no errors.
Simple read and compare of file data found 1 instances of extents that
might benefit from deduplication.
Showing 2 identical extents with id 7ec588f6
Start           Length          Filename
0       1048576 "a/2"
0       1048576 "a/1"
Using 4 threads for dedupe phase
[0x1e42540] Try to dedupe extents with id 7ec588f6
[0x1e42540] Dedupe 1 extents (id: 7ec588f6) with target: (0, 1048576), "a/2"
Kernel processed data (excludes target files): 1048576
Comparison of extent info shows a net change in shared extents of: 0

; After dedupe:
# show-shared-extents a/1 a/2 b/1 b/2

(fiemap) [0] fe_logical: 0, fe_length: 524288, fe_physical:
3633111040, fe_flags: 0x2000 (shared )
(fiemap) [1] fe_logical: 524288, fe_length: 524288, fe_physical:
3633635328, fe_flags: 0x2001 (last shared )
a/1: 1048576 shared bytes

(fiemap) [0] fe_logical: 0, fe_length: 524288, fe_physical:
3633111040, fe_flags: 0x2000 (shared )
(fiemap) [1] fe_logical: 524288, fe_length: 524288, fe_physical:
3633635328, fe_flags: 0x2001 (last shared )
a/2: 1048576 shared bytes

(fiemap) [0] fe_logical: 0, fe_length: 1048576, fe_physical:
3632062464, fe_flags: 0x1 (last )
b/1: 0 shared bytes

(fiemap) [0] fe_logical: 0, fe_length: 1048576, fe_physical:
3633111040, fe_flags: 0x2001 (last shared )
b/2: 1048576 shared bytes


b/1 was not affected by duperemove. As far as i understand, after
creating snapshot the dedupe operation actually modifies the metadata
of a/1 and/or a/2 which causes it to be COWed so b's data is not
affected.

The conclusion is: to actually reclaim the duplicated space you have
to include all snapshots that may point to the file.

-- 
משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!
