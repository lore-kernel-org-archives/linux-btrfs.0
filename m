Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:35459 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdAYQvj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 11:51:39 -0500
Received: by mail-qt0-f177.google.com with SMTP id x49so26192717qtc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 08:51:39 -0800 (PST)
MIME-Version: 1.0
From: Seamus Connor <seamushc@gmail.com>
Date: Wed, 25 Jan 2017 09:51:17 -0700
Message-ID: <CAE1699BtC+T3uVopV0++PY7g_T=SURuALNJtwYOdFTQi7jcjSg@mail.gmail.com>
Subject: Potential BTRFS receive bug
To: linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary=001a11488ab8ce23620546ee0bb2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--001a11488ab8ce23620546ee0bb2
Content-Type: text/plain; charset=UTF-8

Hello,

In evaluating btrfs for my use case, I stumbled on what appears to be a bug.
Originally, I created two lvm logical volumes on the same physical device each
with a btrfs file system.  I then cloned the linux kernel into the first one,
then attempted to do a btrfs send/receive to "backup" the first filesystem. It
was my intent to continue on and experiment with incremental backups using
btrfs.  However, the first time I ran the 'receive' command it failed with the
following error:

mkfile o25030-9-0
rename o25030-9-0 -> linux/drivers/clk/clk-axi-clkgen.c
ERROR: rename o25030-9-0 -> linux/drivers/clk/clk-axi-clkgen.c failed:
No space left on device

If I manually delete the subvolume create above, and re-run the transfer,
things seem fine.  Further, this doesn't happen every time, but it does happen
frequently.

I created the filesystems with these commands:

# lvcreate -n test-btrfs2 -L50G storage /dev/sdc1
# mkfs.btrfs -f /dev/storage/test-btrfs2
# pvs
  PV         VG      Fmt  Attr PSize   PFree
  /dev/sda3  storage lvm2 a--  463.52g 147.52g
  /dev/sdb1  storage lvm2 a--  465.76g      0
  /dev/sdc1  storage lvm2 a--  476.94g  99.99g
# lvs
  LV          VG      Attr       LSize   Pool Origin Data%  Meta%
Move Log Cpy%Sync Convert
  btrfs       storage -wi-ao---- 742.70g
  slow        storage -wi-ao---- 300.00g
  swap        storage -wi-ao----  16.00g
  test-btrfs  storage -wi-a-----  50.00g
  test-btrfs2 storage -wi-ao----  50.00g

# mount /dev/storage/test-btrfs2 btrfs2
which results in mount options on my system:
/dev/mapper/storage-test--btrfs2 on /home/sconnor/tmp/btrfs2 type
btrfs (rw,relatime,ssd,space_cache,subvolid=5,subvol=/)

# btrfs --version
btrfs-progs v4.9
# uname -a
Linux pylon 4.8.13-1-ARCH #1 SMP PREEMPT Fri Dec 9 07:24:34 CET 2016
x86_64 GNU/Linux


Attached is a script which reproduces this issue within 30-60 seconds on my
system.  I found that it was unnecessary to re-do the send step, so I am only
testing on one FS as below.  If it isn't obvious, the script attached
is not very
good, and requires things to be setup manually before execution.

I can share snap_1.bs.gz, and the btrfs receive log file file upon request.

Thanks,
Seamus

--001a11488ab8ce23620546ee0bb2
Content-Type: application/x-sh; name="test.sh"
Content-Disposition: attachment; filename="test.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iyd6o7nf0

