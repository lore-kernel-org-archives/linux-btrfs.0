Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:50993 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaKGLVd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Nov 2014 06:21:33 -0500
Received: by mail-la0-f49.google.com with SMTP id ge10so4124388lab.8
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Nov 2014 03:21:31 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <oroasjals2.fsf@free.home>
References: <oroasjals2.fsf@free.home>
Date: Fri, 7 Nov 2014 11:21:31 +0000
Message-ID: <CAL3q7H5rDTjcAC-JbpuFy_wLnjfA4YEtgEP2JhnEhzUxckAjaA@mail.gmail.com>
Subject: Re: non-atomic xattr replacement in btrfs => rsync random errors
From: Filipe David Manana <fdmanana@gmail.com>
To: Alexandre Oliva <oliva@gnu.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 7, 2014 at 12:37 AM, Alexandre Oliva <oliva@gnu.org> wrote:
> A few days ago, I started using rsync batches to archive old copies of
> ceph OSD snapshots for certain kinds of disaster recovery.  This seems
> to exercise an unexpected race condition in rsync, which happens to
> expose what appears to be a race condition in btrfs, causing random
> scary but harmless errors when replaying the rsync batches.
>
>
> strace has revealed that the two rsync processes running concurrently to
> apply the batch both attempt to access xattrs of the same directory
> concurrently.  I understand rsync is supposed to avoid this, but
> something's going wrong with that.  Here's the smoking gun, snipped from
> strace -p 27251 -p 27253 -o smoking.gun, where both processes are
> started from a single rsync --read-batch=- -aHAX --del ... run:
>
> 0: 27251 stat("osd/0.6ed_head/DIR_D/DIR_E/DIR_6",  <unfinished ...>
> 1: 27253 stat("osd/0.6ed_head/DIR_D/DIR_E/DIR_6", {st_mode=S_IFDIR|0755, st_size=5470, ...}) = 0
> 2: 27251 <... stat resumed> {st_mode=S_IFDIR|0755, st_size=5470, ...}) = 0
> 3: 27253 llistxattr("osd/0.6ed_head/DIR_D/DIR_E/DIR_6", "user.cephos.phash.contents\0", 1024) = 27
> 4: 27251 llistxattr("osd/0.6ed_head/DIR_D/DIR_E/DIR_6",  <unfinished ...>
> 5: 27253 lsetxattr("osd/0.6ed_head/DIR_D/DIR_E/DIR_6", "user.cephos.phash.contents", "\x01F\x00\x00\x00\x00\x00\x00\x00\x0f\x00\x00\x00\x03\x00\x00", 17, 0 <unfinished ...>
> 6: 27251 <... llistxattr resumed> "user.cephos.phash.contents\0", 1024) = 27
> 7: 27251 lgetxattr("osd/0.6ed_head/DIR_D/DIR_E/DIR_6", "user.cephos.phash.contents", 0x0, 0) = -1 ENODATA (No data available)
> 8: 27253 <... lsetxattr resumed> )         = 0
> 9: 27253 utimensat(AT_FDCWD, "osd/0.6ed_head/DIR_D/DIR_E/DIR_6", {UTIME_NOW, {1407992261, 0}}, AT_SYMLINK_NOFOLLOW) = 0
> a: 27251 write(2, "rsync: get_xattr_data: lgetxattr"..., 181) = 181
>
> lines 0-2, 3-6 and 5-8, show concurrent access of both rsync processes
> to the same directory.  This wouldn't be a problem, not even for
> replaying batches, for the lsetxattr would put the intended xattr value
> in there regardless of whether the scanner saw the xattr value before or
> after that.
>
>
> What makes the problem visible is that btrfs appears to have a race in
> its handling of xattr replacement, leaving a window between the removal
> of the old value and the insertion of the new one, as shown by lines
> 5-8.  line 3 show the attribute existed before, and lines 5-8 show it
> disappears in line 7, while lsetxattr still runs to replace it.
>
> If rsync tries hard enough to hit this window, the lgetxattr concurrent
> to the lsetxattr eventually hits, and then rsync reports an error:
>
> rsync: get_xattr_data: lgetxattr(""/media/px/snapshots/cluster/20141102-to-20140816/osd/0.6ed_head/DIR_D/DIR_E/DIR_6"","user.cephos.phash.contents",0) failed: No data available (61)
>
> At the end, it exits with a nonzero status, even though nothing really
> wrong went on and the tree ended up looking just as it was supposed to.
>
>
> Now, I'm a bit concerned because the btrfs race condition, if exercised
> on security-related xattrs or ACLs, could cause data to become visible
> that shouldn't, which could turn this into a locally exploitable
> security issue.  Sure enough nobody goes nuts repeatedly changing the
> ACLs of a dir or file containing information that should be guarded by
> it, so as to increase the likelihood that an attacker succeeds in
> accessing the data, but still...  I don't think the temporary removal of
> the xattr for subsequent insertion should be visible at all.

Indeed, the xattr replace code is not atomic in btrfs.
I'll send a fix soon.

thanks

>
> I'm sorry for reporting a potential security issue like that, but by the
> time it occurred to me that it might have potential security
> implications, I'd already mentioned the problem on #btrfs at FreeNode,
> so the horse was out of the barn already :-(
>
>
> I hope this helps,
>
> --
> Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
> You must be the change you wish to see in the world. -- Gandhi
> Be Free! -- http://FSFLA.org/   FSF Latin America board member
> Free Software Evangelist|Red Hat Brasil GNU Toolchain Engineer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
