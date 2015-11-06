Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33129 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030298AbbKFWV3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Nov 2015 17:21:29 -0500
Received: by iodd200 with SMTP id d200so136527284iod.0
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2015 14:21:29 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAPoQQ-07L3-43Y4JiuHW1MPBNVgm3qXAtC0PDxCi0Pe8CxqPSQ@mail.gmail.com>
References: <CAPoQQ-0SCeXpzjWM5Y3BUD=kHxAdfTRB21vnRf9TQGrQm6CHkQ@mail.gmail.com>
	<CAPoQQ-07L3-43Y4JiuHW1MPBNVgm3qXAtC0PDxCi0Pe8CxqPSQ@mail.gmail.com>
Date: Fri, 6 Nov 2015 22:21:29 +0000
Message-ID: <CAL3q7H6Ro3GreTTQcisgxppNMSt8UZaJDNpVV8Y5hzMzVnUYVw@mail.gmail.com>
Subject: Re: btrfs_sync_file alignment trap on arm (kernel 4.2.5)
From: Filipe Manana <fdmanana@gmail.com>
To: Cody P Schafer <dev@codyps.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 6, 2015 at 10:16 PM, Cody P Schafer <dev@codyps.com> wrote:
> On Wed, Nov 4, 2015 at 5:55 PM, Cody P Schafer <dev@codyps.com> wrote:
>> Ideas as to what could cause this would be appreciated.
>>
>> This consistently is triggered shortly after boot (I presume due to
>> conmand calling fsync on a file).
>>
>> Note that I'm not quite running 4.2.5, but none of the changes I have
>> additionally applied are to btrfs or atomics.
>>
>> Let me know if there is a way for me to get you more info.
>>
>> It looks like the line is:
>>
>>     mutex_lock(&inode->i_mutex);
>>     atomic_inc(&root->log_batch);  <<<<
>>     full_sync = test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
>>         &BTRFS_I(inode)->runtime_flags);
>>
>>
>> addr2line of the trapping instruction:
>>     addr2line -e
>> ./work/beaglebone-poky-linux-gnueabi/linux-yocto-ikabit/4.2.5+gitAUTOINC+c29ac18888-r1/linux-beaglebone-standard-build/arch/arm/boot/vmlinux
>> c0217a34 -i
>>     /home/cody/obj/y/tmp/work-shared/beaglebone/kernel-source/arch/arm/include/asm/atomic.h:194
>>     /home/cody/obj/y/tmp/work-shared/beaglebone/kernel-source/fs/btrfs/file.c:1886
>>
>> fault log:
>>
>> [   11.488382] Alignment trap: not handling instruction e1993f9f at [<c0217a34>]
>> [   11.560558] Unhandled fault: alignment exception (0x001) at 0x0000026d
>> [   11.607301] pgd = dc090000
>> [   11.610166] [0000026d] *pgd=9c063831, *pte=00000000, *ppte=00000000
>> [   11.665548] Internal error: : 1 [#1] PREEMPT ARM
>> [   11.670388] Modules linked in: omaplfb(O) bufferclass_ti(O) pvrsrvkm(O)
>> [   11.677341] CPU: 0 PID: 248 Comm: connmand Tainted: G           O
>>  4.2.5-yocto-standard #1
>> [   11.686172] Hardware name: Generic AM33XX (Flattened Device Tree)
>> [   11.692551] task: dc00d100 ti: dc068000 task.ti: dc068000
>> [   11.698219] PC is at btrfs_sync_file+0x104/0x3f4
>> [   11.703051] LR is at btrfs_sync_file+0x100/0x3f4
>> [   11.707883] pc : [<c0217a38>]    lr : [<c0217a34>]    psr: 60060013
>> [   11.707883] sp : dc069e98  ip : dc069e98  fp : dc069f1c
>> [   11.719897] r10: 00000000  r9 : 0000026d  r8 : dd746b40
>> [   11.725363] r7 : dcef8dcc  r6 : 00000000  r5 : dcef8d68  r4 : 00000001
>> [   11.732192] r3 : 7fffffff  r2 : 00000000  r1 : 00000000  r0 : dcef8dcc
>> [   11.739024] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
>> [   11.746491] Control: 10c5387d  Table: 9c090019  DAC: 00000015
>> [   11.752502] Process connmand (pid: 248, stack limit = 0xdc068210)
>> [   11.758878] Stack: (0xdc069e98 to 0xdc06a000)
>> [   11.763436] 9e80:
>>     ffffffff 7fffffff
>> [   11.771998] 9ea0: dc069f38 c014582c 0000b30b 00000000 00000000
>> 000037f6 000081a4 d5012f68
>> [   11.780559] 9ec0: 00000000 80000000 00000000 00000000 00000000
>> 00000000 0000008d 00000000
>> [   11.789121] 9ee0: 00000400 00000000 00000001 20b04e34 563924e6
>> dd746b40 dce2beb8 00000000
>> [   11.797683] 9f00: 00000000 00000000 dc068000 00000000 dc069f54
>> dc069f20 c0171d00 c0217940
>> [   11.806245] 9f20: ffffffff 7fffffff 00000000 dc069f38 c0145b6c
>> dd746b40 00000000 dd746b40
>> [   11.814807] 9f40: 00000076 c000f7a4 dc069f74 dc069f58 c0171d3c
>> c0171c40 ffffffff 7fffffff
>> [   11.823369] 9f60: 00000000 c015cc9c dc069f94 dc069f78 c0171d7c
>> c0171d14 00000000 bebe2bf8
>> [   11.831931] 9f80: 00e64c4d b6a104d0 dc069fa4 dc069f98 c017204c
>> c0171d50 00000000 dc069fa8
>> [   11.840492] 9fa0: c000f600 c017203c bebe2bf8 00e64c4d 00000009
>> bebe2bf8 0000008d 00000000
>> [   11.849054] 9fc0: bebe2bf8 00e64c4d b6a104d0 00000076 00e64810
>> 00e60cd0 00000009 00000000
>> [   11.857616] 9fe0: 00000000 bebe2bd4 b6e63384 b6dcef00 60060010
>> 00000009 044a1103 099b0303
>> [   11.866199] [<c0217a38>] (btrfs_sync_file) from [<c0171d00>]
>> (vfs_fsync_range+0xcc/0xd4)
>> [   11.874674] [<c0171d00>] (vfs_fsync_range) from [<c0171d3c>]
>> (vfs_fsync+0x34/0x3c)
>> [   11.882600] [<c0171d3c>] (vfs_fsync) from [<c0171d7c>] (do_fsync+0x38/0x54)
>> [   11.889890] [<c0171d7c>] (do_fsync) from [<c017204c>] (SyS_fsync+0x1c/0x20)
>> [   11.897188] [<c017204c>] (SyS_fsync) from [<c000f600>]
>> (ret_fast_syscall+0x0/0x3c)
>> [   11.905116] Code: e14b05fc e1a00007 eb1251f7 e1993f9f (e2833001)
>> [   13.418969] ---[ end trace d7bcd93aea7d243c ]---
>> [   13.442420] Kernel panic - not syncing: Fatal exception
>
> I looked into this a bit further, and it looks like my issue is that
> the btrfs_root* from BTRFS_I(inode)->root is somehow `1` instead of an
> actual pointer value, so it appears this isn't quite an alignment
> issue.
>
> Kernel starts without issue if I just stop doing the overlay (and as a
> result stop using btrfs at all).
>
> I've added some debugging, and the actual file it's trying to fsync
> appears to be: `/var/lib/connman/settings.4CAC7X`
>
> That directory is a overlayfs dir with a btrfs upper and a squashfs lower.
>
> Ideas on why the btrfs_root pointer is 0x1?

Just a bad interaction with overlayfs, this is being discussed at this
thread:  http://www.spinics.net/lists/linux-btrfs/msg47744.html


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
