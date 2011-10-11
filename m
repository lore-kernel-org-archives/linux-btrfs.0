From: Christian Brunner <chb@muc.de>
Subject: Re: OSD: no current directory
Date: Tue, 11 Oct 2011 21:04:35 +0200
Message-ID: <CAO47_-8NCBF5yLHZett7k5CMBjaHTktOr4v06QBBZJchn6PKFg@mail.gmail.com>
References: <CAO47_-9FW_wD7+fD_ihGFivZD=FN1mx=32FJumNehtmvKGhqFg@mail.gmail.com>
	<Pine.LNX.4.64.1110111045330.20977@cobra.newdream.net>
	<CAO47_--b81FHZfZcQPMc=DcRrJns1j4018B53uts+xOiMBR1NQ@mail.gmail.com>
	<Pine.LNX.4.64.1110111147150.20977@cobra.newdream.net>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1110111147150.20977@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

2011/10/11 Sage Weil <sage@newdream.net>:
> On Tue, 11 Oct 2011, Christian Brunner wrote:
>> 2011/10/11 Sage Weil <sage@newdream.net>:
>> > On Tue, 11 Oct 2011, Christian Brunner wrote:
>> >> Maybe this one is easier:
>> >>
>> >> One of our OSDs isn't starting, because ther is no "current"
>> >> directory. What I have are three snap directories.
>> >>
>> >> total 0
>> >> -rw-r--r-- 1 root root =A0 37 Oct =A09 15:57 ceph_fsid
>> >> -rw-r--r-- 1 root root =A0 =A08 Oct =A09 15:57 fsid
>> >> -rw-r--r-- 1 root root =A0 21 Oct =A09 15:57 magic
>> >> drwxr-xr-x 1 root root 7986 Oct 11 18:34 snap_506043
>> >> drwxr-xr-x 1 root root 7986 Oct 11 18:34 snap_507364
>> >> drwxr-xr-x 1 root root 7814 Oct 11 18:36 snap_507417
>> >> -rw-r--r-- 1 root root =A0 =A04 Oct =A09 15:57 store_version
>> >> -rw-r--r-- 1 root root =A0 =A02 Oct =A09 15:57 whoami
>> >>
>> >> Is there a way to rollback the latest?
>> >
>> > That's what the OSD actually does on startup (roll back to the new=
est
>> > snap_). =A0It's probably a trivial bug that's preventing startup n=
ow... I'll
>> > take a look. =A0In the meantime, you can clone the latest snap_ to=
 current
>> > and it should start!
>> >
>> > sage
>>
>> This seems to be a btrfs problem. It fails, when I'm trying to creat=
e the clone
>>
>> # btrfs subvolume snapshot snap_507417 current
>> Create a snapshot of 'snap_507417' in './current'
>> ERROR: cannot snapshot 'snap_507417'
>>
>> And I get the following kernel messages:
>>
>> [ 5863.263950] ------------[ cut here ]------------
>> [ 5863.269125] WARNING: at fs/btrfs/inode.c:2335
>> btrfs_orphan_cleanup+0xcd/0x3d0 [btrfs]()
>> [ 5863.278142] Hardware name: ProLiant DL180 G6
>> [ 5863.283161] Modules linked in: btrfs zlib_deflate libcrc32c bondi=
ng
>> ipv6 serio_raw pcspkr ghes hed iTCO_wdt iTCO_vendor_support ixgbe dc=
a
>> mdio i7core_edac edac_core iomemory_vsl(P) hpsa squashfs usb_storage
>> [last unloaded: scsi_wait_scan]
>> [ 5863.307774] Pid: 6349, comm: btrfs Tainted: P =A0 =A0 =A0 =A0W
>> 3.0.6-1.fits.2.el6.x86_64 #1
>> [ 5863.316647] Call Trace:
>> [ 5863.319648] =A0[<ffffffff8106344f>] warn_slowpath_common+0x7f/0xc=
0
>> [ 5863.326536] =A0[<ffffffff810634aa>] warn_slowpath_null+0x1a/0x20
>> [ 5863.333146] =A0[<ffffffffa023fb0d>] btrfs_orphan_cleanup+0xcd/0x3=
d0 [btrfs]
>> [ 5863.340839] =A0[<ffffffffa0238381>] ? join_transaction+0x201/0x25=
0 [btrfs]
>> [ 5863.348482] =A0[<ffffffffa021fbaa>] ? block_rsv_migrate_bytes+0x3=
a/0x50 [btrfs]
>> [ 5863.356590] =A0[<ffffffffa0261a3b>] btrfs_mksubvol+0x2fb/0x380 [b=
trfs]
>> [ 5863.363726] =A0[<ffffffffa0261bba>]
>> btrfs_ioctl_snap_create_transid+0xfa/0x150 [btrfs]
>> [ 5863.372445] =A0[<ffffffffa0261c66>] btrfs_ioctl_snap_create+0x56/=
0x80 [btrfs]
>> [ 5863.380398] =A0[<ffffffffa026583e>] btrfs_ioctl+0x2fe/0xd50 [btrf=
s]
>> [ 5863.387344] =A0[<ffffffff8125ed20>] ? inode_has_perm+0x30/0x40
>> [ 5863.393798] =A0[<ffffffff81261a2c>] ? file_has_perm+0xdc/0xf0
>> [ 5863.400114] =A0[<ffffffff8117086a>] do_vfs_ioctl+0x9a/0x5a0
>> [ 5863.406244] =A0[<ffffffff81170e11>] sys_ioctl+0xa1/0xb0
>> [ 5863.412001] =A0[<ffffffff81562882>] system_call_fastpath+0x16/0x1=
b
>> [ 5863.418767] ---[ end trace e3234ecab14ad64c ]---
>> [ 5863.424084] btrfs: Error removing orphan entry, stopping orphan c=
leanup
>> [ 5863.431614] btrfs: could not do orphan cleanup -22
>>
>> Can I use an older snapshot as well?
>
> You're able to snapshot the others?
>
> Yeah, any of the snap_ directories will work, although keep in mind w=
hen
> the OSD starts up it will immediately remove current/ and re-clone th=
e
> newest snap_ to current/ again. =A0If the problem is a toxic/broken s=
nap_
> dir, you'll need to rename it out of the way to avoid hitting the pro=
blem
> again...
>
> sage

OK - renaming snap_507417 to broken_snap_507417 worked.

Two other OSDs crashed at the moment it became online again, but as
far as I can see, this is the same problem I've reported already.
After a couple of OSD restarts, I have them all up again.

Thanks for your help.

Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
