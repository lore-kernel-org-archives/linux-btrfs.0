From: Leho Kraav <leho@kraav.com>
Subject: Re: btrfs 3.2.2 -> 3.3.1 upgrade finally ate babies, some advice?
Date: Mon, 09 Apr 2012 23:58:29 +0300
Message-ID: <4F834D75.5060703@kraav.com>
References: <CAMVG2stk4skvQHCyKUzjV-WLJc8Emt0GjRBZBOK-_EJj4q-JYA@mail.gmail.com> <4F82F5BA.3080504@kraav.com> <CAMVG2styuLG9ai0rb20jf=pwnAA3XU3zZsL5PfmxoMXYajG9BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMVG2styuLG9ai0rb20jf=pwnAA3XU3zZsL5PfmxoMXYajG9BQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 09.04.2012 17:54, Daniel J Blueman wrote:
> On 9 April 2012 22:44, Leho Kraav<leho@kraav.com>  wrote:
>
>> And is the previous filesystem still hosed for good then? Or mounting the
>> images with -discard might help?
>
> It seems like the kernel caught and prevented the discard after the
> end of the partition, so the data should be fine; scrubbing will tell
> you.

Without the patch at least, it's BUG time. This is what happens when 
mounting the image.

...
[171555.937706] device label HOME devid 1 transid 370409 /dev/loop3
[171555.956786] device label HOME devid 2 transid 370409 /dev/loop4
[171647.077501] device label HOME devid 2 transid 370409 /dev/loop4
[171647.196262] btrfs: continuing balance
[171650.826278] btrfs: relocating block group 18278776832 flags 9
[171651.218444] btrfs csum failed ino 257 off 262144 csum 3439556781 
private 289331560
[171651.226455] btrfs csum failed ino 257 off 196608 csum 3957169907 
private 1046207033
[171651.227070] btrfs csum failed ino 257 off 196608 csum 3957169907 
private 1046207033
[171652.484666] ------------[ cut here ]------------
[171652.484669] kernel BUG at fs/btrfs/volumes.c:2487!
[171652.484671] invalid opcode: 0000 [#1] PREEMPT SMP
[171652.484673] Modules linked in: btrfs zlib_deflate lrw gf128mul 
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) coretemp it87 hwmon_vid hwmon nfs 
autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc iptable_mangle ipt_ULOG 
xt_recent xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state 
nf_conntrack iptable_filter ip_tables x_tables squashfs imon rfcomm bnep 
ext4 jbd2 snd_dummy loop fuse crc32c_intel nvidia(PO) 
snd_hda_codec_realtek dvb_usb_dib0700 dib7000p dib0070 dvb_usb dvb_core 
snd_hda_intel snd_hda_codec snd_pcm rc_core btusb bluetooth snd_timer 
r8168(O) processor skge snd rtc_cmos sg snd_page_alloc button 
dibx000_common i2c_i801 hid_logitech_dj hid_logitech usbhid sr_mod cdrom 
firewire_ohci firewire_core crc_itu_t pata_jmicron uhci_hcd [last 
unloaded: imon]
[171652.484703]
[171652.484705] Pid: 21206, comm: btrfs-balance Tainted: P           O 
3.3.1-vs2.3.3.2+pf #1 Gigabyte Technology Co., Ltd. P55M-UD2/P55M-UD2
[171652.484708] EIP: 0060:[<fa252ec9>] EFLAGS: 00010282 CPU: 1
[171652.484718] EIP is at btrfs_balance+0xe79/0xed0 [btrfs]
[171652.484719] EAX: fffffffb EBX: d0e58e00 ECX: 80240022 EDX: 80240023
[171652.484721] ESI: 7fd00000 EDI: 00000002 EBP: cc046068 ESP: dc5a3ef0
[171652.484722]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[171652.484724] Process btrfs-balance (pid: 21206, ti=dc5a2000 
task=c40ee750 task.ti=dc5a2000)
[171652.484725] Stack:
[171652.484726]  00000096 c14d806c c1048ebb 00000046 00000046 7fe00000 
00000002 df15d800
[171652.484729]  00000000 c8efc000 c1580e3d 00000030 00000000 00000246 
00000000 ec85a800
[171652.484733]  00029e7f 0002fea6 dc5a3f52 00000010 00000000 00000003 
00000246 00000000
[171652.484736] Call Trace:
[171652.484740]  [<c1048ebb>] ? up+0xb/0x40
[171652.484743]  [<c104dbfe>] ? try_to_wake_up+0x6e/0x100
[171652.484745]  [<c104dc98>] ? default_wake_function+0x8/0x10
[171652.484752]  [<fa252f7f>] ? balance_kthread+0x5f/0xa0 [btrfs]
[171652.484759]  [<fa252f20>] ? btrfs_balance+0xed0/0xed0 [btrfs]
[171652.484761]  [<c104381e>] ? kthread+0x6e/0x80
[171652.484763]  [<c10437b0>] ? kthread_freezable_should_stop+0x50/0x50
[171652.484771]  [<c13c0fb6>] ? kernel_thread_helper+0x6/0xd
[171652.484772] Code: 00 00 83 ea 02 83 c7 02 e9 ee fe ff ff c6 07 00 66 
ba ff 03 8b 7c 24 60 83 c7 01 e9 cf fe ff ff 31 db e9 70 fe ff ff 0f 0b 
0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 8b 74 24 7c c7 04 24 5c 47 28 fa 89 74
[171652.484793] EIP: [<fa252ec9>] btrfs_balance+0xe79/0xed0 [btrfs] 
SS:ESP 0068:dc5a3ef0
[171652.484802] ---[ end trace 15f25988d7f952de ]---
...
