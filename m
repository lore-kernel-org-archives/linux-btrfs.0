From: =?ISO-8859-1?Q?matthieu_Barth=E9lemy?= <bonsouere@gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference
Date: Wed, 25 May 2011 22:32:28 +0200
Message-ID: <BANLkTinXMR-jC2bwz0CFs6qBZqe6aqiWeg@mail.gmail.com>
References: <BANLkTikKAfPgutxW0Su0v0jZ1LnSA495hw@mail.gmail.com>
 <BANLkTik_=otvE_bfyjSQ2NoG6VVh_zgQKg@mail.gmail.com> <4DDD59B3.9000300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDD59B3.9000300@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/5/25 Josef Bacik <josef@redhat.com>:
> On 05/25/2011 01:41 PM, matthieu Barth=E9lemy wrote:
>> Finally I successfully remounted my partition. Here is how I've done
>> to recover, in case it can help someone else :
>> =A0I had to clone btrfs-progs-unstable tree.
>> Then checkout branch "tmp" (because I use compression, default
>> btrfs-progs are "too old"
>> Then I compiled btrfs-zero-log with "make btrfs-zero-log"
>> And finally ran "./btrfs-zero-log /dev/sda2"
>>
>> Now I'm copying everything to a new partition, because I don't know =
if
>> can safely use the damaged one.
>>
>> But wouldn't it be possible to avoid the "Null pointer" kernel crash
>> by checking what we do inside replay_one_buffer, and then
>> automatically clear log, or provide a "clear_log" mount option?
>> Any idea about what could have caused my problem?
>>
>
> Can you do a
>
> gdb btrfs.ko
>
> and then do
>
> list *(add_inode_ref+0x1e7)

Sure, here it is :

 # gdb fs/btrfs/btrfs.ko
GNU gdb (GDB) SUSE (7.2-3.3)
[...]
Reading symbols from /home/btrfs-unstable/fs/btrfs/btrfs.ko...done.
(gdb) list *(add_inode_ref+0x1e7)
0x5ce47 is in add_inode_ref (fs/btrfs/tree-log.c:879).
874                      * if they are in the log.  if so, we allow the=
m to stay
875                      * otherwise they must be unlinked as a conflic=
t
876                      */
877                     ptr =3D btrfs_item_ptr_offset(leaf, path->slots=
[0]);
878                     ptr_end =3D ptr + btrfs_item_size_nr(leaf,
path->slots[0]);
879                     while (ptr < ptr_end) {
880                             victim_ref =3D (struct btrfs_inode_ref =
*)ptr;
881                             victim_name_len =3D btrfs_inode_ref_nam=
e_len(leaf,
882
    victim_ref);
883                             victim_name =3D kmalloc(victim_name_len=
,
GFP_NOFS);



> so I can see where it is. =A0It doesn't seem like either of those
> read_extent_buffer's should screw up, either we do the proper checks =
or
> it should have gone sideways before you got there. =A0Thanks,

Let me know everything I can do to help, I keep my old Btrfs partition
untouched just in case.

I've read in another thread that a new btrfsck will be released "in a
couple of days", this is great news, even if it doesn't handle my
particular problem.
Thanks for your help, and for working so hard on btrfs :-)


>
> Josef
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
