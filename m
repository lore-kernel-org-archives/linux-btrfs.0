Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:55382 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3HZNfa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 09:35:30 -0400
Received: from bluebottle.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 88CA62189A
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 23:35:26 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: snapshot space available
Date: Mon, 26 Aug 2013 23:35:25 +1000
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_dm1GSJ9PyGCsFWi"
Message-Id: <201308262335.25871.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Boundary-00=_dm1GSJ9PyGCsFWi
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Linux xev 3.10-2-amd64 #1 SMP Debian 3.10.5-1 (2013-08-07) x86_64 GNU/Linux=
                                                                           =
                                                                           =
                                                                           =
                                                   =20

I've attached a file of script output from a system running the above Debia=
n=20
kernel on a system with an Intel 120G SSD.  To get this working again I=20
extended the filesystem in question to also use a small USB flash device (4=
G=20
from memory) and then deleted some old snapshots to free some space.

The most intereting part of the script output is pasted below.  The system=
=20
reports that the filesystem is 82% full but that there is no space left.

root@xev:~# df -h /                                                        =
                                                                           =
                                                                           =
                                                                           =
                                                   =20
=46ilesystem                                              Size  Used Avail =
Use%=20
Mounted on                                                                 =
                                                                           =
                                                                           =
                                                =20
/dev/disk/by-uuid/586e6f48-2985-4115-9f89-f844b319c7c0  108G   87G   21G  8=
2%=20
/                                                                          =
                                                                           =
                                                                           =
                                                =20
root@xev:~# btrfs filesystem df /                                          =
                                                                           =
                                                                           =
                                                                           =
                                                   =20
Data: total=3D101.57GB, used=3D81.50GB                                     =
                                                                           =
                                                                           =
                                                                           =
                                                       =20
System, DUP: total=3D8.00MB, used=3D20.00KB                                =
                                                                           =
                                                                           =
                                                                           =
                                                       =20
System: total=3D4.00MB, used=3D0.00                                        =
                                                                           =
                                                                           =
                                                                           =
                                                       =20
Metadata, DUP: total=3D3.00GB, used=3D2.50GB                               =
                                                                           =
                                                                           =
                                                                           =
                                                       =20
Metadata: total=3D8.00MB, used=3D0.00
root@xev:~# ls -l > test                                                   =
                                                                           =
                                                                           =
                                                                           =
                                                   =20
bash: test: No space left on device                                        =
                                                                           =
                                                                           =
                                                                           =
                                                   =20
root@xev:~# touch test
touch: cannot touch =E2=80=98test=E2=80=99: No space left on device        =
                                                                           =
                                                                           =
                                                                           =
                                                                   =20
root@xev:~#

=2D-=20
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

--Boundary-00=_dm1GSJ9PyGCsFWi
Content-Type: text/plain;
  charset="ISO-8859-1";
  name="problem.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="problem.txt"

