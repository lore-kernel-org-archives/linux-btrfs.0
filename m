Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38278 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbcD0CoI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 22:44:08 -0400
Received: by mail-wm0-f41.google.com with SMTP id u206so29356407wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 19:44:06 -0700 (PDT)
Received: from [192.168.1.85] (77-173-215-182.ip.telfort.nl. [77.173.215.182])
        by smtp.googlemail.com with ESMTPSA id ry15sm1520186wjb.19.2016.04.26.19.44.04
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 26 Apr 2016 19:44:04 -0700 (PDT)
Subject: Re: Kernel crash if both devices in raid1 are failing
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <570FFDFE.3050305@gmail.com> <571419C7.6070709@gmail.com>
 <20160421034524.GA26182@localhost.localdomain> <571DC34A.50509@gmail.com>
From: Dmitry Katsubo <dmitry.katsubo@gmail.com>
Message-ID: <57202777.3010402@gmail.com>
Date: Wed, 27 Apr 2016 04:44:07 +0200
MIME-Version: 1.0
In-Reply-To: <571DC34A.50509@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030807040800080005080508"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030807040800080005080508
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2016-04-25 09:12, Dmitry Katsubo wrote:
> I have run "btrfs check /dev/sda" two times. One time it has completed
> OK, actually showing only one error. The 2nd time it has shown many messages
> 
> "parent transid verify failed on NNN wanted AAA found BBB"
> 
> and then asserted :) But I think the 2nd run is not representative as I have
> gracefully removed one drive from btrfs array to build a new array. The
> "btrfs device remove" completed successfully, but it might have written some
> metadata to the remaining drives, which perhaps was not synchronized
> correctly.
> 
> What I am going to do next is to recompile btrfs-tools so that "-i" CLI option
> applies "(y)" to all questions and run "btrfs restore" again. Hopefully it can
> handle transid mismatch correctly...

OK, I have recompiled btrfs with necessary fix (attached). It allowed me to capture
"btrfs restore" output because due to reads from console it was not possible, even
with attempts like this:

while true; do echo y; done | btrfs restore -voxmSi /dev/sda /mnt/backup 2>&1 | tee btrfs_restore

For the matter of experiment I have upgraded kernel to 4.4.6 and it still crashes
on problematic file:

