Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:33474 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbcAJXrd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jan 2016 18:47:33 -0500
Received: by mail-wm0-f44.google.com with SMTP id f206so194178555wmf.0
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Jan 2016 15:47:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jYaga9c0+x+TzdR_FuV57qfr2M-topeRstazV9n1=f9sQ@mail.gmail.com>
References: <CA+9GZUitvMjJSgdpmMb8Fsz-CHK4WXV9XVhGCk9mRCWUU_D-VQ@mail.gmail.com>
 <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
 <CA+9GZUgnmMoLeGsyeo=tFe2GLsDkLEr0umiDovf3P2aBtDA+Xg@mail.gmail.com>
 <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk> <CAPmG0jYaga9c0+x+TzdR_FuV57qfr2M-topeRstazV9n1=f9sQ@mail.gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Mon, 11 Jan 2016 00:47:12 +0100
Message-ID: <CA+9GZUg752dgd2mpEiBvHrFr3W_zccwk4yN=e04DN0OPTBrGDg@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: Henk Slager <eye1tm@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Hugo Mills <hugo@carfax.org.uk>,
        Chris Murphy <lists@colorremedies.com>
Content-Type: multipart/mixed; boundary=001a1140d744a799af05290371f7
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--001a1140d744a799af05290371f7
Content-Type: text/plain; charset=UTF-8

On Sun, Jan 10, 2016 at 3:14 PM, Henk Slager <eye1tm@gmail.com> wrote:
> On Sat, Jan 9, 2016 at 9:26 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Sat, Jan 09, 2016 at 09:00:47PM +0100, cheater00 . wrote:
>>> Hello,
>>> I can repeatedly trigger this bug by making the "data" portion fill
>>> up. If you remember the partition is 6 TB but in btrfs filesystem df
>>> Data is shown as only 2TB when in fact it should be nearly 6TB. So
>>> this has nothing to do with kernel bugs. The filesystem on disk is
>>> structured incorrectly. How do i fix this? How do I make "Data"
>>> bigger? What is it exactly?
>>
>>    This is *exactly* the behaviour of the known kernel bug. The bug is
>> that the FS *should* be extending the data allocation when it gets
>> near to full, and it's not. There is no way of manually allocating
>> more (because the FS should be doing it automatically). There is no
>> known way of persuading the FS to it when it isn't.
>
> Probably this is 'the'  bug we talk about:
> https://bugzilla.kernel.org/show_bug.cgi?id=74101

Yes, would seem like it.

> Size of the fs is much smaller, but also problem occurs when fill-level is <50%
>
> btrfs fs resize  did nothing you mention, but AFAIK you should see
> something in dmesg when you do that.


I remounted (to make the filesystem rw again) and got the attached
log. There are some errors in there. But bear in mind that this disk
has been hanging on in ro mode for a few days now.

I did this:
# btrfs fi resize -1T Media
Resize 'Media' of '-1T'
# btrfs filesystem resize -1G Media
Resize 'Media' of '-1G'
# btrfs filesystem resize -1T Media
Resize 'Media' of '-1T'
# btrfs filesystem resize max Media
Resize 'Media' of 'max'

and it resulted in the following lines in dmesg:
[189115.919160] BTRFS: new size for /dev/sdc1 is 4901661835264
[189177.306291] BTRFS: new size for /dev/sdc1 is 4900588093440
[189181.950289] BTRFS: new size for /dev/sdc1 is 3801076465664
[189232.064357] BTRFS: new size for /dev/sdc1 is 6001173463040

(note the device changed from sdd to sdc when I rebooted last)

> And what is the output of   gdisk -l /dev/sdd  , just to check?

