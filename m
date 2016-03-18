Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.alfazone.pl ([91.222.140.5]:34143 "EHLO mail.alfazone.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbcCRRts (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 13:49:48 -0400
Received: from [192.168.1.2] (host-91.222.141-40.ip4.alfazone.pl [91.222.141.40])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail.alfazone.pl (Postfix) with ESMTPSA id 7E7DA84447
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 18:42:05 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Marcin Solecki <solo@alfazone.pl>
Subject: recovery problem raid5
Message-ID: <56EC3DCC.6060101@alfazone.pl>
Date: Fri, 18 Mar 2016 18:41:32 +0100
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090903040902010802050900"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090903040902010802050900
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello all,
I give up for this problem at restore my data


# uname -a
Linux jarvis.home 4.5.0-1.el7.elrepo.x86_64

# btrfs --version
btrfs-progs v3.19.1

# btrfs fi show
warning, device 4 is missing
bytenr mismatch, want=21020672, have=21217280
Couldn't read chunk root
Label: none  uuid: 27ef2638-b50a-4243-80ed-40c3733ec11d
         Total devices 4 FS bytes used 2.50TiB
         devid    1 size 931.51GiB used 899.71GiB path /dev/sdd
         devid    2 size 931.51GiB used 899.69GiB path /dev/sdb
         devid    3 size 931.51GiB used 899.69GiB path /dev/sdc
         *** Some devices missing

# mount  -o recovery /dev/sda /srv/
mount: wrong fs type, bad option, bad superblock on /dev/sda,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.

dmesg after :
[ 4886.521315] BTRFS info (device sdc): enabling auto recovery
[ 4886.521320] BTRFS info (device sdc): disk space caching is enabled
[ 4886.522853] BTRFS: failed to read chunk tree on sdc
[ 4886.528789] BTRFS: open_ctree failed

#btrfs check --repair /dev/sda
enabling repair mode
warning, device 4 is missing
bytenr mismatch, want=21020672, have=21217280
Couldn't read chunk root
Couldn't open file system

# btrfs rescue chunk-recover -v /dev/sda
All Devices:
         Device: id = 3, name = /dev/sdc
         Device: id = 2, name = /dev/sdb
         Device: id = 1, name = /dev/sda

[ 5164.468272] btrfs[3653]: segfault at 7f454014172e ip 0000000000423479 
sp 00007f4482cec880 error 4 in btrfs[400000+83000]
[ 5168.928317] btrfs[3657]: segfault at 7fd18c14172e ip 0000000000423479 
sp 00007fd0d5858880 error 4 in btrfs[400000+83000]
[ 5173.812457] btrfs[3662]: segfault at 7fd76c14172e ip 0000000000423479 
sp 00007fd6b0e59880 error 4 in btrfs[400000+83000]

# btrfs rescue super-recover -v /dev/sda
All Devices:
         Device: id = 3, name = /dev/sdc
         Device: id = 2, name = /dev/sdb
         Device: id = 1, name = /dev/sda

Before Recovering:
         [All good supers]:
                 device name = /dev/sdc
                 superblock bytenr = 65536

                 device name = /dev/sdc
                 superblock bytenr = 67108864

                 device name = /dev/sdc
                 superblock bytenr = 274877906944

                 device name = /dev/sdb
                 superblock bytenr = 65536

                 device name = /dev/sdb
                 superblock bytenr = 67108864

                 device name = /dev/sdb
                 superblock bytenr = 274877906944

                 device name = /dev/sda
                 superblock bytenr = 65536

                 device name = /dev/sda
                 superblock bytenr = 67108864

                 device name = /dev/sda
                 superblock bytenr = 274877906944

         [All bad supers]:

All supers are valid, no need to recover

# btrfs-show-super /dev/sda
superblock: bytenr=65536, device=/dev/sda
---------------------------------------------------------
csum                    0x61b509bb [match]
bytenr                  65536
flags                   0x1
magic                   _BHRfS_M [match]
fsid                    27ef2638-b50a-4243-80ed-40c3733ec11d
label
generation              69462
root                    1648640000
sys_array_size          290
chunk_root_generation   48545
root_level              1
chunk_root              21020672
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             4000819544064
bytes_used              2743528714240
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             4
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0xe1
                         ( MIXED_BACKREF |
                           BIG_METADATA |
                           EXTENDED_IREF |
                           RAID56 )
csum_type               0
csum_size               4
cache_generation        69462
uuid_tree_generation    69462
dev_item.uuid           70f4650c-e01d-4613-bd7a-a6834c1c44bb
dev_item.fsid           27ef2638-b50a-4243-80ed-40c3733ec11d [match]
dev_item.type           0
dev_item.total_bytes    1000204886016
dev_item.bytes_used     966057263104
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0

thx for helps

-- 


--------------090903040902010802050900
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.log.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg.log.txt"

WyAgIDg4LjQyMzYwNF0gQlRSRlMgd2FybmluZyAoZGV2aWNlIHNkYyk6IGRldmlkIDQgdXVp
ZCBjMjRmMzlmOC1jNzNjLTRhMTctYmJlZi1jYjg5ODhhZGNiZjcgaXMgbWlzc2luZw0KWyAg
IDg4LjQ1NTYwN10gQlRSRlMgaW5mbyAoZGV2aWNlIHNkYyk6IGJkZXYgKG51bGwpIGVycnM6
IHdyIDkyMSwgcmQgMTY0ODg5LCBmbHVzaCAwLCBjb3JydXB0IDAsIGdlbiAwDQpbICAgODgu
ODAwNjA5XSBCVFJGUyBlcnJvciAoZGV2aWNlIHNkYyk6IGJhZCB0cmVlIGJsb2NrIHN0YXJ0
IDAgMTYxOTUyNTYzMg0KWyAgIDg4LjgwMDY0OF0gQlRSRlM6IEZhaWxlZCB0byByZWFkIGJs
b2NrIGdyb3VwczogLTUNClsgICA4OC44MDk3NTZdIEJUUkZTOiBvcGVuX2N0cmVlIGZhaWxl
ZA0KWyAgMTQzLjc5MjU0N10gQlRSRlMgaW5mbyAoZGV2aWNlIHNkYyk6IGFsbG93aW5nIGRl
Z3JhZGVkIG1vdW50cw0KWyAgMTQzLjc5MjU1Ml0gQlRSRlMgaW5mbyAoZGV2aWNlIHNkYyk6
IGRpc2sgc3BhY2UgY2FjaGluZyBpcyBlbmFibGVkDQpbICAxNDMuODAyNzE5XSBCVFJGUyBp
bmZvIChkZXZpY2Ugc2RjKTogYmRldiAobnVsbCkgZXJyczogd3IgOTIxLCByZCAxNjQ4ODks
IGZsdXNoIDAsIGNvcnJ1cHQgMCwgZ2VuIDANClsgIDE0My44NzQzNzBdIEJUUkZTIGVycm9y
IChkZXZpY2Ugc2RjKTogYmFkIHRyZWUgYmxvY2sgc3RhcnQgMCAxNjE5NTI1NjMyDQpbICAx
NDMuODc0NDEwXSBCVFJGUzogRmFpbGVkIHRvIHJlYWQgYmxvY2sgZ3JvdXBzOiAtNQ0KWyAg
MTQzLjg4MzU3MV0gQlRSRlM6IG9wZW5fY3RyZWUgZmFpbGVkDQpbICA0MDIuNTY0Mzc0XSBC
VFJGUyBpbmZvIChkZXZpY2Ugc2RjKTogZW5hYmxpbmcgYXV0byByZWNvdmVyeQ0KWyAgNDAy
LjU2NDM3OV0gQlRSRlMgaW5mbyAoZGV2aWNlIHNkYyk6IGRpc2sgc3BhY2UgY2FjaGluZyBp
cyBlbmFibGVkDQpbICA0MDIuNTY1NTUxXSBCVFJGUzogZmFpbGVkIHRvIHJlYWQgY2h1bmsg
dHJlZSBvbiBzZGMNClsgIDQwMi41NzAxOTddIEJUUkZTOiBvcGVuX2N0cmVlIGZhaWxlZA0K
WyAgNjA0LjI3MzQ1Ml0gYnRyZnNbMjUzNl06IHNlZ2ZhdWx0IGF0IDdmN2ZlMDE0MTcyZSBp
cCAwMDAwMDAwMDAwNDIzNDc5IHNwIDAwMDA3ZjdmMjEzNTg4ODAgZXJyb3IgNCBpbiBidHJm
c1s0MDAwMDArODMwMDBdDQpbIDExMDEuMzE1NzYyXSBCVFJGUyBpbmZvIChkZXZpY2Ugc2Rj
KTogZW5hYmxpbmcgYXV0byByZWNvdmVyeQ0KWyAxMTAxLjMxNTc2Nl0gQlRSRlMgaW5mbyAo
ZGV2aWNlIHNkYyk6IGRpc2sgc3BhY2UgY2FjaGluZyBpcyBlbmFibGVkDQpbIDExMDEuMzE2
OTgwXSBCVFJGUzogZmFpbGVkIHRvIHJlYWQgY2h1bmsgdHJlZSBvbiBzZGMNClsgMTEwMS4z
MjMwMDZdIEJUUkZTOiBvcGVuX2N0cmVlIGZhaWxlZA0KWyAxMTI0LjAwODY5MV0gQlRSRlMg
aW5mbyAoZGV2aWNlIHNkYyk6IGVuYWJsaW5nIGF1dG8gcmVjb3ZlcnkNClsgMTEyNC4wMDg2
OTVdIEJUUkZTIGluZm8gKGRldmljZSBzZGMpOiBkaXNrIHNwYWNlIGNhY2hpbmcgaXMgZW5h
YmxlZA0KWyAxMTI0LjAwOTg1OV0gQlRSRlM6IGZhaWxlZCB0byByZWFkIGNodW5rIHRyZWUg
b24gc2RjDQpbIDExMjQuMDEzMzQ0XSBCVFJGUzogb3Blbl9jdHJlZSBmYWlsZWQNClsgMTE1
MS40MjQ2MTRdIGJ0cmZzWzI2NjZdOiBzZWdmYXVsdCBhdCA3ZjhmZjQxNDE3MmUgaXAgMDAw
MDAwMDAwMDQyMzQ3OSBzcCAwMDAwN2Y4ZjNiY2YzODgwIGVycm9yIDQgaW4gYnRyZnNbNDAw
MDAwKzgzMDAwXQ0KWyAxMTkxLjY2MTIwNV0gYnRyZnNbMjY3N106IHNlZ2ZhdWx0IGF0IDdm
MDYwMDE0MTcyZSBpcCAwMDAwMDAwMDAwNDIzNDc5IHNwIDAwMDA3ZjA1NDU3ODk4ODAgZXJy
b3IgNCBpbiBidHJmc1s0MDAwMDArODMwMDBdDQpbIDIzNjguMTIwNzAwXSBCVFJGUyBpbmZv
IChkZXZpY2Ugc2RjKTogZW5hYmxpbmcgYXV0byByZWNvdmVyeQ0KWyAyMzY4LjEyMDcwNF0g
QlRSRlMgaW5mbyAoZGV2aWNlIHNkYyk6IGRpc2sgc3BhY2UgY2FjaGluZyBpcyBlbmFibGVk
DQpbIDIzNjguMTIxOTI0XSBCVFJGUzogZmFpbGVkIHRvIHJlYWQgY2h1bmsgdHJlZSBvbiBz
ZGMNClsgMjM2OC4xMjY1OTFdIEJUUkZTOiBvcGVuX2N0cmVlIGZhaWxlZA0KWyAyMzcwLjcz
ODcxMl0gQlRSRlMgaW5mbyAoZGV2aWNlIHNkYyk6IGVuYWJsaW5nIGF1dG8gcmVjb3ZlcnkN
ClsgMjM3MC43Mzg3MTddIEJUUkZTIGluZm8gKGRldmljZSBzZGMpOiBkaXNrIHNwYWNlIGNh
Y2hpbmcgaXMgZW5hYmxlZA0KWyAyMzcwLjc0MDAwM10gQlRSRlM6IGZhaWxlZCB0byByZWFk
IGNodW5rIHRyZWUgb24gc2RjDQpbIDIzNzAuNzQ0NjI0XSBCVFJGUzogb3Blbl9jdHJlZSBm
YWlsZWQNClsgMjM3My4wMDI4MDddIEJUUkZTIGluZm8gKGRldmljZSBzZGMpOiBlbmFibGlu
ZyBhdXRvIHJlY292ZXJ5DQpbIDIzNzMuMDAyODExXSBCVFJGUyBpbmZvIChkZXZpY2Ugc2Rj
KTogZGlzayBzcGFjZSBjYWNoaW5nIGlzIGVuYWJsZWQNClsgMjM3My4wMDQwMDFdIEJUUkZT
OiBmYWlsZWQgdG8gcmVhZCBjaHVuayB0cmVlIG9uIHNkYw0KWyAyMzczLjAwNzY1MV0gQlRS
RlM6IG9wZW5fY3RyZWUgZmFpbGVkDQpbIDI1MTMuODAwMjcxXSBCVFJGUyBpbmZvIChkZXZp
Y2Ugc2RjKTogZW5hYmxpbmcgYXV0byByZWNvdmVyeQ0KWyAyNTEzLjgwMDI3Nl0gQlRSRlMg
aW5mbyAoZGV2aWNlIHNkYyk6IGRpc2sgc3BhY2UgY2FjaGluZyBpcyBlbmFibGVkDQpbIDI1
MTMuODAyMTgxXSBCVFJGUzogZmFpbGVkIHRvIHJlYWQgY2h1bmsgdHJlZSBvbiBzZGMNClsg
MjUxMy44MDg2MTRdIEJUUkZTOiBvcGVuX2N0cmVlIGZhaWxlZA0KWyAyOTcyLjQ0ODAzN10g
YnRyZnNbMzE1Ml06IHNlZ2ZhdWx0IGF0IDdmNDU0YzE0MTcyZSBpcCAwMDAwMDAwMDAwNDIz
NDc5IHNwIDAwMDA3ZjQ0OTQzMDU4ODAgZXJyb3IgNCBpbiBidHJmc1s0MDAwMDArODMwMDBd
DQpbIDMxMjMuNjQ3MzcwXSBCVFJGUyBpbmZvIChkZXZpY2Ugc2RiKTogZW5hYmxpbmcgYXV0
byByZWNvdmVyeQ0KWyAzMTIzLjY0NzM3NV0gQlRSRlMgaW5mbyAoZGV2aWNlIHNkYik6IGRp
c2sgc3BhY2UgY2FjaGluZyBpcyBlbmFibGVkDQpbIDMxMjMuNjQ4MjMzXSBCVFJGUzogZmFp
bGVkIHRvIHJlYWQgY2h1bmsgcm9vdCBvbiBzZGINClsgMzEyMy42NTUyMzVdIEJUUkZTOiBv
cGVuX2N0cmVlIGZhaWxlZA0KWyAzMTMxLjU3NDU4MF0gQlRSRlMgaW5mbyAoZGV2aWNlIHNk
Yik6IGVuYWJsaW5nIGF1dG8gcmVjb3ZlcnkNClsgMzEzMS41NzQ1ODVdIEJUUkZTIGluZm8g
KGRldmljZSBzZGIpOiBkaXNrIHNwYWNlIGNhY2hpbmcgaXMgZW5hYmxlZA0KWyAzMTMxLjU3
NTM2MF0gQlRSRlM6IGZhaWxlZCB0byByZWFkIGNodW5rIHJvb3Qgb24gc2RiDQpbIDMxMzEu
NTgyMjM0XSBCVFJGUzogb3Blbl9jdHJlZSBmYWlsZWQNCg==
--------------090903040902010802050900--
