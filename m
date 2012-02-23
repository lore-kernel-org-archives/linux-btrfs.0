From: "Fajar A. Nugraha" <list@fajar.net>
Subject: PATCH: Fix incorrect "error checking ... mount status" in mkfs.btrfs
Date: Thu, 23 Feb 2012 13:50:56 +0700
Message-ID: <CAG1y0sdpBPyYuFRC4YLX8omF2m4nji3tSDaS68xwVtMgfiOf9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b162db7ead49904b99c1099
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--047d7b162db7ead49904b99c1099
Content-Type: text/plain; charset=ISO-8859-1

Originally reported on linux-btrfs list:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg08086.html

Fix suggested on:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg08386.html

loop_info.lo_name is limited to LO_NAME_SIZE (curerently 64) characters.
This can cause a problem if a file whose full path is longer than
LO_NAME_SIZE is currently mounted.

This patch changes resolve_loop_device() to:
* Check /sys/block/loopX/loop/backing_file first
* If that fails, fallback to original behaviour using loop_info.lo_name

Patch is both inline and attached (in case mail client mungles it).

Signed-off-by: Fajar A. Nugraha <github@fajar.net>
---
 utils.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/utils.c b/utils.c
index 178d1b9..a62eeee 100644
--- a/utils.c
+++ b/utils.c
@@ -649,6 +649,9 @@ int resolve_loop_device(const char* loop_dev,
char* loop_file, int max_len)
 {
 	int loop_fd;
 	int ret_ioctl;
+	int sysfs_fd;
+	char sysfs_path[PATH_MAX];
+	const char* sysfs_path_format = "/sys/block/loop%d/loop/backing_file";
 	struct loop_info loopinfo;

 	if ((loop_fd = open(loop_dev, O_RDONLY)) < 0)
@@ -658,7 +661,20 @@ int resolve_loop_device(const char* loop_dev,
char* loop_file, int max_len)
 	close(loop_fd);

 	if (ret_ioctl == 0)
-		strncpy(loop_file, loopinfo.lo_name, max_len);
+	{
+		snprintf(sysfs_path, PATH_MAX, sysfs_path_format, loopinfo.lo_number);
+		sysfs_fd = open(sysfs_path, O_RDONLY);
+		if (sysfs_fd < 0)
+		{
+			strncpy(loop_file, loopinfo.lo_name, max_len);
+		}
+		else
+		{
+			read(sysfs_fd, loop_file, max_len);
+			loop_file[strlen(loop_file)-1] = '\0';
+			close(sysfs_fd);
+		}
+	}
 	else
 		return -errno;

-- 
1.7.9

--047d7b162db7ead49904b99c1099
Content-Type: text/x-patch; charset=US-ASCII;
	name="mkfs.btrfs-fix-incorrect-mount-status.patch"
Content-Disposition: attachment;
	filename="mkfs.btrfs-fix-incorrect-mount-status.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gyzfjaaw0

RnJvbSBlMDA0MTY2ZDhmM2IzMGUwZDQ5OGRmOTk1YWM5ZGU4YjExY2NlNTlhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiAiRmFqYXIgQS4gTnVncmFoYSIgPGdpdGh1YkBmYWphci5uZXQ+
CkRhdGU6IFRodSwgMjMgRmViIDIwMTIgMTM6Mjg6MzMgKzA3MDAKU3ViamVjdDogW1BBVENIXSBG
aXggaW5jb3JyZWN0ICJlcnJvciBjaGVja2luZyAuLi4gbW91bnQgc3RhdHVzIiBpbgogbWtmcy5i
dHJmcwoKT3JpZ2luYWxseSByZXBvcnRlZCBvbiBsaW51eC1idHJmcyBsaXN0OgpodHRwOi8vd3d3
Lm1haWwtYXJjaGl2ZS5jb20vbGludXgtYnRyZnNAdmdlci5rZXJuZWwub3JnL21zZzA4MDg2Lmh0
bWwKCkZpeCBzdWdnZXN0ZWQgb246Cmh0dHA6Ly93d3cubWFpbC1hcmNoaXZlLmNvbS9saW51eC1i
dHJmc0B2Z2VyLmtlcm5lbC5vcmcvbXNnMDgzODYuaHRtbAoKbG9vcF9pbmZvLmxvX25hbWUgaXMg
bGltaXRlZCB0byBMT19OQU1FX1NJWkUgKGN1cmVyZW50bHkgNjQpIGNoYXJhY3RlcnMuClRoaXMg
Y2FuIGNhdXNlIGEgcHJvYmxlbSBpZiBhIGZpbGUgd2hvc2UgZnVsbCBwYXRoIGlzIGxvbmdlciB0
aGFuCkxPX05BTUVfU0laRSBpcyBjdXJyZW50bHkgbW91bnRlZC4KClRoaXMgcGF0Y2ggY2hhbmdl
cyByZXNvbHZlX2xvb3BfZGV2aWNlKCkgdG86CiogQ2hlY2sgL3N5cy9ibG9jay9sb29wWC9sb29w
L2JhY2tpbmdfZmlsZSBmaXJzdAoqIElmIHRoYXQgZmFpbHMsIGZhbGxiYWNrIHRvIG9yaWdpbmFs
IGJlaGF2aW91ciB1c2luZyBsb29wX2luZm8ubG9fbmFtZQoKU2lnbmVkLW9mZi1ieTogRmFqYXIg
QS4gTnVncmFoYSA8Z2l0aHViQGZhamFyLm5ldD4KLS0tCiB1dGlscy5jIHwgICAxOCArKysrKysr
KysrKysrKysrKy0KIDEgZmlsZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS91dGlscy5jIGIvdXRpbHMuYwppbmRleCAxNzhkMWI5Li5hNjJl
ZWVlIDEwMDY0NAotLS0gYS91dGlscy5jCisrKyBiL3V0aWxzLmMKQEAgLTY0OSw2ICs2NDksOSBA
QCBpbnQgcmVzb2x2ZV9sb29wX2RldmljZShjb25zdCBjaGFyKiBsb29wX2RldiwgY2hhciogbG9v
cF9maWxlLCBpbnQgbWF4X2xlbikKIHsKIAlpbnQgbG9vcF9mZDsKIAlpbnQgcmV0X2lvY3RsOwor
CWludCBzeXNmc19mZDsKKwljaGFyIHN5c2ZzX3BhdGhbUEFUSF9NQVhdOworCWNvbnN0IGNoYXIq
IHN5c2ZzX3BhdGhfZm9ybWF0ID0gIi9zeXMvYmxvY2svbG9vcCVkL2xvb3AvYmFja2luZ19maWxl
IjsKIAlzdHJ1Y3QgbG9vcF9pbmZvIGxvb3BpbmZvOwogCiAJaWYgKChsb29wX2ZkID0gb3Blbihs
b29wX2RldiwgT19SRE9OTFkpKSA8IDApCkBAIC02NTgsNyArNjYxLDIwIEBAIGludCByZXNvbHZl
X2xvb3BfZGV2aWNlKGNvbnN0IGNoYXIqIGxvb3BfZGV2LCBjaGFyKiBsb29wX2ZpbGUsIGludCBt
YXhfbGVuKQogCWNsb3NlKGxvb3BfZmQpOwogCiAJaWYgKHJldF9pb2N0bCA9PSAwKQotCQlzdHJu
Y3B5KGxvb3BfZmlsZSwgbG9vcGluZm8ubG9fbmFtZSwgbWF4X2xlbik7CisJeworCQlzbnByaW50
ZihzeXNmc19wYXRoLCBQQVRIX01BWCwgc3lzZnNfcGF0aF9mb3JtYXQsIGxvb3BpbmZvLmxvX251
bWJlcik7CisJCXN5c2ZzX2ZkID0gb3BlbihzeXNmc19wYXRoLCBPX1JET05MWSk7CisJCWlmIChz
eXNmc19mZCA8IDApCisJCXsKKwkJCXN0cm5jcHkobG9vcF9maWxlLCBsb29waW5mby5sb19uYW1l
LCBtYXhfbGVuKTsKKwkJfQorCQllbHNlCisJCXsKKwkJCXJlYWQoc3lzZnNfZmQsIGxvb3BfZmls
ZSwgbWF4X2xlbik7CisJCQlsb29wX2ZpbGVbc3RybGVuKGxvb3BfZmlsZSktMV0gPSAnXDAnOwor
CQkJY2xvc2Uoc3lzZnNfZmQpOworCQl9CisJfQogCWVsc2UKIAkJcmV0dXJuIC1lcnJubzsKIAot
LSAKMS43LjkKCg==
--047d7b162db7ead49904b99c1099--
