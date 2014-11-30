Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:34416 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaK3NnH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 08:43:07 -0500
Received: by mail-qc0-f178.google.com with SMTP id b13so7221515qcw.37
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 05:43:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH-HCWWk7J6N0M1z=2N__T0TQ1qffORnxdVNrpjGHh1gtQx3dg@mail.gmail.com>
References: <CAH-HCWWVR=g6mZFZyu6wYRfP7Harr5bxokJi+_qW8QHsniFPFg@mail.gmail.com>
 <20141130115908.GF32735@carfax.org.uk> <CAH-HCWWk7J6N0M1z=2N__T0TQ1qffORnxdVNrpjGHh1gtQx3dg@mail.gmail.com>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sun, 30 Nov 2014 19:12:46 +0530
Message-ID: <CAH-HCWW+dWbiGMNJuOExdy_NudQjPvZ4APp56++zK_k-4VSkaQ@mail.gmail.com>
Subject: Re: root subvol id is 0 or 5?
To: Hugo Mills <hugo@carfax.org.uk>, Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a1139126c82f568050913aceb
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--001a1139126c82f568050913aceb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 30, 2014 at 7:08 PM, Shriramana Sharma <samjnaa@gmail.com> wrot=
e:
>
> So why 5 and not just 0 which seems a logical choice? On top of this,
> one needs to alias 0 to 5!

Attached patch clarifying this in the documentation. (Should have done
this with the previous mail. Sorry for multiple mails.)

--=20
Shriramana Sharma =E0=AE=B6=E0=AF=8D=E0=AE=B0=E0=AF=80=E0=AE=B0=E0=AE=AE=E0=
=AE=A3=E0=AE=B6=E0=AE=B0=E0=AF=8D=E0=AE=AE=E0=AE=BE =E0=A4=B6=E0=A5=8D=E0=
=A4=B0=E0=A5=80=E0=A4=B0=E0=A4=AE=E0=A4=A3=E0=A4=B6=E0=A4=B0=E0=A5=8D=E0=A4=
=AE=E0=A4=BE

--001a1139126c82f568050913aceb
Content-Type: text/x-patch; charset=US-ASCII;
	name="0002-btrfs-subvolume-doc-clarifications.patch"
Content-Disposition: attachment;
	filename="0002-btrfs-subvolume-doc-clarifications.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i34gjmzl0

RnJvbSA1NDM4N2ZmMjE1NTQyM2Q5OTBiNWE5YWNhOTUzMTVmZTZlNjQ5MzAzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHJpcmFtYW5hIFNoYXJtYSA8c2Ftam5hYUBnbWFpbC5jb20+
CkRhdGU6IFN1biwgMzAgTm92IDIwMTQgMTk6MTE6MzkgKzA1MzAKU3ViamVjdDogW1BBVENIIDIv
Ml0gYnRyZnMgc3Vidm9sdW1lIGRvYyBjbGFyaWZpY2F0aW9ucwoKLS0tCiBEb2N1bWVudGF0aW9u
L2J0cmZzLXN1YnZvbHVtZS50eHQgfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9idHJmcy1z
dWJ2b2x1bWUudHh0IGIvRG9jdW1lbnRhdGlvbi9idHJmcy1zdWJ2b2x1bWUudHh0CmluZGV4IDEz
NjBhYmEuLjM0YWJkZWYgMTAwNjQ0Ci0tLSBhL0RvY3VtZW50YXRpb24vYnRyZnMtc3Vidm9sdW1l
LnR4dAorKysgYi9Eb2N1bWVudGF0aW9uL2J0cmZzLXN1YnZvbHVtZS50eHQKQEAgLTMxLDcgKzMx
LDcgQEAgV2hlbiBgbW91bnRgKDgpIHVzaW5nICdzdWJ2b2wnIG9yICdzdWJ2b2xpZCcgbW91bnQg
b3B0aW9uLCBvbmUgY2FuIGFjY2VzcwogZmlsZXMvZGlyZWN0b3JpZXMvc3Vidm9sdW1lcyBpbnNp
ZGUgaXQsIGJ1dCBub3RoaW5nIGluIHBhcmVudCBzdWJ2b2x1bWVzLgogCiBBbHNvIGV2ZXJ5IGJ0
cmZzIGZpbGVzeXN0ZW0gaGFzIGEgZGVmYXVsdCBzdWJ2b2x1bWUgYXMgaXRzIGluaXRpYWxseSB0
b3AtbGV2ZWwKLXN1YnZvbHVtZSwgd2hvc2Ugc3Vidm9sdW1lIGlkIGlzIDUoRlNfVFJFRSkuCitz
dWJ2b2x1bWUsIHdob3NlIHN1YnZvbHVtZSBpZCBpcyA1LiAoMCBpcyBhbHNvIGFjY2VwdGFibGUg
YXMgYW4gYWxpYXMuKQogCiBBIGJ0cmZzIHNuYXBzaG90IGlzIG11Y2ggbGlrZSBhIHN1YnZvbHVt
ZSwgYnV0IHNoYXJlcyBpdHMgZGF0YShhbmQgbWV0YWRhdGEpCiB3aXRoIG90aGVyIHN1YnZvbHVt
ZS9zbmFwc2hvdC4gRHVlIHRvIHRoZSBjYXBhYmlsaXRpZXMgb2YgQ09XLCBtb2RpZmljYXRpb25z
CkBAIC0xNjYsNyArMTY2LDcgQEAgc2xlZXAgTiBzZWNvbmRzIGJldHdlZW4gY2hlY2tzIChkZWZh
dWx0OiAxKQogCiBFWElUIFNUQVRVUwogLS0tLS0tLS0tLS0KLSpidHJmcyBzdWJ2b2x1bWUqIHJl
dHVybnMgYSB6ZXJvIGV4aXQgc3RhdHVzIGlmIGl0IHN1Y2NlZWRzLiBOb24gemVybyBpcworKmJ0
cmZzIHN1YnZvbHVtZSogcmV0dXJucyBhIHplcm8gZXhpdCBzdGF0dXMgaWYgaXQgc3VjY2VlZHMu
IEEgbm9uLXplcm8gdmFsdWUgaXMKIHJldHVybmVkIGluIGNhc2Ugb2YgZmFpbHVyZS4KIAogQVZB
SUxBQklMSVRZCi0tIAoyLjEuMwoK
--001a1139126c82f568050913aceb--
