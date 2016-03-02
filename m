Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34918 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbcCBV4I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 16:56:08 -0500
Received: by mail-pf0-f176.google.com with SMTP id w128so1455008pfb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Mar 2016 13:56:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH4oapdmQQVwpPD0JNufak7A-=Y=RBNugsM_0Bz=edUG2KRFAw@mail.gmail.com>
References: <1456950881.15729.2.camel@gmail.com>
	<CAH4oapdmQQVwpPD0JNufak7A-=Y=RBNugsM_0Bz=edUG2KRFAw@mail.gmail.com>
Date: Wed, 2 Mar 2016 15:56:07 -0600
Message-ID: <CABmfUYCQVaCHPBzQ4_SUrD=36-7iMarrHpAUd_DGjJxx2zfYbQ@mail.gmail.com>
Subject: Re: duplicate automounts with btrfs RAID1
From: Leigh Orf <leigh.orf@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary=94eb2c0b7d46f737b2052d17f2bf
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--94eb2c0b7d46f737b2052d17f2bf
Content-Type: text/plain; charset=UTF-8

On Wed, Mar 2, 2016 at 3:34 PM, Pavol Cupka <pavol.cupka@gmail.com> wrote:
> is anything in dmesg that would point to diskscontrollers being reset?
>
> or something like that?
>
> pavol

Pavol,

Hmm, yes, there are some weird things going on. I am attaching what I
see as the relevant bits from /var/log/messages (command: egrep
'(sd[cd]|mount)' /var/log/messages)

Note, /dev/sdc is disk 1 and /dev/sdd is disk 2 (the two btrfs RAID1 members).

Leigh

>
> On Wed, Mar 2, 2016 at 9:34 PM, Leigh Orf <leigh.orf@gmail.com> wrote:
>> Hello,
>>
>> Not entirely sure this is a btrfs issue, but here is my problem. I've
>> had this issue with recent Fedora and CentOS distros.
>>
>> I created a btrfs RAID 1 pair with two identical USB external drives,
>> following the instructions found online:
>>
>> mkfs.btrfs -m raid1 -d raid1 /dev/sdc1 /dev/sdd1
>>
>> Then I mount it as /ext1:
>>
>> % df |grep sdc
>> /dev/sdc1      9767539112 1280   9765383552   1% /ext1
>>
>> The problem? Over time, /dev/sdc1 keeps getting mounted under a
>> different mount point, these accrue a couple per day:
>>
>> % mount|grep sdc
>> /dev/sdc1 on /ext1 type btrfs (rw,relatime,space_cache)
>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd1 type
>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd11 type
>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd12 type
>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd13 type
>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd14 type
>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd15 type
>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd16 type
>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd17 type
>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd18 type
>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>> /dev/sdc1 on /run/media/fred/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxx38fd19 type
>> btrfs (rw,nosuid,nodev,relatime,space_cache)
>>
>> It's as if the OS keeps "discovering a new disk" and mounting it
>> under /run/media (where things like external drives, thumb drives etc.
>> automount).
>>
>> Here is info about my setup (up to date CentOS 7.2):
>>
>> % cat /etc/system-release
>> CentOS Linux release 7.2.1511 (Core)
>> % uname -a
>> Linux xxx.xxx.xxx.edu 3.10.0-123.20.1.el7.x86_64 #1 SMP Thu Jan 29
>> 18:05:33 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>> % btrfs --version
>> btrfs-progs v3.19.1
>> % btrfs fi show
>> Label: none  uuid: d9706351-609b-4c6e-9f37-7058bb038fd1
>>         Total devices 2 FS bytes used 640.00KiB
>>         devid    1 size 4.55TiB used 2.03GiB path /dev/sdc1
>>         devid    2 size 4.55TiB used 2.01GiB path /dev/sdd1
>>
>> btrfs-progs v3.19.1
>> % btrfs fi df /ext1
>> Data, RAID1: total=1.00GiB, used=512.00KiB
>> Data, single: total=8.00MiB, used=0.00B
>> System, RAID1: total=8.00MiB, used=16.00KiB
>> System, single: total=4.00MiB, used=0.00B
>> Metadata, RAID1: total=1.00GiB, used=112.00KiB
>> Metadata, single: total=8.00MiB, used=0.00B
>>
>> Periodically I manually unmount these duplicates, but they come back.
>> I'd like a solution that doesn't involve disabling automount all
>> together.
>>
>> Thanks for any pointers, and apologies if this issue is unrelated to the
>> btrfs project.
>>
>> Leigh
>>
>> --
>> Leigh Orf
>> Associate Scientist
>> Cooperative Institute for Meteorological Satellite Studies
>> University of Wisconsin - Madison
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--94eb2c0b7d46f737b2052d17f2bf
Content-Type: text/plain; charset=US-ASCII; name="btrfs-automount-log.txt"
Content-Disposition: attachment; filename="btrfs-automount-log.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ilbds0990