IyEvYmluL2Jhc2gKCiMgIEluIGV2YWx1YXRpbmcgYnRyZnMgZm9yIG15IHVzZSBjYXNlLCBJIHN0
dW1ibGVkIG9uIHdoYXQgYXBwZWFycyB0byBiZSBhIGJ1Zy4KIyAgT3JpZ2luYWxseSwgSSBjcmVh
dGVkIHR3byBsdm0gbG9naWNhbCB2b2x1bWVzIG9uIHRoZSBzYW1lIHBoeXNpY2FsIGRldmljZSBl
YWNoCiMgIHdpdGggYSBidHJmcyBmaWxlIHN5c3RlbS4gIEkgdGhlbiBjbG9uZWQgdGhlIGxpbnV4
IGtlcm5lbCBpbnRvIHRoZSBmaXJzdCBvbmUsCiMgIHRoZW4gYXR0ZW1wdGVkIHRvIGRvIGEgYnRy
ZnMgc2VuZC9yZWNlaXZlIHRvICJiYWNrdXAiIHRoZSBmaXJzdCBmaWxlc3lzdGVtLiBJdAojICB3
YXMgbXkgaW50ZW50IHRvIGNvbnRpbnVlIG9uIGFuZCBleHBlcmltZW50IHdpdGggaW5jcmVtZW50
YWwgYmFja3VwcyB1c2luZwojICBidHJmcy4gIEhvd2V2ZXIsIHRoZSBmaXJzdCB0aW1lIEkgcmFu
IHRoZSAncmVjZWl2ZScgY29tbWFuZCBpdCBmYWlsZWQgd2l0aCB0aGUKIyAgZm9sbG93aW5nIGVy
cm9yOgojICAKIyAgbWtmaWxlIG8yNTAzMC05LTAKIyAgcmVuYW1lIG8yNTAzMC05LTAgLT4gbGlu
dXgvZHJpdmVycy9jbGsvY2xrLWF4aS1jbGtnZW4uYwojICBFUlJPUjogcmVuYW1lIG8yNTAzMC05
LTAgLT4gbGludXgvZHJpdmVycy9jbGsvY2xrLWF4aS1jbGtnZW4uYyBmYWlsZWQ6IE5vIHNwYWNl
IGxlZnQgb24gZGV2aWNlCiMgIAojICBJZiBJIG1hbnVhbGx5IGRlbGV0ZSB0aGUgc3Vidm9sdW1l
IGNyZWF0ZSBhYm92ZSwgYW5kIHJlLXJ1biB0aGUgdHJhbnNmZXIsCiMgIHRoaW5ncyBzZWVtIGZp
bmUuICBGdXJ0aGVyLCB0aGlzIGRvZXNuJ3QgaGFwcGVuIGV2ZXJ5IHRpbWUsIGJ1dCBpdCBkb2Vz
IGhhcHBlbgojICBmcmVxdWVudGx5LgojICAKIyAgSSBjcmVhdGVkIHRoZSBmaWxlc3lzdGVtcyBs
aWtlIHNvOgojICAKIyAgIyBsdmNyZWF0ZSAtbiB0ZXN0LWJ0cmZzMiAtTDUwRyBzdG9yYWdlIC9k
ZXYvc2RjMSAKIyAgIyBta2ZzLmJ0cmZzIC1mIC9kZXYvc3RvcmFnZS90ZXN0LWJ0cmZzMgojICAj
IHB2cwojICAgIFBWICAgICAgICAgVkcgICAgICBGbXQgIEF0dHIgUFNpemUgICBQRnJlZSAgCiMg
ICAgL2Rldi9zZGEzICBzdG9yYWdlIGx2bTIgYS0tICA0NjMuNTJnIDE0Ny41MmcKIyAgICAvZGV2
L3NkYjEgIHN0b3JhZ2UgbHZtMiBhLS0gIDQ2NS43NmcgICAgICAwIAojICAgIC9kZXYvc2RjMSAg
c3RvcmFnZSBsdm0yIGEtLSAgNDc2Ljk0ZyAgOTkuOTlnCiMgICMgbHZzCiMgICAgTFYgICAgICAg
ICAgVkcgICAgICBBdHRyICAgICAgIExTaXplICAgUG9vbCBPcmlnaW4gRGF0YSUgIE1ldGElICBN
b3ZlIExvZyBDcHklU3luYyBDb252ZXJ0CiMgICAgYnRyZnMgICAgICAgc3RvcmFnZSAtd2ktYW8t
LS0tIDc0Mi43MGcgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgCiMgICAgc2xvdyAgICAgICAgc3RvcmFnZSAtd2ktYW8tLS0tIDMwMC4wMGcgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiMgICAgc3dhcCAg
ICAgICAgc3RvcmFnZSAtd2ktYW8tLS0tICAxNi4wMGcgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgCiMgICAgdGVzdC1idHJmcyAgc3RvcmFnZSAtd2kt
YS0tLS0tICA1MC4wMGcgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgCiMgICAgdGVzdC1idHJmczIgc3RvcmFnZSAtd2ktYW8tLS0tICA1MC4wMGcgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiMgIAojICAj
IG1vdW50IC9kZXYvc3RvcmFnZS90ZXN0LWJ0cmZzMiBidHJmczIKIyAgd2hpY2ggcmVzdWx0cyBp
biBhIG1vdW50IGxpa2UgbGlrZSBzbyBvbiBteSBzeXN0ZW06IAojICAvZGV2L21hcHBlci9zdG9y
YWdlLXRlc3QtLWJ0cmZzMiBvbiAvaG9tZS9zY29ubm9yL3RtcC9idHJmczIgdHlwZSBidHJmcyAo
cncscmVsYXRpbWUsc3NkLHNwYWNlX2NhY2hlLHN1YnZvbGlkPTUsc3Vidm9sPS8pCiMgIAojICBC
ZWxvdyBpcyBhIHNjcmlwdCB3aGljaCByZXByb2R1Y2VzIHRoaXMgaXNzdWUgd2l0aGluIDMwLTYw
IHNlY29uZHMgb24gbXkKIyAgc3lzdGVtLiAgSSBmb3VuZCB0aGF0IGl0IHdhcyB1bm5lY2Vzc2Fy
eSB0byByZS1kbyB0aGUgc2VuZCBzdGVwLCBzbyBJIGFtIG9ubHkKIyAgdGVzdGluZyBvbiBvbmUg
RlMgYXMgYmVsb3cuICBJZiBpdCBpc24ndCBvYnZpb3VzLCB0aGUgc2NyaXB0IGJlbG93IGlzIG5v
dCB2ZXJ5CiMgIGdvb2QsIGFuZCByZXF1aXJlcyB0aGluZ3MgdG8gYmUgc2V0dXAganVzdCBzbywg
YW5kIHRoZSBmaWxlc3lzdGVtIG11c3QgYmUKIyAgcHJlLW1vdW50ZWQgYmVmb3JlIGl0IGJlZ2lu
cy4KCnNldCAtZXgKClRFU1RfRElSPS9ob21lL3Njb25ub3IvdG1wLwpURVNUX01OVF9QT0lOVD0k
VEVTVF9ESVIvYnRyZnMyClRFU1RfUEFSVD0vZGV2L3N0b3JhZ2UvdGVzdC1idHJmczIKTE9HPS9o
b21lL3Njb25ub3Ivc2NyYXRjaC9yZWNlaXZlX2xvZy50eHQKCndoaWxlIHRydWUKZG8KICAgIHVt
b3VudCAkVEVTVF9NTlRfUE9JTlQKICAgIG1rZnMuYnRyZnMgLWYgJFRFU1RfUEFSVAogICAgbW91
bnQgJFRFU1RfUEFSVCAkVEVTVF9NTlRfUE9JTlQKICAgIHpjYXQgJFRFU1RfRElSL3NuYXBfMS5i
cy5neiB8IGJ0cmZzIHJlY2VpdmUgLXZ2ICRURVNUX0RJUi9idHJmczIvIDI+ICRMT0cKZG9uZQoK
--001a11488ab8ce23620546ee0bb2--
