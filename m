Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34493 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbbHONPD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Aug 2015 09:15:03 -0400
Received: by iodb91 with SMTP id b91so109468705iod.1
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2015 06:15:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU8UGY6pT-ugL4AehD=920O+THc_TcxXc+eOn28ujKJhMw@mail.gmail.com>
References: <CAK7bmU9vTap5JdkhCDNB=6BC4_fsU-6MCmS3QiFP1Mu2C7yjng@mail.gmail.com>
	<CAK7bmU-a6W1UaPf31WargEGzQdWH7-GDN9Vd1h_1GnQwv-_FsQ@mail.gmail.com>
	<55CEC72D.4060503@oracle.com>
	<CAK7bmU9Hwz9ekQQhC+kzAJ_f1Jyzk5_=LLd4aPZN7f-Q2L3POw@mail.gmail.com>
	<CAK7bmU8UGY6pT-ugL4AehD=920O+THc_TcxXc+eOn28ujKJhMw@mail.gmail.com>
Date: Sat, 15 Aug 2015 09:15:02 -0400
Message-ID: <CAK7bmU-oO-h8nrbxFzfLoj0xOxmjQfjdDkswBZH6j=tnRUZ5VA@mail.gmail.com>
Subject: Re: "delete missing" with two missing devices doesn't delete both
 missing, only does a partial reconstruction
From: Timothy Normand Miller <theosib@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh, it went read-only because it OOPSed:

[39710.419966] ------------[ cut here ]------------
[39710.419969] WARNING: CPU: 1 PID: 5624 at
fs/btrfs/extent-tree.c:6226 __btrfs_free_extent+0x873/0xc80()
[39710.419970] Modules linked in: nfsd auth_rpcgss oid_registry
nfs_acl ipv6 binfmt_misc snd_hda_codec_hdmi snd_hda_codec_realtek
ppdev snd_hda_codec_generic x86_pkg_temp_thermal coretemp kvm_intel
snd_hda_intel snd_hda_controller kvm snd_hda_codec snd_hda_core
microcode snd_hwdep pcspkr snd_pcm snd_timer i2c_i801 snd lpc_ich
mfd_core parport_pc battery xts gf128mul aes_x86_64 cbc sha256_generic
libiscsi scsi_transport_iscsi tg3 ptp pps_core libphy sky2 r8169
pcnet32 mii e1000 bnx2 fuse nfs lockd grace sunrpc reiserfs multipath
linear raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx raid1 raid0 dm_snapshot dm_bufio dm_crypt dm_mirror
dm_region_hash dm_log dm_mod firewire_core hid_sunplus hid_sony
hid_samsung hid_pl hid_petalynx hid_gyration usbhid uhci_hcd
usb_storage ehci_pci
[39710.419991]  ehci_hcd aic94xx libsas qla2xxx megaraid_sas
megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx
3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc mptspi
mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx
gdth advansys initio BusLogic arcmsr aic7xxx aic79xx
scsi_transport_spi sg sata_mv sata_sil24 sata_sil pata_marvell
[39710.420003] CPU: 1 PID: 5624 Comm: kworker/u8:7 Tainted: G        W
      4.1.4-gentoo #1
