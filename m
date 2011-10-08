From: Kai Krakow <hurikhan77@gmail.com>
Subject: btrfs corruption after cp --reflink
Date: Sat, 8 Oct 2011 11:26:48 +0200
Message-ID: <CAMthOuMwb-ibGGzve_ntoqBcdK73UgjFP92AgCyGDu9jyX0bog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I tried to "cp --reflink" a huge file (about 80G, a VMware disk
image). It took maybe about 1 minute when my PC started thrashing the
hard disk, some minutes later the command returned with an out of
memory message. I could no longer open terminals in my KDE Konsole to
investiage dmesg. I could not start new programs. I could not log out.
Hard disk access was somehow blocked. Opening new terminals within
Konsole yielded in red letters. "unable to start /bin/bash" after a
few seconds.

I rebooted using the reset button, Alt+Print+S didn't seem to sync
anything to the disk - I tried. The system booted up just fine, some
error messages about unusable free space caches came up but it booted
up into the login manager. However, I can no longer login: KDE startup
freezes the system. If I ssh into the box first, I can see some dmesg
output related to "bad blocks" and some "transid" errors. So I did a
scrub, this is what I get:

# jupiter btrfs-progs-unstable [git:integration-20110805] # ./btrfs
scr start -B /mnt/btrfs
ERROR: scrubbing /mnt/btrfs failed for device id 1 (Input/output error)
scrub canceled for 493dacb5-0397-4b47-bd18-c2b2349c9958
        scrub started at Sat Oct  8 00:41:59 2011 and was aborted
after 6113 seconds
        total bytes scrubbed: 586.67GB with 40 errors
        error details: verify=40
        corrected errors: 0, uncorrectable errors: 20, unverified errors: 0

jupiter ~ # while true; do dmesg -c; sleep 1; done
[13686.476028] zcache: destroyed pool id=0
[13844.990091] device fsid 493dacb5-0397-4b47-bd18-c2b2349c9958 devid
1 transid 45326 /dev/sdd3
[13844.990374] btrfs: use lzo compression
[13845.074088] btrfs: disk space caching is enabled
[13852.481822] zcache: created ephemeral tmem pool, id=0
[19577.056022] btrfs: unable to fixup at 641086156800
[19577.056211] btrfs: unable to fixup at 641086160896
[19577.056383] btrfs: unable to fixup at 641086164992
[19577.056555] btrfs: unable to fixup at 641086169088
[19577.056733] btrfs: unable to fixup at 641086173184
[19577.858378] btrfs: unable to fixup at 641086156800
[19577.858566] btrfs: unable to fixup at 641086160896
[19577.858736] btrfs: unable to fixup at 641086164992
[19577.858909] btrfs: unable to fixup at 641086169088
[19577.859083] btrfs: unable to fixup at 641086173184
[19986.054338] verify_parent_transid: 310 callbacks suppressed
[19986.054343] parent transid verify failed on 641086156800 wanted
43863 found 43873
[19986.054559] parent transid verify failed on 641086156800 wanted
43863 found 43873
[19986.054904] parent transid verify failed on 641086156800 wanted
43863 found 43873
[19986.062448] parent transid verify failed on 641086156800 wanted
43863 found 43873
[19986.062455] parent transid verify failed on 641086156800 wanted
43863 found 43873

I was able to rsync my /home to the original partition I created my
btrfs from about 2 weeks ago, so this is not a complete desaster - but
with many of these logged to dmesg:

