Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36690 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932418AbcISUBo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 16:01:44 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bm4kd-0000w5-Hq
        for linux-btrfs@vger.kernel.org; Mon, 19 Sep 2016 22:01:15 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC] Preliminary BTRFS Encryption
Date: Mon, 19 Sep 2016 20:01:06 +0000 (UTC)
Message-ID: <nrpg62$g72$2@blaine.gmane.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
        <20160916011213.GV22388@dastard> <nrg4mh$bkn$1@blaine.gmane.org>
        <20160917043829.GC21290@hungrycats.org> <nrioas$da6$1@blaine.gmane.org>
        <20160919180805.GG21290@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 19 Sep 2016 14:08:06 -0400, Zygo Blaxell wrote:

> On Sat, Sep 17, 2016 at 06:37:16AM +0000, Alex Elsayed wrote:
>> > Encryption in ext4 is a per-directory-tree affair. One starts by
>> > setting an encryption policy (using an ioctl() call) for a given
>> > directory, which must be empty at the time; that policy includes a
>> > master key used for all files and directories stored below the target
>> > directory. Each individual file is encrypted with its own key, which
>> > is derived from the master key and a per-file random nonce value
>> > (which is stored in an extended attribute attached to the file's
>> > inode). File names and symbolic links are also encrypted.
> 
> Probably the simplest way to map this to btrfs is to move the nonce from
> the inode to the extent.

I agree. Mostly, I was making a point about how the ext4/VFS code (which 
_does_ put it on the inode) can't just be transported over to btrfs 
unchanged, which is what I read Dave Chinner as advocating.

> Inodes aren't unique within a btrfs filesystem, extents can be shared by
> multiple inodes, and a single extent can appear multiple times in the
> same inode at different offsets.  Attaching the nonce to the inode would
> not be sufficient to read the extent in all but the special case of a
> single reference at the original offset where it was written, and it
> also leads to the replay problems with duplicate inodes you pointed out.

Yup.

> Extents in a btrfs filesystem are unique and carry their own attributes
> (e.g. compression format, checksums) and reference count.  They can
> easily carry a reference to an encryption policy object and a nonce
> attribute.

Definitely agreed.

> Nonces within metadata are more complicated.  btrfs doesn't have
> directory files like ext4 does, so it doesn't get directory filename
> encryption for free with file encryption.  Encryption could be done
> per-item in the metadata trees, but in the special case of directories
> that happen to the the roots of subvols, it would be possible to encrypt
> entire pages of metadata at a time (with the caveat that a snapshot
> would require shared encryption policy between the origin and snapshot
> subvols).

Encrypting tree values per-item is actually one of the best arguments in 
_favor_ of nonce-misuse-resistant AEAD. Its security notion is very, very 
strong:

If a (key, nonce, associated data, message) tuple is repeated, the only 
data an attacker can discover is the fact that the two ciphertexts have 
the same value (a one-bit leak).

In other words, if you encrypt each value in the b-tree with some key, 
some nonce, use the b-tree key as the associated data, and use the value 
as the message, you get a _very_ secure system against a _very_ wide 
variety of attacks - essentially for free. And all _without_ sacrificing 
flexibility, as one could use distinct (crypto) keys for distinct (b-
tree) keys.

(You still need something for protecting the _structure_ of the B-tree, 
but that's a different issue).

> This is what makes keys at the subvol root level so attractive.

Pretty much.

>> So there isn't quite a "subvol key" in the VFS approach - each
>> directory has a key, and there are derived keys for the entries below
>> it. (I'll note that this framing does not address shared extents _at
>> all_, and would love to have clarification on that).
> 
> Files are modified by creating new extents (using parameters inherited
> from the inode to fill in the extent attributes) and updating the inode
> to refer to the new extent instead of the old one at the modified
> offset. Cloned extents are references to existing extents associated
> with a different inode or at a different place within the same inode (if
> the extent is not compatible with the destination inode, clone fails
> with an error).  A snapshot is an efficient way to clone an entire
> subvol tree at once, including all inodes and attributes.

There is the caveat of chattr +C, which would need hard-disabled for 
extent-level encryption (vs block level).

> Inode attributes and extent attributes can sometimes conflict,
> especially during a clone operation.  Encryption attributes could become
> one of these cases (i.e. to prevent an extent from one encryption policy
> from being cloned to an inode under a different encryption policy).

That is a good approach.

>> > I don't see how snapshots could work, writable or otherwise, without
>> > separating the key identity from the subvol identity and having a
>> > many-to-one relationship between subvols and keys.  The extents in
>> > each subvol would be shared, and they'd be encrypted with a single
>> > secret, so there's not really another way to do this.
>> 
>> That's not the issue. The issue is that, assuming the key stays the
>> same,
>> then a user could quite possibly create a snapshot, write into both the
>> original and the snapshot, causing encryption to occur twice with the
>> same key, same nonce, and different data.
> 
> If the extents have nonces (and inodes do not) then this doesn't happen.
> A write to either snapshot necessarily creates new extents in all cases
> (the nodatacow feature, the only way to modify a data extent in-place,
> is disabled when the extent is shared).

As above, note that if encryption is applied to extents rather than 
blocks, nodatacow becomes a data loss vector (partial write -> AEAD 
verify failure).

