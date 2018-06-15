Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936278AbeFOU7j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Jun 2018 16:59:39 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: linux-btrfs@vger.kernel.org
Cc: snitzer@redhat.com, hare@suse.de, axboe@kernel.dk, mwilck@suse.com,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: [PATCH] btrfs-progs: detect zoned disks and prevent their raw use
Date: Fri, 15 Jun 2018 13:59:37 -0700
Message-Id: <20180615205937.8192-1-mcgrof@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using raw zoned disks by filesystems requires special handling, only
f2fs currently supports this. All other filesystems do not support
dealing with zoned disks directly.

As such using raw zoned disks is not supported by btrfs-progs, to use them you
need to use dm-zoned-tools, format them with dzadm, set the scheduler to
deadline, and then setup a dmsetup with zoned type, and somehow set
this up on every boot to live a semi-happy life for now.

Even if you use dmsetup on every boot, the zoned disk is still exposed,
and a user may still think they have to run mkfs.btrfs on it instead
of the /dev/mapper/ disk, and then mount it by mistake.

In either case you may seem to believe your disk works and only eventually
end up with alignmet issues and perhaps lose you data. For instance the
below was observed with XFS but its expected btrfs users would see
the same:

[10869.959501] device-mapper: zoned reclaim: (sda): Align zone 865 wp 28349 to 30842 (wp+2493) blocks failed -5
[10870.014488] sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[10870.016137] sd 0:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[10870.017696] sd 0:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command

We have to prevent these mistakes by avoiding mkfs use on zoned disks.

Note that this not enough yet, if users are on old AHCI controllers,
the disks may not be detected as zoned. More work through udev may be
required to detect this situation old old parent PCI IDs for zoned
disks, and then prevent their use somehow.

If you are stuck on using btrfs there is a udev rule out there [0], this is
far from perfect, and not fully what we want done upstream on Linux
distributions long term but it should at least help developers for now
enjoy their shiny big fat zoned disks with btrfs.

This check should help avoid having folks shoot themselves in the foot
for now with zoned disks. If you make the mistake to use btrfs
on a zoned disk, you will now get:

 # mkfs.btrfs -f /dev/sda
btrfs-progs v4.17
See http://btrfs.wiki.kernel.org for more information.

ERROR: /dev/sda: zoned disk detected, refer to dm-zoned-tools for how to use with btrfs

[0] https://lkml.kernel.org/r/20180614001147.1545-1-mcgrof@kernel.org

Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/main.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index b76462a7..165e6a38 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -481,6 +481,30 @@ static int is_ssd(const char *file)
 	return rotational == '0';
 }
 
+static int is_zoned_disk(char *file)
+{
+	char str[PATH_MAX];
+	char *devname = basename(file);
+	FILE *f;
+	int len;
+
+	len = snprintf(str, sizeof(str), "/sys/block/%s/queue/zoned", devname);
+
+	/* Indicates truncation */
+	if (len >= PATH_MAX) {
+		errno = ENAMETOOLONG;
+		return -1;
+	}
+
+	f = fopen(str, "r");
+	if (!f)
+		return 0;
+
+	fclose(f);
+
+	return 1;
+}
+
 static int _cmp_device_by_id(void *priv, struct list_head *a,
 			     struct list_head *b)
 {
@@ -912,6 +936,19 @@ int main(int argc, char **argv)
 	file = argv[optind++];
 	ssd = is_ssd(file);
 
+	ret = is_zoned_disk(file);
+
+	if (ret < 0) {
+		error("%s: error opening %s\n", file, strerror(errno));
+		goto error;
+	}
+
+	if (ret == 1) {
+		error("%s: zoned disk detected, refer to dm-zoned-tools for "
+		      "how to use with btrfs\n", file);
+		goto error;
+	}
+
 	/*
 	* Set default profiles according to number of added devices.
 	* For mixed groups defaults are single/single.
-- 
2.17.1

