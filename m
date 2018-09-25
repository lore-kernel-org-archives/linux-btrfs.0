Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr60088.outbound.protection.outlook.com ([40.107.6.88]:10427
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725970AbeIYGLU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 02:11:20 -0400
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: DUP dev_extent might overlap something next to it
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <b3461a38-e5f8-f41d-c67c-2efac8129054@mendix.com>
Date: Tue, 25 Sep 2018 02:05:48 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(I'm using v4.19-rc5 code here.)

Imagine allocating a DATA|DUP chunk.

In the chunk allocator, we first set...
  max_stripe_size = SZ_1G;
  max_chunk_size = BTRFS_MAX_DATA_CHUNK_SIZE
... which is 10GiB.

Then...
  /* we don't want a chunk larger than 10% of writeable space */
  max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
                       max_chunk_size);

Imagine we only have one 7880MiB block device in this filesystem. Now
max_chunk_size is down to 788MiB.

The next step in the code is to search for max_stripe_size * dev_stripes
amount of free space on the device, which is in our example 1GiB * 2 =
2GiB. Imagine the device has exactly 1578MiB free in one contiguous
piece. This amount of bytes will be put in devices_info[ndevs - 1].max_avail

Next we recalculate the stripe_size (which is actually the device extent
length), based on the actual maximum amount of available raw disk space:
  stripe_size = div_u64(devices_info[ndevs - 1].max_avail, dev_stripes);

stripe_size is now 789MiB

Next we do...
  data_stripes = num_stripes / ncopies
...where data_stripes ends up as 1, because num_stripes is 2 (the amount
of device extents we're going to have), and DUP has ncopies 2.

Next there's a check...
  if (stripe_size * data_stripes > max_chunk_size)
...which matches because 789MiB * 1 > 788MiB.

We go into the if code, and next is...
  stripe_size = div_u64(max_chunk_size, data_stripes);
...which resets stripe_size to max_chunk_size: 788MiB

Next is a fun one...
  /* bump the answer up to a 16MB boundary */
  stripe_size = round_up(stripe_size, SZ_16M);
...which changes stripe_size from 788MiB to 800MiB.

We're not done changing stripe_size yet...
  /* But don't go higher than the limits we found while searching
   * for free extents
   */
  stripe_size = min(devices_info[ndevs - 1].max_avail,
                    stripe_size);

This is bad. max_avail is twice the stripe_size (we need to fit 2 device
extents on the same device for DUP).

The result here is that 800MiB < 1578MiB, so it's unchanged. However,
the resulting DUP chunk will need 1600MiB disk space, which isn't there,
and the second dev_extent might extend into the next thing (next
dev_extent? end of device?) for 22MiB.

The last shown line of code relies on a situation where there's twice
the value of stripe_size present as value for the variable stripe_size
when it's DUP. This was actually the case before commit 92e222df7b
"btrfs: alloc_chunk: fix DUP stripe size handling", from which I quote:
  "[...] in the meantime there's a check to see if the stripe_size does
not exceed max_chunk_size. Since during this check stripe_size is twice
the amount as intended, the check will reduce the stripe_size to
max_chunk_size if the actual correct to be used stripe_size is more than
half the amount of max_chunk_size."

In the previous version of the code, the 16MiB alignment (why is this
done, by the way?) would result in a 50% chance that it would actually
do an 8MiB alignment for the individual dev_extents, since it was
operating on double the size. Does this matter?

Does it matter that stripe_size can be set to anything which is not
16MiB aligned because of the amount of remaining available disk space
which is just taken?

What is the main purpose of this round_up?

The most straightforward thing to do seems something like...
  stripe_size = min(
      div_u64(devices_info[ndevs - 1].max_avail, dev_stripes),
      stripe_size
  )
..just putting half of the max_avail into stripe_size.

I hope the above analysis is correct...

If this is fixed, then it will be the 5th commit in btrfs history which
tries to fix the same thing in this code again, where all the previous
ones were breaking things while fixing things.

The real problem is that in the very first version of this code, the
stripe_size variable was already reused for very different purposes
throughout the function. And it still is, all the time.

So, while it may seem very logical fix (again), I guess this needs more
eyes, since we missed this line the previous time. D:

-- 
Hans van Kranenburg
