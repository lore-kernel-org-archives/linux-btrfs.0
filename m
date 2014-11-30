Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:48050 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaK3Nhy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 08:37:54 -0500
Received: by mail-qc0-f177.google.com with SMTP id x3so6438691qcv.22
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 05:37:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH-HCWV9dBN4Z0B2p_hRAOdwTgAHr7bOcPLjZ7oRKBp9780emQ@mail.gmail.com>
References: <CAH-HCWXVn3pyejxzy7_sQmGPwARf6hLxYdHPWBrhd5bkZvExpQ@mail.gmail.com>
 <CAH-HCWV9dBN4Z0B2p_hRAOdwTgAHr7bOcPLjZ7oRKBp9780emQ@mail.gmail.com>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sun, 30 Nov 2014 19:07:33 +0530
Message-ID: <CAH-HCWW+B3azXoTPR2__cC+J8PrES4q295Cdc9Mqm2MeVE_y3w@mail.gmail.com>
Subject: Re: Change "total" in btrfs filesystem df output to "alloc"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11396e52d307750509139902
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--001a11396e52d307750509139902
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Attached patch.

On Sun, Nov 30, 2014 at 9:30 AM, Shriramana Sharma <samjnaa@gmail.com> wrot=
e:
> On Sun, Aug 31, 2014 at 7:25 AM, Shriramana Sharma <samjnaa@gmail.com> wr=
ote:
>> Hello. There seem to be lots of questions in various forums re the
>> output of btrfs fi df -- especially w.r.t. the usage of the word
>> "total". For example see https://community.oracle.com/thread/2459838
>>
>> I feel it would make the intent clearer if "total" were changed to
>> "alloc" or "allocated" (if the short form is felt unclear). It would
>> also help people understand the output of regular df on a btrfs system
>> since one can understand easier that pre-allocated space would count
>> as "used" space as it is not free!
>
> Where should I report a bug to get this fixed? Thanks.
>
> --
> Shriramana Sharma =E0=AE=B6=E0=AF=8D=E0=AE=B0=E0=AF=80=E0=AE=B0=E0=AE=AE=
=E0=AE=A3=E0=AE=B6=E0=AE=B0=E0=AF=8D=E0=AE=AE=E0=AE=BE =E0=A4=B6=E0=A5=8D=
=E0=A4=B0=E0=A5=80=E0=A4=B0=E0=A4=AE=E0=A4=A3=E0=A4=B6=E0=A4=B0=E0=A5=8D=E0=
=A4=AE=E0=A4=BE



--=20
Shriramana Sharma =E0=AE=B6=E0=AF=8D=E0=AE=B0=E0=AF=80=E0=AE=B0=E0=AE=AE=E0=
=AE=A3=E0=AE=B6=E0=AE=B0=E0=AF=8D=E0=AE=AE=E0=AE=BE =E0=A4=B6=E0=A5=8D=E0=
=A4=B0=E0=A5=80=E0=A4=B0=E0=A4=AE=E0=A4=A3=E0=A4=B6=E0=A4=B0=E0=A5=8D=E0=A4=
=AE=E0=A4=BE

--001a11396e52d307750509139902
Content-Type: text/x-patch; charset=US-ASCII; name="0001-df-change-total-to-alloc.patch"
Content-Disposition: attachment;
	filename="0001-df-change-total-to-alloc.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i34g98ic0

RnJvbSAzZDM4NjA1MzEwNWVmN2MyZGJhMzY0MzUzMGRmZmUzZWNkNGRjZjQ5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHJpcmFtYW5hIFNoYXJtYSA8c2Ftam5hYUBnbWFpbC5jb20+
CkRhdGU6IFN1biwgMzAgTm92IDIwMTQgMTk6MDA6MzggKzA1MzAKU3ViamVjdDogW1BBVENIXSBk
ZjogY2hhbmdlICJ0b3RhbCIgdG8gImFsbG9jIgoKLS0tCiBjbWRzLWZpbGVzeXN0ZW0uYyB8IDIg
Ky0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAt
LWdpdCBhL2NtZHMtZmlsZXN5c3RlbS5jIGIvY21kcy1maWxlc3lzdGVtLmMKaW5kZXggY2Q2YjNj
Ni4uMDVmNjIzNSAxMDA2NDQKLS0tIGEvY21kcy1maWxlc3lzdGVtLmMKKysrIGIvY21kcy1maWxl
c3lzdGVtLmMKQEAgLTIzMyw3ICsyMzMsNyBAQCBzdGF0aWMgdm9pZCBwcmludF9kZihzdHJ1Y3Qg
YnRyZnNfaW9jdGxfc3BhY2VfYXJncyAqc2FyZ3MsIHVuc2lnbmVkIHVuaXRfbW9kZSkKIAlzdHJ1
Y3QgYnRyZnNfaW9jdGxfc3BhY2VfaW5mbyAqc3AgPSBzYXJncy0+c3BhY2VzOwogCiAJZm9yIChp
ID0gMDsgaSA8IHNhcmdzLT50b3RhbF9zcGFjZXM7IGkrKywgc3ArKykgewotCQlwcmludGYoIiVz
LCAlczogdG90YWw9JXMsIHVzZWQ9JXNcbiIsCisJCXByaW50ZigiJXMsICVzOiBhbGxvYz0lcywg
dXNlZD0lc1xuIiwKIAkJCWdyb3VwX3R5cGVfc3RyKHNwLT5mbGFncyksCiAJCQlncm91cF9wcm9m
aWxlX3N0cihzcC0+ZmxhZ3MpLAogCQkJcHJldHR5X3NpemVfbW9kZShzcC0+dG90YWxfYnl0ZXMs
IHVuaXRfbW9kZSksCi0tIAoyLjEuMwoK
--001a11396e52d307750509139902--
