Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38615 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbbFRXzF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 19:55:05 -0400
Received: by wibdq8 with SMTP id dq8so3546078wib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 16:55:03 -0700 (PDT)
Received: from [192.168.0.18] ([78.194.205.2])
        by mx.google.com with ESMTPSA id q4sm14372635wju.14.2015.06.18.16.55.01
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jun 2015 16:55:02 -0700 (PDT)
Message-ID: <55835A55.7000308@stroebel.fr>
Date: Fri, 19 Jun 2015 01:55:01 +0200
From: Vianney Stroebel <vianney@stroebel.fr>
Reply-To: Vianney Stroebel <capsule@likwid.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Corrupted btrfs partition (converted from ext4) after balance
Content-Type: multipart/mixed;
 boundary="------------000208010203040008000100"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000208010203040008000100
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

One of my btrfs partition seems to have been corrupted.

Since I've tried to balance it, I can only mount it read-only. I have been able to use it read-only without problem so far so the data seems safe.

When I remove the "ro" option, the "mount" command hangs and some programs do not function properly (iotop hangs too and Firefox cannot load new web pages). Every few seconds a message is printed on syslog (see attached file).

If I try to terminate the "mount" process with ctrl+c, my whole system hangs.

This partition was converted from ext4 and I could use it fine after that. It got corrupted when I tried to balance it a few days ago (even though I think I had balanced it before, but I'm not sure about this). The balance would seem to have started but "balance status" showed no progress even after one hour.

This partition is on one hard disk (no raid). Mount options: defaults,compress=lzo,noatime,nodiratime,noauto,ro). My system also runs on btrfs on another disk (ssd) without any problems apart from quite poor performance (but that's for another post).

The command "btrfs scrub start /_big -r" hangs my system.

The command Konsole output "btrfs check /dev/sdb1" outputs :
"Checking filesystem on /dev/sdb1
UUID: 21873ba7-438a-4fbf-a051-ace28bffd264
checking extents"
and stops after a few minutes with no other output.

I did not try "btrfs check --repair".

"Btrfs-zero-log" doesn't seem to apply here.
Konsole output
I could copy the data on another freshly formatted disk and reformat this one but I am wondering if btrfs is stable enough to be used on my professional laptop (where I cannot afford such downtime)or if I should go back to ext4.

So the goal of this message is not only to see if I can repair this partition, but also to assess if btrfs corrupt partitions randomly and irreversibly. If the root cause resides in a non-essential feature (conversion or balancing for example), I would happily continue to use it without this feature.

This is my first message on this mailing list. I've spent the last hours trying to solve this.

More info:

uname -a
Linux viybel-pc 3.19.0-21-generic #21-Ubuntu SMP Sun Jun 14 18:31:11 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

btrfs --version
btrfs-progs v3.19.1

btrfs fi show
Label: none  uuid: 358f485d-690d-436d-ad35-3a1f47329ed7
         Total devices 1 FS bytes used 107.75GiB
         devid    1 size 111.79GiB used 111.79GiB path /dev/sda1

Label: none  uuid: 21873ba7-438a-4fbf-a051-ace28bffd264
         Total devices 1 FS bytes used 606.17GiB
         devid    1 size 698.63GiB used 660.03GiB path /dev/sdb1

btrfs fi df /_big
Data, single: total=431.00GiB, used=419.49GiB
System, single: total=32.00MiB, used=64.00KiB
Metadata, single: total=229.00GiB, used=186.67GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

dmesg > dmesg.log (attached)

Konsole outp
Vianney


--------------000208010203040008000100
Content-Type: text/plain; charset=UTF-8;
 name="viybel_btrfs-bug_syslog-message-after-mount"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="viybel_btrfs-bug_syslog-message-after-mount"

SnVuIDE4IDIzOjM4OjMwIHZpeWJlbC1wYyBrZXJuZWw6IFsgIDkwMy45NjM3MDVdIE5NSSB3
YXRjaGRvZzogQlVHOiBzb2Z0IGxvY2t1cCAtIENQVSMxIHN0dWNrIGZvciAyMnMhIFttb3Vu
dDoyNTU2XQpKdW4gMTggMjM6Mzg6MzAgdml5YmVsLXBjIGtlcm5lbDogWyAgOTAzLjk2Mzcx
NF0gTW9kdWxlcyBsaW5rZWQgaW46IHBjaV9zdHViIHZib3hwY2koT0UpIHZib3huZXRhZHAo
T0UpIHZib3huZXRmbHQoT0UpIHZib3hkcnYoT0UpIGJpbmZtdF9taXNjIGJ0dXNiIGJsdWV0
b290aCB1dmN2aWRlbyBocF93bWkgdmlkZW9idWYyX3ZtYWxsb2Mgc25kX2hkYV9jb2RlY19o
ZG1pKE9FKSBzcGFyc2Vfa2V5bWFwIHZpZGVvYnVmMl9tZW1vcHMgdmlkZW9idWYyX2NvcmUg
djRsMl9jb21tb24gYXJjNCB2aWRlb2RldiBzbmRfaGRhX2NvZGVjX2lkdChPRSkgbWVkaWEg
c25kX2hkYV9jb2RlY19nZW5lcmljKE9FKSBzbmRfaGRhX2ludGVsKE9FKSBzbmRfaGRhX2Nv
ZGVjKE9FKSBzbmRfaGRhX2NvcmUoT0UpIGl3bGR2bSBzbmRfaHdkZXAgbWFjODAyMTEgc25k
X3BjbSBpbnRlbF9wb3dlcmNsYW1wIGNvcmV0ZW1wIHNuZF9zZXFfbWlkaSBzbmRfc2VxX21p
ZGlfZXZlbnQga3ZtX2ludGVsIGt2bSBzbmRfcmF3bWlkaSBpd2x3aWZpIHNuZF9zZXEgam95
ZGV2IGNmZzgwMjExIHNlcmlvX3JhdyBzbmRfc2VxX2RldmljZSBzbmRfdGltZXIgc25kIGhw
X2FjY2VsIHRwbV9pbmZpbmVvbiBsaXMzbHYwMmQgODI1MF9maW50ZWsgaW5wdXRfcG9sbGRl
diBtZWlfbWUgbWFjX2hpZCBscGNfaWNoIG1laSBzb3VuZGNvcmUgaW50ZWxfaXBzIHNocGNo
cCBwYXJwb3J0X3BjIHBwZGV2IGxwIHBhcnBvcnQgYXV0b2ZzNCBidHJmcyB4b3IgcmFpZDZf
cHEgaGlkX2dlbmVyaWMgdXNiaGlkIGhpZCBtbWNfYmxvY2sgaTkxNSBlMTAwMGUgaTJjX2Fs
Z29fYml0IGRybV9rbXNfaGVscGVyIGZpcmV3aXJlX29oY2kgcHNtb3VzZSBwdHAgYWhjaSBm
aXJld2lyZV9jb3JlIHNkaGNpX3BjaSBkcm0gcHBzX2NvcmUgbGliYWhjaSBzZGhjaSBjcmNf
aXR1X3Qgd21pIHZpZGVvCkp1biAxOCAyMzozODozMCB2aXliZWwtcGMga2VybmVsOiBbICA5
MDMuOTYzODEyXSBDUFU6IDEgUElEOiAyNTU2IENvbW06IG1vdW50IFRhaW50ZWQ6IEcgICAg
ICAgIFcgIE9FTCAzLjE5LjAtMjEtZ2VuZXJpYyAjMjEtVWJ1bnR1Ckp1biAxOCAyMzozODoz
MCB2aXliZWwtcGMga2VybmVsOiBbICA5MDMuOTYzODE2XSBIYXJkd2FyZSBuYW1lOiBIZXds
ZXR0LVBhY2thcmQgSFAgUHJvQm9vayA2NTUwYi8xNDZELCBCSU9TIDY4Q0RFIFZlci4gRi4w
NiAwMS8xMS8yMDExCkp1biAxOCAyMzozODozMCB2aXliZWwtcGMga2VybmVsOiBbICA5MDMu
OTYzODIwXSB0YXNrOiBmZmZmODgwMDZhN2ZkODUwIHRpOiBmZmZmODgwMDZiOTEwMDAwIHRh
c2sudGk6IGZmZmY4ODAwNmI5MTAwMDAKSnVuIDE4IDIzOjM4OjMwIHZpeWJlbC1wYyBrZXJu
ZWw6IFsgIDkwMy45NjM4MjNdIFJJUDogMDAxMDpbPGZmZmZmZmZmODE3Y2FhYzI+XSAgWzxm
ZmZmZmZmZjgxN2NhYWMyPl0gX3Jhd19zcGluX2xvY2srMHgxMi8weDgwCkp1biAxOCAyMzoz
ODozMCB2aXliZWwtcGMga2VybmVsOiBbICA5MDMuOTYzODM2XSBSU1A6IDAwMTg6ZmZmZjg4
MDA2YjkxM2IxOCAgRUZMQUdTOiAwMDAwMDI4MgpKdW4gMTggMjM6Mzg6MzAgdml5YmVsLXBj
IGtlcm5lbDogWyAgOTAzLjk2MzgzOV0gUkFYOiAwMDAwMDAwMGFlN2NhZTdjIFJCWDogZmZm
Zjg4MDAwMDAwMDAzMCBSQ1g6IDAwMDAwMDAwMDAwMDAwNTMKSnVuIDE4IDIzOjM4OjMwIHZp
eWJlbC1wYyBrZXJuZWw6IFsgIDkwMy45NjM4NDJdIFJEWDogMDAwMDAwMDAwMDAwYWU3YSBS
U0k6IDAwMDAwMDAwMDAwMDAyNDYgUkRJOiBmZmZmODgwMGI0ZTFkZDcwCkp1biAxOCAyMzoz
ODozMCB2aXliZWwtcGMga2VybmVsOiBbICA5MDMuOTYzODQ0XSBSQlA6IGZmZmY4ODAwNmI5
MTNiMTggUjA4OiAwMDAwMDAwMDAwMDFjY2M0IFIwOTogMDAwMDAwMDAwMDAwMDVmNApKdW4g
MTggMjM6Mzg6MzAgdml5YmVsLXBjIGtlcm5lbDogWyAgOTAzLjk2Mzg0N10gUjEwOiAwMDAw
MDAwMDAwMDAwMDk2IFIxMTogMDAwMDAwMDAwMDAwMDVmNCBSMTI6IGZmZmZmZmZmODE3YzE4
NTMKSnVuIDE4IDIzOjM4OjMwIHZpeWJlbC1wYyBrZXJuZWw6IFsgIDkwMy45NjM4NDldIFIx
MzogZmZmZjg4MDA2YjkxM2FkOCBSMTQ6IGZmZmZmZmZmODEwY2QyNzkgUjE1OiBmZmZmODgw
MDZiOTEzYTc4Ckp1biAxOCAyMzozODozMCB2aXliZWwtcGMga2VybmVsOiBbICA5MDMuOTYz
ODUzXSBGUzogIDAwMDA3ZjhlMjE2MGI4NDAoMDAwMCkgR1M6ZmZmZjg4MDIzYmM0MDAwMCgw
MDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwCkp1biAxOCAyMzozODozMCB2aXliZWwtcGMg
a2VybmVsOiBbICA5MDMuOTYzODU2XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1Iw
OiAwMDAwMDAwMDgwMDUwMDNiCkp1biAxOCAyMzozODozMCB2aXliZWwtcGMga2VybmVsOiBb
ICA5MDMuOTYzODU4XSBDUjI6IDAwMDA3ZjU3NjU4NDkwNDAgQ1IzOiAwMDAwMDAwMDcwMDhi
MDAwIENSNDogMDAwMDAwMDAwMDAwMDdlMApKdW4gMTggMjM6Mzg6MzAgdml5YmVsLXBjIGtl
cm5lbDogWyAgOTAzLjk2Mzg2MV0gU3RhY2s6Ckp1biAxOCAyMzozODozMCB2aXliZWwtcGMg
a2VybmVsOiBbICA5MDMuOTYzODYzXSAgZmZmZjg4MDA2YjkxM2I0OCBmZmZmZmZmZmMwM2E2
YzkwIGZmZmY4ODAwNmI5MTNiODggZmZmZjg4MDBiNGUxZDgwMApKdW4gMTggMjM6Mzg6MzAg
dml5YmVsLXBjIGtlcm5lbDogWyAgOTAzLjk2Mzg2N10gIGZmZmY4ODAwNmI5MTNiODggZmZm
Zjg4MDBiNGUxZTgwMCBmZmZmODgwMDZiOTEzYjY4IGZmZmZmZmZmYzAzYTZkOGMKSnVuIDE4
IDIzOjM4OjMwIHZpeWJlbC1wYyBrZXJuZWw6IFsgIDkwMy45NjM4NzFdICBmZmZmODgwMGI1
OTYxNDIwIGZmZmY4ODAwYjU5NjE0MjAgZmZmZjg4MDA2YjkxM2JjOCBmZmZmZmZmZmMwM2Fk
NjM0Ckp1biAxOCAyMzozODozMCB2aXliZWwtcGMga2VybmVsOiBbICA5MDMuOTYzODc1XSBD
YWxsIFRyYWNlOgpKdW4gMTggMjM6Mzg6MzAgdml5YmVsLXBjIGtlcm5lbDogWyAgOTAzLjk2
MzkxN10gIFs8ZmZmZmZmZmZjMDNhNmM5MD5dIF9fZGVsX3JlbG9jX3Jvb3QrMHgzMC8weDEw
MCBbYnRyZnNdCkp1biAxOCAyMzozODozMCB2aXliZWwtcGMga2VybmVsOiBbICA5MDMuOTYz
OTQ3XSAgWzxmZmZmZmZmZmMwM2E2ZDhjPl0gZnJlZV9yZWxvY19yb290cysweDJjLzB4NDAg
W2J0cmZzXQpKdW4gMTggMjM6Mzg6MzAgdml5YmVsLXBjIGtlcm5lbDogWyAgOTAzLjk2Mzk3
N10gIFs8ZmZmZmZmZmZjMDNhZDYzND5dIG1lcmdlX3JlbG9jX3Jvb3RzKzB4MTc0LzB4MjMw
IFtidHJmc10KSnVuIDE4IDIzOjM4OjMwIHZpeWJlbC1wYyBrZXJuZWw6IFsgIDkwMy45NjQw
MDddICBbPGZmZmZmZmZmYzAzYWU0MjI+XSBidHJmc19yZWNvdmVyX3JlbG9jYXRpb24rMHgz
OTIvMHgzZTAgW2J0cmZzXQpKdW4gMTggMjM6Mzg6MzAgdml5YmVsLXBjIGtlcm5lbDogWyAg
OTAzLjk2NDAzMl0gIFs8ZmZmZmZmZmZjMDM1OGRhNz5dIG9wZW5fY3RyZWUrMHgxYTk3LzB4
MjA5MCBbYnRyZnNdCkp1biAxOCAyMzozODozMCB2aXliZWwtcGMga2VybmVsOiBbICA5MDMu
OTY0MDQ5XSAgWzxmZmZmZmZmZmMwMzJlYjAwPl0gYnRyZnNfbW91bnQrMHg4NTAvMHg5MjAg
W2J0cmZzXQpKdW4gMTggMjM6Mzg6MzAgdml5YmVsLXBjIGtlcm5lbDogWyAgOTAzLjk2NDA2
MV0gIFs8ZmZmZmZmZmY4MTFmOGFhOD5dIG1vdW50X2ZzKzB4MzgvMHgxYzAKSnVuIDE4IDIz
OjM4OjMwIHZpeWJlbC1wYyBrZXJuZWw6IFsgIDkwMy45NjQwNjZdICBbPGZmZmZmZmZmODEx
OWNhNDU+XSA/IF9fYWxsb2NfcGVyY3B1KzB4MTUvMHgyMApKdW4gMTggMjM6Mzg6MzAgdml5
YmVsLXBjIGtlcm5lbDogWyAgOTAzLjk2NDA3M10gIFs8ZmZmZmZmZmY4MTIxNTIwYj5dIHZm
c19rZXJuX21vdW50KzB4NmIvMHgxMjAKSnVuIDE4IDIzOjM4OjMwIHZpeWJlbC1wYyBrZXJu
ZWw6IFsgIDkwMy45NjQwNzldICBbPGZmZmZmZmZmODEyMTgwNDQ+XSBkb19tb3VudCsweDIw
NC8weGIyMApKdW4gMTggMjM6Mzg6MzAgdml5YmVsLXBjIGtlcm5lbDogWyAgOTAzLjk2NDA4
NF0gIFs8ZmZmZmZmZmY4MTIxOGM3Yj5dIFN5U19tb3VudCsweDhiLzB4ZDAKSnVuIDE4IDIz
OjM4OjMwIHZpeWJlbC1wYyBrZXJuZWw6IFsgIDkwMy45NjQwODldICBbPGZmZmZmZmZmODE3
Y2FlY2Q+XSBzeXN0ZW1fY2FsbF9mYXN0cGF0aCsweDE2LzB4MWIKSnVuIDE4IDIzOjM4OjMw
IHZpeWJlbC1wYyBrZXJuZWw6IFsgIDkwMy45NjQwOTFdIENvZGU6IGUwIGZlIDhkIDcwIDAy
IDBmIGI3IGY2IDY2IDY2IDY2IDkwIDY2IDY2IDkwIGViIGNhIDBmIDFmIDg0IDAwIDAwIDAw
IDAwIDAwIDY2IDY2IDY2IDY2IDkwIDU1IDQ4IDg5IGU1IGI4IDAwIDAwIDAyIDAwIGYwIDBm
IGMxIDA3IDw4OT4gYzIgYzEgZWEgMTAgNjYgMzkgYzIgNzUgMDQgNWQgYzMgNjYgOTAgNDEg
ODkgZDAgMGYgYjcgZjIgYjggCkp1biAxOCAyMzozODozMSB2aXliZWwtcGMgc3lzdGVtZFsx
XTogU3RhcnRpbmcgQ2xlYW51cCBvZiBUZW1wb3JhcnkgRGlyZWN0b3JpZXMuLi4KSnVuIDE4
IDIzOjM4OjMxIHZpeWJlbC1wYyBzeXN0ZW1kLXRtcGZpbGVzWzI2MTddOiBbL3Vzci9saWIv
dG1wZmlsZXMuZC92YXIuY29uZjoxNF0gRHVwbGljYXRlIGxpbmUgZm9yIHBhdGggIi92YXIv
bG9nIiwgaWdub3JpbmcuCkp1biAxOCAyMzozODozMSB2aXliZWwtcGMgc3lzdGVtZFsxXTog
U3RhcnRlZCBDbGVhbnVwIG9mIFRlbXBvcmFyeSBEaXJlY3Rvcmllcy4=
--------------000208010203040008000100
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] CPU0 microcode updated early to revision 0x4, date = 2013-06-28
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.19.0-21-generic (buildd@lamiak) (gcc version 4.9.2 (Ubuntu 4.9.2-10ubuntu13) ) #21-Ubuntu SMP Sun Jun 14 18:31:11 UTC 2015 (Ubuntu 3.19.0-21.21-generic 3.19.8)
[    0.000000] Command line: BOOT_IMAGE=/@/boot/vmlinuz-3.19.0-21-generic root=UUID=358f485d-690d-436d-ad35-3a1f47329ed7 ro rootflags=subvol=@ noplymouth
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bafcefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bafcf000-0x00000000bb6cefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bb6cf000-0x00000000bb7cefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bb7cf000-0x00000000bb7fefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bb7ff000-0x00000000bb7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bb800000-0x00000000bbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1b000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd80000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000001fbffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000001fc000000-0x00000001ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000200000000-0x000000023bffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Hewlett-Packard HP ProBook 6550b/146D, BIOS 68CDE Ver. F.06 01/11/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x23c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   4 base 100000000 mask F00000000 write-back
[    0.000000]   5 base 200000000 mask FC0000000 write-back
[    0.000000]   6 base 23C000000 mask FFC000000 uncachable
[    0.000000]   7 disabled
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC  
[    0.000000] e820: last_pfn = 0xbb800 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fe5000, 0x01fe5fff] PGTABLE
[    0.000000] BRK [0x01fe6000, 0x01fe6fff] PGTABLE
[    0.000000] BRK [0x01fe7000, 0x01fe7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23be00000-0x23bffffff]
[    0.000000]  [mem 0x23be00000-0x23bffffff] page 2M
[    0.000000] BRK [0x01fe8000, 0x01fe8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x220000000-0x23bdfffff]
[    0.000000]  [mem 0x220000000-0x23bdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x21fffffff]
[    0.000000]  [mem 0x200000000-0x21fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbafcefff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbadfffff] page 2M
[    0.000000]  [mem 0xbae00000-0xbafcefff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbb7ff000-0xbb7fffff]
[    0.000000]  [mem 0xbb7ff000-0xbb7fffff] page 4k
[    0.000000] BRK [0x01fe9000, 0x01fe9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1fbffffff]
[    0.000000]  [mem 0x100000000-0x1fbffffff] page 2M
[    0.000000] BRK [0x01fea000, 0x01feafff] PGTABLE
[    0.000000] RAMDISK: [mem 0x34546000-0x3629afff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FDDC0 000024 (v02 HPQOEM)
[    0.000000] ACPI: XSDT 0x00000000BB7FE120 000084 (v01 HPQOEM SLIC-MPC 0000000F      01000013)
[    0.000000] ACPI: FACP 0x00000000BB7FC000 0000F4 (v03 HPQOEM 146D     0000000F HP   00000001)
[    0.000000] ACPI: DSDT 0x00000000BB7D8000 01E96A (v02 HPQOEM 146D     00000001 INTL 20060912)
[    0.000000] ACPI: FACS 0x00000000BB76D000 000040
[    0.000000] ACPI: HPET 0x00000000BB7FB000 000038 (v01 HPQOEM 146D     00000001 HP   00000001)
[    0.000000] ACPI: APIC 0x00000000BB7FA000 0000BC (v01 HPQOEM 146D     00000001 HP   00000001)
[    0.000000] ACPI: MCFG 0x00000000BB7F9000 00003C (v01 HPQOEM 146D     00000001 HP   00000001)
[    0.000000] ACPI: ASF! 0x00000000BB7F8000 0000A0 (v32 HPQOEM 146D     00000001 HP   00000001)
[    0.000000] ACPI: TCPA 0x00000000BB7F7000 000032 (v02 HPQOEM 146D     00000000 HP   00000001)
[    0.000000] ACPI: SSDT 0x00000000BB7D5000 000135 (v01 HPQOEM SataAhci 00001000 INTL 20060912)
[    0.000000] ACPI: SSDT 0x00000000BB7D4000 000314 (v01 HPQOEM PtidDevc 00001000 INTL 20060912)
[    0.000000] ACPI: SLIC 0x00000000BB7D3000 000176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
[    0.000000] ACPI: SSDT 0x00000000BB7D2000 000A10 (v01 PmRef  CpuPm    00003000 INTL 20060912)
[    0.000000] ACPI: SSDT 0x00000000BB7D1000 000288 (v01 PmRef  Cpu0Tst  00003000 INTL 20060912)
[    0.000000] ACPI: SSDT 0x00000000BB7D0000 000225 (v01 PmRef  ApTst    00003000 INTL 20060912)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023bffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x23bff5000-0x23bff9fff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880233600000-ffff88023b5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x23bffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xbafcefff]
[    0.000000]   node   0: [mem 0xbb7ff000-0xbb7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x1fbffffff]
[    0.000000]   node   0: [mem 0x200000000-0x23bffffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x23bffffff]
[    0.000000] On node 0 totalpages: 2043758
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11904 pages used for memmap
[    0.000000]   DMA32 zone: 761808 pages, LIFO batch:31
[    0.000000]   Normal zone: 20224 pages used for memmap
[    0.000000]   Normal zone: 1277952 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xbe000000-0xbfffffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbafcf000-0xbb6cefff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb6cf000-0xbb7cefff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb7cf000-0xbb7fefff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb800000-0xbbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc000000-0xbdffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbe000000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed13fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed14000-0xfed18fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed19000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1afff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1b000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffd7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffd80000-0xffffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x1fc000000-0x1ffffffff]
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff88023bc00000 s87040 r8192 d31744 u262144
[    0.000000] pcpu-alloc: s87040 r8192 d31744 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 2011545
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/@/boot/vmlinuz-3.19.0-21-generic root=UUID=358f485d-690d-436d-ad35-3a1f47329ed7 ro rootflags=subvol=@ noplymouth
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7930200K/8175032K available (8000K kernel code, 1232K rwdata, 3752K rodata, 1408K init, 1300K bss, 244832K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:16640 nr_irqs:488 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2659.952 MHz processor
[    0.000031] Calibrating delay loop (skipped), value calculated using timer frequency.. 5319.90 BogoMIPS (lpj=10639808)
[    0.000037] pid_max: default: 32768 minimum: 301
[    0.000044] ACPI: Core revision 20141107
[    0.012062] ACPI: All ACPI Tables successfully acquired
[    0.012728] Security Framework initialized
[    0.012748] AppArmor: AppArmor initialized
[    0.012751] Yama: becoming mindful.
[    0.013235] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.015055] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.015914] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.015931] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.016172] Initializing cgroup subsys memory
[    0.016181] Initializing cgroup subsys devices
[    0.016185] Initializing cgroup subsys freezer
[    0.016188] Initializing cgroup subsys net_cls
[    0.016192] Initializing cgroup subsys blkio
[    0.016195] Initializing cgroup subsys perf_event
[    0.016198] Initializing cgroup subsys net_prio
[    0.016202] Initializing cgroup subsys hugetlb
[    0.016226] CPU: Physical Processor ID: 0
[    0.016229] CPU: Processor Core ID: 0
[    0.016235] mce: CPU supports 9 MCE banks
[    0.016246] CPU0: Thermal monitoring enabled (TM1)
[    0.016254] process: using mwait in idle threads
[    0.016259] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.016359] Freeing SMP alternatives memory: 32K (ffffffff81e96000 - ffffffff81e9e000)
[    0.017528] ftrace: allocating 30086 entries in 118 pages
[    0.032121] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.071814] smpboot: CPU0: Intel(R) Core(TM) i5 CPU       M 480  @ 2.67GHz (fam: 06, model: 25, stepping: 05)
[    0.179820] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.179838] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.179841] ... version:                3
[    0.179843] ... bit width:              48
[    0.179844] ... generic registers:      4
[    0.179846] ... value mask:             0000ffffffffffff
[    0.179848] ... max period:             000000007fffffff
[    0.179849] ... fixed-purpose events:   3
[    0.179851] ... event mask:             000000070000000f
[    0.180665] x86: Booting SMP configuration:
[    0.180669] .... node  #0, CPUs:      #1
[    0.193956] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.194078]  #2
[    0.205273] CPU2 microcode updated early to revision 0x4, date = 2013-06-28
[    0.207552]  #3
[    0.220734] x86: Booted up 1 node, 4 CPUs
[    0.220742] smpboot: Total of 4 processors activated (21279.61 BogoMIPS)
[    0.223292] devtmpfs: initialized
[    0.225590] evm: security.selinux
[    0.225593] evm: security.SMACK64
[    0.225595] evm: security.SMACK64EXEC
[    0.225596] evm: security.SMACK64TRANSMUTE
[    0.225597] evm: security.SMACK64MMAP
[    0.225599] evm: security.ima
[    0.225600] evm: security.capability
[    0.225659] PM: Registering ACPI NVS region [mem 0xbb6cf000-0xbb7cefff] (1048576 bytes)
[    0.225823] pinctrl core: initialized pinctrl subsystem
[    0.225941] RTC time: 21:43:51, date: 06/18/15
[    0.226044] NET: Registered protocol family 16
[    0.227822] cpuidle: using governor ladder
[    0.231815] cpuidle: using governor menu
[    0.231921] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.231924] ACPI: bus type PCI registered
[    0.231927] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.232004] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.232008] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.232464] PCI: Using configuration type 1 for base access
[    0.232669] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.232671] mtrr: probably your BIOS does not setup all CPUs.
[    0.232673] mtrr: corrected configuration.
[    0.236263] ACPI: Added _OSI(Module Device)
[    0.236267] ACPI: Added _OSI(Processor Device)
[    0.236269] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.236271] ACPI: Added _OSI(Processor Aggregator Device)
[    0.240252] ACPI: Executed 1 blocks of module-level executable AML code
[    0.244742] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.253349] ACPI: Dynamic OEM Table Load:
[    0.253358] ACPI: SSDT 0xFFFF880231D03000 00047D (v01 PmRef  Cpu0Ist  00003000 INTL 20060912)
[    0.253779] ACPI: Dynamic OEM Table Load:
[    0.253786] ACPI: SSDT 0xFFFF880231DE1000 0008AA (v01 PmRef  Cpu0Cst  00003001 INTL 20060912)
[    0.254415] ACPI: Dynamic OEM Table Load:
[    0.254422] ACPI: SSDT 0xFFFF880231DBA400 000303 (v01 PmRef  ApIst    00003000 INTL 20060912)
[    0.254847] ACPI: Dynamic OEM Table Load:
[    0.254853] ACPI: SSDT 0xFFFF880231D0BA00 000119 (v01 PmRef  ApCst    00003000 INTL 20060912)
[    0.700912] ACPI: Interpreter enabled
[    0.700922] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20141107/hwxface-580)
[    0.700928] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20141107/hwxface-580)
[    0.700942] ACPI: (supports S0 S3 S4 S5)
[    0.700945] ACPI: Using IOAPIC for interrupt routing
[    0.700974] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.702424] ACPI: Power Resource [APPR] (off)
[    0.703928] ACPI: Power Resource [COMP] (off)
[    0.704194] ACPI: Power Resource [LPP] (on)
[    0.707417] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.707425] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.708715] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.708720] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.709402] PCI host bridge to bus 0000:00
[    0.709407] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.709409] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.709412] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.709414] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.709417] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xdfffffff]
[    0.709419] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfedfffff]
[    0.709421] pci_bus 0000:00: root bus resource [mem 0xfee01000-0xffffffff]
[    0.709430] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
[    0.709453] DMAR: Disabling batched IOTLB flush on Ironlake
[    0.709521] pci 0000:00:02.0: [8086:0046] type 00 class 0x030000
[    0.709531] pci 0000:00:02.0: reg 0x10: [mem 0xd0000000-0xd03fffff 64bit]
[    0.709536] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.709540] pci 0000:00:02.0: reg 0x20: [io  0x4050-0x4057]
[    0.709653] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.709680] pci 0000:00:16.0: reg 0x10: [mem 0xd4824000-0xd482400f 64bit]
[    0.709782] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.709869] pci 0000:00:19.0: [8086:10eb] type 00 class 0x020000
[    0.709894] pci 0000:00:19.0: reg 0x10: [mem 0xd4800000-0xd481ffff]
[    0.709905] pci 0000:00:19.0: reg 0x14: [mem 0xd482a000-0xd482afff]
[    0.709916] pci 0000:00:19.0: reg 0x18: [io  0x4020-0x403f]
[    0.710014] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.710055] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.710098] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.710122] pci 0000:00:1a.0: reg 0x10: [mem 0xd4829000-0xd48293ff]
[    0.710239] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.710280] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.710323] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.710346] pci 0000:00:1b.0: reg 0x10: [mem 0xd4820000-0xd4823fff 64bit]
[    0.710463] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.710506] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.710544] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.710662] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.710739] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    0.710856] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.710899] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.710939] pci 0000:00:1c.2: [8086:3b46] type 01 class 0x060400
[    0.711056] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.711099] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.711138] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
[    0.711256] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.711299] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.711347] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.711371] pci 0000:00:1d.0: reg 0x10: [mem 0xd4828000-0xd48283ff]
[    0.711490] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.711531] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.711570] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.711682] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.711719] pci 0000:00:1f.0: [8086:3b0b] type 00 class 0x060100
[    0.711898] pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
[    0.711924] pci 0000:00:1f.2: reg 0x10: [io  0x4048-0x404f]
[    0.711935] pci 0000:00:1f.2: reg 0x14: [io  0x405c-0x405f]
[    0.711945] pci 0000:00:1f.2: reg 0x18: [io  0x4040-0x4047]
[    0.711956] pci 0000:00:1f.2: reg 0x1c: [io  0x4058-0x405b]
[    0.711966] pci 0000:00:1f.2: reg 0x20: [io  0x4000-0x401f]
[    0.711977] pci 0000:00:1f.2: reg 0x24: [mem 0xd4827000-0xd48277ff]
[    0.712052] pci 0000:00:1f.2: PME# supported from D3hot
[    0.712133] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
[    0.712161] pci 0000:00:1f.6: reg 0x10: [mem 0xd4826000-0xd4826fff 64bit]
[    0.712374] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.712382] pci 0000:00:1c.0:   bridge window [mem 0xd4700000-0xd47fffff]
[    0.712499] pci 0000:00:1c.1: PCI bridge to [bus 02-42]
[    0.712505] pci 0000:00:1c.1:   bridge window [io  0x2000-0x3fff]
[    0.712510] pci 0000:00:1c.1:   bridge window [mem 0xd0700000-0xd46fffff]
[    0.712657] pci 0000:43:00.0: [1180:e822] type 00 class 0x080500
[    0.712678] pci 0000:43:00.0: MMC controller base frequency changed to 50Mhz.
[    0.712691] pci 0000:43:00.0: proprietary Ricoh MMC controller disabled (via firewire function)
[    0.712693] pci 0000:43:00.0: MMC cards are now supported by standard SDHCI controller
[    0.712719] pci 0000:43:00.0: reg 0x10: [mem 0xd0603000-0xd06030ff]
[    0.712915] pci 0000:43:00.0: supports D1 D2
[    0.712916] pci 0000:43:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.713036] pci 0000:43:00.1: [1180:e230] type 00 class 0x088000
[    0.713062] pci 0000:43:00.1: reg 0x10: [mem 0xd0602000-0xd06020ff]
[    0.713240] pci 0000:43:00.1: supports D1 D2
[    0.713242] pci 0000:43:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.713358] pci 0000:43:00.3: [1180:e832] type 00 class 0x0c0010
[    0.713384] pci 0000:43:00.3: reg 0x10: [mem 0xd0600000-0xd06007ff]
[    0.713563] pci 0000:43:00.3: supports D1 D2
[    0.713565] pci 0000:43:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.720818] pci 0000:00:1c.2: PCI bridge to [bus 43]
[    0.720833] pci 0000:00:1c.2:   bridge window [mem 0xd0600000-0xd06fffff]
[    0.720956] pci 0000:44:00.0: [8086:4239] type 00 class 0x028000
[    0.721000] pci 0000:44:00.0: reg 0x10: [mem 0xd0500000-0xd0501fff 64bit]
[    0.721217] pci 0000:44:00.0: PME# supported from D0 D3hot D3cold
[    0.721258] pci 0000:44:00.0: System wakeup disabled by ACPI
[    0.728774] pci 0000:00:1c.3: PCI bridge to [bus 44]
[    0.728788] pci 0000:00:1c.3:   bridge window [mem 0xd0500000-0xd05fffff]
[    0.728907] pci 0000:00:1e.0: PCI bridge to [bus 45] (subtractive decode)
[    0.728915] pci 0000:00:1e.0:   bridge window [mem 0xd0400000-0xd04fffff]
[    0.728923] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.728924] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.728926] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.728927] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    0.728929] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfedfffff] (subtractive decode)
[    0.728930] pci 0000:00:1e.0:   bridge window [mem 0xfee01000-0xffffffff] (subtractive decode)
[    0.729826] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.729872] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[    0.729916] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.729960] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.730004] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.730047] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.730091] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.730135] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.730177] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
[    0.730182] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.730187] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.730249] PCI host bridge to bus 0000:ff
[    0.730252] pci_bus 0000:ff: root bus resource [bus ff]
[    0.730258] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
[    0.730298] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
[    0.730340] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
[    0.730378] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
[    0.730415] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
[    0.730453] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
[    0.730801] ACPI: Enabled 6 GPEs in block 00 to 3F
[    0.730841] ACPI : EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.730955] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.730959] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.730964] vgaarb: loaded
[    0.730965] vgaarb: bridge control possible 0000:00:02.0
[    0.731190] SCSI subsystem initialized
[    0.731250] libata version 3.00 loaded.
[    0.731272] ACPI: bus type USB registered
[    0.731291] usbcore: registered new interface driver usbfs
[    0.731302] usbcore: registered new interface driver hub
[    0.731320] usbcore: registered new device driver usb
[    0.731445] PCI: Using ACPI for IRQ routing
[    0.741273] PCI: pci_cache_line_size set to 64 bytes
[    0.741400] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.741402] e820: reserve RAM buffer [mem 0xbafcf000-0xbbffffff]
[    0.741403] e820: reserve RAM buffer [mem 0xbb800000-0xbbffffff]
[    0.741511] NetLabel: Initializing
[    0.741514] NetLabel:  domain hash size = 128
[    0.741515] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.741528] NetLabel:  unlabeled traffic allowed by default
[    0.741605] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.741612] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.743656] Switched to clocksource hpet
[    0.749256] AppArmor: AppArmor Filesystem Enabled
[    0.749344] pnp: PnP ACPI init
[    0.749628] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.749632] system 00:00: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.749635] system 00:00: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    0.749637] system 00:00: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.749640] system 00:00: [mem 0xd4900000-0xd4900fff] has been reserved
[    0.749643] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.749645] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.749648] system 00:00: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.749651] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.749655] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.749777] pnp 00:01: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.749842] system 00:02: [io  0x0200-0x027f] has been reserved
[    0.749845] system 00:02: [io  0x1000-0x100f] has been reserved
[    0.749848] system 00:02: [io  0xffff] has been reserved
[    0.749851] system 00:02: [io  0xffff] has been reserved
[    0.749853] system 00:02: [io  0x0400-0x047f] could not be reserved
[    0.749856] system 00:02: [io  0x0500-0x057f] has been reserved
[    0.749858] system 00:02: [io  0xef80-0xef9f] has been reserved
[    0.749862] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.749895] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.750045] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 PNP0500 (disabled)
[    0.750321] pnp 00:05: [dma 0 disabled]
[    0.750382] pnp 00:05: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.750409] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.750434] pnp 00:07: Plug and Play ACPI device, IDs SYN0179 SYN0100 SYN0002 PNP0f13 (active)
[    0.750785] pnp: PnP ACPI: found 8 devices
[    0.757768] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02-42] add_size 200000
[    0.757798] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.757806] pci 0000:00:1c.1: BAR 15: assigned [mem 0xd4a00000-0xd4bfffff 64bit pref]
[    0.757811] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.757818] pci 0000:00:1c.0:   bridge window [mem 0xd4700000-0xd47fffff]
[    0.757829] pci 0000:00:1c.1: PCI bridge to [bus 02-42]
[    0.757833] pci 0000:00:1c.1:   bridge window [io  0x2000-0x3fff]
[    0.757840] pci 0000:00:1c.1:   bridge window [mem 0xd0700000-0xd46fffff]
[    0.757845] pci 0000:00:1c.1:   bridge window [mem 0xd4a00000-0xd4bfffff 64bit pref]
[    0.757855] pci 0000:00:1c.2: PCI bridge to [bus 43]
[    0.757861] pci 0000:00:1c.2:   bridge window [mem 0xd0600000-0xd06fffff]
[    0.757872] pci 0000:00:1c.3: PCI bridge to [bus 44]
[    0.757878] pci 0000:00:1c.3:   bridge window [mem 0xd0500000-0xd05fffff]
[    0.757890] pci 0000:00:1e.0: PCI bridge to [bus 45]
[    0.757896] pci 0000:00:1e.0:   bridge window [mem 0xd0400000-0xd04fffff]
[    0.757907] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.757909] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.757911] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.757912] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xdfffffff]
[    0.757913] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfedfffff]
[    0.757915] pci_bus 0000:00: resource 9 [mem 0xfee01000-0xffffffff]
[    0.757917] pci_bus 0000:01: resource 1 [mem 0xd4700000-0xd47fffff]
[    0.757918] pci_bus 0000:02: resource 0 [io  0x2000-0x3fff]
[    0.757920] pci_bus 0000:02: resource 1 [mem 0xd0700000-0xd46fffff]
[    0.757921] pci_bus 0000:02: resource 2 [mem 0xd4a00000-0xd4bfffff 64bit pref]
[    0.757923] pci_bus 0000:43: resource 1 [mem 0xd0600000-0xd06fffff]
[    0.757925] pci_bus 0000:44: resource 1 [mem 0xd0500000-0xd05fffff]
[    0.757927] pci_bus 0000:45: resource 1 [mem 0xd0400000-0xd04fffff]
[    0.757928] pci_bus 0000:45: resource 4 [io  0x0000-0x0cf7]
[    0.757930] pci_bus 0000:45: resource 5 [io  0x0d00-0xffff]
[    0.757931] pci_bus 0000:45: resource 6 [mem 0x000a0000-0x000bffff]
[    0.757932] pci_bus 0000:45: resource 7 [mem 0xc0000000-0xdfffffff]
[    0.757934] pci_bus 0000:45: resource 8 [mem 0xf0000000-0xfedfffff]
[    0.757935] pci_bus 0000:45: resource 9 [mem 0xfee01000-0xffffffff]
[    0.757964] NET: Registered protocol family 2
[    0.758155] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.758315] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.758517] TCP: Hash tables configured (established 65536 bind 65536)
[    0.758551] TCP: reno registered
[    0.758563] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.758595] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.758672] NET: Registered protocol family 1
[    0.758693] pci 0000:00:02.0: Video device with shadowed ROM
[    0.759381] PCI: CLS 64 bytes, default 64
[    0.759446] Trying to unpack rootfs image as initramfs...
[    1.193067] Freeing initrd memory: 30036K (ffff880034546000 - ffff88003629b000)
[    1.193104] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.193107] software IO TLB [mem 0xb6fcf000-0xbafcf000] (64MB) mapped at [ffff8800b6fcf000-ffff8800bafcefff]
[    1.193374] microcode: CPU0 sig=0x20655, pf=0x10, revision=0x4
[    1.193382] microcode: CPU1 sig=0x20655, pf=0x10, revision=0x4
[    1.193391] microcode: CPU2 sig=0x20655, pf=0x10, revision=0x4
[    1.193397] microcode: CPU3 sig=0x20655, pf=0x10, revision=0x4
[    1.193472] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.193500] Scanning for low memory corruption every 60 seconds
[    1.193902] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    1.193939] Initialise system trusted keyring
[    1.193966] audit: initializing netlink subsys (disabled)
[    1.193986] audit: type=2000 audit(1434663832.084:1): initialized
[    1.194289] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.195525] zpool: loaded
[    1.195529] zbud: loaded
[    1.195686] VFS: Disk quotas dquot_6.5.2
[    1.195740] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.196195] fuse init (API version 7.23)
[    1.196343] Key type big_key registered
[    1.196838] Key type asymmetric registered
[    1.196842] Asymmetric key parser 'x509' registered
[    1.196883] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.196936] io scheduler noop registered
[    1.196940] io scheduler deadline registered (default)
[    1.196968] io scheduler cfq registered
[    1.198049] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    1.198056] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    1.198076] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    1.198082] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    1.198100] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    1.198103] pci 0000:43:00.0: Signaling PME through PCIe PME interrupt
[    1.198106] pci 0000:43:00.1: Signaling PME through PCIe PME interrupt
[    1.198109] pci 0000:43:00.3: Signaling PME through PCIe PME interrupt
[    1.198114] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    1.198132] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    1.198135] pci 0000:44:00.0: Signaling PME through PCIe PME interrupt
[    1.198140] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    1.198146] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.198183] pciehp 0000:00:1c.1:pcie04: Slot #1 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl+ LLActRep+
[    1.198222] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
[    1.198226] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.198260] vesafb: mode is 1366x768x32, linelength=5504, pages=0
[    1.198262] vesafb: scrolling: redraw
[    1.198264] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.199742] vesafb: framebuffer at 0xc0000000, mapped to 0xffffc90010f00000, using 4160k, total 4160k
[    1.202346] Console: switching to colour frame buffer device 170x48
[    1.204650] fb0: VESA VGA frame buffer device
[    1.204701] intel_idle: MWAIT substates: 0x1120
[    1.204702] intel_idle: v0.4 model 0x25
[    1.204703] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.205075] ACPI: AC Adapter [AC] (on-line)
[    1.205297] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    1.205332] ACPI: Sleep Button [SLPB]
[    1.205383] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    1.205432] ACPI: Lid Switch [LID]
[    1.205482] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.205511] ACPI: Power Button [PWRF]
[    1.211533] thermal LNXTHERM:00: registered as thermal_zone0
[    1.211559] ACPI: Thermal Zone [EXTZ] (46 C)
[    1.211626] thermal LNXTHERM:01: registered as thermal_zone1
[    1.211649] ACPI: Thermal Zone [EX2Z] (0 C)
[    1.211743] thermal LNXTHERM:02: registered as thermal_zone2
[    1.211767] ACPI: Thermal Zone [PWMZ] (0 C)
[    1.214830] thermal LNXTHERM:03: registered as thermal_zone3
[    1.214854] ACPI: Thermal Zone [LOCZ] (49 C)
[    1.215280] thermal LNXTHERM:04: registered as thermal_zone4
[    1.215303] ACPI: Thermal Zone [GFXZ] (0 C)
[    1.232402] thermal LNXTHERM:05: registered as thermal_zone5
[    1.232427] ACPI: Thermal Zone [BATZ] (29 C)
[    1.247004] thermal LNXTHERM:06: registered as thermal_zone6
[    1.247029] ACPI: Thermal Zone [EGXZ] (0 C)
[    1.247258] thermal LNXTHERM:07: registered as thermal_zone7
[    1.248331] ACPI: Thermal Zone [CPUZ] (68 C)
[    1.249573] thermal LNXTHERM:08: registered as thermal_zone8
[    1.250624] ACPI: Thermal Zone [MCHZ] (62 C)
[    1.251835] thermal LNXTHERM:09: registered as thermal_zone9
[    1.252865] ACPI: Thermal Zone [PCHZ] (67 C)
[    1.253928] GHES: HEST is not enabled!
[    1.255098] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.256249] serial 00:04: [io  0x03f8-0x03ff]
[    1.256348] serial 00:04: [irq 4]
[    1.256977] serial 00:04: activated
[    1.278798] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.282511] Linux agpgart interface v0.103
[    1.283674] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    1.284847] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.286543] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    1.287931] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    1.290004] tpm_tis 00:01: 1.2 TPM (device-id 0xB, rev-id 16)
[    1.324485] ACPI: Battery Slot [BAT0] (battery present)
[    1.325674] ACPI: Battery Slot [BAT1] (battery absent)
[    1.503860] tpm_tis 00:01: TPM is disabled/deactivated (0x7)
[    1.508005] brd: module loaded
[    1.509784] loop: module loaded
[    1.511086] libphy: Fixed MDIO Bus: probed
[    1.512193] tun: Universal TUN/TAP device driver, 1.6
[    1.513288] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.514435] PPP generic driver version 2.4.2
[    1.515587] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.516689] ehci-pci: EHCI PCI platform driver
[    1.517975] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.519076] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.520204] ehci-pci 0000:00:1a.0: debug port 2
[    1.525204] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.525222] ehci-pci 0000:00:1a.0: irq 16, io mem 0xd4829000
[    1.535750] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.536881] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.537974] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.539065] usb usb1: Product: EHCI Host Controller
[    1.540159] usb usb1: Manufacturer: Linux 3.19.0-21-generic ehci_hcd
[    1.541248] usb usb1: SerialNumber: 0000:00:1a.0
[    1.542463] hub 1-0:1.0: USB hub found
[    1.543557] hub 1-0:1.0: 2 ports detected
[    1.544910] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.545993] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.547097] ehci-pci 0000:00:1d.0: debug port 2
[    1.552126] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.552141] ehci-pci 0000:00:1d.0: irq 20, io mem 0xd4828000
[    1.563753] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.564878] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.565976] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.567079] usb usb2: Product: EHCI Host Controller
[    1.568183] usb usb2: Manufacturer: Linux 3.19.0-21-generic ehci_hcd
[    1.569289] usb usb2: SerialNumber: 0000:00:1d.0
[    1.570509] hub 2-0:1.0: USB hub found
[    1.571617] hub 2-0:1.0: 2 ports detected
[    1.572833] ehci-platform: EHCI generic platform driver
[    1.573944] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.575054] ohci-pci: OHCI PCI platform driver
[    1.576176] ohci-platform: OHCI generic platform driver
[    1.577284] uhci_hcd: USB Universal Host Controller Interface driver
[    1.578436] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.581241] i8042: Detected active multiplexing controller, rev 1.1
[    1.583096] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.584184] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.585271] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.586340] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.587405] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.588570] mousedev: PS/2 mouse device common for all mice
[    1.589786] rtc_cmos 00:03: RTC can wake from S4
[    1.590996] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.592075] rtc_cmos 00:03: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.593132] i2c /dev entries driver
[    1.594299] device-mapper: uevent: version 1.0.3
[    1.595451] device-mapper: ioctl: 4.29.0-ioctl (2014-10-28) initialised: dm-devel@redhat.com
[    1.596557] ledtrig-cpu: registered to indicate activity on CPUs
[    1.597995] PCCT header not found.
[    1.599099] ACPI PCC probe failed.
[    1.600297] TCP: cubic registered
[    1.601480] NET: Registered protocol family 10
[    1.602854] NET: Registered protocol family 17
[    1.603997] Key type dns_resolver registered
[    1.605463] Loading compiled-in X.509 certificates
[    1.607439] Loaded X.509 cert 'Magrathea: Glacier signing key: 333a84cc9705ddb26e1cdce388afcedc2deff761'
[    1.608567] registered taskstats version 1
[    1.611866] Key type trusted registered
[    1.615501] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.616439] Key type encrypted registered
[    1.616454] AppArmor: AppArmor sha1 policy hashing enabled
[    1.667877] tpm_tis 00:01: A TPM error (7) occurred attempting to read a pcr value
[    1.669052] ima: No TPM chip found, activating TPM-bypass!
[    1.670229] evm: HMAC attrs: 0x1
[    1.671954]   Magic number: 3:266:753
[    1.673132] tty ttyS4: hash matches
[    1.674418] rtc_cmos 00:03: setting system clock to 2015-06-18 21:43:53 UTC (1434663833)
[    1.676745] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.677975] EDD information not available.
[    1.679275] PM: Hibernation image not present or could not be loaded.
[    1.679708] Freeing unused kernel memory: 1408K (ffffffff81d36000 - ffffffff81e96000)
[    1.680972] Write protecting the kernel read-only data: 12288k
[    1.682511] Freeing unused kernel memory: 180K (ffff8800017d3000 - ffff880001800000)
[    1.683894] Freeing unused kernel memory: 344K (ffff880001baa000 - ffff880001c00000)
[    1.703915] random: systemd-udevd urandom read with 8 bits of entropy available
[    1.730121] wmi: Mapper loaded
[    1.735106] pps_core: LinuxPPS API ver. 1 registered
[    1.736854] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.740668] PTP clock support registered
[    1.742787] sdhci: Secure Digital Host Controller Interface driver
[    1.744571] sdhci: Copyright(c) Pierre Ossman
[    1.746518] [drm] Initialized drm 1.1.0 20060810
[    1.748593] sdhci-pci 0000:43:00.0: SDHCI controller found [1180:e822] (rev 1)
[    1.750202] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    1.750298] sdhci-pci 0000:43:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.750308] sdhci-pci 0000:43:00.0: No vmmc regulator found
[    1.750309] sdhci-pci 0000:43:00.0: No vqmmc regulator found
[    1.751376] sdhci-pci 0000:43:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.759188] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    1.761479] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.769168] sdhci-pci 0000:43:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.772675] mmc0: SDHCI controller on PCI [0000:43:00.0] using DMA
[    1.835904] firewire_ohci 0000:43:00.3: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
[    1.855822] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.887912] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.991747] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    1.993211] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.993679] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 64:31:50:8f:cb:77
[    1.993680] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    1.993734] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: FFFFFF-0FF
[    1.993774] ahci 0000:00:1f.2: version 3.0
[    1.994114] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    2.000585] hub 1-1:1.0: USB hub found
[    2.002635] hub 1-1:1.0: 6 ports detected
[    2.007915] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x37 impl SATA mode
[    2.009342] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
[    2.024385] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    2.025821] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.027628] hub 2-1:1.0: USB hub found
[    2.029228] hub 2-1:1.0: 8 ports detected
[    2.040601] scsi host0: ahci
[    2.042200] scsi host1: ahci
[    2.043687] scsi host2: ahci
[    2.045195] scsi host3: ahci
[    2.046643] scsi host4: ahci
[    2.048073] scsi host5: ahci
[    2.049388] ata1: SATA max UDMA/133 abar m2048@0xd4827000 port 0xd4827100 irq 29
[    2.050674] ata2: SATA max UDMA/133 abar m2048@0xd4827000 port 0xd4827180 irq 29
[    2.051955] ata3: SATA max UDMA/133 abar m2048@0xd4827000 port 0xd4827200 irq 29
[    2.053222] ata4: DUMMY
[    2.054484] ata5: SATA max UDMA/133 abar m2048@0xd4827000 port 0xd4827300 irq 29
[    2.055771] ata6: SATA max UDMA/133 abar m2048@0xd4827000 port 0xd4827380 irq 29
[    2.057817] [drm] Memory usable by graphics device = 2048M
[    2.059105] checking generic (c0000000 410000) vs hw (c0000000 10000000)
[    2.059106] fb: switching to inteldrmfb from VESA VGA
[    2.060406] Console: switching to colour dummy device 80x25
[    2.060478] [drm] Replacing VGA console driver
[    2.123927] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.123936] [drm] Driver supports precise vblank timestamp query.
[    2.124032] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.143305] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.146056] acpi device:0d: registered as cooling_device4
[    2.146164] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input12
[    2.146587] [drm] Initialized i915 1.6.0 20141121 for 0000:00:02.0 on minor 0
[    2.153916] mmc0: new SD card at address edba
[    2.156136] Driver 'mmcblk' needs updating - please use bus_type methods
[    2.156241] mmcblk0: mmc0:edba SD512 488 MiB 
[    2.157509]  mmcblk0: p1
[    2.162251] fbcon: inteldrmfb (fb0) is primary device
[    2.191901] tsc: Refined TSC clocksource calibration: 2659.999 MHz
[    2.276009] usb 1-1.1: new full-speed USB device number 3 using ehci-pci
[    2.304028] usb 2-1.1: new full-speed USB device number 3 using ehci-pci
[    2.336047] firewire_core 0000:43:00.3: created device fw0: GUID 5566778811223344, S400
[    2.372669] usb 1-1.1: New USB device found, idVendor=03f0, idProduct=231d
[    2.372672] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.372675] usb 1-1.1: Product: HP Integrated Module
[    2.372677] usb 1-1.1: Manufacturer: Broadcom Corp
[    2.375894] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.376413] ata1.00: unexpected _GTF length (8)
[    2.376553] ata1.00: ATA-8: KINGSTON SNV425S2128GB, C091126a, max UDMA/100
[    2.376556] ata1.00: 250069680 sectors, multi 16: LBA48 
[    2.377110] ata1.00: unexpected _GTF length (8)
[    2.377245] ata1.00: configured for UDMA/100
[    2.377462] scsi 0:0:0:0: Direct-Access     ATA      KINGSTON SNV425S 126a PQ: 0 ANSI: 5
[    2.377911] sd 0:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
[    2.377925] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.378058] sd 0:0:0:0: [sda] Write Protect is off
[    2.378060] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.378135] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.379567]  sda: sda1 sda2
[    2.380001] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.444019] usb 1-1.3: new full-speed USB device number 4 using ehci-pci
[    2.452502] usb 2-1.1: New USB device found, idVendor=046d, idProduct=c24a
[    2.452505] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.452508] usb 2-1.1: Product: Gaming Mouse G600
[    2.452510] usb 2-1.1: Manufacturer: Logitech
[    2.452513] usb 2-1.1: SerialNumber: B62250C02AEF0012
[    2.456978] hidraw: raw HID events driver (C) Jiri Kosina
[    2.469023] usbcore: registered new interface driver usbhid
[    2.469023] usbhid: USB HID core driver
[    2.470644] input: Logitech Gaming Mouse G600 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.0/0003:046D:C24A.0001/input/input13
[    2.470796] hid-generic 0003:046D:C24A.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech Gaming Mouse G600] on usb-0000:00:1d.0-1.1/input0
[    2.489196] input: Logitech Gaming Mouse G600 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.1/0003:046D:C24A.0002/input/input14
[    2.531520] psmouse serio4: synaptics: queried max coordinates: x [..5560], y [..4778]
[    2.538134] usb 1-1.3: New USB device found, idVendor=138a, idProduct=0007
[    2.538137] usb 1-1.3: New USB device strings: Mfr=0, Product=0, SerialNumber=1
[    2.538140] usb 1-1.3: SerialNumber: 002084ed2d80
[    2.544141] hid-generic 0003:046D:C24A.0002: input,hiddev0,hidraw1: USB HID v1.11 Keyboard [Logitech Gaming Mouse G600] on usb-0000:00:1d.0-1.1/input1
[    2.601628] psmouse serio4: synaptics: Touchpad model: 1, fw: 7.4, id: 0x1c0b1, caps: 0xd04773/0xa40000/0xa0400, board id: 0, fw id: 643134
[    2.608014] usb 1-1.5: new high-speed USB device number 5 using ehci-pci
[    2.645928] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input11
[    2.695967] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.697988] ata2.00: unexpected _GTF length (8)
[    2.699530] ata2.00: ATA-8: TOSHIBA MQ01ABD075, AX001C, max UDMA/100
[    2.699533] ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.703057] ata2.00: unexpected _GTF length (8)
[    2.704595] ata2.00: configured for UDMA/100
[    2.704971] scsi 1:0:0:0: Direct-Access     ATA      TOSHIBA MQ01ABD0 1C   PQ: 0 ANSI: 5
[    2.705339] sd 1:0:0:0: [sdb] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    2.705340] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    2.705385] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.705496] sd 1:0:0:0: [sdb] Write Protect is off
[    2.705498] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.705543] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.809065]  sdb: sdb1
[    2.809513] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.856069] Console: switching to colour frame buffer device 170x48
[    2.902875] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    2.904249] i915 0000:00:02.0: registered panic notifier
[    3.023983] ata3: SATA link down (SStatus 0 SControl 300)
[    3.192219] Switched to clocksource tsc
[    3.344000] ata5: SATA link down (SStatus 0 SControl 300)
[    3.664035] ata6: SATA link down (SStatus 0 SControl 300)
[    3.884661] usb 1-1.5: New USB device found, idVendor=05c8, idProduct=0403
[    3.886059] usb 1-1.5: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    3.887351] usb 1-1.5: Product: HP Webcam [2 MP Fixed]
[    3.888653] usb 1-1.5: Manufacturer: Foxlink
[    3.889929] usb 1-1.5: SerialNumber: 200909240102
[    4.047988] raid6: sse2x1    6448 MB/s
[    4.115985] raid6: sse2x2    7574 MB/s
[    4.183993] raid6: sse2x4    8409 MB/s
[    4.184006] raid6: using algorithm sse2x4 (8409 MB/s)
[    4.184024] raid6: using ssse3x2 recovery algorithm
[    4.185311] xor: measuring software checksum speed
[    4.224034]    prefetch64-sse: 12149.000 MB/sec
[    4.264040]    generic_sse:  9665.000 MB/sec
[    4.264056] xor: using function: prefetch64-sse (12149.000 MB/sec)
[    4.278287] Btrfs loaded
[    4.528918] BTRFS: device fsid 21873ba7-438a-4fbf-a051-ace28bffd264 devid 1 transid 1994 /dev/sdb1
[    4.529442] BTRFS: device fsid 358f485d-690d-436d-ad35-3a1f47329ed7 devid 1 transid 40210 /dev/sda1
[    4.537672] BTRFS info (device sda1): disk space caching is enabled
[    4.666208] BTRFS: detected SSD devices, enabling SSD mode
[    5.130526] systemd[1]: Inserted module 'autofs4'
[    5.136118] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT -GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID -ELFUTILS +KMOD -IDN)
[    5.136315] systemd[1]: Detected architecture x86-64.
[    5.137687] systemd[1]: Set hostname to <viybel-pc>.
[    5.321505] systemd[1]: [/lib/systemd/system/sec.service:1] Assignment outside of section. Ignoring.
[    5.321571] systemd[1]: [/lib/systemd/system/sec.service:2] Assignment outside of section. Ignoring.
[    5.322296] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    5.322330] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    5.322416] systemd[1]: Reached target Remote File Systems (Pre).
[    5.322444] systemd[1]: Starting Remote File Systems (Pre).
[    5.322644] systemd[1]: Reached target Encrypted Volumes.
[    5.322689] systemd[1]: Starting Encrypted Volumes.
[    5.322910] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    5.322952] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    5.323210] systemd[1]: Created slice Root Slice.
[    5.323264] systemd[1]: Starting Root Slice.
[    5.323334] systemd[1]: Listening on udev Control Socket.
[    5.323342] systemd[1]: Starting udev Control Socket.
[    5.326049] systemd[1]: Created slice User and Session Slice.
[    5.326071] systemd[1]: Starting User and Session Slice.
[    5.328777] systemd[1]: Listening on Journal Socket.
[    5.328813] systemd[1]: Starting Journal Socket.
[    5.332726] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    5.332748] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    5.335491] systemd[1]: Listening on udev Kernel Socket.
[    5.335512] systemd[1]: Starting udev Kernel Socket.
[    5.339532] systemd[1]: Listening on Journal Socket (/dev/log).
[    5.339555] systemd[1]: Starting Journal Socket (/dev/log).
[    5.343587] systemd[1]: Listening on Delayed Shutdown Socket.
[    5.343609] systemd[1]: Starting Delayed Shutdown Socket.
[    5.346313] systemd[1]: Listening on Journal Audit Socket.
[    5.346335] systemd[1]: Starting Journal Audit Socket.
[    5.350246] systemd[1]: Created slice System Slice.
[    5.350281] systemd[1]: Starting System Slice.
[    5.350897] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    5.354676] systemd[1]: Starting Setup Virtual Console...
[    5.357242] systemd[1]: Mounting POSIX Message Queue File System...
[    5.360636] systemd[1]: Starting Increase datagram queue length...
[    5.364328] systemd[1]: Created slice system-getty.slice.
[    5.364370] systemd[1]: Starting system-getty.slice.
[    5.366930] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[    5.366945] systemd[1]: Starting system-systemd\x2dfsck.slice.
[    5.369485] systemd[1]: Reached target Slices.
[    5.369499] systemd[1]: Starting Slices.
[    5.369998] systemd[1]: Starting Nameserver information manager...
[    5.374797] systemd[1]: Starting Uncomplicated firewall...
[    5.377254] systemd[1]: Starting Load Kernel Modules...
[    5.379431] systemd[1]: Mounting Huge Pages File System...
[    5.381686] systemd[1]: Starting udev Coldplug all Devices...
[    5.383801] systemd[1]: Mounting Debug File System...
[    5.402469] systemd[1]: Started Set Up Additional Binary Formats.
[    5.403758] systemd[1]: Listening on fsck to fsckd communication Socket.
[    5.405151] systemd[1]: Starting fsck to fsckd communication Socket.
[    5.406417] systemd[1]: Mounted Huge Pages File System.
[    5.408543] systemd[1]: Mounted Debug File System.
[    5.411669] systemd[1]: Mounted POSIX Message Queue File System.
[    5.413184] systemd[1]: Started Create list of required static device nodes for the current kernel.
[    5.415345] lp: driver loaded but no devices found
[    5.417195] systemd[1]: Started Setup Virtual Console.
[    5.418380] systemd[1]: Started Increase datagram queue length.
[    5.421526] systemd[1]: Started Uncomplicated firewall.
[    5.423539] ppdev: user-space parallel port driver
[    5.425392] systemd[1]: Started Nameserver information manager.
[    5.427567] parport_pc 00:05: reported by Plug and Play ACPI
[    5.428638] parport0: PC-style at 0x378 (0x778), irq 5, using FIFO [PCSPP,TRISTATE,COMPAT,EPP,ECP]
[    5.446185] systemd[1]: Listening on Syslog Socket.
[    5.447371] systemd[1]: Starting Syslog Socket.
[    5.449407] systemd[1]: Starting Journal Service...
[    5.451280] systemd[1]: Starting Create Static Device Nodes in /dev...
[    5.453840] systemd[1]: Started udev Coldplug all Devices.
[    5.455606] systemd[1]: Starting udev Wait for Complete Device Initialization...
[    5.481772] systemd[1]: Started Create Static Device Nodes in /dev.
[    5.484564] systemd[1]: Starting udev Kernel Device Manager...
[    5.501755] systemd[1]: Started Journal Service.
[    5.524486] lp0: using parport0 (interrupt-driven).
[    5.671983] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.675885] Blacklisted intel_ips for HP ProBook
[    5.682612] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000047f (\PMIO) (20141107/utaddress-258)
[    5.682619] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.682624] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20141107/utaddress-258)
[    5.682627] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.682628] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20141107/utaddress-258)
[    5.682632] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.682633] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20141107/utaddress-258)
[    5.682636] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.682638] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    5.699460] cfg80211: Calling CRDA to update world regulatory domain
[    5.704838] hp_accel: hardware type HPB655x found
[    5.705453] lis3lv02d: 8 bits sensor found
[    5.715723] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    5.715727] Copyright(c) 2003- 2014 Intel Corporation
[    5.715873] iwlwifi 0000:44:00.0: can't disable ASPM; OS doesn't have ASPM control
[    5.718276] iwlwifi 0000:44:00.0: Direct firmware load for iwlwifi-6000-6.ucode failed with error -2
[    5.718808] iwlwifi 0000:44:00.0: Direct firmware load for iwlwifi-6000-5.ucode failed with error -2
[    5.723818] iwlwifi 0000:44:00.0: loaded firmware version 9.221.4.1 build 25532 op_mode iwldvm
[    5.744253] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input15
[    5.759887] iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    5.759892] iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[    5.759894] iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[    5.759897] iwlwifi 0000:44:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
[    5.759957] iwlwifi 0000:44:00.0: L1 Enabled - LTR Disabled
[    5.766645] iwlwifi 0000:44:00.0: RF_KILL bit toggled to disable radio.
[    5.817604] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    5.822475] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    5.836112] snd_hda_core: module verification failed: signature and/or  required key missing - tainting kernel
[    5.849386] media: Linux media interface: v0.10
[    5.859948] Linux video capture interface: v2.00
[    5.883429] snd_hda_codec_idt hdaudioC0D0: autoconfig for 92HD75B3X5: line_outs=1 (0xf/0x0/0x0/0x0/0x0) type:line
[    5.883436] snd_hda_codec_idt hdaudioC0D0:    speaker_outs=1 (0xd/0x0/0x0/0x0/0x0)
[    5.883439] snd_hda_codec_idt hdaudioC0D0:    hp_outs=1 (0xa/0x0/0x0/0x0/0x0)
[    5.883441] snd_hda_codec_idt hdaudioC0D0:    mono: mono_out=0x0
[    5.883443] snd_hda_codec_idt hdaudioC0D0:    inputs:
[    5.883446] snd_hda_codec_idt hdaudioC0D0:      Internal Mic=0xc
[    5.883449] snd_hda_codec_idt hdaudioC0D0:      Mic=0xb
[    5.883451] snd_hda_codec_idt hdaudioC0D0:      Line=0xe
[    5.894267] Adding 7812092k swap on /dev/sda2.  Priority:-1 extents:1 across:7812092k SSFS
[    5.900730] uvcvideo: Found UVC 1.00 device HP Webcam [2 MP Fixed] (05c8:0403)
[    5.937377] input: HP Webcam [2 MP Fixed] as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5:1.0/input/input21
[    5.938500] usbcore: registered new interface driver uvcvideo
[    5.938501] USB Video Class driver (1.1.1)
[    5.941371] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[    5.941473] input: HDA Intel MID Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
[    5.941554] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
[    5.941633] input: HDA Intel MID Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input19
[    5.941723] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input22
[    5.941806] input: HDA Intel MID HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input23
[    5.941887] input: HDA Intel MID HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input24
[    5.947811] input: HP WMI hotkeys as /devices/virtual/input/input20
[    5.955334] random: nonblocking pool is initialized
[    5.955765] cfg80211: World regulatory domain updated:
[    5.955768] cfg80211:  DFS Master region: unset
[    5.955770] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    5.955773] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.955776] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.955778] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.955780] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.955782] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    6.431185] WARNING! power/level is deprecated; use power/control instead
[    6.449075] Bluetooth: Core ver 2.20
[    6.449105] NET: Registered protocol family 31
[    6.449107] Bluetooth: HCI device and connection manager initialized
[    6.449113] Bluetooth: HCI socket layer initialized
[    6.449116] Bluetooth: L2CAP socket layer initialized
[    6.449123] Bluetooth: SCO socket layer initialized
[    6.454106] usbcore: registered new interface driver btusb
[    6.868249] BTRFS info (device sda1): disk space caching is enabled
[    6.921005] systemd-journald[322]: Received request to flush runtime journal from PID 1
[    7.063698] systemd-journald[322]: File /var/log/journal/8ec6315440a84adc97fb293de5d6093f/system.journal corrupted or uncleanly shut down, renaming and replacing.
[    7.215373] audit: type=1400 audit(1434663839.033:2): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/sbin/dhclient" pid=641 comm="apparmor_parser"
[    7.215383] audit: type=1400 audit(1434663839.033:3): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=641 comm="apparmor_parser"
[    7.215388] audit: type=1400 audit(1434663839.033:4): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=641 comm="apparmor_parser"
[    7.215392] audit: type=1400 audit(1434663839.033:5): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/connman/scripts/dhclient-script" pid=641 comm="apparmor_parser"
[    7.231972] audit: type=1400 audit(1434663839.049:6): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/telepathy/mission-control-5" pid=641 comm="apparmor_parser"
[    7.231980] audit: type=1400 audit(1434663839.049:7): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/telepathy/telepathy-*" pid=641 comm="apparmor_parser"
[    7.231985] audit: type=1400 audit(1434663839.049:8): apparmor="STATUS" operation="profile_load" profile="unconfined" name="pxgsettings" pid=641 comm="apparmor_parser"
[    7.231989] audit: type=1400 audit(1434663839.049:9): apparmor="STATUS" operation="profile_load" profile="unconfined" name="sanitized_helper" pid=641 comm="apparmor_parser"
[    7.231993] audit: type=1400 audit(1434663839.049:10): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/telepathy/telepathy-ofono" pid=641 comm="apparmor_parser"
[    7.241032] audit: type=1400 audit(1434663839.061:11): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/sbin/cups-browsed" pid=641 comm="apparmor_parser"
[    7.657073] Process accounting resumed
[    8.702037] systemd-journald[322]: File /var/log/journal/8ec6315440a84adc97fb293de5d6093f/user-1000.journal corrupted or uncleanly shut down, renaming and replacing.
[   10.771179] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
[   16.156572] vboxdrv: Found 4 processor cores.
[   16.161252] vboxdrv: fAsync=0 offMin=0xda offMax=0xe51
[   16.161410] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   16.161413] vboxdrv: Successfully loaded version 4.3.26_Ubuntu (interface 0x001a000a).
[   16.221188] vboxpci: IOMMU not found (not registered)
[  249.579279] perf interrupt took too long (2507 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[  970.359648] Process accounting resumed


--------------000208010203040008000100--
