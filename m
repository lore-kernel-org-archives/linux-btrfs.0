Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab3ICWTJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 18:19:09 -0400
Message-ID: <52266055.9050004@suse.com>
Date: Tue, 03 Sep 2013 18:19:01 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] xfstests: fix device lookup in btrfs/003
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The DEVHTL lookup in btrfs/003 is broken. It can only handle full LUNs and
not partitions on a disk.

Rather than returning 2:0:0:0 for /dev/sdc7, it returns 'block' and we see:
./common/rc: line 2081: /sys/class/scsi_device/block/device/delete:
No such file or directory

If we look up the device by dev instead of by name, we can handle working
with full disks and partitions more easily and get the ability to use
any device name rather than just the ones that match sysfs.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 tests/btrfs/003 |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -137,9 +137,21 @@ _test_replace()
 	#pick the 2nd last disk 
 	ds=${devs[@]:$(($n-1)):1}
 
-	# retrive the HTL for this scsi disk
-	d=`echo $ds|cut -d"/" -f3`
-	DEVHTL=`ls -l /sys/class/block/${d} | rev | cut -d "/" -f 3 | rev`
+	HEXMAJOR="$(stat -c "%t" "$ds")"
+	HEXMINOR="$(stat -c "%T" "$ds")"
+	if [ -z "$HEXMAJOR" -o -z "$HEXMINOR" ]; then
+		_fail "tr: HEXMAJOR and/or HEXMINOR is unset for $ds"
+	fi
+
+	DIR="/sys/dev/block/$(( 0x$HEXMAJOR )):$(( 0x$HEXMINOR ))"
+
+	if [ -L "$DIR/device" ]; then # whole disk
+		DEVHTL="$(basename $(readlink "$DIR/device"))"
+	elif [ -L "$DIR/../device" ]; then # partition
+		DEVHTL="$(basename $(readlink "$DIR/../device"))"
+	else
+		_fail "tr: Can't locate device backing $ds"
+	fi
 
 	#fail disk
 	_devmgt_remove ${DEVHTL}

--
Jeff Mahoney
SUSE Labs
