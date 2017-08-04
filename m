Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36304 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdHDPFS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Aug 2017 11:05:18 -0400
Received: by mail-io0-f195.google.com with SMTP id j32so1247641iod.3
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Aug 2017 08:05:18 -0700 (PDT)
Subject: Re: Massive loss of disk space
To: kreijack@inwind.it, pwm <pwm@iapetus.neab.net>,
        Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
References: <alpine.DEB.2.02.1708011253230.31126@iapetus.neab.net>
 <20170801122039.GX7140@carfax.org.uk>
 <alpine.DEB.2.02.1708011520490.31126@iapetus.neab.net>
 <b30d1b78-7cbd-9bf5-3507-b028b9b8191f@gmail.com>
 <7f2b5c3a-2f5c-e857-d2dc-3ea16b58ecaf@gmail.com>
 <798a9077-bcbd-076c-a458-3403010ce8ac@libero.it>
 <6dc6ca6a-7f55-4176-e2b7-ae8ab69eca00@gmail.com>
 <f227b82c-171a-4475-e08c-6abb53de51f2@inwind.it>
 <0abbc952-99d1-8b23-41ee-f58afca11d08@gmail.com>
 <cab4df59-a5ce-9944-22cb-367173dab108@inwind.it>
 <8344dc9f-d213-b2d8-5b6c-5c1a54041ef1@gmail.com>
 <e19345c3-87c7-e248-fa4c-9dd608680640@inwind.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4d5470d6-f2d9-04ab-7005-e3febd3775f0@gmail.com>
Date: Fri, 4 Aug 2017 11:05:14 -0400
MIME-Version: 1.0
In-Reply-To: <e19345c3-87c7-e248-fa4c-9dd608680640@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-04 10:45, Goffredo Baroncelli wrote:
> On 2017-08-03 19:23, Austin S. Hemmelgarn wrote:
>> On 2017-08-03 12:37, Goffredo Baroncelli wrote:
>>> On 2017-08-03 13:39, Austin S. Hemmelgarn wrote:
> [...]
> 
>>>> Also, as I said below, _THIS WORKS ON ZFS_.  That immediately means that a CoW filesystem _does not_ need to behave like BTRFS is.
>>>
>>> It seems that ZFS on linux doesn't support fallocate
>>>
>>> see https://github.com/zfsonlinux/zfs/issues/326
>>>
>>> So I think that you are referring to a posix_fallocate and ZFS on solaris, which I can't test so I can't comment.
>> Both Solaris, and FreeBSD (I've got a FreeNAS system at work i checked on).
> 
> For fun I checked the freebsd source and zfs source. To me it seems that ZFS on freebsd doesn't implement posix_fallocate() (VOP_ALLOCATE in freebas jargon), but instead relies on the freebsd default one.
> 
> 	http://fxr.watson.org/fxr/source/cddl/contrib/opensolaris/uts/common/fs/zfs/zfs_vnops.c#L7212
> 
> Following the chain of function pointers
> 
> 	http://fxr.watson.org/fxr/source/kern/vfs_default.c?im=10#L110
> 
> it seems that the freebsd vop_allocate() is implemented in vop_stdallocate()
> 
> 	http://fxr.watson.org/fxr/source/kern/vfs_default.c?im=excerpts#L912
> 
> which simply calls read() and write() on the range [offset...offset+len), which for a "conventional" filesystem ensure the block allocation. Of course it is an expensive solution.
> 
> So I think (but I am not familiar with freebsd) that ZFS doesn't implement a real posix_allocate but it try to simulate it. Of course this don't
 From a practical perspective though, posix_fallocate() doesn't matter, 
because almost everything uses the native fallocate call if at all 
possible.  As you mention, FreeBSD is emulating it, but that 'emulation' 
provides behavior that is close enough to what is required that it 
doesn't matter.  As a matter of perspective, posix_fallocate() is 
emulated on Linux too, see my reply below to your later comment about 
posix_fallocate() on BTRFS.

Internally ZFS also keeps _some_ space reserved so it doesn't get wedged 
like BTRFS does when near full, and they don't do the whole data versus 
metadata segregation crap, so from a practical perspective, what 
FreeBSD's ZFS implementation does is sufficient because of the internal 
structure and handling of writes in ZFS.
> 
> 
>>
>> That said, I'm starting to wonder if just failing fallocate() calls to allocate space is actually the right thing to do here after all.  Aside from this, we don't reserve metadata space for checksums and similar things for the eventual writes (so it's possible to get -ENOSPC on a write to an fallocate'ed region anyway because of metadata exhaustion), and splitting extents can also cause it to fail, so it's perfectly possible for the fallocate assumption to not hole on BTRFS.
> 
> posix_fallocate in BTRFS is not reliable for another reason. This syscall guarantees that a BG is allocated, but I think that the allocated BG is available to all processes, so a parallel process my exhaust all the available space before the first process uses it.
As mentioned above, posix_fallocate() is emulated in libc on Linux by 
calling the regular fallocate() if the FS supports it (which BTRFS 
does), or by writing out data like FreeBSD does in the kernel if the FS 
doesn't support fallocate().  IOW, posix_fallocate() has the exact same 
issues on BTRFS as Linux's fallocate() syscall does.
> 
> My opinion is that BTRFS is not reliable when the space is exhausted, so it needs to work with an amount of disk space free. The size of this disk space should be O(2*size_of_biggest_write), and for operation like fallocate this means O(2*length).
Again, this arises from how we handle writes.  If we were to track 
blocks that have had fallocate called on them and only use those (for 
the first write at least) for writes to the file that had fallocate 
called on them (as well as breaking reflinks on them when fallocate is 
called), then we can get away with just using the size of the biggest 
write plus a little bit more space for _data_, but even then we need 
space for metadata (which we don't appear to track right now).
> 
> I think that is not casual that the fallocate implemented by ZFSONLINUX works with the flag FALLOC_FL_PUNCH_HOLE mode.
> 
> https://github.com/zfsonlinux/zfs/blob/master/module/zfs/zpl_file.c#L662
> [...]
> /*
>   * The only flag combination which matches the behavior of zfs_space()
>   * is FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE.  The FALLOC_FL_PUNCH_HOLE
>   * flag was introduced in the 2.6.38 kernel.
>   */
> #if defined(HAVE_FILE_FALLOCATE) || defined(HAVE_INODE_FALLOCATE)
> long
> zpl_fallocate_common(struct inode *ip, int mode, loff_t offset, loff_t len)
> {
> 	int error = -EOPNOTSUPP;
> 
> #if defined(FALLOC_FL_PUNCH_HOLE) && defined(FALLOC_FL_KEEP_SIZE)
> 	cred_t *cr = CRED();
> 	flock64_t bf;
> 	loff_t olen;
> 	fstrans_cookie_t cookie;
> 
> 	if (mode != (FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> 		return (error);
> 
> [...]
> 

