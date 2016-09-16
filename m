Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35689 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753480AbcIPUXq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 16:23:46 -0400
Received: by mail-oi0-f44.google.com with SMTP id w11so125257748oia.2
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Sep 2016 13:23:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160916192459.GA13514@coach.home>
References: <20160916192459.GA13514@coach.home>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 16 Sep 2016 14:23:44 -0600
Message-ID: <CAJCQCtQutt6r2Jovr0jEbTk4W6HUaQpbGiipen97TH1C+k055g@mail.gmail.com>
Subject: Re: Post ext3 conversion problems
To: Sean Greenslade <sean@seangreenslade.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2016 at 1:25 PM, Sean Greenslade
<sean@seangreenslade.com> wrote:
> Hi, all. I've been playing around with an old laptop of mine, and I
> figured I'd use it as a learning / bugfinding opportunity. Its /home
> partition was originally ext3. I have a full partition image of this
> drive as a backup, so I can do (and have done) potentially destructive
> things. The system disk is a ~6 year old SSD.
>
> To start, I rebooted to a livedisk (Arch, kernel 4.7.2 w/progs 4.7.1)
> and ran a simple btrfs-convert on it. After patching up the fstab and
> rebooting, everything seemed fine. I deleted the recovery subvol, ran a
> full balance, ran a full defrag, and rebooted again. I then decided to
> try (as an experiment) using DUP mode for data and metadata. I ran that
> balance without issue, then started using the machine. Sometime later, I
> got the following remount ro:
>
> [ 7316.764235] ------------[ cut here ]------------
> [ 7316.764292] WARNING: CPU: 2 PID: 14196 at fs/btrfs/inode.c:2954 btrfs_finish_ordered_io+0x6bc/0x6d0 [btrfs]
> [ 7316.764297] BTRFS: Transaction aborted (error -95)
> [ 7316.764301] Modules linked in: fuse sha256_ssse3 sha256_generic hmac drbg ansi_cprng ctr ccm joydev mousedev uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core videodev media crc32c_generic iTCO_wdt btrfs iTCO_vendor_support arc4 xor ath9k raid6_pq ath9k_common ath9k_hw ath mac80211 snd_hda_codec_realtek snd_hda_codec_generic psmouse input_leds coretemp snd_hda_intel led_class pcspkr snd_hda_codec cfg80211 snd_hwdep snd_hda_core snd_pcm lpc_ich snd_timer atl1c rfkill snd soundcore shpchp intel_agp wmi thermal fjes battery evdev ac tpm_tis mac_hid tpm sch_fq_codel vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O) vboxdrv(O) loop sg acpi_cpufreq ip_tables x_tables ext4 crc16 jbd2 mbcache sd_mod serio_raw atkbd libps2 ahci libahci uhci_hcd libata scsi_mod ehci_pci ehci_hcd usbcore
> [ 7316.764434]  usb_common i8042 serio i915 video button intel_gtt i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm
> [ 7316.764462] CPU: 2 PID: 14196 Comm: kworker/u8:11 Tainted: G           O    4.7.3-5-ck #1
> [ 7316.764467] Hardware name: ASUSTeK Computer INC. 1015PEM/1015PE, BIOS 0903    11/08/2010
> [ 7316.764507] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
> [ 7316.764513]  0000000000000286 000000006101f47d ffff8800230dbc78 ffffffff812f0215
> [ 7316.764522]  ffff8800230dbcc8 0000000000000000 ffff8800230dbcb8 ffffffff8107ae6f
> [ 7316.764530]  00000b8a00000035 ffff88007791afa8 ffff8800751d9000 ffff880014101d40
> [ 7316.764538] Call Trace:
> [ 7316.764551]  [<ffffffff812f0215>] dump_stack+0x63/0x8e
> [ 7316.764560]  [<ffffffff8107ae6f>] __warn+0xcf/0xf0
> [ 7316.764567]  [<ffffffff8107aef1>] warn_slowpath_fmt+0x61/0x80
> [ 7316.764605]  [<ffffffffa07aa362>] ? unpin_extent_cache+0xa2/0xf0 [btrfs]
> [ 7316.764640]  [<ffffffffa07628e6>] ? btrfs_free_path+0x26/0x30 [btrfs]
> [ 7316.764677]  [<ffffffffa079aaac>] btrfs_finish_ordered_io+0x6bc/0x6d0 [btrfs]
> [ 7316.764715]  [<ffffffffa079adc5>] finish_ordered_fn+0x15/0x20 [btrfs]
> [ 7316.764753]  [<ffffffffa07c5f8e>] btrfs_scrubparity_helper+0x7e/0x360 [btrfs]
> [ 7316.764791]  [<ffffffffa07c62fe>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
> [ 7316.764799]  [<ffffffff810949bd>] process_one_work+0x1ed/0x490
> [ 7316.764806]  [<ffffffff81094ca9>] worker_thread+0x49/0x500
> [ 7316.764813]  [<ffffffff81094c60>] ? process_one_work+0x490/0x490
> [ 7316.764820]  [<ffffffff8109ac3a>] kthread+0xda/0xf0
> [ 7316.764830]  [<ffffffff815c553f>] ret_from_fork+0x1f/0x40
> [ 7316.764838]  [<ffffffff8109ab60>] ? kthread_worker_fn+0x170/0x170
> [ 7316.764843] ---[ end trace 90f54effc5e294b0 ]---
> [ 7316.764851] BTRFS: error (device sda2) in btrfs_finish_ordered_io:2954: errno=-95 unknown
> [ 7316.764859] BTRFS info (device sda2): forced readonly
> [ 7316.765396] pending csums is 9437184
>
> After seeing this, I decided to attempt a repair (confident that I could
> restore from backup if it failed). At the time, I was unaware of the
> issues with progs 4.7.1, so when I ran the check and saw all the
> incorrect backrefs messages, I figured that was my problem and ran the
> --repair. Of course, this didn't make the messages go away on subsequent
> checks, so I looked further and found this bug:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=155791
>
> I updated progs to 4.7.2 and re-ran the --repair (I didn't save any of
> the logs from these, unfortunately). The repair seemed to work (I also
> used --init-extent-tree), as current checks don't report any errors.
>
> The system boots and mounts the FS just fine. I can read from it all
> day, scrubs complete without failure, but just using the system for a
> while will eventually trigger the same "Transaction aborted (error -95)"
> error.
>
> I realize this is something of a mess, and that I was less than
> methodical with my actions so far. Given that I have a full backup that
> can be restored if need be (and I certainly could try running the
> convert again), what is my best course of action?


Not a mess, I think it's a good bug report. I think Qu and David know
more about the latest iteration of the convert code. If you can wait
until next week at least to see if they have questions that'd be best.
If you need to get access to the computer sooner than later I suggest
btrfs-image -c9 -t4 -s to make a filename sanitized copy of the
filesystem metadata for them to look at, just in case. They might be
able to figure out the problem just from the stack trace, but better
to have the image before blowing away the file system, just in case
they want it.

-- 
Chris Murphy
