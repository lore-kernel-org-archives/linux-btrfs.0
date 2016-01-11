Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37595 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759679AbcAKQCh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 11:02:37 -0500
Received: by mail-wm0-f43.google.com with SMTP id f206so276092913wmf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 08:02:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5693B7C0.8010903@gmail.com>
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
 <5693B7C0.8010903@gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Mon, 11 Jan 2016 17:02:15 +0100
Message-ID: <CA+9GZUizsH3ToTMf_7mfN1Xgv=5obrCxCRHY+APS4SSGKoWHVA@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e010d8b02c0b5e8052911103d
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--089e010d8b02c0b5e8052911103d
Content-Type: text/plain; charset=UTF-8

I triggered the bug again, attaching log. There were some usb resets,
but they happened 23 minutes before the fs crashed.

At mount, the output of btrfs fi df -g was like this:
Data, single: total=2080.01GiB, used=2078.80GiB
System, DUP: total=0.01GiB, used=0.00GiB
System, single: total=0.00GiB, used=0.00GiB
Metadata, DUP: total=5.50GiB, used=3.73GiB
Metadata, single: total=0.01GiB, used=0.00GiB
GlobalReserve, single: total=0.50GiB, used=0.00GiB

Now it is:
Data, single: total=2094.01GiB, used=2092.26GiB
System, DUP: total=0.01GiB, used=0.00GiB
System, single: total=0.00GiB, used=0.00GiB
Metadata, DUP: total=5.50GiB, used=3.79GiB
Metadata, single: total=0.01GiB, used=0.00GiB
GlobalReserve, single: total=0.50GiB, used=0.00GiB

The file being copied at the time was 954 MB.



