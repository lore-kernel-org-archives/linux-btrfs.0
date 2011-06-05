From: Joe Peterson <lavajoe@gentoo.org>
Subject: Fix to btrfs-progs to avoid "underlinking"
Date: Sun, 5 Jun 2011 10:41:15 -0600
Message-ID: <BANLkTikPLUU=3bG0-S9X9a5oDQsKCD9E5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016365edf76c1ed5104a4f9a70b
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--0016365edf76c1ed5104a4f9a70b
Content-Type: text/plain; charset=ISO-8859-1

Attached is a simple patch to the makefile line that builds "convert".
 It explicitly includes libcom_err, which is implicitly pulled in by
libext2fs.  This fixes a what is called "underlinking" in this blog
post:

    http://blog.flameeyes.eu/2010/11/26/it-s-not-all-gold-that-shines-why-underlinking-is-a-bad-thing

Apparently, this condition causes links to fail using the "gold link
editor", and it can cause future library version incompatibilities to
not be detected (so that affected programs can be rebuilt).

-Joe

[Note: please CC my email address in any responses]

--0016365edf76c1ed5104a4f9a70b
Content-Type: text/x-patch; charset=US-ASCII;
	name="btrfs-progs-0.19-fix-underlinking.patch"
Content-Disposition: attachment;
	filename="btrfs-progs-0.19-fix-underlinking.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gok7x9le0

LS0tIGJ0cmZzLXByb2dzLTAuMTkvTWFrZWZpbGV+CTIwMTEtMDYtMDUgMTA6MjE6MDQuMDAwMDAw
MDAwIC0wNjAwCisrKyBidHJmcy1wcm9ncy0wLjE5L01ha2VmaWxlCTIwMTEtMDYtMDUgMTA6MjE6
NDYuMDAwMDAwMDAwIC0wNjAwCkBAIC03NSw3ICs3NSw3IEBAIHF1aWNrLXRlc3Q6ICQob2JqZWN0
cykgcXVpY2stdGVzdC5vCiAJZ2NjICQoQ0ZMQUdTKSAtbyBxdWljay10ZXN0ICQob2JqZWN0cykg
cXVpY2stdGVzdC5vICQoTERGTEFHUykgJChMSUJTKQogCiBjb252ZXJ0OiAkKG9iamVjdHMpIGNv
bnZlcnQubwotCWdjYyAkKENGTEFHUykgLW8gYnRyZnMtY29udmVydCAkKG9iamVjdHMpIGNvbnZl
cnQubyAtbGV4dDJmcyAkKExERkxBR1MpICQoTElCUykKKwlnY2MgJChDRkxBR1MpIC1vIGJ0cmZz
LWNvbnZlcnQgJChvYmplY3RzKSBjb252ZXJ0Lm8gLWxleHQyZnMgLWxjb21fZXJyICQoTERGTEFH
UykgJChMSUJTKQogCiBpb2N0bC10ZXN0OiAkKG9iamVjdHMpIGlvY3RsLXRlc3QubwogCWdjYyAk
KENGTEFHUykgLW8gaW9jdGwtdGVzdCAkKG9iamVjdHMpIGlvY3RsLXRlc3QubyAkKExERkxBR1Mp
ICQoTElCUykK
--0016365edf76c1ed5104a4f9a70b--
