Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:47533 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2LQNdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 08:33:25 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so5457278iay.19
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 05:33:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMiUzp95BXF8fcNb9EQQsrz1NpDtX9qr=FdC9C=+r3KYkYxgzw@mail.gmail.com>
References: <CAMiUzp95BXF8fcNb9EQQsrz1NpDtX9qr=FdC9C=+r3KYkYxgzw@mail.gmail.com>
Date: Mon, 17 Dec 2012 14:33:24 +0100
Message-ID: <CAB9VWqCjoFGdZVx0Uup2zmvuqS2PHiQO=h2EKawH-dZiGqvfDQ@mail.gmail.com>
Subject: Re: Online Deduplication for Btrfs (Master's thesis)
From: Alexander Block <ablock84@gmail.com>
To: =?UTF-8?B?TWFydGluIEvFmcOtxb5law==?= <martin.krizek@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        lczerner@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I did some research on deduplication in the past and there are some
problems that you will face. I'll try to list some of them (for sure
not all).

On Mon, Dec 17, 2012 at 1:05 PM, Martin Křížek <martin.krizek@gmail.com> wrote:
> Hello everyone,
>
> my name is Martin Krizek. I am a student at Faculty of Information, Brno
> University of Technology, Czech Republic. As my master's thesis I chose to work
> on Online Deduplication for Btrfs.
>
> My goal is to study Btrfs design, the offline deduplication patch [1] and to
> come up with a design for the online dedup, this semester. I will be
> implementing
> the feature next semester (spring, that is).
The offline dedup patch is quite old and won't apply/compile anymore.
You should probably look into the clone ioctl which basically does the
same as the extent_same ioctl from the patch. Based on the clone ioctl
you can at least learn how to "inject" existing extents into other
inodes.
>
> I would like to shortly introduce my ideas on what I think the feature
> should look
> like.
>
> * Use cases
> The two main use cases for the dedup are:
> 1. virtual machine images
> 2. backup servers
>
> * When to dedup
> The choice of 'when to dedup' is not up to me as the master's thesis
> specification
> states "online". :)
>
> * What to dedup
> I'd say the most reasonable is block-level deduplication as it seems the most
> general approach to me.
Here you have two options:
1. Based on the per volume tree where you'll find btrfs_file_extent
items which point to the global extent tree.
2. Based on the global extent tree. By using the backref resolving
code, you can find which volumes refer to these extents.
>
> * Controlling dedup
> - turn on/off deduplication - specify subvolumes on which
> deduplication is turned on
>  (mount, ioctl - inherited),
> - turn on/off byte-by-byte comparison of blocks that have same hashes
> (mount, ioctl),
> - deduplication statistics (ioctl)
You'll get trouble when online dedup is turned on and off again. While
it is offline, extents still get written, but you won't have your hash
tree up-to-date. You'll need to find a way to update when dedup is
online again, without too much performance loos while updating.
>
> * Limitations
> Not really limitations, but this is a list of situations when dedup will not
> be triggered:
> - encryption,
I've already heard somewhere else that encryption+dedup is not
possible but I don't understand why. Can someone explain this
limitation?
> - compression - basically, dedup is kind of compression, might be worth to into
>   it in the future though
> - inline/prealloc extents,
Should be possible to dedup inline extents, but must be configurable
(e.g. minimum block size). People should also be able to completely
disable it when performance is important.
> - data across subvolumes
Should be possible. See my comment on the key in the hash tree.
>
> * How to store hashes
> The obvious choice would be to use the checksum tree that holds block checksums
> of each extent. The problem with the checksum tree is that the
> checksums are looked up by logical address for the start of the extent data.
> This is undesirable since it needs to be done the other way around. Logical
> addresses need to be looked up by a hash.
> To solve this, another key type would be created inside the checksum tree (or
> maybe better, a new tree would be introduced) that
> would have a hash as item's right-hand key value. This way, items could be
> looked up on a hash:
> (root, HASH_ITEM, hash)
> The root value says which root (subvolume) is hashed block stored on. The hash
> value is hash itself.
With the root inside the key you make it impossible to allow
cross-subvolume deduplication. Also, the offset field in the key that
you plan to use for the hash is only 64bit, so you can at best store a
part of the hash in the key. You should probably split the hash into 3
parts: 64bit to put into the objectid field, 64bit to put into the
offset field and the remainder into the item data. A lookup would then
do the necessary splitting and in case a match is found also compare
the remainder found in the items data.
> The item data would be of the following structure:
> struct btrfs_hash_item {
> __le64 disk_bytenr;
> __le64 disk_num_bytes;
> __le64 offset;
> }
You could omit the offset here and and store the sum of disk_bytenr
and offset in one field. You could also omit the disk_num_bytes field
if you have a fixed dedup block length. The reason: No matter what you
store here, you never know if the referred extent is still existent
and still contains the same data. So when you found a possible
duplicate, a lookup into the extent tree is required to make sure it
is still valid. Probably the extents generation can help here.
> Fields disk_bytenr and disk_num_bytes would point to a
> extent item of the extent allocation tree. The offset is a offset of a hashed
> block in the extent.
>
> * When to trigger dedup exactly
> So It might be appropriate to delay the process just before data are
> written out to disk to give data the chance to be changed. I looked a bit into
> the compression code and it seems like dedup could use the similar aproach -
> to have threads that would do dedup on sync or general writeback.
It's important that you avoid unnecessary writes of duplicated blocks
in case you do delayed deduplication. See my final comment for
details.
>
> * Hash algorithm
> sha256 seems like a safe choice.
Doesn't fit into the dedup tree's key. See my above comments.
>
> * Future improvements
> There are some features that might be considered if time permits or as something
> that could be implemented in the future:
> - dedup across subvolumes
> - specify a hash algorithm
> - specify number of deduplication blocks
>
>
> I would appreciate any comments you might have, thanks!
>
> Best regards,
> Martin Krizek
>
>
> [1] http://lwn.net/Articles/422331/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

