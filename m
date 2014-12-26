Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:40744 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbaLZWst (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Dec 2014 17:48:49 -0500
Message-ID: <549DE5C6.2000606@pobox.com>
Date: Fri, 26 Dec 2014 14:48:38 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
References: <3738341.y7uRQFcLJH@merkaba>
In-Reply-To: <3738341.y7uRQFcLJH@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/26/2014 05:37 AM, Martin Steigerwald wrote:
> Hello!
>
> First: Have a merry christmas and enjoy a quiet time in these days.
>
> Second: At a time you feel like it, here is a little rant, but also a bug
> report:
>
> I have this on 3.18 kernel on Debian Sid with BTRFS Dual SSD RAID with
> space_cache, skinny meta data extents – are these a problem? – and
> compress=lzo:

(there is no known problem with skinny metadata, it's actually more 
efficient than the older format. There has been some anecdotes about 
mixing the skinny and fat metadata but nothing has ever been 
demonstrated problematic.)

>
> merkaba:~> btrfs fi sh /home
> Label: 'home'  uuid: b96c4f72-0523-45ac-a401-f7be73dd624a
>          Total devices 2 FS bytes used 144.41GiB
>          devid    1 size 160.00GiB used 160.00GiB path /dev/mapper/msata-home
>          devid    2 size 160.00GiB used 160.00GiB path /dev/mapper/sata-home
>
> Btrfs v3.17
> merkaba:~> btrfs fi df /home
> Data, RAID1: total=154.97GiB, used=141.12GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=5.00GiB, used=3.29GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

This filesystem, at the allocation level, is "very full" (see below).

> And I had hangs with BTRFS again. This time as I wanted to install tax
> return software in Virtualbox´d Windows XP VM (which I use once a year
> cause I know no tax return software for Linux which would be suitable for
> Germany and I frankly don´t care about the end of security cause all
> surfing and other network access I will do from the Linux box and I only
> run the VM behind a firewall).
>
>
> And thus I try the balance dance again:

ITEM: Balance... it doesn't do what you think it does... 8-)

"Balancing" is something you should almost never need to do. It is only 
for cases of changing geometry (adding disks, switching RAID levels, 
etc.) of for cases when you've radically changed allocation behaviors 
(like you decided to remove all your VM's or you've decided to remove a 
mail spool directory full of thousands of tiny files).

People run balance all the time because they think they should. They are 
_usually_ incorrect in that belief.

>
> merkaba:~> btrfs balance start -dusage=5 -musage=5 /home
> ERROR: error during balancing '/home' - No space left on device

ITEM: Running out of space during a balance is not running out of space 
for files. BTRFS has two layers of allocation. That is, there are two 
levels of abstraction where "no space" can occur.

The first level of allocation is the "making more BTRFS structures out 
of raw device space".

The second level is "allocating space for files inside of existing BTRFS 
structures".

Balance is the operation of relocating the BTRFS structures and 
attempting to increase their order (conincidentally) while doing that. 
So, for instance, "reocating block group some_number_here" requires 
finding an unallocated expanse of disk, creating a new/empty block group 
there of the current relevant block group size (typically data=1G or 
metadata=256M if you didn't override these settings while making the 
filesystem). You can _easily_ end up lacking a 1G contiguous expanse of 
raw allocation space on a nearly-full filesystem.

NOTE :: This does _not_ happen with other filesystems like EXT4 because 
building those filesystems creates a static filesystem-level allocation. 
That is 100% of the disk that can be controlled by EXT4 (etc) is 
allocated and initialized at initial creation time (or first mount in 
the case of EXT4).

BTRFS is intentionally different because it wants to be able to adapt as 
your usage changes. If you first make millions of tiny files then you 
will have a lot of metadata extents and virtually no data extents. If 
you erase a lot of those and then start making large files the metadata 
will tend to go away and then data extents will be created.

Being a chaotic system, you can get into some corner cases that suck, 
but in terms of natural evolution it has more benefits than drawbacks.


> There may be more info in syslog - try dmesg | tail
> merkaba:~#1> btrfs balance start -dusage=5 -musage=5 /home
> ERROR: error during balancing '/home' - No space left on device
> There may be more info in syslog - try dmesg | tail
> merkaba:~#1> btrfs balance start -dusage=5 /home
>
> .... losts deleted for brevity ....
>
> So I am rebalancing everything basically, without need I bet, so causing
> more churn to SSDs than is needed.

Correct, though churn isn't really the issue.

> Otherwise alternative would be to make BTRFS larger I bet.

Correct.

>
>
> Well this is still not what I would consider stable. So I will still

Not a question of stability.

See, dong a balance is like doing a sliding block puzzle. If there isn't 
enough room to slide the blocks around then the blocks will not slide 
around. You are just out of space and that results in "out of space" 
returns. This is not even an error, just a fact.

http://en.wikipedia.org/wiki/15_puzzle

Meditate on the above link. Then ask yourself what happens if you put in 
the number 16. 8-)

