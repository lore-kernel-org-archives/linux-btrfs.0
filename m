Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48494 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3AECvY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jan 2013 21:51:24 -0500
Message-ID: <50E7945A.4000108@oracle.com>
Date: Sat, 05 Jan 2013 10:47:54 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com, miaox@cn.fujitsu.com,
        Goffredo Baroncelli <kreijack@dgmail.com>, dsterba@suse.cz
Subject: [RFC PATCH v9 0/2] Btrfs: get/set label for a mounted file system
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

There have a couple of changes in this version which were shown as following:

- Don't reserve an unit of transactions for set filesystem label.

- Replace the old warning message to "btrfs: label is too long, return the first %zu bytes"
  in btrfs_ioc_get_fslabel() is the existing label length is longer than than
  BTRFS_LABEL_SIZE - 1. Otherwise, checkpatch.pl would give a warning as:
  "WARNING: quoted string split across lines".

- btrfs_ioc_set_fslabel(): drop an error message if the input label length is too long for
  debugging purpose.


The old versions can be found at:
v8:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/21906

v7:
http://www.spinics.net/lists/linux-btrfs/msg20994.html

v6:
http://www.spinics.net/lists/linux-btrfs/msg20922.html

v5:
http://www.spinics.net/lists/linux-btrfs/msg20888.html

v4:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/21618

v3:
https://patchwork.kernel.org/patch/1124642/

v2:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/12877

v1:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/12872

Thanks,
-Jeff