U2NyaXB0IHN0YXJ0ZWQgb24gRnJpIDIzIEF1ZyAyMDEzIDAwOjE5OjAzIEVTVApyb290QHhldjp+
IyBkZiAtaCAvDQpGaWxlc3lzdGVtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIFNpemUgIFVzZWQgQXZhaWwgVXNlJSBNb3VudGVkIG9uDQovZGV2L2Rpc2svYnkt
dXVpZC81ODZlNmY0OC0yOTg1LTQxMTUtOWY4OS1mODQ0YjMxOWM3YzAgIDEwOEcgICA4N0cgICAy
MUcgIDgyJSAvDQpyb290QHhldjp+IyBidHJmcyBkZiAvCAgICBtbMUBmG1sxQGkbWzFAbBtbMUBl
G1sxQHMbWzFAeRtbMUBzG1sxQHQbWzFAZRtbMUBtG1sxQCANCkRhdGE6IHRvdGFsPTEwMS41N0dC
LCB1c2VkPTgxLjUwR0INClN5c3RlbSwgRFVQOiB0b3RhbD04LjAwTUIsIHVzZWQ9MjAuMDBLQg0K
U3lzdGVtOiB0b3RhbD00LjAwTUIsIHVzZWQ9MC4wMA0KTWV0YWRhdGEsIERVUDogdG90YWw9My4w
MEdCLCB1c2VkPTIuNTBHQg0KTWV0YWRhdGE6IHRvdGFsPTguMDBNQiwgdXNlZD0wLjAwDQpyb290
QHhldjp+IyBkbWVzZ3x0YWlsIC01MA0KWyAgIDE1LjEyODA2OV0gZTEwMDBlIDAwMDA6MDA6MTku
MDogaXJxIDQzIGZvciBNU0kvTVNJLVgNClsgICAxNS4xMjgxNDldIElQdjY6IEFERFJDT05GKE5F
VERFVl9VUCk6IG1iMDogbGluayBpcyBub3QgcmVhZHkNClsgICAxNS4xMjk4MTddIGRldmljZSBl
dGgwIGVudGVyZWQgcHJvbWlzY3VvdXMgbW9kZQ0KWyAgIDE1LjE0NTcyMl0gSVB2NjogQUREUkNP
TkYoTkVUREVWX1VQKTogZXRoMDogbGluayBpcyBub3QgcmVhZHkNClsgICAxNS4xNDcxNzhdIGRl
dmljZSBldGgxIGVudGVyZWQgcHJvbWlzY3VvdXMgbW9kZQ0KWyAgIDE1LjE0OTEyMF0gODEzOXRv
byAwMDAwOjA0OjAxLjAgZXRoMTogbGluayB1cCwgMTAwTWJwcywgZnVsbC1kdXBsZXgsIGxwYSAw
eDQxRTENClsgICAxNS4xNTM2NzZdIHhlbmJyMDogcG9ydCAzKGV0aDEpIGVudGVyZWQgbGlzdGVu
aW5nIHN0YXRlDQpbICAgMTUuMTUzNjkwXSB4ZW5icjA6IHBvcnQgMyhldGgxKSBlbnRlcmVkIGxp
c3RlbmluZyBzdGF0ZQ0KWyAgIDE1LjE1MzY5N10geGVuYnIwOiBwb3J0IDIoZXRoMCkgZW50ZXJl
ZCBsaXN0ZW5pbmcgc3RhdGUNClsgICAxNS4xNTM3MDNdIHhlbmJyMDogcG9ydCAyKGV0aDApIGVu
dGVyZWQgbGlzdGVuaW5nIHN0YXRlDQpbICAgMTUuMTUzNzM1XSBJUHY2OiBBRERSQ09ORihORVRE
RVZfVVApOiB4ZW5icjA6IGxpbmsgaXMgbm90IHJlYWR5DQpbICAgMTUuNjYwMDUzXSB4ZW5icjA6
IHBvcnQgMihldGgwKSBlbnRlcmVkIGRpc2FibGVkIHN0YXRlDQpbICAgMTcuMzcyODc0XSBlMTAw
MGU6IG1iMCBOSUMgTGluayBpcyBVcCAxMDAwIE1icHMgRnVsbCBEdXBsZXgsIEZsb3cgQ29udHJv
bDogUngvVHgNClsgICAxNy4zNzMwMTddIElQdjY6IEFERFJDT05GKE5FVERFVl9DSEFOR0UpOiBt
YjA6IGxpbmsgYmVjb21lcyByZWFkeQ0KWyAgIDE3LjM3MzA0N10geGVuYnIwOiBwb3J0IDEobWIw
KSBlbnRlcmVkIGxpc3RlbmluZyBzdGF0ZQ0KWyAgIDE3LjM3MzA1NF0geGVuYnIwOiBwb3J0IDEo
bWIwKSBlbnRlcmVkIGxpc3RlbmluZyBzdGF0ZQ0KWyAgIDE4LjE2MDAxN10geGVuYnIwOiBwb3J0
IDMoZXRoMSkgZW50ZXJlZCBsZWFybmluZyBzdGF0ZQ0KWyAgIDIwLjM3NjAxN10geGVuYnIwOiBw
b3J0IDEobWIwKSBlbnRlcmVkIGxlYXJuaW5nIHN0YXRlDQpbICAgMjEuMTY4MDEwXSB4ZW5icjA6
IHRvcG9sb2d5IGNoYW5nZSBkZXRlY3RlZCwgc2VuZGluZyB0Y24gYnBkdQ0KWyAgIDIxLjE2ODAz
NV0geGVuYnIwOiBwb3J0IDMoZXRoMSkgZW50ZXJlZCBmb3J3YXJkaW5nIHN0YXRlDQpbICAgMjEu
MTY4MDYyXSBJUHY2OiBBRERSQ09ORihORVRERVZfQ0hBTkdFKTogeGVuYnIwOiBsaW5rIGJlY29t
ZXMgcmVhZHkNClsgICAyMy4zODQwMTNdIHhlbmJyMDogdG9wb2xvZ3kgY2hhbmdlIGRldGVjdGVk
LCBzZW5kaW5nIHRjbiBicGR1DQpbICAgMjMuMzg0MDMzXSB4ZW5icjA6IHBvcnQgMShtYjApIGVu
dGVyZWQgZm9yd2FyZGluZyBzdGF0ZQ0KWyAgIDIzLjgwNTMxN10gUlBDOiBSZWdpc3RlcmVkIG5h
bWVkIFVOSVggc29ja2V0IHRyYW5zcG9ydCBtb2R1bGUuDQpbICAgMjMuODA1MzIxXSBSUEM6IFJl
Z2lzdGVyZWQgdWRwIHRyYW5zcG9ydCBtb2R1bGUuDQpbICAgMjMuODA1MzIzXSBSUEM6IFJlZ2lz
dGVyZWQgdGNwIHRyYW5zcG9ydCBtb2R1bGUuDQpbICAgMjMuODA1MzI0XSBSUEM6IFJlZ2lzdGVy
ZWQgdGNwIE5GU3Y0LjEgYmFja2NoYW5uZWwgdHJhbnNwb3J0IG1vZHVsZS4NClsgICAyMy44MTEx
NDJdIEZTLUNhY2hlOiBMb2FkZWQNClsgICAyMy44MTIxNTBdIEtleSB0eXBlIGRuc19yZXNvbHZl
ciByZWdpc3RlcmVkDQpbICAgMjMuODIyMzY4XSBGUy1DYWNoZTogTmV0ZnMgJ25mcycgcmVnaXN0
ZXJlZCBmb3IgY2FjaGluZw0KWyAgIDIzLjgzODIwMF0gSW5zdGFsbGluZyBrbmZzZCAoY29weXJp
Z2h0IChDKSAxOTk2IG9raXJAbW9uYWQuc3diLmRlKS4NClsgICAyMy44NDM0NDBdIFNFTGludXg6
IGluaXRpYWxpemVkIChkZXYgcnBjX3BpcGVmcywgdHlwZSBycGNfcGlwZWZzKSwgdXNlcyBnZW5m
c19jb250ZXh0cw0KWyAgIDI0LjM0Mjc5NF0gU0VMaW51eDogaW5pdGlhbGl6ZWQgKGRldiBiaW5m
bXRfbWlzYywgdHlwZSBiaW5mbXRfbWlzYyksIHVzZXMgZ2VuZnNfY29udGV4dHMNClsgICAyNC40
MjMwNDddIGF1ZGl0ZCAoMjU4NCk6IC9wcm9jLzI1ODQvb29tX2FkaiBpcyBkZXByZWNhdGVkLCBw
bGVhc2UgdXNlIC9wcm9jLzI1ODQvb29tX3Njb3JlX2FkaiBpbnN0ZWFkLg0KWyAgIDI0LjU3OTA4
MF0gbHAwOiB1c2luZyBwYXJwb3J0MCAoaW50ZXJydXB0LWRyaXZlbikuDQpbICAgMjQuNTg2ODYy
XSBwcGRldjogdXNlci1zcGFjZSBwYXJhbGxlbCBwb3J0IGRyaXZlcg0KWyAgIDI3LjI3NTM4Ml0g
QlRSRlMgZGVidWcgKGRldmljZSBkbS0wKTogdHJ1bmNhdGVkIDIgb3JwaGFucw0KWyAgIDYyLjE5
ODEyNV0gU0VMaW51eDogaW5pdGlhbGl6ZWQgKGRldiBwcm9jLCB0eXBlIHByb2MpLCB1c2VzIGdl
bmZzX2NvbnRleHRzDQpbICA1ODAuNzU5NzUzXSBORlM6IFJlZ2lzdGVyaW5nIHRoZSBpZF9yZXNv
bHZlciBrZXkgdHlwZQ0KWyAgNTgwLjc1OTc3Ml0gS2V5IHR5cGUgaWRfcmVzb2x2ZXIgcmVnaXN0
ZXJlZA0KWyAgNTgwLjc1OTc3NF0gS2V5IHR5cGUgaWRfbGVnYWN5IHJlZ2lzdGVyZWQNClsgIDU5
NS43NjgwMTldIFJQQzogQVVUSF9HU1MgdXBjYWxsIHRpbWVkIG91dC4NClsgIDU5NS43NjgwMTld
IFBsZWFzZSBjaGVjayB1c2VyIGRhZW1vbiBpcyBydW5uaW5nLg0KWyAgNTk1Ljc3MzgxM10gU0VM
aW51eDogaW5pdGlhbGl6ZWQgKGRldiAwOjI3LCB0eXBlIG5mczQpLCB1c2VzIGdlbmZzX2NvbnRl
eHRzDQpbICA1OTUuNzc5MjAwXSBTRUxpbnV4OiBpbml0aWFsaXplZCAoZGV2IDA6MjgsIHR5cGUg
bmZzNCksIHVzZXMgZ2VuZnNfY29udGV4dHMNClsgIDU5NS43ODIyNDldIFNFTGludXg6IGluaXRp
YWxpemVkIChkZXYgMDoyOSwgdHlwZSBuZnM0KSwgdXNlcyBnZW5mc19jb250ZXh0cw0KWyAgNjA2
LjIyNzM3MV0gU0VMaW51eDogaW5pdGlhbGl6ZWQgKGRldiAwOjI3LCB0eXBlIG5mczQpLCB1c2Vz
IGdlbmZzX2NvbnRleHRzDQpbICA2MDYuMjMwNDQxXSBTRUxpbnV4OiBpbml0aWFsaXplZCAoZGV2
IDA6MjgsIHR5cGUgbmZzNCksIHVzZXMgZ2VuZnNfY29udGV4dHMNClsgIDYwNi4yMzM2NzZdIFNF
TGludXg6IGluaXRpYWxpemVkIChkZXYgMDozMCwgdHlwZSBuZnM0KSwgdXNlcyBnZW5mc19jb250
ZXh0cw0KWyAgNjU4LjkwMjI4OF0gQlRSRlMgZGVidWcgKGRldmljZSBkbS0wKTogdW5saW5rZWQg
MSBvcnBoYW5zDQpyb290QHhldjp+IyBscyAtbCA+IHRlc3QNCmJhc2g6IHRlc3Q6IE5vIHNwYWNl
IGxlZnQgb24gZGV2aWNlDQpyb290QHhldjp+IyBlY2hvID1uIAgbW0sIG1tLCBtbS24IG1tLCBtb
SwgbW0sIG1tLCBtbSwgbW0t0b3VjaCB0ZXN0DQp0b3VjaDogY2Fubm90IHRvdWNoIOKAmHRlc3Ti
gJk6IE5vIHNwYWNlIGxlZnQgb24gZGV2aWNlDQpyb290QHhldjp+IyBleGl0DQoKU2NyaXB0IGRv
bmUgb24gRnJpIDIzIEF1ZyAyMDEzIDAwOjE5OjUxIEVTVAo=

--Boundary-00=_dm1GSJ9PyGCsFWi--