# cat /mnt/tmp/file > /dev/null
[   11.432059] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   11.436665] ata3.00: BMDMA stat 0x25
[   11.441301] ata3.00: failed command: READ DMA
[   11.479570] ata3.00: cmd c8/00:20:40:ec:f3/00:00:00:00:00/e3 tag 0 dma 16384 in
[   11.479664]          res 51/40:1e:42:ec:f3/00:00:00:00:00/e3 Emask 0x9 (media error)
[   11.619086] ata3.00: status: { DRDY ERR }
[   11.619126] ata3.00: error: { UNC }
[   11.625750] blk_update_request: I/O error, dev sda, sector 66317378
[   11.625779] NOHZ: local_softirq_pending 40
[   70.969876] ------------[ cut here ]------------
[   70.969879] kernel BUG at /build/linux-SBJFwR/linux-4.4.6/debian/build/source_rt/fs/btrfs/volumes.c:5509!
[   70.969885] invalid opcode: 0000 [#1] PREEMPT SMP 
[   70.969954] Modules linked in: netconsole configfs bridge stp llc arc4 iTCO_wdt iTCO_vendor_support ppdev coretemp pcspkr serio_raw i2c_i801 ath5k ath mac80211 cfg80211 sr9700 evdev rfkill dm9601 usbnet lpc_ich mfd_core mii option usb_wwan usbserial rng_core sg snd_hda_codec_realtek snd_hda_codec_generic i915 snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm acpi_cpufreq snd_timer video 8250_fintek snd drm_kms_helper soundcore tpm_tis drm tpm parport_pc i2c_algo_bit parport shpchp button processor binfmt_misc w83627hf hwmon_vid autofs4 xfs libcrc32c hid_generic usbhid hid crc32c_generic btrfs xor raid6_pq uas usb_storage sd_mod sr_mod cdrom ata_generic firewire_ohci ata_piix libata scsi_mod firewire_core crc_itu_t ehci_pci uhci_hcd ehci_hcd usbcore usb_common e1000e ptp pps_core
[   70.969965] CPU: 0 PID: 114 Comm: kworker/u4:3 Tainted: G        W       4.4.0-1-rt-686-pae #1 Debian 4.4.6-1
[   70.969968] Hardware name: AOpen i945GMx-IF/i945GMx-IF, BIOS i945GMx-IF R1.01 Mar.02.2007 AOpen Inc. 03/02/2007
[   70.970029] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[   70.970032] task: f3eec0c0 ti: f6a76000 task.ti: f6a76000
[   70.970036] EIP: 0060:[<f87506be>] EFLAGS: 00010217 CPU: 0
[   70.970076] EIP is at __btrfs_map_block+0x11be/0x15a0 [btrfs]

Unfortunately I was not able to capture the whole trace, as there seem to be
concurrent problem with netconsole: the whole system hangs at the point above.

P.S. If debian maintainer of btrfs-progs is on the list: Project packaging fails
for me (happens at the very end during binaries installation):

# debuild
...
dpkg-source: info: building btrfs-progs in btrfs-progs_4.4.1-1.1.debian.tar.xz
dpkg-source: info: building btrfs-progs in btrfs-progs_4.4.1-1.1.dsc
 debian/rules build
dh build --parallel
   dh_testdir -O--parallel
   debian/rules override_dh_auto_configure
make[1]: Entering directory '/home/btrfs-progs-4.4.1'
dh_auto_configure -- --bindir=/bin
make[1]: Leaving directory '/home/btrfs-progs-4.4.1'
   dh_auto_build -O--parallel
 fakeroot debian/rules binary
dh binary --parallel
   dh_testroot -O--parallel
   dh_prep -O--parallel
   debian/rules override_dh_auto_install
make[1]: Entering directory '/home/btrfs-progs-4.4.1'
dh_auto_install --destdir=debian/btrfs-progs
# Adding initramfs-tools integration
install -D -m 0755 debian/local/btrfs.hook debian/btrfs-progs/usr/share/initramfs-tools/hooks/btrfs
install -D -m 0755 debian/local/btrfs.local-premount debian/btrfs-progs/usr/share/initramfs-tools/scripts/local-premount/btrfs
make[1]: Leaving directory '/home/btrfs-progs-4.4.1'
   dh_install -O--parallel
/home/btrfs-progs-4.4.1/debian/btrfs-progs.install: 1: /home/btrfs-progs-4.4.1/debian/btrfs-progs.install: btrfs-calc-size: not found
/home/btrfs-progs-4.4.1/debian/btrfs-progs.install: 2: /home/btrfs-progs-4.4.1/debian/btrfs-progs.install: btrfs-select-super: not found
/home/btrfs-progs-4.4.1/debian/btrfs-progs.install: 3: /home/btrfs-progs-4.4.1/debian/btrfs-progs.install: ioctl.h: not found
dh_install: problem reading debian/btrfs-progs.install: 
debian/rules:16: recipe for target 'binary' failed
make: *** [binary] Error 127
dpkg-buildpackage: error: fakeroot debian/rules binary gave error exit status 2
debuild: fatal error at line 1376:
dpkg-buildpackage -rfakeroot -D -us -uc failed


-- 
With best regards,
Dmitry

--------------030807040800080005080508
Content-Type: text/plain; charset=UTF-8;
 name="00_infinite_loops_on_ignore_errors.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="00_infinite_loops_on_ignore_errors.patch"

SW5kZXg6IGJ0cmZzLXByb2dzLTQuNC4xL2NtZHMtcmVzdG9yZS5jCj09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
LS0tIGJ0cmZzLXByb2dzLTQuNC4xLm9yaWcvY21kcy1yZXN0b3JlLmMKKysrIGJ0cmZzLXBy
b2dzLTQuNC4xL2NtZHMtcmVzdG9yZS5jCkBAIC00MzgsNiArNDM4LDkgQEAgc3RhdGljIGVu
dW0gbG9vcF9yZXNwb25zZSBhc2tfdG9fY29udGludQogCWNoYXIgYnVmWzJdOwogCWNoYXIg
KnJldDsKIAorCWlmIChpZ25vcmVfZXJyb3JzKQorCQlyZXR1cm4gTE9PUF9DT05USU5VRTsK
KwogCXByaW50ZigiV2Ugc2VlbSB0byBiZSBsb29waW5nIGEgbG90IG9uICVzLCBkbyB5b3Ug
d2FudCB0byBrZWVwIGdvaW5nICIKIAkgICAgICAgIm9uID8gKHkvTi9hKTogIiwgZmlsZSk7
CiBhZ2FpbjoK
--------------030807040800080005080508--