The below recomendation is incorrect...

> recommend: If you want to use BTRFS on a server and estimate 25 GiB of
> usage, make drive at least 50GiB big or even 100GiB to be on the safe
> side. Like I recommended for SLES 11 SP 2/3 BTRFS deployments – but
> hey, there say meanwhile "don´t" as in "just don´t use it at all and use SLES
> 12 instead, cause BTRFS with 3.0 kernel with a ton of snapper snapshots
> is really not asking for anything even near to production or enterprise
> reliability" (if you need proof, I think I still have a snapshot of a SLES
> 11 SP3 VM that broke over night due to me having installed an LDAP server
> for preparing some training slides). Even 3.12 kernel seems daring regarding
> BTRFS, unless SUSE actively backports fixes.
>
>
> In kernel log the failed attempts look like this:
  Already covered.
>
> [  209.783437] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
> [  210.116416] BTRFS info (device dm-3): relocating block group 501238202368 flags 17
> My expection for a *stable* and *production quality* filesystem would be:
>
> I never ever get hangs with one kworker running on 100% of one Sandybridge
> core *for minutes* in a production filesystem and thats about it.

Now this is one of several other issues.

ITEM: An SSD plus a good fast controller and default system virtual 
memory and disk scheduler activities can completely bog a system down. 
You can get into a mode where the system begins doing synchronous writes 
of vast expanses of dirty cache. The SSD is so fast that there is 
effectively zero "wait for IO time" and the IO subsystem is effectively 
locked or just plain busy.

Look at /proc/sys/vm/dirty_background_ratio which is probably set to 10% 
of system ram.

You may need/want to change this number to something closer to 4. That's 
not a hard suggestion. Some reading and analysis will be needed to find 
the best possible tuning for an advanced system.

>
> Especially for a filesystem that claims to still have a good amount of free
> space:
>
> merkaba:~> LANG=C df -hT /home
> Filesystem             Type   Size  Used Avail Use% Mounted on
> /dev/mapper/msata-home btrfs  160G  146G   25G  86% /home

It does have plenty of free space at the file-storage level. (Which is 
not the "balance" level where raw disk is converted into file system 
"data" or "metadata" extents.)

>
> (yeah, these don´t add up, I account this to compression, but hey, who knows)

No need to "account for" compression.

They add up fine, in the sense that they are separate domains for space 
and so are not intended to be taken together. You will notice that you 
are not getting "out of space" errors for actually creating/appending files.

