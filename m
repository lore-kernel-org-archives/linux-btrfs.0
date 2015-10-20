Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34992 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbbJTNa1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 09:30:27 -0400
Received: by lbbes7 with SMTP id es7so15259652lbb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 06:30:26 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 20 Oct 2015 16:29:46 +0300
Message-ID: <CAGqmi76ZKv3ezguTyxGL_Jv_xtq5w_SGPvjwTy90Z=oNY73Vmw@mail.gmail.com>
Subject: [RFC PATCH] btrfs/ioctl.c: Prefer inode with lowest offset as source
 for clone
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c237f0c0cfa105228943f6
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--001a11c237f0c0cfa105228943f6
Content-Type: text/plain; charset=UTF-8

For performance reason, leave data at the start of disk, is preferable
while deduping
It's might sense for the reasons:
1. Spinning rust - start of the disk is much faster
2. Btrfs can deallocate empty data chunk from the end of fs - ie it's compact fs

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/ioctl.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3e3e613..3eb77c0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3074,8 +3074,13 @@ static int btrfs_extent_same(struct inode *src,
u64 loff, u64 olen,

  /* pass original length for comparison so we stay within i_size */
  ret = btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
- if (ret == 0)
-     ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
+ if (ret == 0) {
+     /* prefer inode with lowest offset as source for clone*/
+     if (loff > dest_loff)
+         ret = btrfs_clone(dst, src, dst_loff, olen, len, loff, 1);
+     else
+         ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
+ }

  if (same_inode)
  unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
-- 
2.6.1

--001a11c237f0c0cfa105228943f6
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-btrfs-ioctl.c-Prefer-inode-with-lowest-offset-as-sou.patch"
Content-Disposition: attachment;
	filename="0001-btrfs-ioctl.c-Prefer-inode-with-lowest-offset-as-sou.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ifzelbvy0

RnJvbSA1ZWQzODIyYmMzMDhjNzI2ZDkxYTgzN2ZiZDk3ZWJhY2FhNTFlNThkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBUaW1vZmV5IFRpdG92ZXRzIDxuZWZlbGltNGFnQGdtYWlsLmNv
bT4KRGF0ZTogVHVlLCAyMCBPY3QgMjAxNSAxNTo1MzoyMCArMDMwMApTdWJqZWN0OiBbUkZDIFBB
VENIXSBidHJmcy9pb2N0bC5jOiBQcmVmZXIgaW5vZGUgd2l0aCBsb3dlc3Qgb2Zmc2V0IGFzIHNv
dXJjZSBmb3IKIGNsb25lCgpGb3IgcGVyZm9ybWFuY2UgcmVhc29uLCBsZWF2ZSBkYXRhIGF0IHRo
ZSBzdGFydCBvZiBkaXNrLCBpcyBwcmVmZXJhYmxlCgpTaWduZWQtb2ZmLWJ5OiBUaW1vZmV5IFRp
dG92ZXRzIDxuZWZlbGltNGFnQGdtYWlsLmNvbT4KLS0tCiBmcy9idHJmcy9pb2N0bC5jIHwgOSAr
KysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvZnMvYnRyZnMvaW9jdGwuYyBiL2ZzL2J0cmZzL2lvY3RsLmMKaW5kZXgg
M2UzZTYxMy4uM2ViNzdjMCAxMDA2NDQKLS0tIGEvZnMvYnRyZnMvaW9jdGwuYworKysgYi9mcy9i
dHJmcy9pb2N0bC5jCkBAIC0zMDc0LDggKzMwNzQsMTMgQEAgc3RhdGljIGludCBidHJmc19leHRl
bnRfc2FtZShzdHJ1Y3QgaW5vZGUgKnNyYywgdTY0IGxvZmYsIHU2NCBvbGVuLAogCiAJLyogcGFz
cyBvcmlnaW5hbCBsZW5ndGggZm9yIGNvbXBhcmlzb24gc28gd2Ugc3RheSB3aXRoaW4gaV9zaXpl
ICovCiAJcmV0ID0gYnRyZnNfY21wX2RhdGEoc3JjLCBsb2ZmLCBkc3QsIGRzdF9sb2ZmLCBvbGVu
LCAmY21wKTsKLQlpZiAocmV0ID09IDApCi0JCXJldCA9IGJ0cmZzX2Nsb25lKHNyYywgZHN0LCBs
b2ZmLCBvbGVuLCBsZW4sIGRzdF9sb2ZmLCAxKTsKKwlpZiAocmV0ID09IDApIHsKKwkJLyogcHJl
ZmVyIGlub2RlIHdpdGggbG93ZXN0IG9mZnNldCBhcyBzb3VyY2UgZm9yIGNsb25lKi8KKwkJaWYg
KGxvZmYgPiBkZXN0X2xvZmYpCisJCQlyZXQgPSBidHJmc19jbG9uZShkc3QsIHNyYywgZHN0X2xv
ZmYsIG9sZW4sIGxlbiwgbG9mZiwgMSk7CisJCWVsc2UKKwkJCXJldCA9IGJ0cmZzX2Nsb25lKHNy
YywgZHN0LCBsb2ZmLCBvbGVuLCBsZW4sIGRzdF9sb2ZmLCAxKTsKKwl9CiAKIAlpZiAoc2FtZV9p
bm9kZSkKIAkJdW5sb2NrX2V4dGVudCgmQlRSRlNfSShzcmMpLT5pb190cmVlLCBzYW1lX2xvY2tf
c3RhcnQsCi0tIAoyLjYuMQoK
--001a11c237f0c0cfa105228943f6--
