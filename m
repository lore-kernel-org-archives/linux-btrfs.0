Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 211F8C43143
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 08:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B23F120652
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 08:56:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jrskyZvG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B23F120652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbeJAPdO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 11:33:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44120 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728808AbeJAPdO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2018 11:33:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w918s3Rc128613
        for <linux-btrfs@vger.kernel.org>; Mon, 1 Oct 2018 08:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=P4uRh/6s4Y2ZXi7LrGKTTQPJfu+gp3dGXbDChpRxKZI=;
 b=jrskyZvGFnEHkzJ0b65LmPZXoObVhx0vKtpZRjL1o2k5E+wTBqKDWdqadcFEo8DNbmia
 FPg18QI14DtIetLmnGwqh/yuJH25ydxgyx4eghShhq9IC068qtLt5yJfrqYK+mDlRx6b
 OYbYMh3uIB+1HLsSBPXWzWLW6fcLrpQ32hiWYHAjejCElTiDlWu3eMPQ0OvTzdwiXtUS
 0CzLf3+osFws+v3u5u1l+ydVoVxAh3Z1Zv2l3NM6Waex1aUNw+e0xwnRJo5EiMnFF8ii
 hL59+8i53X+aPzHcEfuWqsIEBWpfo7v/P1wpvyFIbi0k56ehy5TnUxagb8arO6evxsxT /A== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mt1bpnpfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Oct 2018 08:56:31 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w918uVWP019000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 1 Oct 2018 08:56:31 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w918uUmk019048
        for <linux-btrfs@vger.kernel.org>; Mon, 1 Oct 2018 08:56:30 GMT
Received: from tpasj.sg.oracle.com (/10.186.53.176)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Oct 2018 01:56:30 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs: harden agaist duplicate fsid
Date:   Mon,  1 Oct 2018 16:56:04 +0800
Message-Id: <1538384164-3030-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9032 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810010091
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Its not that impossible to imagine that a device OR a btrfs image is
been copied just by using the dd or the cp command. Which in case both
the copies of the btrfs will have the same fsid. If on the system with
automount enabled, the copied FS gets scanned.

We have a known bug in btrfs, that we let the device path be changed
after the device has been mounted. So using this loop hole the new
copied device would appears as if its mounted immediately after its
been copied.

For example:

Initially.. /dev/mmcblk0p4 is mounted as /

lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
mmcblk0     179:0    0 29.2G  0 disk
|-mmcblk0p4 179:4    0    4G  0 part /
|-mmcblk0p2 179:2    0  500M  0 part /boot
|-mmcblk0p3 179:3    0  256M  0 part [SWAP]
`-mmcblk0p1 179:1    0  256M  0 part /boot/efi

btrfs fi show
   Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
   Total devices 1 FS bytes used 1.40GiB
   devid    1 size 4.00GiB used 3.00GiB path /dev/mmcblk0p4

Copy mmcblk0 to sda
   dd if=/dev/mmcblk0 of=/dev/sda

And immediately after the copy completes the change in the device
superblock is notified which the automount scans using
btrfs device scan and the new device sda becomes the mounted root
device.

lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda           8:0    1 14.9G  0 disk
|-sda4        8:4    1    4G  0 part /
|-sda2        8:2    1  500M  0 part
|-sda3        8:3    1  256M  0 part
`-sda1        8:1    1  256M  0 part
mmcblk0     179:0    0 29.2G  0 disk
|-mmcblk0p4 179:4    0    4G  0 part
|-mmcblk0p2 179:2    0  500M  0 part /boot
|-mmcblk0p3 179:3    0  256M  0 part [SWAP]
`-mmcblk0p1 179:1    0  256M  0 part /boot/efi

btrfs fi show /
 Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
 Total devices 1 FS bytes used 1.40GiB
 devid    1 size 4.00GiB used 3.00GiB path /dev/sda4

The bug is quite nasty that you can't either unmount /dev/sda4 or
/dev/mmcblk0p4. And the problem does not get solved until you take
sda out of the system on to another system to change its fsid
using the 'btrfstune -u' command.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---

Hi,

There was previous attempt to fix this bug ref: 
   www.spinics.net/lists/linux-btrfs/msg37466.html

which broke the Ubuntu subvol mount at boot. The reason
for that is, Ubuntu changes the device path in the boot
process, and the earlier fix checked for the device-path
instead of block_device as in here and so we failed the
subvol mount request and thus the bootup process.

I have tested this with Oracle Linux with btrfs as boot device
with a subvol to be mounted at boot. And also have verified
with new test case btrfs/173.

It will be good if someone run this through Ubuntu boot test case.

 fs/btrfs/volumes.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f4405e430da6..62173a3abcc4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -850,6 +850,29 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 			return ERR_PTR(-EEXIST);
 		}
 
+		/*
+		 * we are going to replace the device path, make sure its the
+		 * same device if the device mounted
+		 */
+		if (device->bdev) {
+			struct block_device *path_bdev;
+
+			path_bdev = lookup_bdev(path);
+			if (IS_ERR(path_bdev)) {
+				mutex_unlock(&fs_devices->device_list_mutex);
+				return ERR_CAST(path_bdev);
+			}
+
+			if (device->bdev != path_bdev) {
+				bdput(path_bdev);
+				mutex_unlock(&fs_devices->device_list_mutex);
+				return ERR_PTR(-EEXIST);
+			}
+			bdput(path_bdev);
+			pr_info("BTRFS: device fsid:devid %pU:%llu old path:%s new path:%s\n",
+				disk_super->fsid, devid, rcu_str_deref(device->name), path);
+		}
+
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name) {
 			mutex_unlock(&fs_devices->device_list_mutex);
-- 
1.8.3.1

