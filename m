Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:35610 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752214AbcHXWTb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 18:19:31 -0400
Received: by mail-ua0-f196.google.com with SMTP id 109so2423097uat.2
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Aug 2016 15:19:29 -0700 (PDT)
MIME-Version: 1.0
From: Robert Munteanu <robert.munteanu@gmail.com>
Date: Thu, 25 Aug 2016 01:19:27 +0300
Message-ID: <CAC8ULPbST1tMtfW8MBdEXiFSxknQtUHYneZu8FpQij5DRon_gg@mail.gmail.com>
Subject: btrfs partition fails to mount - kernel BUG at ../fs/btrfs/extent-tree.c:1872
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary=94eb2c122f72b4ae8c053ad8ac79
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--94eb2c122f72b4ae8c053ad8ac79
Content-Type: text/plain; charset=UTF-8

Hi,

Using Kernel 4.7.1 ( openSUSE Tumbleweed x86_64 ), btrfsprogs 4.7 I
always get a hard lockup when trying to mount my btrfs root partition.

This may be due to some previous errors which only manifested
themselves now, as it's been converted from an ext4 partition.

Using mount -o ro works. Using mount -o recovery or mounting without
arguments does not. I've managed to capture one of the error messages,
but via screenshot only. I've transcribed some of it below, more at

  http://i.imgur.com/OSIddHE.jpg

BTRFS info (device sda1): disk space caching is enabled
BTRFS info (device sda1): detected SSD devices, enabling SSD mode
BTRFS info (device sda1): checking UUID tree
BTRFS info (device sda1): continuing balance
BTRFS info (device sda1): relocating block group 1047892328448 flags 1
BTRFS info (device sda1): found 805 extents
(...)
kernel BUG at ../fs/btrfs/extent-tree.c:1872
invalid opcode: 0000 [#1] PREEMPT SMP
(...)
Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
(...)
Call Trace:
 [...] remove_extent_backref
 [...] __btrfs_free_extent_isra
 [...] __btrfs_run_delayed
 [...] delayed_ref_async_start
 [...] btrfs_scrubparity_helper
 [...] process_one_work
 [...] worked_thread
 [...] kthread
 [...] ret_from_fork
DWARF2 unwinder stuck at ret_from_fork

For reference, I've attached the output of

- btrfsck /dev/sda1
- btrfsck --repair /dev/sda1
- btrfsck --repair /dev/sda1 (2nd execution)

I've included two executions in repair mode to show that nothing of
interest changes between the two.

My way out is simply transferring the data out ( mount -o ro works )
and creating a new partition, but it would be interesting to fix it,
and if there's any information I can offer to help prepare a bug fix
please let me know.

Thanks,

Robert

-- 
http://robert.muntea.nu/

--94eb2c122f72b4ae8c053ad8ac79
Content-Type: application/octet-stream; name="btrfsck.out"
Content-Disposition: attachment; filename="btrfsck.out"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_is9g9w9v0

Q2hlY2tpbmcgZmlsZXN5c3RlbSBvbiAvZGV2L3NkYTEKVVVJRDogNTRkZWExMjUtNzRjZC00YmIy
LTg2YTItZjdiYzY0NWI3NmNmCmZvdW5kIDE5NDk1MzU5Mjg0NSBieXRlcyB1c2VkIGVyciBpcyAw
CnRvdGFsIGNzdW0gYnl0ZXM6IDE4NTczNTc2MAp0b3RhbCB0cmVlIGJ5dGVzOiA0Mjk4ODAxMTUy
CnRvdGFsIGZzIHRyZWUgYnl0ZXM6IDM5MjgzMDk3NjAKdG90YWwgZXh0ZW50IHRyZWUgYnl0ZXM6
IDE0NDI2MTEyMApidHJlZSBzcGFjZSB3YXN0ZSBieXRlczogODAxNzg2ODYzCmZpbGUgZGF0YSBi
bG9ja3MgYWxsb2NhdGVkOiAxNDU1MjkyMzcwOTQ0CiByZWZlcmVuY2VkIDMyNDgyNjk5NjczNgo=
--94eb2c122f72b4ae8c053ad8ac79
Content-Type: application/octet-stream; name="btrfsck_repair.out"
Content-Disposition: attachment; filename="btrfsck_repair.out"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_is9gcog21

ZW5hYmxpbmcgcmVwYWlyIG1vZGUKQ2hlY2tpbmcgZmlsZXN5c3RlbSBvbiAvZGV2L3NkYTEKVVVJ
RDogNTRkZWExMjUtNzRjZC00YmIyLTg2YTItZjdiYzY0NWI3NmNmCmNhY2hlIGFuZCBzdXBlciBn
ZW5lcmF0aW9uIGRvbid0IG1hdGNoLCBzcGFjZSBjYWNoZSB3aWxsIGJlIGludmFsaWRhdGVkCmZv
dW5kIDE5NDk1MzU3NjQ2MSBieXRlcyB1c2VkIGVyciBpcyAwCnRvdGFsIGNzdW0gYnl0ZXM6IDE4
NTczNTc2MAp0b3RhbCB0cmVlIGJ5dGVzOiA0Mjk4Nzg0NzY4CnRvdGFsIGZzIHRyZWUgYnl0ZXM6
IDM5MjgzMDk3NjAKdG90YWwgZXh0ZW50IHRyZWUgYnl0ZXM6IDE0NDI0NDczNgpidHJlZSBzcGFj
ZSB3YXN0ZSBieXRlczogODAxNzY5ODg5CmZpbGUgZGF0YSBibG9ja3MgYWxsb2NhdGVkOiAxNDU1
MjkyMzcwOTQ0CiByZWZlcmVuY2VkIDMyNDgyNjk5NjczNgo=
--94eb2c122f72b4ae8c053ad8ac79
Content-Type: application/octet-stream; name="btrfsck_repair_2.out"
Content-Disposition: attachment; filename="btrfsck_repair_2.out"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_is9gcogi2

ZW5hYmxpbmcgcmVwYWlyIG1vZGUKQ2hlY2tpbmcgZmlsZXN5c3RlbSBvbiAvZGV2L3NkYTEKVVVJ
RDogNTRkZWExMjUtNzRjZC00YmIyLTg2YTItZjdiYzY0NWI3NmNmCmNhY2hlIGFuZCBzdXBlciBn
ZW5lcmF0aW9uIGRvbid0IG1hdGNoLCBzcGFjZSBjYWNoZSB3aWxsIGJlIGludmFsaWRhdGVkCmZv
dW5kIDE5NDk1Njc0MjY2OSBieXRlcyB1c2VkIGVyciBpcyAwCnRvdGFsIGNzdW0gYnl0ZXM6IDE4
NTczNTc2MAp0b3RhbCB0cmVlIGJ5dGVzOiA0Mjk4Nzg0NzY4CnRvdGFsIGZzIHRyZWUgYnl0ZXM6
IDM5MjgzMDk3NjAKdG90YWwgZXh0ZW50IHRyZWUgYnl0ZXM6IDE0NDI0NDczNgpidHJlZSBzcGFj
ZSB3YXN0ZSBieXRlczogODAxNzY5NzQwCmZpbGUgZGF0YSBibG9ja3MgYWxsb2NhdGVkOiAxNDU1
MjkyMzcwOTQ0CiByZWZlcmVuY2VkIDMyNDgyNjk5NjczNgo=
--94eb2c122f72b4ae8c053ad8ac79--
