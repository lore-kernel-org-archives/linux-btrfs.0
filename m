Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54674 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab2KDT5o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Nov 2012 14:57:44 -0500
Received: by mail-lb0-f174.google.com with SMTP id n3so3759353lbo.19
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Nov 2012 11:57:42 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 4 Nov 2012 21:57:42 +0200
Message-ID: <CAOcd+r3nJ1-WtVoS0F9SwpXyPSC2=MMGV9n+q8G4FaqqGAnZiw@mail.gmail.com>
Subject: bytes_may_use is incremented with NOCOW [was: btrfs seems to do COW
 while inode has NODATACOW set]
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Joseph,

I carefully ping you again for this issue. Basically, what I see is
that bytes_may_use is always incremented on the btrfs_file_aio_write
path, way before checking for NOCOW flags. As a result, ENOSPC is
returned, even on a fully-allocated NOCOW file. Do you think this can
be improved?

Thanks,
Alex.



On Mon, Oct 29, 2012 at 7:18 PM, Alex Lyakas
<alex.btrfs@zadarastorage.com> wrote:
> FWIW,
> I have found when I am hitting ENOSPC.
>
> btrfs_check_data_free_space() has this code:
> ...
>         /* make sure we have enough space to handle the data first */
>         spin_lock(&data_sinfo->lock);
>         used = data_sinfo->bytes_used + data_sinfo->bytes_reserved +
>                 data_sinfo->bytes_pinned + data_sinfo->bytes_readonly +
>                 data_sinfo->bytes_may_use;
>
>         if (used + bytes > data_sinfo->total_bytes) {
>                 struct btrfs_trans_handle *trans;
>
> ...
>         return -ENOSPC;
> }
> data_sinfo->bytes_may_use += bytes;
>
> Josef, I have read your doc on
> https://btrfs.wiki.kernel.org/index.php/ENOSPC and also the related
> email thread. You mention there the metadata reservations only. In my
> case, bytes_may_use get bumped up for data. Eventually I hit ENOSPC
> because I have very few extra space for data, but plenty of space for
> metadata. However, I am using NOCOW. Is this the intended thing to do
> --- to bump up bytes_may_use even though we won't need any new space
> for data eventually?
>
> Thanks,
> Alex.
>
>
>
>
>
> On Sun, Oct 28, 2012 at 2:12 PM, Alex Lyakas
> <alex.btrfs@zadarastorage.com> wrote:
>> Hi,
>> it appears that I found why the COW is happening. The code in the
>> kernel that triggers this is:
>> check_committed_ref():
>>         if (btrfs_extent_generation(leaf, ei) <=
>>             btrfs_root_last_snapshot(&root->root_item))
>>                 goto out;
>> It appears that both "extent_generation" and "last_snapshot" are 0 in my case.
>> How it happened that "extent_generation" is 0? This is converter's
>> fault; in record_file_extent() it has:
>> btrfs_set_extent_generation(leaf, ei, 0);
>> instead of
>> btrfs_set_extent_generation(leaf, ei, trans->transid);
>>
>> After fixing this, I see that no COW is happening and
>> EXTENT_DATAs/EXTENT_ITEMs remain exactly the same, which is awesome!
>> (Community, if you feel this bug should be fixed, I can send this
>> trivial patch for converter).
>>
>> However, I still receive ENOSPC when running IO to the file. I setup a
>> looback device on the file, and when running IOs to /dev/loop0, I get:
>> Oct 28 13:49:41 vc kernel: [ 1243.775530] loop: Write error at byte
>> offset 3637841920, length 4096, prev_pos=3637841920, bw=-28.
>> Oct 28 13:49:41 vc kernel: [ 1243.780909] loop: Write error at byte
>> offset 163704832, length 4096, prev_pos=163704832, bw=-28.
>> Oct 28 13:49:41 vc kernel: [ 1243.783282] loop: Write error at byte
>> offset 3637899264, length 4096, prev_pos=3637899264, bw=-28.
>> Oct 28 13:49:41 vc kernel: [ 1243.788148] loop: Write error at byte
>> offset 498728960, length 4096, prev_pos=498728960, bw=-28.
>> Oct 28 13:49:41 vc kernel: [ 1243.790573] loop: Write error at byte
>> offset 498855936, length 4096, prev_pos=498855936, bw=-28.
>> Oct 28 13:49:41 vc kernel: [ 1243.793017] loop: Write error at byte
>> offset 407240704, length 4096, prev_pos=407240704, bw=-28.
>> ...
>> (I added the print into drivers/block/loop.c into
>> __do_lo_send_write(), and file->f_op->write receives -28 back).
>> When writing later to the same offsets with "dd" I don't get this
>> problem. Free space seems also fine:
>> root@vc:/btrfs-progs# ./btrfs fi df /mnt/src/
>> Data: total=5.47GB, used=5.00GB
>> System: total=32.00MB, used=4.00KB
>> Metadata: total=512.00MB, used=36.00KB
>>
>> How can it happen that I get back ENOSPC with NOCOW?
>> Can anybody please help me debugging this further? There are no prints
>> from btrfs. Kernel is latest Chris's.
>>
>> Thanks,
>> Alex.
>>
>>
>>
>>
>>
>>
>>
>> On Fri, Oct 26, 2012 at 3:33 PM, Kyle Gates <kylegates@hotmail.com> wrote:
>>>> > Wade, thanks.
>>>> >
>>>> > Yes, with the preallocated extent I saw the behavior you describe, and
>>>> > it makes perfect sense to alloc a new EXTENT_DATA in this case.
>>>> > In my case, I did another simple test:
>>>> >
>>>> > Before:
>>>> > item 4 key (257 INODE_ITEM 0) itemoff 3593 itemsize 160
>>>> > inode generation 5 transid 5 size 5368709120 nbytes 5368709120
>>>> > owner[0:0] mode 100644
>>>> > inode blockgroup 0 nlink 1 flags 0x3 seq 0
>>>> > item 5 key (257 INODE_REF 256) itemoff 3578 itemsize 15
>>>> > inode ref index 2 namelen 5 name: vol-1
>>>> > item 6 key (257 EXTENT_DATA 0) itemoff 3525 itemsize 53
>>>> > extent data disk byte 5368709120 nr 131072
>>>> > extent data offset 0 nr 131072 ram 131072
>>>> > extent compression 0
>>>> > item 7 key (257 EXTENT_DATA 131072) itemoff 3472 itemsize 53
>>>> > extent data disk byte 5905842176 nr 33423360
>>>> > extent data offset 0 nr 33423360 ram 33423360
>>>> > extent compression 0
>>>> > ...
>>>> >
>>>> > I am going to do a single write of a 4Kib block into (257 EXTENT_DATA
>>>> > 131072) extent:
>>>> >
>>>> > dd if=/dev/urandom of=/mnt/src/subvol-1/vol-1 bs=4096 seek=32 count=1
>>>> > conv=notrunc
>>>> >
>>>> > After:
>>>> > item 4 key (257 INODE_ITEM 0) itemoff 3593 itemsize 160
>>>> > inode generation 5 transid 21 size 5368709120 nbytes 5368709120
>>>> > owner[0:0] mode 100644
>>>> > inode blockgroup 0 nlink 1 flags 0x3 seq 1
>>>> > item 5 key (257 INODE_REF 256) itemoff 3578 itemsize 15
>>>> > inode ref index 2 namelen 5 name: vol-1
>>>> > item 6 key (257 EXTENT_DATA 0) itemoff 3525 itemsize 53
>>>> > extent data disk byte 5368709120 nr 131072
>>>> > extent data offset 0 nr 131072 ram 131072
>>>> > extent compression 0
>>>> > item 7 key (257 EXTENT_DATA 131072) itemoff 3472 itemsize 53
>>>> > extent data disk byte 5368840192 nr 4096
>>>> > extent data offset 0 nr 4096 ram 4096
>>>> > extent compression 0
>>>> > item 8 key (257 EXTENT_DATA 135168) itemoff 3419 itemsize 53
>>>> > extent data disk byte 5905842176 nr 33423360
>>>> > extent data offset 4096 nr 33419264 ram 33423360
>>>> > extent compression 0
>>>> >
>>>> > We clearly see that a new extent has been allocated for some reason
>>>> > (bytenr=5368840192), and previous extent (bytenr=5905842176) is still
>>>> > there, but used at offset of 4096. This is exactly cow, I believe.
>>>> Hmm, I'm pretty sure that using 'dd' in this fashion skips the first 32 4096-sized
>>>> blocks and thus writes -past- the length of this extent (eg: writes from 131073 to
>>>> 135168). This causes a new extent to be allocated after the previous extent.
>>>>
>>>> But even if using 'dd' with a 'skip' value of '31' created a new EXTENT_DATA, it
>>>> would not necessarily be data CoW, since data CoW refers only to the location of
>>>> the -data- (i.e., not metadata and thus not EXTENT_DATA) on disk. The key thing
>>>> is to look at where the EXTENT_DATAs are pointing to, not how many EXTENT_DATAs
>>>> there are.
>>>>
>>>> > However, your hint about not being able to read into memory may be
>>>> > useful; it would be good if we can find the place in the code that
>>>> > does that decision to cow.
>>>> Try looking at the callers of btrfs_cow_block(), but you'll be own your own from
>>>> there :)
>>>>
>>>> > I guess I am looking for a way to never ever allocate new EXTENT_DATAs
>>>> > on a fully-mapped file. Is there one?
>>>> Hmm, I don't think that this exists right now. You could try a '-o autodefrag' to
>>>> minimize the number of EXTENT_DATAs, though.
>>>
>>> This seems to be a start at what you're looking for:
>>> Commit: 7e97b8daf63487c20f78487bd4045f39b0d97cf4
>>> btrfs: allow setting NOCOW for a zero sized file via ioctl
>>>
>>> In short, the nodatacow option won't be honored if any checksums have been assigned to any extents of a file.
>>>
>>>>
>>>> Regards,
>>>> Wade
>>>>
>>>> >
>>>> > Thanks!
>>>> > Alex.
