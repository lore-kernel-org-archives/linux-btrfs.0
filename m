Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:35682 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750867AbcLDTLS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 14:11:18 -0500
Received: by mail-ua0-f175.google.com with SMTP id 12so329680022uas.2
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Dec 2016 11:11:17 -0800 (PST)
MIME-Version: 1.0
From: Henk Slager <eye1tm@gmail.com>
Date: Sun, 4 Dec 2016 20:11:16 +0100
Message-ID: <CAPmG0jYzCNTFEpA_tZAJE2BpohLPtxmu=WE_vB2ypBSJoD_Zvw@mail.gmail.com>
Subject: btrfs restore differs from normal copy
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I noticed that a monthly differential snapshot creation ended with an
error although the created snapshot itself seemed OK. To test en be
more confident, I also transferred the diff between the 2016-12-01 en
2016-12-02 and that went without an error from send or receive. The
send runs on a server and heavily relies on 'Received UUID'. The
receive runs at the same time on a fanless system that is only a
monthly btrfs backup receive target if all works well.

After the 2016-12-01 snapshot receive, the fs refused to mount after
reboot and same as for another mount refusal, I did a clear_space
mount and that made it work again. A scrub revealed 2 csum errors,
each in a VM imagefle (35GB and 16GB), so I thought I use btrfs
restore this time to fix the backup, prepare for next month, without
growing the fs with 51GB and also get hints on the root cause of the
csum errors.

The 16GB VM imagefile only exists in the 2016-12-01 snapshot (after I
deleted the 2016-12-02 snapshot), so with regex I just fetched the
file. I had to press 'y' once on the "We seem to be looping a lot
...".
I ran  btrfs restore with -o -i -s -v options (and --path-regex).

# dd_rescue -W <restored_imagefile> <original_imagefile_in_temp_rw_snapshot>
showed about 11GB diff, which is way more than the 4k block with failed csum.

I did the same for another, older VM imagefile (no csum error blocks)
in the 2016-12-01 snapshot. That gave 2GB diff. If I mount the fs and
just copy the file instead of btrfs restore, the diff is 0, as
expected.

On both computers:
# uname -r
4.8.10-1-default
# btrfs --version
btrfs-progs v4.8.2+20161031

The mount options of the receive fs( everything is default CoW:
rw,noatime,compress=lzo,nossd,space_cache,subvolid=5,subvol=/

Any idea why btrfs restores wrong file data?