(the device changed to sdc since I've rebooted)

# gdisk -l /dev/sdc
GPT fdisk (gdisk) version 0.8.8

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdc: 11721045168 sectors, 5.5 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 0DEF5509-8730-4AB4-A846-79DA3C376F66
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 11721045134
Partitions will be aligned on 2048-sector boundaries
Total free space is 3181 sectors (1.6 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048     11721043967   5.5 TiB     8300


> Have you had the fs already filled up to e.g. 95% before or has is
> always been not more than 2TiB?

It has never been more than 2TB, I've had it for quite some time now
but it's always hovered around 1TB.

> Why are the single (empty )profiles for metadata and system still
> there?  They should have been removed already by the various balancing
> operations that are advised in the btrfs-wiki.

Not sure. Would this happen automatically? Or is this something I
should have done?
I have another fs on the same model/size disk, which isn't exhibiting
this bug, and it has those profiles as well.

Here's what both look like:

buggy fs ("Media"):
Data, single: total=1.98TiB, used=1.98TiB
System, DUP: total=8.00MiB, used=240.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=5.50GiB, used=3.49GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

non-buggy fs:
Data, single: total=5.43TiB, used=5.40TiB
System, DUP: total=8.00MiB, used=608.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=12.50GiB, used=11.21GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B


> What is the output of   btrfs check  /dev/sdd  ?  The usb resets
> mentioned might have introduced some errors to the fs (that is what I
> have experienced at least, but it depends on timing etc)

I'll run that overnight and report tomorrow.

> What you could try is to create an image+'copy' of the fs with
> btrfs-image just after you get ENOSPC abd then do various tests with
> that (make sure unmount or even better unplug the physical hdd!). Like
> mounting and then try to add a file, convert all metadata + system
> from dup to single and then try to add a file. It all doesn't give
> real space, but it might give hints to what could be wrong.

I can't do that because I would have to buy an extra disk which is 300 euro.

> If you somehow manage to reduce the fs by lets say 100G and also the
> partition, you could install or copy a newer linux+kernel to
> partition(s) in that 100G space and boot from there.

let me try finding the latest kernel then. There are backports.

--001a1140d744a799af05290371f7
Content-Type: text/plain; charset=US-ASCII; name="remount to make disk rw.txt"
Content-Disposition: attachment; filename="remount to make disk rw.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ij94nrgl0

WzE4ODkzNi43NzIxOThdIEJUUkZTIGVycm9yIChkZXZpY2Ugc2RjMSk6IGNsZWFuZXIgdHJhbnNh
Y3Rpb24gYXR0YWNoIHJldHVybmVkIC0zMApbMTg4OTM2Ljc3NjE4OF0gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tClsxODg5MzYuNzc2MjE1XSBXQVJOSU5HOiBDUFU6IDMgUElE
OiA2MjMgYXQgL2hvbWUva2VybmVsL0NPRC9saW51eC9mcy9idHJmcy9pbm9kZS5jOjg5NjggYnRy
ZnNfZGVzdHJveV9pbm9kZSsweDI5OC8weDJjMCBbYnRyZnNdKCkKWzE4ODkzNi43NzYyMTddIE1v
ZHVsZXMgbGlua2VkIGluOiB1ZnMgcW54NCBoZnNwbHVzIGhmcyBtaW5peCBudGZzIG1zZG9zIGpm
cyB4ZnMgbGliY3JjMzJjIG5sc191dGY4IGlzb2ZzIHBjaV9zdHViIHZib3hwY2koT0UpIHZib3hu
ZXRhZHAoT0UpIHZib3huZXRmbHQoT0UpIHZib3hkcnYoT0UpIGN1c2UgaXB0X01BU1FVRVJBREUg
bmZfbmF0X21hc3F1ZXJhZGVfaXB2NCBpcHRhYmxlX25hdCBuZl9uYXRfaXB2NCBuZl9uYXQgbmZf
Y29ubnRyYWNrX2lwdjQgbmZfZGVmcmFnX2lwdjQgeHRfY29ubnRyYWNrIG5mX2Nvbm50cmFjayBp
cHRfUkVKRUNUIG5mX3JlamVjdF9pcHY0IHh0X0NIRUNLU1VNIGlwdGFibGVfbWFuZ2xlIHh0X3Rj
cHVkcCBicmlkZ2Ugc3RwIGxsYyBpcDZ0YWJsZV9maWx0ZXIgaXA2X3RhYmxlcyBpcHRhYmxlX2Zp
bHRlciBpcF90YWJsZXMgZWJ0YWJsZV9uYXQgZWJ0YWJsZXMgeF90YWJsZXMgdXNibHAgc25kX2hk
YV9jb2RlY19oZG1pIGhwX3dtaSBzcGFyc2Vfa2V5bWFwIHNuZF9oZGFfY29kZWNfaWR0IHNuZF9o
ZGFfY29kZWNfZ2VuZXJpYyBpbnRlbF9yYXBsIGlvc2ZfbWJpIHg4Nl9wa2dfdGVtcF90aGVybWFs
IGludGVsX3Bvd2VyY2xhbXAgZG1fbXVsdGlwYXRoIHNuZF9oZGFfaW50ZWwgc25kX2hkYV9jb2Rl
YyBjb3JldGVtcCBzbmRfaGRhX2NvcmUga3ZtX2ludGVsIHJhZGVvbiBzbmRfaHdkZXAgaGlkX2xv
Z2l0ZWNoX2hpZHBwIGt2bSBzbmRfcGNtIGk5MTUgc25kX3NlcV9taWRpIGNyYzMyX3BjbG11bCBz
bmRfc2VxX21pZGlfZXZlbnQgc25kX3Jhd21pZGkgYWVzbmlfaW50ZWwgYWVzX2k1ODYgdHRtIHh0
cyBzbmRfc2VxIGxydyBkcm1fa21zX2hlbHBlciBzbmRfc2VxX2RldmljZSBnZjEyOG11bCBzbmRf
dGltZXIgYWJsa19oZWxwZXIgZHJtIGpveWRldiBjcnlwdGQgYm5lcCByZmNvbW0gc25kIGlucHV0
X2xlZHMgaTJjX2FsZ29fYml0IGZiX3N5c19mb3BzIHJ0c3hfcGNpX21zIGJsdWV0b290aCBzZXJp
b19yYXcgc291bmRjb3JlIHN5c2NvcHlhcmVhIG1lbXN0aWNrIHN5c2ZpbGxyZWN0IHN5c2ltZ2Js
dCBocF9hY2NlbCBtZWlfbWUgbGlzM2x2MDJkIGxwY19pY2ggd21pIHNocGNocCBpbnB1dF9wb2xs
ZGV2IG1laSB2aWRlbyBtYWNfaGlkIG5mc2QgYXV0aF9ycGNnc3MgbmZzX2FjbCBwYXJwb3J0X3Bj
IG5mcyBwcGRldiBsb2NrZCBscCBncmFjZSBzdW5ycGMgcGFycG9ydCBmc2NhY2hlIGJpbmZtdF9t
aXNjIGhpZF9nZW5lcmljIGhpZF9sb2dpdGVjaF9kaiB1c2JoaWQgaGlkIGJ0cmZzIHhvciB1YXMg
dXNiX3N0b3JhZ2UgcmFpZDZfcHEgcnRzeF9wY2lfc2RtbWMgYWhjaSByODE2OSBzZGhjaV9wY2kg
cHNtb3VzZSBsaWJhaGNpIHNkaGNpIHJ0c3hfcGNpIG1paSBmamVzClsxODg5MzYuNzc2MzEyXSBD
UFU6IDMgUElEOiA2MjMgQ29tbTogdW1vdW50IFRhaW50ZWQ6IEcgICAgICAgIFcgIE9FICAgNC4z
LjAtMDQwMzAwcmM3LWdlbmVyaWMgIzIwMTUxMDI2MDcxMgpbMTg4OTM2Ljc3NjMxNF0gSGFyZHdh
cmUgbmFtZTogSGV3bGV0dC1QYWNrYXJkIEhQIFBhdmlsaW9uIGR2NiBOb3RlYm9vayBQQy8xN0ZB
LCBCSU9TIEYuMDIgMTAvMDMvMjAxMQpbMTg4OTM2Ljc3NjMxN10gIDAwMDAwMDAwIDAwMDAwMDAw
IGU4MzFkZGRjIGMxMzYxMGU4IDAwMDAwMDAwIGU4MzFkZTBjIGMxMDY4MTA3IGMxOTU3ODA0Clsx
ODg5MzYuNzc2MzIyXSAgMDAwMDAwMDMgMDAwMDAyNmYgZjhhZTVjMzQgMDAwMDIzMDggZjhhNmUy
NDggZjhhNmUyNDggY2VhYmIxZTQgMDAwMDAwMDIKWzE4ODkzNi43NzYzMjZdICBlYTg4NzgwMCBl
ODMxZGUxYyBjMTA2ODFlMiAwMDAwMDAwOSAwMDAwMDAwMCBlODMxZGU0YyBmOGE2ZTI0OCBlODMx
ZGUzOApbMTg4OTM2Ljc3NjMzMV0gQ2FsbCBUcmFjZToKWzE4ODkzNi43NzYzMzhdICBbPGMxMzYx
MGU4Pl0gZHVtcF9zdGFjaysweDQxLzB4NTkKWzE4ODkzNi43NzYzNDNdICBbPGMxMDY4MTA3Pl0g
d2Fybl9zbG93cGF0aF9jb21tb24rMHg4Ny8weGMwClsxODg5MzYuNzc2MzYwXSAgWzxmOGE2ZTI0
OD5dID8gYnRyZnNfZGVzdHJveV9pbm9kZSsweDI5OC8weDJjMCBbYnRyZnNdClsxODg5MzYuNzc2
Mzc1XSAgWzxmOGE2ZTI0OD5dID8gYnRyZnNfZGVzdHJveV9pbm9kZSsweDI5OC8weDJjMCBbYnRy
ZnNdClsxODg5MzYuNzc2Mzc5XSAgWzxjMTA2ODFlMj5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDIy
LzB4MzAKWzE4ODkzNi43NzYzOTNdICBbPGY4YTZlMjQ4Pl0gYnRyZnNfZGVzdHJveV9pbm9kZSsw
eDI5OC8weDJjMCBbYnRyZnNdClsxODg5MzYuNzc2Mzk3XSAgWzxjMTIwMWZlOD5dID8gZnNub3Rp
ZnlfZGVzdHJveV9tYXJrcysweDU4LzB4NzAKWzE4ODkzNi43NzY0MDBdICBbPGMxMWRkOGRmPl0g
ZGVzdHJveV9pbm9kZSsweDJmLzB4NjAKWzE4ODkzNi43NzY0MDJdICBbPGMxMWRkYTBhPl0gZXZp
Y3QrMHhmYS8weDE3MApbMTg4OTM2Ljc3NjQwNV0gIFs8YzExZGRjMjM+XSBpcHV0KzB4MTUzLzB4
MWMwClsxODg5MzYuNzc2NDE5XSAgWzxmOGE0NGI2ND5dIGJ0cmZzX3B1dF9ibG9ja19ncm91cF9j
YWNoZSsweDk0LzB4ZDAgW2J0cmZzXQpbMTg4OTM2Ljc3NjQzNF0gIFs8ZjhhNTY5YjE+XSBjbG9z
ZV9jdHJlZSsweDEzMS8weDMwMCBbYnRyZnNdClsxODg5MzYuNzc2NDM3XSAgWzxjMTFkZGFiNz5d
ID8gZGlzcG9zZV9saXN0KzB4MzcvMHg1MApbMTg4OTM2Ljc3NjQ0MF0gIFs8YzExZGU3Njk+XSA/
IGV2aWN0X2lub2RlcysweDEzOS8weDE1MApbMTg4OTM2Ljc3NjQ1MF0gIFs8ZjhhMjcwNTY+XSBi
dHJmc19wdXRfc3VwZXIrMHgxNi8weDIwIFtidHJmc10KWzE4ODkzNi43NzY0NTRdICBbPGMxMWM2
ODUwPl0gZ2VuZXJpY19zaHV0ZG93bl9zdXBlcisweDYwLzB4ZTAKWzE4ODkzNi43NzY0NThdICBb
PGMxMWFiMWVkPl0gPyBrZnJlZSsweDEyZC8weDE0MApbMTg4OTM2Ljc3NjQ2Ml0gIFs8YzExNmRm
MDA+XSA/IHVucmVnaXN0ZXJfc2hyaW5rZXIrMHg0MC8weDUwClsxODg5MzYuNzc2NDY1XSAgWzxj
MTFjNmFmMT5dIGtpbGxfYW5vbl9zdXBlcisweDExLzB4MjAKWzE4ODkzNi43NzY0NzVdICBbPGY4
YTI3ZjY1Pl0gYnRyZnNfa2lsbF9zdXBlcisweDE1LzB4ZjAgW2J0cmZzXQpbMTg4OTM2Ljc3NjQ3
OV0gIFs8YzExYzZjNGQ+XSBkZWFjdGl2YXRlX2xvY2tlZF9zdXBlcisweDNkLzB4NzAKWzE4ODkz
Ni43NzY0ODJdICBbPGMxMWM3MGI3Pl0gZGVhY3RpdmF0ZV9zdXBlcisweDU3LzB4NjAKWzE4ODkz
Ni43NzY0ODVdICBbPGMxMWUxZDQ5Pl0gY2xlYW51cF9tbnQrMHgzOS8weDkwClsxODg5MzYuNzc2
NDg4XSAgWzxjMTFlMWRlMD5dIF9fY2xlYW51cF9tbnQrMHgxMC8weDIwClsxODg5MzYuNzc2NDkx
XSAgWzxjMTA4MjJjZj5dIHRhc2tfd29ya19ydW4rMHg3Zi8weGEwClsxODg5MzYuNzc2NDk1XSAg
WzxjMTAwMzVlNT5dIHByZXBhcmVfZXhpdF90b191c2VybW9kZSsweGY1LzB4MTIwClsxODg5MzYu
Nzc2NDk4XSAgWzxjMTAwMzY0Nj5dIHN5c2NhbGxfcmV0dXJuX3Nsb3dwYXRoKzB4MzYvMHgxMjAK
WzE4ODkzNi43NzY1MDFdICBbPGMxMWUzMzY1Pl0gPyBTeVNfb2xkdW1vdW50KzB4NzUvMHhiMApb
MTg4OTM2Ljc3NjUwNl0gIFs8YzE3NDM3ODY+XSBzeXNjYWxsX2V4aXRfd29yaysweDcvMHhjClsx
ODg5MzYuNzc2NTA5XSAtLS1bIGVuZCB0cmFjZSBkYzNjZjY4MTQ1MjZjN2M4IF0tLS0KWzE4ODkz
Ni43Nzc0MDhdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbMTg4OTM2Ljc3
NzQyNl0gV0FSTklORzogQ1BVOiAzIFBJRDogNjIzIGF0IC9ob21lL2tlcm5lbC9DT0QvbGludXgv
ZnMvYnRyZnMvaW5vZGUuYzo4OTY4IGJ0cmZzX2Rlc3Ryb3lfaW5vZGUrMHgyOTgvMHgyYzAgW2J0
cmZzXSgpClsxODg5MzYuNzc3NDI3XSBNb2R1bGVzIGxpbmtlZCBpbjogdWZzIHFueDQgaGZzcGx1
cyBoZnMgbWluaXggbnRmcyBtc2RvcyBqZnMgeGZzIGxpYmNyYzMyYyBubHNfdXRmOCBpc29mcyBw
Y2lfc3R1YiB2Ym94cGNpKE9FKSB2Ym94bmV0YWRwKE9FKSB2Ym94bmV0Zmx0KE9FKSB2Ym94ZHJ2
KE9FKSBjdXNlIGlwdF9NQVNRVUVSQURFIG5mX25hdF9tYXNxdWVyYWRlX2lwdjQgaXB0YWJsZV9u
YXQgbmZfbmF0X2lwdjQgbmZfbmF0IG5mX2Nvbm50cmFja19pcHY0IG5mX2RlZnJhZ19pcHY0IHh0
X2Nvbm50cmFjayBuZl9jb25udHJhY2sgaXB0X1JFSkVDVCBuZl9yZWplY3RfaXB2NCB4dF9DSEVD
S1NVTSBpcHRhYmxlX21hbmdsZSB4dF90Y3B1ZHAgYnJpZGdlIHN0cCBsbGMgaXA2dGFibGVfZmls
dGVyIGlwNl90YWJsZXMgaXB0YWJsZV9maWx0ZXIgaXBfdGFibGVzIGVidGFibGVfbmF0IGVidGFi
bGVzIHhfdGFibGVzIHVzYmxwIHNuZF9oZGFfY29kZWNfaGRtaSBocF93bWkgc3BhcnNlX2tleW1h
cCBzbmRfaGRhX2NvZGVjX2lkdCBzbmRfaGRhX2NvZGVjX2dlbmVyaWMgaW50ZWxfcmFwbCBpb3Nm
X21iaSB4ODZfcGtnX3RlbXBfdGhlcm1hbCBpbnRlbF9wb3dlcmNsYW1wIGRtX211bHRpcGF0aCBz
bmRfaGRhX2ludGVsIHNuZF9oZGFfY29kZWMgY29yZXRlbXAgc25kX2hkYV9jb3JlIGt2bV9pbnRl
bCByYWRlb24gc25kX2h3ZGVwIGhpZF9sb2dpdGVjaF9oaWRwcCBrdm0gc25kX3BjbSBpOTE1IHNu
ZF9zZXFfbWlkaSBjcmMzMl9wY2xtdWwgc25kX3NlcV9taWRpX2V2ZW50IHNuZF9yYXdtaWRpIGFl
c25pX2ludGVsIGFlc19pNTg2IHR0bSB4dHMgc25kX3NlcSBscncgZHJtX2ttc19oZWxwZXIgc25k
X3NlcV9kZXZpY2UgZ2YxMjhtdWwgc25kX3RpbWVyIGFibGtfaGVscGVyIGRybSBqb3lkZXYgY3J5
cHRkIGJuZXAgcmZjb21tIHNuZCBpbnB1dF9sZWRzIGkyY19hbGdvX2JpdCBmYl9zeXNfZm9wcyBy
dHN4X3BjaV9tcyBibHVldG9vdGggc2VyaW9fcmF3IHNvdW5kY29yZSBzeXNjb3B5YXJlYSBtZW1z
dGljayBzeXNmaWxscmVjdCBzeXNpbWdibHQgaHBfYWNjZWwgbWVpX21lIGxpczNsdjAyZCBscGNf
aWNoIHdtaSBzaHBjaHAgaW5wdXRfcG9sbGRldiBtZWkgdmlkZW8gbWFjX2hpZCBuZnNkIGF1dGhf
cnBjZ3NzIG5mc19hY2wgcGFycG9ydF9wYyBuZnMgcHBkZXYgbG9ja2QgbHAgZ3JhY2Ugc3VucnBj
IHBhcnBvcnQgZnNjYWNoZSBiaW5mbXRfbWlzYyBoaWRfZ2VuZXJpYyBoaWRfbG9naXRlY2hfZGog
dXNiaGlkIGhpZCBidHJmcyB4b3IgdWFzIHVzYl9zdG9yYWdlIHJhaWQ2X3BxIHJ0c3hfcGNpX3Nk
bW1jIGFoY2kgcjgxNjkgc2RoY2lfcGNpIHBzbW91c2UgbGliYWhjaSBzZGhjaSBydHN4X3BjaSBt
aWkgZmplcwpbMTg4OTM2Ljc3NzUwMl0gQ1BVOiAzIFBJRDogNjIzIENvbW06IHVtb3VudCBUYWlu
dGVkOiBHICAgICAgICBXICBPRSAgIDQuMy4wLTA0MDMwMHJjNy1nZW5lcmljICMyMDE1MTAyNjA3
MTIKWzE4ODkzNi43Nzc1MDRdIEhhcmR3YXJlIG5hbWU6IEhld2xldHQtUGFja2FyZCBIUCBQYXZp
bGlvbiBkdjYgTm90ZWJvb2sgUEMvMTdGQSwgQklPUyBGLjAyIDEwLzAzLzIwMTEKWzE4ODkzNi43
Nzc1MDVdICAwMDAwMDAwMCAwMDAwMDAwMCBlODMxZGRkYyBjMTM2MTBlOCAwMDAwMDAwMCBlODMx
ZGUwYyBjMTA2ODEwNyBjMTk1NzgwNApbMTg4OTM2Ljc3NzUxMF0gIDAwMDAwMDAzIDAwMDAwMjZm
IGY4YWU1YzM0IDAwMDAyMzA4IGY4YTZlMjQ4IGY4YTZlMjQ4IGQ0MDM5NWI0IDAwMDAwMDAyClsx
ODg5MzYuNzc3NTE1XSAgZWE4ODc4MDAgZTgzMWRlMWMgYzEwNjgxZTIgMDAwMDAwMDkgMDAwMDAw
MDAgZTgzMWRlNGMgZjhhNmUyNDggZTgzMWRlMzgKWzE4ODkzNi43Nzc1MjBdIENhbGwgVHJhY2U6
ClsxODg5MzYuNzc3NTI0XSAgWzxjMTM2MTBlOD5dIGR1bXBfc3RhY2srMHg0MS8weDU5ClsxODg5
MzYuNzc3NTI3XSAgWzxjMTA2ODEwNz5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4ODcvMHhjMApb
MTg4OTM2Ljc3NzU0Ml0gIFs8ZjhhNmUyNDg+XSA/IGJ0cmZzX2Rlc3Ryb3lfaW5vZGUrMHgyOTgv
MHgyYzAgW2J0cmZzXQpbMTg4OTM2Ljc3NzU1Nl0gIFs8ZjhhNmUyNDg+XSA/IGJ0cmZzX2Rlc3Ry
b3lfaW5vZGUrMHgyOTgvMHgyYzAgW2J0cmZzXQpbMTg4OTM2Ljc3NzU1OV0gIFs8YzEwNjgxZTI+
XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyMi8weDMwClsxODg5MzYuNzc3NTcyXSAgWzxmOGE2ZTI0
OD5dIGJ0cmZzX2Rlc3Ryb3lfaW5vZGUrMHgyOTgvMHgyYzAgW2J0cmZzXQpbMTg4OTM2Ljc3NzU3
NV0gIFs8YzEyMDFmZTg+XSA/IGZzbm90aWZ5X2Rlc3Ryb3lfbWFya3MrMHg1OC8weDcwClsxODg5
MzYuNzc3NTc4XSAgWzxjMTFkZDhkZj5dIGRlc3Ryb3lfaW5vZGUrMHgyZi8weDYwClsxODg5MzYu
Nzc3NTgxXSAgWzxjMTFkZGEwYT5dIGV2aWN0KzB4ZmEvMHgxNzAKWzE4ODkzNi43Nzc1ODNdICBb
PGMxMWRkYzIzPl0gaXB1dCsweDE1My8weDFjMApbMTg4OTM2Ljc3NzU5N10gIFs8ZjhhNDRiNjQ+
XSBidHJmc19wdXRfYmxvY2tfZ3JvdXBfY2FjaGUrMHg5NC8weGQwIFtidHJmc10KWzE4ODkzNi43
Nzc2MTFdICBbPGY4YTU2OWIxPl0gY2xvc2VfY3RyZWUrMHgxMzEvMHgzMDAgW2J0cmZzXQpbMTg4
OTM2Ljc3NzYxNF0gIFs8YzExZGRhYjc+XSA/IGRpc3Bvc2VfbGlzdCsweDM3LzB4NTAKWzE4ODkz
Ni43Nzc2MTddICBbPGMxMWRlNzY5Pl0gPyBldmljdF9pbm9kZXMrMHgxMzkvMHgxNTAKWzE4ODkz
Ni43Nzc2MjhdICBbPGY4YTI3MDU2Pl0gYnRyZnNfcHV0X3N1cGVyKzB4MTYvMHgyMCBbYnRyZnNd
ClsxODg5MzYuNzc3NjMxXSAgWzxjMTFjNjg1MD5dIGdlbmVyaWNfc2h1dGRvd25fc3VwZXIrMHg2
MC8weGUwClsxODg5MzYuNzc3NjM0XSAgWzxjMTFhYjFlZD5dID8ga2ZyZWUrMHgxMmQvMHgxNDAK
WzE4ODkzNi43Nzc2MzddICBbPGMxMTZkZjAwPl0gPyB1bnJlZ2lzdGVyX3Nocmlua2VyKzB4NDAv
MHg1MApbMTg4OTM2Ljc3NzY0MF0gIFs8YzExYzZhZjE+XSBraWxsX2Fub25fc3VwZXIrMHgxMS8w
eDIwClsxODg5MzYuNzc3NjUwXSAgWzxmOGEyN2Y2NT5dIGJ0cmZzX2tpbGxfc3VwZXIrMHgxNS8w
eGYwIFtidHJmc10KWzE4ODkzNi43Nzc2NTNdICBbPGMxMWM2YzRkPl0gZGVhY3RpdmF0ZV9sb2Nr
ZWRfc3VwZXIrMHgzZC8weDcwClsxODg5MzYuNzc3NjU2XSAgWzxjMTFjNzBiNz5dIGRlYWN0aXZh
dGVfc3VwZXIrMHg1Ny8weDYwClsxODg5MzYuNzc3NjU5XSAgWzxjMTFlMWQ0OT5dIGNsZWFudXBf
bW50KzB4MzkvMHg5MApbMTg4OTM2Ljc3NzY2Ml0gIFs8YzExZTFkZTA+XSBfX2NsZWFudXBfbW50
KzB4MTAvMHgyMApbMTg4OTM2Ljc3NzY2NV0gIFs8YzEwODIyY2Y+XSB0YXNrX3dvcmtfcnVuKzB4
N2YvMHhhMApbMTg4OTM2Ljc3NzY2OF0gIFs8YzEwMDM1ZTU+XSBwcmVwYXJlX2V4aXRfdG9fdXNl
cm1vZGUrMHhmNS8weDEyMApbMTg4OTM2Ljc3NzY3MV0gIFs8YzEwMDM2NDY+XSBzeXNjYWxsX3Jl
dHVybl9zbG93cGF0aCsweDM2LzB4MTIwClsxODg5MzYuNzc3Njc0XSAgWzxjMTFlMzM2NT5dID8g
U3lTX29sZHVtb3VudCsweDc1LzB4YjAKWzE4ODkzNi43Nzc2NzldICBbPGMxNzQzNzg2Pl0gc3lz
Y2FsbF9leGl0X3dvcmsrMHg3LzB4YwpbMTg4OTM2Ljc3NzY4Ml0gLS0tWyBlbmQgdHJhY2UgZGMz
Y2Y2ODE0NTI2YzdjOSBdLS0tClsxODg5MzkuMjIyNDAzXSBCVFJGUyBpbmZvIChkZXZpY2Ugc2Rj
MSk6IGRpc2sgc3BhY2UgY2FjaGluZyBpcyBlbmFibGVkClsxODkwMDIuNTg4NTc3XSBCVFJGUyBp
bmZvIChkZXZpY2Ugc2RjMSk6IFRoZSBmcmVlIHNwYWNlIGNhY2hlIGZpbGUgKDIxNTkzMjQxNjgx
OTIpIGlzIGludmFsaWQuIHNraXAgaXQKWzE4OTAwMi41ODg1NzddIAoK
--001a1140d744a799af05290371f7--
