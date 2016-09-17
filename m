Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49507 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752001AbcIQGha (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 02:37:30 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bl9Fd-0002nV-4X
        for linux-btrfs@vger.kernel.org; Sat, 17 Sep 2016 08:37:25 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC] Preliminary BTRFS Encryption
Date: Sat, 17 Sep 2016 06:37:16 +0000 (UTC)
Message-ID: <nrioas$da6$1@blaine.gmane.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
        <20160916011213.GV22388@dastard> <nrg4mh$bkn$1@blaine.gmane.org>
        <20160917043829.GC21290@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 17 Sep 2016 00:38:30 -0400, Zygo Blaxell wrote:

> On Fri, Sep 16, 2016 at 06:49:53AM +0000, Alex Elsayed wrote:
>> The main issue I see is that subvolumes as btrfs has them _do_
>> introduce novel concerns - in particular, how should snapshots interact
>> with keying (and nonces)? None of the AEADs currently in the kernel are
>> nonce-misuse resistant, which means that if different data is encrypted
>> under the same key and nonce, things go _very_ badly wrong. With
>> writable snapshots, I'd consider that a nontrivial risk.
> 
> Snapshots should copy subvolume keys (or key UUIDs, since the keys
> aren't stored in the filesystem), i.e. an ioctl could say "create a new
> subvol 'foo' with the same key as existing subvol 'bar'".  This could
> also handle nested subvols (child copies key of parent) if the nested
> subvols weren't created with their own separate keys.  For snapshots,
> we wouldn't even ask--the snapshot and its origin subvol would share a
> key unconditionally. (*)

I'll quote the LWN article on the way EXT4 (and VFS) encryption works 
(https://lwn.net/Articles/639427/):

> Encryption in ext4 is a per-directory-tree affair. One starts by
> setting an encryption policy (using an ioctl() call) for a given
> directory, which must be empty at the time; that policy includes a
> master key used for all files and directories stored below the target
> directory. Each individual file is encrypted with its own key, which is
> derived from the master key and a per-file random nonce value (which is
> stored in an extended attribute attached to the file's inode). File
> names and symbolic links are also encrypted.

So there isn't quite a "subvol key" in the VFS approach - each directory 
has a key, and there are derived keys for the entries below it. (I'll 
note that this framing does not address shared extents _at all_, and 
would love to have clarification on that).

> I don't see how snapshots could work, writable or otherwise, without
> separating the key identity from the subvol identity and having a
> many-to-one relationship between subvols and keys.  The extents in each
> subvol would be shared, and they'd be encrypted with a single secret,
> so there's not really another way to do this.

That's not the issue. The issue is that, assuming the key stays the same, 
then a user could quite possibly create a snapshot, write into both the 
original and the snapshot, causing encryption to occur twice with the 
same key, same nonce, and different data.

This invalidates both the integrity and confidentialiyy of AES-GCM (and 
any other AEAD that is not nonce-misuse resistant), allowing them to 
effectively mount offline decryption attacks against things they could 
not ordinarily read, or replace files without being caught.

> If the key is immutable (which it probably is, given that it's used to
> encrypt at the extent level, and extents are (mostly) immutable) then
> just giving each subvol a copy of the key ID is sufficient.

Sufficient for reading data, yes. Sufficient for really nasty nonce-reuse 
attacks, also yes.

> (*) OK, we could ask, but if the answer was "no, please do not use the
> origin subvol's key", then btrfs would return EINVAL and not create the
> snapshot, since there would be no way to read any data contained within
> it without the key.

It _might_ be possible to get away with only allowing RO snapshots for 
encrypted subvols, but this really requires much more careful thought 
than it's getting.

>> > Indeed, with the generic file encryption, btrfs may not even need the
>> > special subvolume encryption pixies. i.e. you can effectively
>> > implement subvolume encryption via configuration of a multi-user
>> > encryption key for each subvolume and apply it to the subvolume tree
>> > root at creation time. Then only users with permission to unlock the
>> > subvolume key can access it.
> 
> Life is pretty easy when we're only encrypting data extents.

Agreed.

> Encrypted subvol trees cause quite a few problems for btrfs when it
> needs to relocate extents (e.g. to shrink a filesystem or change RAID
> profile) or validate data integrity.  Ideally it would still be able to
> do these operations without decrypting the data; otherwise, there are
> bad cases, e.g. if a disk fails, all of the subvolumes would have to be
> unlocked in order to replace a disk.

Sure; there are certainly caveats. At very least, the free space map 
would need to be either unencrypted, or encrypted under a "global" key 
(no worse in security properties than dmcrypt, though, with the added 
boon of AEAD). That would at least make operation with some subvolumes 
locked safe.

One could also just encrypt all of the subvolume trees under one global 
key. Encrypting _all_ the metadata in _some fashion_ is _required_ if we 
ever want dmcrypt to be unnecessary, but if that's the goal, per-
subvolume keys for that aren't needed (though they would be nice).

(If making dmcrypt unnecessary is a non-goal, then we'll always need it, 
even if we use FS encryption - meaning if we use FS encryption, we do 
twice the work for only marginal gain. This is suboptimal.)

> Still, there could be a half way point here.  If btrfs could tie block
> groups to subvol encryption keys, it could arrange for all of the
> extents in a metadata block group to use the same encryption key. Then
> it would be possible to relocate the entire metadata block group without
> decrypting its contents.  It would only be necessary to copy the block
> group's encrypted data, then update the virtual-to-physical address
> mappings in the chunk tree.  Something would have to be done about
> checksums during the copy but that's a larger question (are there two
> sets of checksums, one authenticated for the encrypted data, and the
> crc32 check for device-level data corruption?).

That is definitely a neat possibility.

> There's also a nasty problem with the extent tree--there's only one per
> filesystem, it's shared between all subvols and block groups, and every
> extent in that tree has back references to the (possibly encrypted)
> subvol trees.  I'll leave that problem as an exercise for other readers.
>  ;)

See above - a different model is in play there (it can be encrypted under 
a global key), and it may be possible to treat backrefs to encrypted 
subvols as "immutable" - i.e. they count towards refcount, and cannot be 
walked, and so the extent cannot be (re)moved unless all backrefs are to 
unlocked subvols.

