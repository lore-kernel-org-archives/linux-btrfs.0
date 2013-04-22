Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36926 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3DVPZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 11:25:51 -0400
Received: by mail-lb0-f170.google.com with SMTP id 13so2621539lba.1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 08:25:49 -0700 (PDT)
Received: by mail-la0-f47.google.com with SMTP id ez20so1730929lab.34
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 08:25:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201304221601.27430.Martin@lichtvoll.de>
References: <5157386.Pre7jntDtG@merkaba> <CAEzrpqf1_FU2p_A1c7fcefz4yxw-H3b=i5UemJtf=UtN=SjyYQ@mail.gmail.com>
 <201304221600.02454.Martin@lichtvoll.de> <201304221601.27430.Martin@lichtvoll.de>
From: Dan van der Ster <dan@vanderster.com>
Date: Mon, 22 Apr 2013 17:25:07 +0200
Message-ID: <CABZ+qq=h4YpU9=uFbLJ3XGwz9Y+q8o1DRX_JHtWufkNWN=PB_g@mail.gmail.com>
Subject: Re: btrfs scrub gives unable to find logical $hugenum len 16384
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Josef Bacik <jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quick question, do you agree that the traceback in the P.S. is the
same BUG? I hit this during a scrub yesterday (with 3.8.7), though
re-scrubbing succeeded.
Cheers, Dan

