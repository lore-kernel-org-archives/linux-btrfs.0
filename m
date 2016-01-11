Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38272 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899AbcAKNbK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 08:31:10 -0500
Received: by mail-wm0-f48.google.com with SMTP id b14so268462126wmb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 05:31:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+9GZUjj8a=drg7--p-f02+QXLo7aWMyZd3O8TA9gTyGWb3MLA@mail.gmail.com>
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
 <CA+9GZUgnmMoLeGsyeo=tFe2GLsDkLEr0umiDovf3P2aBtDA+Xg@mail.gmail.com>
 <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk> <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk> <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
 <5693A8B3.2090508@gmail.com> <CA+9GZUjj8a=drg7--p-f02+QXLo7aWMyZd3O8TA9gTyGWb3MLA@mail.gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Mon, 11 Jan 2016 14:30:49 +0100
Message-ID: <CA+9GZUg-6WrQTgCw_AmVb2qqr4aL4xeWH6mSq1zQ14qbxextzA@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e010d8b022776cc05290ef378
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--089e010d8b022776cc05290ef378
Content-Type: text/plain; charset=UTF-8

The bug just happened again. Attached is a log since the time I
mounted the FS right after the fsck.

Note the only things between the message I got while mounting:
[216798.144518] BTRFS info (device sdc1): disk space caching is enabled

and the beginning of the crash dump:
[241534.760651] ------------[ cut here ]------------

is this:
[218266.098344] usb 4-1.1: reset high-speed USB device number 3 using ehci-pci
[233647.332085] usb 4-1.1: reset high-speed USB device number 3 using ehci-pci

I am not sure why those resets happen, though. I bought a few cables
and experimented with them, and the usb ports themselves are located
directly on the motherboard.
Also, they happened some considerable time before the crash dump. So
I'm not sure they're even related. Especially given that I was copying
a lot of very small files, and they all copied onto the disk fine all
the time between the last usb reset and the crash dump, which is
roughly two and a half hours. In fact I pressed ctrl-z on a move
operation and then wrote something like sleep $(echo '60*60*3' | bc) ;
fg and ran it just past 9 am, so the mv resumed past 12 pm, so as
things add up the last usb reset happened even before the mv was
resumed with fg.

I unmounted the fs and re-mounted the it to make it writeable again.
This showed up in dmesg:

[241766.485365] BTRFS error (device sdc1): cleaner transaction attach
returned -30
[241770.115897] BTRFS info (device sdc1): disk space caching is enabled

this time there was no "info" line about the free space cache file. So
maybe it wasn't important for the bug to occur at all.

The new output of btrfs fi df -g is:
Data, single: total=2080.01GiB, used=2078.80GiB
System, DUP: total=0.01GiB, used=0.00GiB
System, single: total=0.00GiB, used=0.00GiB
Metadata, DUP: total=5.50GiB, used=3.73GiB
Metadata, single: total=0.01GiB, used=0.00GiB
GlobalReserve, single: total=0.50GiB, used=0.00GiB

I could swap this disk onto sata and the other disk back onto usb to
see if the usb resets have anything to do with this. But I'm skeptic.
Also maybe btrfs has some other issues related to just the disk being
on usb, resets or not, and this way if the bug doesn't trigger on sata
we'll think "aha it was the resets, buggy hardware etc" but instead
it'll have been something else that just has to do with the disk being
on usb operating normally.