>
>
> In kernel log I have things like this, but some earlier time and these I have
> not yet perceived as hangs:
>
> Dec 23 23:33:26 merkaba kernel: [23040.621678] ------------[ cut here ]------------
> Dec 23 23:33:26 merkaba kernel: [23040.621792] WARNING: CPU: 3 PID: 308 at fs/btrfs/delayed-inode.c:1410 btrfs_assert_delayed_root_empt
> y+0x2d/0x2f [btrfs]()
> Dec 23 23:33:26 merkaba kernel: [23040.621796] Modules linked in: mmc_block ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c snd
> _usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device hid_generic hid_pl ff_memless usbhid hid nls_utf8 nls_cp437 vfat fat uas usb_stor
> age bnep bluetooth binfmt_misc cpufreq_userspace cpufreq_stats pci_stub cpufreq_powersave vboxpci(O) cpufreq_conservative vboxnetadp(O)
>   vboxnetflt(O) vboxdrv(O) ext4 crc16 mbcache jbd2 intel_rapl x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm crct10dif_pclmul crc32
> _pclmul ghash_clmulni_intel snd_hda_codec_hdmi iwldvm aesni_intel snd_hda_codec_conexant mac80211 aes_x86_64 snd_hda_codec_generic lrw
> gf128mul glue_helper ablk_helper cryptd psmouse snd_hda_intel serio_raw iwlwifi pcspkr lpc_ich snd_hda_controller i2c_i801 mfd_core snd
> _hda_codec snd_hwdep cfg80211 snd_pcm snd_timer shpchp thinkpad_acpi nvram snd soundcore rfkill battery ac tpm_tis tpm processor evdev
> joydev sbs sbshc coretemp hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 fuse ecryptfs autofs4 md_mod btrfs xor raid6_pq microc
> ode dm_mirror dm_region_hash dm_log dm_mod sg sr_mod sd_mod cdrom crc32c_intel ahci firewire_ohci libahci sata_sil24 e1000e libata ptp
> sdhci_pci ehci_pci sdhci firewire_core ehci_hcd crc_itu_t pps_core mmc_core scsi_mod usbcore usb_common thermal
> Dec 23 23:33:26 merkaba kernel: [23040.621978] CPU: 3 PID: 308 Comm: btrfs-transacti Tainted: G        W  O   3.18.0-tp520 #14
> Dec 23 23:33:26 merkaba kernel: [23040.621982] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
> Dec 23 23:33:26 merkaba kernel: [23040.621985]  0000000000000009 ffff8804044c7d88 ffffffff814a516e 0000000080000000
> Dec 23 23:33:26 merkaba kernel: [23040.621992]  0000000000000000 ffff8804044c7dc8 ffffffff8103f83e ffff8804044c7db8
> Dec 23 23:33:26 merkaba kernel: [23040.621999]  ffffffffc04bd5a1 ffff880037590800 ffff8800a599c320 0000000000000000
> Dec 23 23:33:26 merkaba kernel: [23040.622006] Call Trace:
> Dec 23 23:33:26 merkaba kernel: [23040.622026]  [<ffffffff814a516e>] dump_stack+0x4f/0x7c
> Dec 23 23:33:26 merkaba kernel: [23040.622034]  [<ffffffff8103f83e>] warn_slowpath_common+0x7c/0x96
> Dec 23 23:33:26 merkaba kernel: [23040.622104]  [<ffffffffc04bd5a1>] ? btrfs_assert_delayed_root_empty+0x2d/0x2f [btrfs]
> Dec 23 23:33:26 merkaba kernel: [23040.622111]  [<ffffffff8103f8ec>] warn_slowpath_null+0x15/0x17
> Dec 23 23:33:26 merkaba kernel: [23040.622164]  [<ffffffffc04bd5a1>] btrfs_assert_delayed_root_empty+0x2d/0x2f [btrfs]
> Dec 23 23:33:26 merkaba kernel: [23040.622211]  [<ffffffffc047a830>] btrfs_commit_transaction+0x394/0x8bc [btrfs]
> Dec 23 23:33:26 merkaba kernel: [23040.622254]  [<ffffffffc0476dd5>] transaction_kthread+0xf9/0x1af [btrfs]
> Dec 23 23:33:26 merkaba kernel: [23040.622295]  [<ffffffffc0476cdc>] ? btrfs_cleanup_transaction+0x43a/0x43a [btrfs]
> Dec 23 23:33:26 merkaba kernel: [23040.622305]  [<ffffffff8105697c>] kthread+0xb2/0xba
> Dec 23 23:33:26 merkaba kernel: [23040.622312]  [<ffffffff814a0000>] ? dcbnl_newmsg+0x14/0xa8
> Dec 23 23:33:26 merkaba kernel: [23040.622317]  [<ffffffff810568ca>] ? __kthread_parkme+0x62/0x62
> Dec 23 23:33:26 merkaba kernel: [23040.622324]  [<ffffffff814a9f6c>] ret_from_fork+0x7c/0xb0
> Dec 23 23:33:26 merkaba kernel: [23040.622329]  [<ffffffff810568ca>] ? __kthread_parkme+0x62/0x62
> Dec 23 23:33:26 merkaba kernel: [23040.622334] ---[ end trace 90db5b1c7067cf1d ]---
> Dec 23 23:33:56 merkaba kernel: [23070.671999] ------------[ cut here ]------------

