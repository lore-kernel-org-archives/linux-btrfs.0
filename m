Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44678 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751643AbcITPo7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 11:44:59 -0400
Subject: Re: Experimental btrfs encryption
To: "Theodore Ts'o" <tytso@mit.edu>
References: <20160919151518.i2aon4axmfzt54rn@thunk.org>
 <nrpjhc$g72$3@blaine.gmane.org> <a8dc3c28-5629-d870-f202-de35d2f941f1@fb.com>
 <20160920025041.mzeljxxzclikktxn@thunk.org>
CC: Alex Elsayed <eternaleye@gmail.com>, <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <12484cc6-b5ca-e507-157e-5eb48d9a4edf@fb.com>
Date: Tue, 20 Sep 2016 11:44:40 -0400
MIME-Version: 1.0
In-Reply-To: <20160920025041.mzeljxxzclikktxn@thunk.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/19/2016 10:50 PM, Theodore Ts'o wrote:
> On Mon, Sep 19, 2016 at 08:32:34PM -0400, Chris Mason wrote:
>>>> That key is used to protect the contents of the data file, and to
>>>> encrypt filenames and symlink targets --- since filenames can leak
>>>> significant information about what the user is doing.  (For example,
>>>> in the downloads directory of their web browser, leaking filenames is
>>>> just as good as leaking part of their browsing history.)
>>
>> One of the things that makes per-subvolume encryption attractive to me is
>> that we're able to enforce the idea that an entire directory tree is
>> encrypted by one key.  It can't be snapshotted again without the key, and it
>> just fits with the rest of the btrfs management code.  I do want to support
>> the existing vfs interfaces as well too though.
>
> One of the main reasons for doing fs-level encryption is so you can
> allow multiple users to have different keys.  In some cases you can
> assume that different users will be in different distinct subvolumes
> (e.g., each user has their own home directory), but that's not always
> going to be possible.
>

Agreed, they are just different use cases.  I think both are important, 
and btrfs won't do encryption without the file-level option.

> One of the other things that was in the original design, but which got
> dropped in our initial implementation, was the concept of having the
> per-inode key wrapped by multiple user keys.  This would allow a file
> to be accessible by more than one user.  So something to consider is
> that there may very well be situations where you *want* to have more
> than one key associated with a directory hierarchy.
>
>>> The issue, here, is that inodes are fundamentally not a safe scope to
>>> attach that information to in btrfs. As extents can be shared between
>>> inodes (and thus both will need to decrypt them), and inodes can be
>>> duplicated unmodified (snapshots), attaching keys and nonces to inodes
>>> opens up a whole host of (possibly insoluble) issues, including
>>> catastrophic nonce reuse via writable snapshots.
>>
>> I'm going to have to read harder about nonce reuse.  In btrfs an inode is
>> really a pair [ root id, inode number ], so strictly speaking two writable
>> snapshots won't have the same inode in memory and when a snapshot is
>> modified we'd end up with a different nonce for the new modifications.
>
> Nonce reuse is not necessrily catastrophic.  It all depends on the
> context.  In the case of Counter or GCM mode, nonce (or IV) reuse is
> absolutely catastrophic.  It must *never* be done or you completely
> lose all security.  As the Soviets discovered the hard way courtesy of
> the Venona project (well, they didn't discover it until after they
> lost the cold war, but...) one time pads are completely secure.
> Two-time pads, are most emphatically _not_.  :-)
>
> In the case of the nonces used in fscrypt's key derivation, reuse of
> the nonce basically means that two files share the same key.  Assuming
> you're using a competently designed block cipher (e.g., AES), reuse of
> the key is not necessarily a problem.  What it would mean is that two
> files which are are reflinked would share the same key.  And if you
> have writable snapshots, that's definitely not a problem, since with
> AES we use the a fixed key and a fixed IV given a logical block
> number, and we can do block overwrites without having to guarantee
> unique nonces (which you *do* need to worry about if you use counter
> mode or some other stream cipher such as ChaCha20 --- Kent Overstreet
> had some clever tricks to avoid IV reuse since he used a stream cipher
> in his proposed bcachefs encryption).
>
> The main issue is if you want to reflink a file and then have the two
> files have different permissions / ownerships.  In that case, you
> really want to use different keys for user A and for user B --- but if
> you are assuming a single key per subvolume, you can't support
> different keys for different users anyway, so you're kind of toast for
> that use case in any case.

So there's a matrix of possible configurations.  If you're doing a 
reflink between subvolumes and you're doing a subvolume granular 
encryption and you don't have keys to the source subvolume, the reflink 
shouldn't be allowed.  If you do have keys, any new writes are happening 
into a different inode, and will be encrypted with a different key.

If you're doing a file level encryption and you do have access to the 
source file, the destination file is a new inode.  Thanks to COW any 
changes are going to go into new extents and will end up with different 
keys/nonces.

Either way, we degrade down into extent based encryption.  I'd take that 
hit to maintain sane semantics in the face of snapshots and reflinks. 
The btrfs extent structures on disk already have an encryption type field.

>
> So in any case, assuming you're using block encryption (which is what
> fscrypt uses) there really isn't a problem with nonce reuse, although
> in some cases if you really do want to reflink a file and have it be
> protected by different user keys, this would have to force copy of the
> duplicated blocks at that point.  But arguably, that is a feature, not
> a bug.  If the two users are mutually suspicious, you don't _want_ to
> leak information about who much of a particular file had been changed
> by a particular user.  So you would want to break the reflink and have
> separate copies for both users anyway.
>
>
> One final thought --- something which is really going to be a factor
> in many use cases is going to be hardware accelerated encryption.  For
> example, Qualcomm is already shipping an SOC where the encryption can
> be done in the data path between the CPU and the eMMC storage device.
> If you want to support certain applications that try to read megabytes
> and megabytes of data before painting a single pixel, in-line hardware
> crypto at line speeds is going to be critical if you don't want to
> sacrifice performance, and keep users from being cranky because it
> took extra seconds before they could start reading their news feed (or
> saving bird eggs from voracious porcine predators, or whatever).
>
> This may very well be an issue in the future not just for mobile
> devices, but I could imagine this potentially being an issue for other
> form factors as well.  Yes, Skylake can encrypt multiple bytes per
> clock cycle using the miracles of hardware acceleration and
> pipelining.  But in-line encryption will still have the advantage of
> avoiding the memory bandwidth costs.  So while it is fun to talk about
> exotic encryption modes, it would be wise to have file system
> encryption architectures to have modes which are compatible with
> hardware in-line encryption schemes.
>

Strongly agree here.  This is the whole reason btrfs used crc32c, but 
times 100 (or maybe 1000).  I love that  Kent and others are 
experimenting in bcachefs and elsewhere.  Btrfs can always bring in new 
schemes that work well once the framework is in place, but its not an 
area where I have enough expertise to get exotic on the first try.

-chris
