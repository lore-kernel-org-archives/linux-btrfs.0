From: Avi Kivity <avi@redhat.com>
Subject: packing structures and numbers
Date: Fri, 03 Oct 2008 14:42:50 +0300
Message-ID: <48E6053A.8010100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been reading btrfs's on-disk format, and two things caught my eye

- attribute((packed)) structures everywhere, often with misaligned 
fields.  This conserves space, but can be harmful to in-memory 
performance on some archs.
- le64's everywhere.   This scales nicely, but wastes space.  My home 
directory is unlikely to have more than 4G objects or 4GB extents (let 
alone >2 devices).

I think the two issues can be improved by separating the on-disk format 
and the in-memory structure, and by using uleb128 as the on-disk format 
for numbers.  uleb128 is a variable-length format that encodes 7 bits of 
a number in each byte, using the eighth bit as a stop bit.

So, for example

struct btrfs_disk_key {
    __le64 objectid;
    u8 type;
    __le64 offset;
} __attribute__ ((__packed__));

With 1M objectids, and 1T offsets, this reduces in size from 17 bytes to 
10 bytes.  Most other structures show similar gains.  We can also have 
more than 256 types if the need arises.

There are, off course, disadvantages to switching to uleb128:

- need to write encode and decode functions, which is tedious.  This can 
be automated a la xdr.
- increased cpu utilization for decoding and encoding
- can no longer know the size of the in-memory structures in advance
- it's just wonderful to rewrite the entire disk format so close to 
freezing it

The advantages, IMO, outweigh the disadvantages:

- better packing reduces tree depth and therefore seekage, the most 
important cost on rotating media
- the disk format is infinitely growable
- in-memory format is more efficient for archs which prefer aligned accesses

I'm not volunteering to do this, but please consider this proposal.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

