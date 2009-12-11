From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Snapshot mysteries (and an oops)
Date: Fri, 11 Dec 2009 20:40:18 +0100
Message-ID: <200912112040.18415.kreijack@alice.it>
References: <cb0375e10912111116w284bfc33p3bc2bad00b20a9b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cb0375e10912111116w284bfc33p3bc2bad00b20a9b1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Andrew

On Friday 11 December 2009, Andrew Lutomirski wrote:
> Hi all-
> 
> I'm a bit mystified by snapshots.  I think that there are some bugs in
> btrfsctl at least (or maybe its documentation).  There's definitely at
> least one bug in the kernel.
> 
> Here's some commands I just tried (vanilla 2.6.32, btrfs-progs from
> git today.  "test" is a brand-new empty btrfs filesystem, mounted with
> default options).  Questions and comments are inline:
> 
> [test]# mkdir dir2
> [test]# touch dir2/file2
> [test]# btrfsctl -s snap2 dir2
> operation complete
> Btrfs v0.19-4-gab8fb4c
> [test]# ls snap2
> dir2  snap1  subvol1
> [test]# ls snap2/snap1
> [test]#
> 
> WTF?  It looks like btrfsctl just snapshotted the subvolume containing
> dir2 instead of snapshotting the directory.  I would have expected it
> to either snapshot just the directory or, if that's impossible, to
> fail.

It is possible to snapshot a (sub)volume only. I agree that nor the 
documentation nor the UI is very clear about that.

> [test]# rm -rf snap1
> rm: cannot remove directory `snap1': Directory not empty
> [test]# ls snap1
> [test]#
> 
> OK, so rmdir can't remove snapshots.  (Is there any good reason for that?)
The volume is like a filesystem: you cannot remove a directory where is 
mounted a filesystem

 
> [test]# btrfsctl -D snap1
> ioctl:: No such file or directory
> [test]# btrfsctl -D snap1 .
> operation complete
> Btrfs v0.19-4-gab8fb4c
> 
> I can't make any sense of that.  What's the second parameter to -D
> supposed to do?
> 
> [test]# btrfsctl -D subvol1 .
> operation complete
> Btrfs v0.19-4-gab8fb4c
> 
> Phew.  That worked :)

Yes the docs may be improved. The syntax is:

btrfsctl -D <snapshotname> <directory>
	<snapshotname>		snapshot name
	<directory>		where the snapshot is

> [test]# rm -rf *
> 
> OK, now I'm back to where I started.
> 
> [test]# btrfsctl -S subvol2 .
> operation complete
> Btrfs v0.19-4-gab8fb4c
> [test]# touch subvol2/file
> [test]# ln subvol2/file file
> Segmentation fault
> 
> Crap.  I guess I wasn't supposed to try that.  dmesg attached:
> 
> Process ln (pid: 3153, threadinfo ffff880196940000, task ffff8801a4149780)
> Stack:
>  0000000000000000 ffff88017a741e00 ffff88018af585d0 000000000000000e
> <0> ffff880196941e28 ffff88018af585d0 ffff88017a741e00 ffff88017a7905d0
> <0> ffff88017e4b3680 ffff88017a790688 ffff880196941e78 ffffffff81105988
> Call Trace:
>  [<ffffffff81105988>] vfs_link+0xd5/0x14a
> 
> Thanks,
> Andy
>  [<ffffffff811057e9>] ? lookup_hash+0x3b/0x3f
>  [<ffffffff81107eb1>] sys_linkat+0xc4/0x121
>  [<ffffffff8106af52>] ? up_read+0xe/0x10
>  [<ffffffff8141d2a9>] ? do_page_fault+0x269/0x299
>  [<ffffffff81095e6c>] ? audit_syscall_entry+0x11e/0x14a
>  [<ffffffff81107f2c>] sys_link+0x1e/0x22
>  [<ffffffff81011cf2>] system_call_fastpath+0x16/0x1b
> Code: ff 85 c0 41 89 c6 ba 01 00 00 00 75 39 49 8b 44 24 20 48 89 da
> 4c 89 fe 4c 89 e7 49 89 45 e0 e8 8f dc ff ff 85 c0 41 89 c6 74 04 <0f>
> 0b eb fe 48 8b 45 b8 31 d2 48 89 de 4c 89 e7 48 8b 48 28 e8
> RIP  [<ffffffffa0bc4305>] btrfs_link+0xcf/0x144 [btrfs]
>  RSP <ffff880196941dd8>
> ---[ end trace 95f0a8585b4e506f ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

BR
Goffredo
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