[39710.420003] Hardware name: ECS H87H3-M/H87H3-M, BIOS 4.6.5 07/16/2013
[39710.420005] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
[39710.420006]  0000000000000000 ffffffff8197e672 ffffffff81794418
0000000000000000
[39710.420008]  ffffffff81049cbc 000001846cc5e000 ffff880064d12000
000000000000e000
[39710.420009]  00000000fffffffe 0000000000000000 ffffffff8127bc03
00000000000fc277
[39710.420010] Call Trace:
[39710.420012]  [<ffffffff81794418>] ? dump_stack+0x40/0x50
[39710.420014]  [<ffffffff81049cbc>] ? warn_slowpath_common+0x7c/0xb0
[39710.420015]  [<ffffffff8127bc03>] ? __btrfs_free_extent+0x873/0xc80
[39710.420018]  [<ffffffff81353ef0>] ? cpumask_next_and+0x30/0x50
[39710.420019]  [<ffffffff81075c93>] ? enqueue_task_fair+0x2c3/0xdb0
[39710.420021]  [<ffffffff812e054c>] ? btrfs_delayed_ref_lock+0x2c/0x260
[39710.420022]  [<ffffffff81280ffc>] ? __btrfs_run_delayed_refs+0x42c/0x1280
[39710.420024]  [<ffffffff8113cedd>] ? __sb_start_write+0x3d/0xe0
[39710.420025]  [<ffffffff81285f7e>] ? btrfs_run_delayed_refs.part.58+0x5e/0x270
[39710.420026]  [<ffffffff81286228>] ? delayed_ref_async_start+0x78/0x90
[39710.420028]  [<ffffffff812c56f3>] ? normal_work_helper+0x73/0x2a0
[39710.420029]  [<ffffffff8105ebbc>] ? process_one_work+0x13c/0x3d0
[39710.420031]  [<ffffffff8105eeb3>] ? worker_thread+0x63/0x480
[39710.420032]  [<ffffffff8105ee50>] ? process_one_work+0x3d0/0x3d0
[39710.420033]  [<ffffffff81063a5e>] ? kthread+0xce/0xf0
[39710.420034]  [<ffffffff81063990>] ? kthread_create_on_node+0x180/0x180
[39710.420036]  [<ffffffff8179ced2>] ? ret_from_fork+0x42/0x70
[39710.420037]  [<ffffffff81063990>] ? kthread_create_on_node+0x180/0x180
[39710.420038] ---[ end trace 0b4fe6057cd7a1a4 ]---

