Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:35848 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdCQMWO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 08:22:14 -0400
Received: by mail-pg0-f51.google.com with SMTP id g2so40356160pge.3
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Mar 2017 05:22:13 -0700 (PDT)
MIME-Version: 1.0
From: John Marrett <johnf@zioncluster.ca>
Date: Fri, 17 Mar 2017 08:22:07 -0400
Message-ID: <CAAafysHAZ_1-4rTqsY4cw0rkBgq3f_F29nM+=XsDEhNvR8CkJQ@mail.gmail.com>
Subject: BTRFS Metadata Corruption Prevents Scrub and btrfs check
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a filesystem with uncorrectable errors in metadata. In the past
when I've experienced corruption due to drive failures it affected the
data and not metadata. I was able to delete the files and restored
their content from backup. Unfortunately I can't do this this time as
I have no way to directly affect the metadata. I encounter stale file
handle errors when I try to access the impacted files:

tar: home/johnf/personal/projects/openwrt/trunk/build_dir/target-mips_r2_uClibc-0.9.32/hostapd-wpad-mini/hostapd-20110117/hostapd/hostapd.eap_user:
Read error at byte 0, while reading 3975 bytes: Input/output error
tar: home/johnf/personal/projects/openwrt/trunk/build_dir/target-mips_r2_uClibc-0.9.32/hostapd-wpad-mini/hostapd-20110117/hostapd/hostapd.radius_clients:
Cannot stat: Stale file handle
tar: home/johnf/personal/projects/openwrt/trunk/build_dir/target-mips_r2_uClibc-0.9.32/hostapd-wpad-mini/hostapd-20110117/hostapd/hostapd.sim_db:
Cannot stat: Stale file handle

When I attempt a scrub the system fails with the following messages:

Thu Mar  9 20:41:20 EST 2017
scrub status for 67b4821f-16e0-436d-b521-e4ab2c7d3ab7
        scrub started at Thu Mar  9 13:04:52 2017 and finished after 07:05:41
        total bytes scrubbed: 12.56TiB with 2 errors
        error details: csum=2
        corrected errors: 0, uncorrectable errors: 2, unverified errors: 0

The following messages are emitted by the kernel:

[43022.286418] BTRFS warning (device sda4): sda4 checksum verify
failed on 9626194001920 wanted 26FCCA1 found 6EB184F1 level 0
[43022.305795] BTRFS warning (device sda4): sda4 checksum verify
failed on 9626194001920 wanted 26FCCA1 found 6EB184F1 level 0
[76606.731223] BTRFS warning (device sda4): checksum error at logical
9626194001920 on dev /dev/sdh1, sector 5016524768: metadata leaf
(level 0) in tree 4804958584832
[76606.731233] BTRFS warning (device sda4): checksum error at logical
9626194001920 on dev /dev/sdh1, sector 5016524768: metadata leaf
(level 0) in tree 4804958584832
[76606.731240] BTRFS error (device sda4): bdev /dev/sdh1 errs: wr 0,
rd 0, flush 0, corrupt 2, gen 0
[76606.734185] BTRFS warning (device sda4): checksum error at logical
9626194001920 on dev /dev/sdg1, sector 5016524768: metadata leaf
(level 0) in tree 4804958584832
[76606.734192] BTRFS warning (device sda4): checksum error at logical
9626194001920 on dev /dev/sdg1, sector 5016524768: metadata leaf
(level 0) in tree 4804958584832
[76606.734196] BTRFS error (device sda4): bdev /dev/sdg1 errs: wr 0,
rd 0, flush 0, corrupt 2, gen 0
[76606.735122] BTRFS error (device sda4): unable to fixup (regular)
error at logical 9626194001920 on dev /dev/sdh1
[76609.735650] BTRFS error (device sda4): unable to fixup (regular)
error at logical 9626194001920 on dev /dev/sdg1

I then shut the system down and performed a btrfs check using the
lastest btrfs-progs from master:

ubuntu@ubuntu:~/tmp/btrfs-progs$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working directory clean
ubuntu@ubuntu:~/tmp/btrfs-progs$ ./btrfs --version
btrfs-progs v4.10
ubuntu@ubuntu:~/tmp/btrfs-progs$ sudo ./btrfs check -p --repair /dev/sda4
enabling repair mode
Checking filesystem on /dev/sda4
UUID: 67b4821f-16e0-436d-b521-e4ab2c7d3ab7
checksum verify failed on 9626194001920 found 6EB184F1 wanted 026FCCA1
checksum verify failed on 9626194001920 found 6EB184F1 wanted 026FCCA1
checksum verify failed on 9626194001920 found 6EB184F1 wanted 026FCCA1
checksum verify failed on 9626194001920 found 6EB184F1 wanted 026FCCA1
Csum didn't match
ref mismatch on [5165855678464 28672] extent item 1, found 0
checksum verify failed on 9626194001920 found 6EB184F1 wanted 026FCCA1
checksum verify failed on 9626194001920 found 6EB184F1 wanted 026FCCA1
checksum verify failed on 9626194001920 found 6EB184F1 wanted 026FCCA1
checksum verify failed on 9626194001920 found 6EB184F1 wanted 026FCCA1
Csum didn't match
Incorrect local backref count on 5165855678464 root 259 owner 1732872
offset 0 found 0 wanted 1 back 0x3ba80f40
Backref disk bytenr does not match extent record,
bytenr=5165855678464, ref bytenr=7880454922968236032
backpointer mismatch on [5165855678464 28672]
owner ref check failed [5165855678464 28672]
checksum verify failed on 9626194001920 found 6EB184F1 wanted 026FCCA1
checksum verify failed on 9626194001920 found 6EB184F1 wanted 026FCCA1
checksum verify failed on 9626194001920 found 6EB184F1 wanted 026FCCA1
checksum verify failed on 9626194001920 found 6EB184F1 wanted 026FCCA1
Csum didn't match
failed to repair damaged filesystem, aborting

I have backups of the affected files, I simply want to restore them
and return the filesystem to a stable state. Is there a way I can do
this without erasing the entire filesystem and restoring it?

Thanks in advance for your help and guidance,

-JohnF
