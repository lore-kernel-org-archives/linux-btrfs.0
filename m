From: Timothy Crone <tjcrone@gmail.com>
Subject: Re: Segmentation Faults
Date: Fri, 25 Nov 2011 11:25:25 -0500
Message-ID: <CAG+2MKJLU=9bo3BFed8LSWYXLfsP-Of8KxRUtG8L0koBH1t1ow@mail.gmail.com>
References: <loom.20111116T171334-175@post.gmane.org> <20111116230045.GY12759@twin.jikos.cz>
 <CAG+2MKL7ynWwuv9_YUOTEtV+25coh0TJEOc9f8cu_2nx2Fktdw@mail.gmail.com>
 <20111122171401.GC12759@twin.jikos.cz> <CAG+2MKJXR2XV-U2Osh+swdD_EfVqnZda_B8S6Q9UUT51eziTVA@mail.gmail.com>
 <CAG+2MKJTt2U3c1FvkG-QMBFy+R1fFFXtNXPKsXP1fe_YL6yGgA@mail.gmail.com> <4ECC48EF.6000509@cn.fujitsu.com>
Reply-To: tjcrone@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ECC48EF.6000509@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Okay, I built the version you sent me. I am guessing that this has the
newest btrfs code in it even though it is labeled 3.1.0? Is that
because it has not been merged? Relevant commands and a stack trace
below. Still says something about a null pointer.

root@berna:~# uname -a
Linux berna 3.1.0+ #3 SMP Wed Nov 23 08:27:28 EST 2011 x86_64 GNU/Linux

root@berna:~# rm -rf /home/myusername/.cache/chromium

