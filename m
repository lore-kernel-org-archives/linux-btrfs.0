Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34176 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753134AbcISW0E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 18:26:04 -0400
Received: by mail-oi0-f65.google.com with SMTP id a62so2337284oib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Sep 2016 15:26:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <nrpg62$g72$2@blaine.gmane.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916011213.GV22388@dastard> <nrg4mh$bkn$1@blaine.gmane.org>
 <20160917043829.GC21290@hungrycats.org> <nrioas$da6$1@blaine.gmane.org>
 <20160919180805.GG21290@hungrycats.org> <nrpg62$g72$2@blaine.gmane.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 19 Sep 2016 16:25:55 -0600
Message-ID: <CAJCQCtR=6_cLa_f2BdcfhkfWGB_4kHSG-JfFh4w+40R7zOMtWQ@mail.gmail.com>
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: Alex Elsayed <eternaleye@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 19, 2016 at 2:01 PM, Alex Elsayed <eternaleye@gmail.com> wrote:
> On Mon, 19 Sep 2016 14:08:06 -0400, Zygo Blaxell wrote:
>
>> On Sat, Sep 17, 2016 at 06:37:16AM +0000, Alex Elsayed wrote:
>>> > Encryption in ext4 is a per-directory-tree affair. One starts by
>>> > setting an encryption policy (using an ioctl() call) for a given
>>> > directory, which must be empty at the time; that policy includes a
>>> > master key used for all files and directories stored below the target
>>> > directory. Each individual file is encrypted with its own key, which
>>> > is derived from the master key and a per-file random nonce value
>>> > (which is stored in an extended attribute attached to the file's
>>> > inode). File names and symbolic links are also encrypted.
>>
>> Probably the simplest way to map this to btrfs is to move the nonce from
>> the inode to the extent.
>
> I agree. Mostly, I was making a point about how the ext4/VFS code (which
> _does_ put it on the inode) can't just be transported over to btrfs
> unchanged, which is what I read Dave Chinner as advocating.
>
>> Inodes aren't unique within a btrfs filesystem, extents can be shared by
>> multiple inodes, and a single extent can appear multiple times in the
>> same inode at different offsets.  Attaching the nonce to the inode would
>> not be sufficient to read the extent in all but the special case of a
>> single reference at the original offset where it was written, and it
>> also leads to the replay problems with duplicate inodes you pointed out.
>
> Yup.
>
>> Extents in a btrfs filesystem are unique and carry their own attributes
>> (e.g. compression format, checksums) and reference count.  They can
>> easily carry a reference to an encryption policy object and a nonce
>> attribute.
>
> Definitely agreed.
>
>> Nonces within metadata are more complicated.  btrfs doesn't have
>> directory files like ext4 does, so it doesn't get directory filename
>> encryption for free with file encryption.  Encryption could be done
>> per-item in the metadata trees, but in the special case of directories
>> that happen to the the roots of subvols, it would be possible to encrypt
>> entire pages of metadata at a time (with the caveat that a snapshot
>> would require shared encryption policy between the origin and snapshot
>> subvols).
>
> Encrypting tree values per-item is actually one of the best arguments in
> _favor_ of nonce-misuse-resistant AEAD. Its security notion is very, very
> strong:
>
> If a (key, nonce, associated data, message) tuple is repeated, the only
> data an attacker can discover is the fact that the two ciphertexts have
> the same value (a one-bit leak).
>
> In other words, if you encrypt each value in the b-tree with some key,
> some nonce, use the b-tree key as the associated data, and use the value
> as the message, you get a _very_ secure system against a _very_ wide
> variety of attacks - essentially for free. And all _without_ sacrificing
> flexibility, as one could use distinct (crypto) keys for distinct (b-
> tree) keys.
>
> (You still need something for protecting the _structure_ of the B-tree,
> but that's a different issue).
>
>> This is what makes keys at the subvol root level so attractive.
>
> Pretty much.
>
>>> So there isn't quite a "subvol key" in the VFS approach - each
>>> directory has a key, and there are derived keys for the entries below
>>> it. (I'll note that this framing does not address shared extents _at
>>> all_, and would love to have clarification on that).
>>
>> Files are modified by creating new extents (using parameters inherited
>> from the inode to fill in the extent attributes) and updating the inode
>> to refer to the new extent instead of the old one at the modified
>> offset. Cloned extents are references to existing extents associated
>> with a different inode or at a different place within the same inode (if
>> the extent is not compatible with the destination inode, clone fails
>> with an error).  A snapshot is an efficient way to clone an entire
>> subvol tree at once, including all inodes and attributes.
>
> There is the caveat of chattr +C, which would need hard-disabled for
> extent-level encryption (vs block level).

What about raid56 partial stripe writes? Aren't these effectively nocow?


-- 
Chris Murphy