JSBzdWRvIGVncmVwICcoc2RbY2RdfG1vdW50KScgL3Zhci9sb2cvbWVzc2FnZXMKRmViIDI5IDA5
OjAyOjQ1IHh4eCBrZXJuZWw6IFs1Nzc1MTcuOTAwMjA2XSBidHJmczogZGV2aWNlIGZzaWQgeHh4
eHh4eHgteHh4eC14eHh4LXh4eHgteHh4eHh4eHh4eGQxIGRldmlkIDIgdHJhbnNpZCA3IC9kZXYv
c2RkMQpGZWIgMjkgMDk6MDI6NDUgeHh4IHVkaXNrc2RbMTMxODVdOiBNb3VudGVkIC9kZXYvc2Rk
MSBhdCAvcnVuL21lZGlhL2ZyZWQveHh4eHh4eHgteHh4eC14eHh4LXh4eHgteHh4eHh4eHh4eGQx
IG9uIGJlaGFsZiBvZiB1aWQgMTUzMjEKRmViIDI5IDEwOjI2OjI5IHh4eCBrZXJuZWw6IFs1ODI1
NDIuMzA3NjE3XSBidHJmczogZGV2aWNlIGZzaWQgeHh4eHh4eHgteHh4eC14eHh4LXh4eHgteHh4
eHh4eHh4eGQxIGRldmlkIDIgdHJhbnNpZCA3IC9kZXYvc2RkMQpGZWIgMjkgMTA6MjY6MjkgeHh4
IHVkaXNrc2RbMTMxODVdOiBNb3VudGVkIC9kZXYvc2RkMSBhdCAvcnVuL21lZGlhL2ZyZWQveHh4
eHh4eHgteHh4eC14eHh4LXh4eHgteHh4eHh4eHh4eGQxMSBvbiBiZWhhbGYgb2YgdWlkIDE1MzIx
CkZlYiAyOSAxMToyMzo0MCB4eHggc3lzdGVtZFsxXTogU3RvcHBpbmcgQXV0b21vdW50cyBmaWxl
c3lzdGVtcyBvbiBkZW1hbmQuLi4KRmViIDI5IDExOjIzOjQxIHh4eCBzeXN0ZW1kWzFdOiBTdGFy
dGluZyBBdXRvbW91bnRzIGZpbGVzeXN0ZW1zIG9uIGRlbWFuZC4uLgpGZWIgMjkgMTE6MjM6NDEg
eHh4IHVkaXNrc2RbMTMxODVdOiBDbGVhbmluZyB1cCBtb3VudCBwb2ludCAvcnVuL21lZGlhL2Zy
ZWQveHh4eHh4eHgteHh4eC14eHh4LXh4eHgteHh4eHh4eHh4eGQxIChkZXZpY2UgODo0OSBpcyBu
b3QgbW91bnRlZCkKRmViIDI5IDExOjIzOjQxIHh4eCB1ZGlza3NkWzEzMTg1XTogRXJyb3IgY2xl
YW5pbmcgdXAgbW91bnQgcG9pbnQgL3J1bi9tZWRpYS9mcmVkL3h4eHh4eHh4LXh4eHgteHh4eC14
eHh4LXh4eHh4eHh4eHhkMTogRXJyb3IgcmVtb3ZpbmcgZGlyZWN0b3J5OiBEZXZpY2Ugb3IgcmVz
b3VyY2UgYnVzeQpGZWIgMjkgMTE6MjM6NDEgeHh4IHVkaXNrc2RbMTMxODVdOiBDbGVhbmluZyB1
cCBtb3VudCBwb2ludCAvcnVuL21lZGlhL2ZyZWQveHh4eHh4eHgteHh4eC14eHh4LXh4eHgteHh4
eHh4eHh4eGQxMSAoZGV2aWNlIDg6NDkgaXMgbm90IG1vdW50ZWQpCkZlYiAyOSAxMToyMzo0MSB4
eHggdWRpc2tzZFsxMzE4NV06IEVycm9yIGNsZWFuaW5nIHVwIG1vdW50IHBvaW50IC9ydW4vbWVk
aWEvZnJlZC94eHh4eHh4eC14eHh4LXh4eHgteHh4eC14eHh4eHh4eHh4ZDExOiBFcnJvciByZW1v
dmluZyBkaXJlY3Rvcnk6IERldmljZSBvciByZXNvdXJjZSBidXN5CkZlYiAyOSAxMToyMzo0MSB4
eHggdWRpc2tzZFsxMzE4NV06IENsZWFuaW5nIHVwIG1vdW50IHBvaW50IC9ydW4vbWVkaWEvZnJl
ZC94eHh4eHh4eC14eHh4LXh4eHgteHh4eC14eHh4eHh4eHh4ZDEgKGRldmljZSA4OjQ5IGlzIG5v
dCBtb3VudGVkKQpGZWIgMjkgMTE6MjM6NDEgeHh4IHVkaXNrc2RbMTMxODVdOiBFcnJvciBjbGVh
bmluZyB1cCBtb3VudCBwb2ludCAvcnVuL21lZGlhL2ZyZWQveHh4eHh4eHgteHh4eC14eHh4LXh4
eHgteHh4eHh4eHh4eGQxOiBFcnJvciByZW1vdmluZyBkaXJlY3Rvcnk6IERldmljZSBvciByZXNv
dXJjZSBidXN5CkZlYiAyOSAxMToyMzo0MSB4eHggdWRpc2tzZFsxMzE4NV06IENsZWFuaW5nIHVw
IG1vdW50IHBvaW50IC9ydW4vbWVkaWEvZnJlZC94eHh4eHh4eC14eHh4LXh4eHgteHh4eC14eHh4
eHh4eHh4ZDExIChkZXZpY2UgODo0OSBpcyBub3QgbW91bnRlZCkKRmViIDI5IDExOjIzOjQxIHh4
eCB1ZGlza3NkWzEzMTg1XTogRXJyb3IgY2xlYW5pbmcgdXAgbW91bnQgcG9pbnQgL3J1bi9tZWRp
YS9mcmVkL3h4eHh4eHh4LXh4eHgteHh4eC14eHh4LXh4eHh4eHh4eHhkMTE6IEVycm9yIHJlbW92
aW5nIGRpcmVjdG9yeTogRGV2aWNlIG9yIHJlc291cmNlIGJ1c3kKRmViIDI5IDExOjIzOjQxIHh4
eCBzeXN0ZW1kWzFdOiBTdGFydGVkIEF1dG9tb3VudHMgZmlsZXN5c3RlbXMgb24gZGVtYW5kLgpG
ZWIgMjkgMTM6NTM6MjIgeHh4IGtlcm5lbDogWzU5NDk1NS4yMjUyNTldIGJ0cmZzOiBkZXZpY2Ug
ZnNpZCB4eHh4eHh4eC14eHh4LXh4eHgteHh4eC14eHh4eHh4eHh4ZDEgZGV2aWQgMiB0cmFuc2lk
IDcgL2Rldi9zZGQxCkZlYiAyOSAxMzo1MzoyMiB4eHggdWRpc2tzZFsxMzE4NV06IE1vdW50ZWQg
L2Rldi9zZGQxIGF0IC9ydW4vbWVkaWEvZnJlZC94eHh4eHh4eC14eHh4LXh4eHgteHh4eC14eHh4
eHh4eHh4ZDEyIG9uIGJlaGFsZiBvZiB1aWQgMTUzMjEKTWFyICAxIDA5OjM3OjAxIHh4eCBrZXJu
ZWw6IFs2NjU5NzQuMDIzMTg0XSBidHJmczogZGV2aWNlIGZzaWQgeHh4eHh4eHgteHh4eC14eHh4
LXh4eHgteHh4eHh4eHh4eGQxIGRldmlkIDIgdHJhbnNpZCA3IC9kZXYvc2RkMQpNYXIgIDEgMDk6
Mzc6MDEgeHh4IHVkaXNrc2RbMTMxODVdOiBNb3VudGVkIC9kZXYvc2RkMSBhdCAvcnVuL21lZGlh
L2ZyZWQveHh4eHh4eHgteHh4eC14eHh4LXh4eHgteHh4eHh4eHh4eGQxMyBvbiBiZWhhbGYgb2Yg
dWlkIDE1MzIxCk1hciAgMSAxMzowNzoyNSB4eHgga2VybmVsOiBbNjc4NTk4LjAzMTM3M10gYnRy
ZnM6IGRldmljZSBmc2lkIHh4eHh4eHh4LXh4eHgteHh4eC14eHh4LXh4eHh4eHh4eHhkMSBkZXZp
ZCAyIHRyYW5zaWQgNyAvZGV2L3NkZDEKTWFyICAxIDEzOjA3OjI1IHh4eCB1ZGlza3NkWzEzMTg1
XTogTW91bnRlZCAvZGV2L3NkZDEgYXQgL3J1bi9tZWRpYS9mcmVkL3h4eHh4eHh4LXh4eHgteHh4
eC14eHh4LXh4eHh4eHh4eHhkMTQgb24gYmVoYWxmIG9mIHVpZCAxNTMyMQpNYXIgIDEgMTM6NDg6
MjcgeHh4IGtlcm5lbDogWzY4MTA2MC41MzQ5OTddIGJ0cmZzOiBkZXZpY2UgZnNpZCB4eHh4eHh4
eC14eHh4LXh4eHgteHh4eC14eHh4eHh4eHh4ZDEgZGV2aWQgMiB0cmFuc2lkIDcgL2Rldi9zZGQx
Ck1hciAgMSAxMzo0ODoyNyB4eHggdWRpc2tzZFsxMzE4NV06IE1vdW50ZWQgL2Rldi9zZGQxIGF0
IC9ydW4vbWVkaWEvZnJlZC94eHh4eHh4eC14eHh4LXh4eHgteHh4eC14eHh4eHh4eHh4ZDE1IG9u
IGJlaGFsZiBvZiB1aWQgMTUzMjEKTWFyICAxIDE2OjMwOjQ2IHh4eCBrZXJuZWw6IFs2OTA3OTku
NTc3MDY2XSBidHJmczogZGV2aWNlIGZzaWQgeHh4eHh4eHgteHh4eC14eHh4LXh4eHgteHh4eHh4
eHh4eGQxIGRldmlkIDIgdHJhbnNpZCA3IC9kZXYvc2RkMQpNYXIgIDEgMTY6MzA6NDYgeHh4IHVk
aXNrc2RbMTMxODVdOiBNb3VudGVkIC9kZXYvc2RkMSBhdCAvcnVuL21lZGlhL2ZyZWQveHh4eHh4
eHgteHh4eC14eHh4LXh4eHgteHh4eHh4eHh4eGQxNiBvbiBiZWhhbGYgb2YgdWlkIDE1MzIxCk1h
ciAgMiAwOTowNjoyNiB4eHgga2VybmVsOiBbNzUwNTM5LjUzNDY1MV0gYnRyZnM6IGRldmljZSBm
c2lkIHh4eHh4eHh4LXh4eHgteHh4eC14eHh4LXh4eHh4eHh4eHhkMSBkZXZpZCAyIHRyYW5zaWQg
NyAvZGV2L3NkZDEKTWFyICAyIDA5OjA2OjI2IHh4eCB1ZGlza3NkWzEzMTg1XTogTW91bnRlZCAv
ZGV2L3NkZDEgYXQgL3J1bi9tZWRpYS9mcmVkL3h4eHh4eHh4LXh4eHgteHh4eC14eHh4LXh4eHh4
eHh4eHhkMTcgb24gYmVoYWxmIG9mIHVpZCAxNTMyMQpNYXIgIDIgMTA6MDk6MzQgeHh4IHVkaXNr
c2RbMTMxODVdOiBDbGVhbmluZyB1cCBtb3VudCBwb2ludCAvcnVuL21lZGlhL2ZyZWQveHh4eHh4
eHgteHh4eC14eHh4LXh4eHgteHh4eHh4eHh4eGQxIChkZXZpY2UgODo0OSBpcyBub3QgbW91bnRl
ZCkKTWFyICAyIDEwOjA5OjM0IHh4eCB1ZGlza3NkWzEzMTg1XTogRXJyb3IgY2xlYW5pbmcgdXAg
bW91bnQgcG9pbnQgL3J1bi9tZWRpYS9mcmVkL3h4eHh4eHh4LXh4eHgteHh4eC14eHh4LXh4eHh4
eHh4eHhkMTogRXJyb3IgcmVtb3ZpbmcgZGlyZWN0b3J5OiBEZXZpY2Ugb3IgcmVzb3VyY2UgYnVz
eQpNYXIgIDIgMTA6MDk6MzQgeHh4IHVkaXNrc2RbMTMxODVdOiBDbGVhbmluZyB1cCBtb3VudCBw
b2ludCAvcnVuL21lZGlhL2ZyZWQveHh4eHh4eHgteHh4eC14eHh4LXh4eHgteHh4eHh4eHh4eGQx
MSAoZGV2aWNlIDg6NDkgaXMgbm90IG1vdW50ZWQpCk1hciAgMiAxMDowOTozNCB4eHggdWRpc2tz
ZFsxMzE4NV06IEVycm9yIGNsZWFuaW5nIHVwIG1vdW50IHBvaW50IC9ydW4vbWVkaWEvZnJlZC94
eHh4eHh4eC14eHh4LXh4eHgteHh4eC14eHh4eHh4eHh4ZDExOiBFcnJvciByZW1vdmluZyBkaXJl
Y3Rvcnk6IERldmljZSBvciByZXNvdXJjZSBidXN5Ck1hciAgMiAxMDowOTozNCB4eHggdWRpc2tz
ZFsxMzE4NV06IENsZWFuaW5nIHVwIG1vdW50IHBvaW50IC9ydW4vbWVkaWEvZnJlZC94eHh4eHh4
eC14eHh4LXh4eHgteHh4eC14eHh4eHh4eHh4ZDEyIChkZXZpY2UgODo0OSBpcyBub3QgbW91bnRl
ZCkKTWFyICAyIDEwOjA5OjM0IHh4eCB1ZGlza3NkWzEzMTg1XTogRXJyb3IgY2xlYW5pbmcgdXAg
bW91bnQgcG9pbnQgL3J1bi9tZWRpYS9mcmVkL3h4eHh4eHh4LXh4eHgteHh4eC14eHh4LXh4eHh4
eHh4eHhkMTI6IEVycm9yIHJlbW92aW5nIGRpcmVjdG9yeTogRGV2aWNlIG9yIHJlc291cmNlIGJ1
c3kKTWFyICAyIDEwOjA5OjM0IHh4eCB1ZGlza3NkWzEzMTg1XTogQ2xlYW5pbmcgdXAgbW91bnQg
cG9pbnQgL3J1bi9tZWRpYS9mcmVkL3h4eHh4eHh4LXh4eHgteHh4eC14eHh4LXh4eHh4eHh4eHhk
MTMgKGRldmljZSA4OjQ5IGlzIG5vdCBtb3VudGVkKQpNYXIgIDIgMTA6MDk6MzQgeHh4IHVkaXNr
c2RbMTMxODVdOiBFcnJvciBjbGVhbmluZyB1cCBtb3VudCBwb2ludCAvcnVuL21lZGlhL2ZyZWQv
eHh4eHh4eHgteHh4eC14eHh4LXh4eHgteHh4eHh4eHh4eGQxMzogRXJyb3IgcmVtb3ZpbmcgZGly
ZWN0b3J5OiBEZXZpY2Ugb3IgcmVzb3VyY2UgYnVzeQpNYXIgIDIgMTA6MDk6MzQgeHh4IHVkaXNr
c2RbMTMxODVdOiBDbGVhbmluZyB1cCBtb3VudCBwb2ludCAvcnVuL21lZGlhL2ZyZWQveHh4eHh4
eHgteHh4eC14eHh4LXh4eHgteHh4eHh4eHh4eGQxNCAoZGV2aWNlIDg6NDkgaXMgbm90IG1vdW50
ZWQpCk1hciAgMiAxMDowOTozNCB4eHggdWRpc2tzZFsxMzE4NV06IEVycm9yIGNsZWFuaW5nIHVw
IG1vdW50IHBvaW50IC9ydW4vbWVkaWEvZnJlZC94eHh4eHh4eC14eHh4LXh4eHgteHh4eC14eHh4
eHh4eHh4ZDE0OiBFcnJvciByZW1vdmluZyBkaXJlY3Rvcnk6IERldmljZSBvciByZXNvdXJjZSBi
dXN5Ck1hciAgMiAxMDowOTozNCB4eHggdWRpc2tzZFsxMzE4NV06IENsZWFuaW5nIHVwIG1vdW50
IHBvaW50IC9ydW4vbWVkaWEvZnJlZC94eHh4eHh4eC14eHh4LXh4eHgteHh4eC14eHh4eHh4eHh4
ZDE1IChkZXZpY2UgODo0OSBpcyBub3QgbW91bnRlZCkKTWFyICAyIDEwOjA5OjM0IHh4eCB1ZGlz
a3NkWzEzMTg1XTogRXJyb3IgY2xlYW5pbmcgdXAgbW91bnQgcG9pbnQgL3J1bi9tZWRpYS9mcmVk
L3h4eHh4eHh4LXh4eHgteHh4eC14eHh4LXh4eHh4eHh4eHhkMTU6IEVycm9yIHJlbW92aW5nIGRp
cmVjdG9yeTogRGV2aWNlIG9yIHJlc291cmNlIGJ1c3kKTWFyICAyIDEwOjA5OjM0IHh4eCB1ZGlz
a3NkWzEzMTg1XTogQ2xlYW5pbmcgdXAgbW91bnQgcG9pbnQgL3J1bi9tZWRpYS9mcmVkL3h4eHh4
eHh4LXh4eHgteHh4eC14eHh4LXh4eHh4eHh4eHhkMTYgKGRldmljZSA4OjQ5IGlzIG5vdCBtb3Vu
dGVkKQpNYXIgIDIgMTA6MDk6MzQgeHh4IHVkaXNrc2RbMTMxODVdOiBFcnJvciBjbGVhbmluZyB1
cCBtb3VudCBwb2ludCAvcnVuL21lZGlhL2ZyZWQveHh4eHh4eHgteHh4eC14eHh4LXh4eHgteHh4
eHh4eHh4eGQxNjogRXJyb3IgcmVtb3ZpbmcgZGlyZWN0b3J5OiBEZXZpY2Ugb3IgcmVzb3VyY2Ug
YnVzeQpNYXIgIDIgMTA6MDk6MzQgeHh4IHVkaXNrc2RbMTMxODVdOiBDbGVhbmluZyB1cCBtb3Vu
dCBwb2ludCAvcnVuL21lZGlhL2ZyZWQveHh4eHh4eHgteHh4eC14eHh4LXh4eHgteHh4eHh4eHh4
eGQxNyAoZGV2aWNlIDg6NDkgaXMgbm90IG1vdW50ZWQpCk1hciAgMiAxMDowOTozNCB4eHggdWRp
c2tzZFsxMzE4NV06IEVycm9yIGNsZWFuaW5nIHVwIG1vdW50IHBvaW50IC9ydW4vbWVkaWEvZnJl
ZC94eHh4eHh4eC14eHh4LXh4eHgteHh4eC14eHh4eHh4eHh4ZDE3OiBFcnJvciByZW1vdmluZyBk
aXJlY3Rvcnk6IERldmljZSBvciByZXNvdXJjZSBidXN5Ck1hciAgMiAxMDoxMDo1NCB4eHgga2Vy
bmVsOiBbNzU0NDA3LjI2ODI1Nl0gTHVzdHJlOiBVbm1vdW50ZWQgb2R5c3NleS1jbGllbnQKTWFy
ICAyIDEyOjM0OjIzIHh4eCBrZXJuZWw6IFs3NjMwMTYuMDU5MDUyXSBidHJmczogZGV2aWNlIGZz
aWQgeHh4eHh4eHgteHh4eC14eHh4LXh4eHgteHh4eHh4eHh4eGQxIGRldmlkIDIgdHJhbnNpZCA3
IC9kZXYvc2RkMQpNYXIgIDIgMTI6MzQ6MjMgeHh4IHVkaXNrc2RbMTMxODVdOiBNb3VudGVkIC9k
ZXYvc2RkMSBhdCAvcnVuL21lZGlhL2ZyZWQveHh4eHh4eHgteHh4eC14eHh4LXh4eHgteHh4eHh4
eHh4eGQxOCBvbiBiZWhhbGYgb2YgdWlkIDE1MzIxCk1hciAgMiAxMzo0MToxMiB4eHgga2VybmVs
OiBbNzY3MDI1LjE4OTI2Nl0gYnRyZnM6IGRldmljZSBmc2lkIHh4eHh4eHh4LXh4eHgteHh4eC14
eHh4LXh4eHh4eHh4eHhkMSBkZXZpZCAyIHRyYW5zaWQgNyAvZGV2L3NkZDEKTWFyICAyIDEzOjQx
OjEyIHh4eCB1ZGlza3NkWzEzMTg1XTogTW91bnRlZCAvZGV2L3NkZDEgYXQgL3J1bi9tZWRpYS9m
cmVkL3h4eHh4eHh4LXh4eHgteHh4eC14eHh4LXh4eHh4eHh4eHhkMTkgb24gYmVoYWxmIG9mIHVp
ZCAxNTMyMQpNYXIgIDIgMTM6NTE6NDAgeHh4IGtlcm5lbDogWzc2NzY1My42MDE1MzddIGJ0cmZz
OiBkZXZpY2UgZnNpZCB4eHh4eHh4eC14eHh4LXh4eHgteHh4eC14eHh4eHh4eHh4ZDEgZGV2aWQg
MSB0cmFuc2lkIDggL2Rldi9zZGMxCk1hciAgMiAxMzo1MTo0MCB4eHgga2VybmVsOiBbNzY3NjUz
LjYwMTU2OF0gYnRyZnM6IGRldmljZSBmc2lkIHh4eHh4eHh4LXh4eHgteHh4eC14eHh4LXh4eHh4
eHh4eHhkMSBkZXZpZCAyIHRyYW5zaWQgOCAvZGV2L3NkZDEKTWFyICAyIDEzOjUxOjQ2IHh4eCBr
ZXJuZWw6IFs3Njc2NTkuNjc2NDcyXSBidHJmczogZGV2aWNlIGZzaWQgeHh4eHh4eHgteHh4eC14
eHh4LXh4eHgteHh4eHh4eHh4eGQxIGRldmlkIDEgdHJhbnNpZCA4IC9kZXYvc2RjMQpNYXIgIDIg
MTM6NTE6NDYgeHh4IGtlcm5lbDogWzc2NzY1OS42NzY1MjFdIGJ0cmZzOiBkZXZpY2UgZnNpZCB4
eHh4eHh4eC14eHh4LXh4eHgteHh4eC14eHh4eHh4eHh4ZDEgZGV2aWQgMiB0cmFuc2lkIDggL2Rl
di9zZGQxCgo=
--94eb2c0b7d46f737b2052d17f2bf--