On Mon, Jan 11, 2016 at 2:11 PM, cheater00 . <cheater00@gmail.com> wrote:
> On Mon, Jan 11, 2016 at 2:05 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-01-09 16:07, cheater00 . wrote:
>>>
>>> Would like to point out that this can cause data loss. If I'm writing
>>> to disk and the disk becomes unexpectedly read only - that data will
>>> be lost, because who in their right mind makes their code expect this
>>> and builds a contingency (e.g. caching, backpressure, etc)...
>>
>> If a data critical application (mail server, database server, anything
>> similar) can't gracefully handle ENOSPC, then that application is broken,
>> not the FS.  As an example, set up a small VM with an SMTP server, then
>> force the FS the server uses for queuing mail read-only, and see if you can
>> submit mail, then go read the RFCs for SMTP and see what clients are
>> supposed to do when they can't submit mail.  A properly designed piece of
>> software is supposed to be resilient against common failure modes of the
>> resources it depends on (which includes ENOSPC and read-only filesystems for
>> anything that works with data on disk).
>>>
>>>
>>> There's no loss of data on the disk because the data doesn't make it
>>> to disk in the first place. But it's exactly the same as if the data
>>> had been written to disk, and then lost.
>>>
>> No, it isn't.  If you absolutely need the data on disk, you should be
>> calling fsync or fdatasync, and then assuming if those return an error that
>> none of the data written since the last call has gotten to the disk (some of
>> it might have, but you need to assume it hasn't).  Every piece of software
>> in wide usage that requires data to be on the disk does this, because
>> otherwise it can't guarantee that the data is on disk.
>
> I agree that a lot of stuff goes right in a perfect world. But most of
> the time what you're running isn't a mail server used by billions of
> users, but instead a bash script someone wrote once that's supposed to
> do something, and no one knows how it works.

--089e010d8b022776cc05290ef378
Content-Type: text/plain; charset=US-ASCII; name="bug again after fsck and remount.txt"
Content-Disposition: attachment;
	filename="bug again after fsck and remount.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ija00gpw0

WzIxNjc5OC4xNDQ1MThdIEJUUkZTIGluZm8gKGRldmljZSBzZGMxKTogZGlzayBzcGFjZSBjYWNo
aW5nIGlzIGVuYWJsZWQKWzIxODI2Ni4wOTgzNDRdIHVzYiA0LTEuMTogcmVzZXQgaGlnaC1zcGVl
ZCBVU0IgZGV2aWNlIG51bWJlciAzIHVzaW5nIGVoY2ktcGNpClsyMzM2NDcuMzMyMDg1XSB1c2Ig
NC0xLjE6IHJlc2V0IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMyB1c2luZyBlaGNpLXBj
aQpbMjQxNTM0Ljc2MDY1MV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsy
NDE1MzQuNzYwNjc1XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxOTg0NSBhdCAvaG9tZS9rZXJuZWwv
Q09EL2xpbnV4L2ZzL2J0cmZzL2V4dGVudC10cmVlLmM6Mjg1MSBidHJmc19ydW5fZGVsYXllZF9y
ZWZzKzB4MjI3LzB4MjUwIFtidHJmc10oKQpbMjQxNTM0Ljc2MDY3N10gQlRSRlM6IFRyYW5zYWN0
aW9uIGFib3J0ZWQgKGVycm9yIC0yOCkKWzI0MTUzNC43NjA2NzldIE1vZHVsZXMgbGlua2VkIGlu
OiB1ZnMgcW54NCBoZnNwbHVzIGhmcyBtaW5peCBudGZzIG1zZG9zIGpmcyB4ZnMgbGliY3JjMzJj
IG5sc191dGY4IGlzb2ZzIHBjaV9zdHViIHZib3hwY2koT0UpIHZib3huZXRhZHAoT0UpIHZib3hu
ZXRmbHQoT0UpIHZib3hkcnYoT0UpIGN1c2UgaXB0X01BU1FVRVJBREUgbmZfbmF0X21hc3F1ZXJh
ZGVfaXB2NCBpcHRhYmxlX25hdCBuZl9uYXRfaXB2NCBuZl9uYXQgbmZfY29ubnRyYWNrX2lwdjQg
bmZfZGVmcmFnX2lwdjQgeHRfY29ubnRyYWNrIG5mX2Nvbm50cmFjayBpcHRfUkVKRUNUIG5mX3Jl
amVjdF9pcHY0IHh0X0NIRUNLU1VNIGlwdGFibGVfbWFuZ2xlIHh0X3RjcHVkcCBicmlkZ2Ugc3Rw
IGxsYyBpcDZ0YWJsZV9maWx0ZXIgaXA2X3RhYmxlcyBpcHRhYmxlX2ZpbHRlciBpcF90YWJsZXMg
ZWJ0YWJsZV9uYXQgZWJ0YWJsZXMgeF90YWJsZXMgdXNibHAgc25kX2hkYV9jb2RlY19oZG1pIGhw
X3dtaSBzcGFyc2Vfa2V5bWFwIHNuZF9oZGFfY29kZWNfaWR0IHNuZF9oZGFfY29kZWNfZ2VuZXJp
YyBpbnRlbF9yYXBsIGlvc2ZfbWJpIHg4Nl9wa2dfdGVtcF90aGVybWFsIGludGVsX3Bvd2VyY2xh
bXAgZG1fbXVsdGlwYXRoIHNuZF9oZGFfaW50ZWwgc25kX2hkYV9jb2RlYyBjb3JldGVtcCBzbmRf
aGRhX2NvcmUga3ZtX2ludGVsIHJhZGVvbiBzbmRfaHdkZXAgaGlkX2xvZ2l0ZWNoX2hpZHBwIGt2
bSBzbmRfcGNtIGk5MTUgc25kX3NlcV9taWRpIGNyYzMyX3BjbG11bCBzbmRfc2VxX21pZGlfZXZl
bnQgc25kX3Jhd21pZGkgYWVzbmlfaW50ZWwgYWVzX2k1ODYgdHRtIHh0cyBzbmRfc2VxIGxydyBk
cm1fa21zX2hlbHBlciBzbmRfc2VxX2RldmljZSBnZjEyOG11bCBzbmRfdGltZXIgYWJsa19oZWxw
ZXIgZHJtIGpveWRldiBjcnlwdGQgYm5lcCByZmNvbW0gc25kIGlucHV0X2xlZHMgaTJjX2FsZ29f
Yml0IGZiX3N5c19mb3BzIHJ0c3hfcGNpX21zIGJsdWV0b290aCBzZXJpb19yYXcgc291bmRjb3Jl
IHN5c2NvcHlhcmVhIG1lbXN0aWNrIHN5c2ZpbGxyZWN0IHN5c2ltZ2JsdCBocF9hY2NlbCBtZWlf
bWUgbGlzM2x2MDJkIGxwY19pY2ggd21pIHNocGNocCBpbnB1dF9wb2xsZGV2IG1laSB2aWRlbyBt
YWNfaGlkIG5mc2QgYXV0aF9ycGNnc3MgbmZzX2FjbCBwYXJwb3J0X3BjIG5mcyBwcGRldiBsb2Nr
ZCBscCBncmFjZSBzdW5ycGMgcGFycG9ydCBmc2NhY2hlIGJpbmZtdF9taXNjIGhpZF9nZW5lcmlj
IGhpZF9sb2dpdGVjaF9kaiB1c2JoaWQgaGlkIGJ0cmZzIHhvciB1YXMgdXNiX3N0b3JhZ2UgcmFp
ZDZfcHEgcnRzeF9wY2lfc2RtbWMgYWhjaSByODE2OSBzZGhjaV9wY2kgcHNtb3VzZSBsaWJhaGNp
IHNkaGNpIHJ0c3hfcGNpIG1paSBmamVzClsyNDE1MzQuNzYwNzc1XSBDUFU6IDAgUElEOiAxOTg0
NSBDb21tOiBidHJmcy10cmFuc2FjdGkgVGFpbnRlZDogRyAgICAgICAgVyAgT0UgICA0LjMuMC0w
NDAzMDByYzctZ2VuZXJpYyAjMjAxNTEwMjYwNzEyClsyNDE1MzQuNzYwNzc2XSBIYXJkd2FyZSBu
YW1lOiBIZXdsZXR0LVBhY2thcmQgSFAgUGF2aWxpb24gZHY2IE5vdGVib29rIFBDLzE3RkEsIEJJ
T1MgRi4wMiAxMC8wMy8yMDExClsyNDE1MzQuNzYwNzc4XSAgMDAwMDAwMDAgMDAwMDAwMDAgZTRj
OWRkZDggYzEzNjEwZTggZTRjOWRlMTggZTRjOWRlMDggYzEwNjgxMDcgZjhhZTQxOTAKWzI0MTUz
NC43NjA3ODJdICBlNGM5ZGUzNCAwMDAwNGQ4NSBmOGFlM2ZmMCAwMDAwMGIyMyBmOGE0NWE3NyBm
OGE0NWE3NyBlYTY3NDA3OCBmZmZmZmZlNApbMjQxNTM0Ljc2MDc4Nl0gIGNhZmFmNDAwIGU0Yzlk
ZTIwIGMxMDY4MTczIDAwMDAwMDA5IGU0YzlkZTE4IGY4YWU0MTkwIGU0YzlkZTM0IGU0YzlkZTVj
ClsyNDE1MzQuNzYwNzkwXSBDYWxsIFRyYWNlOgpbMjQxNTM0Ljc2MDc5Nl0gIFs8YzEzNjEwZTg+
XSBkdW1wX3N0YWNrKzB4NDEvMHg1OQpbMjQxNTM0Ljc2MDgwMF0gIFs8YzEwNjgxMDc+XSB3YXJu
X3Nsb3dwYXRoX2NvbW1vbisweDg3LzB4YzAKWzI0MTUzNC43NjA4MTBdICBbPGY4YTQ1YTc3Pl0g
PyBidHJmc19ydW5fZGVsYXllZF9yZWZzKzB4MjI3LzB4MjUwIFtidHJmc10KWzI0MTUzNC43NjA4
MThdICBbPGY4YTQ1YTc3Pl0gPyBidHJmc19ydW5fZGVsYXllZF9yZWZzKzB4MjI3LzB4MjUwIFti
dHJmc10KWzI0MTUzNC43NjA4MjBdICBbPGMxMDY4MTczPl0gd2Fybl9zbG93cGF0aF9mbXQrMHgz
My8weDQwClsyNDE1MzQuNzYwODI4XSAgWzxmOGE0NWE3Nz5dIGJ0cmZzX3J1bl9kZWxheWVkX3Jl
ZnMrMHgyMjcvMHgyNTAgW2J0cmZzXQpbMjQxNTM0Ljc2MDgzNl0gIFs8ZjhhNDY3ZjA+XSBidHJm
c193cml0ZV9kaXJ0eV9ibG9ja19ncm91cHMrMHgxNzAvMHgyYTAgW2J0cmZzXQpbMjQxNTM0Ljc2
MDg0OF0gIFs8ZjhhZGIzYzg+XSBjb21taXRfY293b25seV9yb290cysweDFlOS8weDI2YSBbYnRy
ZnNdClsyNDE1MzQuNzYwODU5XSAgWzxmOGE1YjZiYT5dIGJ0cmZzX2NvbW1pdF90cmFuc2FjdGlv
bisweDg3YS8weGU5MCBbYnRyZnNdClsyNDE1MzQuNzYwODY5XSAgWzxmOGE1YmQ0ZD5dID8gc3Rh
cnRfdHJhbnNhY3Rpb24rMHg3ZC8weDViMCBbYnRyZnNdClsyNDE1MzQuNzYwODc4XSAgWzxmOGE1
Njg2NT5dIHRyYW5zYWN0aW9uX2t0aHJlYWQrMHgyMTUvMHgyMzAgW2J0cmZzXQpbMjQxNTM0Ljc2
MDg4N10gIFs8ZjhhNTY2NTA+XSA/IGJ0cmZzX2NsZWFudXBfdHJhbnNhY3Rpb24rMHg0OTAvMHg0
OTAgW2J0cmZzXQpbMjQxNTM0Ljc2MDg5MF0gIFs8YzEwODNjM2I+XSBrdGhyZWFkKzB4OWIvMHhi
MApbMjQxNTM0Ljc2MDg5NF0gIFs8YzE3NDM1ODE+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4
MjEvMHgzMApbMjQxNTM0Ljc2MDg5N10gIFs8YzEwODNiYTA+XSA/IGt0aHJlYWRfY3JlYXRlX29u
X25vZGUrMHgxMTAvMHgxMTAKWzI0MTUzNC43NjA4OTldIC0tLVsgZW5kIHRyYWNlIGRjM2NmNjgx
NDUyNmM3Y2EgXS0tLQpbMjQxNTM0Ljc2MDkyM10gQlRSRlM6IGVycm9yIChkZXZpY2Ugc2RjMSkg
aW4gYnRyZnNfcnVuX2RlbGF5ZWRfcmVmczoyODUxOiBlcnJubz0tMjggTm8gc3BhY2UgbGVmdApb
MjQxNTM0Ljc2MDkyN10gQlRSRlMgaW5mbyAoZGV2aWNlIHNkYzEpOiBmb3JjZWQgcmVhZG9ubHkK
WzI0MTUzNC43NjExOThdIEJUUkZTIHdhcm5pbmcgKGRldmljZSBzZGMxKTogU2tpcHBpbmcgY29t
bWl0IG9mIGFib3J0ZWQgdHJhbnNhY3Rpb24uClsyNDE1MzQuNzYxMjAxXSBCVFJGUzogZXJyb3Ig
KGRldmljZSBzZGMxKSBpbiBjbGVhbnVwX3RyYW5zYWN0aW9uOjE3NDE6IGVycm5vPS0yOCBObyBz
cGFjZSBsZWZ0Cgo=
--089e010d8b022776cc05290ef378
Content-Type: text/plain; charset=US-ASCII; name="lsusb.txt"
Content-Disposition: attachment; filename="lsusb.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ija00kyy1

IyBsc3VzYgpCdXMgMDA0IERldmljZSAwMDc6IElEIDA1ZTM6MDYwOCBHZW5lc3lzIExvZ2ljLCBJ
bmMuIEh1YgpCdXMgMDA0IERldmljZSAwMDY6IElEIDA0NmQ6YzMxZCBMb2dpdGVjaCwgSW5jLiBN
ZWRpYSBLZXlib2FyZCBLMjAwCkJ1cyAwMDQgRGV2aWNlIDAwNTogSUQgMDQ2ZDpjNTJiIExvZ2l0
ZWNoLCBJbmMuIFVuaWZ5aW5nIFJlY2VpdmVyCkJ1cyAwMDQgRGV2aWNlIDAwNDogSUQgMDVlMzow
NjA4IEdlbmVzeXMgTG9naWMsIEluYy4gSHViCkJ1cyAwMDQgRGV2aWNlIDAwMzogSUQgMDY3Yjoy
NzczIFByb2xpZmljIFRlY2hub2xvZ3ksIEluYy4gUEwyNzczIFNBVEFJSSBicmlkZ2UgY29udHJv
bGxlcgpCdXMgMDA0IERldmljZSAwMDI6IElEIDgwODc6MDAyNCBJbnRlbCBDb3JwLiBJbnRlZ3Jh
dGVkIFJhdGUgTWF0Y2hpbmcgSHViCkJ1cyAwMDQgRGV2aWNlIDAwMTogSUQgMWQ2YjowMDAyIExp
bnV4IEZvdW5kYXRpb24gMi4wIHJvb3QgaHViCkJ1cyAwMDIgRGV2aWNlIDAwMTogSUQgMWQ2Yjow
MDAzIExpbnV4IEZvdW5kYXRpb24gMy4wIHJvb3QgaHViCkJ1cyAwMDEgRGV2aWNlIDAwMzogSUQg
MDRmYzowYzA1IFN1bnBsdXMgVGVjaG5vbG9neSBDby4sIEx0ZCAKQnVzIDAwMSBEZXZpY2UgMDAy
OiBJRCAwNGU4OjMyNTIgU2Ftc3VuZyBFbGVjdHJvbmljcyBDby4sIEx0ZCAKQnVzIDAwMSBEZXZp
Y2UgMDAxOiBJRCAxZDZiOjAwMDIgTGludXggRm91bmRhdGlvbiAyLjAgcm9vdCBodWIKQnVzIDAw
MyBEZXZpY2UgMDAzOiBJRCAxMzhhOjAwMTggVmFsaWRpdHkgU2Vuc29ycywgSW5jLiBGaW5nZXJw
cmludCBzY2FubmVyCkJ1cyAwMDMgRGV2aWNlIDAwMjogSUQgODA4NzowMDI0IEludGVsIENvcnAu
IEludGVncmF0ZWQgUmF0ZSBNYXRjaGluZyBIdWIKQnVzIDAwMyBEZXZpY2UgMDAxOiBJRCAxZDZi
OjAwMDIgTGludXggRm91bmRhdGlvbiAyLjAgcm9vdCBodWIKCiMgbHN1c2IgLXQKLzogIEJ1cyAw
NC5Qb3J0IDE6IERldiAxLCBDbGFzcz1yb290X2h1YiwgRHJpdmVyPWVoY2ktcGNpLzJwLCA0ODBN
CiAgICB8X18gUG9ydCAxOiBEZXYgMiwgSWYgMCwgQ2xhc3M9SHViLCBEcml2ZXI9aHViLzZwLCA0
ODBNCiAgICAgICAgfF9fIFBvcnQgMTogRGV2IDMsIElmIDAsIENsYXNzPU1hc3MgU3RvcmFnZSwg
RHJpdmVyPXVzYi1zdG9yYWdlLCA0ODBNCiAgICAgICAgfF9fIFBvcnQgMjogRGV2IDQsIElmIDAs
IENsYXNzPUh1YiwgRHJpdmVyPWh1Yi80cCwgNDgwTQogICAgICAgICAgICB8X18gUG9ydCAxOiBE
ZXYgNSwgSWYgMCwgQ2xhc3M9SHVtYW4gSW50ZXJmYWNlIERldmljZSwgRHJpdmVyPXVzYmhpZCwg
MTJNCiAgICAgICAgICAgIHxfXyBQb3J0IDE6IERldiA1LCBJZiAxLCBDbGFzcz1IdW1hbiBJbnRl
cmZhY2UgRGV2aWNlLCBEcml2ZXI9dXNiaGlkLCAxMk0KICAgICAgICAgICAgfF9fIFBvcnQgMTog
RGV2IDUsIElmIDIsIENsYXNzPUh1bWFuIEludGVyZmFjZSBEZXZpY2UsIERyaXZlcj11c2JoaWQs
IDEyTQogICAgICAgICAgICB8X18gUG9ydCAyOiBEZXYgNiwgSWYgMCwgQ2xhc3M9SHVtYW4gSW50
ZXJmYWNlIERldmljZSwgRHJpdmVyPXVzYmhpZCwgMS41TQogICAgICAgICAgICB8X18gUG9ydCAy
OiBEZXYgNiwgSWYgMSwgQ2xhc3M9SHVtYW4gSW50ZXJmYWNlIERldmljZSwgRHJpdmVyPXVzYmhp
ZCwgMS41TQogICAgICAgICAgICB8X18gUG9ydCAzOiBEZXYgNywgSWYgMCwgQ2xhc3M9SHViLCBE
cml2ZXI9aHViLzRwLCA0ODBNCi86ICBCdXMgMDMuUG9ydCAxOiBEZXYgMSwgQ2xhc3M9cm9vdF9o
dWIsIERyaXZlcj1laGNpLXBjaS8ycCwgNDgwTQogICAgfF9fIFBvcnQgMTogRGV2IDIsIElmIDAs
IENsYXNzPUh1YiwgRHJpdmVyPWh1Yi82cCwgNDgwTQogICAgICAgIHxfXyBQb3J0IDE6IERldiAz
LCBJZiAwLCBDbGFzcz1WZW5kb3IgU3BlY2lmaWMgQ2xhc3MsIERyaXZlcj0sIDEyTQovOiAgQnVz
IDAyLlBvcnQgMTogRGV2IDEsIENsYXNzPXJvb3RfaHViLCBEcml2ZXI9eGhjaV9oY2QvMnAsIDUw
MDBNCi86ICBCdXMgMDEuUG9ydCAxOiBEZXYgMSwgQ2xhc3M9cm9vdF9odWIsIERyaXZlcj14aGNp
X2hjZC8ycCwgNDgwTQogICAgfF9fIFBvcnQgMTogRGV2IDIsIElmIDAsIENsYXNzPVByaW50ZXIs
IERyaXZlcj11c2JscCwgNDgwTQogICAgfF9fIFBvcnQgMjogRGV2IDMsIElmIDAsIENsYXNzPU1h
c3MgU3RvcmFnZSwgRHJpdmVyPXVzYi1zdG9yYWdlLCA0ODBNCgo=
--089e010d8b022776cc05290ef378--