Not sure about either of these, they _could_ be previous unrelated bugs 
that are now fixed bugs, since you say they've stopped happening.

> Dec 23 23:33:56 merkaba kernel: [23070.671999] ------------[ cut here ]------------
> Dec 23 23:33:56 merkaba kernel: [23070.672064] WARNING: CPU: 3 PID: 308 at fs/btrfs/delayed-inode.c:1410 btrfs_assert_delayed_root_empt
> y+0x2d/0x2f [btrfs]()
> Dec 23 23:33:56 merkaba kernel: [23070.672067] Modules linked in: mmc_block ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device hid_generic hid_pl ff_memless usbhid hid nls_utf8 nls_cp437 vfat fat uas usb_storage bnep bluetooth binfmt_misc cpufreq_userspace cpufreq_stats pci_stub cpufreq_powersave vboxpci(O) cpufreq_conservative vboxnetadp(O) vboxnetflt(O) vboxdrv(O) ext4 crc16 mbcache jbd2 intel_rapl x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_codec_hdmi iwldvm aesni_intel snd_hda_codec_conexant mac80211 aes_x86_64 snd_hda_codec_generic lrw gf128mul glue_helper ablk_helper cryptd psmouse snd_hda_intel serio_raw iwlwifi pcspkr lpc_ich snd_hda_controller i2c_i801 mfd_core snd_hda_codec snd_hwdep cfg80211 snd_pcm snd_timer shpchp thinkpad_acpi nvram snd soundcore rfkill battery ac tpm_tis tpm processor evdev joydev sbs sbshc coretemp hdaps(O) tp_smapi(O) think
pad_ec(O) loop firewire_sbp2 fuse ecryptfs autofs4 md_mod btrfs xor raid6_pq microcode dm_mirror dm_region_hash dm_log dm_mod sg sr_mod sd_mod cdrom crc32c_intel ahci firewire_ohci libahci sata_sil24 e1000e libata ptp sdhci_pci ehci_pci sdhci firewire_core ehci_hcd crc_itu_t pps_core mmc_core scsi_mod usbcore usb_common thermal
> Dec 23 23:33:56 merkaba kernel: [23070.672193] CPU: 3 PID: 308 Comm: btrfs-transacti Tainted: G        W  O   3.18.0-tp520 #14
> Dec 23 23:33:56 merkaba kernel: [23070.672196] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
> Dec 23 23:33:56 merkaba kernel: [23070.672200]  0000000000000009 ffff8804044c7d88 ffffffff814a516e 0000000080000000
> Dec 23 23:33:56 merkaba kernel: [23070.672205]  0000000000000000 ffff8804044c7dc8 ffffffff8103f83e ffff8804044c7db8
> Dec 23 23:33:56 merkaba kernel: [23070.672209]  ffffffffc04bd5a1 ffff880037590800 ffff8802cd6e50a0 0000000000000000
> Dec 23 23:33:56 merkaba kernel: [23070.672214] Call Trace:
> Dec 23 23:33:56 merkaba kernel: [23070.672222]  [<ffffffff814a516e>] dump_stack+0x4f/0x7c
> Dec 23 23:33:56 merkaba kernel: [23070.672229]  [<ffffffff8103f83e>] warn_slowpath_common+0x7c/0x96
> Dec 23 23:33:56 merkaba kernel: [23070.672264]  [<ffffffffc04bd5a1>] ? btrfs_assert_delayed_root_empty+0x2d/0x2f [btrfs]
> Dec 23 23:33:56 merkaba kernel: [23070.672270]  [<ffffffff8103f8ec>] warn_slowpath_null+0x15/0x17
> Dec 23 23:33:56 merkaba kernel: [23070.672301]  [<ffffffffc04bd5a1>] btrfs_assert_delayed_root_empty+0x2d/0x2f [btrfs]
> Dec 23 23:33:56 merkaba kernel: [23070.672330]  [<ffffffffc047a830>] btrfs_commit_transaction+0x394/0x8bc [btrfs]
> Dec 23 23:33:56 merkaba kernel: [23070.672357]  [<ffffffffc0476dd5>] transaction_kthread+0xf9/0x1af [btrfs]
> Dec 23 23:33:56 merkaba kernel: [23070.672383]  [<ffffffffc0476cdc>] ? btrfs_cleanup_transaction+0x43a/0x43a [btrfs]
> Dec 23 23:33:56 merkaba kernel: [23070.672389]  [<ffffffff8105697c>] kthread+0xb2/0xba
> Dec 23 23:33:56 merkaba kernel: [23070.672395]  [<ffffffff814a0000>] ? dcbnl_newmsg+0x14/0xa8
> Dec 23 23:33:56 merkaba kernel: [23070.672399]  [<ffffffff810568ca>] ? __kthread_parkme+0x62/0x62
> Dec 23 23:33:56 merkaba kernel: [23070.672405]  [<ffffffff814a9f6c>] ret_from_fork+0x7c/0xb0
> Dec 23 23:33:56 merkaba kernel: [23070.672409]  [<ffffffff810568ca>] ? __kthread_parkme+0x62/0x62
> Dec 23 23:33:56 merkaba kernel: [23070.672412] ---[ end trace 90db5b1c7067cf1e ]---
> Dec 23 23:34:26 merkaba kernel: [23100.709530] ------------[ cut here ]------------
>
>
> The recent hangings today are not in the log, I was upset enough to
> forcefully switch of the machine. Tax returns are not my all time favorite,
> but tax returns with hanging filesystems is no fun at all.
>
>
> I will upgrade to 3.19 with 3.19-rc2.
>
> Lets see what this balance will do.
>
> It currently is here:
>
> merkaba:~> btrfs balance status /home
> Balance on '/home' is running
> 32 out of about 164 chunks balanced (53 considered),  80% left
>
> merkaba:~> btrfs fi df /home
> Data, RAID1: total=154.97GiB, used=142.10GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=5.00GiB, used=3.33GiB
> GlobalReserve, single: total=512.00MiB, used=254.31MiB
>
>
> So for once, we are told not to balance needlessly, but then in order for
> stable operation I need to balance nonetheless?