[180054.695188] parent transid verify failed on 1782596403200 wanted
25633 found 44577
[180054.695264] parent transid verify failed on 1782596403200 wanted
25633 found 44577
[180054.695337] parent transid verify failed on 1782596403200 wanted
25633 found 44577
[180054.695409] parent transid verify failed on 1782596403200 wanted
25633 found 44577
[180054.695482] parent transid verify failed on 1782596403200 wanted
25633 found 44577
[180054.695562] parent transid verify failed on 1782596403200 wanted
25633 found 44577
[180054.695635] parent transid verify failed on 1782596403200 wanted
25633 found 44577
[180054.695708] parent transid verify failed on 1782596403200 wanted
25633 found 44577
[180054.695780] parent transid verify failed on 1782596403200 wanted
25633 found 44577
[180054.695852] parent transid verify failed on 1782596403200 wanted
25633 found 44577
[180059.285139] btrfs: corrupt leaf, slot offset bad:
block=3D1782603522048,root=3D1, slot=3D0
[180059.285229] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000020
[180059.285366] IP: [<ffffffffa020ad3f>] btrfs_print_leaf+0x28/0x766 [b=
trfs]
[180059.285465] PGD 31a5c5067 PUD 31c6c6067 PMD 0
[180059.285614] Oops: 0000 [#1] SMP
[180059.285730] CPU 6
[180059.285765] Modules linked in: parport_pc ppdev lp parport bridge
stp bnep rfcomm cpufreq_conservative bluetooth xt_tcpudp
cpufreq_userspace ipt_LOG cpufreq_powersave xt_recent cpufreq_stats
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack rfkill crc16
xt_multiport mperf iptable_filter ip_tables x_tables binfmt_misc fuse
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc firewire_sbp2 loop
snd_hda_codec_analog mxm_wmi wmi tpm_tis tpm psmouse snd_hda_intel
snd_hda_codec tpm_bios snd_hwdep snd_pcm snd_seq snd_timer i7core_edac
snd_seq_device edac_core snd soundcore asus_atk0110 processor
snd_page_alloc pcspkr button i2c_i801 i2c_core serio_raw evdev joydev
thermal_sys ext3 jbd mbcache dm_mod btrfs zlib_deflate crc32c
libcrc32c raid1 md_mod sg hid_microsoft usbhid hid sd_mod sr_mod cdrom
crc_t10dif ata_generic uhci_hcd firewire_ohci ata_piix firewire_core
crc_itu_t libata ehci_hcd scsi_mod usbcore usb_common [last unloaded:
scsi_wait_scan]
[180059.289277]
[180059.289325] Pid: 11097, comm: rm Not tainted 3.1.0+ #3 System
manufacturer System Product Name/P6T DELUXE V2
[180059.289497] RIP: 0010:[<ffffffffa020ad3f>]  [<ffffffffa020ad3f>]
btrfs_print_leaf+0x28/0x766 [btrfs]
[180059.289609] RSP: 0018:ffff88031cd8db48  EFLAGS: 00010296
[180059.289664] RAX: 0000160000000000 RBX: 0000000000000000 RCX:
0000019f0b733000
[180059.289735] RDX: ffff8802cb879500 RSI: 0000000000000000 RDI:
ffff88031cb25000
[180059.289806] RBP: ffff880000000000 R08: ffff88031cd8dfd8 R09:
0000000000000000
[180059.289877] R10: 000000000000003a R11: ffff88033fcce7f0 R12:
0000160000000000
[180059.289948] R13: 0000000000000005 R14: ffff88031cb25000 R15:
0000000000000000
[180059.290020] FS:  00007f23410ee700(0000) GS:ffff88033fcc0000(0000)
knlGS:0000000000000000
[180059.290092] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[180059.290148] CR2: 0000000000000020 CR3: 000000031c4c7000 CR4:
00000000000006e0
[180059.290219] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[180059.290290] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[180059.290362] Process rm (pid: 11097, threadinfo ffff88031cd8c000,
task ffff88031ad76d00)
[180059.290434] Stack:
[180059.290483]  ffffffff0000a000 ffff88031cb25000 0000000000000000
0000019e0330b000
[180059.290682]  0000019e03294000 ffff88031cd8dc60 0000019e0330b000
00000000001000a8
[180059.290881]  000000001168a000 ffffffff810f705e 0000019e0328a000
ffff8802cb4ec000
[180059.291081] Call Trace:
[180059.291134]  [<ffffffff810f705e>] ? kmem_cache_alloc+0x2a/0xe2
[180059.291195]  [<ffffffffa0208bae>] ? __btrfs_free_extent+0x28a/0x5e8=
 [btrfs]
[180059.291253]  [<ffffffff810f6a64>] ? __slab_free+0xdb/0x245
[180059.291314]  [<ffffffffa02095d2>] ? run_clustered_refs+0x6c6/0x716 =
[btrfs]
[180059.291376]  [<ffffffffa02096ef>] ?
btrfs_run_delayed_refs+0xcd/0x16c [btrfs]
[180059.291454]  [<ffffffffa0215610>] ?
__btrfs_end_transaction+0x83/0x1e2 [btrfs]
[180059.291532]  [<ffffffffa021e9cb>] ? btrfs_evict_inode+0x184/0x20d [=
btrfs]
[180059.291591]  [<ffffffff811141c8>] ? evict+0x9a/0x14e
[180059.291647]  [<ffffffff8110ce79>] ? do_unlinkat+0x10a/0x15e
[180059.291703]  [<ffffffff8110e950>] ? vfs_readdir+0x91/0xa7
[180059.291759]  [<ffffffff8112dd97>] ? fsnotify_find_inode_mark+0x23/0=
x2e
[180059.291817]  [<ffffffff8134f052>] ? system_call_fastpath+0x16/0x1b
[180059.291873] Code: c1 13 e1 41 57 41 56 41 55 41 54 49 bc 00 00 00
00 00 16 00 00 4c 89 e0 55 48 bd 00 00 00 00 00 88 ff ff 53 48 89 f3
48 83 ec 58
[180059.293313]  03 46 20 48 c1 f8 06 48 c1 e0 0c 8b 44 28 60 89 44 24 =
2c e8
[180059.294084] RIP  [<ffffffffa020ad3f>] btrfs_print_leaf+0x28/0x766 [=
btrfs]
[180059.294178]  RSP <ffff88031cd8db48>
[180059.294230] CR2: 0000000000000020
[180059.294286] ---[ end trace a7d81066cd58d1c9 ]---


On Tue, Nov 22, 2011 at 8:14 PM, Liu Bo <liubo2009@cn.fujitsu.com> wrot=
e:
> On 11/23/2011 06:02 AM, Timothy Crone wrote:
>> Okay, I got it. Dmesg had what I think you need. Some relavent
>> commands then the trace follow. I was trying to delete my Chrome
>> cache, because I determined that this part of the file system was
>> possibly causing my problems. I've heard of others having issues wit=
h
>> Chrome and btrfs. Not sure if this is related. If you figure out wha=
t
>> is going on, I would be interested to hear back. Cheers.
>>
>> root@berna:~# uname -a
>> Linux berna 3.1.1 #1 SMP Thu Nov 17 13:51:31 EST 2011 x86_64 GNU/Lin=
ux
>>
>> root@berna:/home/myusername/.cache# rm -rf chromium
>>
>> Nov 22 16:37:18 localhost kernel: [11287.116968] parent transid veri=
fy
>> failed on 1782596403200 wanted 25633 found 44577
>> Nov 22 16:37:18 localhost kernel: [11287.116973] parent transid veri=
fy
>> failed on 1782596403200 wanted 25633 found 44577
>> Nov 22 16:37:18 localhost kernel: [11287.116977] parent transid veri=
fy
>> failed on 1782596403200 wanted 25633 found 44577
>> Nov 22 16:37:18 localhost kernel: [11287.116980] parent transid veri=
fy
>> failed on 1782596403200 wanted 25633 found 44577
>> Nov 22 16:37:18 localhost kernel: [11287.116983] parent transid veri=
fy
>> failed on 1782596403200 wanted 25633 found 44577
>> Nov 22 16:37:18 localhost kernel: [11287.116997] parent transid veri=
fy
>> failed on 1782596403200 wanted 25633 found 44577
>> Nov 22 16:37:18 localhost kernel: [11287.116999] parent transid veri=
fy
>> failed on 1782596403200 wanted 25633 found 44577
>> Nov 22 16:37:18 localhost kernel: [11287.117001] parent transid veri=
fy
>> failed on 1782596403200 wanted 25633 found 44577
>> Nov 22 16:37:18 localhost kernel: [11287.117003] parent transid veri=
fy
>> failed on 1782596403200 wanted 25633 found 44577
>> Nov 22 16:37:18 localhost kernel: [11287.117004] parent transid veri=
fy
>> failed on 1782596403200 wanted 25633 found 44577
>> Nov 22 16:37:20 localhost kernel: [11288.764956] btrfs: corrupt leaf=
,
>> slot offset bad: block=3D1782603522048,root=3D1, slot=3D0
>> Nov 22 16:37:20 localhost kernel: [11288.764979] BUG: unable to hand=
le
>> kernel NULL pointer dereference at 0000000000000020
>
>
> Hi,
>
> I've seen that you have updated to v3.1, but I'm afraid that is not e=
nough...
>
> Apparently the latest code can provide us more debug info(Not just a =
NULL pointer).
>
> Could you please update to the latest code and see what is going on?
>
> Here it is:
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git f=
or-linus
>
>
> thanks,
> liubo
>
>> Nov 22 16:37:20 localhost kernel: [11288.764983] IP:
>> [<ffffffffa00d8d3f>] btrfs_print_leaf+0x28/0x766 [btrfs]
>> Nov 22 16:37:20 localhost kernel: [11288.764999] PGD 313061067 PUD
>> 31c39f067 PMD 0
>> Nov 22 16:37:20 localhost kernel: [11288.765001] Oops: 0000 [#1] SMP
>> Nov 22 16:37:20 localhost kernel: [11288.765003] CPU 5
>> Nov 22 16:37:20 localhost kernel: [11288.765004] Modules linked in:
>> parport_pc ppdev lp parport bridge stp rfcomm bnep xt_tcpudp ipt_LOG
>> xt_recent nf_conntrack_ipv4 nf_defrag_ipv4 xt_state bluetooth
>> nf_conntrack cpufreq_conservative cpufreq_userspace cpufreq_powersav=
e
>> xt_multiport rfkill crc16 cpufreq_stats iptable_filter mperf ip_tabl=
es
>> x_tables binfmt_misc fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl
>> sunrpc firewire_sbp2 loop nvidia(P) snd_hda_codec_analog i2c_i801
>> i2c_core asus_atk0110 psmouse processor tpm_tis i7core_edac edac_cor=
e
>> pcspkr thermal_sys tpm serio_raw snd_hda_intel snd_hda_codec snd_hwd=
ep
>> snd_pcm snd_seq snd_timer snd_seq_device mxm_wmi wmi snd soundcore
>> snd_page_alloc evdev button tpm_bios joydev ext3 jbd mbcache dm_mod
>> btrfs zlib_deflate crc32c libcrc32c raid1 md_mod sg hid_microsoft
>> usbhid hid sr_mod cdrom sd_mod crc_t10dif ata_generic uhci_hcd
>> ata_piix firewire_ohci e1000 libata firewire_core ehci_hcd crc_itu_t
>> scsi_mod usbcore sky2 [last unloaded: scsi_wait_scan]
>> Nov 22 16:37:20 localhost kernel: [11288.765038]
>> Nov 22 16:37:20 localhost kernel: [11288.765040] Pid: 3232, comm: rm
>> Tainted: P =A0 =A0 =A0 =A0 =A0 =A03.1.1 #1 System manufacturer Syste=
m Product
>> Name/P6T DELUXE V2
>> Nov 22 16:37:20 localhost kernel: [11288.765042] RIP:
>> 0010:[<ffffffffa00d8d3f>] =A0[<ffffffffa00d8d3f>]
>> btrfs_print_leaf+0x28/0x766 [btrfs]
>> Nov 22 16:37:20 localhost kernel: [11288.765049] RSP:
>> 0018:ffff88031ea69b48 =A0EFLAGS: 00010296
>> Nov 22 16:37:20 localhost kernel: [11288.765050] RAX: 00001600000000=
00
>> RBX: 0000000000000000 RCX: 0000019f0b733000
>> Nov 22 16:37:20 localhost kernel: [11288.765052] RDX: ffff8803099c5c=
80
>> RSI: 0000000000000000 RDI: ffff88032f91c800
>> Nov 22 16:37:20 localhost kernel: [11288.765053] RBP: ffff8800000000=
00
>> R08: ffff88031ea69fd8 R09: 0000000000000000
>> Nov 22 16:37:20 localhost kernel: [11288.765054] R10: 00000000000000=
3a
>> R11: ffff88033fcae230 R12: 0000160000000000
>> Nov 22 16:37:20 localhost kernel: [11288.765055] R13: 00000000000000=
05
>> R14: ffff88032f91c800 R15: 0000000000000000
>> Nov 22 16:37:20 localhost kernel: [11288.765057] FS:
>> 00007f5628162700(0000) GS:ffff88033fca0000(0000)
>> knlGS:0000000000000000
>> Nov 22 16:37:20 localhost kernel: [11288.765058] CS: =A00010 DS: 000=
0
>> ES: 0000 CR0: 000000008005003b
>> Nov 22 16:37:20 localhost kernel: [11288.765060] CR2: 00000000000000=
20
>> CR3: 0000000321ba4000 CR4: 00000000000006e0
>> Nov 22 16:37:20 localhost kernel: [11288.765061] DR0: 00000000000000=
00
>> DR1: 0000000000000000 DR2: 0000000000000000
>> Nov 22 16:37:20 localhost kernel: [11288.765062] DR3: 00000000000000=
00
>> DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Nov 22 16:37:20 localhost kernel: [11288.765064] Process rm (pid:
>> 3232, threadinfo ffff88031ea68000, task ffff88032eaf5f60)
>> Nov 22 16:37:20 localhost kernel: [11288.765065] Stack:
>> Nov 22 16:37:20 localhost kernel: [11288.765065] =A0ffffffff0000a000
>> ffff88032f91c800 0000000000000000 0000019e0330b000
>> Nov 22 16:37:20 localhost kernel: [11288.765068] =A00000019e03294000
>> ffff88031ea69c60 0000019e0330b000 00000000001000a8
>> Nov 22 16:37:20 localhost kernel: [11288.765070] =A0000000001168a000
>> ffffffff810f3272 0000019e0328a000 ffff880321178000
>> Nov 22 16:37:20 localhost kernel: [11288.765072] Call Trace:
>> Nov 22 16:37:20 localhost kernel: [11288.765076] =A0[<ffffffff810f32=
72>]
>> ? kmem_cache_alloc+0x2a/0xe1
>> Nov 22 16:37:20 localhost kernel: [11288.765083] =A0[<ffffffffa00d6b=
ae>]
>> ? __btrfs_free_extent+0x28a/0x5e8 [btrfs]
>> Nov 22 16:37:20 localhost kernel: [11288.765089] =A0[<ffffffffa00d75=
d2>]
>> ? run_clustered_refs+0x6c6/0x716 [btrfs]
>> Nov 22 16:37:20 localhost kernel: [11288.765096] =A0[<ffffffffa00d76=
ef>]
>> ? btrfs_run_delayed_refs+0xcd/0x16c [btrfs]
>> Nov 22 16:37:20 localhost kernel: [11288.765103] =A0[<ffffffffa00e36=
10>]
>> ? __btrfs_end_transaction+0x83/0x1e2 [btrfs]
>> Nov 22 16:37:20 localhost kernel: [11288.765111] =A0[<ffffffffa00ec9=
cd>]
>> ? btrfs_evict_inode+0x184/0x20d [btrfs]
>> Nov 22 16:37:20 localhost kernel: [11288.765115] =A0[<ffffffff811105=
00>]
>> ? evict+0x9a/0x14e
>> Nov 22 16:37:20 localhost kernel: [11288.765117] =A0[<ffffffff81108d=
6f>]
>> ? do_unlinkat+0x10a/0x15e
>> Nov 22 16:37:20 localhost kernel: [11288.765118] =A0[<ffffffff8110ac=
88>]
>> ? vfs_readdir+0x91/0xa7
>> Nov 22 16:37:20 localhost kernel: [11288.765121] =A0[<ffffffff81129f=
63>]
>> ? fsnotify_find_inode_mark+0x23/0x2e
>> Nov 22 16:37:20 localhost kernel: [11288.765124] =A0[<ffffffff813430=
52>]
>> ? system_call_fastpath+0x16/0x1b
>> Nov 22 16:37:20 localhost kernel: [11288.765125] Code: 21 26 e1 41 5=
7
>> 41 56 41 55 41 54 49 bc 00 00 00 00 00 16 00 00 4c 89 e0 55 48 bd 00
>> 00 00 00 00 88 ff ff 53 48 89 f3 48 83 ec 58
>> Nov 22 16:37:20 localhost kernel: [11288.765140] RIP
>> [<ffffffffa00d8d3f>] btrfs_print_leaf+0x28/0x766 [btrfs]
>> Nov 22 16:37:20 localhost kernel: [11288.765146] =A0RSP <ffff88031ea=
69b48>
>> Nov 22 16:37:20 localhost kernel: [11288.765147] CR2: 00000000000000=
20
>> Nov 22 16:37:20 localhost kernel: [11288.765148] ---[ end trace
>> 6db8d0a7667ab7d9 ]---
>>
>>
>>
>>
>>
>> On Tue, Nov 22, 2011 at 1:28 PM, Timothy Crone <tjcrone@gmail.com> w=
rote:
>>> If you tell me the best way to generate them for you, I will do tha=
t.
>>> It doesn't seem that anything is printed to /var/log/messages, and =
my
>>> machine locks up pretty soon after the segfault, so I haven't been
>>> able to get a detailed stack trace.
>>>
>>> On Tue, Nov 22, 2011 at 12:14 PM, David Sterba <dave@jikos.cz> wrot=
e:
>>>> On Fri, Nov 18, 2011 at 07:29:52AM -0500, Timothy Crone wrote:
>>>>> Okay, I installed 3.1.1 and continue to oops when trying to delet=
e a
>>>>> directory. Please let me know if you would like any additional
>>>>> information.
>>>> Do you have more detailed stacktraces from the crash?
>>>>
>>>>
>>>> david
>>>>
>>>
>>>
>>> --
>>> Timothy J. Crone
>>> Lamont-Doherty Earth Observatory
>>> Columbia University
>>> 61 Route 9W
>>> Palisades, NY 10964
>>> Tel: 845-365-8687
>>>
>>> http://www.fluidcontinuity.org
>>>
>>
>>
>>
>
>



--=20
Timothy J. Crone
Lamont-Doherty Earth Observatory
Columbia University
61 Route 9W
Palisades, NY 10964
Tel: 845-365-8687

http://www.fluidcontinuity.org
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