On Sat, Aug 15, 2015 at 9:13 AM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> So I tried deleting the files that I think are the problem, and the
> file system went suddenly read-only, and I got this in dmesg:
>
> A bunch of these first messages:
> [39710.420118]  item 45 key (1668296151040 168 524288) itemoff 1557 itemsize 53
> [39710.420118]          extent refs 1 gen 166914 flags 1
> [39710.420119]          extent data backref root 949 objectid 440675
> offset 2621440 count 1
> [39710.420120]  item 46 key (1668296675328 168 524288) itemoff 1504 itemsize 53
> [39710.420120]          extent refs 1 gen 166914 flags 1
> [39710.420121]          extent data backref root 949 objectid 440675
> offset 3145728 count 1
> [39710.420121]  item 47 key (1668297199616 168 524288) itemoff 1451 itemsize 53
> [39710.420122]          extent refs 1 gen 166914 flags 1
> [39710.420122]          extent data backref root 949 objectid 440675
> offset 3670016 count 1
> [39710.420123]  item 48 key (1668297723904 168 524288) itemoff 1398 itemsize 53
> [39710.420123]          extent refs 1 gen 166914 flags 1
> [39710.420124]          extent data backref root 949 objectid 440675
> offset 4194304 count 1
> [39710.420125]  item 49 key (1668298248192 168 524288) itemoff 1345 itemsize 53
> [39710.420125]          extent refs 1 gen 166914 flags 1
> [39710.420126]          extent data backref root 949 objectid 440675
> offset 4718592 count 1
> [39710.420126]  item 50 key (1668298772480 168 524288) itemoff 1292 itemsize 53
> [39710.420127]          extent refs 1 gen 166914 flags 1
> [39710.420127]          extent data backref root 949 objectid 440675
> offset 5242880 count 1
> [39710.420128] BTRFS error (device sdc): unable to find ref byte nr
> 1668272218112 parent 0 root 949  owner 1032823 offset 655360
> [39710.420129] BTRFS: error (device sdc) in __btrfs_free_extent:6232:
> errno=-2 No such entry
> [39710.420131] BTRFS: error (device sdc) in
> btrfs_run_delayed_refs:2821: errno=-2 No such entry
> [39710.431108] pending csums is 5795840
>
> On Sat, Aug 15, 2015 at 8:51 AM, Timothy Normand Miller
> <theosib@gmail.com> wrote:
>> I didn't quite understand "profile and convert", since I can't find a
>> profile option.  Is this something your patch adds?
>>
>> Before I do that, however, I have to deal with this:
>>
>> compute0 ~ # btrfs device delete missing /mnt/btrfs
>> ERROR: error removing the device 'missing' - Input/output error
>>
>> [13058.298763] BTRFS warning (device sdc): csum failed ino 596 off
>> 623218688 csum 2756583412 expected csum 4104700738
>> [13058.298775] BTRFS warning (device sdc): csum failed ino 596 off
>> 623222784 csum 2568037276 expected csum 275151414
>> [13058.298782] BTRFS warning (device sdc): csum failed ino 596 off
>> 623226880 csum 2227564114 expected csum 3824181799
>> [13058.298788] BTRFS warning (device sdc): csum failed ino 596 off
>> 623230976 csum 3298529275 expected csum 1155389604
>> [13058.298794] BTRFS warning (device sdc): csum failed ino 596 off
>> 623235072 csum 2603391790 expected csum 1861925401
>> [13058.298801] BTRFS warning (device sdc): csum failed ino 596 off
>> 623239168 csum 2044148708 expected csum 3227559459
>> [13058.298807] BTRFS warning (device sdc): csum failed ino 596 off
>> 623243264 csum 615351306 expected csum 2720021058
>> [13058.329747] BTRFS warning (device sdc): csum failed ino 596 off
>> 623218688 csum 2756583412 expected csum 4104700738
>> [13058.329759] BTRFS warning (device sdc): csum failed ino 596 off
>> 623222784 csum 2568037276 expected csum 275151414
>> [13058.329770] BTRFS warning (device sdc): csum failed ino 596 off
>> 623226880 csum 2227564114 expected csum 3824181799
>>
>> Because of this, it won't delete the missing device.  How do I get
>> past this?  I'm pretty sure the problem is in some files I want to
>> delete anyhow.  Would deleting them solve the problem?
>>
>> On Sat, Aug 15, 2015 at 12:59 AM, Anand Jain <anand.jain@oracle.com> wrote:
>>>
>>>> BTW, when this is all over with, how do I make sure there are really
>>>> two copies of everything?  Will a scrub verify this?  Should I run a
>>>> balance operation?
>>>
>>> pls use 'btrfs bal profile and convert' to migrate single chunk (if any
>>> created when there were lesser number of RW-able devices) back to your
>>> desired raid1. Do this when all the devices are back online. Kindly note
>>> there is a bug in the btrfs VM that you won't be able to bring a device
>>> online with out unmount -> mount (I am working to fix). btrfs-progs will be
>>> wrong in this case don't depend too much on that.
>>> So to understand inside of btrfs kernel volume I generally use:
>>>     https://patchwork.kernel.org/patch/5816011/
>>>
>>> In there if bdev is null it indicates device is scanned but not part of VM
>>> yet. Then unmount -> mount will bring device back to be part of VM.
>>>
>>>>> After applying Anand's patch, I was able to mount my 4-drive RAID1
>>>>> and bring a new fourth drive online.
>>>
>>>>> However, something weird happened
>>>>> where the first "delete missing" only deleted one missing drive and
>>>>> only did a partial duplication.  I've posted a bug report here:
>>>
>>> that seems to be normal to me. unless I am missing something else / clarity.
>>>
>>>
>>> Thanks, Anand
>>
>>
>>
>> --
>> Timothy Normand Miller, PhD
>> Assistant Professor of Computer Science, Binghamton University
>> http://www.cs.binghamton.edu/~millerti/
>> Open Graphics Project
>
>
>
> --
> Timothy Normand Miller, PhD
> Assistant Professor of Computer Science, Binghamton University
> http://www.cs.binghamton.edu/~millerti/
> Open Graphics Project



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