Nope. "needing to Balance" just isn't your problem. Being out of space 
for new extents is your problem with the balancing you don't need to do. 
Which is different than your VM update problem. And is also different 
than your bursty, excessive caching problem.

I've also not seen you say you did a btrfsck ever. Does a filesystem 
check come up clean.


> Well lets see how it will improve things. Last time it did. Considerably.
> BTRFS only had these hang problems with 3.15 and 3.16 if trees allocated
> all remaining space. So I expect it to downsize these trees are to there is
> some device space being freed to allocatable again.
>
> Next I will also defrag the Windows VM image just as an additional safety
> net.

Simply copying the file might help you for a while at least. But in the 
long term "too much orderliness" for large files ends up being anti-helpful.

e.g. disk_file.img :: cp disk_file.img new_disk_file.img; rm 
disk_file.img; mv new_disk_file.img disk_file.img;

Turning off Copy-on-write might be helpful. (This will turn off 
compression as well) but it can be anti-helpful too depending on the VM 
and how it's used.

As I learn more about the way BTRFS stores files, particularly deltas to 
files, I come to suspect that the "best" storage model for a VM _might_ 
be exactly the opposite of normal suggestions. (The most wasteful 
possible storage is the Gauss sum of consecutive integers where i=1 and 
n=number of consecutively stored blocks in the file. Ouch. So a file 
that is reasonably segmented is "more efficent".)

With a fast SSD, my research suggests that defragging the disk image is 
bad. No-COW is good if you don't snapshot often, but each snapshot puts 
the file in one-COW which kind-of defeats the No-COW if you do it very 
often.

But as near as I can tell, starting with an "empty" .qcow file and 
growing the system step-wise and _never_ defragging that file tends to 
create a chaotically natural expanse that wont hit these corner cases. 
(Way more analysis needs to be done here for that to be a real answer.)

As I learn more I discover that being overly agressive with balance and 
defrag of large files is the opposite of good. The system seems to want 
to develop a chaotic layout and trying to make it orderly seems to make 
things worse. For very large files like VM images it seems to amplify 
the worst parts.

> Okay, doing something else now as the BTRFS will sort things out hopefully.

To get good natural performance on my (non SSD) system while running 
VM(s) I classify a bunch of the system ram with the moveablecore= kernel 
boot option (about 1/4 to 1/3rd of physical ram) and turn down the dirty 
backround ratio to avoid large synchronous cache flush events.

YMMV.

>
> Ciao,
>
Later.
