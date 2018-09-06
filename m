Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr1-f41.google.com ([209.85.221.41]:42661 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbeIFN5H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2018 09:57:07 -0400
Received: by mail-wr1-f41.google.com with SMTP id v17-v6so10545197wrr.9
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Sep 2018 02:22:31 -0700 (PDT)
Received: from ?IPv6:2a02:908:2210:9e40:b0d8:11b1:d906:8193? ([2a02:908:2210:9e40:b0d8:11b1:d906:8193])
        by smtp.gmail.com with ESMTPSA id x16-v6sm5807449wrm.69.2018.09.06.02.22.28
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Sep 2018 02:22:29 -0700 (PDT)
From: =?UTF-8?Q?Stefan_L=c3=b6wen?= <stefan.loewen@gmail.com>
Subject: btrfs send hung in pipe_wait
To: linux-btrfs@vger.kernel.org
Message-ID: <e1371e79-f5d1-494b-a6ea-3d8d888bf1d3@gmail.com>
Date: Thu, 6 Sep 2018 11:22:23 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------1CD475EC96BFB3B804600C07"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1CD475EC96BFB3B804600C07
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello linux-btrfs,

I'm trying to clone a subvolume with 'btrfs send' but it always hangs 
for hours.

I tested this on multiple systems. All showed the same result:
- Manjaro (btrfs-progs v4.17.1; linux v4.18.5-1-MANJARO)
- Ubuntu 18.04 in VirtualBox (btrfs-progs v4.15.1; linux v4.15.0-33-generic)
- ArchLinux in VirtualBox (btrfs-progs v4.17.1; linux v4.18.5-arch1-1-ARCH)
All following logs are from the ArchLinux VM.

To make sure it's not the 'btrfs receive' at fault I tried sending into 
a file using the following command:
'strace -o btrfs-send.strace btrfs send -vvv -f intenso_white.snapshot 
/mnt/intenso_white/@data/.snapshots/test-snapshot'

The 'btrfs send' process always copies around 1.2-1.4G of data, then 
stops all disk IO and fully loads one cpu core. btrfs scrub found 0 
errors. Neither did btrfsck. 'btrfs device stats' is all 0.

I would be thankful for all ideas and tips.

Regards
Stefan

---------------------------------------------

The btrfs-send.strace is attached. So is the dmesg.log during the hang.

Stack traces of the hung process:
--- /proc/3022/task/3022/stack ---
[<0>] 0xffffffffffffffff
--- /proc/3022/task/3023/stack ---
[<0>] pipe_wait+0x6c/0xb0
[<0>] splice_from_pipe_next.part.3+0x24/0xa0
[<0>] __splice_from_pipe+0x43/0x180
[<0>] splice_from_pipe+0x5d/0x90
[<0>] default_file_splice_write+0x15/0x20
[<0>] __se_sys_splice+0x31b/0x770
[<0>] do_syscall_64+0x5b/0x170
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[<0>] 0xffffffffffffffff

[vagrant@archlinux mnt]$ uname -a
Linux archlinux 4.18.5-arch1-1-ARCH #1 SMP PREEMPT Fri Aug 24 12:48:58 
UTC 2018 x86_64 GNU/Linux

[vagrant@archlinux mnt]$ btrfs --version
btrfs-progs v4.17.1

[vagrant@archlinux mnt]$ sudo btrfs fi show /dev/sdb1
Label: 'intenso_white'  uuid: 07bf61ed-7728-4151-a784-c4b840e343ed
Total devices 1 FS bytes used 655.82GiB
devid    1 size 911.51GiB used 703.09GiB path /dev/sdb1

[vagrant@archlinux mnt]$ sudo btrfs fi df /mnt/intenso_white/
Data, single: total=695.01GiB, used=653.69GiB
System, DUP: total=40.00MiB, used=96.00KiB
Metadata, DUP: total=4.00GiB, used=2.13GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


--------------1CD475EC96BFB3B804600C07
Content-Type: text/plain; charset=UTF-8;
 name="btrfs-send.strace"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="btrfs-send.strace"

ZXhlY3ZlKCIvdXNyL2Jpbi9idHJmcyIsIFsiYnRyZnMiLCAic2VuZCIsICItdnZ2IiwgIi1m
IiwgImludGVuc29fd2hpdGUuc25hcHNob3QiLCAiL21udC9pbnRlbnNvX3doaXRlL0BkYXRh
Ly5zbmFwc2giLi4uXSwgMHg3ZmZjYjhmNTI3MTggLyogMTYgdmFycyAqLykgPSAwCmJyayhO
VUxMKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDB4NTU1YzllZGRiMDAwCmFy
Y2hfcHJjdGwoMHgzMDAxIC8qIEFSQ0hfPz8/ICovLCAweDdmZmU4Yzk5NzFlMCkgPSAtMSBF
SU5WQUwgKEludmFsaWQgYXJndW1lbnQpCmFjY2VzcygiL2V0Yy9sZC5zby5wcmVsb2FkIiwg
Ul9PSykgICAgICA9IC0xIEVOT0VOVCAoTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeSkKb3Bl
bmF0KEFUX0ZEQ1dELCAiL2V0Yy9sZC5zby5jYWNoZSIsIE9fUkRPTkxZfE9fQ0xPRVhFQykg
PSAzCmZzdGF0KDMsIHtzdF9tb2RlPVNfSUZSRUd8MDY0NCwgc3Rfc2l6ZT0yODU0MiwgLi4u
fSkgPSAwCm1tYXAoTlVMTCwgMjg1NDIsIFBST1RfUkVBRCwgTUFQX1BSSVZBVEUsIDMsIDAp
ID0gMHg3ZmZhOWEwMTYwMDAKY2xvc2UoMykgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgID0gMApvcGVuYXQoQVRfRkRDV0QsICIvdXNyL2xpYi9saWJ1dWlkLnNvLjEiLCBPX1JE
T05MWXxPX0NMT0VYRUMpID0gMwpyZWFkKDMsICJcMTc3RUxGXDJcMVwxXDBcMFwwXDBcMFww
XDBcMFwwXDNcMD5cMFwxXDBcMFwwYFwyNFwwXDBcMFwwXDBcMCIuLi4sIDgzMikgPSA4MzIK
ZnN0YXQoMywge3N0X21vZGU9U19JRlJFR3wwNzU1LCBzdF9zaXplPTI2NTUyLCAuLi59KSA9
IDAKbW1hcChOVUxMLCA4MTkyLCBQUk9UX1JFQUR8UFJPVF9XUklURSwgTUFQX1BSSVZBVEV8
TUFQX0FOT05ZTU9VUywgLTEsIDApID0gMHg3ZmZhOWEwMTQwMDAKbW1hcChOVUxMLCAyMTIx
NzUyLCBQUk9UX1JFQUR8UFJPVF9FWEVDLCBNQVBfUFJJVkFURXxNQVBfREVOWVdSSVRFLCAz
LCAwKSA9IDB4N2ZmYTk5ZTBkMDAwCm1wcm90ZWN0KDB4N2ZmYTk5ZTEzMDAwLCAyMDkzMDU2
LCBQUk9UX05PTkUpID0gMAptbWFwKDB4N2ZmYTlhMDEyMDAwLCA4MTkyLCBQUk9UX1JFQUR8
UFJPVF9XUklURSwgTUFQX1BSSVZBVEV8TUFQX0ZJWEVEfE1BUF9ERU5ZV1JJVEUsIDMsIDB4
NTAwMCkgPSAweDdmZmE5YTAxMjAwMApjbG9zZSgzKSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgPSAwCm9wZW5hdChBVF9GRENXRCwgIi91c3IvbGliL2xpYmJsa2lkLnNvLjEi
LCBPX1JET05MWXxPX0NMT0VYRUMpID0gMwpyZWFkKDMsICJcMTc3RUxGXDJcMVwxXDBcMFww
XDBcMFwwXDBcMFwwXDNcMD5cMFwxXDBcMFwwXDI0MFwyMzFcMFwwXDBcMFwwXDAiLi4uLCA4
MzIpID0gODMyCmZzdGF0KDMsIHtzdF9tb2RlPVNfSUZSRUd8MDc1NSwgc3Rfc2l6ZT0zMjY0
ODAsIC4uLn0pID0gMAptbWFwKE5VTEwsIDI0MjY2NTYsIFBST1RfUkVBRHxQUk9UX0VYRUMs
IE1BUF9QUklWQVRFfE1BUF9ERU5ZV1JJVEUsIDMsIDApID0gMHg3ZmZhOTliYmMwMDAKbXBy
b3RlY3QoMHg3ZmZhOTljMDYwMDAsIDIwOTcxNTIsIFBST1RfTk9ORSkgPSAwCm1tYXAoMHg3
ZmZhOTllMDYwMDAsIDI0NTc2LCBQUk9UX1JFQUR8UFJPVF9XUklURSwgTUFQX1BSSVZBVEV8
TUFQX0ZJWEVEfE1BUF9ERU5ZV1JJVEUsIDMsIDB4NGEwMDApID0gMHg3ZmZhOTllMDYwMDAK
bW1hcCgweDdmZmE5OWUwYzAwMCwgMTgyNCwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9Q
UklWQVRFfE1BUF9GSVhFRHxNQVBfQU5PTllNT1VTLCAtMSwgMCkgPSAweDdmZmE5OWUwYzAw
MApjbG9zZSgzKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAwCm9wZW5hdChB
VF9GRENXRCwgIi91c3IvbGliL2xpYnouc28uMSIsIE9fUkRPTkxZfE9fQ0xPRVhFQykgPSAz
CnJlYWQoMywgIlwxNzdFTEZcMlwxXDFcMFwwXDBcMFwwXDBcMFwwXDBcM1wwPlwwXDFcMFww
XDBcMzIwIVwwXDBcMFwwXDBcMCIuLi4sIDgzMikgPSA4MzIKZnN0YXQoMywge3N0X21vZGU9
U19JRlJFR3wwNzU1LCBzdF9zaXplPTkxOTEyLCAuLi59KSA9IDAKbW1hcChOVUxMLCAyMTg3
MjgwLCBQUk9UX1JFQUR8UFJPVF9FWEVDLCBNQVBfUFJJVkFURXxNQVBfREVOWVdSSVRFLCAz
LCAwKSA9IDB4N2ZmYTk5OWE1MDAwCm1wcm90ZWN0KDB4N2ZmYTk5OWJiMDAwLCAyMDkzMDU2
LCBQUk9UX05PTkUpID0gMAptbWFwKDB4N2ZmYTk5YmJhMDAwLCA4MTkyLCBQUk9UX1JFQUR8
UFJPVF9XUklURSwgTUFQX1BSSVZBVEV8TUFQX0ZJWEVEfE1BUF9ERU5ZV1JJVEUsIDMsIDB4
MTUwMDApID0gMHg3ZmZhOTliYmEwMDAKY2xvc2UoMykgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgID0gMApvcGVuYXQoQVRfRkRDV0QsICIvdXNyL2xpYi9saWJsem8yLnNvLjIi
LCBPX1JET05MWXxPX0NMT0VYRUMpID0gMwpyZWFkKDMsICJcMTc3RUxGXDJcMVwxXDBcMFww
XDBcMFwwXDBcMFwwXDNcMD5cMFwxXDBcMFwwXDIwJ1wwXDBcMFwwXDBcMCIuLi4sIDgzMikg
PSA4MzIKZnN0YXQoMywge3N0X21vZGU9U19JRlJFR3wwNzU1LCBzdF9zaXplPTEzNzQzMiwg
Li4ufSkgPSAwCm1tYXAoTlVMTCwgMjIzMjUyOCwgUFJPVF9SRUFEfFBST1RfRVhFQywgTUFQ
X1BSSVZBVEV8TUFQX0RFTllXUklURSwgMywgMCkgPSAweDdmZmE5OTc4MzAwMAptcHJvdGVj
dCgweDdmZmE5OTdhNDAwMCwgMjA5MzA1NiwgUFJPVF9OT05FKSA9IDAKbW1hcCgweDdmZmE5
OTlhMzAwMCwgODE5MiwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9QUklWQVRFfE1BUF9G
SVhFRHxNQVBfREVOWVdSSVRFLCAzLCAweDIwMDAwKSA9IDB4N2ZmYTk5OWEzMDAwCmNsb3Nl
KDMpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAKb3BlbmF0KEFUX0ZEQ1dE
LCAiL3Vzci9saWIvbGlienN0ZC5zby4xIiwgT19SRE9OTFl8T19DTE9FWEVDKSA9IDMKcmVh
ZCgzLCAiXDE3N0VMRlwyXDFcMVwwXDBcMFwwXDBcMFwwXDBcMFwzXDA+XDBcMVwwXDBcMFwy
NjBFXDBcMFwwXDBcMFwwIi4uLiwgODMyKSA9IDgzMgpmc3RhdCgzLCB7c3RfbW9kZT1TX0lG
UkVHfDA3NTUsIHN0X3NpemU9NjIwMjI0LCAuLi59KSA9IDAKbW1hcChOVUxMLCAyNzE1NzA0
LCBQUk9UX1JFQUR8UFJPVF9FWEVDLCBNQVBfUFJJVkFURXxNQVBfREVOWVdSSVRFLCAzLCAw
KSA9IDB4N2ZmYTk5NGViMDAwCm1wcm90ZWN0KDB4N2ZmYTk5NTgyMDAwLCAyMDkzMDU2LCBQ
Uk9UX05PTkUpID0gMAptbWFwKDB4N2ZmYTk5NzgxMDAwLCA4MTkyLCBQUk9UX1JFQUR8UFJP
VF9XUklURSwgTUFQX1BSSVZBVEV8TUFQX0ZJWEVEfE1BUF9ERU5ZV1JJVEUsIDMsIDB4OTYw
MDApID0gMHg3ZmZhOTk3ODEwMDAKY2xvc2UoMykgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgID0gMApvcGVuYXQoQVRfRkRDV0QsICIvdXNyL2xpYi9saWJwdGhyZWFkLnNvLjAi
LCBPX1JET05MWXxPX0NMT0VYRUMpID0gMwpyZWFkKDMsICJcMTc3RUxGXDJcMVwxXDNcMFww
XDBcMFwwXDBcMFwwXDNcMD5cMFwxXDBcMFwwXDM0MGZcMFwwXDBcMFwwXDAiLi4uLCA4MzIp
ID0gODMyCmZzdGF0KDMsIHtzdF9tb2RlPVNfSUZSRUd8MDc1NSwgc3Rfc2l6ZT0xNTU0MDgs
IC4uLn0pID0gMApsc2VlaygzLCA4MDgsIFNFRUtfU0VUKSAgICAgICAgICAgICAgICAgPSA4
MDgKcmVhZCgzLCAiXDRcMFwwXDBcMjBcMFwwXDBcNVwwXDBcMEdOVVwwXDJcMFwwXDMwMFw0
XDBcMFwwXDNcMFwwXDBcMFwwXDBcMCIsIDMyKSA9IDMyCm1tYXAoTlVMTCwgMTMxNTI4LCBQ
Uk9UX1JFQUQsIE1BUF9QUklWQVRFfE1BUF9ERU5ZV1JJVEUsIDMsIDApID0gMHg3ZmZhOTk0
Y2EwMDAKbW1hcCgweDdmZmE5OTRkMDAwMCwgNjE0NDAsIFBST1RfUkVBRHxQUk9UX0VYRUMs
IE1BUF9QUklWQVRFfE1BUF9GSVhFRHxNQVBfREVOWVdSSVRFLCAzLCAweDYwMDApID0gMHg3
ZmZhOTk0ZDAwMDAKbW1hcCgweDdmZmE5OTRkZjAwMCwgMjQ1NzYsIFBST1RfUkVBRCwgTUFQ
X1BSSVZBVEV8TUFQX0ZJWEVEfE1BUF9ERU5ZV1JJVEUsIDMsIDB4MTUwMDApID0gMHg3ZmZh
OTk0ZGYwMDAKbW1hcCgweDdmZmE5OTRlNTAwMCwgODE5MiwgUFJPVF9SRUFEfFBST1RfV1JJ
VEUsIE1BUF9QUklWQVRFfE1BUF9GSVhFRHxNQVBfREVOWVdSSVRFLCAzLCAweDFhMDAwKSA9
IDB4N2ZmYTk5NGU1MDAwCm1tYXAoMHg3ZmZhOTk0ZTcwMDAsIDEyNzQ0LCBQUk9UX1JFQUR8
UFJPVF9XUklURSwgTUFQX1BSSVZBVEV8TUFQX0ZJWEVEfE1BUF9BTk9OWU1PVVMsIC0xLCAw
KSA9IDB4N2ZmYTk5NGU3MDAwCmNsb3NlKDMpICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICA9IDAKb3BlbmF0KEFUX0ZEQ1dELCAiL3Vzci9saWIvbGliYy5zby42IiwgT19SRE9O
TFl8T19DTE9FWEVDKSA9IDMKcmVhZCgzLCAiXDE3N0VMRlwyXDFcMVwzXDBcMFwwXDBcMFww
XDBcMFwzXDA+XDBcMVwwXDBcMDAwMENcMlwwXDBcMFwwXDAiLi4uLCA4MzIpID0gODMyCmxz
ZWVrKDMsIDc5MiwgU0VFS19TRVQpICAgICAgICAgICAgICAgICA9IDc5MgpyZWFkKDMsICJc
NFwwXDBcMFwyNFwwXDBcMFwzXDBcMFwwR05VXDBcMjEwbzdcMjFcMVwzMDc9XDMxMVwzNjZc
MjYzXDI1NlwyMDJwXDM3NzdcMzM1Ii4uLiwgNjgpID0gNjgKZnN0YXQoMywge3N0X21vZGU9
U19JRlJFR3wwNzU1LCBzdF9zaXplPTIxMzY4NDAsIC4uLn0pID0gMAptbWFwKE5VTEwsIDgx
OTIsIFBST1RfUkVBRHxQUk9UX1dSSVRFLCBNQVBfUFJJVkFURXxNQVBfQU5PTllNT1VTLCAt
MSwgMCkgPSAweDdmZmE5OTRjODAwMApsc2VlaygzLCA3OTIsIFNFRUtfU0VUKSAgICAgICAg
ICAgICAgICAgPSA3OTIKcmVhZCgzLCAiXDRcMFwwXDBcMjRcMFwwXDBcM1wwXDBcMEdOVVww
XDIxMG83XDIxXDFcMzA3PVwzMTFcMzY2XDI2M1wyNTZcMjAycFwzNzc3XDMzNSIuLi4sIDY4
KSA9IDY4CmxzZWVrKDMsIDg2NCwgU0VFS19TRVQpICAgICAgICAgICAgICAgICA9IDg2NApy
ZWFkKDMsICJcNFwwXDBcMFwyMFwwXDBcMFw1XDBcMFwwR05VXDBcMlwwXDBcMzAwXDRcMFww
XDBcM1wwXDBcMFwwXDBcMFwwIiwgMzIpID0gMzIKbW1hcChOVUxMLCAxODQ4ODk2LCBQUk9U
X1JFQUQsIE1BUF9QUklWQVRFfE1BUF9ERU5ZV1JJVEUsIDMsIDApID0gMHg3ZmZhOTkzMDQw
MDAKbXByb3RlY3QoMHg3ZmZhOTkzMjYwMDAsIDE2NzExNjgsIFBST1RfTk9ORSkgPSAwCm1t
YXAoMHg3ZmZhOTkzMjYwMDAsIDEzNTU3NzYsIFBST1RfUkVBRHxQUk9UX0VYRUMsIE1BUF9Q
UklWQVRFfE1BUF9GSVhFRHxNQVBfREVOWVdSSVRFLCAzLCAweDIyMDAwKSA9IDB4N2ZmYTk5
MzI2MDAwCm1tYXAoMHg3ZmZhOTk0NzEwMDAsIDMxMTI5NiwgUFJPVF9SRUFELCBNQVBfUFJJ
VkFURXxNQVBfRklYRUR8TUFQX0RFTllXUklURSwgMywgMHgxNmQwMDApID0gMHg3ZmZhOTk0
NzEwMDAKbW1hcCgweDdmZmE5OTRiZTAwMCwgMjQ1NzYsIFBST1RfUkVBRHxQUk9UX1dSSVRF
LCBNQVBfUFJJVkFURXxNQVBfRklYRUR8TUFQX0RFTllXUklURSwgMywgMHgxYjkwMDApID0g
MHg3ZmZhOTk0YmUwMDAKbW1hcCgweDdmZmE5OTRjNDAwMCwgMTM4ODgsIFBST1RfUkVBRHxQ
Uk9UX1dSSVRFLCBNQVBfUFJJVkFURXxNQVBfRklYRUR8TUFQX0FOT05ZTU9VUywgLTEsIDAp
ID0gMHg3ZmZhOTk0YzQwMDAKY2xvc2UoMykgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgID0gMAptbWFwKE5VTEwsIDEyMjg4LCBQUk9UX1JFQUR8UFJPVF9XUklURSwgTUFQX1BS
SVZBVEV8TUFQX0FOT05ZTU9VUywgLTEsIDApID0gMHg3ZmZhOTkzMDEwMDAKYXJjaF9wcmN0
bChBUkNIX1NFVF9GUywgMHg3ZmZhOTkzMDE4YzApID0gMAptcHJvdGVjdCgweDdmZmE5OTRi
ZTAwMCwgMTYzODQsIFBST1RfUkVBRCkgPSAwCm1wcm90ZWN0KDB4N2ZmYTk5NGU1MDAwLCA0
MDk2LCBQUk9UX1JFQUQpID0gMAptcHJvdGVjdCgweDdmZmE5OTc4MTAwMCwgNDA5NiwgUFJP
VF9SRUFEKSA9IDAKbXByb3RlY3QoMHg3ZmZhOTk5YTMwMDAsIDQwOTYsIFBST1RfUkVBRCkg
PSAwCm1wcm90ZWN0KDB4N2ZmYTk5YmJhMDAwLCA0MDk2LCBQUk9UX1JFQUQpID0gMAptcHJv
dGVjdCgweDdmZmE5YTAxMjAwMCwgNDA5NiwgUFJPVF9SRUFEKSA9IDAKbXByb3RlY3QoMHg3
ZmZhOTllMDYwMDAsIDIwNDgwLCBQUk9UX1JFQUQpID0gMAptcHJvdGVjdCgweDU1NWM5ZTEw
MTAwMCwgMjA0ODAsIFBST1RfUkVBRCkgPSAwCm1wcm90ZWN0KDB4N2ZmYTlhMDQ2MDAwLCA0
MDk2LCBQUk9UX1JFQUQpID0gMAptdW5tYXAoMHg3ZmZhOWEwMTYwMDAsIDI4NTQyKSAgICAg
ICAgICAgPSAwCnNldF90aWRfYWRkcmVzcygweDdmZmE5OTMwMWI5MCkgICAgICAgICA9IDMw
MjIKc2V0X3JvYnVzdF9saXN0KDB4N2ZmYTk5MzAxYmEwLCAyNCkgICAgID0gMApydF9zaWdh
Y3Rpb24oU0lHUlRNSU4sIHtzYV9oYW5kbGVyPTB4N2ZmYTk5NGQwMTMwLCBzYV9tYXNrPVtd
LCBzYV9mbGFncz1TQV9SRVNUT1JFUnxTQV9TSUdJTkZPLCBzYV9yZXN0b3Jlcj0weDdmZmE5
OTRkYzNjMH0sIE5VTEwsIDgpID0gMApydF9zaWdhY3Rpb24oU0lHUlRfMSwge3NhX2hhbmRs
ZXI9MHg3ZmZhOTk0ZDAxZDAsIHNhX21hc2s9W10sIHNhX2ZsYWdzPVNBX1JFU1RPUkVSfFNB
X1JFU1RBUlR8U0FfU0lHSU5GTywgc2FfcmVzdG9yZXI9MHg3ZmZhOTk0ZGMzYzB9LCBOVUxM
LCA4KSA9IDAKcnRfc2lncHJvY21hc2soU0lHX1VOQkxPQ0ssIFtSVE1JTiBSVF8xXSwgTlVM
TCwgOCkgPSAwCnBybGltaXQ2NCgwLCBSTElNSVRfU1RBQ0ssIE5VTEwsIHtybGltX2N1cj04
MTkyKjEwMjQsIHJsaW1fbWF4PVJMSU02NF9JTkZJTklUWX0pID0gMApvcGVuYXQoQVRfRkRD
V0QsICJpbnRlbnNvX3doaXRlLnNuYXBzaG90IiwgT19XUk9OTFl8T19UUlVOQykgPSAtMSBF
Tk9FTlQgKE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkpCm9wZW5hdChBVF9GRENXRCwgImlu
dGVuc29fd2hpdGUuc25hcHNob3QiLCBPX1dST05MWXxPX0NSRUFUfE9fVFJVTkMsIDA2MDAp
ID0gMwppb2N0bCgzLCBUQ0dFVFMsIDB4N2ZmZThjOTk1ZjkwKSAgICAgICAgPSAtMSBFTk9U
VFkgKEluYXBwcm9wcmlhdGUgaW9jdGwgZm9yIGRldmljZSkKYnJrKE5VTEwpICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgID0gMHg1NTVjOWVkZGIwMDAKYnJrKDB4NTU1YzllZGZj
MDAwKSAgICAgICAgICAgICAgICAgICAgID0gMHg1NTVjOWVkZmMwMDAKbHN0YXQoIi9tbnQi
LCB7c3RfbW9kZT1TX0lGRElSfDA3NTUsIHN0X3NpemU9NjAsIC4uLn0pID0gMApsc3RhdCgi
L21udC9pbnRlbnNvX3doaXRlIiwge3N0X21vZGU9U19JRkRJUnwwNzc3LCBzdF9zaXplPTI0
LCAuLi59KSA9IDAKbHN0YXQoIi9tbnQvaW50ZW5zb193aGl0ZS9AZGF0YSIsIHtzdF9tb2Rl
PVNfSUZESVJ8MDc1NSwgc3Rfc2l6ZT0yOCwgLi4ufSkgPSAwCmxzdGF0KCIvbW50L2ludGVu
c29fd2hpdGUvQGRhdGEvLnNuYXBzaG90cyIsIHtzdF9tb2RlPVNfSUZESVJ8MDc1NSwgc3Rf
c2l6ZT03NiwgLi4ufSkgPSAwCmxzdGF0KCIvbW50L2ludGVuc29fd2hpdGUvQGRhdGEvLnNu
YXBzaG90cy90ZXN0LXNuYXBzaG90Iiwge3N0X21vZGU9U19JRkRJUnwwNzU1LCBzdF9zaXpl
PTI4LCAuLi59KSA9IDAKb3BlbmF0KEFUX0ZEQ1dELCAiL21udC9pbnRlbnNvX3doaXRlL0Bk
YXRhLy5zbmFwc2hvdHMvdGVzdC1zbmFwc2hvdCIsIE9fUkRPTkxZfE9fTk9BVElNRSkgPSA0
CmNsb3NlKDQpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAKb3BlbmF0KEFU
X0ZEQ1dELCAiL3Byb2Mvc2VsZi9tb3VudHMiLCBPX1JET05MWXxPX0NMT0VYRUMpID0gNApm
dXRleCgweDdmZmE5OTRjNGZjOCwgRlVURVhfV0FLRV9QUklWQVRFLCAyMTQ3NDgzNjQ3KSA9
IDAKZnN0YXQoNCwge3N0X21vZGU9U19JRlJFR3wwNDQ0LCBzdF9zaXplPTAsIC4uLn0pID0g
MApyZWFkKDQsICJwcm9jIC9wcm9jIHByb2Mgcncsbm9zdWlkLG5vZGV2LCIuLi4sIDEwMjQp
ID0gMTAyNApyZWFkKDQsICJpbWUscGVyZl9ldmVudCAwIDBcbmNncm91cCAvc3lzL2YiLi4u
LCAxMDI0KSA9IDEwMjQKcmVhZCg0LCAic2l6ZT0yTSAwIDBcbmRlYnVnZnMgL3N5cy9rZXJu
ZWwvIi4uLiwgMTAyNCkgPSAzMTgKcmVhZCg0LCAiIiwgMTAyNCkgICAgICAgICAgICAgICAg
ICAgICAgID0gMApjbG9zZSg0KSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAw
CmxzdGF0KCIvbW50Iiwge3N0X21vZGU9U19JRkRJUnwwNzU1LCBzdF9zaXplPTYwLCAuLi59
KSA9IDAKbHN0YXQoIi9tbnQvaW50ZW5zb193aGl0ZSIsIHtzdF9tb2RlPVNfSUZESVJ8MDc3
Nywgc3Rfc2l6ZT0yNCwgLi4ufSkgPSAwCm9wZW5hdChBVF9GRENXRCwgIi9tbnQvaW50ZW5z
b193aGl0ZSIsIE9fUkRPTkxZfE9fTk9BVElNRSkgPSA0CmlvY3RsKDQsIEJUUkZTX0lPQ19U
UkVFX1NFQVJDSCwge2tleT17dHJlZV9pZD1CVFJGU19ST09UX1RSRUVfT0JKRUNUSUQsIG1p
bl9vYmplY3RpZD1CVFJGU19VVUlEX1RSRUVfT0JKRUNUSUQsIG1heF9vYmplY3RpZD1CVFJG
U19VVUlEX1RSRUVfT0JKRUNUSUQsIG1pbl9vZmZzZXQ9MCwgbWF4X29mZnNldD1VSU5UNjRf
TUFYLCBtaW5fdHJhbnNpZD0wLCBtYXhfdHJhbnNpZD1VSU5UNjRfTUFYLCBtaW5fdHlwZT1C
VFJGU19ST09UX0lURU1fS0VZLCBtYXhfdHlwZT1CVFJGU19ST09UX0lURU1fS0VZLCBucl9p
dGVtcz0xfX0gPT4ge2tleT17bnJfaXRlbXM9MX0sIC4uLn0pID0gMApsc3RhdCgiL21udCIs
IHtzdF9tb2RlPVNfSUZESVJ8MDc1NSwgc3Rfc2l6ZT02MCwgLi4ufSkgPSAwCmxzdGF0KCIv
bW50L2ludGVuc29fd2hpdGUiLCB7c3RfbW9kZT1TX0lGRElSfDA3NzcsIHN0X3NpemU9MjQs
IC4uLn0pID0gMApsc3RhdCgiL21udC9pbnRlbnNvX3doaXRlL0BkYXRhIiwge3N0X21vZGU9
U19JRkRJUnwwNzU1LCBzdF9zaXplPTI4LCAuLi59KSA9IDAKbHN0YXQoIi9tbnQvaW50ZW5z
b193aGl0ZS9AZGF0YS8uc25hcHNob3RzIiwge3N0X21vZGU9U19JRkRJUnwwNzU1LCBzdF9z
aXplPTc2LCAuLi59KSA9IDAKbHN0YXQoIi9tbnQvaW50ZW5zb193aGl0ZS9AZGF0YS8uc25h
cHNob3RzL3Rlc3Qtc25hcHNob3QiLCB7c3RfbW9kZT1TX0lGRElSfDA3NTUsIHN0X3NpemU9
MjgsIC4uLn0pID0gMApvcGVuYXQoQVRfRkRDV0QsICIvbW50L2ludGVuc29fd2hpdGUvQGRh
dGEvLnNuYXBzaG90cy90ZXN0LXNuYXBzaG90IiwgT19SRE9OTFl8T19OT0FUSU1FKSA9IDUK
Y2xvc2UoNSkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMApvcGVuYXQoQVRf
RkRDV0QsICIvcHJvYy9zZWxmL21vdW50cyIsIE9fUkRPTkxZfE9fQ0xPRVhFQykgPSA1CmZz
dGF0KDUsIHtzdF9tb2RlPVNfSUZSRUd8MDQ0NCwgc3Rfc2l6ZT0wLCAuLi59KSA9IDAKcmVh
ZCg1LCAicHJvYyAvcHJvYyBwcm9jIHJ3LG5vc3VpZCxub2RldiwiLi4uLCAxMDI0KSA9IDEw
MjQKcmVhZCg1LCAiaW1lLHBlcmZfZXZlbnQgMCAwXG5jZ3JvdXAgL3N5cy9mIi4uLiwgMTAy
NCkgPSAxMDI0CnJlYWQoNSwgInNpemU9Mk0gMCAwXG5kZWJ1Z2ZzIC9zeXMva2VybmVsLyIu
Li4sIDEwMjQpID0gMzE4CnJlYWQoNSwgIiIsIDEwMjQpICAgICAgICAgICAgICAgICAgICAg
ICA9IDAKY2xvc2UoNSkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMApsc3Rh
dCgiL21udCIsIHtzdF9tb2RlPVNfSUZESVJ8MDc1NSwgc3Rfc2l6ZT02MCwgLi4ufSkgPSAw
CmxzdGF0KCIvbW50L2ludGVuc29fd2hpdGUiLCB7c3RfbW9kZT1TX0lGRElSfDA3NzcsIHN0
X3NpemU9MjQsIC4uLn0pID0gMApvcGVuYXQoNCwgIi9tbnQvaW50ZW5zb193aGl0ZS9AZGF0
YS8uc25hcHNob3RzL3Rlc3Qtc25hcHNob3QiLCBPX1JET05MWXxPX05PQVRJTUUpID0gNQpp
b2N0bCg1LCBCVFJGU19JT0NfU1VCVk9MX0dFVEZMQUdTLCBCVFJGU19TVUJWT0xfUkRPTkxZ
KSA9IDAKY2xvc2UoNSkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMAp3cml0
ZSgyLCAiQXQgc3Vidm9sIC9tbnQvaW50ZW5zb193aGl0ZS9AZGEiLi4uLCA2MCkgPSA2MAps
c3RhdCgiL21udCIsIHtzdF9tb2RlPVNfSUZESVJ8MDc1NSwgc3Rfc2l6ZT02MCwgLi4ufSkg
PSAwCmxzdGF0KCIvbW50L2ludGVuc29fd2hpdGUiLCB7c3RfbW9kZT1TX0lGRElSfDA3Nzcs
IHN0X3NpemU9MjQsIC4uLn0pID0gMApsc3RhdCgiL21udC9pbnRlbnNvX3doaXRlL0BkYXRh
Iiwge3N0X21vZGU9U19JRkRJUnwwNzU1LCBzdF9zaXplPTI4LCAuLi59KSA9IDAKbHN0YXQo
Ii9tbnQvaW50ZW5zb193aGl0ZS9AZGF0YS8uc25hcHNob3RzIiwge3N0X21vZGU9U19JRkRJ
UnwwNzU1LCBzdF9zaXplPTc2LCAuLi59KSA9IDAKbHN0YXQoIi9tbnQvaW50ZW5zb193aGl0
ZS9AZGF0YS8uc25hcHNob3RzL3Rlc3Qtc25hcHNob3QiLCB7c3RfbW9kZT1TX0lGRElSfDA3
NTUsIHN0X3NpemU9MjgsIC4uLn0pID0gMApvcGVuYXQoNCwgIi9tbnQvaW50ZW5zb193aGl0
ZS9AZGF0YS8uc25hcHNob3RzL3Rlc3Qtc25hcHNob3QiLCBPX1JET05MWXxPX05PQVRJTUUp
ID0gNQpwaXBlKFs2LCA3XSkgICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAwCm1tYXAo
TlVMTCwgODM5MjcwNCwgUFJPVF9OT05FLCBNQVBfUFJJVkFURXxNQVBfQU5PTllNT1VTfE1B
UF9TVEFDSywgLTEsIDApID0gMHg3ZmZhOThiMDAwMDAKbXByb3RlY3QoMHg3ZmZhOThiMDEw
MDAsIDgzODg2MDgsIFBST1RfUkVBRHxQUk9UX1dSSVRFKSA9IDAKY2xvbmUoY2hpbGRfc3Rh
Y2s9MHg3ZmZhOTkyZmZlMzAsIGZsYWdzPUNMT05FX1ZNfENMT05FX0ZTfENMT05FX0ZJTEVT
fENMT05FX1NJR0hBTkR8Q0xPTkVfVEhSRUFEfENMT05FX1NZU1ZTRU18Q0xPTkVfU0VUVExT
fENMT05FX1BBUkVOVF9TRVRUSUR8Q0xPTkVfQ0hJTERfQ0xFQVJUSUQsIHBhcmVudF90aWRw
dHI9MHg3ZmZhOTkzMDA5ZDAsIHRscz0weDdmZmE5OTMwMDcwMCwgY2hpbGRfdGlkcHRyPTB4
N2ZmYTk5MzAwOWQwKSA9IDMwMjMKaW9jdGwoNSwgQlRSRlNfSU9DX1NFTkQsIHtzZW5kX2Zk
PTcsIGNsb25lX3NvdXJjZXNfY291bnQ9MCwgY2xvbmVfc291cmNlcz1OVUxMLCBwYXJlbnRf
cm9vdD0wLCBmbGFncz0wfSkgPSA/IEVSRVNUQVJUU1lTIChUbyBiZSByZXN0YXJ0ZWQgaWYg
U0FfUkVTVEFSVCBpcyBzZXQpCi0tLSBTSUdXSU5DSCB7c2lfc2lnbm89U0lHV0lOQ0gsIHNp
X2NvZGU9U0lfS0VSTkVMfSAtLS0KaW9jdGwoNSwgQlRSRlNfSU9DX1NFTkQsIHtzZW5kX2Zk
PTcsIGNsb25lX3NvdXJjZXNfY291bnQ9MCwgY2xvbmVfc291cmNlcz1OVUxMLCBwYXJlbnRf
cm9vdD0wLCBmbGFncz0wfQ==
--------------1CD475EC96BFB3B804600C07
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Linux version 4.18.5-arch1-1-ARCH (builduser@heftig-12250) (gcc version 8.2.0 (GCC)) #1 SMP PREEMPT Fri Aug 24 12:48:58 UTC 2018
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-linux root=UUID=a83c9650-c8f8-4afe-90a6-4e80156d523d rw quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dffeffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfff0000-0x00000000dfffffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR variable ranges disabled:
[    0.000000] Disabled
[    0.000000] x86/PAT: MTRRs disabled, skipping PAT initialization too.
[    0.000000] CPU MTRRs all blank - virtualized system.
[    0.000000] x86/PAT: Configuration [0-7]: WB  WT  UC- UC  WB  WT  UC- UC  
[    0.000000] last_pfn = 0xdfff0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x0009fff0-0x0009ffff] mapped at [(____ptrval____)]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [(____ptrval____)] 99000 size 24576
[    0.000000] BRK [0x111677000, 0x111677fff] PGTABLE
[    0.000000] BRK [0x111678000, 0x111678fff] PGTABLE
[    0.000000] BRK [0x111679000, 0x111679fff] PGTABLE
[    0.000000] BRK [0x11167a000, 0x11167afff] PGTABLE
[    0.000000] BRK [0x11167b000, 0x11167bfff] PGTABLE
[    0.000000] BRK [0x11167c000, 0x11167cfff] PGTABLE
[    0.000000] BRK [0x11167d000, 0x11167dfff] PGTABLE
[    0.000000] BRK [0x11167e000, 0x11167efff] PGTABLE
[    0.000000] BRK [0x11167f000, 0x11167ffff] PGTABLE
[    0.000000] RAMDISK: [mem 0x37131000-0x3788ffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000E0000 000024 (v02 VBOX  )
[    0.000000] ACPI: XSDT 0x00000000DFFF0030 00003C (v01 VBOX   VBOXXSDT 00000001 ASL  00000061)
[    0.000000] ACPI: FACP 0x00000000DFFF00F0 0000F4 (v04 VBOX   VBOXFACP 00000001 ASL  00000061)
[    0.000000] ACPI: DSDT 0x00000000DFFF0470 0021FF (v02 VBOX   VBOXBIOS 00000002 INTL 20180629)
[    0.000000] ACPI: FACS 0x00000000DFFF0200 000040
[    0.000000] ACPI: FACS 0x00000000DFFF0200 000040
[    0.000000] ACPI: APIC 0x00000000DFFF0240 00005C (v02 VBOX   VBOXAPIC 00000001 ASL  00000061)
[    0.000000] ACPI: SSDT 0x00000000DFFF02A0 0001CC (v01 VBOX   VBOXCPUT 00000002 INTL 20180629)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x11fffc000-0x11fffffff]
[    0.000000] kvm-clock: cpu 0, msr 1:1fff6001, primary cpu clock
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: using sched offset of 5269732913 cycles
[    0.000000] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000011fffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000dffeffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000011fffffff]
[    0.000000] Reserved but unavailable: 114 pages
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000011fffffff]
[    0.000000] On node 0 totalpages: 1048462
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913392 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfff0000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] [mem 0xe0000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370452778343963 ns
[    0.000000] random: get_random_bytes called from start_kernel+0x95/0x535 with crng_init=0
[    0.000000] setup_percpu: NR_CPUS:320 nr_cpumask_bits:320 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] percpu: Embedded 46 pages/cpu @(____ptrval____) s151552 r8192 d28672 u1048576
[    0.000000] pcpu-alloc: s151552 r8192 d28672 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] PV qspinlock hash table entries: 256 (order: 0, 4096 bytes)
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 1032057
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-linux root=UUID=a83c9650-c8f8-4afe-90a6-4e80156d523d rw quiet
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 4031212K/4193848K available (10252K kernel code, 1297K rwdata, 3528K rodata, 1492K init, 612K bss, 162636K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Kernel/User page tables isolation: enabled
[    0.000000] ftrace: allocating 33395 entries in 131 pages
[    0.003333] Preemptible hierarchical RCU implementation.
[    0.003333] 	CONFIG_RCU_FANOUT set to non-default value of 32
[    0.003333] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.003333] 	RCU restricting CPUs from NR_CPUS=320 to nr_cpu_ids=2.
[    0.003333] 	RCU priority boosting: priority 1 delay 500 ms.
[    0.003333] 	Tasks RCU enabled.
[    0.003333] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.003333] NR_IRQS: 20736, nr_irqs: 440, preallocated irqs: 16
[    0.003333] 	Offload RCU callbacks from CPUs: (none).
[    0.003333] Console: colour dummy device 80x25
[    0.003333] console [tty0] enabled
[    0.003333] ACPI: Core revision 20180531
[    0.003333] APIC: Switch to symmetric I/O mode setup
[    0.003333] x2apic enabled
[    0.003333] Switched APIC routing to physical x2apic.
[    0.003333] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.003333] tsc: Detected 2593.992 MHz processor
[    0.003333] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x25641074d3b, max_idle_ns: 440795244898 ns
[    0.003333] Calibrating delay loop (skipped) preset value.. 5190.15 BogoMIPS (lpj=8646640)
[    0.003333] pid_max: default: 32768 minimum: 301
[    0.003333] Security Framework initialized
[    0.003333] Yama: becoming mindful.
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003971] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004014] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.004025] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.004309] mce: CPU supports 0 MCE banks
[    0.004325] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.004325] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.004328] Spectre V2 : Mitigation: Full generic retpoline
[    0.004328] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
[    0.004329] Speculative Store Bypass: Vulnerable
[    0.004417] Freeing SMP alternatives memory: 28K
[    0.006666] smpboot: CPU0: Intel(R) Core(TM) i5-4310U CPU @ 2.00GHz (family: 0x6, model: 0x45, stepping: 0x1)
[    0.023365] Performance Events: unsupported p6 CPU model 69 no PMU driver, software events only.
[    0.030022] Hierarchical SRCU implementation.
[    0.044332] NMI watchdog: Perf event create on CPU 0 failed with -2
[    0.044336] NMI watchdog: Perf NMI watchdog permanently disabled
[    0.056697] smp: Bringing up secondary CPUs ...
[    0.096727] x86: Booting SMP configuration:
[    0.096731] .... node  #0, CPUs:      #1
[    0.003333] kvm-clock: cpu 1, msr 1:1fff6041, secondary cpu clock
[    0.003333] mce: CPU supports 0 MCE banks
[    0.099385] smp: Brought up 1 node, 2 CPUs
[    0.099385] smpboot: Max logical packages: 1
[    0.099385] smpboot: Total of 2 processors activated (10380.30 BogoMIPS)
[    0.100140] devtmpfs: initialized
[    0.100140] x86/mm: Memory block size: 128MB
[    0.101099] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370867519511994 ns
[    0.101099] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.101099] pinctrl core: initialized pinctrl subsystem
[    0.101099] RTC time:  8:32:36, date: 09/06/18
[    0.101099] NET: Registered protocol family 16
[    0.101180] audit: initializing netlink subsys (disabled)
[    0.103375] audit: type=2000 audit(1536222763.843:1): state=initialized audit_enabled=0 res=1
[    0.103791] cpuidle: using governor ladder
[    0.103791] cpuidle: using governor menu
[    0.103791] ACPI: bus type PCI registered
[    0.103791] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.103791] PCI: Using configuration type 1 for base access
[    0.106775] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.106935] ACPI: Added _OSI(Module Device)
[    0.106937] ACPI: Added _OSI(Processor Device)
[    0.106938] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.106939] ACPI: Added _OSI(Processor Aggregator Device)
[    0.106941] ACPI: Added _OSI(Linux-Dell-Video)
[    0.112542] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    0.115629] ACPI: Interpreter enabled
[    0.115639] ACPI: (supports S0 S5)
[    0.115641] ACPI: Using IOAPIC for interrupt routing
[    0.115897] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.116004] ACPI: Enabled 2 GPEs in block 00 to 07
[    0.121998] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.122014] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.122046] acpi PNP0A03:00: _OSC: not requesting OS control; OS requires [ExtendedConfig ASPM ClockPM MSI]
[    0.122063] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.122567] PCI host bridge to bus 0000:00
[    0.122573] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.122576] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.122577] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.122578] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfdffffff window]
[    0.122581] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.122629] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.123555] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.124275] pci 0000:00:01.1: [8086:7111] type 00 class 0x01018a
[    0.124606] pci 0000:00:01.1: reg 0x20: [io  0xd000-0xd00f]
[    0.124735] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.124737] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.124738] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.124739] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.125144] pci 0000:00:02.0: [80ee:beef] type 00 class 0x030000
[    0.126910] pci 0000:00:02.0: reg 0x10: [mem 0xe0000000-0xe07fffff pref]
[    0.164284] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.170084] pci 0000:00:03.0: reg 0x10: [mem 0xf0000000-0xf001ffff]
[    0.176805] pci 0000:00:03.0: reg 0x18: [io  0xd010-0xd017]
[    0.207840] pci 0000:00:04.0: [80ee:cafe] type 00 class 0x088000
[    0.210134] pci 0000:00:04.0: reg 0x10: [io  0xd020-0xd03f]
[    0.213550] pci 0000:00:04.0: reg 0x14: [mem 0xf0400000-0xf07fffff]
[    0.223363] pci 0000:00:04.0: reg 0x18: [mem 0xf0800000-0xf0803fff pref]
[    0.243975] pci 0000:00:05.0: [8086:2415] type 00 class 0x040100
[    0.244123] pci 0000:00:05.0: reg 0x10: [io  0xd100-0xd1ff]
[    0.244189] pci 0000:00:05.0: reg 0x14: [io  0xd200-0xd23f]
[    0.245644] pci 0000:00:07.0: [8086:7113] type 00 class 0x068000
[    0.247128] pci 0000:00:07.0: quirk: [io  0x4000-0x403f] claimed by PIIX4 ACPI
[    0.247150] pci 0000:00:07.0: quirk: [io  0x4100-0x410f] claimed by PIIX4 SMB
[    0.249317] pci 0000:00:0c.0: [8086:1e31] type 00 class 0x0c0330
[    0.253369] pci 0000:00:0c.0: reg 0x10: [mem 0xf0810000-0xf081ffff]
[    0.302124] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 9 10 *11)
[    0.302675] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 9 *10 11)
[    0.302861] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 *9 10 11)
[    0.303031] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 9 10 *11)
[    0.303482] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.303482] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.303482] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.303482] vgaarb: loaded
[    0.303679] pps_core: LinuxPPS API ver. 1 registered
[    0.303680] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.303683] PTP clock support registered
[    0.303697] EDAC MC: Ver: 3.0.0
[    0.304315] PCI: Using ACPI for IRQ routing
[    0.304315] PCI: pci_cache_line_size set to 64 bytes
[    0.304315] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.304315] e820: reserve RAM buffer [mem 0xdfff0000-0xdfffffff]
[    0.304315] NetLabel: Initializing
[    0.304315] NetLabel:  domain hash size = 128
[    0.304315] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.304315] NetLabel:  unlabeled traffic allowed by default
[    0.304315] clocksource: Switched to clocksource kvm-clock
[    0.321206] VFS: Disk quotas dquot_6.6.0
[    0.321225] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.321307] pnp: PnP ACPI init
[    0.321392] pnp 00:00: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.321472] pnp 00:01: Plug and Play ACPI device, IDs PNP0f03 (active)
[    0.322299] pnp: PnP ACPI: found 2 devices
[    0.339603] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.339617] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.339620] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.339622] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.339625] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfdffffff window]
[    0.339717] NET: Registered protocol family 2
[    0.339945] tcp_listen_portaddr_hash hash table entries: 2048 (order: 3, 32768 bytes)
[    0.339962] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.340053] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.340119] TCP: Hash tables configured (established 32768 bind 32768)
[    0.340155] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.340169] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.340221] NET: Registered protocol family 1
[    0.340228] NET: Registered protocol family 44
[    0.340235] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.340279] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.340343] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.342324] PCI: CLS 0 bytes, default 64
[    0.342428] Unpacking initramfs...
[    0.468721] Freeing initrd memory: 7548K
[    0.468736] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.468739] software IO TLB [mem 0xdbff0000-0xdfff0000] (64MB) mapped at [(____ptrval____)-(____ptrval____)]
[    0.468792] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x25641074d3b, max_idle_ns: 440795244898 ns
[    0.468834] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.468875] Scanning for low memory corruption every 60 seconds
[    0.469442] Initialise system trusted keyrings
[    0.469452] Key type blacklist registered
[    0.469562] workingset: timestamp_bits=41 max_order=20 bucket_order=0
[    0.470683] zbud: loaded
[    0.470999] pstore: using lz4hc compression
[    0.473446] Key type asymmetric registered
[    0.473447] Asymmetric key parser 'x509' registered
[    0.473477] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 245)
[    0.477094] io scheduler noop registered
[    0.477098] io scheduler deadline registered
[    0.477270] io scheduler cfq registered (default)
[    0.477272] io scheduler mq-deadline registered
[    0.477274] io scheduler kyber registered
[    0.477324] io scheduler bfq registered
[    0.477881] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    0.478023] vesafb: mode is 640x480x32, linelength=2560, pages=0
[    0.478025] vesafb: scrolling: redraw
[    0.478027] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.478055] vesafb: framebuffer at 0xe0000000, mapped to 0x(____ptrval____), using 1216k, total 1216k
[    0.480489] Console: switching to colour frame buffer device 80x30
[    0.481244] fb0: VESA VGA frame buffer device
[    0.481294] intel_idle: Please enable MWAIT in BIOS SETUP
[    0.481389] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.481414] ACPI: Power Button [PWRF]
[    0.481485] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
[    0.481491] ACPI: Sleep Button [SLPF]
[    0.481593] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    0.481678] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:00/input/input2
[    0.482373] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.490476] ledtrig-cpu: registered to indicate activity on CPUs
[    0.490710] NET: Registered protocol family 10
[    0.505142] Segment Routing with IPv6
[    0.505185] NET: Registered protocol family 17
[    0.505572] RAS: Correctable Errors collector initialized.
[    0.505588] sched_clock: Marking stable (505509868, 0)->(823528256, -318018388)
[    0.506354] registered taskstats version 1
[    0.506365] Loading compiled-in X.509 certificates
[    0.506387] zswap: loaded using pool lzo/zbud
[    0.515022] Key type big_key registered
[    0.515264]   Magic number: 2:792:522
[    0.515302] hctosys: unable to open rtc device (rtc0)
[    0.525768] Freeing unused kernel image memory: 1492K
[    0.525876] Write protecting the kernel read-only data: 16384k
[    0.527846] Freeing unused kernel image memory: 2016K
[    0.528593] Freeing unused kernel image memory: 568K
[    0.607501] SCSI subsystem initialized
[    0.636094] ACPI: bus type USB registered
[    0.636122] usbcore: registered new interface driver usbfs
[    0.636133] usbcore: registered new interface driver hub
[    0.636341] usbcore: registered new device driver usb
[    0.642061] libata version 3.00 loaded.
[    0.643517] ata_piix 0000:00:01.1: version 2.13
[    0.662205] scsi host0: ata_piix
[    0.664586] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.665193] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.668522] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.670605] scsi host1: ata_piix
[    0.670700] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xd000 irq 14
[    0.670703] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xd008 irq 15
[    0.684217] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.684738] xhci_hcd 0000:00:0c.0: xHCI Host Controller
[    0.684747] xhci_hcd 0000:00:0c.0: new USB bus registered, assigned bus number 1
[    1.075827] ata1.01: NODEV after polling detection
[    1.076074] ata1.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
[    1.076076] ata1.00: 41943040 sectors, multi 128: LBA 
[    1.076669] xhci_hcd 0000:00:0c.0: hcc params 0x04000000 hci version 0x100 quirks 0x000000000000b930
[    1.076748] scsi 0:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
[    1.077547] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 4.18
[    1.077551] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.077553] usb usb1: Product: xHCI Host Controller
[    1.077555] usb usb1: Manufacturer: Linux 4.18.5-arch1-1-ARCH xhci-hcd
[    1.077557] usb usb1: SerialNumber: 0000:00:0c.0
[    1.078078] hub 1-0:1.0: USB hub found
[    1.078187] hub 1-0:1.0: 8 ports detected
[    1.080347] xhci_hcd 0000:00:0c.0: xHCI Host Controller
[    1.080353] xhci_hcd 0000:00:0c.0: new USB bus registered, assigned bus number 2
[    1.080359] xhci_hcd 0000:00:0c.0: Host supports USB 3.0  SuperSpeed
[    1.080645] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 4.18
[    1.080648] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.080650] usb usb2: Product: xHCI Host Controller
[    1.080652] usb usb2: Manufacturer: Linux 4.18.5-arch1-1-ARCH xhci-hcd
[    1.080653] usb usb2: SerialNumber: 0000:00:0c.0
[    1.080868] hub 2-0:1.0: USB hub found
[    1.080908] hub 2-0:1.0: 6 ports detected
[    1.088766] sd 0:0:0:0: [sda] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
[    1.088781] sd 0:0:0:0: [sda] Write Protect is off
[    1.088783] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.088801] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.098859]  sda: sda1 sda2
[    1.099630] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.226504] raid6: sse2x1   gen()  5525 MB/s
[    1.286935] raid6: sse2x1   xor()  3925 MB/s
[    1.351882] raid6: sse2x2   gen()  6373 MB/s
[    1.409812] raid6: sse2x2   xor()  5337 MB/s
[    1.466925] raid6: sse2x4   gen()  7334 MB/s
[    1.530167] usb 1-1: new high-speed USB device number 2 using xhci_hcd
[    1.530205] raid6: sse2x4   xor()  3160 MB/s
[    1.586811] raid6: avx2x1   gen()  2545 MB/s
[    1.647330] raid6: avx2x1   xor()  4374 MB/s
[    1.689474] usb 1-1: New USB device found, idVendor=152d, idProduct=0539, bcdDevice= 2.06
[    1.689478] usb 1-1: New USB device strings: Mfr=10, Product=11, SerialNumber=3
[    1.689480] usb 1-1: Product: External USB 3.0
[    1.689482] usb 1-1: Manufacturer: Intenso
[    1.689484] usb 1-1: SerialNumber: 20120625001B2
[    1.698164] usb-storage 1-1:1.0: USB Mass Storage device detected
[    1.705386] usb-storage 1-1:1.0: Quirks match for vid 152d pid 0539: 4000000
[    1.705467] scsi host2: usb-storage 1-1:1.0
[    1.706162] usbcore: registered new interface driver usb-storage
[    1.711960] raid6: avx2x2   gen() 10713 MB/s
[    1.766779] raid6: avx2x2   xor()  5911 MB/s
[    1.823481] raid6: avx2x4   gen() 12573 MB/s
[    1.882040] raid6: avx2x4   xor()  8853 MB/s
[    1.882046] raid6: using algorithm avx2x4 gen() 12573 MB/s
[    1.882048] raid6: .... xor() 8853 MB/s, rmw enabled
[    1.882051] raid6: using avx2x2 recovery algorithm
[    1.882382] usb 2-1: new SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[    1.888787] xor: automatically using best checksumming function   avx       
[    1.898493] usb 2-1: New USB device found, idVendor=152d, idProduct=0539, bcdDevice= 2.06
[    1.898496] usb 2-1: New USB device strings: Mfr=10, Product=11, SerialNumber=3
[    1.898498] usb 2-1: Product: External USB 3.0
[    1.898500] usb 2-1: Manufacturer: Intenso
[    1.898502] usb 2-1: SerialNumber: 2012071215002
[    1.899974] usb-storage 2-1:1.0: USB Mass Storage device detected
[    1.903413] usb-storage 2-1:1.0: Quirks match for vid 152d pid 0539: 4000000
[    1.903466] scsi host3: usb-storage 2-1:1.0
[    1.918187] Btrfs loaded, crc32c=crc32c-intel
[    1.918798] BTRFS: device label rootfs devid 1 transid 42 /dev/sda2
[    1.949726] BTRFS info (device sda2): disk space caching is enabled
[    1.949728] BTRFS info (device sda2): has skinny extents
[    2.054552] random: fast init done
[    2.220202] systemd[1]: systemd 239 running in system mode. (+PAM -AUDIT -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN +PCRE2 default-hierarchy=hybrid)
[    2.220232] systemd[1]: Detected virtualization oracle.
[    2.220236] systemd[1]: Detected architecture x86-64.
[    2.225882] systemd[1]: Set hostname to <archlinux>.
[    2.356325] random: systemd: uninitialized urandom read (16 bytes read)
[    2.356378] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    2.356424] random: systemd: uninitialized urandom read (16 bytes read)
[    2.356535] systemd[1]: Listening on Journal Socket.
[    2.356711] random: systemd: uninitialized urandom read (16 bytes read)
[    2.360224] systemd[1]: Mounting Kernel Configuration File System...
[    2.361606] systemd[1]: Listening on udev Kernel Socket.
[    2.361764] systemd[1]: Reached target Remote Encrypted Volumes.
[    2.361941] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    2.422287] BTRFS info (device sda2): disk space caching is enabled
[    2.550188] systemd-journald[216]: Received request to flush runtime journal from PID 1
[    2.662915] systemd-journald[216]: File /var/log/journal/d8b7d823fa4b4e219a8c84bf6d1fe82c/system.journal corrupted or uncleanly shut down, renaming and replacing.
[    2.717817] scsi 2:0:0:0: Direct-Access     Intenso  External USB 3.0 0206 PQ: 0 ANSI: 6
[    2.719008] sd 2:0:0:0: [sdb] 1953523712 512-byte logical blocks: (1.00 TB/932 GiB)
[    2.719866] sd 2:0:0:0: [sdb] Write Protect is off
[    2.719869] sd 2:0:0:0: [sdb] Mode Sense: 27 00 00 00
[    2.721935] sd 2:0:0:0: [sdb] No Caching mode page found
[    2.722009] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    2.728515]  sdb: sdb1 sdb2
[    2.729066] sdb: p2 size 19914992 extends beyond EOD, enabling native capacity
[    2.733219]  sdb: sdb1 sdb2
[    2.733988] sdb: p2 size 19914992 extends beyond EOD, truncated
[    2.737554] sd 2:0:0:0: [sdb] Attached SCSI disk
[    2.870788] ACPI: Battery Slot [BAT0] (battery present)
[    2.871906] Linux agpgart interface v0.103
[    2.875858] ACPI: AC Adapter [AC] (on-line)
[    2.881081] piix4_smbus 0000:00:07.0: SMBus Host Controller at 0x4100, revision 0
[    2.885979] vboxguest: host-version: 5.2.18r123745 0x1
[    2.886675] vbg_heartbeat_init: Setting up heartbeat to trigger every 2000 milliseconds
[    2.889343] input: VirtualBox mouse integration as /devices/pci0000:00/0000:00:04.0/input/input5
[    2.890385] vboxguest: misc device minor 57, IRQ 20, I/O port d020, MMIO at 0x00000000f0400000 (size 0x0000000000400000)
[    2.905724] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    2.905725] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.931231] rtc_cmos rtc_cmos: registered as rtc0
[    2.931249] rtc_cmos rtc_cmos: alarms up to one day, 114 bytes nvram
[    2.934276] scsi 3:0:0:0: Direct-Access     Intenso  External USB 3.0 0206 PQ: 0 ANSI: 6
[    2.934913] sd 3:0:0:0: [sdc] 1953523712 512-byte logical blocks: (1.00 TB/932 GiB)
[    2.935369] sd 3:0:0:0: [sdc] Write Protect is off
[    2.935372] sd 3:0:0:0: [sdc] Mode Sense: 27 00 00 00
[    2.935803] sd 3:0:0:0: [sdc] No Caching mode page found
[    2.935862] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[    2.939364]  sdc: sdc1
[    2.941245] sd 3:0:0:0: [sdc] Attached SCSI disk
[    2.971012] usbcore: registered new interface driver uas
[    2.976712] RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters, 10737418240 ms ovfl timer
[    2.976713] RAPL PMU: hw unit of domain pp0-core 2^-0 Joules
[    2.976714] RAPL PMU: hw unit of domain package 2^-0 Joules
[    2.976715] RAPL PMU: hw unit of domain dram 2^-0 Joules
[    2.976716] RAPL PMU: hw unit of domain pp1-gpu 2^-0 Joules
[    2.997577] input: PC Speaker as /devices/platform/pcspkr/input/input7
[    3.022025] Adding 2024444k swap on /dev/sda1.  Priority:-2 extents:1 across:2024444k FS
[    3.058370] cryptd: max_cpu_qlen set to 1000
[    3.086189] AVX2 version of gcm_enc/dec engaged.
[    3.086191] AES CTR mode by8 optimization enabled
[    3.089852] mousedev: PS/2 mouse device common for all mice
[    3.168389] vboxvideo: module is from the staging directory, the quality is unknown, you have been warned.
[    3.171996] [drm] VRAM 00800000
[    3.176777] [TTM] Zone  kernel: Available graphics memory: 2021432 kiB
[    3.176779] [TTM] Initializing pool allocator
[    3.176782] [TTM] Initializing DMA pool allocator
[    3.179667] checking generic (e0000000 130000) vs hw (e0000000 800000)
[    3.179668] fb: switching to vboxdrmfb from VESA VGA
[    3.179689] Console: switching to colour dummy device 80x25
[    3.181528] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input6
[    3.181887] fbcon: vboxdrmfb (fb0) is primary device
[    3.182621] Console: switching to colour frame buffer device 100x37
[    3.183900] vboxvideo 0000:00:02.0: fb0: vboxdrmfb frame buffer device
[    3.203426] [drm] Initialized vboxvideo 1.0.0 20130823 for 0000:00:02.0 on minor 0
[    3.262796] BTRFS: device label intenso_usb_black devid 1 transid 57 /dev/sdc1
[    3.272853] BTRFS: device label intenso_white devid 1 transid 4790 /dev/sdb1
[    3.811983] vboxsf: loading out-of-tree module taints kernel.
[    4.009067] random: crng init done
[    4.009080] random: 7 urandom warning(s) missed due to ratelimiting
[    4.020238] snd_intel8x0 0000:00:05.0: intel8x0_measure_ac97_clock: measured 58895 usecs (14336 samples)
[    4.020242] snd_intel8x0 0000:00:05.0: measured clock 243416 rejected
[    4.099036] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 08:00:27:b4:cd:7d
[    4.099043] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.111316] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.415332] snd_intel8x0 0000:00:05.0: intel8x0_measure_ac97_clock: measured 57377 usecs (14336 samples)
[    4.415338] snd_intel8x0 0000:00:05.0: measured clock 249856 rejected
[    4.838448] snd_intel8x0 0000:00:05.0: intel8x0_measure_ac97_clock: measured 47261 usecs (11264 samples)
[    4.838452] snd_intel8x0 0000:00:05.0: measured clock 238336 rejected
[    4.838454] snd_intel8x0 0000:00:05.0: clocking to 48000
[    6.299323] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[    6.299751] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   10.588498] audit: type=1006 audit(1536222772.771:2): pid=319 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=1 res=1
[   10.653278] audit: type=1006 audit(1536222772.834:3): pid=322 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=2 res=1
[   10.799356] systemd-journald[216]: File /var/log/journal/d8b7d823fa4b4e219a8c84bf6d1fe82c/user-1000.journal corrupted or uncleanly shut down, renaming and replacing.
[  141.213745] usb 2-1: USB disconnect, device number 2
[  239.329476] audit: type=1006 audit(1536223001.473:4): pid=510 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=3 res=1
[  239.353422] audit: type=1006 audit(1536223001.497:5): pid=513 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=4 res=1
[  260.645105] audit: type=1006 audit(1536223022.793:6): pid=528 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=5 res=1
[  260.666712] audit: type=1006 audit(1536223022.816:7): pid=531 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=6 res=1
[  285.729540] audit: type=1006 audit(1536223047.883:8): pid=2951 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=7 res=1
[  285.750233] audit: type=1006 audit(1536223047.900:9): pid=2954 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=8 res=1
[  302.217171] BTRFS info (device sdb1): disk space caching is enabled
[  302.217173] BTRFS info (device sdb1): has skinny extents
[  631.223843] audit: type=1006 audit(1536223393.390:10): pid=3029 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=9 res=1

--------------1CD475EC96BFB3B804600C07--
