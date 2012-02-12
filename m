From: lutz.euler@freenet.de (Lutz Euler)
Subject: Re: Bulk discard doesn't work after add/delete of devices
Date: Sun, 12 Feb 2012 18:01:31 +0100
Message-ID: <20279.61547.888033.662423@localhost.localdomain>
References: <20270.59513.240729.662692@localhost.localdomain>
	<4F3386D8.6010108@cn.fujitsu.com>
	<20275.60248.386622.516828@localhost.localdomain>
	<4F34795B.2020004@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Liu Bo <liubo2009@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F34795B.2020004@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

tl;dr: btrfs_trim_fs, IMHO, needs more thorough surgery.

Thanks for providing the new patch. I think it will work in the case
that "fstrim" is called without specifying a range to trim (that is,
defaulting to the whole filesystem), but I didn't test that yet, sorry.

Instead, I have been thinking about what happens if a range smaller than
the whole filesystem is specified. After all, the observation that in my
filesystem the smallest "objectid" is already larger than the filesystem
size still holds even in that case, and wanting to trim only part of the
filesystem seems to be a valid wish, too.

So I dug into the code myself and came to the conclusion that the
way "btrfs_trim_fs" interprets the range passed from the ioctl is
fundamentally broken.

Instead of papering over that I'd very much prefer a more thorough fix
here, which in addition might make it unnecessary to treat the "trim the
complete filesystem" case specially. Please read on for the details:

The current implementation of "btrfs_trim_fs" simply compares the
objectid's it finds in the chunk tree against the range passed from
the ioctl, seemingly assuming that both kinds of numbers span the same
range. But this is clearly not true: Even without adding and deleting
of devices, in a simple mirror the objectids will span only about half
the size of the filesystem. With suitable add/delete of devices I can
construct a filesystem with a smallest objectid of 0 and a largest
objectid much larger than the size of the filesystem (so, obviously,
with large holes in the set of used objectid's), or, as in my filesystem
mentioned above, with a smallest objectid larger than the size of the
filesystem.

So, in the function the statement
  cache = btrfs_lookup_block_group(fs_info, range->start);
will lead to nothing being trimmed if the smallest objectid is too
large; if the
  if (cache->key.objectid >= (range->start + range->len))
is left in, too little will be trimmed; if it is left out, the following
calculations
  start = max(range->start, cache->key.objectid);
  end = min(range->start + range->len,
            cache->key.objectid + cache->key.offset);
  if (end - start >= range->minlen)
are bound to misbehave, for example start being larger than end seems
possible, overflowing the subtraction and, I believe, leading to the
whole filesystem being trimmed where the user only requested a part.

Here is the start of the chunk tree of my filesystem for reference,
showing the device sizes and the first objectid:

chunk tree
node 241620221952 level 1 items 2 free 119 generation 16831 owner 3
fs uuid 88af7576-3027-4a3b-a5ae-34bfd167982f
chunk uuid 9a7d25e3-ebcf-4f31-bdd4-f44531a2fb1c
        key (DEV_ITEMS DEV_ITEM 3) block 241620226048 (58989313) gen
          16831
        key (FIRST_CHUNK_TREE CHUNK_ITEM 231956545536) block
          241620230144 (58989314) gen 16831
leaf 241620226048 items 19 free space 1420 generation 16831 owner 3
fs uuid 88af7576-3027-4a3b-a5ae-34bfd167982f
chunk uuid 9a7d25e3-ebcf-4f31-bdd4-f44531a2fb1c
        item 0 key (DEV_ITEMS DEV_ITEM 3) itemoff 3897 itemsize 98
                dev item devid 3 total_bytes 80789987328 bytes used
                  44090523648
        item 1 key (DEV_ITEMS DEV_ITEM 4) itemoff 3799 itemsize 98
                dev item devid 4 total_bytes 80025313280 bytes used
                  44090523648
        item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 213702934528) itemoff
          3687 itemsize 112
                chunk length 1073741824 owner 2 type 20 num_stripes 2
                        stripe 0 devid 4 offset 1074790400
                        stripe 1 devid 3 offset 40870346752

So, to make bulk discard of ranges useful, it seems the incoming range
should be interpreted relative to the size of the filesystem and not to
the allocated chunks. As AFAIK the size of the filesystem is just the
sum of the sizes of its devices it might be possible to map the range
onto a virtual concatenation of the devices, these perhaps ordered by
devid, and then to find the free space by searching for the resulting
devid(s) and device-relative offsets in the device tree?

I understand that currently unallocated space is never trimmed?
To nevertheless do that might be useful after a balance or at file
system creation time? If there is a way to find the unallocated space
for a device, this could be improved at the same time, too.

Kind regards,

Lutz
