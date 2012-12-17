Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:53207 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2LQMFD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 07:05:03 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so4628938lag.19
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 04:05:02 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 17 Dec 2012 13:05:01 +0100
Message-ID: <CAMiUzp95BXF8fcNb9EQQsrz1NpDtX9qr=FdC9C=+r3KYkYxgzw@mail.gmail.com>
Subject: Online Deduplication for Btrfs (Master's thesis)
From: =?UTF-8?B?TWFydGluIEvFmcOtxb5law==?= <martin.krizek@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: lczerner@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

my name is Martin Krizek. I am a student at Faculty of Information, Brno
University of Technology, Czech Republic. As my master's thesis I chose to work
on Online Deduplication for Btrfs.

My goal is to study Btrfs design, the offline deduplication patch [1] and to
come up with a design for the online dedup, this semester. I will be
implementing
the feature next semester (spring, that is).

I would like to shortly introduce my ideas on what I think the feature
should look
like.

* Use cases
The two main use cases for the dedup are:
1. virtual machine images
2. backup servers

* When to dedup
The choice of 'when to dedup' is not up to me as the master's thesis
specification
states "online". :)

* What to dedup
I'd say the most reasonable is block-level deduplication as it seems the most
general approach to me.

* Controlling dedup
- turn on/off deduplication - specify subvolumes on which
deduplication is turned on
 (mount, ioctl - inherited),
- turn on/off byte-by-byte comparison of blocks that have same hashes
(mount, ioctl),
- deduplication statistics (ioctl)

* Limitations
Not really limitations, but this is a list of situations when dedup will not
be triggered:
- encryption,
- compression - basically, dedup is kind of compression, might be worth to into
  it in the future though
- inline/prealloc extents,
- data across subvolumes

* How to store hashes
The obvious choice would be to use the checksum tree that holds block checksums
of each extent. The problem with the checksum tree is that the
checksums are looked up by logical address for the start of the extent data.
This is undesirable since it needs to be done the other way around. Logical
addresses need to be looked up by a hash.
To solve this, another key type would be created inside the checksum tree (or
maybe better, a new tree would be introduced) that
would have a hash as item's right-hand key value. This way, items could be
looked up on a hash:
(root, HASH_ITEM, hash)
The root value says which root (subvolume) is hashed block stored on. The hash
value is hash itself.
The item data would be of the following structure:
struct btrfs_hash_item {
__le64 disk_bytenr;
__le64 disk_num_bytes;
__le64 offset;
}
Fields disk_bytenr and disk_num_bytes would point to a
extent item of the extent allocation tree. The offset is a offset of a hashed
block in the extent.

* When to trigger dedup exactly
So It might be appropriate to delay the process just before data are
written out to disk to give data the chance to be changed. I looked a bit into
the compression code and it seems like dedup could use the similar aproach -
to have threads that would do dedup on sync or general writeback.

* Hash algorithm
sha256 seems like a safe choice.

* Future improvements
There are some features that might be considered if time permits or as something
that could be implemented in the future:
- dedup across subvolumes
- specify a hash algorithm
- specify number of deduplication blocks


I would appreciate any comments you might have, thanks!

Best regards,
Martin Krizek


[1] http://lwn.net/Articles/422331/
