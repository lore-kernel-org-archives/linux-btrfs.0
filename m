From: David Marcin <djmarcin@gmail.com>
Subject: Re: BUG during btrfs device delete missing
Date: Thu, 8 Dec 2011 12:27:52 -0800
Message-ID: <CAHh_JMOfLyHV=BSnW8J=8tn6huH0A2AvKqk6+WdOLCdG6zqkAA@mail.gmail.com>
References: <CAHh_JMPvmRNRrhh0aQhQiej+NP4Vb36MbFtECFphc8cUM9B=ZQ@mail.gmail.com>
 <CAHh_JMOxrqLRC2ad5n3DuArL1hQdNiixO7jd8StYSKLkbLUB7A@mail.gmail.com> <20111208194556.GS8971@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	David Marcin <djmarcin@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111208194556.GS8971@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,
This was on 3.2-rc2 but I tried with rc4 and it segfaulted again. =A0I
think the traces were the same but I've rebooted and can't say for
sure.
David
On Thu, Dec 8, 2011 at 11:45 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Which kernel is this? =A0This looks like one I recently fixed.
>
> -chris
>
> On Thu, Dec 08, 2011 at 11:06:47AM -0800, David Marcin wrote:
>> raid10 metadata and data filesystem. =A0dmesg log follows. =A0The sy=
stem
>> is unable to unmount the filesystem after this occurs.
>>
>> Filesystem mounted at/mnt/btrfs with -o compress,degraded
>> Command: btrfs device delete missing /mnt/btrfs
>>
>> [ =A0283.398222] ------------[ cut here ]------------
>> [ =A0283.398289] kernel BUG at /home/apw/COD/linux/fs/btrfs/transact=
ion.c:1329!
>> [ =A0283.398355] invalid opcode: 0000 [#1] SMP
>> [ =A0283.398481] CPU 3
>> [ =A0283.398520] Modules linked in: nfsd nfs lockd fscache auth_rpcg=
ss
>> nfs_acl sunrpc psmouse lp parport joydev serio_raw btrfs zlib_deflat=
e
>> libcrc32c usbhid hid mpt2sas scsi_transport_sas raid_class e1000e
>> [ =A0283.399435]
>> [ =A0283.399491] Pid: 2216, comm: btrfs Not tainted
>> 3.2.0-030200rc2-generic #201111151435 Supermicro X8SIL/X8SIL
>> [ =A0283.399678] RIP: 0010:[<ffffffffa00f7052>] =A0[<ffffffffa00f705=
2>]
>> btrfs_commit_transaction+0x8f2/0x900 [btrfs]
>> [ =A0283.399822] RSP: 0018:ffff880133573ac8 =A0EFLAGS: 00010282
>> [ =A0283.399884] RAX: 00000000fffffffb RBX: ffff8801276540f0 RCX: ff=
ff880133573a38
>> [ =A0283.399952] RDX: 0000000000002000 RSI: 000004a22dd55000 RDI: ff=
ff880127654150
>> [ =A0283.400020] RBP: ffff880133573b88 R08: 0000000000002000 R09: 00=
00000000000000
>> [ =A0283.400087] R10: 0000000000000000 R11: 0000000000000001 R12: ff=
ff880127654168
>> [ =A0283.400154] R13: ffff880130b8ac00 R14: ffff8801276540f0 R15: ff=
ff88012d4eb480
>> [ =A0283.400220] FS: =A000007f0c17fc1760(0000) GS:ffff88013bcc0000(0=
000)
>> knlGS:0000000000000000
>> [ =A0283.400302] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [ =A0283.400363] CR2: 00007f7e1d427870 CR3: 0000000132a4c000 CR4: 00=
000000000006e0
>> [ =A0283.400428] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00=
00000000000000
>> [ =A0283.400492] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00=
00000000000400
>> [ =A0283.400557] Process btrfs (pid: 2216, threadinfo ffff8801335720=
00,
>> task ffff8801306cdbc0)
>> [ =A0283.400637] Stack:
>> [ =A0283.400691] =A00000000000100000 ffffea0001a22701 ffff880133573b=
28
>> ffff88012d4eb480
>> [ =A0283.400905] =A00000000000000000 0000000000000132 ffff880133573b=
28
>> ffffffffa00f65be
>> [ =A0283.401122] =A00000000000000001 ffff880130b8ac00 ffff880130b8ac=
00
>> 0000000000000001
>> [ =A0283.401322] Call Trace:
>> [ =A0283.401380] =A0[<ffffffffa00f65be>] ? join_transaction+0xde/0x2=
80 [btrfs]
>> [ =A0283.401441] =A0[<ffffffff81088a90>] ? wake_up_bit+0x40/0x40
>> [ =A0283.401521] =A0[<ffffffffa013615e>] prepare_to_relocate+0xbe/0x=
d0 [btrfs]
>> [ =A0283.401604] =A0[<ffffffffa013c17b>] relocate_block_group+0x4b/0=
x5f0 [btrfs]
>> [ =A0283.401671] =A0[<ffffffff8160e7fe>] ? _raw_spin_lock+0xe/0x20
>> [ =A0283.401750] =A0[<ffffffffa00f515b>] ?
>> btrfs_clean_old_snapshots+0x7b/0x160 [btrfs]
>> [ =A0283.401852] =A0[<ffffffffa013c8d3>]
>> btrfs_relocate_block_group+0x1b3/0x2d0 [btrfs]
>> [ =A0283.401952] =A0[<ffffffffa011ac8d>] btrfs_relocate_chunk+0x7d/0=
x430 [btrfs]
>> [ =A0283.402038] =A0[<ffffffffa0125e42>] ?
>> btrfs_tree_read_unlock_blocking+0x42/0x70 [btrfs]
>> [ =A0283.402141] =A0[<ffffffffa011b8d3>] btrfs_shrink_device+0x223/0=
x440 [btrfs]
>> [ =A0283.402226] =A0[<ffffffffa011bce2>] btrfs_rm_device+0x1f2/0x5c0=
 [btrfs]
>> [ =A0283.402310] =A0[<ffffffffa0125a78>] btrfs_ioctl+0x4e8/0x690 [bt=
rfs]
>> [ =A0283.402379] =A0[<ffffffff811892a9>] do_vfs_ioctl+0x99/0x350
>> [ =A0283.402443] =A0[<ffffffff81182dc5>] ? putname+0x35/0x50
>> [ =A0283.402506] =A0[<ffffffff81189601>] sys_ioctl+0xa1/0xb0
>> [ =A0283.402572] =A0[<ffffffff81616c02>] system_call_fastpath+0x16/0=
x1b
>> [ =A0283.402634] Code: 00 48 85 db 0f 84 5b fe ff ff 48 8b 03 0f 1f =
40
>> 00 48 8b 7b 08 48 83 c3 10 4c 89 ee ff d0 48 8b 03 48 85 c0 75 eb e9
>> 3a fe ff ff <0f> 0b eb fe 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 =
48
>> 83 ec
>> [ =A0283.404962] RIP =A0[<ffffffffa00f7052>]
>> btrfs_commit_transaction+0x8f2/0x900 [btrfs]
>> [ =A0283.405099] =A0RSP <ffff880133573ac8>
>> [ =A0283.405224] ---[ end trace d2452d35e90228f4 ]---
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
