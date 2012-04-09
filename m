From: Leho Kraav <leho@kraav.com>
Subject: Re: btrfs 3.2.2 -> 3.3.1 upgrade finally ate babies, some advice?
Date: Tue, 10 Apr 2012 00:32:00 +0300
Message-ID: <4F835550.6090106@kraav.com>
References: <CAMVG2stk4skvQHCyKUzjV-WLJc8Emt0GjRBZBOK-_EJj4q-JYA@mail.gmail.com> <4F82F5BA.3080504@kraav.com> <CAMVG2styuLG9ai0rb20jf=pwnAA3XU3zZsL5PfmxoMXYajG9BQ@mail.gmail.com> <4F834D75.5060703@kraav.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F834D75.5060703@kraav.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 09.04.2012 23:58, Leho Kraav wrote:
> On 09.04.2012 17:54, Daniel J Blueman wrote:
>> On 9 April 2012 22:44, Leho Kraav<leho@kraav.com> wrote:
>>
>>> And is the previous filesystem still hosed for good then? Or mounting
>>> the
>>> images with -discard might help?
>>
>> It seems like the kernel caught and prevented the discard after the
>> end of the partition, so the data should be fine; scrubbing will tell
>> you.
>
> Without the patch at least, it's BUG time. This is what happens when
> mounting the image.
>

It is also BUG time WITH the patch. Mount succeeds, but "btrfs fi 
balance HOME" gives us:

Apr 10 00:24:18 server sudo: pam_unix(sudo:session): session opened for 
user root by (uid=1000)
Apr 10 00:24:18 server kernel: [  363.839105] ------------[ cut here 
]------------
Apr 10 00:24:18 server kernel: [  363.839163] kernel BUG at 
fs/btrfs/volumes.c:2733!
Apr 10 00:24:18 server kernel: [  363.839220] invalid opcode: 0000 [#1] 
PREEMPT SMP
Apr 10 00:24:18 server kernel: [  363.839258] Modules linked in: btrfs 
zlib_deflate rfcomm bnep ext4 jbd2 snd_dummy loop fuse crc32c_intel 
nvidia(PO) snd_hda_codec_realtek snd_hda_intel snd_hda_c
odec snd_pcm dvb_usb_dib0700 dvb_usb dib0070 dib7000p dibx000_common 
imon dvb_core hid_logitech_dj btusb bluetooth hid_logitech rc_core skge 
snd_page_alloc snd_timer processor snd r8168(O) butto
n i2c_i801 rtc_cmos usbhid sr_mod cdrom firewire_ohci firewire_core 
crc_itu_t uhci_hcd pata_jmicron
Apr 10 00:24:18 server kernel: [  363.839609]
Apr 10 00:24:18 server kernel: [  363.839619] Pid: 4682, comm: btrfs 
Tainted: P           O 3.3.1-vs2.3.3.2+pf #1 Gigabyte Technology Co., 
Ltd. P55M-UD2/P55M-UD2
Apr 10 00:24:18 server kernel: [  363.839677] EIP: 0060:[<f4f4deff>] 
EFLAGS: 00210246 CPU: 1
Apr 10 00:24:18 server kernel: [  363.839709] EIP is at 
btrfs_balance+0xe7f/0xed0 [btrfs]
Apr 10 00:24:18 server kernel: [  363.839732] EAX: ffffff00 EBX: 
ffffffef ECX: 00000003 EDX: 00000303
Apr 10 00:24:18 server kernel: [  363.839758] ESI: eb868e00 EDI: 
00000000 EBP: 00000000 ESP: e8ebbdd8
Apr 10 00:24:18 server kernel: [  363.839785]  DS: 007b ES: 007b FS: 
00d8 GS: 0033 SS: 0068
Apr 10 00:24:18 server kernel: [  363.839809] Process btrfs (pid: 4682, 
ti=e8eba000 task=eb2c8ab0 task.ti=e8eba000)
Apr 10 00:24:18 server kernel: [  363.839839] Stack:
Apr 10 00:24:18 server kernel: [  363.839850]  00000040 00000001 
00000000 00000000 00000000 e8ebbe30 e8ece000 ec713bb4
Apr 10 00:24:18 server kernel: [  363.839914]  00000097 eb945000 
00000097 0000000e 00000000 00000002 00000000 f2f2d3b0
Apr 10 00:24:18 server kernel: [  363.839987]  ec0cdd34 f3153b00 
e9240600 ec0cde00 c1094152 c10cbb6b eac98b00 00000001
Apr 10 00:24:18 server kernel: [  363.840090] Call Trace:
Apr 10 00:24:18 server kernel: [  363.840109]  [<c1094152>] ? 
filemap_fault+0x82/0x420
Apr 10 00:24:18 server kernel: [  363.840132]  [<c10cbb6b>] ? 
__mem_cgroup_try_charge+0x28b/0x4c0
Apr 10 00:24:18 server kernel: [  363.840160]  [<c10aa619>] ? 
__do_fault+0x3c9/0x510
Apr 10 00:24:18 server kernel: [  363.840183]  [<c10c2865>] ? 
kmem_cache_alloc+0x75/0x90
Apr 10 00:24:18 server kernel: [  363.840212]  [<f4f53f19>] ? 
btrfs_ioctl_balance.isra.52+0x379/0x390 [btrfs]
Apr 10 00:24:18 server kernel: [  363.840246]  [<f4f56230>] ? 
update_ioctl_balance_args+0x2e0/0x2e0 [btrfs]
Apr 10 00:24:18 server kernel: [  363.840280]  [<f4f568a1>] ? 
btrfs_ioctl+0x671/0x1200 [btrfs]
Apr 10 00:24:18 server kernel: [  363.840306]  [<c10ae1b4>] ? 
handle_mm_fault+0x124/0x260
Apr 10 00:24:18 server kernel: [  363.840334]  [<f4f56230>] ? 
update_ioctl_balance_args+0x2e0/0x2e0 [btrfs]
Apr 10 00:24:18 server kernel: [  363.840363]  [<c10e01ea>] ? 
do_vfs_ioctl+0x7a/0x580
Apr 10 00:24:18 server kernel: [  363.840386]  [<c1020a10>] ? 
vmalloc_sync_all+0x10/0x10
Apr 10 00:24:18 server kernel: [  363.840409]  [<c1020b95>] ? 
do_page_fault+0x185/0x3d0
Apr 10 00:24:18 server kernel: [  363.840432]  [<c10cf15f>] ? 
do_sys_open+0x15f/0x1b0
Apr 10 00:24:18 server kernel: [  363.840453]  [<c10df1e2>] ? 
do_fcntl+0x232/0x470
Apr 10 00:24:18 server kernel: [  363.840475]  [<c10e071e>] ? 
sys_ioctl+0x2e/0x60
Apr 10 00:24:18 server kernel: [  363.840497]  [<c13c0a4c>] ? 
sysenter_do_call+0x12/0x22
Apr 10 00:24:18 server kernel: [  363.840519] Code: c7 02 e9 ee fe ff ff 
c6 07 00 66 ba ff 03 8b 7c 24 60 83 c7 01 e9 cf fe ff ff 31 db e9 70 fe 
ff ff 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b <0f> 0b 8b 74 24 7c c7 04 24 9c f7 
f7 f4 89 74 24 04 e8 dc ce 46
Apr 10 00:24:18 server kernel: [  363.840933] EIP: [<f4f4deff>] 
btrfs_balance+0xe7f/0xed0 [btrfs] SS:ESP 0068:e8ebbdd8
Apr 10 00:24:18 server kernel: [  363.841023] ---[ end trace 
8be1f61ebfe6132a ]---
~
