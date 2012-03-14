From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: kernel BUG at fs/btrfs/transaction.c:1337!
Date: Wed, 14 Mar 2012 10:54:22 +0800
Message-ID: <4F60085E.5000005@oracle.com>
References: <CAMtaSwQUG2ovM8Yv_2+kLNMQbtMzwDq1pgd9PsMC3xYn2b6xmw@mail.gmail.com> <4F5DA13A.7010506@oracle.com> <CAMtaSwThPed_GjJOGFVYhHjBiCCVNc-KAe6XsvOLpZ0dRwpYfw@mail.gmail.com> <4F5F5D72.80706@oracle.com> <CAMtaSwR0yTOp+1Do9_HE+3MPGhk0p9+6J0=wfk7PQSwA3fOV8A@mail.gmail.com> <CAMtaSwR88Z-kTW--xDAjFtkH8wss2nFKC46Ex5GkyKypi6W_7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: btrfs <linux-btrfs@vger.kernel.org>
To: qasdfgtyuiop <qasdfgtyuiop@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMtaSwR88Z-kTW--xDAjFtkH8wss2nFKC46Ex5GkyKypi6W_7A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>



 > $sudo btrfsck /home/not-a-user/broken-btrfs.img
 > bad block 29933568
 > bad block 44224512
 > parent transid verify failed on 54566912 wanted 3532 found 3475

These aren't related to the original problem as in the subject.
But it could be the panic's aftermath effect if IOs didn't made
into the disk depending on how the system was halted.
Previously this mailing-list reported the same BUG calling,
   'BUG at fs/btrfs/transaction.c:1337!'
however the stack-trace in them are different.

Here its something to do with type of IO to the underneath SSD.
SSDs generally gives better performance for random access, however
their performance aren't good when it comes to sequential access.
So it may provide some clues if we could know the sizes of upload
and download as in the below statement...

 > It seems not.  The oops occurs when I'm surfing the Internet using
 > chromium and downloading and uploading using transmisson.  Suddenly it
 > switched to console and printed these lines.  My root filesystem / is
 > on a 16GB SSD whoes device file is /dev/sdb1.  The mount option is
 > ssd,compress.

Further, You could know the Qdepth at
# cat /sys/block/sd< >/queue/nr_requests

And may be that this Q was 90% full. but this at the moment will be of
little help unless we know the other stuffs.. in the logs and probably
in the dump.

If you would want to give a try to reproduce, i would recommend
  - create sequential IO of file size equal to the files which were
    being download / uploaded.
  - do not change any of the parameter as in your original boot-disk.

  If this could trigger the problem, after the reboot enable the
  coredump and recreate the problem collect the dump. this may help.


Thanks, Anand


