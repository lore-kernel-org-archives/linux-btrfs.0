From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [RFC PATCH 0/2] Change Size of Compressed Extent
Date: Tue,  3 May 2011 14:28:13 -0500
Message-ID: <1304450895-15586-1-git-send-email-mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


In recent thread on the list (see: "abysmal performance"), there
were some questions regarding why Btrfs seems to break up compressed files
into 32 block (128KB) chunks.

This is done for two reasons:
(1)  Ease the RAM required when spreading compression across several CPUs.
(2)  Make sure the amount of IO required to do a random read is
reasonably small.

The two attached patches show how to increase limit to 512KB (128 blocks).

I'm submitting these patches more for the purpose of documenting this issue
on the M/L.  I haven't fully explored the effect on performance.

As Chris Mason pointed out in the referenced thread, you would have to
decompress 512KB instead of just 128KB if you have a random read of
1KB in the middle of one of the chunks.

It should also be noted that just because filefrag reports the file as
fragmented, the extent fragments are often adjacent on the storage medium
(especially if you've just run defragment on that file).

It's possible that system performance could improve if the chunk size
was even smaller perhaps, instead of larger.

However, I have seen a decrease in the size of Metadata on my compressed
file systems after applying this patch, and defragmenting files with the
larger extent size.

Since I'd already done the experiment, and since someone was asking
about it, I thought I'd share my findings.