After my research I came to the conclusion that a real online
deduplication feature is not worth the trouble. The only advantage of
online deduplication compared to offline deduplication is that you can
avoid unnecessary writes for duplicate data and thus increase
performance in theory. In practice, I don't know if you really gain
much performance, because for small writes of duplicated data you
still have to write out meta data. In all cases, at least the inodes
extent items need to written, no matter if they point to new data or
duplicate data. The performance gain will only be measurable for large
duplicated blocks, in all other cases you'll loose performance due to
the overhead of deduplication.

Storing the hashes inside a btrfs tree is also a bad idea. The hashes
are randomly distributed and thus have completely randomly ordered
keys. Lookup and insertion will be very slow when there is not enough
ram to hold the whole hash tree in memory...which is very likely to
happen. You should think about an alternative, e.g. storing the hash
table inside a dedicated inode (in a format that is more appropriate
for hash tables). But even with this solution, you'll get out of ram
very fast. You can use bloom filters or some comparable probabilistic
data structure to avoid most of the lookups, but then you still have a
lot of insertions because no matter if a duplicate is written or not,
you need to update the hash table for later lookups.

Even if you find a good and fast solution for storing the hashes,
you'll get in trouble when data gets overwritten or deleted. Then you
have old hash values in the hash tree/table. This means, for each
lookup you'll also need to check if the found extent is still there
and unchanged. As an alternative, you could update the hash table
on-the-fly when data gets overwritten or deleted...but this again
means some additional lookups and writes and finally performance loss.
Also, when dedup is enabled for the first time (or after it was
disabled for some time), you have no hash table at all (or only a
partial out-of-date hash table)...what to do in this case?

Next problem is...the backref resolving code gets very slow when there
are too many references to the same block. This will slow down
everything that depends on backref resolving, e.g. scrubbing (in case
of errors), send and deduplication itself. So you'll need to limit the
number of allowed references to each block, which may give poor
deduplication results. Probably the backref resolving code can be
optimized...I tried it but with limited results.

Then you have fragmentation...which maybe can be ignored in some cases
(e.g. for SSD's).

In my opinion, the only acceptable deduplication solution would be
either an offline or semi online solution which basically does
periodic offline deduplication. I'm a big fan of doing this in-kernel,
because then it can use a lot of information already present. For
example, the checksums that are already present in the checksum tree
can be used as a first phase hint. Some time ago I had a in-kernel
prototype running that used this approach:

1. Run through the checksum tree and do the following for each checksum:
    a. Check if we (probably) have the checksum in bloom_filter1.
    b. If yes, add the checksum to bloom_filter2
    c. In any case, add the checksum to bloom_filter1
2. Run through the checksum tree a seconds time and do the following
for each checksum:
    a. Check if we (probably) have the checksum in bloom_filter2.
    b. If yes, put the extent info (sha256, disk_bytenr, ...) into a
list with a defined maximum size. If the list gets full, sort by hash
and write out the previously collected extents to a dedicated inode.
Then start with a fresh empty list.
3. We now have a dedicated file with multiple sorted blocks. Each
sorted block contains a list of extents. We can now do a very fast
merge sort like read and thus get a large stream of hash sorted
extents. While reading in the sorted extents, we can check if the
previous extent has the same hash as the current. If yes, we have a
duplicate.

I stopped working on that due to missing time. There are still a lot
of problems to solve with this solution which I won't go into detail
now. The main advantages of this solution are low memory consumption
and time mostly being dependent on the number of duplicates instead of
the whole filesystem size as there is no need to hash the whole
filesystem. Also, you don't have a permanent large table on-disk, as
you can delete the dedicated inodes after you're finished.
