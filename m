Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36670 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbbDMLNH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 07:13:07 -0400
Received: by igblo3 with SMTP id lo3so42194479igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 04:13:07 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 Apr 2015 14:13:06 +0300
Message-ID: <CAJ1pDqSeVL8kVXsAfKvw=LCk5Q9Kbej7bcJ+BVC7jSrD8Etk7w@mail.gmail.com>
Subject: Btrfs receive hardening patches
From: lauri <lauri.vosandi@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7bea4294d06c1005139932bc
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--047d7bea4294d06c1005139932bc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

due to security reasons in certain usecases it would be nice to force
btrfs receive to confine itself to the directory of subvolume. I've
attached a patch that issues chroot before parsing btrfs stream. Let
me know if this breaks anything, preliminary tests showed it performed
as expected. If necessary I can make this functionality optional via
command-line flag.

--=20
Lauri V=F5sandi
tel: +372 53329412
e-mail: lauri.vosandi@gmail.com
blog: http://lauri.vosandi.com/

--047d7bea4294d06c1005139932bc
Content-Type: text/plain; charset=US-ASCII;
	name="preliminary-btrfs-receive-hardening-patches.diff"
Content-Disposition: attachment;
	filename="preliminary-btrfs-receive-hardening-patches.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i8fs4tdj0

ZGlmZiAtLWdpdCBhL2NtZHMtcmVjZWl2ZS5jIGIvY21kcy1yZWNlaXZlLmMKaW5kZXggNDRlZjI3
ZS4uZTAzYWNkZCAxMDA2NDQKLS0tIGEvY21kcy1yZWNlaXZlLmMKKysrIGIvY21kcy1yZWNlaXZl
LmMKQEAgLTg2NywxNSArODY3LDIwIEBAIHN0YXRpYyBpbnQgZG9fcmVjZWl2ZShzdHJ1Y3QgYnRy
ZnNfcmVjZWl2ZSAqciwgY29uc3QgY2hhciAqdG9tbnQsIGludCByX2ZkLAogCQlnb3RvIG91dDsK
IAl9CiAKLQkvKgotCSAqIGZpbmRfbW91bnRfcm9vdCByZXR1cm5zIGEgcm9vdF9wYXRoIHRoYXQg
aXMgYSBzdWJwYXRoIG9mCi0JICogZGVzdF9kaXJfZnVsbF9wYXRoLiBOb3cgZ2V0IHRoZSBvdGhl
ciBwYXJ0IG9mIHJvb3RfcGF0aCwKLQkgKiB3aGljaCBpcyB0aGUgZGVzdGluYXRpb24gZGlyIHJl
bGF0aXZlIHRvIHJvb3RfcGF0aC4KKworCS8qKgorCSAqIE5hc3R5IGhhY2sgdG8gZW5mb3JjZSBj
aHJvb3QgYmVmb3JlIHBhcnNpbmcgYnRyZnMgc3RyZWFtCiAJICovCi0Jci0+ZGVzdF9kaXJfcGF0
aCA9IGRlc3RfZGlyX2Z1bGxfcGF0aCArIHN0cmxlbihyLT5yb290X3BhdGgpOwotCXdoaWxlIChy
LT5kZXN0X2Rpcl9wYXRoWzBdID09ICcvJykKLQkJci0+ZGVzdF9kaXJfcGF0aCsrOworCWlmIChj
aHJvb3QoZGVzdF9kaXJfZnVsbF9wYXRoKSkgeworCQlmcHJpbnRmKHN0ZGVyciwKKwkJCSJFUlJP
UjogZmFpbGVkIHRvIGNocm9vdCB0byAlc1xuIiwKKwkJCWRlc3RfZGlyX2Z1bGxfcGF0aCk7CisJ
CXJldCA9IC1FSU5WQUw7CisJCWdvdG8gb3V0OworCX0KIAorCXItPnJvb3RfcGF0aCA9IHItPmRl
c3RfZGlyX3BhdGggPSBzdHJkdXAoIi8iKTsKKwkKIAlyZXQgPSBzdWJ2b2xfdXVpZF9zZWFyY2hf
aW5pdChyLT5tbnRfZmQsICZyLT5zdXMpOwogCWlmIChyZXQgPCAwKQogCQlnb3RvIG91dDsK
--047d7bea4294d06c1005139932bc--