On 03/14/12 02:28, qasdfgtyuiop wrote:
> These information might be useful:
> $sudo btrfsck /home/not-a-user/broken-btrfs.img
> bad block 29933568
> bad block 44224512
> parent transid verify failed on 54566912 wanted 3532 found 3475
> parent transid verify failed on 54566912 wanted 3532 found 3475
> Extent back ref already exists for 40439808 parent 0 root 5
> Extent back ref already exists for 117432320 parent 0 root 5
> Extent back ref already exists for 117600256 parent 0 root 5
> Extent back ref already exists for 49078272 parent 0 root 5
> Extent back ref already exists for 164507648 parent 0 root 5
> Extent back ref already exists for 166637568 parent 0 root 5
> Extent back ref already exists for 61587456 parent 0 root 5
> Extent back ref already exists for 117633024 parent 0 root 5
> Extent back ref already exists for 250806272 parent 0 root 5
> Extent back ref already exists for 35176448 parent 0 root 5
> Extent back ref already exists for 117395456 parent 0 root 5
> Extent back ref already exists for 250949632 parent 0 root 5
> Extent back ref already exists for 117628928 parent 0 root 5
> Extent back ref already exists for 280928256 parent 0 root 5
> Extent back ref already exists for 34058240 parent 0 root 5
> Extent back ref already exists for 63078400 parent 0 root 5
> Extent back ref already exists for 117325824 parent 0 root 5
> Extent back ref already exists for 319053824 parent 0 root 5
> Extent back ref already exists for 117391360 parent 0 root 5
> Extent back ref already exists for 58880000 parent 0 root 5
> Extent back ref already exists for 139710464 parent 0 root 5
> Extent back ref already exists for 117592064 parent 0 root 5
> Extent back ref already exists for 34013184 parent 0 root 5
> Extent back ref already exists for 294502400 parent 0 root 5
> Extent back ref already exists for 70004736 parent 0 root 5
> Extent back ref already exists for 48816128 parent 0 root 5
> Extent back ref already exists for 53764096 parent 0 root 5
> Extent back ref already exists for 5456105472 parent 0 root 5
> Extent back ref already exists for 57430016 parent 0 root 5
> Extent back ref already exists for 62701568 parent 0 root 5
> Extent back ref already exists for 34869248 parent 0 root 5
> Extent back ref already exists for 34877440 parent 0 root 5
> Extent back ref already exists for 5456109568 parent 0 root 5
> Extent back ref already exists for 5456113664 parent 0 root 5
> Extent back ref already exists for 35168256 parent 0 root 5
> Extent back ref already exists for 5456117760 parent 0 root 5
> Extent back ref already exists for 51052544 parent 0 root 5
> Extent back ref already exists for 33845248 parent 0 root 5
> Extent back ref already exists for 33849344 parent 0 root 5
> Extent back ref already exists for 62627840 parent 0 root 5
> Extent back ref already exists for 5456121856 parent 0 root 5
> Extent back ref already exists for 30162944 parent 0 root 5
> Extent back ref already exists for 307396608 parent 0 root 5
> Extent back ref already exists for 5470208000 parent 0 root 5
> Extent back ref already exists for 30547968 parent 0 root 5
> Extent back ref already exists for 47996928 parent 0 root 5
> Extent back ref already exists for 5470183424 parent 0 root 5
> Extent back ref already exists for 35127296 parent 0 root 5
> Extent back ref already exists for 59133952 parent 0 root 5
> Extent back ref already exists for 33841152 parent 0 root 5
> Extent back ref already exists for 5432545280 parent 0 root 5
> Extent back ref already exists for 5456003072 parent 0 root 5
> Extent back ref already exists for 38998016 parent 0 root 5
> Extent back ref already exists for 30568448 parent 0 root 5
> Extent back ref already exists for 33296384 parent 0 root 5
> Extent back ref already exists for 5470212096 parent 0 root 5
> Extent back ref already exists for 5470216192 parent 0 root 5
> Extent back ref already exists for 41598976 parent 0 root 5
> Extent back ref already exists for 30572544 parent 0 root 5
> Extent back ref already exists for 338010112 parent 0 root 5
> Extent back ref already exists for 176168960 parent 0 root 5
> Extent back ref already exists for 290648064 parent 0 root 5
> Extent back ref already exists for 42500096 parent 0 root 5
> Extent back ref already exists for 59551744 parent 0 root 5
> Extent back ref already exists for 59772928 parent 0 root 5
> Extent back ref already exists for 65953792 parent 0 root 5
> Extent back ref already exists for 117329920 parent 0 root 5
> Extent back ref already exists for 164323328 parent 0 root 5
> Extent back ref already exists for 44875776 parent 0 root 5
> Extent back ref already exists for 30584832 parent 0 root 5
> Extent back ref already exists for 332926976 parent 0 root 5
> Extent back ref already exists for 333000704 parent 0 root 5
> parent transid verify failed on 51126272 wanted 3532 found 3413
> parent transid verify failed on 51126272 wanted 3532 found 3413
> parent transid verify failed on 51126272 wanted 3532 found 3413
> parent transid verify failed on 51126272 wanted 3532 found 3413
> Ignoring transid failure
> leaf 51126272 items 42 free space 803 generation 3413 owner 2
> fs uuid 51221b80-6228-4621-bc28-66ab07bd8ab1
> chunk uuid e4dfa132-572f-44da-bc44-162c4f294768
>   item 0 key (50118656 EXTENT_ITEM 4096) itemoff 3944 itemsize 51
>    extent refs 1 gen 142 flags 2
>    tree block key (104995 54 1323978974) level 0
>    tree block backref root 256
>   item 1 key (50122752 EXTENT_ITEM 4096) itemoff 3893 itemsize 51
>    extent refs 1 gen 142 flags 2
>    tree block key (104996 60 9) level 0
>    tree block backref root 256
>   item 2 key (50126848 EXTENT_ITEM 4096) itemoff 3842 itemsize 51
>    extent refs 1 gen 142 flags 2
>    tree block key (105000 54 65963700) level 0
>    tree block backref root 256
>   item 3 key (50130944 EXTENT_ITEM 4096) itemoff 3791 itemsize 51
>    extent refs 1 gen 142 flags 2
>    tree block key (105002 60 3) level 0
>    tree block backref root 256
>   item 4 key (50135040 EXTENT_ITEM 4096) itemoff 3740 itemsize 51
>    extent refs 1 gen 10 flags 2
>    tree block key (13363 6c 0) level 0
>    tree block backref root 256
>   item 5 key (50139136 EXTENT_ITEM 4096) itemoff 3689 itemsize 51
>    extent refs 1 gen 3413 flags 2
>    tree block key (329306112 a8 4096) level 0
>    tree block backref root 2
>   item 6 key (50143232 EXTENT_ITEM 4096) itemoff 3638 itemsize 51
>    extent refs 1 gen 10 flags 2
>    tree block key (13389 6c 0) level 0
>    tree block backref root 256
>   item 7 key (50147328 EXTENT_ITEM 4096) itemoff 3587 itemsize 51
>    extent refs 1 gen 1042 flags 2
>    tree block key (38108 6c 0) level 0
>    tree block backref root 256
>   item 8 key (50151424 EXTENT_ITEM 4096) itemoff 3536 itemsize 51
>    extent refs 1 gen 3185 flags 2
>    tree block key (14842 6c 0) level 0
>    tree block backref root 256
>   item 9 key (50155520 EXTENT_ITEM 4096) itemoff 3485 itemsize 51
>    extent refs 1 gen 3359 flags 2
>    tree block key (138272768 a8 4096) level 0
>    tree block backref root 2
>   item 10 key (50159616 EXTENT_ITEM 4096) itemoff 3434 itemsize 51
>    extent refs 1 gen 10 flags 2
>    tree block key (13411 6c 0) level 0
>    tree block backref root 256
>   item 11 key (50163712 EXTENT_ITEM 4096) itemoff 3383 itemsize 51
>    extent refs 1 gen 3413 flags 2
>    tree block key (334221312 a8 4096) level 0
>    tree block backref root 2
>   item 12 key (50167808 EXTENT_ITEM 4096) itemoff 3332 itemsize 51
>    extent refs 1 gen 3413 flags 2
>    tree block key (336216064 a8 4096) level 0
>    tree block backref root 2
>   item 13 key (50171904 EXTENT_ITEM 4096) itemoff 3281 itemsize 51
>    extent refs 1 gen 1044 flags 2
>    tree block key (18446744073709551606 80 3719999488) level 0
>    tree block backref root 7
>   item 14 key (50176000 EXTENT_ITEM 4096) itemoff 3230 itemsize 51
>    extent refs 1 gen 3221 flags 2
>    tree block key (45553 6c 0) level 0
>    tree block backref root 256
>   item 15 key (50180096 EXTENT_ITEM 4096) itemoff 3179 itemsize 51
>    extent refs 1 gen 10 flags 2
>    tree block key (13476 6c 0) level 0
>    tree block backref root 256
>   item 16 key (50184192 EXTENT_ITEM 4096) itemoff 3128 itemsize 51
>    extent refs 1 gen 142 flags 2
>    tree block key (61875 54 801940705) level 0
>    tree block backref root 256
>   item 17 key (50188288 EXTENT_ITEM 4096) itemoff 3077 itemsize 51
>    extent refs 1 gen 142 flags 2
>    tree block key (61877 54 2690822507) level 0
>    tree block backref root 256
>   item 18 key (50192384 EXTENT_ITEM 4096) itemoff 3026 itemsize 51
>    extent refs 1 gen 142 flags 2
>    tree block key (61878 54 2573316129) level 0
>    tree block backref root 256
>   item 19 key (50196480 EXTENT_ITEM 4096) itemoff 2975 itemsize 51
>    extent refs 1 gen 833 flags 2
>    tree block key (197256 6c 0) level 0
>    tree block backref root 256
>   item 20 key (50200576 EXTENT_ITEM 4096) itemoff 2924 itemsize 51
>    extent refs 1 gen 250 flags 2
>    tree block key (9293 6c 0) level 0
>    tree block backref root 256
>   item 21 key (50204672 EXTENT_ITEM 4096) itemoff 2873 itemsize 51
>    extent refs 1 gen 3413 flags 2
>    tree block key (345333760 a8 4096) level 0
>    tree block backref root 2
>   item 22 key (50208768 EXTENT_ITEM 4096) itemoff 2822 itemsize 51
>    extent refs 1 gen 10 flags 2
>    tree block key (13491 6c 0) level 0
>    tree block backref root 256
>   item 23 key (50212864 EXTENT_ITEM 4096) itemoff 2771 itemsize 51
>    extent refs 1 gen 3413 flags 2
>    tree block key (5459881984 a8 4096) level 0
>    tree block backref root 2
>   item 24 key (50216960 EXTENT_ITEM 4096) itemoff 2720 itemsize 51
>    extent refs 1 gen 3359 flags 2
>    tree block key (310218 54 2654955152) level 0
>    tree block backref root 256
>   item 25 key (50221056 EXTENT_ITEM 4096) itemoff 2669 itemsize 51
>    extent refs 1 gen 142 flags 2
>    tree block key (62047 6c 0) level 0
>    tree block backref root 256
>   item 26 key (50225152 EXTENT_ITEM 4096) itemoff 2618 itemsize 51
>    extent refs 1 gen 142 flags 2
>    tree block key (62138 c 62131) level 0
>    tree block backref root 256
>   item 27 key (50229248 EXTENT_ITEM 4096) itemoff 2567 itemsize 51
>    extent refs 1 gen 3359 flags 2
>    tree block key (310245 1 0) level 0
>    tree block backref root 256
>   item 28 key (50233344 EXTENT_ITEM 4096) itemoff 2516 itemsize 51
>    extent refs 1 gen 142 flags 2
>    tree block key (62140 54 2443586333) level 0
>    tree block backref root 256
>   item 29 key (50237440 EXTENT_ITEM 4096) itemoff 2465 itemsize 51
>    extent refs 1 gen 833 flags 2
>    tree block key (197151 54 3550991761) level 0
>    tree block backref root 256
>   item 30 key (50241536 EXTENT_ITEM 4096) itemoff 2414 itemsize 51
>    extent refs 1 gen 802 flags 2
>    tree block key (175734 6c 0) level 0
>    tree block backref root 256
>   item 31 key (50245632 EXTENT_ITEM 4096) itemoff 2363 itemsize 51
>    extent refs 1 gen 10 flags 2
>    tree block key (13534 6c 0) level 0
>    tree block backref root 256
>   item 32 key (50249728 EXTENT_ITEM 4096) itemoff 2312 itemsize 51
>    extent refs 1 gen 3359 flags 2
>    tree block key (310246 c 310218) level 0
>    tree block backref root 256
>   item 33 key (50253824 EXTENT_ITEM 4096) itemoff 2261 itemsize 51
>    extent refs 1 gen 3185 flags 2
>    tree block key (17532 1 0) level 0
>    tree block backref root 5
>   item 34 key (50257920 EXTENT_ITEM 4096) itemoff 2210 itemsize 51
>    extent refs 1 gen 1049 flags 2
>    tree block key (41424 6c 0) level 0
>    tree block backref root 256
>   item 35 key (50262016 EXTENT_ITEM 4096) itemoff 2159 itemsize 51
>    extent refs 1 gen 833 flags 2
>    tree block key (197313 1 0) level 0
>    tree block backref root 256
>   item 36 key (50266112 EXTENT_ITEM 4096) itemoff 2108 itemsize 51
>    extent refs 1 gen 10 flags 2
>    tree block key (13438 6c 0) level 0
>    tree block backref root 256
>   item 37 key (50270208 EXTENT_ITEM 4096) itemoff 2057 itemsize 51
>    extent refs 1 gen 3359 flags 2
>    tree block key (310265 c 310249) level 0
>    tree block backref root 256
>   item 38 key (50274304 EXTENT_ITEM 4096) itemoff 2006 itemsize 51
>    extent refs 1 gen 3359 flags 2
>    tree block key (310282 c 310245) level 0
>    tree block backref root 256
>   item 39 key (50278400 EXTENT_ITEM 4096) itemoff 1955 itemsize 51
>    extent refs 1 gen 833 flags 2
>    tree block key (197321 1 0) level 0
>    tree block backref root 256
>   item 40 key (50282496 EXTENT_ITEM 4096) itemoff 1904 itemsize 51
>    extent refs 1 gen 833 flags 2
>    tree block key (197338 1 0) level 0
>    tree block backref root 256
>   item 41 key (50286592 EXTENT_ITEM 4096) itemoff 1853 itemsize 51
>    extent refs 1 gen 3359 flags 2
>    tree block key (310249 54 3310625780) level 0
>    tree block backref root 256
> failed to find block number 51019776
>
>
>
> On 3/14/12, qasdfgtyuiop<qasdfgtyuiop@gmail.com>  wrote:
>> I'm sorry but I don't know how to get the kernel dump.  It seems that
>> the kernel dump is not enabled for my kernel:
>> # CONFIG_CRASH_DUMP is not set
>>
>> On 3/13/12, Anand Jain<Anand.Jain@oracle.com>  wrote:
>>>
>>>
>>>    These logs doesn't have the traces of the below BUG_ON().
>>>    stack as in the dmesg below has 'btrfs_congested_fn'
>>>    which generally notifies block-device near Q full condition.
>>>    we would need logs to confirm anything further. was there
>>>    a kernel dump generated when BUG_ON was called? that should
>>>    help.
>>>
>>> Thanks, Anand
>>>
>>>
>>> On 03/13/12 13:42, qasdfgtyuiop wrote:
>>>> All my logs are attached
>>>> I have reinstalled my system the old filesystem has been backuped as a
>>>> img file using dd if=/dev/sdb1 of=broken-btrfs.img bs=1G.  I mounted
>>>> the broken filesystem and copied the log files out.  While copying I
>>>> got the error message:
>>>> cp: reading `log/messages.log': Input/output error
>>>> cp: failed to extend `/home/gaoxiang/tests/log/messages.log':
>>>> Input/output
>>>> error
>>>> cp: reading `log/kernel.log': Input/output error
>>>> cp: failed to extend `/home/gaoxiang/tests/log/kernel.log': Input/output
>>>> error
>>>> cp: reading `log/errors.log': Input/output error
>>>> cp: failed to extend `/home/gaoxiang/tests/log/errors.log': Input/output
>>>> error
>>>> cp: reading `log/everything.log': Input/output error
>>>> cp: failed to extend `/home/gaoxiang/tests/log/everything.log':
>>>> Input/output error
>>>>
>>>>
>>>> On Mon, Mar 12, 2012 at 3:09 PM, Anand Jain<Anand.Jain@oracle.com>
>>>> wrote:
>>>>>
>>>>>    could you also post few lines of dmesg logged _before_ the below
>>>>> logs.
>>>>>
>>>>> Thanks,  -Anand
>>>>>
>>>>>
>>>>>
>>>>> On Saturday 10,March,2012 06:26 PM, qasdfgtyuiop wrote:
>>>>>>
>>>>>> [11558.527680] ------------[ cut here ]------------
>>>>>> [11558.527708] kernel BUG at fs/btrfs/transaction.c:1337!
>>>>>> [11558.527730] invalid opcode: 0000 [#1] PREEMPT SMP
>>>>> [11558.527764] CPU 1
>>>>>> [11558.527776] Modules linked in: loop nls_cp437 vfat fat dm_mod xfs
>>>>>> exportfs jfs usb_storage uas fuse ext4 jbd2 mbcache snd_hda_codec_hdmi
>>>>>> snd_hda_codec_realtek arc4 iwlwifi snd_hda_intel snd_hda_codec
>>>>>> uvcvideo snd_hwdep nouveau iTCO_wdt i2c_i801 jmb38x_ms broadcom
>>>>>> snd_pcm i915 videodev tg3 sdhci_pci v4l2_compat_ioctl32 mac80211 sdhci
>>>>>> ttm i2c_algo_bit snd_page_alloc intel_agp snd_timer mxm_wmi serio_raw
>>>>>> drm_kms_helper btusb media bluetooth drm psmouse evdev joydev pcspkr
>>>>>> crc16 mei(C) iTCO_vendor_support snd libphy intel_ips memstick
>>>>>> mmc_core cfg80211 soundcore intel_gtt i2c_core thermal battery
>>>>>> ideapad_laptop sparse_keymap rfkill wmi ac video processor button
>>>>>> btrfs crc32c libcrc32c zlib_deflate sd_mod sr_mod cdrom usbhid hid
>>>>>> ahci libahci libata scsi_mod ehci_hcd usbcore usb_common
>>>>>> [11558.528323]
>>>>>> [11558.528333] Pid: 125, comm: btrfs-transacti Tainted: G         C
>>>>>> 3.2.9-1-ARCH #1 LENOVO                           IdeaPad Y460    /KL2
>>>>>> [11558.528389] RIP: 0010:[<ffffffffa014c879>]  [<ffffffffa014c879>]
>>>>>> btrfs_commit_transaction+0x879/0x880 [btrfs]
>>>>>> [11558.528439] RSP: 0018:ffff8801af1dfde0  EFLAGS: 00010282
>>>>>> [11558.528460] RAX: 00000000fffffffb RBX: ffff8801afa91690 RCX:
>>>>>> 0000000000000000
>>>>>> [11558.528484] RDX: ffff8801af1dfce8 RSI: 0000000003c10000 RDI:
>>>>>> ffff8801afa916f0
>>>>>> [11558.528510] RBP: ffff8801af1dfe70 R08: 0000000000002000 R09:
>>>>>> 0000000000000000
>>>>>> [11558.528536] R10: 0000000000000000 R11: 0000000000000001 R12:
>>>>>> ffff8801b13ab000
>>>>>> [11558.528561] R13: ffff8801afa90c18 R14: ffff8801afa91708 R15:
>>>>>> 0000000000000218
>>>>>> [11558.528586] FS:  0000000000000000(0000) GS:ffff8801bbc80000(0000)
>>>>>> knlGS:0000000000000000
>>>>>> [11558.528616] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>>>> [11558.528637] CR2: 00007fb7899244e8 CR3: 0000000001805000 CR4:
>>>>>> 00000000000006e0
>>>>>> [11558.528663] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>>>>> 0000000000000000
>>>>>> [11558.528688] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>>>>>> 0000000000000400
>>>>>> [11558.528714] Process btrfs-transacti (pid: 125, threadinfo
>>>>>> ffff8801af1de000, task ffff8801aff2ce60)
>>>>>> [11558.528744] Stack:
>>>>>> [11558.528755]  ffff8801af1dfe10 0000000000000000 0000000000000000
>>>>>> ffff8801aff2ce60
>>>>>> [11558.528791]  ffffffff81088d80 ffff8801af1dfe08 ffff8801af1dfe08
>>>>>> ffffffffa014ccd4
>>>>>> [11558.528827]  0000000000000000 00000000af2b0560 ffff8801aff2ce60
>>>>>> ffff8801b13ab000
>>>>>> [11558.528863] Call Trace:
>>>>>> [11558.528879]  [<ffffffff81088d80>] ? abort_exclusive_wait+0xb0/0xb0
>>>>>> [11558.528910]  [<ffffffffa014ccd4>] ? start_transaction+0x94/0x2b0
>>>>>> [btrfs]
>>>>>> [11558.528940]  [<ffffffffa0144e6d>] transaction_kthread+0x26d/0x290
>>>>>> [btrfs]
>>>>>> [11558.528971]  [<ffffffffa0144c00>] ? btrfs_congested_fn+0xd0/0xd0
>>>>>> [btrfs]
>>>>>> [11558.528996]  [<ffffffff8108843c>] kthread+0x8c/0xa0
>>>>>> [11558.529018]  [<ffffffff8145feb4>] kernel_thread_helper+0x4/0x10
>>>>>> [11558.529040]  [<ffffffff810883b0>] ? kthread_worker_fn+0x190/0x190
>>>>>> [11558.529064]  [<ffffffff8145feb0>] ? gs_change+0x13/0x13
>>>>>> [11558.529083] Code: ff ff e9 44 f9 ff ff 0f 0b 0f 0b 0f 0b be fc 04
>>>>>> 00 00 48 c7 c7 fa 00 1a a0 e8 84 98 f1 e0 e9 3c fb ff ff 0f 0b 0f 0b
>>>>>> 0f 0b 0f 0b<0f>     0b 0f 0b 0f 1f 00 55 48 89 e5 53 48 83 ec 08 66 66
>>>>>> 66
>>>>>> 66 90
>>>>>> [11558.529389] RIP  [<ffffffffa014c879>]
>>>>>> btrfs_commit_transaction+0x879/0x880 [btrfs]
>>>>>> [11558.529425]  RSP<ffff8801af1dfde0>
>>>>>> [11558.592012] ---[ end trace e0456c287e012690 ]---
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>>>> in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