Apr 21 09:31:44 dvanders-webserver kernel: [505979.695932] btrfs:
unable to find logical 8653227934915758829 len 16384
Apr 21 09:31:44 dvanders-webserver kernel: [505979.695977]
------------[ cut here ]------------
Apr 21 09:31:44 dvanders-webserver kernel: [505979.696017] Kernel BUG
at ffffffffa00af3d4 [verbose debug info unavailable]
Apr 21 09:31:44 dvanders-webserver kernel: [505979.696058] invalid
opcode: 0000 [#1] SMP
Apr 21 09:31:44 dvanders-webserver kernel: [505979.696099] Modules
linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2
ir_lirc_codec lirc_de
v ir_mce_kbd_decoder ir_sanyo_decoder ir_sony_decoder ir_jvc_decoder
ir_rc6_decoder ir_rc5_decoder ir_nec_decoder snd_hda_codec_hdmi bnep
snd_hda_intel rfcomm
rc_technisat_usb2 stv6110x bluetooth snd_hda_codec snd_hwdep
dvb_usb_technisat_usb2 stv090x dvb_usb dvb_core snd_pcm asix rc_core
usbnet snd_seq_midi snd_rawmi
di radeon coretemp kvm_intel snd_seq_midi_event kvm snd_seq ttm
serio_raw drm_kms_helper drm snd_timer snd_seq_device mac_hid snd
ppdev soundcore snd_page_allo
c i2c_algo_bit parport_pc lpc_ich microcode nfsd nfs_acl auth_rpcgss
nfs fscache lockd lp sunrpc parport btrfs zlib_deflate libcrc32c
firewire_ohci firewire_co
re crc_itu_t sky2 ahci libahci
Apr 21 09:31:44 dvanders-webserver kernel: [505979.696636] CPU 0
Apr 21 09:31:44 dvanders-webserver kernel: [505979.696650] Pid: 25622,
comm: btrfs-endio-met Not tainted 3.8.7-030807-generic #201304121430
Shuttle Inc SP35/FP
35
Apr 21 09:31:44 dvanders-webserver kernel: [505979.698035] RIP:
0010:[<ffffffffa00af3d4>]  [<ffffffffa00af3d4>]
__btrfs_map_block+0xbc4/0xbf0 [btrfs]
Apr 21 09:31:44 dvanders-webserver kernel: [505979.699456] RSP:
0018:ffff88008087fa88  EFLAGS: 00010296
Apr 21 09:31:44 dvanders-webserver kernel: [505979.700838] RAX:
000000000000003b RBX: ffff880230e7c120 RCX: 000000000000001e
Apr 21 09:31:44 dvanders-webserver kernel: [505979.702234] RDX:
0000000000003934 RSI: 0000000000000082 RDI: 0000000000000246
Apr 21 09:31:44 dvanders-webserver kernel: [505979.703634] RBP:
ffff88008087fb48 R08: 0000000000000000 R09: 0000000000000001
Apr 21 09:31:44 dvanders-webserver kernel: [505979.705032] R10:
00000000000005fb R11: 00000000000005fa R12: ffff8801f627ef00
Apr 21 09:31:44 dvanders-webserver kernel: [505979.706421] R13:
ffff880230e7c000 R14: ffff88008087fba0 R15: 781670f5c5240aed
Apr 21 09:31:44 dvanders-webserver kernel: [505979.707817] FS:
0000000000000000(0000) GS:ffff88023fc00000(0000)
knlGS:0000000000000000
Apr 21 09:31:44 dvanders-webserver kernel: [505979.709247] CS:  0010
DS: 0000 ES: 0000 CR0: 000000008005003b
Apr 21 09:31:44 dvanders-webserver kernel: [505979.710685] CR2:
00007f9071d44010 CR3: 000000017bfe4000 CR4: 00000000000407f0
Apr 21 09:31:44 dvanders-webserver kernel: [505979.712187] DR0:
0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Apr 21 09:31:44 dvanders-webserver kernel: [505979.713661] DR3:
0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr 21 09:31:44 dvanders-webserver kernel: [505979.714746] Process
btrfs-endio-met (pid: 25622, threadinfo ffff88008087e000, task
ffff880099591740)
Apr 21 09:31:44 dvanders-webserver kernel: [505979.715846] Stack:
Apr 21 09:31:44 dvanders-webserver kernel: [505979.716936]
ffffffff8135532f 0000000000000040 ffff88008087faf8 ffffffff811861a2
Apr 21 09:31:44 dvanders-webserver kernel: [505979.718043]
00000000da5ecf80 ffffffff8135532f 0000000000000230 0000000000000238
Apr 21 09:31:44 dvanders-webserver kernel: [505979.719149]
ffff88008087fb98 00000000da5cab30 ffff880200000000 ffff8801f627e080
Apr 21 09:31:44 dvanders-webserver kernel: [505979.720246] Call Trace:
Apr 21 09:31:44 dvanders-webserver kernel: [505979.721311]
[<ffffffff8135532f>] ? radix_tree_node_alloc+0x1f/0x60
Apr 21 09:31:44 dvanders-webserver kernel: [505979.722362]
[<ffffffff811861a2>] ? kmem_cache_alloc+0x132/0x140
Apr 21 09:31:44 dvanders-webserver kernel: [505979.723420]
[<ffffffff8135532f>] ? radix_tree_node_alloc+0x1f/0x60
Apr 21 09:31:44 dvanders-webserver kernel: [505979.724493]
[<ffffffffa00e24ef>] ? reada_find_extent+0xbf/0x530 [btrfs]
Apr 21 09:31:44 dvanders-webserver kernel: [505979.725559]
[<ffffffffa00b546e>] btrfs_map_block+0xe/0x10 [btrfs]
Apr 21 09:31:44 dvanders-webserver kernel: [505979.726625]
[<ffffffffa00e2575>] reada_find_extent+0x145/0x530 [btrfs]
Apr 21 09:31:44 dvanders-webserver kernel: [505979.727682]
[<ffffffffa00e2992>] reada_add_block+0x32/0xf0 [btrfs]
Apr 21 09:31:44 dvanders-webserver kernel: [505979.728743]
[<ffffffffa00e2ce6>] __readahead_hook.isra.4+0x296/0x410 [btrfs]
...



On Mon, Apr 22, 2013 at 4:01 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Am Montag, 22. April 2013 schrieb Martin Steigerwald:
>> Am Samstag, 20. April 2013 schrieb Josef Bacik:
>> > So I found your bug on the plane ride, as soon as I get home I'll email
>> > it.  Thanks,
>>
>> Did you get home yet?
>>
>> I would like to know the impact of the bug. I am running from a
>> restauration of a backup via rsync which went without any errors, but
>> still.
>>
>> I also still have the backup dd image available for testing.
>
> Scratch this, I think this is:
>
> [PATCH] Btrfs: don't call readahead hook until we have read the entire eb
>
> Noticed it after writing above mail.
>
> Ciao,
> Martin
>
>>
>> Thanks,
>> Martin
>>
>> > Josef
>> >
>> > On Apr 20, 2013 4:43 AM, "Martin Steigerwald" <Martin@lichtvoll.de>
> wrote:
>> > > Am Samstag, 20. April 2013 schrieb Josef Bacik:
>> > > > On Fri, Apr 19, 2013 at 03:15:30AM -0600, Martin Steigerwald wrote:
>> > > > > Am Dienstag, 16. April 2013 schrieb Martin Steigerwald:
>> > > > > > On Saturday 13 April 2013 17:48:31 Martin Steigerwald wrote:
>> > > > > > > Hi!
>> > > > > > >
>> > > > > > > Please answer soon whether it would be a good idea to replay
>> > > > > > > a backup right now as I am leaving to Berlin tomorrow for a
>> > > > > > > week without my backup drive with me. Well, I made space on
>> > > > > > > an external 2,5 inch drive, that I can take with me. I am
>> > > > > > > taking that one with me, after having made sure it has a
>> > > > > > > consistent backup. :)
>> > > > > >
>> > > > > > Ping.
>> > > > > >
>> > > > > > Any hints on this one? I am going to recreate the filesystem
>> > > > > > next weekend at latest.
>> > > > > >
>> > > > > > I did not see any I/O or BTRFS errors in logs so far, so
>> > > > > > filesystem appears to be good.
>> > > > >
>> > > > > Last chance to let me dig out some more information about this.
>> > > > >
>> > > > > Even with lack of any other oddities I am not going to tolerate a
>> > > > > non scrubbing BTRFS filesystem for longer than a week and will
>> > > > > redo it during the weekend.
>> > > >
>> > > > Can you get a btrfs-image of the file system as it is and upload it
>> > > > somewhere for me to pull down so I can try and reproduce?  Thanks,
>> > >
>> > > Hmmm, this doesn´t seem to work:
>> > >
>> > > merkaba:~#134> btrfs-image -c9 -t4 /dev/merkaba/home
>> > > /mnt/zeit/home.img checksum verify failed on 65536 wanted E79F04C2
>> > > found 73
>> > > checksum verify failed on 65536 wanted E79F04C2 found 73
>> > > Csum didn't match
>> > > btrfs-image: btrfs-image.c:394: flush_pending: Assertion `!(!eb)'
>> > > failed. zsh: abort      btrfs-image -c9 -t4 /dev/merkaba/home
>> > > /mnt/zeit/home.img merkaba:~#134> btrfs-image /dev/merkaba/home
>> > > /mnt/zeit/home.img checksum verify failed on 65536 wanted E79F04C2
>> > > found 73
>> > > checksum verify failed on 65536 wanted E79F04C2 found 73
>> > > Csum didn't match
>> > > btrfs-image: btrfs-image.c:394: flush_pending: Assertion `!(!eb)'
>> > > failed. zsh: abort      btrfs-image /dev/merkaba/home
>> > > /mnt/zeit/home.img merkaba:~#134>
>> > >
>> > >
>> > > merkaba:~> ls -l /mnt/zeit/home.img
>> > > -rw-r--r-- 1 root root 0 Apr 20 10:32 /mnt/zeit/home.img
>> > >
>> > >
>> > > In order to be able to restore to a sane setup, I will do the
>> > > following now:
>> > >
>> > > - make another rsync backup without deleting older backup snapshots
>> > > in case the BTRFS filesystem got corrupted and cannot retrieve some
>> > > files which seems
>> > > so from above and btrfs-debug-tree outputs.
>> > >
>> > > - make a dd backup of the home partition to my backup harddisk for
>> > > further investigation
>> > >
>> > > - recreate the home filesystem as BTRFS or Ext4/XFS. But I think I
>> > > will try BTRFS again, but I will put all the KDE Akonadi / Nepomuk
>> > > related stuff onto
>> > > another Ext4 partition as asked by a KDE developer to see whether the
>> > > mail data loss issue is somehow related to using BTRFS, cause the
>> > > developer as well as the main KMail developer also use KMail 2 with
>> > > POP3 and they have no
>> > > data losses.
>> > >
>> > >
>> > > I can try some stuff on the dd image then, maybe its still possible
>> > > to get an
>> > > btrfs-image somehow.
>> > >
>> > > Thanks,
>> > > --
>> > > Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
>> > > GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
>> > > --
>> > > To unsubscribe from this list: send the line "unsubscribe
>> > > linux-btrfs" in the body of a message to majordomo@vger.kernel.org
>> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
