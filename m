Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55106 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaEKF40 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 01:56:26 -0400
Received: by mail-qc0-f174.google.com with SMTP id x13so6318614qcv.19
        for <linux-btrfs@vger.kernel.org>; Sat, 10 May 2014 22:56:25 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 11 May 2014 07:56:25 +0200
Message-ID: <CAF1_xX2nVWGyq5s3hjDoJ6i9QM3LmocshPgrca1hkD0YsvCTcw@mail.gmail.com>
Subject: [regression] [v3.14] btrfs hangs while reading some files
From: Ronald <ronald645@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear btrfs developers,

Since v3.14, it has occasionally hapenned that reading some files from
a btrfs partition cause the process to hang. Right, a file has been
located that exhibits this behaviour.

/home/gebruiker/.wine_office/drive_c/MSOCache/All
Users/{90120000-0030-0000-0000-0000000FF1CE}-C/EnterWW.cab

This is what happens on v3.13:

08:46 gebruiker@delta ~ :)
 ==> FILE="$(cat fail)"
08:46 gebruiker@delta ~ :)
 ==> dd if="$FILE" of=/dev/zero
517229+1 records in
517229+1 records out
264821640 bytes (265 MB) copied, 7.57866 s, 34.9 MB/s

This is what happens on v3.14:

08:46 gebruiker@delta ~ :)
 ==> FILE="$(cat fail)"
08:46 gebruiker@delta ~ :)
 ==> dd if="$FILE" of=/dev/zero
Killed

Eventually the process is killed by me, as nothing sems to be
hapenning. What I know is the following:

- the bug has thus far consistently reproduced
- appears to happen mostly to big files (e.g. hundreds of megs or
several gigabyte's)
- probably only happens when reading files from a btrfs partition

An attempt to bisect has been performed:
# bad: [455c6fdbd219161bd09b1165f11699d6d73de11c] Linux 3.14
# good: [d8ec26d7f8287f5788a494f56e8814210f0e64be] Linux 3.13
git bisect start 'v3.14' 'v3.13' '--' 'fs/btrfs'
# good: [bd0330ad2174d1a5f762eee2ee58f0148f10d575] btrfs: Add acl mount option.
git bisect good bd0330ad2174d1a5f762eee2ee58f0148f10d575
# skip: [95def2ede1a9dd12b164932eaf5fefb67aefc41c] Btrfs: fix to catch
all errors when resolving indirect ref
git bisect skip 95def2ede1a9dd12b164932eaf5fefb67aefc41c
# skip: [49fc647a2c558862145357f3a25892248042f6fe] Btrfs: do not
export ulist functions
git bisect skip 49fc647a2c558862145357f3a25892248042f6fe
# skip: [3a6d75e846224542151e9ff186cb89df5a6ca2c6] Btrfs: fix qgroup
rescan to work with skinny metadata
git bisect skip 3a6d75e846224542151e9ff186cb89df5a6ca2c6
# skip: [4c7a6f74ceeafd738b55d1c57349327f7ea8e895] Btrfs: rework ulist
with list+rb_tree
git bisect skip 4c7a6f74ceeafd738b55d1c57349327f7ea8e895
# bad: [f568849edac8611d603e00bd6cbbcfea09395ae6] Merge branch
'for-3.14/core' of git://git.kernel.dk/linux-block
git bisect bad f568849edac8611d603e00bd6cbbcfea09395ae6
# good: [bf3d846b783327359ddc4bd4f52627b36abb4d1d] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect good bf3d846b783327359ddc4bd4f52627b36abb4d1d
# skip: [4f024f3797c43cb4b73cd2c50cec728842d0e49e] block: Abstract out
bvec iterator
git bisect skip 4f024f3797c43cb4b73cd2c50cec728842d0e49e
# skip: [33879d4512c021ae65be9706608dacb36b4687b1] block:
submit_bio_wait() conversions
git bisect skip 33879d4512c021ae65be9706608dacb36b4687b1
# skip: [bc1e79acc13d70c5bb1b2a47bf0a580e6ae81fb6] block: fixup for
generic bio chaining
git bisect skip bc1e79acc13d70c5bb1b2a47bf0a580e6ae81fb6
# good: [b28bc9b38c52f63f43e3fd875af982f2240a2859] Merge tag
'v3.13-rc6' into for-3.14/core
git bisect good b28bc9b38c52f63f43e3fd875af982f2240a2859
# bad: [c7b22bb19a24fef1a851a41e5c0657c0c4a41550] btrfs: fix missing
increment of bi_remaining
git bisect bad c7b22bb19a24fef1a851a41e5c0657c0c4a41550
# first bad commit: [c7b22bb19a24fef1a851a41e5c0657c0c4a41550] btrfs:
fix missing increment of bi_remaining

Reverting this commit causes the resulting kernel to OOPS during boot.
Furthermore, the first batch of skipping is because this kernel would
not load (grub keeps displaying 'Loading 'ArchLinux''. The second
batch of skipping is because the resulting kernel would OOPS during
boot.

The bisect failed, since the attempt to boot the latest marked good
kernel ended in an OOPS. So, testing this was not reliable.

The machine is an 32bit UP box. ~10,5 years old. This bug has also
been observed on multicore 64bit machines.

Would appreciate some pointers on how to debug this further.

                                   Ronald