On Mon, Jan 11, 2016 at 3:10 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-01-11 08:11, cheater00 . wrote:
>>
>> On Mon, Jan 11, 2016 at 2:05 PM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>>
>>> On 2016-01-09 16:07, cheater00 . wrote:
>>>>
>>>>
>>>> Would like to point out that this can cause data loss. If I'm writing
>>>> to disk and the disk becomes unexpectedly read only - that data will
>>>> be lost, because who in their right mind makes their code expect this
>>>> and builds a contingency (e.g. caching, backpressure, etc)...
>>>
>>>
>>> If a data critical application (mail server, database server, anything
>>> similar) can't gracefully handle ENOSPC, then that application is broken,
>>> not the FS.  As an example, set up a small VM with an SMTP server, then
>>> force the FS the server uses for queuing mail read-only, and see if you
>>> can
>>> submit mail, then go read the RFCs for SMTP and see what clients are
>>> supposed to do when they can't submit mail.  A properly designed piece of
>>> software is supposed to be resilient against common failure modes of the
>>> resources it depends on (which includes ENOSPC and read-only filesystems
>>> for
>>> anything that works with data on disk).
>>>>
>>>>
>>>>
>>>> There's no loss of data on the disk because the data doesn't make it
>>>> to disk in the first place. But it's exactly the same as if the data
>>>> had been written to disk, and then lost.
>>>>
>>> No, it isn't.  If you absolutely need the data on disk, you should be
>>> calling fsync or fdatasync, and then assuming if those return an error
>>> that
>>> none of the data written since the last call has gotten to the disk (some
>>> of
>>> it might have, but you need to assume it hasn't).  Every piece of
>>> software
>>> in wide usage that requires data to be on the disk does this, because
>>> otherwise it can't guarantee that the data is on disk.
>>
>>
>> I agree that a lot of stuff goes right in a perfect world. But most of
>> the time what you're running isn't a mail server used by billions of
>> users, but instead a bash script someone wrote once that's supposed to
>> do something, and no one knows how it works.
>>
> And that's why no sane person does stuff like that on enterprise level
> systems.  And even then, if the person writing the bash script actually
> knows what they're doing, they will be using the 'sync' command to ensure
> data integrity when they actually need it, or they will write their script
> in such a way that it gracefully handles a partial run.

--089e010d8b02c0b5e8052911103d
Content-Type: text/plain; charset=US-ASCII; name="bug yet again.txt"
Content-Disposition: attachment; filename="bug yet again.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ija5qfnc0

WzI0MTc3MC4xMTU4OTddIEJUUkZTIGluZm8gKGRldmljZSBzZGMxKTogZGlzayBzcGFjZSBjYWNo
aW5nIGlzIGVuYWJsZWQKWzI0Mjc3My43NzczNjVdIHVzYiA0LTEuMTogcmVzZXQgaGlnaC1zcGVl
ZCBVU0IgZGV2aWNlIG51bWJlciAzIHVzaW5nIGVoY2ktcGNpClsyNDgwNjQuNzIyMTgxXSB1c2Ig
NC0xLjE6IHJlc2V0IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMyB1c2luZyBlaGNpLXBj
aQpbMjQ5NDU3LjM2OTE2Nl0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsy
NDk0NTcuMzY5MjE1XSBXQVJOSU5HOiBDUFU6IDQgUElEOiA3MzU4IGF0IC9ob21lL2tlcm5lbC9D
T0QvbGludXgvZnMvYnRyZnMvZXh0ZW50LXRyZWUuYzo2MzYwIF9fYnRyZnNfZnJlZV9leHRlbnQr
MHgzNTQvMHhlNzAgW2J0cmZzXSgpClsyNDk0NTcuMzY5MjIwXSBCVFJGUzogVHJhbnNhY3Rpb24g
YWJvcnRlZCAoZXJyb3IgLTI4KQpbMjQ5NDU3LjM2OTIyNF0gTW9kdWxlcyBsaW5rZWQgaW46IHVm
cyBxbng0IGhmc3BsdXMgaGZzIG1pbml4IG50ZnMgbXNkb3MgamZzIHhmcyBsaWJjcmMzMmMgbmxz
X3V0ZjggaXNvZnMgcGNpX3N0dWIgdmJveHBjaShPRSkgdmJveG5ldGFkcChPRSkgdmJveG5ldGZs
dChPRSkgdmJveGRydihPRSkgY3VzZSBpcHRfTUFTUVVFUkFERSBuZl9uYXRfbWFzcXVlcmFkZV9p
cHY0IGlwdGFibGVfbmF0IG5mX25hdF9pcHY0IG5mX25hdCBuZl9jb25udHJhY2tfaXB2NCBuZl9k
ZWZyYWdfaXB2NCB4dF9jb25udHJhY2sgbmZfY29ubnRyYWNrIGlwdF9SRUpFQ1QgbmZfcmVqZWN0
X2lwdjQgeHRfQ0hFQ0tTVU0gaXB0YWJsZV9tYW5nbGUgeHRfdGNwdWRwIGJyaWRnZSBzdHAgbGxj
IGlwNnRhYmxlX2ZpbHRlciBpcDZfdGFibGVzIGlwdGFibGVfZmlsdGVyIGlwX3RhYmxlcyBlYnRh
YmxlX25hdCBlYnRhYmxlcyB4X3RhYmxlcyB1c2JscCBzbmRfaGRhX2NvZGVjX2hkbWkgaHBfd21p
IHNwYXJzZV9rZXltYXAgc25kX2hkYV9jb2RlY19pZHQgc25kX2hkYV9jb2RlY19nZW5lcmljIGlu
dGVsX3JhcGwgaW9zZl9tYmkgeDg2X3BrZ190ZW1wX3RoZXJtYWwgaW50ZWxfcG93ZXJjbGFtcCBk
bV9tdWx0aXBhdGggc25kX2hkYV9pbnRlbCBzbmRfaGRhX2NvZGVjIGNvcmV0ZW1wIHNuZF9oZGFf
Y29yZSBrdm1faW50ZWwgcmFkZW9uIHNuZF9od2RlcCBoaWRfbG9naXRlY2hfaGlkcHAga3ZtIHNu
ZF9wY20gaTkxNSBzbmRfc2VxX21pZGkgY3JjMzJfcGNsbXVsIHNuZF9zZXFfbWlkaV9ldmVudCBz
bmRfcmF3bWlkaSBhZXNuaV9pbnRlbCBhZXNfaTU4NiB0dG0geHRzIHNuZF9zZXEgbHJ3IGRybV9r
bXNfaGVscGVyIHNuZF9zZXFfZGV2aWNlIGdmMTI4bXVsIHNuZF90aW1lciBhYmxrX2hlbHBlciBk
cm0gam95ZGV2IGNyeXB0ZCBibmVwIHJmY29tbSBzbmQgaW5wdXRfbGVkcyBpMmNfYWxnb19iaXQg
ZmJfc3lzX2ZvcHMgcnRzeF9wY2lfbXMgYmx1ZXRvb3RoIHNlcmlvX3JhdyBzb3VuZGNvcmUgc3lz
Y29weWFyZWEgbWVtc3RpY2sgc3lzZmlsbHJlY3Qgc3lzaW1nYmx0IGhwX2FjY2VsIG1laV9tZSBs
aXMzbHYwMmQgbHBjX2ljaCB3bWkgc2hwY2hwIGlucHV0X3BvbGxkZXYgbWVpIHZpZGVvIG1hY19o
aWQgbmZzZCBhdXRoX3JwY2dzcyBuZnNfYWNsIHBhcnBvcnRfcGMgbmZzIHBwZGV2IGxvY2tkIGxw
IGdyYWNlIHN1bnJwYyBwYXJwb3J0IGZzY2FjaGUgYmluZm10X21pc2MgaGlkX2dlbmVyaWMgaGlk
X2xvZ2l0ZWNoX2RqIHVzYmhpZCBoaWQgYnRyZnMgeG9yIHVhcyB1c2Jfc3RvcmFnZSByYWlkNl9w
cSBydHN4X3BjaV9zZG1tYyBhaGNpIHI4MTY5IHNkaGNpX3BjaSBwc21vdXNlIGxpYmFoY2kgc2Ro
Y2kgcnRzeF9wY2kgbWlpIGZqZXMKWzI0OTQ1Ny4zNjk0NTVdIENQVTogNCBQSUQ6IDczNTggQ29t
bTogYnRyZnMtdHJhbnNhY3RpIFRhaW50ZWQ6IEcgICAgICAgIFcgIE9FICAgNC4zLjAtMDQwMzAw
cmM3LWdlbmVyaWMgIzIwMTUxMDI2MDcxMgpbMjQ5NDU3LjM2OTQ2MF0gSGFyZHdhcmUgbmFtZTog
SGV3bGV0dC1QYWNrYXJkIEhQIFBhdmlsaW9uIGR2NiBOb3RlYm9vayBQQy8xN0ZBLCBCSU9TIEYu
MDIgMTAvMDMvMjAxMQpbMjQ5NDU3LjM2OTQ2NF0gIDAwMDAwMDAwIDAwMDAwMDAwIGQ2ZDFiYzQw
IGMxMzYxMGU4IGQ2ZDFiYzgwIGQ2ZDFiYzcwIGMxMDY4MTA3IGY4YWU0MTkwClsyNDk0NTcuMzY5
NDkwXSAgZDZkMWJjOWMgMDAwMDFjYmUgZjhhZTNmZjAgMDAwMDE4ZDggZjhhM2Q4ZDQgZjhhM2Q4
ZDQgZWE0MmYyYTAgZmZmZmZmZTQKWzI0OTQ1Ny4zNjk1MDNdICAwMDAwMDAwMCBkNmQxYmM4OCBj
MTA2ODE3MyAwMDAwMDAwOSBkNmQxYmM4MCBmOGFlNDE5MCBkNmQxYmM5YyBkNmQxYmQ0YwpbMjQ5
NDU3LjM2OTUxNl0gQ2FsbCBUcmFjZToKWzI0OTQ1Ny4zNjk1MzBdICBbPGMxMzYxMGU4Pl0gZHVt
cF9zdGFjaysweDQxLzB4NTkKWzI0OTQ1Ny4zNjk1NDJdICBbPGMxMDY4MTA3Pl0gd2Fybl9zbG93
cGF0aF9jb21tb24rMHg4Ny8weGMwClsyNDk0NTcuMzY5NTc0XSAgWzxmOGEzZDhkND5dID8gX19i
dHJmc19mcmVlX2V4dGVudCsweDM1NC8weGU3MCBbYnRyZnNdClsyNDk0NTcuMzY5NjEwXSAgWzxm
OGEzZDhkND5dID8gX19idHJmc19mcmVlX2V4dGVudCsweDM1NC8weGU3MCBbYnRyZnNdClsyNDk0
NTcuMzY5NjIwXSAgWzxjMTA2ODE3Mz5dIHdhcm5fc2xvd3BhdGhfZm10KzB4MzMvMHg0MApbMjQ5
NDU3LjM2OTY1NV0gIFs8ZjhhM2Q4ZDQ+XSBfX2J0cmZzX2ZyZWVfZXh0ZW50KzB4MzU0LzB4ZTcw
IFtidHJmc10KWzI0OTQ1Ny4zNjk2NjZdICBbPGMxMGQ2MDAxPl0gPyBrdGltZV9nZXQrMHg0MS8w
eDEyMApbMjQ5NDU3LjM2OTcxNV0gIFs8ZjhhYWQyNmI+XSA/IGJ0cmZzX2RlbGF5ZWRfcmVmX2xv
Y2srMHgyYi8weDIwMCBbYnRyZnNdClsyNDk0NTcuMzY5NzQ5XSAgWzxmOGE0MjM3MD5dIF9fYnRy
ZnNfcnVuX2RlbGF5ZWRfcmVmcysweDk3MC8weDExMTAgW2J0cmZzXQpbMjQ5NDU3LjM2OTc2M10g
IFs8YzExNjc0YTE+XSA/IHNldF9wYWdlX2RpcnR5KzB4MzEvMHg3MApbMjQ5NDU3LjM2OTgxNF0g
IFs8ZjhhODM3Y2M+XSA/IHNldF9leHRlbnRfYnVmZmVyX2RpcnR5KzB4N2MvMHhkMCBbYnRyZnNd
ClsyNDk0NTcuMzY5ODQ3XSAgWzxmOGE0NThiZD5dIGJ0cmZzX3J1bl9kZWxheWVkX3JlZnMrMHg2
ZC8weDI1MCBbYnRyZnNdClsyNDk0NTcuMzY5ODc5XSAgWzxmOGE0NjdmMD5dIGJ0cmZzX3dyaXRl
X2RpcnR5X2Jsb2NrX2dyb3VwcysweDE3MC8weDJhMCBbYnRyZnNdClsyNDk0NTcuMzY5OTI2XSAg
WzxmOGFkYjNjOD5dIGNvbW1pdF9jb3dvbmx5X3Jvb3RzKzB4MWU5LzB4MjZhIFtidHJmc10KWzI0
OTQ1Ny4zNjk5NzRdICBbPGY4YTViNmJhPl0gYnRyZnNfY29tbWl0X3RyYW5zYWN0aW9uKzB4ODdh
LzB4ZTkwIFtidHJmc10KWzI0OTQ1Ny4zNzAwMTJdICBbPGY4YTViZDRkPl0gPyBzdGFydF90cmFu
c2FjdGlvbisweDdkLzB4NWIwIFtidHJmc10KWzI0OTQ1Ny4zNzAwMjZdICBbPGMxMGE1MDYwPl0g
PyB3YWtlX2F0b21pY190X2Z1bmN0aW9uKzB4NzAvMHg3MApbMjQ5NDU3LjM3MDA2Nl0gIFs8Zjhh
NTY4NjU+XSB0cmFuc2FjdGlvbl9rdGhyZWFkKzB4MjE1LzB4MjMwIFtidHJmc10KWzI0OTQ1Ny4z
NzAxMDFdICBbPGY4YTU2NjUwPl0gPyBidHJmc19jbGVhbnVwX3RyYW5zYWN0aW9uKzB4NDkwLzB4
NDkwIFtidHJmc10KWzI0OTQ1Ny4zNzAxMTNdICBbPGMxMDgzYzNiPl0ga3RocmVhZCsweDliLzB4
YjAKWzI0OTQ1Ny4zNzAxMjVdICBbPGMxNzQzNTgxPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsw
eDIxLzB4MzAKWzI0OTQ1Ny4zNzAxMzZdICBbPGMxMDgzYmEwPl0gPyBrdGhyZWFkX2NyZWF0ZV9v
bl9ub2RlKzB4MTEwLzB4MTEwClsyNDk0NTcuMzcwMTQ0XSAtLS1bIGVuZCB0cmFjZSBkYzNjZjY4
MTQ1MjZjN2NiIF0tLS0KWzI0OTQ1Ny4zNzAyMDNdIEJUUkZTOiBlcnJvciAoZGV2aWNlIHNkYzEp
IGluIF9fYnRyZnNfZnJlZV9leHRlbnQ6NjM2MDogZXJybm89LTI4IE5vIHNwYWNlIGxlZnQKWzI0
OTQ1Ny4zNzAyMTFdIEJUUkZTIGluZm8gKGRldmljZSBzZGMxKTogZm9yY2VkIHJlYWRvbmx5Clsy
NDk0NTcuMzcwMjIwXSBCVFJGUzogZXJyb3IgKGRldmljZSBzZGMxKSBpbiBidHJmc19ydW5fZGVs
YXllZF9yZWZzOjI4NTE6IGVycm5vPS0yOCBObyBzcGFjZSBsZWZ0ClsyNDk0NTcuNDE5OTc4XSBC
VFJGUyB3YXJuaW5nIChkZXZpY2Ugc2RjMSk6IFNraXBwaW5nIGNvbW1pdCBvZiBhYm9ydGVkIHRy
YW5zYWN0aW9uLgpbMjQ5NDU3LjQxOTk4NF0gQlRSRlM6IGVycm9yIChkZXZpY2Ugc2RjMSkgaW4g
Y2xlYW51cF90cmFuc2FjdGlvbjoxNzQxOiBlcnJubz0tMjggTm8gc3BhY2UgbGVmdAoK
--089e010d8b02c0b5e8052911103d--
