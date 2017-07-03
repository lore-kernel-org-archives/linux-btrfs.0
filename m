Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:36585 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755846AbdGCOkc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jul 2017 10:40:32 -0400
Received: by mail-it0-f53.google.com with SMTP id m68so88820074ith.1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Jul 2017 07:40:32 -0700 (PDT)
MIME-Version: 1.0
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Mon, 3 Jul 2017 16:40:10 +0200
Message-ID: <CAA85sZtOT6Fkxee77CWpdiYdQYbLGfoAihdjSvW9V00w+AWeBw@mail.gmail.com>
Subject: Known bugs in v4,.11.0?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="94eb2c039fe2b54a4005536abfeb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--94eb2c039fe2b54a4005536abfeb
Content-Type: text/plain; charset="UTF-8"

We're running a openstack deployment using kolla-ansible on machines
with btrfs filesystems.

kolla-ansible deploys everything as docker images, which in turn uses
btrfs subvolumes and does some heavy-magic^tm

Anyway, a while ago, we restarted one docker instance on four
machines, as you do - pretty common, but this caused a kernel panic on
all four machines....

I'm wondering if there is a known bug in btrfs, that we might have
hit? especially since the kernel panic is truncated... =/

Screenshot:
https://goo.gl/photos/zJzLV7QruNqMFKRBA

OCR:ed and fixed up trace:
[4492428.611565]  do_syscall_64+0x67/0x180
[4492428.611713]  entry_SYSCALL64_slow_path+0x25/0x25
[4492428.611860] RIP: 0033:0x6ba79a
[4492428.612005] RSP: 002b:000000c421cc0ac0 EFLAGS: 00000206 ORIG_RAX:
00000000000000a5
[4492428.612292] RAX: ffffffffffffffda RBX: 000000c42001550c RCX:
00000000006ba79a
[4492428.612576] RDX: 000000c4214e6a40 RSI: 000000c4216a67e0 RDI:
000000c4214e6a38
[4492428.612862] RBP: 000000c421cc0b70 R08: 000000c4226597c0 RB9:
0000000000000000
[4492428.613146] R10: 000000000000000e R11: 0000000000000206 R12:
0000000000000a40
[4492428.613435] R13: 00000000000000af R14: 000000000000001f R15:
0000000000000004
[4492428.613723] Code: ee cb f4 00 48 8b 3d ef cb f4 00 48 39 fa 48 8b
72 10 0f 84 69 01 00 00 48 3b 86 d8 00 00 00 74 24 48 8b 92 d8 00 00
00 48 39 d7 <48> 8b 72 10 0f 84 40 01 00 00 48 3b 86 d8 00 00 00 75 e3
48 B9
[4492428.614213] RIP: propagate_one+0xa1/0x200 RSP: ffffc9002eac3d78
[4492428.614363] CR2: 0000000000000010
[4492428.614881] ---[ end trace ce6357ccc7c57710 I---
[4492428.615067] Kernel panic - not syncing: Fatal exception
[4492428.615286] Kernel 0ffset: disabled
[4492428.615478] ---[ end Kernel panic - not syncing: Fatal exception
---

the propagate_one bit makes me think it could be filesystem related -
so, that's why i'm asking =)

--94eb2c039fe2b54a4005536abfeb
Content-Type: text/plain; charset="US-ASCII"; name="kernel-oops-4.11.0.txt"
Content-Disposition: attachment; filename="kernel-oops-4.11.0.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j4o95fn30

WzQ0OTI0MjguNjExNTY1XSAgZG9fc3lzY2FsbF82NCsweDY3LzB4MTgwCls0NDkyNDI4LjYxMTcx
M10gIGVudHJ5X1NZU0NBTEw2NF9zbG93X3BhdGgrMHgyNS8weDI1Cls0NDkyNDI4LjYxMTg2MF0g
UklQOiAwMDMzOjB4NmJhNzlhCls0NDkyNDI4LjYxMjAwNV0gUlNQOiAwMDJiOjAwMDAwMGM0MjFj
YzBhYzAgRUZMQUdTOiAwMDAwMDIwNiBPUklHX1JBWDogMDAwMDAwMDAwMDAwMDBhNQpbNDQ5MjQy
OC42MTIyOTJdIFJBWDogZmZmZmZmZmZmZmZmZmZkYSBSQlg6IDAwMDAwMGM0MjAwMTU1MGMgUkNY
OiAwMDAwMDAwMDAwNmJhNzlhCls0NDkyNDI4LjYxMjU3Nl0gUkRYOiAwMDAwMDBjNDIxNGU2YTQw
IFJTSTogMDAwMDAwYzQyMTZhNjdlMCBSREk6IDAwMDAwMGM0MjE0ZTZhMzgKWzQ0OTI0MjguNjEy
ODYyXSBSQlA6IDAwMDAwMGM0MjFjYzBiNzAgUjA4OiAwMDAwMDBjNDIyNjU5N2MwIFJCOTogMDAw
MDAwMDAwMDAwMDAwMApbNDQ5MjQyOC42MTMxNDZdIFIxMDogMDAwMDAwMDAwMDAwMDAwZSBSMTE6
IDAwMDAwMDAwMDAwMDAyMDYgUjEyOiAwMDAwMDAwMDAwMDAwYTQwCls0NDkyNDI4LjYxMzQzNV0g
UjEzOiAwMDAwMDAwMDAwMDAwMGFmIFIxNDogMDAwMDAwMDAwMDAwMDAxZiBSMTU6IDAwMDAwMDAw
MDAwMDAwMDQKWzQ0OTI0MjguNjEzNzIzXSBDb2RlOiBlZSBjYiBmNCAwMCA0OCA4YiAzZCBlZiBj
YiBmNCAwMCA0OCAzOSBmYSA0OCA4YiA3MiAxMCAwZiA4NCA2OSAwMSAwMCAwMCA0OCAzYiA4NiBk
OCAwMCAwMCAwMCA3NCAyNCA0OCA4YiA5MiBkOCAwMCAwMCAwMCA0OCAzOSBkNyA8NDg+IDhiIDcy
IDEwIDBmIDg0IDQwIDAxIDAwIDAwIDQ4IDNiIDg2IGQ4IDAwIDAwIDAwIDc1IGUzIDQ4IEI5Cls0
NDkyNDI4LjYxNDIxM10gUklQOiBwcm9wYWdhdGVfb25lKzB4YTEvMHgyMDAgUlNQOiBmZmZmYzkw
MDJlYWMzZDc4Cls0NDkyNDI4LjYxNDM2M10gQ1IyOiAwMDAwMDAwMDAwMDAwMDEwCls0NDkyNDI4
LjYxNDg4MV0gLS0tWyBlbmQgdHJhY2UgY2U2MzU3Y2NjN2M1NzcxMCBJLS0tCls0NDkyNDI4LjYx
NTA2N10gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgpbNDQ5MjQy
OC42MTUyODZdIEtlcm5lbCAwZmZzZXQ6IGRpc2FibGVkCls0NDkyNDI4LjYxNTQ3OF0gLS0tWyBl
bmQgS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgo=
--94eb2c039fe2b54a4005536abfeb--
