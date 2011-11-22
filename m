From: Timothy Crone <tjcrone@gmail.com>
Subject: Re: Segmentation Faults
Date: Tue, 22 Nov 2011 17:02:40 -0500
Message-ID: <CAG+2MKJTt2U3c1FvkG-QMBFy+R1fFFXtNXPKsXP1fe_YL6yGgA@mail.gmail.com>
References: <loom.20111116T171334-175@post.gmane.org> <20111116230045.GY12759@twin.jikos.cz>
 <CAG+2MKL7ynWwuv9_YUOTEtV+25coh0TJEOc9f8cu_2nx2Fktdw@mail.gmail.com>
 <20111122171401.GC12759@twin.jikos.cz> <CAG+2MKJXR2XV-U2Osh+swdD_EfVqnZda_B8S6Q9UUT51eziTVA@mail.gmail.com>
Reply-To: tjcrone@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Timothy Crone <tjcrone@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG+2MKJXR2XV-U2Osh+swdD_EfVqnZda_B8S6Q9UUT51eziTVA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Okay, I got it. Dmesg had what I think you need. Some relavent
commands then the trace follow. I was trying to delete my Chrome
cache, because I determined that this part of the file system was
possibly causing my problems. I've heard of others having issues with
Chrome and btrfs. Not sure if this is related. If you figure out what
is going on, I would be interested to hear back. Cheers.

root@berna:~# uname -a
Linux berna 3.1.1 #1 SMP Thu Nov 17 13:51:31 EST 2011 x86_64 GNU/Linux

root@berna:/home/myusername/.cache# rm -rf chromium