[10902.814420] btrfs no csum found for inode 445127 start 58392576
[10902.815153] btrfs no csum found for inode 445127 start 58396672
[10902.815951] btrfs no csum found for inode 445127 start 58400768
[10902.816692] btrfs no csum found for inode 445127 start 58404864
[10902.817430] btrfs no csum found for inode 445127 start 58408960
[10902.818168] btrfs no csum found for inode 445127 start 58413056
[10902.818904] btrfs no csum found for inode 445127 start 58417152
[10902.819683] btrfs no csum found for inode 445127 start 58421248
[10902.820421] btrfs no csum found for inode 445127 start 58425344
[10902.821154] btrfs no csum found for inode 445127 start 58429440
[10902.821887] btrfs no csum found for inode 445127 start 58433536
[10902.822673] btrfs no csum found for inode 445127 start 58437632
[10902.823414] btrfs no csum found for inode 445127 start 58441728
[10902.824151] btrfs no csum found for inode 445127 start 58445824
[10902.824889] btrfs no csum found for inode 445127 start 58449920
[10902.825716] btrfs no csum found for inode 445127 start 58454016
[10960.325903] verify_parent_transid: 470 callbacks suppressed
[10960.325908] parent transid verify failed on 641086173184 wanted
43863 found 43873
[10960.326129] parent transid verify failed on 641086173184 wanted
43863 found 43873
[10960.326319] parent transid verify failed on 641086173184 wanted
43863 found 43873
[10960.334898] parent transid verify failed on 641086173184 wanted
43863 found 43873
[10960.334906] parent transid verify failed on 641086173184 wanted
43863 found 43873
[10960.334912] btrfs no csum found for inode 288125 start 8912896
[10960.335131] parent transid verify failed on 641086173184 wanted
43863 found 43873
[10960.335322] parent transid verify failed on 641086173184 wanted
43863 found 43873
[10960.335518] parent transid verify failed on 641086173184 wanted
43863 found 43873
[10960.335840] parent transid verify failed on 641086173184 wanted
43863 found 43873
[10960.335849] parent transid verify failed on 641086173184 wanted
43863 found 43873
[10960.335854] btrfs no csum found for inode 288125 start 8916992
[10960.336643] btrfs no csum found for inode 288125 start 8921088
[10960.337413] btrfs no csum found for inode 288125 start 8925184
[10960.338169] btrfs no csum found for inode 288125 start 8929280
[10960.338920] btrfs no csum found for inode 288125 start 8933376
[10960.339702] btrfs no csum found for inode 288125 start 8937472
[10960.340440] btrfs no csum found for inode 288125 start 8941568
[10960.341179] btrfs no csum found for inode 288125 start 8945664
[10960.341916] btrfs no csum found for inode 288125 start 8949760
[10960.342746] btrfs no csum found for inode 288125 start 8953856
[10960.343483] btrfs no csum found for inode 288125 start 8957952
[10960.344222] btrfs no csum found for inode 288125 start 8962048

I'm on Gentoo, using gentoo-sources 3.0.4 in the backup system (the
btrfs system runs on 3.0.6):

# uname -a
Linux jupiter 3.0.4-gentoo #1 SMP Sat Oct 1 17:20:43 CEST 2011 i686
Intel(R) Pentium(R) 4 CPU 3.20GHz GenuineIntel GNU/Linux

The btrfs partition consists of multiple sub volumes. I would not
loose my /home as I was able to sync it but I would loose the rest of
the file system which includes a complete Gentoo installation and some
big data files only recoverable by investing much time. So I'd love to
get rid of the problems scrub complains about. I don't mind if I would
have to delete some files which I can probably recover easily. But I
can simply find no way to identify these files. Is there a way to map
the above error messages to file system pathes?

Just for completeness, here's my fstab with mount options (the relevant part):

/dev/sdd3 / btrfs compress=lzo,autodefrag,subvol=root 0 1
/dev/sdd3 /home btrfs compress=lzo,autodefrag,subvol=home 0 2
/dev/sdd3 /usr/portage btrfs compress=lzo,autodefrag,subvol=portage 0 2
/dev/sdd3 /usr/src btrfs compress=lzo,autodefrag,subvol=usr-src 0 2
/dev/sdd3 /tmp btrfs compress=lzo,autodefrag,subvol=tmp,nodev,nosuid 0 2
/dev/sdd3 /var/tmp btrfs compress=lzo,autodefrag,subvol=var-tmp,nodev,nosuid 0 2
/dev/sdd3 /mnt/btrfs-subvol-0 btrfs
compress=lzo,subvolid=0,autodefrag,noauto 0 2

I got rid of the free space caching issues by mounting with
clear_cache. Memory of the system is stable (memtest86 does not report
errors). The hard disk is fresh from factory, no errors reported in
smartctl and no sector errors reported in dmesg. When the problem in
"cp --reflink" occured I know there was a backtrace in dmesg related
to btrfs but I was not able to capture it. Btrfs was created with meta
data mirroring and user data striping although the fs is single disk
only currently. I planned to add more disks when btrfs proves stable
for me.

Thanks in advance,
Kai