Nov 22 16:37:18 localhost kernel: [11287.116968] parent transid verify
failed on 1782596403200 wanted 25633 found 44577
Nov 22 16:37:18 localhost kernel: [11287.116973] parent transid verify
failed on 1782596403200 wanted 25633 found 44577
Nov 22 16:37:18 localhost kernel: [11287.116977] parent transid verify
failed on 1782596403200 wanted 25633 found 44577
Nov 22 16:37:18 localhost kernel: [11287.116980] parent transid verify
failed on 1782596403200 wanted 25633 found 44577
Nov 22 16:37:18 localhost kernel: [11287.116983] parent transid verify
failed on 1782596403200 wanted 25633 found 44577
Nov 22 16:37:18 localhost kernel: [11287.116997] parent transid verify
failed on 1782596403200 wanted 25633 found 44577
Nov 22 16:37:18 localhost kernel: [11287.116999] parent transid verify
failed on 1782596403200 wanted 25633 found 44577
Nov 22 16:37:18 localhost kernel: [11287.117001] parent transid verify
failed on 1782596403200 wanted 25633 found 44577
Nov 22 16:37:18 localhost kernel: [11287.117003] parent transid verify
failed on 1782596403200 wanted 25633 found 44577
Nov 22 16:37:18 localhost kernel: [11287.117004] parent transid verify
failed on 1782596403200 wanted 25633 found 44577
Nov 22 16:37:20 localhost kernel: [11288.764956] btrfs: corrupt leaf,
slot offset bad: block=1782603522048,root=1, slot=0
Nov 22 16:37:20 localhost kernel: [11288.764979] BUG: unable to handle
kernel NULL pointer dereference at 0000000000000020
Nov 22 16:37:20 localhost kernel: [11288.764983] IP:
[<ffffffffa00d8d3f>] btrfs_print_leaf+0x28/0x766 [btrfs]
Nov 22 16:37:20 localhost kernel: [11288.764999] PGD 313061067 PUD
31c39f067 PMD 0
Nov 22 16:37:20 localhost kernel: [11288.765001] Oops: 0000 [#1] SMP
Nov 22 16:37:20 localhost kernel: [11288.765003] CPU 5
Nov 22 16:37:20 localhost kernel: [11288.765004] Modules linked in:
parport_pc ppdev lp parport bridge stp rfcomm bnep xt_tcpudp ipt_LOG
xt_recent nf_conntrack_ipv4 nf_defrag_ipv4 xt_state bluetooth
nf_conntrack cpufreq_conservative cpufreq_userspace cpufreq_powersave
xt_multiport rfkill crc16 cpufreq_stats iptable_filter mperf ip_tables
x_tables binfmt_misc fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl
sunrpc firewire_sbp2 loop nvidia(P) snd_hda_codec_analog i2c_i801
i2c_core asus_atk0110 psmouse processor tpm_tis i7core_edac edac_core
pcspkr thermal_sys tpm serio_raw snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm snd_seq snd_timer snd_seq_device mxm_wmi wmi snd soundcore
snd_page_alloc evdev button tpm_bios joydev ext3 jbd mbcache dm_mod
btrfs zlib_deflate crc32c libcrc32c raid1 md_mod sg hid_microsoft
usbhid hid sr_mod cdrom sd_mod crc_t10dif ata_generic uhci_hcd
ata_piix firewire_ohci e1000 libata firewire_core ehci_hcd crc_itu_t
scsi_mod usbcore sky2 [last unloaded: scsi_wait_scan]
Nov 22 16:37:20 localhost kernel: [11288.765038]
Nov 22 16:37:20 localhost kernel: [11288.765040] Pid: 3232, comm: rm
Tainted: P            3.1.1 #1 System manufacturer System Product
Name/P6T DELUXE V2
Nov 22 16:37:20 localhost kernel: [11288.765042] RIP:
0010:[<ffffffffa00d8d3f>]  [<ffffffffa00d8d3f>]
btrfs_print_leaf+0x28/0x766 [btrfs]
Nov 22 16:37:20 localhost kernel: [11288.765049] RSP:
0018:ffff88031ea69b48  EFLAGS: 00010296
Nov 22 16:37:20 localhost kernel: [11288.765050] RAX: 0000160000000000
RBX: 0000000000000000 RCX: 0000019f0b733000
Nov 22 16:37:20 localhost kernel: [11288.765052] RDX: ffff8803099c5c80
RSI: 0000000000000000 RDI: ffff88032f91c800
Nov 22 16:37:20 localhost kernel: [11288.765053] RBP: ffff880000000000
R08: ffff88031ea69fd8 R09: 0000000000000000
Nov 22 16:37:20 localhost kernel: [11288.765054] R10: 000000000000003a
R11: ffff88033fcae230 R12: 0000160000000000
Nov 22 16:37:20 localhost kernel: [11288.765055] R13: 0000000000000005
R14: ffff88032f91c800 R15: 0000000000000000
Nov 22 16:37:20 localhost kernel: [11288.765057] FS:
00007f5628162700(0000) GS:ffff88033fca0000(0000)
knlGS:0000000000000000
Nov 22 16:37:20 localhost kernel: [11288.765058] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Nov 22 16:37:20 localhost kernel: [11288.765060] CR2: 0000000000000020
CR3: 0000000321ba4000 CR4: 00000000000006e0
Nov 22 16:37:20 localhost kernel: [11288.765061] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Nov 22 16:37:20 localhost kernel: [11288.765062] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 22 16:37:20 localhost kernel: [11288.765064] Process rm (pid:
3232, threadinfo ffff88031ea68000, task ffff88032eaf5f60)
Nov 22 16:37:20 localhost kernel: [11288.765065] Stack:
Nov 22 16:37:20 localhost kernel: [11288.765065]  ffffffff0000a000
ffff88032f91c800 0000000000000000 0000019e0330b000
Nov 22 16:37:20 localhost kernel: [11288.765068]  0000019e03294000
ffff88031ea69c60 0000019e0330b000 00000000001000a8
Nov 22 16:37:20 localhost kernel: [11288.765070]  000000001168a000
ffffffff810f3272 0000019e0328a000 ffff880321178000
Nov 22 16:37:20 localhost kernel: [11288.765072] Call Trace:
Nov 22 16:37:20 localhost kernel: [11288.765076]  [<ffffffff810f3272>]
? kmem_cache_alloc+0x2a/0xe1
Nov 22 16:37:20 localhost kernel: [11288.765083]  [<ffffffffa00d6bae>]
? __btrfs_free_extent+0x28a/0x5e8 [btrfs]
Nov 22 16:37:20 localhost kernel: [11288.765089]  [<ffffffffa00d75d2>]
? run_clustered_refs+0x6c6/0x716 [btrfs]
Nov 22 16:37:20 localhost kernel: [11288.765096]  [<ffffffffa00d76ef>]
? btrfs_run_delayed_refs+0xcd/0x16c [btrfs]
Nov 22 16:37:20 localhost kernel: [11288.765103]  [<ffffffffa00e3610>]
? __btrfs_end_transaction+0x83/0x1e2 [btrfs]
Nov 22 16:37:20 localhost kernel: [11288.765111]  [<ffffffffa00ec9cd>]
? btrfs_evict_inode+0x184/0x20d [btrfs]
Nov 22 16:37:20 localhost kernel: [11288.765115]  [<ffffffff81110500>]
? evict+0x9a/0x14e
Nov 22 16:37:20 localhost kernel: [11288.765117]  [<ffffffff81108d6f>]
? do_unlinkat+0x10a/0x15e
Nov 22 16:37:20 localhost kernel: [11288.765118]  [<ffffffff8110ac88>]
? vfs_readdir+0x91/0xa7
Nov 22 16:37:20 localhost kernel: [11288.765121]  [<ffffffff81129f63>]
? fsnotify_find_inode_mark+0x23/0x2e
Nov 22 16:37:20 localhost kernel: [11288.765124]  [<ffffffff81343052>]
? system_call_fastpath+0x16/0x1b
Nov 22 16:37:20 localhost kernel: [11288.765125] Code: 21 26 e1 41 57
41 56 41 55 41 54 49 bc 00 00 00 00 00 16 00 00 4c 89 e0 55 48 bd 00
00 00 00 00 88 ff ff 53 48 89 f3 48 83 ec 58
Nov 22 16:37:20 localhost kernel: [11288.765140] RIP
[<ffffffffa00d8d3f>] btrfs_print_leaf+0x28/0x766 [btrfs]
Nov 22 16:37:20 localhost kernel: [11288.765146]  RSP <ffff88031ea69b48>
Nov 22 16:37:20 localhost kernel: [11288.765147] CR2: 0000000000000020
Nov 22 16:37:20 localhost kernel: [11288.765148] ---[ end trace
6db8d0a7667ab7d9 ]---





On Tue, Nov 22, 2011 at 1:28 PM, Timothy Crone <tjcrone@gmail.com> wrote:
> If you tell me the best way to generate them for you, I will do that.
> It doesn't seem that anything is printed to /var/log/messages, and my
> machine locks up pretty soon after the segfault, so I haven't been
> able to get a detailed stack trace.
>
> On Tue, Nov 22, 2011 at 12:14 PM, David Sterba <dave@jikos.cz> wrote:
>> On Fri, Nov 18, 2011 at 07:29:52AM -0500, Timothy Crone wrote:
>>> Okay, I installed 3.1.1 and continue to oops when trying to delete a
>>> directory. Please let me know if you would like any additional
>>> information.
>>
>> Do you have more detailed stacktraces from the crash?
>>
>>
>> david
>>
>
>
>
> --
> Timothy J. Crone
> Lamont-Doherty Earth Observatory
> Columbia University
> 61 Route 9W
> Palisades, NY 10964
> Tel: 845-365-8687
>
> http://www.fluidcontinuity.org
>



-- 
Timothy J. Crone
Lamont-Doherty Earth Observatory
Columbia University
61 Route 9W
Palisades, NY 10964
Tel: 845-365-8687

http://www.fluidcontinuity.org
